#!/usr/bin/env bash
# """Generate mkdocs source code references documentation for bash scripts
#
# SYNOPSIS:
#   `./generate_source_docs.sh [options]`
#
# DESCRIPTION:
#   From the list of nodes stored in `${NODE_LIST[@]}` array in the script,
#   parse every scripts in nodes and folder nodes to generate their
#   corresponding references source code documentation for mkdocs and output this
#   documentation in their corresponding file in the `docs` folder.
#
# OPTIONS:
#
#   - `-d,--dry-run` : Specify the generation of the documentation is only for
#                      test purpose:
#
# """

# Input folder/script
NODE_LIST=(
  "."
  "tools"
  "user_config"
)

DRY_RUN="false"

SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 || return 1 ; pwd -P )"
SCRIPT_FULL_PATH="${SCRIPT_PATH}/$(basename "${BASH_SOURCE[0]}")"

MKDOCS_ROOT="${SCRIPT_PATH//\/tools/}"
MKDOCS_DEBUG_LEVEL="INFO"

manpage()
{
  # """Extract the script documentation from header and print it on stdout
  #
  # Simply extract the docstring from the header of the script, format it with
  # some output enhancement (such as bold) and print it to stdout.
  #
  # Globals:
  #   SCRIPTPATH
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


# - SC2034: var appears unused, Verify use (or export if used externally)
# shellcheck disable=SC2034
mkdocs_log()
{
  # """Print debug message in colors depending on message severity on stderr
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
    if [[ -n "${ZSH_VERSION}" ]]
    then
      prefix="${(P)msg_severity}"
    else
      prefix="${!msg_severity}"
    fi
    color_output="e_${msg_severity}"
  else
    prefix="${info}"
  fi

  if [[ -n "${ZSH_VERSION}" ]]
  then
    color_output="${(P)color_output}"
  else
    color_output="${!color_output}"
  fi

  # Concat all remaining arguments in the message content and apply markdown
  # like syntax.
  msg_content=$(echo "$*" | sed -e "s/ \*\*/ \\${e_bold}/g" \
                              -e "s/\*\*\./\\${e_normal}\\${color_output}./g" \
                              -e "s/\*\* /\\${e_normal}\\${color_output} /g" \
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


parse_main_doc()
{
  # """Process the content of the main part of the docstring
  #
  # Render the mkdocs documentation of the main part of the docstring.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the main parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  if [[ -n "${main_doc}" ]]
  then
    while IFS= read -r i_line
    do
      echo "${quote_indent} ${i_line/${space_indent}}"
    done <<< "$(echo -e "${main_doc}")"
    echo "${quote_indent}"
  fi
}

parse_globals_doc()
{
  # """Process the content of the globals part of the docstring
  #
  # If `Globals` part of the docstring is not `None`, render the mkdocs
  # documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the globals parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  if [[ -n "${globals_doc}" ]] && ! [[ "${globals_doc}" =~ "None" ]]
  then
    echo -e "${quote_indent} **Globals**"
    echo "${quote_indent}"
    # `IFS=` here is local to the loop and make the read do not hide leading
    # space to keep indentation of the current line.
    while IFS= read -r i_line
    do
      # If line is not empty
      if [[ -n "${i_line}" ]] && ! [[ "${i_line}" =~ ^[[:space:]]*$ ]]
      then
        echo "${quote_indent} - \`${i_line/${space_indent}}\`"
      fi
    done <<< "$(echo -e "${globals_doc}")"
  fi
  echo "${quote_indent}"
}

parse_arguments_doc()
{

  # """Process the content of the arguments part of the docstring
  #
  # If `Arguments` part of the docstring is not `None`, render the mkdocs
  # documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the arguments parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  local argument
  local description
  local line_content

  if [[ -n "${arguments_doc}" ]] && ! [[ "${arguments_doc}" =~ "None" ]]
  then
    # `IFS=` here is local to the loop and make the read do not hide leading
    # space to keep indentation of the current line.
    echo "${quote_indent} **Arguments**"
    echo "${quote_indent}"
    echo "${quote_indent} | Arguments | Description |"
    echo "${quote_indent} | :-------- | :---------- |"
    while IFS= read -r i_line
    do
      # If line is not empty
      if [[ -n "${i_line}" ]] && ! [[ "${i_line}" =~ ^[[:space:]]*$ ]]
      then
        line_content="${i_line/${space_indent}}"
        argument="\`${line_content%%:*}\`"
        description="${line_content##*:}"
        echo -e "${quote_indent} | ${argument} | ${description} |"
      fi
    done <<< "$(echo -e "${arguments_doc}")"
    echo "${quote_indent}"
  fi
}

parse_output_doc()
{
  # """Process the content of the output part of the docstring
  #
  # If `Output` part of the docstring is not `None`, render the mkdocs
  # documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the return parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  if [[ -n "${output_doc}" ]] && ! [[ "${output_doc}" =~ "None" ]]
  then
    echo -e "${quote_indent} **Output**"
    echo "${quote_indent}"
    # `IFS=` here is local to the loop and make the read do not hide leading
    # space to keep indentation of the current line.
    while IFS= read -r i_line
    do
      # If current line is not empty
      if [[ -n "${i_line}" ]] && ! [[ "${i_line}" =~ ^[[:space:]]*$ ]]
      then
        echo "${quote_indent} - ${i_line/${space_indent}}"
      fi
    done <<< "$(echo -e "${output_doc}")"
    echo "${quote_indent}"
  fi
}

parse_returns_doc()
{
  # """Process the content of the return part of the docstring
  #
  # If `Returns` part of the docstring is not `None`, render the mkdocs
  # documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Rendered content of the return parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  if [[ -n "${returns_doc}" ]] && ! [[ "${returns_doc}" =~ "None" ]]
  then
    echo "${quote_indent} **Returns**"
    echo "${quote_indent}"
    # `IFS=` here is local to the loop and make the read do not hide leading
    # space to keep indentation of the current line.
    while IFS= read -r i_line
    do
      # If current line is not empty
      if [[ -n "${i_line}" ]] && ! [[ "${i_line}" =~ ^[[:space:]]*$ ]]
      then
        echo -e "${quote_indent} - ${i_line/${space_indent}}"
      fi
    done <<< "$(echo -e "${returns_doc}")"
    echo "${quote_indent}"
  fi
}

parse_method_doc_line()
{
  # """Process current line of the method documentation
  #
  # For the current line of the method docstring (value of `${i_line}` sets in
  # the parent method), add its content to the variable storing part of the
  # documentation to later be processed.
  #
  # Globals:
  #   MKDOCS_ROOT
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the header of the docstring on stdout
  #   Warning log if optional part of the docstring are missing on stderr
  #   Error log if required part of the docstring are missing on stderr
  #
  # Returns:
  #   1 if required part of the docstring are missing
  #
  # """

  # If parsing first line of the docstring, i.e. the header
  if [[ "${part}" == "header" ]]
  then
    if ! [[ "${i_line}" =~ \"+[A-Za-z] ]]
    then
      mkdocs_log "ERROR" "Mehod **${method_name}** in" \
        "**${i_node//${MKDOCS_ROOT}\/}** does not have **header** description."
      return 1
    else
      echo "${quote_indent} **${i_line//${header_regexp_delete}}**"
    fi
    part="main"
  # If current line define a new part (except `main`)
  elif [[ "${i_line}" =~ (Globals|Arguments|Output|Returns): ]]
  then
    # Get the name of the variable storing the current part of the docstring
    var_subst="$( echo ${part} | tr '[:upper:]' '[:lower:]')_doc"

    # Handling of zsh for variable substitution
    if [[ -n "${ZSH_VERSION}" ]]
    then
      part_content="${(P)var_subst}"
    else
      part_content="${!var_subst}"
    fi

    # If part content is empty or made of only empty lines
    if [[ -z "${part_content}" ]] || [[ -z "$(echo -e "${part_content}")" ]]
    then
      if [[ "${part}" == "main" ]]
      then
        mkdocs_log "WARNING" \
          "Method **${method_name}** in **${i_node//${MKDOCS_ROOT}\/}**" \
          "does not have **${part}** description."
      else
        mkdocs_log "ERROR" \
          "Method **${method_name}** in **${i_node//${MKDOCS_ROOT}\/}**" \
          "does not have **${part}** description."
        return 1
      fi
    fi

    # Normally, when changing part, comment of part should have two more space
    # than the main part of the docstring.
    if [[ "${part}" == "main" ]]
    then
      space_indent+="  "
    fi

    # Update the current part name
    part=$(echo "${i_line}" | sed -e "s/^ *//g" -e "s/:$//g")
  else
    # Add line to the variable corresponding to the currently parsed docstring
    # part.
    case "${part}" in
      main)
        main_doc+="${i_line/${space_indent}}\n"
        ;;
      Globals)
        globals_doc+="${i_line}\n"
        ;;
      Arguments)
        arguments_doc+="${i_line}\n"
        ;;
      Output)
        output_doc+="${i_line}\n"
        ;;
      Returns)
        returns_doc+="${i_line}\n"
        ;;
    esac
  fi
}

