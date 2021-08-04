<!-- BEGIN MKDOCS TEMPLATE -->
<!--
WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !
Modified content will be overwritten when updating
-->

# Release Notes

<!-- END MKDOCS TEMPLATE -->

## 🔖 v1.0

### 🔖 v1.0.3-RD.4 <small>(04/08/2021)</small>

* 🚑💚 Fix CI to work even better with VCSH repos

### 🔖 v1.0.3-RD.3 <small>(04/08/2021)</small>

* 🚑💚 Fix CI to pass CI Lint

### 🔖 v1.0.3-RD.2 <small>(04/08/2021)</small>

* Fix markdownlint issues in md files in user_config
* Upgrade CI to better support vcsh repo
* Update gitignore
* Remove useless pinned requirement file in user_config

### 🔖 v1.0.3-RD.1 <small>(13/05/2021)</small>

Simple release to publish Mkdocs Template R. Deville based on v1.0.3 of main
Mkdocs Template.

<!-- markdownlint-disable MD013 -->
{% set mkdocs_template_url = git_platform.url ~ mkdocs_template.git_slug_with_namespace %}
<!-- markdownlint-enable MD013 -->
??? info "Release Note from [mkdocs_template]({{ mkdocs_template_url}})"

    ## 🔖 v1.0

    ### 🔖 v1.0.3 <small>(13/05/2021)</small>

    - 📝 Update documentation content.
    - 🔧 Update extra content through yaml `_data·` files
        - Add new content
        - Add documentation in template files
    - ✨ Improve `plugins.py` behaviour
        - Convert `.format()` string into `f""` string
        - Fix configuration management
    - ⬆📌 Upgrade pinned python dependencies

    ### 🔖 v1.0.2 <small>(29/04/2021)</small>

    - 📝📄 Update copyright in license content
    - ✨ Improve handling of copyright in plugins.py script
    - 🔥 Remove useless file from tracked tree

    ### 🔖 v1.0.1 <small>(29/04/2021)</small>

    - 🐛🍱 Fix wrong assets path in `docs/personal_template/create.md`
    - 🐛 Update `plugins.py` to latest release

    ### 🔖 v1.0.0 <small>(29/04/2021)</small>

    First initial release of MkDocs Template

    - ✨ Add bunch of features:
        - `setup.sh` script to automatically install template,
        - `template` folder holding basic template files, script
          `docs/_data/plugins.py` to dynamically setup `mkdocs.yml` configuration
          and schema and template for files read by the script
    - 🔧 Add bunch of configuration files:
        - Syntax and workflow configuration files such as `.editorconfig`,
          `.yamllint`, `pyproject.toml`
    - 👷 Add CI which test the scripts (bash and python), build the
      documentation and deploy it
    - 📝🍱 Add the documentation describing the usage of the template with needed
      assets.
    - 📄 Add licenses, MIT and Beer-Ware.

