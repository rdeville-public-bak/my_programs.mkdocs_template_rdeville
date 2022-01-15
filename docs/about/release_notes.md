<!-- BEGIN MKDOCS TEMPLATE -->
<!--
WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !
Modified content will be overwritten when updating
-->

# Release Notes

<!-- END MKDOCS TEMPLATE -->

## 🔖 v1.0

### 🔖 v1.0.6 <small>(15/01/2022)</small>

  * 🐛 Fix bug where when upgrading not escaping sed char.

### 🔖 v1.0.5 <small>(08/12/2021)</small>

  * ⬆📝 Upgrade documentation content from v1.0.4-RD.2 template

### 🔖 v1.0.4 <small>(07/12/2021)</small>

  * 🚨 Fix pylint and shellcheck warning
  * ⬆🔧 Upgrade dependencies and config
  * ⬆ Update template dependencies and configuration
  *   Fix link from rdeville.private to public

### 🔖 v1.0.3 <small>(13/05/2021)</small>

  * 📝 Update documentation content.
  * 🔧 Update extra content through yaml `_data·` files
    * Add new content
    * Add documentation in template files
  * ✨ Improve `plugins.py` behaviour
    * Convert `.format()` string into `f""` string
    * Fix configuration management
  * ⬆📌 Upgrade pinned python dependencies

### 🔖 v1.0.2 <small>(29/04/2021)</small>

  * 📝📄 Update copyright in license content
  * ✨ Improve handling of copyright in plugins.py script
  * 🔥 Remove useless file from tracked tree

### 🔖 v1.0.1 <small>(29/04/2021)</small>

  * 🐛🍱 Fix wrong assets path in `docs/personal_template/create.md`
  * 🐛 Update `plugins.py` to latest release

### 🔖 v1.0.0 <small>(29/04/2021)</small>

First initial release of MkDocs Template

  * ✨ Add bunch of features:
    * `setup.sh` script to automatically install template,
    * `template` folder holding basic template files, script
      `docs/_data/plugins.py` to dynamically setup `mkdocs.yml` configuration
      and schema and template for files read by the script
  * 🔧 Add bunch of configuration files:
    * Syntax and workflow configuration files such as `.editorconfig`,
      `.yamllint`, `pyproject.toml`
  * 👷 Add CI which test the scripts (bash and python), build the
    documentation and deploy it
  * 📝🍱 Add the documentation describing the usage of the template with needed
    assets.
  * 📄 Add licenses, MIT and Beer-Ware.

