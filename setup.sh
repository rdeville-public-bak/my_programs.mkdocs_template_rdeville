#!/usr/bin/env bash
# """Simply setup documentation configuration for the current folder.
#
# SYNOPSIS:
#   `./setup.sh [-u|--upgrade] [-s|--subrepo] [-h|--help] -r|--repo-url REPO_URL`
#
# DESCRIPTION:
#   This script will install/upgrade set of scripts and files to create and
#   manage documentation rendered using mkdocs.
#
#   If directory is already using mkdocs and user does not provide
#   `-u|--upgrade` options, an error will be shown and nothing will be done.
#
#   If user does not provide REPO_URL from which download the template, i.e.
#   using option `-r|--repo-url REPO_URL`, then an error will be prompt and
#   the script will exit.
#
# OPTIONS:
#   Available options are:
#
#     * `-u,--upgrade`  : Upgrade the current mkdocs documentation to the latest
#                         template version.
#
#     * `-s,--subrepo`  : Specify the current repo is a subrepo that will be
#                         merge into another main project using mkdocs-monorepo
#                         plugin.
#
#     * `-r,--repo-url` : URL of the repo from which the template will be
#                         downloaded.
#
#     * `-h,--help`     : Print this help.
#
# """

# Set constant variables
UPGRADE="false"
SUBREPO="false"

MKDOCS_ROOT="${PWD}"
MKDOCS_TMP="${MKDOCS_ROOT}/.tmp"
MKDOCS_CLONE_ROOT="${MKDOCS_TMP}/mkdocs_template"
MKDOCS_DEBUG_LEVEL="DEBUG"

USER_POST_SETUP="false"

SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 || return 1 ; pwd -P )"
SCRIPT_FULL_PATH="${SCRIPT_PATH}/$(basename "${BASH_SOURCE[0]}")"

