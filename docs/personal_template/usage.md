{% set curr_repo=subs("mkdocs_template") %}
# Use Your Custom Template

!!! note

    In the rest of documentation we will assume you forked the main repo to
    https://gitdomain.tld/namespace/mkdocs_template.git.

Now you have created your custom template you might want to use it. Well it is
as simple as installing the mkdocs template from the main repo. This is done
using the script the `setup.sh`. Below is a recall of the script usage.

{% include "docs/usage/setup.sh.md" %}

## Installing your own template

Similarly to the installation of the main template, to install your custom
template, you will need to download the `setup.sh` script. Note that you can
download it either from your fork (not recommended) or from the main repo, which
is the recommended way to ensure having the latest `setup.sh`.

The main difference with the installation of your own template compared to the
installation of the basic main template is the url of the repo to use.

```bash
# Assuming you are in the repo for which you want to write a documentation
# First download the setup script into a temporary folder
wget {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}/-/raw/master/setup.sh \
   -O /tmp/setup_mkdocs.sh
# Then read the content of the script with your favorite editor
vim /tmp/setup_mkdocs.sh
# If you are confident with what the script does, make it executable and run it
chmod +x /tmp/setup_mkdocs.sh
# Note the URL of the repo specified with option `-r`
/tmp/setup_mkdocs.sh -r https://gitdomain.tld/namespace/mkdocs_template.git
```

Or if you already read the content of the script `setup.sh` at the root of this
repo, previous commands can be done in online:

```bash
# ASSUMING YOU ARE IN THE REPO FOR WHICH YOU WANT TO WRITE A DOCUMENTATION
# You can get the content of the script setup.sh via curl and pipe it into bash
curl -sfL \
  {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}/-/raw/master/setup.sh \
  | bash -s -- \
    -r https://gitdomain.tld/namespace/mkdocs_template.git
```

This will automatically compute the union of the content of the folder
`templates` and the folder `user_config` and copy them in the folder where you
are located.

## Upgrade from your template

Later, you may change some configuration in your template, such as adding or
removing files, updating CSS, etc. Once this modification done, you will need to
upgrade your already installed documentation from your new template.

This is done by using the option `-u` of the script `setup.sh`. Using this
option, the script will compare last version with old version of each files, if
they have changed, backup the old version, to avoid losing content in case of error
and then upgrade the files to the latest version.

```bash
# Assuming you are in the repo for which you want to write a documentation
# First download the setup script into a temporary folder
wget {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}/-/raw/master/setup.sh \
   -O /tmp/setup_mkdocs.sh
# Then read the content of the script with your favorite editor
vim /tmp/setup_mkdocs.sh
# If you are confident with what the script does, make it executable and run it
chmod +x /tmp/setup_mkdocs.sh
# Note the URL of the repo specified with option `-r`
# NOTE THE USAGE OF THE `-u` OPTION
/tmp/setup_mkdocs.sh -u -r https://gitdomain.tld/namespace/mkdocs_template.git
```

Or if you already read the content of the script `setup.sh` at the root of this
repo, previous commands can be done in online:

```bash
# ASSUMING YOU ARE IN THE REPO FOR WHICH YOU WANT TO WRITE A DOCUMENTATION
# You can get the content of the script setup.sh via curl and pipe it into bash
# NOTE THE USAGE OF THE `-u` OPTION
curl -sfL \
  {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}/-/raw/master/setup.sh \
  | bash -s -- \
    -u -r https://gitdomain.tld/namespace/mkdocs_template.git
```
