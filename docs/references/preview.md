# preview.sh

Setup a temporary documentation folder to preview the rendering of the template

## Synopsis

`./preview.sh [-c|--clean] [-r|--very-clean]`

## Description

This script will build the final list of folder that will be installed in
the folder that will host the documenation and render a preview of such
basic documentation based from template.

This will be done by creating symlinks from `templates` and `user_config`
folders into `preview` folder.

Available options are:

  * `-c,--clean`      : Remove every existing symlinks before rendering the
                        preview.

  * `-r,--very-clean` : Remove every existing symlinks without rendering the
                        preview.

  * `-h,--help`       : Print this help.



## main()

 **Setup preview folder to be able to see the rendering of the documentation template.**

 Build the list of the file that will be installed if using the mkdocs
 documentation template, make a symlinks of all these files into `preview`
 folder and, depending on the options provided, render the documentation
 preview.

 **Globals**

 - `UPGRADE`
 - `SUBREPO`
 - `REPO_URL`
 - `MKDOCS_ROOT`
 - `MKDOCS_TMP`
 - `MKDOCS_CLONE_ROOT`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `-c,--clean`      |  Remove every existing symlinks before rendering the preview. |
 | `-r,--very-clean` |  Remove every existing symlinks without rendering the preview. |
 | `-h,--help`       |  Print this help. |

 **Output**

 - Log informations

 **Returns**

 - 0, if rendering of the preview documentation went right.
 - 1, if rendering of the preview documentation went wrong.

### manpage()

> **Extract the script documentation from header and print it on stdout.**
>
> Simply extract the docstring from the header of the script, format it with
> some output enhancement (such as bold) and print it to stdout.
>
> **Globals**
>
> - `SCRIPT_FULL_PATH`
>
> **Output**
>
> - Help to stdout
>
>

### mkdocs_log()

> **Print debug message in colors depending on message severity on stderr.**
>
> Echo colored log depending on user provided message severity. Message
> severity are associated to following color output:
>
>   - `DEBUG` print in the fifth colors of the terminal (usually magenta)
>   - `INFO` print in the second colors of the terminal (usually green)
>   - `WARNING` print in the third colors of the terminal (usually yellow)
>   - `ERROR` print in the third colors of the terminal (usually red)
>
> If no message severity is provided, severity will automatically be set to
> INFO.
>
> **Globals**
>
> - `ZSH_VERSION`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, message severity or message content |
> | `$@` |  string, message content |
>
> **Output**
>
> - Log informations colored
>
>

### build_file_list()

> **Recursively build a list of file from provided folder**
>
> Recursively build a list of file from provided folder and store such list
> in a temporary bash array that must be set in parent method.
>
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, absolute path to the folder which will be parsed |
>
>

### build_final_file_list()

> **Build the merged list from `templates` and `user_config` folder.**
>
> If there is the same file in `user_config` and `templates` folder, then
> replace the file to be installed from `templates` by the one in
> `user_config`. Finally, add remaining `user_config` files not in
> `templates` to the list of files to install or upgrade in a bash array set
> in parent method.
>
> **Globals**
>
> - `MKDOCS_ROOT`
>
>

### clean_preview()

> **Recursively clean the preview folder by removing all symlinks**
>
> Simply remove recursively all symlinks from folder `preview`.
>
> **Globals**
>
> - `MKDOCS_ROOT`
> - `MKDOCS_CLONE_ROOT`
>
> **Output**
>
> - Log message
>
>

### setup_mkdocs()

> **Recursively install base folder and script to render a preview of the documentation template.**
>
> Build the list of files and folders, recursively create a symlink of all
> files to their right location from the temporary clone repo to the folder
> `preview`.
>
> **Globals**
>
> - `MKDOCS_ROOT`
> - `MKDOCS_CLONE_ROOT`
>
> **Output**
>
> - Log message
>
>
