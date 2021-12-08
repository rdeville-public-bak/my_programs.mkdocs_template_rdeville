#!/usr/bin/env bash
# """Post setup script to handle the README.md file
#
# SYNOPSIS:
#   NOT TO BE USED ALONE, MUST BE SOURCED
#
# DESCRIPTION:
#   This script will define methods to  install/upgrade the file README.md base
#   on the git remote origin if its exists else, will ask the user to provide
#   information.
#
# """

# Set constant variables
BASE_ONLINE_DOC_URL="https://docs.romaindeville.fr/"
REPO_URL=""
REPO_NAME=""
REPO_NAME_FIRST_UPPERCASE=""
REPO_ONLINE_DOC_URL=""

main_post_setup()
{
  # """User defined post-setup config which handle update of `README.md`
  #
  # Main post-setup method which handle the management of `README.md` file from
  # `user_config` folder using git repo information. If current repo is not a
  # git repository without `origin` remote defined, print an error and exit.
  #
  # Globals:
  #   MKDOCS_ROOT
  #   MKDOCS_CLONE_ROOT
  #   UPGRADE
  #
  # Arguments:
  #   None
  #
  # Output:
  #   None
  #
  # Returns:
  #   0, If everything went right
  #   1, If something went wrong
  #
  # """

  #   - SC2034: var appears unused, Verify use (or export if used externally)
  # shellcheck disable=SC2034
  mkdocs_log()
  {
    # """Print debug message in colors depending on message severity on stderr.
    #
    # Echo colored log depending on user provided message severity. Message
    # severity are associated to following color output:
    #
    #   - `DEBUG` print in the fifth color of the terminal (usually magenta)
    #   - `INFO` print in the second color of the terminal (usually green)
    #   - `WARNING` print in the third color of the terminal (usually yellow)
    #   - `ERROR` print in the third color of the terminal (usually red)
    #
    # If no message severity is provided, severity will automatically be set to
    # INFO.
    #
    # Globals:
    #   ZSH_VERSION
    #   MKDOCS_DEBUG_LEVEL
    #
    # Arguments:
    #   $1 : string, message severity or message content
    #   $@ : string, message content
    #
    # Output:
    #   Colored log informations
    #
    # Returns:
    #   None
    #
    # """

    # Store color prefixes in variable to ease their use.
    # Base on only 8 colors to ensure portability of color when in tty
    local e_normal="\e[0m"     # Normal (usually white fg & transparent bg)
    local e_bold="\e[1m"       # Bold
    local e_underline="\e[4m"  # Underline
    local e_debug="\e[0;35m"   # Fifth term color (usually magenta fg)
    local e_info="\e[0;32m"    # Second term color (usually green fg)
    local e_warning="\e[0;33m" # Third term color (usually yellow fg)
    local e_error="\e[0;31m"   # First term color (usually red fg)

    # Store preformated colored prefix for log message
    local error="${e_bold}${e_error}[ERROR]${e_normal}${e_error}"
    local warning="${e_bold}${e_warning}[WARNING]${e_normal}${e_warning}"
    local info="${e_bold}${e_info}[INFO]${e_normal}${e_info}"
    local debug="${e_bold}${e_debug}[DEBUG]${e_normal}${e_debug}"

    local color_output="e_error"
    local msg_severity
    local msg

    # Not using ${1^^} to ensure portability when using ZSH
    msg_severity=$(echo "$1" | tr '[:upper:]' '[:lower:]')

    if [[ "${msg_severity}" =~ ^(error|time|warning|info|debug)$ ]]
    then
      # Shift arguments by one such that $@ start from the second arguments
      shift
      # Place the content of variable which name is defined by ${msg_severity}
      # For instance, if `msg_severity` is INFO, then `prefix` will have the same
      # value as variable `info`.
      prefix="${!msg_severity}"
      color_output="e_${msg_severity}"
    else
      prefix="${info}"
    fi

    color_output="${!color_output}"

    # Concat all remaining arguments in the message content and apply markdown
    # like syntax.
    msg_content=$(echo "$*" \
      | sed -e "s/ \*\*/ \\${e_bold}/g" \
            -e "s/\*\*\./\\${e_normal}\\${color_output}./g" \
            -e "s/\*\* /\\${e_normal}\\${color_output} /g" \
            -e "s/\*\*$/\\${e_normal}\\${color_output} /g" \
            -e "s/ \_\_/ \\${e_underline}/g" \
            -e "s/\_\_\./\\${e_normal}\\${color_output}./g" \
            -e "s/\_\_ /\\${e_normal}\\${color_output} /g")
    msg="${prefix} ${msg_content}${e_normal}"

    # Print message or not depending on message severity and MKDOCS_DEBUG_LEVEL
    if [[ -z "${MKDOCS_DEBUG_LEVEL}" ]] && [[ "${msg_severity}" == "error" ]]
    then
      echo -e "${msg}" 1>&2
    elif [[ -n "${MKDOCS_DEBUG_LEVEL}" ]]
    then
      case ${MKDOCS_DEBUG_LEVEL} in
        DEBUG)
          echo "${msg_severity}" \
            | grep -q -E "(debug|info|warning|error)" && echo -e "${msg}" 1>&2
          ;;
        INFO)
          echo "${msg_severity}" \
            | grep -q -E "(info|warning|error)" && echo -e "${msg}" 1>&2
          ;;
        WARNING)
          echo "${msg_severity}" \
            | grep -q -E "(warning|error)" && echo -e "${msg}" 1>&2
          ;;
        ERROR)
          echo "${msg_severity}" \
            | grep -q -E "error" && echo -e "${msg}" 1>&2
          ;;
      esac
    fi
  }

  extract_repo_info()
  {
    # """Extract repository from the origin remote
    #
    # Parse output of command `git remote -v | grep origin` to setup repo
    # information store in `REPO_*` variables
    #
    # Globals:
    #   REPO_URL
    #   REPO_NAME
    #   REPO_NAME_FIRST_UPPERCASE
    #   REPO_NAME_FIRST_UPPERCASE_ARRAY
    #   REPO_ONLINE_DOC_URL
    #
    # Arguments:
    #   None
    #
    # Output:
    #   None
    #
    # Returns:
    #   None
    # """

    local repo_remote
    local repo_domain

    repo_remote=$(git remote -v | \
                    grep origin | \
                    head -1 | \
                    sed -e "s/origin\t//g" -e "s/ *([a-z]*)//g")

    if [[ "${repo_remote}" =~ @ ]]
    then
      repo_remote=${repo_remote##*@}
      repo_domain="https://${repo_remote%%:*}/"
      repo_with_namespace="${repo_remote##*:}"
    else
      repo_domain=${repo_remote##https:\/\/}
      repo_domain="https://${repo_domain%%/*}/"
      repo_with_namespace="${repo_remote/${repo_domain}/}"
    fi
    REPO_URL="${repo_domain}${repo_with_namespace/.git/}"
    REPO_NAME="${repo_with_namespace##*/}"
    REPO_NAME="${REPO_NAME/.git/}"
    REPO_NAME_FIRST_UPPERCASE="${REPO_NAME/_/ }"
    REPO_NAME_FIRST_UPPERCASE="${REPO_NAME_FIRST_UPPERCASE/-/ }"
    # shellcheck disable=SC2206
    #   - SC2206: Quote to prevent word splitting/globbing
    REPO_NAME_FIRST_UPPERCASE_ARRAY=( ${REPO_NAME_FIRST_UPPERCASE} )
    # shellcheck disable=SC2178
    #   - SC2178: Variabel was used as an array but is now assigned a string
    REPO_NAME_FIRST_UPPERCASE="${REPO_NAME_FIRST_UPPERCASE_ARRAY[*]^}"
    REPO_ONLINE_DOC_URL="${BASE_ONLINE_DOC_URL}${repo_with_namespace/.git/}"
  }

  ensure_remote_origin()
  {
    # """Ensure remote `origin` exists and parse remote info
    #
    # Ensure current folder is a git folder with an `origin` remote defined. If
    # not, print an error else extract repository information from remote.
    #
    # Globals:
    #   None
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Error message if git remote `origin` does not exists
    #
    # Returns:
    #   0, if everything went right
    #   1, if remote `origin` does not exists or not in a git repository
    # """

    if ! git remote -v | grep origin &> /dev/null
    then
      mkdocs_log "WARNING" "Unable to fetch git remote **\`origin\`**!"
      mkdocs_log "WARNING" "Are you sure you are in a git repository with an origin remote defined ?"
      return 1
    else
      extract_repo_info
    fi
  }

  upgrade_readme()
  {
    # """Upgrade latest version of README.md
    #
    # Check if latest version of README.md is different from the old version. If
    # yes, then move the old version to ${MKDOCS_ROOT}/.old then upgrade to
    # latest version.
    #
    # Globals:
    #   MKDOCS_ROOT
    #   REPO_URL
    #   REPO_NAME
    #   REPO_NAME_FIRST_UPPERCASE
    #   REPO_NAME_FIRST_UPPERCASE_ARRAY
    #   REPO_ONLINE_DOC_URL
    #
    # Arguments:
    #   $1, string, absolute path to the latest file version to be installed
    #   $2, string, absolute path to the location of the installation
    #
    # Output:
    #   Log messages
    #
    # Returns:
    #   None
    #
    # """

    local file_from="$1"
    local file_to="$2"
    # - SC2295: Expansions inside ${..} need to be quoted separately, otherwise
    #           they match as patterns.
    # shellcheck disable=SC2295
    local relative_file_to="${file_to##*${MKDOCS_ROOT}\/}"
    local tmp_file_from="${MKDOCS_TMP}/${relative_file_to}.new"
    local tmp_file_to="${MKDOCS_TMP}/${relative_file_to}.old"
    local bak_file=${file_to//${MKDOCS_ROOT}/${MKDOCS_ROOT}\/.old}
    local begin="<\!-- BEGIN MKDOCS TEMPLATE -->"
    local end="<\!-- END MKDOCS TEMPLATE -->"
    local bak_dir

    bak_file=${bak_file}.$(date "+%Y-%m-%d-%H-%M")
    bak_dir=$(dirname "${bak_file}")

    sed -n -e "/${begin}/,/${end}/"p "${file_from}" > "${tmp_file_from}"
    sed -i \
      -e "s|<TPL:REPO_NAME>|${REPO_NAME}|g" \
      -e "s|<TPL:REPO_URL>|${REPO_URL}|g" \
      -e "s|<TPL:REPO_ONLINE_DOC_URL>|${REPO_ONLINE_DOC_URL}|g" \
      -e "s|<TPL:REPO_NAME_FIRST_UPPERCASE>|${REPO_NAME_FIRST_UPPERCASE}|g" \
      "${tmp_file_from}"

    sed -n -e "/${begin}/,/${end}/"p "${file_to}" > "${tmp_file_to}"

    if [[ "$(sha1sum "${tmp_file_from}" | cut -d " " -f 1 )" \
       != "$(sha1sum "${tmp_file_to}"   | cut -d " " -f 1 )" ]]
    then
      # - SC2295: Expansions inside ${..} need to be quoted separately, otherwise
      #           they match as patterns.
      # shellcheck disable=SC2295
      mkdocs_log "INFO" "Backup file **${relative_file_to}** to **${bak_file##*${MKDOCS_ROOT}\/}.**"
      if ! [[ -d "${bak_dir}" ]]
      then
        mkdir -p "${bak_dir}"
      fi
      cp "${file_to}" "${bak_file}"

      grep -B 1000000 "${begin}" "${file_to}" | sed -e "s/${begin}//g" > "${tmp_file_to}"
      cat "${tmp_file_from}" >> "${tmp_file_to}"
      grep -A 1000000 "${end}" "${file_to}" | sed -e "s/${end}//g" >> "${tmp_file_to}"
      cat "${tmp_file_to}" > "${file_to}"
    fi
  }

  setup_readme()
  {
    # """Install latest version of README.md from user_config folder
    #
    # Simply install README.md file replacing <TPL:XXX> with previously computed
    # value.
    #
    # Globals:
    #   MKDOCS_ROOT
    #   REPO_URL
    #   REPO_NAME
    #   REPO_NAME_FIRST_UPPERCASE
    #   REPO_NAME_FIRST_UPPERCASE_ARRAY
    #   REPO_ONLINE_DOC_URL
    #
    #
    # Arguments:
    #   $1, string, absolute path to the latest file version to be installed
    #   $2, string, absolute path to the location of the installation
    #
    # Output:
    #   Log messages
    #
    # Returns:
    #   None
    #
    # """

    local file_from="$1"
    local file_to="$2"
    # - SC2295: Expansions inside ${..} need to be quoted separately, otherwise
    #           they match as patterns.
    # shellcheck disable=SC2295
    local relative_file_to="${file_to##*${MKDOCS_ROOT}\/}"
    local begin="<!-- BEGIN MKDOCS TEMPLATE -->"
    local end="<!-- END MKDOCS TEMPLATE -->"

    mkdocs_log "INFO" "Installing file **${relative_file_to}**."
    content=""
    if ! grep "${begin}" "${file_from}" &> /dev/null
    then
      content+="\
${begin}
<!--
WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !
Modified content will be overwritten when updating
-->

$(cat "${file_from}")

${end}"
    else
      content="$(cat "${file_from}")"
    fi
    echo -e "${content}" | \
      sed -e "s|<TPL:REPO_NAME>|${REPO_NAME}|g" \
          -e "s|<TPL:REPO_URL>|${REPO_URL}|g" \
          -e "s|<TPL:REPO_ONLINE_DOC_URL>|${REPO_ONLINE_DOC_URL}|g" \
          -e "s|<TPL:REPO_NAME_FIRST_UPPERCASE>|${REPO_NAME_FIRST_UPPERCASE}|g" \
      > "${file_to}"
  }

  if ! ensure_remote_origin
  then
    return 1
  fi

  file_from="${MKDOCS_CLONE_ROOT}/user_config/README.md"
  file_to="${MKDOCS_ROOT}/README.md"
  if [[ "${UPGRADE}" == "true" ]]
  then
    upgrade_readme "${file_from}" "${file_to}"
  else
    setup_readme "${file_from}" "${file_to}"
  fi
}

# *****************************************************************************
# VIM MODELINE
# vim: fdm=indent:fdi=
# *****************************************************************************
