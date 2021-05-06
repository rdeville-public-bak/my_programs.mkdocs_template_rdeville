<div align="center" style="text-align: center;">

  <!-- Project Title -->
  <a href="https://framagit.org/rdeville.public/my_programs/mkdocs_template">
    <img src="docs/assets/img/meta/mkdocs_template_logo.png" width="100px">
    <h1>Mkdocs Template</h1>
  </a>

  <!-- Project Badges -->
  [![License][license_badge]][license]
  [![Build Status][build_status_badge]][build_status]

--------------------------------------------------------------------------------

Mkdocs Templates scaffolding project to host documentation configuration
and themes to manage homogenous documentation accros multiple projects.

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

[repo_url]: https://framagit.org/rdeville.public/my_programs/mkdocs_template
[license_badge]: https://img.shields.io/badge/License-MIT%2FBeer%20Ware-blue?style=flat-square&logo=open-source-initiative
[license]: LICENSE
[build_status_badge]: https://framagit.org/rdeville.public/my_programs/mkdocs_template/badges/master/pipeline.svg?style=flat-square&logo=appveyor
[build_status]: https://framagit.org/rdeville.public/my_programs/mkdocs_template/commits/master

## Table of Content

* [Introduction](#introduction)
* [Usage](#usage)
* [Project Documentation](#project-documentation)

## Introduction

Since some times now, I use [mkdocs][mkdocs] to write documentation of my
projects.

While [mkdocs][mkdocs] is a really usefull software allowing me to
write clean and clear documentation in markdown and render it as static
website, I was tired to always copy/paste same configuration accross all my
project documentations.

Even worst, when I decide to change some minor things (such as color palettes),
I had to go to each project and for each project I had to replace manually
every time the same two configuration lines.

This project aim is to ease the management of documentation configuration by
allowing to create a template and easily setup or upgrade it to a newer
version.

## Usage

Assuming you want to use this **really** basic template. In a repo in which you
want to create a documentation, type the following commands:

```bash
# ASSUMING YOU ARE IN THE REPO FOR WHICH YOU WANT TO WRITE A DOCUMENTATION
# First download the setup script into a temporary folder
wget \
   https://framagit.org/rdeville.public/my_programs/mkdocs_template/-/raw/master/setup.sh \
   -O /tmp/setup_mkdocs.sh
# Then read the content of the script with your favorite editor
vim /tmp/setup_mkdocs.sh
# If you are confident with what the script does, make it executable and run it
chmod +x /tmp/setup_mkdocs.sh
/tmp/setup_mkdocs.sh -r https://framagit.org/rdeville.public/my_programs/mkdocs_template
```

Or if you already read the content of the script `setup.sh` at the root of this
repo, previous commands can be done in one line:

```
# ASSUMING YOU ARE IN THE REPO FOR WHICH YOU WANT TO WRITE A DOCUMENTATION
# You can get the content of the script setup.sh via curl and pipe it into bash
curl -sfL \
   https://framagit.org/rdeville.public/my_programs/mkdocs_template_rdeville/-/raw/master/setup.sh \
   | bash -s -- -r https://framagit.org/rdeville.public/my_programs/mkdocs_template_rdeville
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

This is the basic usage of the template, but you might want to provide your own
configuration (such as other color palette or add a default license). This will
be explain in the [Online Documentation][online_doc].


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

[online_doc]: https://docs.romaindeville.fr/my_programs/mkdocs_template/index.html