generate_method_docs()
{
  # """Generate mkdocs documentation from a method docstring
  #
  # For the method name with its docstring passed as first argument, parse it
  # content and add it to the script documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   $1: string, method name with its docstring
  #
  # Output:
  #   Rendered documentation on stdout
  #   Error log if required part of the docstring are missing on stderr
  #
  # Returns:
  #   1 if required part of the docstring are missing
  #
  # """

  # Content of the docstring
  local method_doc="$1"

  # First part of the docstring
  local header_regexp_delete=' *"""'
  local method_name
  local method_full_desc

  # Variable storing subpart of the docstring
  local part="header"
  local part_content=""
  local var_subst=""

  # Variable storing documentation of each part of the docstring
  local main_doc=""
  local globals_doc=""
  local arguments_doc=""
  local output_doc=""
  local returns_doc=""

  # Default markdown title depth
  local toc_depth="##"

  # Extract the method name
  method_name="$(grep -E ".*\(\)$" <<<"${method_doc}" | sed "s/^ *//g")"

  # Extract only the docstring without the comment prefix `#`
  # - SC2026: This word (`p`) is outside of quotes
  # shellcheck disable=SC2026
  method_full_desc=$(echo "${method_doc}" \
    | sed -n -e '/# """.*/,/# """/'p \
    | sed -e 's/# //g' \
          -e 's/"""$//g' \
          -e 's/#$//g' \
  )

  # Compute TOC depth of the method
  if [[ "${nb_indent}" -ne 0 ]]
  then
    toc_depth+="$(printf "%$(( nb_indent ))s" '#')"
  fi

  # Output title of the method name with its depth
  echo -e "\n\n${toc_depth} ${method_name}\n"

  # Normally, indentation of docstring should be two more space that method
  # indentation.
  space_indent+="  "

  # `IFS=` here is local to the loop and make the read do not hide leading space
  # to keep indentation of the current line.
  # - SC2116: Useless echo ?
  # shellcheck disable=SC2116
  while IFS= read -r i_line
  do
    parse_method_doc_line
  done <<<"$(echo "${method_full_desc}")"

  # Remove indentation correction
  space_indent=${space_indent:-4}

  # Process the aggregated documentation per parts
  parse_main_doc
  parse_globals_doc
  parse_arguments_doc
  parse_output_doc
  parse_returns_doc
  echo "${quote_indent}"
}

