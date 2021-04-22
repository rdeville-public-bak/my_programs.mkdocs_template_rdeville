# setup.sh

Simply setup documentation configuration for the current folder.

## Synopsis

`./setup.sh [-u|--upgrade] [-s|--subrepo] [-h|--help] -r|--repo-url REPO_URL`

## Description

This script will install/upgrade set of scripts and files to create and
manage documentation rendered using mkdocs.

If directory is already using mkdocs and user does not provide
`-u|--upgrade` options, an error will be shown and nothing will be done.

If user does not provide REPO_URL from which download the template, i.e.
using option `-r|--repo-url REPO_URL`, then an error will be prompt and
the script will exit.

## Options

Available options are:

  * `-u,--upgrade`  : Upgrade the current mkdocs documentation to the latest
                      template version.

  * `-s,--subrepo`  : Specify the current repo is a subrepo that will be
                      merge into another main project using mkdocs-monorepo
                      plugin.

  * `-r,--repo-url` : URL of the repo from which the template will be
                      downloaded.

  * `-h,--help`     : Print this help.



## main()

 **Setup folder to be able to use mkdocs documentation templates.**
 
 Check if `git` is installed. Then check that folder is not already using
 mkdocs documentation.
 
 If directory already set to use mkdocs documentation, then check if user
 explicitly tell to upgrade and upgrade, otherwise, print a warning and exit.
 
 If directory not already set to use mkdocs documentation, clone user
 provided repo to a temporary folder, copy relevant scripts, files and
 folders to initiliaze a documentation rendered using mkdocs.

 **Globals**

 - `UPGRADE`
 - `SUBREPO`
 - `REPO_URL`
 - `MKDOCS_ROOT`
 - `MKDOCS_TMP`
 - `MKDOCS_CLONE_ROOT`
 - `SCRIPT_FULL_PATH`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `-u,--upgrade           ` |  Arguments to explicitly upgrade the documentation |
 | `-s,--subrepo           ` |  Specify the current repo is a subrepo that will be merge into another main project using mkdocs-monorepo plugin. |
 | `-r,--repo-url REPO_URL ` |  Arguments with the URL of the repo holding the template to setup/upgrade |

 **Output**

 - Log informations

 **Returns**

 - 0 if directory is correctly configure to start writing documentation
 - 1 if something when wrong during the setup of documentation

### manpage()

> **Extract the script documentation from header and print it on stdout.**
> 
> Simply extract the docstring from the header of the script, format it with
> some output enhancement (such as bold), print it to stdout and exit.
>
> **Globals**
>
> - `SCRIPT_FULL_PATH`
>
> **Output**
>
> - Help manpage from header docstring on stdout
>
> **Returns**
>
> - 0, always
>
>

### mkdocs_log()

> **Print debug message in colors depending on message severity on stderr.**
> 
> Echo colored log depending on user provided message severity. Message
> severity are associated to following color output:
> 
>   - `DEBUG` print in the fifth color of the terminal (usually magenta)
>   - `INFO` print in the second color of the terminal (usually green)
>   - `WARNING` print in the third color of the terminal (usually yellow)
>   - `ERROR` print in the third color of the terminal (usually red)
> 
> If no message severity is provided, severity will automatically be set to
> INFO.
>
> **Globals**
>
> - `ZSH_VERSION`
> - `MKDOCS_DEBUG_LEVEL`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1 ` |  string, message severity or message content |
> | `$@ ` |  string, message content |
>
> **Output**
>
> - Colored log informations
>
>

### check_git()

> **Ensure command `git` exists.**
> 
> Simply ensure the command `git` exists.
>
>
> **Output**
>
> - Error message if commang `git` does not exists
>
> **Returns**
>
> - 0 if `git` command exists
> - 1 if `git` command does not exist
>
>

### clone_mkdocs_template_repo()

> **Clone repo mkdocs_template to a temporary folder.**
> 
> Clone the repo mkdocs_template to a temporary folder using provided URL.
>
> **Globals**
>
> - `REPO_URL`
> - `MKDOCS_ROOT`
> - `MKDOCS_CLONE_ROOT`
> - `MKDOCS_TMP`
>
> **Output**
>
> - Log messages
>
> **Returns**
>
> - 0 if clone of repo went right
> - 1 if clone of repo went wrong
>
>

### check_upgrade()

> **Check if user specify to upgrade mkdocs documentation.**
> 
> Check if user specify to upgrade mkdocs documentation from the
> mkdocs_template provided as repo URL. This is done by the use of option
> `-u|--upgrade`.
> 
> If user did not explicitly specify to upgrade, print a warning else,
> upgrade mkdocs documentation files.
>
> **Globals**
>
> - `UPGRADE`
>
> **Output**
>
> - Warning messages.
>
> **Returns**
>
> - 0 if upgrade went right.
> - 1 if user did not specify to upgrade or if upgrade went wrong.
>
>

### upgrade_mkdocs_config_file()

> **Handle the upgrade of mkdocs.yml file.**
> 
> Depending on the type of documentation, i.e. `SUBREPO` set to `true` or
> `false`.
> 
> If `SUBREPO` set to `true`, this will update `mkdocs.local.yml` else
> will update `mkdocs.yml` if needed.
>
> **Globals**
>
> - `MKDOCS_ROOT`
> - `MKDOCS_TMP`
> - `SUBREPO`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1 ` |  string, absolute path to the latest file version to be installed |
> | `$2 ` |  string, absolute path to the location of the installation |
>
> **Output**
>
> - Log message
>
>

### setup_mkdocs_config_file()

> **Handle the configuration of mkdocs.yml file.**
> 
> Depending on the type of documentation, i.e. `SUBREPO` set to `true` or
> `false`.
> 
> In the first case, `SUBREPO` set to `true`, will generate a basic
> `mkdocs.yml` to be included with mkdocs monorepo plugins and put the full
> configuration to `mkdocs.local.yml`.
> Else, `SUBREPO` set to `false`, write directly the full configuration to
> `mkdocs.yml`.
>
> **Globals**
>
> - `MKDOCS_ROOT`
> - `SUBREPO`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1 ` |  string, absolute path to the latest file version to be installed |
> | `$2 ` |  string, absolute path to the location of the installation |
>
> **Output**
>
> - Log message
>
>

### upgrade_file()

> **Upgrade latest version of script and files from mkdocs_template.**
> 
> Check if latest version of file is different from the old version. If
> yes, then move the old version to `${MKDOCS_ROOT}/.old` then upgrade to
> latest version.
>
> **Globals**
>
> - `MKDOCS_ROOT`
> - `MKDOCS_TMP`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1 ` |  string, absolute path to the latest file version to be installed |
> | `$2 ` |  string, absolute path to the location of the installation |
>
> **Output**
>
> - Log messages
>
>

### setup_file()

> **Install latest version of script and files from mkdocs_template.**
> 
> Simply install file provided as argument from the mkdocs_template
> temporary repo to the right place in the folder currently setup to use
> mkdocs documentation.
>
> **Globals**
>
> - `MKDOCS_ROOT`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1 ` |  string, absolute path to the latest file version to be installed |
> | `$2 ` |  string, absolute path to the location of the installation |
>
> **Output**
>
> - Log messages
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
> | `$1 ` |  string, absolute path to the folder which will be parsed |
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

### setup_mkdocs()

> **Recursively install base folder and script to write mkdocs documentation.**
> 
> Build the list of files and folders, recursively copy all files to
> their right location from the temporary cloned repo to the folder which
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
