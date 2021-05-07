{% set curr_repo=subs("mkdocs_template") %}
# Setup a template

The installation of a mkdocs documentation from a template is done using the
script `setup.sh` at the root of the repo.

{% include "docs/usage/setup.sh.md" %}

## Installation of the template

Assuming you want to use the **really** basic template provided at [{{
git_platform.name }} - {{ curr_repo.git_name_with_namespace }}]({{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}). In a repo in which you
want to create a documentation, type the following commands:

```bash
# ASSUMING YOU ARE IN THE REPO FOR WHICH YOU WANT TO WRITE A DOCUMENTATION
# First download the setup script into a temporary folder
wget {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}/-/raw/master/setup.sh \
   -O /tmp/setup_mkdocs.sh
# Then read the content of the script with your favorite editor
vim /tmp/setup_mkdocs.sh
# If you are confident with what the script does, make it executable and run it
chmod +x /tmp/setup_mkdocs.sh
/tmp/setup_mkdocs.sh -r {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}
```

Or if you already read the content of the script `setup.sh` at the root of this
repo, previous commands can be done in one line:

```bash
# ASSUMING YOU ARE IN THE REPO FOR WHICH YOU WANT TO WRITE A DOCUMENTATION
# You can get the content of the script setup.sh via curl and pipe it into bash
curl -sfL \
  {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}/-/raw/master/setup.sh \
  | bash -s -- \
    -r {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}
```

This will automatically copy the content of folder `templates` of the Mkdocs
Template project in the folder where you are located.

Note that some copied files will have comment tag automatically added if they
are not present. For instance, following example content:

```markdown
# Title

Sample content of a page
```

Will be copied with the following tags:

```md
<!-- BEGIN MKDOCS TEMPLATE -->
<!-- WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG ! -->
<!-- Modified content will be overwritten when updating -->
# Title

Sample content of a page

<!-- END MKDOCS TEMPLATE -->
```

These tags serve as delimiter of the template content, without them, any
modification you may have done on copied files will be overwritten when you will
upgrade to a latest template version.

So this allow you to add content before and after these tags, content you will
add before and after will not be modified when upgrading while content between
tags might be updated if latest version contain update.

In other words, you might do the following:

```md
# Previous title

Content added by the user, which will not be updated in case of upgrade of the
template.

<!-- BEGIN MKDOCS TEMPLATE -->
<!-- WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG ! -->
<!-- Modified content will be overwritten when updating -->
# Title

Sample content of a page

<!-- END MKDOCS TEMPLATE -->

# Next title

Content added by the user, which will not be updated in case of upgrade of the
template.
```

The tag comment depends on the extension of the file copied:

  - `*.md`, `*.html` or `*LICENSE`, will have following tags:
    ```html
    <!-- BEGIN MKDOCS TEMPLATE -->
    <!-- WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG ! -->
    <!-- Modified content will be overwritten when updating -->

    […]

    <!-- END MKDOCS TEMPLATE -->
    ```

  - `*.css`, `*.js`, will have following tags:
    ```css
    /* BEGIN MKDOCS TEMPLATE */
    /* WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG ! */
    /* Modified content will be overwritten when updating */

    […]

    /* END MKDOCS TEMPLATE */
    ```

  - `*.yaml`, `*.yml`, `*.gitignore`, `*.toml`, `*.in`, `*.txt`, will have
    ```yaml
    ### BEGIN MKDOCS TEMPLATE ##
    ### WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG ! ###
    ### Modified content will be overwritten when updating ###
    ###

    […]

    ### END MKDOCS TEMPLATE ###
    ```

  - Files with other extension will not have comment tags, this is mainly for
    source code file or svg images for instance.


Moreover, if there is already mkdocs tags in the file, the complete file will be
copied during setup but only content between tags will be overwritten when
upgrading.

For instance, the file `mkdocs.yml` has most of its content between tags, only
the end is not between tags. So when installing the template for the first time,
all of the file will be installed while when upgrading only content between tag
will be overwritten.

Once you have install the mkdocs template files using the script `setup.sh` you
now have some [configuration][configuration] to do.

[configuration]: configure.md
