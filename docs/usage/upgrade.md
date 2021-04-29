{% set curr_repo=subs("mkdocs_template") %}
# Upgrade to latest template

If the source template get new features, like improving `plugins.py·` script,
you might want to get them. To to so is as easy as installing the documentation.
This is done using the script `setup.sh` with the option `-u`. Below is a recall
of the usage of the script

{% include "docs/usage/setup.sh.md" %}

## How to upgrade


This is done by using the option `-u` of the script `setup.sh`. Using this
option, the script will compare last version with old version of each files, if
they have changed, backup the old version, to avoid losing content in case of error
and then upgrade the files to the latest version.

```bash
# ASSUMING YOU ARE IN THE REPO FOR WHICH YOU WANT TO WRITE A DOCUMENTATION
# First download the setup script into a temporary folder
wget {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}/-/raw/master/setup.sh \
   -O /tmp/setup_mkdocs.sh
# Then read the content of the script with your favorite editor
vim /tmp/setup_mkdocs.sh
# If you are confident with what the script does, make it executable and run it
chmod +x /tmp/setup_mkdocs.sh
# NOTE THE USAGE OF THE `-u` OPTION
/tmp/setup_mkdocs.sh -u -r {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}
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
    -u -r {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}
```

This will automatically upgrade the content of your documentation from the
template to its latest version.

