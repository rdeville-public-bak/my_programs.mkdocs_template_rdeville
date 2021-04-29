## Synopsis of `setup.sh`

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

  * `-h,--help`     : Print the help.


