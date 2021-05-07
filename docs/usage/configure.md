# Configuration of the documentation

Once you have installed files using the script `setup.sh`, and before starting
to render your documentation you will need some configuration to do:

## Base mkdocs configuration

Normally, most configuration of `mkdocs` is done in `mkdocs.yml` file, but to be
able to use a templated `mkdocs.yml`, most of the configuration is handled
differently.

Now, it is the file `templates/docs/_data/plugins.py` which will handle the
configuration. This file is automatically called with the
[`mkdocs-macros-plugins`][mkdocs_macros_plugins]. So, if you want to overload
mkdocs configuration value, this is done through the file
`docs/_data/vars.yaml`. An example of such content is provided in
`docs/_data/template/vars.tpl.yaml`.

```bash
# Assuming you are at the root of the folder where you installed the documentation
cp docs/_data/template/vars.tpl.yaml docs/_data/vars.yaml
# Now edit the content of the copied file with your favorite editor
vim docs/_data/vars.yaml
```

The file is heavily commented allowing you to know what you are updating. Note
that this part is optional, as most of the `mkdocs.yml` configuration is
automatically set based on the git repo information (git remote **origin**) and
[repo variables](#repo-variables).

[mkdocs_macros_plugins]: https://mkdocs-macros-plugin.readthedocs.io/en/latest/

## Repo variables

!!! important "Ensure a git remote **origin** exists"

    Before continuing, your documentation **MUST** be a git repository with a
    remote **origin**. Indeed, the script `docs/_data/plugins.py` will get
    remote information to have the `repo_slug` to know which file in
    `docs/_data/` hold the repository information.

So assuming that your remote **origin** is
`https://mygit.tld/namespace/my_repo_slug.git` (this work also for ssh remote).
You will need to copy the template provided in `docs/_data/template/repo.tpl.yaml`
in `docs/_data/my_repo_slug` and then update its content:

```bash
# Assuming you are at the root of the repo holding the documentation
cp docs/_data/template/repo.tpl.yaml docs/_data/my_repo_slug.yaml
# Then edit the content of the file with your favorite editor
vim docs/_data/my_repo_slug.yaml
```

You will need to update some keys in the repo file which will be used to
automatically set `mkdocs.yml` configuration if not set in
`docs/_data/vars.yaml`.

For instance key `my_repo_slug['name']` will be used to dynamically set
`site_name` key of the `mkdocs.yml`.

Below is an example of such file:

```yaml
# Repo information
# ===========================================================================
# First key MUST be the "slug" of the repo based on the remote, i.e. if remote
# is git@git.domain.tld:username/repo_name.git, then the key will be
# `repo_name`.
my_repo_slug:

  # An explicit name for the repo that will be shown on the documentation
  # page.
  name: "The Best Repo Name in the World"

  # (OPTIONATL) An extension of the explicit name with the namespace in which
  # the repo is. For instance, using above remote, the entry will be
  # `Username / Repo Name`.
  # This entry is not used in the configuration of mkdocs.
  #git_name_with_namespace: "Namespace / My Repo Name"

  # The complete path of the repo from the git_platform["url"]. For instance,
  # using, above remote, the entry will be `username/repo_name.git`
  git_slug_with_namespace: "namespace/my_repo_slug.git"

  # If the repo documentation is part of a bigger repo, then provide the
  # path of the rendered documentation. If the documentation is not part of
  # another repo, leave it empty.
  #url_slug_with_namespace: "subpath_for_url_renderin/repo_slug"

  # (OPTIONAL) Path, relative to `docs_dir` mkdocs config, to the logo of the
  # repo. If not specified, path will automatically be set to
  # `assets/img/meta/repo_name_logo.png`
  #logo: "assets/img/meta/repo_name_logo.png"

  # Description of the repo, will be used to setup the mkdocs description.
  desc: >-
    An explicit description to explain what my repo do. Can be a multiline
    description with **markdown** support such as
    [link](https://url.domain.tld) and more.

  # (OPTIONAL) If you plan to use `mkdocstring` plugins to render python
  # source code, you will need to provide the path where your source files
  # are relative to the root of the repo.
  #src_path:
  #  - "src"

  # List of informations about the main maintainers that will be automatically
  # added to the license file in `docs/about/license.md`
  maintainers:
    - name: "Firstname Lastname"
      mail: "mail@domain.tld"
```

## Subrepo Variables

If you are working on a big project, with multiple subrepo you might have or
want to split the documentation such as each project hold its own but render all
of them from a master repository.

An example could be an [ansible collection][ansible_collection] which can be
composed of a master repository holding specific files and folders holdings
things like roles, etc. In this case, you might want to keep roles in other git
repository (like git submodules) and each of the role holds its own
documentation. But you want the final rendered documentation to include these
repos.

This can be done via a file describing such subrepo, i.e. the file
`docs/_data/subrepo.yaml`. To do so, copy the template provided in
`docs/_data/template/subrepo.tpl.yml`.

```bash
# Assuming you are at the root of the folder where you installed the documentation
cp docs/_data/template/subrepo.tpl.yaml docs/_data/subrepo.yaml
# Edit the content of the file with your favorite editor
vim docs/_data/subrepo.yaml
```

Below is an example of file `docs/_data/subrepo.yml` for an ansible collection
which roles are in folder `roles` at the root of the repo and such that roles
documentation are include in the final documentation.

```yaml
subrepo:
  # Folder where there are subrepo
  roles:
    # Nav entry in mkdocs.yml from where the roles documentations will be
    # include. If the entry does not exists, it will be automatically added at
    # the end of the `nav`
    nav_entry: "Roles"
      # Specify that the role will be include to the final documentation
      internal:
        # Provide a list of repo information
        - name: role_name_1
          nav_entry: My Role 1
          # You can provided both https or ssh url, but https is prefered for CI
          # to better work
          git_url: https://gitdomain.tld/namespace/subnamespace/my_role_name_1
        - name: role_name_2
          nav_entry: My Role 2
          # You can provided both https or ssh url, but https is prefered for CI
          # to better work
          git_url: https://gitdomain.tld/namespace/subnamespace/my_role_name_2
```

If you want to add link to external documentation, i.e. a link to the home page
will be included in the `nav` of the main repo but their own `nav` will not be
included, this can also be done with the file `docs/_data/subrepo.yaml`.

An example could be a main repo simply providing entry point to other repos,
such as repo holding base content of
[docs.romaindeville.fr][docs.romaindeville.fr]. Below is an example of the
content of such `subrepo.yaml` file:


```yaml
subrepo:
  # Folder where there are subrepo
  programs:
    # Nav entry in mkdocs.yml from where the roles documentations will be
    # include. If the entry does not exists, it will be automatically added at
    # the end of the `nav`
    nav_entry: "My Programs"
      # Specify repos which documentation will be external
      external:
        # Provide a list of repo information
        - name: my_first_repo
          nav_entry: Example of First External repo
          # You can provided both https or ssh url, but https is prefered for CI
          # to better work
          git_url: https://gitdomain.tld/namespace/subnamespace/my_first_repo.git
          # Link to the external documentation, can be relative to the root of
          #the documentation of a full https link.
          online_url: /relative/to/root/documentation/
        - name: my_second_repo
          nav_entry: Example of Second External repo
          # You can provided both https or ssh url, but https is prefered for CI
          # to better work
          git_url: https://gitdomain.tld/namespace/subnamespace/my_second_repo.git
          # Link to the external documentation, can be relative to the root of
          #the documentation of a full https link.
          online_url: https://domain.tld/full/external/link/
```

Of course, both `internal` and `external` can be used as shown below (click to
reveal).

??? Example

    ```yaml
    subrepo:
      # Folder where there are subrepo
      roles:
        # Nav entry in mkdocs.yml from where the roles documentations will be
        # include. If the entry does not exists, it will be automatically added at
        # the end of the `nav`
        nav_entry: "Roles"
          # Specify that the role will be include to the final documentation
          internal:
            # Provide a list of repo information
            - name: role_name_1
              nav_entry: My Role 1
              # You can provided both https or ssh url, but https is prefered for CI
              # to better work
              git_url: https://gitdomain.tld/namespace/subnamespace/my_role_name_1
            - name: role_name_2
              nav_entry: My Role 2
              # You can provided both https or ssh url, but https is prefered for CI
              # to better work
          # Specify repos which documentation will be external
          external:
            # Provide a list of repo information
            - name: my_first_role
              nav_entry: Example of First External Role
              # You can provided both https or ssh url, but https is prefered for CI
              # to better work
              git_url: https://gitdomain.tld/namespace/subnamespace/my_first_role.git
              # Link to the external documentation, can be relative to the root of
              #the documentation of a full https link.
              online_url: /relative/to/root/documentation/
      programs:
        nav_entry: "My Programs"
          # Specify repos which documentation will be external
          external:
            # Provide a list of repo information
            - name: my_first_repo
              nav_entry: Example of First External repo
              # You can provided both https or ssh url, but https is prefered for CI
              # to better work
              git_url: https://gitdomain.tld/namespace/subnamespace/my_first_repo.git
              # Link to the external documentation, can be relative to the root of
              #the documentation of a full https link.
              online_url: /relative/to/root/documentation/
            - name: my_second_repo
              nav_entry: Example of Second External repo
              # You can provided both https or ssh url, but https is prefered for CI
              # to better work
              git_url: https://gitdomain.tld/namespace/subnamespace/my_second_repo.git
              # Link to the external documentation, can be relative to the root of
              #the documentation of a full https link.
              online_url: https://domain.tld/full/external/link/
    ```

Thus, when rendering the documentation, the script `docs/_data/plugins.py` will
check if folders `roles/{role_name_1,role_name_2}` exists. If they exists and
are git repo, script will pull them to get the last version. If they do not
exists, the will be cloned.

Finally, the script `docs/_data/plugins.py` will update the `nav` of the
documentation with these repos and will load file `docs/_data/repo.yaml`
of each repo allowing to access to the repo informations.


## Extra variables

All of the above files will create variables which can be used in your
documentation using [mkdocs-macros-plugin][mkdocs-macros-plugin]. If you want to
add extra variables which are not in `vars.yaml`, nor `repo.yaml`, neither in
`subrepo.yaml`, you can do it by settings them in a file
`docs/_data/extra.yaml`. Indeed, previously mentionned filed will be checked
against a schema (provided in `docs/_data/{repo,subrepo,vars}.schema.yaml`),
thus do not allow extra variables to ensure stability of script
`docs/_data/plugins.py` while file `docs/_data/extra.yaml` is loaded as it is
without schema control.

[mkdocs-macros-plugin]: https://mkdocs-macros-plugin.readthedocs.io/en/latest/

## Variable usage

Finally, as describe above some variables are used for the configuration to
render documentation. But they can also be use in your markdown documentation
files using jinja template. For instance, below is a basic content of a markdown
file showing the name of the main repo, its description and a list of roles and
programs with their description.

=== "Markdown"

    ```jinja
    {% raw %}
    <!-- Print the name of the repo -->
    # {{ my_repo_slug.name }}

    <!-- Print the desc of the repo -->
    {{ my_repo_slug.desc }}

    <!-- Print a section and a table with repo information from subrepo -->
    {%- for i_key in subrepo %}
    <!-- Print the title of the section from `nav_entry` in subrepo -->
    # {{ subrepo[i_key].nav_entry }}

    <!-- Start the table with repo information -->
    | Name | Description |
    | ---- | ----------- |
    {%-   for i_repo_type in subrepo[i_key] %}
    {%-     if i_repo_type in ("external","internal") %}
    {%-       for i_repo in subrepo[i_key][i_repo_type] %}
    {# Get the content of the dictionary #}
    {%-     set curr_repo = subs(i_repo.name) %}
    | {{ curr_repo.name }} | {{ curr_repo.desc }}
    {%-       endfor %}
    {%-     endif %}
    {%-   endfor %}
    {%- endfor %}
    {% endraw %}
    ```
=== "Rendered HTML"

    # {{ example.my_repo_slug.name }}

    {{ example.my_repo_slug.desc }}

    {%- for i_key in example.subrepo %}

    ## {{ example.subrepo[i_key].nav_entry }}

    | Name | Description |
    | ---- | ----------- |
    {%-   for i_repo_type in example.subrepo[i_key] %}
    {%-     if i_repo_type in ("external","internal") %}
    {%-       for i_repo in example.subrepo[i_key][i_repo_type] %}
    {#- Get the content of the dictionary #}
    {%-         set curr_repo = subs(i_repo.name) %}
    | {{ curr_repo.name }} | {{ curr_repo.desc }} |
    {%-       endfor %}
    {%-     endif %}
    {%-   endfor %}
    {%- endfor %}


You are now ready to write your documentation. Juste remember **to not update**
content between markdown tags.

Moreover, later the main template may get upgraded (like adding new feature or
providing new template content), to automatically apply this upgrade to your
documentation see [Upgrade][upgrade].

And finally, you may want to provide your own template, with custom CSS for
instance, or pre-fill index documentation page, to do so, set [Setup Your Own
Template][setup_your_own_template]

[ansible_collection]: https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html#collection-structure
[docs.romaindeville.fr]: {{ site_base_url }}
[upgrade]: upgrade.md
[setup_your_own_template]: ../personal_template/index.md
