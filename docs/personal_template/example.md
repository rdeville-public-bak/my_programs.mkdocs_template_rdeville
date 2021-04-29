{% set curr_repo=subs("mkdocs_template") %}
# Example

This current documentation you are reading is actually using the custom template
[Mkdocs Template R.Deville][mkdocs_template_rdeville].

This custom template add a lots of things such as :

  - `.gitlab-ci.yaml` with basic CI file at the root of the repo to later be
    extended and another CI file to only test and build the documentation,
  - Workflow files definining some syntax rules such as `.editorconfig`,
    `.yamllint`, `pyproject.toml` (which also define basic test using `tox`),
  - `README.md`, a template of README which is automatically updated with the
    script `post_setup.sh`,
  - `mkdocs.yml` with more plugins and more configuration than the basic file.
  - A default `docs/_data/vars.yaml` file,
  - A complete theme using new plugins defined in `mkdocs.yml` with custom CSS,
    javascript, images, etc.,
  - A predefined basic `docs` content,
  - And many more things.

Below is an example of the rendering of the preview of the basic template and
the custom template.


=== "Basic Template"

    ![!Basic Template Preview][basic_template_preview]


=== "Custom Template"

    ![!Custom Template Preview][custom_template_preview]

[mkdocs_template_rdeville]: {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}_rdeville
[basic_template_preview]: /assets/img/basic_template_preview.png
[custom_template_preview]: /assets/img/custom_template_preview.png

