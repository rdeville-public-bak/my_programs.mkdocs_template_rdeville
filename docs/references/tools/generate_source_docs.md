# generate_source_docs.sh

Generate mkdocs source code references documentation for bash scripts

## Synopsis

`./generate_source_docs.sh [options]`

## Description

From the list of nodes stored in `${NODE_LIST[@]}` array in the script,
parse every scripts in nodes and folder nodes to generate their
corresponding references source code documentation for mkdocs and output this
documentation in their corresponding file in the `docs` folder.

## Options


- `-d,--dry-run` : Specify the generation of the documentation is only for
                   test purpose:



## manpage()

 **Extract the script documentation from header and print it on stdout**
 
 Simply extract the docstring from the header of the script, format it with
 some output enhancement (such as bold) and print it to stdout.

 **Globals**

 - `SCRIPTPATH`

 **Output**

 - Help to stdout

## mkdocs_log()

 **Print debug message in colors depending on message severity on stderr**
 
 Echo colored log depending on user provided message severity. Message
 severity are associated to following color output:
 
   - `DEBUG` print in the fifth colors of the terminal (usually magenta)
   - `INFO` print in the second colors of the terminal (usually green)
   - `WARNING` print in the third colors of the terminal (usually yellow)
   - `ERROR` print in the third colors of the terminal (usually red)
 
 If no message severity is provided, severity will automatically be set to
 INFO.

 **Globals**

 - `ZSH_VERSION`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `$1` |  string, message severity or message content |
 | `$@` |  string, message content |

 **Output**

 - Log informations colored

## parse_main_doc()

 **Process the content of the main part of the docstring**
 
 Render the mkdocs documentation of the main part of the docstring.


 **Output**

 - Render content of the main parts of the docstring on stdout

## parse_globals_doc()

 **Process the content of the globals part of the docstring**
 
 If `Globals` part of the docstring is not `None`, render the mkdocs
 documentation.


 **Output**

 - Render content of the globals parts of the docstring on stdout

## parse_arguments_doc()

 **Process the content of the arguments part of the docstring**
 
 If `Arguments` part of the docstring is not `None`, render the mkdocs
 documentation.


 **Output**

 - Render content of the arguments parts of the docstring on stdout

## parse_output_doc()

 **Process the content of the output part of the docstring**
 
 If `Output` part of the docstring is not `None`, render the mkdocs
 documentation.


 **Output**

 - Render content of the return parts of the docstring on stdout

## parse_returns_doc()

 **Process the content of the return part of the docstring**
 
 If `Returns` part of the docstring is not `None`, render the mkdocs
 documentation.


 **Output**

 - Rendered content of the return parts of the docstring on stdout

## parse_method_doc_line()

 **Process current line of the method documentation**
 
 For the current line of the method docstring (value of `${i_line}` sets in
 the parent method), add its content to the variable storing part of the
 documentation to later be processed.

 **Globals**

 - `MKDOCS_ROOT`

 **Output**

 - Render content of the header of the docstring on stdout
 - Warning log if optional part of the docstring are missing on stderr
 - Error log if required part of the docstring are missing on stderr

 **Returns**

 - 1 if required part of the docstring are missing

## generate_method_docs()

 **Generate mkdocs documentation from a method docstring**
 
 For the method name with its docstring passed as first argument, parse it
 content and add it to the script documentation.


 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `$1` |  string, method name with its docstring |

 **Output**

 - Rendered documentation on stdout
 - Error log if required part of the docstring are missing on stderr

 **Returns**

 - 1 if required part of the docstring are missing

## generate_doc()

 **Generate mkdocs documentation of the current node**
 
 For the current node (value of `${i_node}` set in parent method), extract
 the main script documentation, then extract every method name and for every
 method name, call the method to parse their documentation.
 Finally, print the generate documentation in it corresponding file in `docs`
 folder.

 **Globals**

 - `MKDOCS_ROOT`

 **Output**

 - Error log if script does not have main documentation

 **Returns**

 - 1 if script does not have main documentation

## build_doc()

 **Recursive method that call the documentation builder for every file**
 
 For every node provided as arguments, if node is a file, then process its
 documentation build. Else, if node is a folder, add all `*.sh` file in this
 folder to a temporary array which later is passed recursively as arguments to
 this method.

 **Globals**

 - `MKDOCS_ROOT`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `$1` |  Bash array, List of node (files or folder) which documentation should be built. |

 **Output**

 - Information log to tell which node is currently computed.
 - Warning log to when node does not exist.

## main()

 **Main method that build source documentat for every files**
 
 First ensure that directory environment is activated first, then load
 libraries script and finally call the building doc methods.

 **Globals**

 - `MKDOCS_ROOT`
 - `NODE_LIST`

 **Output**

 - Error log if directory environment is not activated yet

 **Returns**

 - 1 if directory environment is not activated yet
