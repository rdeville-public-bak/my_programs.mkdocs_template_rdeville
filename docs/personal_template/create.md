{% set curr_repo=subs("mkdocs_template") %}
# Create Custom Template

## Fork the main repo

!!! info

    Only forking from [Mkdocs Template Repo][mkdocs_template_repo] on {{
    git_platform.name }} will be described here. If you find a mirror of this
    repo, you can still fork this mirror but documentation of such process will
    not be presented here.

First thing to do is to fork the [Mkdocs Template Repo][mkdocs_template_repo].
To do so, click on the button ++"燎 Fork"++ as shown below:

![!Fork Mkdocs Template][fork_mkdocs_template]

Then, choose where you want to store your fork from your accessible namespace:

![!Fork Mkdocs Template Destination][fork_mkdocs_template_dest]

Wait for the fork to finish:

![!Fork Mkdocs Template Finish][fork_mkdocs_template_finish]

Finally, you can clone your forked.

!!! note

    In the rest of documentation we will assume you forked the main repo to
    https://gitdomain.tld/namespace/mkdocs_template.git.

```bash
# Clone using https
git clone https://gitdomain.tld/namespace/mkdocs_template.git.
# Clone using ssh
git clone git@gitdomain.tld:namespace/mkdocs_template.git.
```

[mkdocs_template_repo]: {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}
[fork_mkdocs_template]: /assets/img/fork_main_repo.png
[fork_mkdocs_template_dest]: /assets/img/fork_dest_namespace.png
[fork_mkdocs_template_finish]: /assets/img/fork_finish.png

## Add the content of your template

Now, to setup your own template, you just have to write it in the empty folder
but track `user_config` folder. If you happen to add a file with the same path
from `template`, the your file will override the one in `template`.

For instance, if you create a file `user_config/docs/index.md`, its content will
override the content of the file `template/docs/index.md` when using template.

Moreover, you can add a `post_setup.sh` script in `user_config` to handle
customized command once `setup.sh` finish.

Below are some examples such as a possible structure of `user_config` folder as
well as some content exaple. Note that every files, hidden or not, within folder
`user_config` are copied when installed, which can be usefull to provide
configuration workflow files, such as `.editorconfig`, `.gitignore`, etc. files.

=== "Folder `user_config`"

    ```text
    ├──  .editorconfig
    ├──  .gitignore
    ├──  .gitkeep
    ├──  .gitlab-ci.yml
    ├──  .yamllint
    ├──  docs
    │  ├──  .gitlab-ci.yml
    │  ├──  _data
    │  │  └──  vars.yaml
    │  ├──  about
    │  │  ├──  code_of_conduct.md
    │  │  ├──  contributing.md
    │  │  ├──  data_privacy.md
    │  │  ├──  index.md
    │  │  ├──  license.md
    │  │  └──  release_notes.md
    │  ├──  index.md
    │  └──  theme
    │     ├──  css
    │     │  └──  theme.css
    │     └──  js
    │        └──  extra.js
    ├──  LICENSE.BEERWARE
    ├──  LICENSE.MIT
    ├──  mkdocs.local.yml
    ├──  post_setup.sh
    ├──  pyproject.toml
    ├──  README.md
    ├──  requirements.dev.in
    ├──  requirements.dev.txt
    ├──  requirements.docs.in
    └──  requirements.docs.txt
    ```