generate_doc()
{
  # """Generate mkdocs documentation of the current node
  #
  # For the current node (value of `${i_node}` set in parent method), extract
  # the main script documentation, then extract every method name and for every
  # method name, call the method to parse their documentation.
  # Finally, print the generate documentation in it corresponding file in `docs`
  # folder.
  #
  # Globals:
  #   MKDOCS_ROOT
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Error log if script does not have main documentation
  #
  # Returns:
  #   1 if script does not have main documentation
  #
  # """

  local output_file=${i_node}
  local space_indent
  local quote_indent
  local nb_indent
  local script_doc
  local full_doc

  # Handle files starting with `.` like `.envrc`
  if [[ "${i_node}" =~ ^\. ]]
  then
    output_file="${i_node/.}"
  fi
  output_file="${MKDOCS_ROOT}/docs/references/${output_file//.sh}.md"

  # Extract module documentation
  script_doc="$(sed -n -e "/^# \"\"\".*/,/^# \"\"\"/"p "${i_node}" \
                | sed -e "s/^# \"\"\"//g" \
                      -e "s/^# //g" \
                      -e "s/^  //g" \
                      -e "s/^#$//g" \
                      -e "s/DESCRIPTION[:]/## Description\n/g" \
                      -e "s/COMMANDS[:]/## Commands\n/g" \
                      -e "s/OPTIONS[:]/## Options\n/g" \
                      -e "s/SYNOPSIS[:]/## Synopsis\n/g" \
  )"

  if [[ -z ${script_doc} ]]
  then
    mkdocs_log "ERROR" "Script **${i_node}** does not have documentation."
    return 1
  fi

  # Build directory in documentation folder respecting the tree structure of the
  # `i_node` currently parsed.
  if [[ "${DRY_RUN}" == "false" ]]
  then
    mkdir -p "${MKDOCS_ROOT}/docs/references/$(dirname "${i_node}")"
  fi

  # Start building the complete documentation
  full_doc="# $(basename "${i_node}")\n\n"
  full_doc+="${script_doc}\n\n"

  # For every method_name, `IFS=` here is local to the loop and make the read
  # do not hide leading space to keep indentation of the current method name.
  while IFS= read -r i_method_name
  do
    # Determine the number of space indentation
    space_indent=${i_method_name%%[a-z]*}
    nb_indent=$(( ${#space_indent} / 2 ))
    if [[ "${nb_indent}" -ne 0 ]]
    then
      quote_indent="$(printf "%${nb_indent}s" ">")"
      method_content=$(sed -n -e "/${i_method_name}/,/# \"\"\"$/"p "${i_node}")
    else
      quote_indent=""
      method_content=$(sed -n -e "/^${i_method_name}/,/# \"\"\"$/"p "${i_node}")
    fi
    full_doc+="$(generate_method_docs "${method_content}")"
  done <<<"$(grep -E '[a-zA-Z_]\(\)' "${i_node}")"

  if [[ "${DRY_RUN}" == "false" ]]
  then
    echo -e "${full_doc}" > "${output_file}"
  fi
}

build_doc()
{
  # """Recursive method that call the documentation builder for every file
  #
  # For every node provided as arguments, if node is a file, then process its
  # documentation build. Else, if node is a folder, add all `*.sh` file in this
  # folder to a temporary array which later is passed recursively as arguments to
  # this method.
  #
  # Globals:
  #   MKDOCS_ROOT
  #
  # Arguments:
  #   $1: Bash array, List of node (files or folder) which documentation should be built.
  #
  # Output:
  #   Information log to tell which node is currently computed.
  #   Warning log to when node does not exist.
  #
  # Returns:
  #   None
  #
  # """
  local abs_path
  local i_node
  local tmp_nodes=()

  for i_node in "$@"
  do
    # Build absolute path of the node
    abs_path="${MKDOCS_ROOT}/${i_node}"

    if [[ -f "${abs_path}" ]]
    then
      mkdocs_log "INFO" "Computing documentation of **${i_node}**."
      generate_doc || error="true"
    elif [[ -d "${abs_path}" ]]
    then
      for i_subnode in "${abs_path}"/*.sh
      do
        # Handle folder where there is not `*.sh` file
        if [[ "${i_subnode}" != "${abs_path}/*.sh" ]]
        then
          # Remove every occurrences of `${MKDOCS_ROOT}`
          i_subnode="${i_subnode//${MKDOCS_ROOT}\//}"
          tmp_nodes+=("${i_subnode}")
        fi
      done
    else
      mkdocs_log "WARNING" "Node **${i_node}** does not exists !"
    fi
  done

  # Call this method for subnode
  if [[ -n "${tmp_nodes[*]}" ]]
  then
    build_doc "${tmp_nodes[@]}" || error="true"
  fi

  if [[ "${error}" == "true" ]]
  then
    return 1
  fi
  return 0
}

main()
{
  # """Main method that build source documentat for every files
  #
  # First ensure that directory environment is activated first, then load
  # libraries script and finally call the building doc methods.
  #
  # Globals:
  #   MKDOCS_ROOT
  #   NODE_LIST
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Error log if directory environment is not activated yet
  #
  # Returns:
  #   1 if directory environment is not activated yet
  #
  # """

  while [[ $# -gt 0 ]]
  do
    case $1 in
      -d|--dry-run)
        DRY_RUN="true"
        shift
        ;;
      --help|-h)
        manpage
        ;;
    esac
  done
  cd "${MKDOCS_ROOT}" || return 1

  build_doc "${NODE_LIST[@]}" || return 1
}

main "$@"

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
