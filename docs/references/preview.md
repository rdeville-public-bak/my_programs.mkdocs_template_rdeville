# preview.sh

Setup a temporary documentation folder to preview the rendering of the template

## Synopsis

`./preview.sh [-c|--clean] [-r|--very-clean]`

## Description

This script will build the final list of folder that will be installed in
the folder that will host the documenation and render a preview of such
basic documenation based from template.

This will be done by creating symlinks from `templates` and `user_config`
folders into `preview` folder.

Available options are:

  `-c,--clean`      : Remove every existing symlinks before rendering the
                      preview.

  `-r,--very-clean` : Remove every existing symlinks without rendering the
                      preview.

  `-h,--help`       : Print this help.



## main()

 **Setup folder to be able to use directory environment mechanism**
 
 Check if git is installed. Then check that folder is not already using
 mkdocs documentation.
 
 If directory already set to use directory environment, then check if user
 explicitly tell to upgrade and upgrade, otherwise, print a warning and exit.
 
 If directory not already set to use directory environment, clone
 user provided repo to a temporary folder, copy relevant scripts, files and
 folders to initiliaze a documentation rendered using mkdocs.

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
 | `-u,--upgrade` | -u,--upgrade |
 | `-r,--repo-url REPO_URL` | -r,--repo-url REPO_URL |
 | `-s,--subrepo` | -s,--subrepo |

 **Output**

 - Log informations

 **Returns**

 - 0 if directory is correctly configure to start writing documentation
 - 1 if something when wrong during the setup of documentation

### manpage()

> **Extract the script documentation from header and print it on stdout**
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

> **Print debug message in colors depending on message severity on stderr**
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
> | `$1, string, absolute path to the folder which will be parsed` | $1, string, absolute path to the folder which will be parsed |
>
>

### build_final_file_list()

> **Replate templates file by user configured files**
> 
> If there is the same file in `user_config` and `templates` folder, then
> replace the file to be installed from `templates` by the one in
> `user_config`. Finally, add remaining `user_config` files not in
> `templates` to the list of files to install or upgrade in a bash array.
>
> **Globals**
>
> - `MKDOCS_ROOT`
>
>

### clean_preview()

> **Recursively clean the preview folder by removing all symlinks**
> 
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

> **Recursively install base folder and script to write mkdocs documentation.**
> 
> Build the list of files and folders, recursively copy all files to
> their right location from the temporary clone repo to the folder which
> will host the mkdocs documentation.
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
