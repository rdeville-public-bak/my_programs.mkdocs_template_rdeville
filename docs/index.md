---
hide:
  - navigation # Hide navigation
  - toc        # Hide table of contents
---

{% set curr_repo=subs("mkdocs_template") %}

<!-- BEGIN MKDOCS TEMPLATE -->
<!--
WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !
Modified content will be overwritten when updating
-->

<div align="center">

  <!-- Project Title -->
  <a href="{{ git_platform.url }}{{ curr_repo.repo_path_with_namespace }}">
    <img src="{{ curr_repo.logo }}" width="200px">
    <h1>{{ curr_repo.name }}</h1>
  </a>

<hr>

{{ to_html(curr_repo.desc) }}

<hr>

  <b>
IMPORTANT !<br>

Main repo is on
<a href="{{ git_platform.url }}{{ curr_repo.git_slug_with_namespace }}">
  {{ git_platform.name }} - {{ curr_repo.git_name_with_namespace }}</a>.<br>
On other online git platforms, they are just mirrors of the main repo.<br>
Any issues, pull/merge requests, etc., might not be considered on those other
platforms.
  </b>

</div>

<!-- END MKDOCS TEMPLATE -->

## Introduction

Since some times now, I use [mkdocs][mkdocs] to write documentation of my
projects.

While [mkdocs][mkdocs] is a really usefull software allowing me to write clean
and clear documentation in markdown and render it as static website, I was tired
to always copy/paste same configuration accross all my projects documentations.

Even worst, when I decide to change some minor things (such as color palettes),
I had to go to each projects and for each project I had to replace manually
every time the same two configuration lines.

This project aims is to ease the management of documentation configuration by
allowing to create a template and easily setup or upgrade it to a newer version.

## Usage

Below is a really basic usage example of this repo, more complete documentation
is provided at section [Use Template][use_template] and if you want to create
your own template from this repo, you can refer to the section [Setup Your Own
Template][setup_your_own_template]

Assuming you want to use this **really** basic template. In a repo in which you
want to create a documentation, type the following commands:

```bash
# ASSUMING YOU ARE IN THE REPO FOR WHICH YOU WANT TO WRITE A DOCUMENTATION
# First download the setup script into a temporary folder
wget {{ git_platform.url }}{{ curr_repo.repo_path_with_namespace }}/-/raw/master/setup.sh \
   -O /tmp/setup_mkdocs.sh
# Then read the content of the script with your favorite editor
vim /tmp/setup_mkdocs.sh
# If you are confident with what the script does, make it executable and run it
chmod +x /tmp/setup_mkdocs.sh
/tmp/setup_mkdocs.sh -r {{ git_platform.url }}{{ curr_repo.repo_path_with_namespace }}
```

Or if you already read the content of the script `setup.sh` at the root of this
repo, previous commands can be done in online:

```bash
# ASSUMING YOU ARE IN THE REPO FOR WHICH YOU WANT TO WRITE A DOCUMENTATION
# You can get the content of the script setup.sh via curl and pipe it into bash
curl -sfL {{ git_platform.url }}{{ curr_repo.repo_path_with_namespace }}/-/raw/master/setup.sh \
   | bash -s -- -r {{ git_platform.url }}{{ curr_repo.repo_path_with_namespace }}
```

This will automatically create the folder `docs` with basic pages and the
following files:

- `mkdocs.yml`
- `requirements.docs.in`
- `requirements.docs.txt`

What you will now have to do is :

- Copy the provided template file `docs/_data/template/repo.tpl.yaml` into
  `docs/_data/repo_name.yml` such as `repo_name` is the slug of your repo (for
  instance slug of `mkdocs template` is `mkdocs_template` and slug of
  `docs.domain.tld project` is `docs_domain_tld_project`).
- Edit this new file `docs/_data/repo_name.yml`, especially, do not forget to
  change the key `repo_name` in the file accordingly to your repo slug.

You are ready now to render you documentation:

```bash
mkdocs serve
```

[use_template]: usage/
[setup_your_own_template]: personal_template

<!-- URL used in mulitple section -->
[mkdocs]: https://mkdocs.org/
