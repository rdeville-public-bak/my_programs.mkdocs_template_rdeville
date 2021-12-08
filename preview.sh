#!/usr/bin/env bash
# """Setup a temporary documentation folder to preview the rendering of the template
#
# SYNOPSIS:
#   `./preview.sh [-c|--clean] [-r|--very-clean]`
#
# DESCRIPTION:
#   This script will build the final list of folder that will be installed in
#   the folder that will host the documenation and render a preview of such
#   basic documentation based from template.
#
#   This will be done by creating symlinks from `templates` and `user_config`
#   folders into `preview` folder.
#
#   Available options are:
#
#     * `-c,--clean`      : Remove every existing symlinks before rendering the
#                           preview.
#
#     * `-r,--very-clean` : Remove every existing symlinks without rendering the
#                           preview.
#
#     * `-h,--help`       : Print this help.
#
# """

# Set constant variables
MKDOCS_ROOT="${PWD}"
MKDOCS_TMP="${MKDOCS_ROOT}/preview"
MKDOCS_DEBUG_LEVEL="DEBUG"

SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 || return 1 ; pwd -P )"
SCRIPT_FULL_PATH="${SCRIPT_PATH}/$(basename "${BASH_SOURCE[0]}")"

main()
{
  # """Setup preview folder to be able to see the rendering of the documentation template.
  #
  # Build the list of the file that will be installed if using the mkdocs
  # documentation template, make a symlinks of all these files into `preview`
  # folder and, depending on the options provided, render the documentation
  # preview.
  #
  # Globals:
  #   UPGRADE
  #   SUBREPO
  #   REPO_URL
  #   MKDOCS_ROOT
  #   MKDOCS_TMP
  #   MKDOCS_CLONE_ROOT
  #
  # Arguments:
  #     * `-c,--clean`      : Remove every existing symlinks before rendering the preview.
  #     * `-r,--very-clean` : Remove every existing symlinks without rendering the preview.
  #     * `-h,--help`       : Print this help.
  #
  # Output:
  #   Log informations
  #
  # Returns:
  #   0, if rendering of the preview documentation went right.
  #   1, if rendering of the preview documentation went wrong.
  #
  # """

  manpage()
  {
    # """Extract the script documentation from header and print it on stdout.
    #
    # Simply extract the docstring from the header of the script, format it with
    # some output enhancement (such as bold) and print it to stdout.
    #
    # Globals:
    #   SCRIPT_FULL_PATH
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Help to stdout
    #
    # Returns:
    #   None
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
    #   - `DEBUG` print in the fifth colors of the terminal (usually magenta)
    #   - `INFO` print in the second colors of the terminal (usually green)
    #   - `WARNING` print in the third colors of the terminal (usually yellow)
    #   - `ERROR` print in the third colors of the terminal (usually red)
    #
    # If no message severity is provided, severity will automatically be set to
    # INFO.
    #
    # Globals:
    #   ZSH_VERSION
    #
    # Arguments:
    #   $1: string, message severity or message content
    #   $@: string, message content
    #
    # Output:
    #   Log informations colored
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
    #   $1: string, absolute path to the folder which will be parsed
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

  clean_preview()
  {
    # """Recursively clean the preview folder by removing all symlinks
    #
    # Simply remove recursively all symlinks from folder `preview`.
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
    local path=$1
    if [[ -d "${path}" ]] && ! rmdir "${path}" &> /dev/null
    then
      # - SC2295: Expansions inside ${..} need to be quoted separately,
      #           otherwise the match as pattern
      # shellcheck disable=SC2295
      mkdocs_log "INFO" "Cleaning **${path##*${MKDOCS_ROOT}\/}**."
      for i_node in "${path}"/*
      do
        if [[ -d "${i_node}" ]]
        then
          clean_preview "${i_node}"
        elif [[ -L "${i_node}" ]]
        then
          rm "${i_node}"
        fi
      done
      rmdir --ignore-fail-on-non-empty "${path}"
    fi
  }


  setup_mkdocs()
  {
    # """Recursively install base folder and script to render a preview of the documentation template.
    #
    # Build the list of files and folders, recursively create a symlink of all
    # files to their right location from the temporary clone repo to the folder
    # `preview`.
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
    local dir
    local i_node
    local file_from
    local file_to

    mkdocs_log "INFO" "Building list of files"
    build_file_list "${MKDOCS_ROOT}/templates"
    template_nodes=("${tmp_nodes[@]}")
    tmp_nodes=()
    build_file_list "${MKDOCS_ROOT}/user_config"
    user_nodes=("${tmp_nodes[@]}")
    tmp_nodes=()

    build_final_file_list

    for i_node in "${tmp_nodes[@]}"
    do
      file_from="${MKDOCS_ROOT}/${i_node}"
      file_to="${MKDOCS_TMP}/${i_node//user_config\/}"
      file_to="${file_to//templates\/}"
      if ! [[ -d "$(dirname "${file_to}")" ]]
      then
        dir=$(dirname "${file_to}")
        # - SC2295: Expansions inside ${..} need to be quoted separately,
        #           otherwise the match as pattern
        # shellcheck disable=SC2295
        mkdocs_log "INFO" "Create dir **${dir##*${MKDOCS_ROOT}\/}**."
        mkdir -p "${dir}"
      fi
      if ! [[ "${file_to}" =~ \.gitkeep$ ]] && ! [[ "${file_to}" =~ \/mkdocs.local.yml ]]
      then
        if ! [[ -e "${file_to}" ]]
        then
          ln -s "${file_from}" "${file_to}"
        fi
      elif [[ "${file_to}" =~ \/mkdocs.local.yml ]]
      then
        # - SC2295: Expansions inside ${..} need to be quoted separately,
        #           otherwise the match as pattern
        # shellcheck disable=SC2295
        mkdocs_log "INFO" "Updating ${file_to##*${MKDOCS_ROOT}\/}"
        cat "${file_from}" > "${file_to}"
        echo "  - Example: example.md" >> "${file_to}"
      fi
    done
  }

  # Parse arguments
  while [[ $# -gt 0 ]]
  do
    case "$1" in
      --clean|-c)
        clean_preview "${MKDOCS_ROOT}/preview"
        shift
        ;;
      --very-clean|-r)
        clean_preview "${MKDOCS_ROOT}/preview"
        return
        ;;
      --help|-h)
        manpage
        ;;
    esac
  done

  # Set color prefix
  local e_normal="\e[0m"      # normal (white fg & transparent bg)
  local e_bold="\e[1m"        # bold
  local e_warning="\e[0;33m"  # yellow fg
  local e_error="\e[0;31m"    # red fg
  local e_info="\e[0;32m"     # green fg

  setup_mkdocs
  cd "${MKDOCS_TMP}" || exit 1
  mkdocs serve -f "${MKDOCS_TMP}/mkdocs.local.yml"
  cd "${MKDOCS_ROOT}" || exit 1
}

main "${@}"

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------