main()
{
  # """Setup folder to be able to use mkdocs documentation templates.
  #
  # Check if `git` is installed. Then check that folder is not already using
  # mkdocs documentation.
  #
  # If directory already set to use mkdocs documentation, then check if user
  # explicitly tell to upgrade and upgrade, otherwise, print a warning and exit.
  #
  # If directory not already set to use mkdocs documentation, clone user
  # provided repo to a temporary folder, copy relevant scripts, files and
  # folders to initiliaze a documentation rendered using mkdocs.
  #
  # Globals:
  #   UPGRADE
  #   SUBREPO
  #   REPO_URL
  #   MKDOCS_ROOT
  #   MKDOCS_TMP
  #   MKDOCS_CLONE_ROOT
  #   SCRIPT_FULL_PATH
  #
  # Arguments:
  #   -u,--upgrade           : Arguments to explicitly upgrade the documentation
  #   -s,--subrepo           : Specify the current repo is a subrepo that will be merge into another main project using mkdocs-monorepo plugin.
  #   -r,--repo-url REPO_URL : Arguments with the URL of the repo holding the template to setup/upgrade
  #
  # Output:
  #   Log informations
  #
  # Returns:
  #   0 if directory is correctly configure to start writing documentation
  #   1 if something when wrong during the setup of documentation
  #
  # """

  manpage()
  {
    # """Extract the script documentation from header and print it on stdout.
    #
    # Simply extract the docstring from the header of the script, format it with
    # some output enhancement (such as bold), print it to stdout and exit.
    #
    # Globals:
    #   SCRIPT_FULL_PATH
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Help manpage from header docstring on stdout
    #
    # Returns:
    #   0, always
    #
    # """

    local e_normal="\\\e[0m"     # Normal (usually white fg & transparent bg)
    local e_bold="\\\e[1m"       # Bold
    # Extract module documentation and format it
    help_content="$(\
      sed -n -e "/^# \"\"\".*/,/^# \"\"\"/"p "${SCRIPT_FULL_PATH}" \
        | sed -e "s/^# \"\"\"//g" \
              -e "s/^# //g" \
              -e "s/^#$//g" \
              -e "s/DESCRIPTION[:]/${e_bold}DESCRIPTION${e_normal}\n/g" \
              -e "s/COMMANDS[:]/${e_bold}COMMANDS${e_normal}\n/g" \
              -e "s/OPTIONS[:]/${e_bold}OPTIONS${e_normal}\n/g" \
              -e "s/SYNOPSIS[:]/${e_bold}SYNOPSIS${e_normal}\n/g")"
    echo -e "${help_content}"
    exit 0
  }

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

  check_git()
  {
    # """Ensure command `git` exists.
    #
    # Simply ensure the command `git` exists.
    #
    # Globals:
    #   None
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Error message if commang `git` does not exists
    #
    # Returns:
    #   0 if `git` command exists
    #   1 if `git` command does not exist
    #
    # """

    if ! command -v git > /dev/null 2>&1
    then
      mkdocs_log "ERROR" "**git** must be installed."
      mkdocs_log "ERROR" "Please install **git** first."
      return 1
    fi
  }

  clone_mkdocs_template_repo()
  {
    # """Clone repo mkdocs_template to a temporary folder.
    #
    # Clone the repo mkdocs_template to a temporary folder using provided URL.
    #
    # Globals:
    #   REPO_URL
    #   MKDOCS_ROOT
    #   MKDOCS_CLONE_ROOT
    #   MKDOCS_TMP
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Log messages
    #
    # Returns:
    #   0 if clone of repo went right
    #   1 if clone of repo went wrong
    #
    # """

    if [[ -z "${REPO_URL}" ]]
    then
      mkdocs_log "ERROR" "You did not provide URL of the repo to clone"
      mkdocs_log "ERROR" "To provide URL of the repo to clone, use option --repo-url|-r."
      mkdocs_log "ERROR" "If you are using curl, use the following command
          \`\`\`
          curl -sfL \\
            https://domain.tld/namespace/mkdocs_template/-/raw/master/setup.sh \\
            | bash -s -- --repo-url https://git.domain.tld/namespace/repo
          \`\`\`
      "
      return 1
    fi

    # - SC2295: Expansions inside ${..} need to be quoted separately,
    #           otherwise the match as pattern
    # shellcheck disable=SC2295
    mkdocs_log "INFO" "Cloning mkdocs_template repo to **${MKDOCS_TMP##*${MKDOCS_ROOT}\/}/mkdocs_template**."
    mkdir -p "${MKDOCS_TMP}"

    git clone "${REPO_URL}" "${MKDOCS_CLONE_ROOT}" || return 1
  }

  check_upgrade()
  {
    # """Check if user specify to upgrade mkdocs documentation.
    #
    # Check if user specify to upgrade mkdocs documentation from the
    # mkdocs_template provided as repo URL. This is done by the use of option
    # `-u|--upgrade`.
    #
    # If user did not explicitly specify to upgrade, print a warning else,
    # upgrade mkdocs documentation files.
    #
    # Globals:
    #   UPGRADE
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Warning messages.
    #
    # Returns:
    #   0 if upgrade went right.
    #   1 if user did not specify to upgrade or if upgrade went wrong.
    #
    # """

    # If folder seems to already be set to use direnv but user did not specify
    # to upgrade
    if [[ "${UPGRADE}" == "false" ]]
    then
      mkdocs_log "WARNING" "This folder seems to already be set to build a mkdocs documentation."
      mkdocs_log "WARNING" "Continuing might result in the loss of your configuration."
      mkdocs_log "WARNING" "If you want to upgrade your configuration use the option \`--upgrade|-u\`."
      mkdocs_log "WARNING" "Or if you used curl:
        \`\`\`
          curl -sfL \\
            https://domain.tld/namespace/mkdocs_template/-/raw/master/setup.sh \\
            | bash -s -- --upgrade
        \`\`\`"
      return 1
    # If folder seems to already be set to use direnv and user not specify to
    # upgrade
    elif [[ "${UPGRADE}" == "true" ]]
    then
      # Clone last version of mkdocs_template to .tmp folder
      if ! clone_mkdocs_template_repo
      then
        mkdocs_log "WARNING" "An error occurs when trying to get the last version of mkdocs_tempalte."
        return 1
      fi
      setup_mkdocs
    fi
  }

  upgrade_mkdocs_config_file()
  {
    # """Handle the upgrade of mkdocs.yml file.
    #
    # Depending on the type of documentation, i.e. `SUBREPO` set to `true` or
    # `false`.
    #
    # If `SUBREPO` set to `true`, this will update `mkdocs.local.yml` else
    # will update `mkdocs.yml` if needed.
    #
    # Globals:
    #   MKDOCS_ROOT
    #   MKDOCS_TMP
    #   SUBREPO
    #
    # Arguments:
    #   $1 : string, absolute path to the latest file version to be installed
    #   $2 : string, absolute path to the location of the installation
    #
    # Output:
    #   Log message
    #
    # Returns:
    #   None
    #
    # """
    local file_from=$1
    local file_to=$2
    # - SC2295: Expansions inside ${..} need to be quoted separately,
    #           otherwise the match as pattern
    # shellcheck disable=SC2295
    local relative_file_to="${file_to##*${MKDOCS_ROOT}\/}"
    local tmp_file_from="${MKDOCS_TMP}/new_mkdocs.yml"
    local tmp_file_to="${MKDOCS_TMP}/old_mkdocs.yml"
    local bak_file=${file_to//${MKDOCS_ROOT}/${MKDOCS_ROOT}\/.old}
    local begin="### BEGIN MKDOCS TEMPLATE ###"
    local end="### END MKDOCS TEMPLATE ###"
    local bak_dir

    bak_file=${bak_file}.$(date "+%Y-%m-%d-%H-%M")
    bak_dir=$(dirname "${bak_file}")

    if [[ "${SUBREPO}" == "false" ]]
    then
      file_to=${file_to//mkdocs.local.yml/mkdocs.yml}
      # - SC2295: Expansions inside ${..} need to be quoted separately,
      #           otherwise the match as pattern
      # shellcheck disable=SC2295
      relative_file_to="${file_to##*${MKDOCS_ROOT}\/}"
      bak_file=${file_to//${MKDOCS_ROOT}/${MKDOCS_ROOT}\/.old}.$(date "+%Y-%m-%d-%H-%M")
    fi

    sed -n -e "/${begin}/,/${end}/"p "${file_from}" > "${tmp_file_from}"
    sed -n -e "/${begin}/,/${end}/"p "${file_to}" > "${tmp_file_to}"

    if [[ "$(sha1sum "${tmp_file_from}" | cut -d " " -f 1 )" \
       != "$(sha1sum "${tmp_file_to}"   | cut -d " " -f 1 )" ]]
    then
      # - SC2295: Expansions inside ${..} need to be quoted separately,
      #           otherwise the match as pattern
      # shellcheck disable=SC2295
      mkdocs_log "INFO" "Backup file **${relative_file_to}** to **${bak_file##*${MKDOCS_ROOT}\/}**."
      if ! [[ -d "${bak_dir}" ]]
      then
        mkdir -p "${bak_dir}"
      fi
      cp "${file_to}" "${bak_file}"

      content=$(grep -B 10000 "${begin}" "${file_to}" | sed -e "s/${begin}//g")
      content+=$(sed -n -e "/${begin}/,/${end}/"p  "${file_from}")
      content+=$(grep -A 10000 "${end}" "${file_to}" | sed -e "s/${end}//g")
      mkdocs_log "INFO" "Upgrading file **${relative_file_to}**."
      echo "${content}" > "${file_to}"
    fi
  }

  setup_mkdocs_config_file()
  {
    # """Handle the configuration of mkdocs.yml file.
    #
    # Depending on the type of documentation, i.e. `SUBREPO` set to `true` or
    # `false`.
    #
    # In the first case, `SUBREPO` set to `true`, will generate a basic
    # `mkdocs.yml` to be included with mkdocs monorepo plugins and put the full
    # configuration to `mkdocs.local.yml`.
    # Else, `SUBREPO` set to `false`, write directly the full configuration to
    # `mkdocs.yml`.
    #
    # Globals:
    #   MKDOCS_ROOT
    #   SUBREPO
    #
    # Arguments:
    #   $1 : string, absolute path to the latest file version to be installed
    #   $2 : string, absolute path to the location of the installation
    #
    # Output:
    #   Log message
    #
    # Returns:
    #   None
    #
    # """

    local file_from=$1
    local file_to=$2
    # - SC2295: Expansions inside ${..} need to be quoted separately,
    #           otherwise the match as pattern
    # shellcheck disable=SC2295
    local relative_file_to="${file_to##*${MKDOCS_ROOT}\/}"

    if [[ "${SUBREPO}" == "false" ]]
    then
      file_to=${file_to//mkdocs.local.yml/mkdocs.yml}
    else
      if ! [[ -e ${file_to//mkdocs.local.yml/mkdocs.yml} ]]
      then
        mkdocs_log "INFO" "Creation of **${relative_file_to//mkdocs.local.yml/mkdocs.yml}**."
        cat <<EOM > "${file_to//mkdocs.local.yml/mkdocs.yml}"
# Website Information
# ---------------------------------------------------------------------------
# If this documentation is a subdocumentation and will be used by monorepo.
# DO NOT FORGET TO UPDATE BELOW VALUE.
site_name: "{{ repo_name.path_slug_with_namespace }}"

# DO NOT FORGET TO ADD THE \`nav\` KEY BELOW.
EOM
      fi
    fi

    mkdocs_log "INFO" "Creation of **${relative_file_to}**."
    cp "${file_from}" "${file_to}"
  }

  upgrade_file()
  {
    # """Upgrade latest version of script and files from mkdocs_template.
    #
    # Check if latest version of file is different from the old version. If
    # yes, then move the old version to `${MKDOCS_ROOT}/.old` then upgrade to
    # latest version.
    #
    # Globals:
    #   MKDOCS_ROOT
    #   MKDOCS_TMP
    #
    # Arguments:
    #   $1 : string, absolute path to the latest file version to be installed
    #   $2 : string, absolute path to the location of the installation
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
    # - SC2295: Expansions inside ${..} need to be quoted separately,
    #           otherwise the match as pattern
    # shellcheck disable=SC2295
    local relative_file_to="${file_to##*${MKDOCS_ROOT}\/}"
    local tmp_file_from="${MKDOCS_TMP}/${relative_file_to}.new"
    local tmp_file_to="${MKDOCS_TMP}/${relative_file_to}.old"
    local bak_file=${file_to//${MKDOCS_ROOT}/${MKDOCS_ROOT}\/.old}
    local begin=""
    local end=""
    local begin_tag="BEGIN MKDOCS TEMPLATE"
    local end_tag="END MKDOCS TEMPLATE"
    local prefix=""
    local suffix=""
    local content=""
    local bak_dir

    bak_file=${bak_file}.$(date "+%Y-%m-%d-%H-%M")
    bak_dir=$(dirname "${bak_file}")

    if [[ "${relative_file_to}" =~ ^mkdocs.*yml$ ]]
    then
      upgrade_mkdocs_config_file "${file_from}" "${file_to}"
    elif ! [[ -f "${file_to}" ]]
    then
      mkdocs_log "INFO" "Installing file **${relative_file_to}**."
      cp "${file_from}" "${file_to}"
    else
      case "${file_to}" in
        *.md|*.html|*LICENSE)
            prefix="<!--"
            suffix="-->"
          ;;
        *.css|*.js)
            prefix="/*"
            suffix="*/"
          ;;
        *.yaml|*.yml|*.gitignore|*.toml|*.in|*.txt)
            prefix="###"
            suffix="###"
          ;;
      esac
      begin="${prefix} ${begin_tag} ${suffix}"
      end="${prefix} ${end_tag} ${suffix}"
      warning="\
${prefix} WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !${suffix}
${prefix} Modified content will be overwritten when updating.${suffix}"

      for i_file in "${tmp_file_from}" "${tmp_file_to}"
      do
        if ! [[ -d $(dirname "${i_file}") ]]
        then
          mkdir -p "$(dirname "${i_file}")"
        fi
      done

      if [[ -n "${prefix}" ]]
      then
        if ! grep "${begin}" "${file_from}" &>/dev/null
        then
          content="\
${begin}
${warning}
$(cat "${file_from}")
${end}"
          echo "${content}" > "${tmp_file_from}"
        else
          sed -n -e "/${begin_tag}/,/${end_tag}/"p "${file_from}" > "${tmp_file_from}"
        fi
        sed -n -e "/${begin_tag}/,/${end_tag}/"p "${file_to}" > "${tmp_file_to}"

        if [[ "$(sha1sum "${tmp_file_from}" | cut -d " " -f 1 )" \
           != "$(sha1sum "${tmp_file_to}"   | cut -d " " -f 1 )" ]]
        then
          # - SC2295: Expansions inside ${..} need to be quoted separately,
          #           otherwise the match as pattern
          # shellcheck disable=SC2295
          mkdocs_log "INFO" "Backup file **${relative_file_to}** to **${bak_file##*${MKDOCS_ROOT}\/}**."
          if ! [[ -d "${bak_dir}" ]]
          then
            mkdir -p "${bak_dir}"
          fi
          cp "${file_to}" "${bak_file}"

          mkdocs_log "INFO" "Upgrading file **${relative_file_to}**."
          grep -B 1000000 "${begin}" "${file_to}" | sed -e "s/${begin}//g" > "${tmp_file_to}"
          cat "${tmp_file_from}" >> "${tmp_file_to}"
          grep -A 1000000 "${end}" "${file_to}" | sed -e "s/${end}//g" >> "${tmp_file_to}"
          cat "${tmp_file_to}" > "${file_to}"
        fi
      elif [[ "$(sha1sum "${file_from}" | cut -d " " -f 1 )" \
           != "$(sha1sum "${file_to}"   | cut -d " " -f 1 )" ]]
      then
        # - SC2295: Expansions inside ${..} need to be quoted separately,
        #           otherwise the match as pattern
        # shellcheck disable=SC2295
        mkdocs_log "INFO" "Backup file **${relative_file_to}** to **${bak_file##*${MKDOCS_ROOT}\/}**."
        if ! [[ -d "${bak_dir}" ]]
        then
          mkdir -p "${bak_dir}"
        fi
        cp "${file_to}" "${bak_file}"
        mkdocs_log "INFO" "Upgrading file **${relative_file_to}**."
        cp "${file_from}" "${file_to}"
      fi
    fi
  }

  setup_file()
  {
    # """Install latest version of script and files from mkdocs_template.
    #
    # Simply install file provided as argument from the mkdocs_template
    # temporary repo to the right place in the folder currently setup to use
    # mkdocs documentation.
    #
    # Globals:
    #   MKDOCS_ROOT
    #
    # Arguments:
    #   $1 : string, absolute path to the latest file version to be installed
    #   $2 : string, absolute path to the location of the installation
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
    # - SC2295: Expansions inside ${..} need to be quoted separately,
    #           otherwise the match as pattern
    # shellcheck disable=SC2295
    local relative_file_to="${file_to##*${MKDOCS_ROOT}\/}"
    local begin=""
    local end=""
    local begin_tag="BEGIN MKDOCS TEMPLATE"
    local end_tag="END MKDOCS TEMPLATE"
    local warning=""
    local prefix=""
    local suffix=""

    if [[ "${relative_file_to}" =~ ^mkdocs.*yml$ ]]
    then
      setup_mkdocs_config_file "${file_from}" "${file_to}"
    else
      case "${file_to}" in
        *.md|*.html|*LICENSE)
            prefix="<!--"
            suffix="-->"
          ;;
        *.css|*.js)
            prefix="/*"
            suffix="*/"
          ;;
        *.yaml|*.yml|*.gitignore|*.toml|*.in|*.txt)
            prefix="###"
            suffix="###"
          ;;
      esac
      begin="${prefix} ${begin_tag} ${suffix}"
      end="${prefix} ${end_tag} ${suffix}"
      warning="\
${prefix} WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !${suffix}
${prefix} Modified content will be overwritten when updating.${suffix}"
      if [[ -n "${prefix}" ]] && ! grep "${begin}" "${file_from}" &>/dev/null
      then
          content="\
${begin}
${warning}
$(cat "${file_from}")
${end}"
        echo "${content}" > "${file_to}"
      else
        cp "${file_from}" "${file_to}"
      fi
    fi
  }


  build_file_list()
  {
    # """Recursively build a list of file from provided folder
    #
    # Recursively build a list of file from provided folder and store such list
    # in a temporary bash array that must be set in parent method.
    #
    # Globals:
    #   None
    #
    # Arguments:
    #   $1 : string, absolute path to the folder which will be parsed
    #
    # Output:
    #   None
    #
    # Returns:
    #   None
    #
    # """

    local folder=$1
    for i_node in "$folder"/* "$folder"/.*
    do
      if ! [[ "${i_node}" =~ ^${folder}\/[\.]+$ ]] \
        && ! [[ "${i_node}" =~ __pycache__ ]]
      then
        if [[ -f "${i_node}" ]]
        then
          tmp_nodes+=("${i_node}")
        elif [[ -d "${i_node}" ]]
        then
          build_file_list "${i_node}"
        fi
      fi
    done
  }


  build_final_file_list()
  {
    # """Build the merged list from `templates` and `user_config` folder.
    #
    # If there is the same file in `user_config` and `templates` folder, then
    # replace the file to be installed from `templates` by the one in
    # `user_config`. Finally, add remaining `user_config` files not in
    # `templates` to the list of files to install or upgrade in a bash array set
    # in parent method.
    #
    # Globals:
    #   MKDOCS_ROOT
    #
    # Arguments:
    #   None
    #
    # Output:
    #   None
    #
    # Returns:
    #   None
    #
    # """

    for i_template_node in "${template_nodes[@]##*templates\/}"
    do
      found="false"
      for i_user_node in "${user_nodes[@]##*user_config\/}"
      do
        if [[ ${i_template_node} =~ ^${i_user_node}$ ]]
        then
          found="true"
        fi
      done
      if [[ "${found}" == "false" ]]
      then
        tmp_nodes+=("templates/${i_template_node}")
      fi
    done
    for i_user_node in "${user_nodes[@]##*user_config\/}"
    do
      tmp_nodes+=("user_config/${i_user_node}")
    done
    tmp_nodes=("${tmp_nodes[@]##*${MKDOCS_ROOT}\/}")
  }


  setup_mkdocs()
  {
    # """Recursively install base folder and script to write mkdocs documentation.
    #
    # Build the list of files and folders, recursively copy all files to
    # their right location from the temporary cloned repo to the folder which
    # will host the mkdocs documentation.
    #
    # Globals:
    #   MKDOCS_ROOT
    #   MKDOCS_CLONE_ROOT
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Log message
    #
    # Returns:
    #   None
    #
    # """

    local tmp_nodes=()
    local template_nodes=()
    local user_nodes=()
    local file_from
    local i_node
    local file_from
    local file_to
    local curr_dirname
    local last_dirname

    build_file_list "${MKDOCS_CLONE_ROOT}/templates"
    template_nodes=("${tmp_nodes[@]}")
    tmp_nodes=()
    build_file_list "${MKDOCS_CLONE_ROOT}/user_config"
    user_nodes=("${tmp_nodes[@]}")
    tmp_nodes=()

    build_final_file_list

    for i_node in "${tmp_nodes[@]}"
    do
      file_from="${MKDOCS_CLONE_ROOT}/${i_node}"
      file_to="${MKDOCS_ROOT}/${i_node//user_config\/}"
      file_to="${file_to//templates\/}"
      curr_dirname="$(dirname "${file_to}")"
      if ! [[ -d "${curr_dirname}" ]]
      then
          # - SC2295: Expansions inside ${..} need to be quoted separately,
          #           otherwise the match as pattern
          # shellcheck disable=SC2295
        mkdocs_log "INFO" "Create dir **${curr_dirname##*${MKDOCS_ROOT}\/}**."
        mkdir -p "${curr_dirname}"
      fi
      if [[ "${curr_dirname}" != "${last_dirname}" ]]
      then
        last_dirname=${curr_dirname}
        if [[ "${UPGRADE}" == "true" ]]
        then
          # - SC2295: Expansions inside ${..} need to be quoted separately,
          #           otherwise the match as pattern
          # shellcheck disable=SC2295
          mkdocs_log "INFO" "Check file to upgrade in **./${last_dirname##*${MKDOCS_ROOT}\/}**."
        else
          # - SC2295: Expansions inside ${..} need to be quoted separately,
          #           otherwise the match as pattern
          # shellcheck disable=SC2295
          mkdocs_log "INFO" "Installing files in **./${last_dirname##*${MKDOCS_ROOT}\/}**."
        fi
      fi
      if ! [[ "${file_to}" =~ \.gitkeep$ ]] \
        && [[ "${file_to}" != "${MKDOCS_ROOT}/README.md" ]] \
        && [[ "${file_to}" != "${MKDOCS_ROOT}/post_setup.sh" ]]
      then
        if [[ "${UPGRADE}" == "true" ]]
        then
          upgrade_file "${file_from}" "${file_to}"
        else
          setup_file "${file_from}" "${file_to}"
        fi
      elif [[ "${file_to}" == "README.md" ]] \
           && ! [[ "${tmp_nodes[*]}" =~ user_config\/post_setup\.sh ]]
      then
        # If user has a `README.md` in user_config but not `post_setup.sh` file
        if [[ "${UPGRADE}" == "true" ]]
        then
          upgrade_file "${file_from}" "${file_to}"
        else
          setup_file "${file_from}" "${file_to}"
        fi
      elif [[ "${file_to}" == "${MKDOCS_ROOT}/post_setup.sh" ]]
      then
        USER_POST_SETUP="true"
        USER_POST_SETUP_FILE_PATH="${file_from}"
      fi
    done
    if [[ "${USER_POST_SETUP}" == "true" ]]
    then
      # If user provide a post setup script, source it and execute
      # main_post_setup
      mkdocs_log "INFO" "Sourcing user post_setup.sh"
      # - SC1090: Can't follow non-constant source. Use a directive to specify location.
      # shellcheck disable=SC1090
      source "${USER_POST_SETUP_FILE_PATH}"
      mkdocs_log "INFO" "Executing main_post_setup"
      main_post_setup
    fi
  }

  # Set color prefix
  local e_normal="\e[0m"      # normal (white fg & transparent bg)
  local e_bold="\e[1m"        # bold
  local e_warning="\e[0;33m"  # yellow fg
  local e_error="\e[0;31m"    # red fg
  local e_info="\e[0;32m"     # green fg

  # Ensure git is installed
  check_git || return 1

  # Parse arguments
  while [[ $# -gt 0 ]]
  do
    case "$1" in
      --upgrade|-u)
        UPGRADE="true"
        shift
        ;;
      --subrepo|-s)
        SUBREPO="true"
        shift
        ;;
      --repo-url|-r)
        shift
        REPO_URL="$1"
        shift
        ;;
      --help|-h)
        manpage
        ;;
    esac
  done

  if [[ -f "${MKDOCS_ROOT}/mkdocs.yml" ]]
  then
    # Check if user specify want to upgrade
    check_upgrade || return 1
  else
    # Clone last version of mkdocs_template to .tmp folder
    if ! clone_mkdocs_template_repo
    then
      mkdocs_log "WARNING" "An error occurs when trying to get the last version of mkdocs_tempalte."
      return 1
    fi
    setup_mkdocs
  fi

  mkdocs_log "INFO" "Removing temporary cloned files"
  rm -rf "${MKDOCS_TMP}"
}

main "${@}"

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------