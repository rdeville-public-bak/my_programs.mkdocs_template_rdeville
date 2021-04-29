<!-- BEGIN MKDOCS TEMPLATE -->
<!--
WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !
Modified content will be overwritten when updating
-->

# Release Notes

<!-- END MKDOCS TEMPLATE -->

## 🔖 v1.0

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