=== "`README.md`"

    Below is the templated content of a README.md which is automatically updated
    with the script `post_setup.sh`

    ````markdown
    <div align="center" style="text-align: center;">

      <!-- Project Title -->
      <a href="<TPL:REPO_URL>">
        <img src="docs/assets/img/meta/<TPL:REPO_NAME>_logo.png" width="100px">
        <h1><TPL:REPO_NAME_FIRST_UPPERCASE></h1>
      </a>

      <!-- Project Badges -->
      [![License][license_badge]][license]
      [![Build Status][build_status_badge]][build_status]

    --------------------------------------------------------------------------------

    TODO: Short description as written in `docs/_data/repo.yaml`

    --------------------------------------------------------------------------------

      <b>
    IMPORTANT !

    Main repo is on [ Framagit][repo_url].<br>
    On other online git platforms, they are just mirror of the main repo.<br>
    Any issues, pull/merge requests, etc., might not be considered on those other
    platforms.
      </b>
    </div>

    --------------------------------------------------------------------------------

    [repo_url]: <TPL:REPO_URL>
    [license_badge]: https://img.shields.io/badge/License-MIT%2FBeer%20Ware-blue?style=flat-square&logo=open-source-initiative
    [license]: LICENSE
    [build_status_badge]: <TPL:REPO_URL>/badges/master/pipeline.svg?style=flat-square&logo=appveyor
    [build_status]: <TPL:REPO_URL>/commits/master

    ## Table of Content

    * [Project Documentation](#project-documentation)

    <!-- BEGIN MKDOCS TEMPLATE -->
    <!--
         WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !
         Modified content will be overwritten when updating
    -->

    ## Project Documentation

    The complete documentation of the project can be accessed via its [Online
    Documentation][online_doc].

    If, for any reason, the link to the [Online Documentation][online_doc] is
    broken, you can generate its documention locally on your computer (since the
    documentation is jointly stored within the repository).

    To do so, you will need the following requirements:

      - Python >= 3.8
      - Pip3 with Python >= 3.8

    First setup a temporary python virtual environment and activate it:

    ```bash
    # Create the temporary virtual environment
    python3 -m venv .temporary_venv
    # Activate it
    source .temporary_venv/bin/activate
    ```

    Now, install required dependencies to render the documentation using
    [mkdocs][mkdocs] in the python virtual environment:

    ```bash
    pip3 install -r requirements.docs.txt
    ```

    Now you can easily render the documentation using [mkdocs][mkdocs] through the
    usage of the following command (some logs will be outputed to stdout):

    ```bash
    # Assuming you are at the root of the repo
    # If there is a `mkdocs.local.yml`
    mkdocs serve -f mkdocs.local.yml
    # If there is no `mkdocs.local.yml`, only `mkdocs.yml`
    mkdocs serve
    ```

    You can now browse the full documentation by visiting
    [http://localhost:8000][localhost].

    [localhost]: https://localhost:8000
    [mkdocs]: https://www.mkdocs.org/

    <!-- END MKDOCS TEMPLATE -->

    [online_doc]: <TPL:REPO_ONLINE_DOC_URL>/index.html
    ```
    ````

=== "`docs/theme/js/extra.js`"

    ```javascript
    /*
     * LIGHTGALLERY
     * ----------------------------------------------------------------------------
     * Lightgallery extra javascript
     * From: https://github.com/g-provost/lightgallery-markdown
     */

    /*
     * Loading lightgallery
     */
    var elements = document.getElementsByClassName("lightgallery");
    for(var i=0; i<elements.length; i++) {
      lightGallery(elements[i]);
    }

    /*
     * Loading video plugins for lightgallery
     */
    lightGallery(document.getElementById('html5-videos'));

    /*
     * Loading parameter to auto-generate thumbnails for vimeo/youtube video
     */
    lightGallery(document.getElementById('video-thumbnails'), {
        loadYoutubeThumbnail: true,
        youtubeThumbSize: 'default',
        loadVimeoThumbnail: true,
        vimeoThumbSize: 'thumbnail_medium',
    });

    /*
     * Table Sort
     * ----------------------------------------------------------------------------
     * Code snippet to allow sorting table
     * From: https://squidfunk.github.io/mkdocs-material/reference/data-tables/#sortable-tables
     */
    document$.subscribe(function() {
      var tables = document.querySelectorAll("article table")
      tables.forEach(function(table) {
        new Tablesort(table)
      })
    })


    /*
     * Mermaid Configuration to support dark/light switching
     * ----------------------------------------------------------------------------
     * Table Sort
     * Optional config
     * If your document is not specifying `data-md-color-scheme` for color schemes
     * you just need to specify `default`.
     */
    window.mermaidConfig = {
      "rdeville-light": {
        startOnLoad: false,
        theme: "default",
        flowchart: {
          htmlLabels: false
        },
        er: {
          useMaxWidth: false
        },
        sequence: {
          useMaxWidth: false,
          /*
           * Mermaid handles Firefox a little different. For some reason, it
           * doesn't attach font sizes to the labels in Firefox. If we specify the
           * documented defaults, font sizes are written to the labels in Firefox.
           */
          noteFontWeight: "14px",
          actorFontSize: "14px",
          messageFontSize: "16px"
        }
      },
      "rdeville-dark": {
        startOnLoad: false,
        theme: "dark",
        flowchart: {
          htmlLabels: false
        },
        er: {
          useMaxWidth: false
        },
        sequence: {
          useMaxWidth: false,
          noteFontWeight: "14px",
          actorFontSize: "14px",
          messageFontSize: "16px"
        }
      }
    }
    ```

=== "`docs/about/contributing.md`"

    ```markdown
    {% raw %}
    {% set curr_repo=subs("TODO") %}

    <!-- BEGIN MKDOCS TEMPLATE -->
    <!--
    WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !
    Modified content will be overwritten when updating
    -->

    # Contributing

    This project welcomes contributions from developers and users in the open source
    community. Contributions can be made in a number of ways, a few examples are :

      * Code patch via pull requests
      * Documentation improvements
      * Bug reports and patch reviews
      * Proposition of new features
      * etc.

    ## Reporting an Issue

    Please include as much details as you can when reporting an issue in the [issue
    trackers][issue_tracker]. If the problem is visual (for instance, wrong
    documentation rendering) please add a screenshot.

    [issue_tracker]: {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}/-/issues

    ## Submitting Pull Requests

    Once you are happy with your changes or you are ready for some feedback, push it
    to your fork and send a pull request. For a change to be accepted it will most
    likely need to have tests and documentation if it is a new feature.

    For more information, you can refers to the main [developers
    guides][developers_guides] which is the common resources I use for all
    my projects. There you will find:

      * [Syntax Guide][syntax_guide], which describe syntax guidelines per language
        to follow if you want to contribute.
      * [Contributing workflow][contributing_workflow], which provide an example
       of the workflow I used for the development.

    [developers_guides]: {{ site_base_url }}/dev_guides/index.html
    [syntax_guide]: {{ site_base_url }}/dev_guides/style_guides/index.html
    [contributing_workflow]: {{ site_base_url }}/dev_guides/contributing_workflow.html

    ## Community

    Finally, every member of the community should follow this [Code of
    conduct][code_of_conduct].

    [code_of_conduct]: code_of_conduct.md

    <!-- END MKDOCS TEMPLATE -->
    {% endraw %}
    ```


## Preview your template

When working on your custom template you might want to see a preview of your
template. To do so, simply call the script `preview.sh`

```bash
# Assuming you are at the root of the mkdocs template repo
./preview.sh
```

!!! note

    You might need to do so more command, such as copying repo file do
    `preview/docs/_data/mkdocs_template.yaml` or more. This will be prompted as
    error or warning when rendering preview.

This will compute the final list of files that will be installed, i.e. the union
of content of `template` and `user_config` folder, such that content of
`user_config` override content of `template`. Then create a symlink to each
final file in `preview` folder. Finally, render the documentation to
[http://localhost:8000][localhost]

[localhost]: http://localhost:8000

## Keep track with the main repo

If you want to update your fork to have the last version of the main repo, you
will first need to add a remote pointing to the main repo on
[{{ git_platform.name }}][repo_url].

First, list the current remote to ensure that remote `upstream` does not exists
yet:

```bash
git remote -v
> origin <URL_TO_YOUR_ORIGIN_REMOTE> (fetch)
> origin <URL_TO_YOUR_ORIGIN_REMOTE> (push)
```

If there is not upstream, add the `upstream` remote:

```bash
git remote add upstream {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}.git
```

Ensure that the remote upstream is well sets:

```bash
git remote -v
> origin <URL_TO_YOUR_ORIGIN_REMOTE> (fetch)
> origin <URL_TO_YOUR_ORIGIN_REMOTE> (push)
> upstream {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}.git (fetch)
> upstream {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}.git (push)
```

Once done, fetch branches from this `upstream` remote, commit to `master` of
the main repo will be stored in local branch `upstream/master`:

```text
git fetch upstream
> remote: Counting objects: 75, done.
> remote: Compressing objects: 100% (53/53), done.
> remote: Total 62 (delta 27), reused 44 (delta 9)
> Unpacking objects: 100% (62/62), done.
> From {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}.git
>  * [new branch]      master     -> upstream/master*
```

Check out your fork's local `master` branch.

```text
git checkout master
> Switched to branch 'master'
```

Merge the changes from `upstream/master` into your local `master` branch. This
brings your fork's `master` branch into sync with the `upstream` repository,
without losing your local changes.

```text
git merge upstream/master
> Updating a422352..5fdff0f
> Fast-forward
>  README                    |    9 -------
>  index.md                  |    7 ++++++
>  2 files changed, 7 insertions(+), 9 deletions(-)
>  delete mode 100644 README
>  create mode 100644 index.md
```

If your local branch didn't have any unique commits, Git will instead perform a
"fast-forward":

```text
git merge upstream/master
> Updating 34e91da..16c56ad
> Fast-forward
>  index.md                 |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
```

Here you are up-to-date with the main repo :wink:.

[repo_url]: {{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}
