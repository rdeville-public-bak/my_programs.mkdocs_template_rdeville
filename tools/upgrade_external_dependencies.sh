#!/usr/bin/env bash
# """Upgrade required external files for mkdocs plugins and PyMDownx
#
# SYNOPSIS:
#   `./upgrade_external_dependencies.sh`
#
# DESCRIPTION:
#
#   Simply download required files, JS, CSS, fonts and images for:
#
#     - [lightgallery.js](https://raw.githubusercontent.com/sachinchoolur/lightgallery.js/master/dist/)
#     - [PyMDownx - Arithmatex](https://facelessuser.github.io/pymdown-extensions/extensions/arithmatex/)
#     - [TableSort](https://squidfunk.github.io/mkdocs-material/reference/data-tables/#sortable-tables)
#     - [PolyFill Library](https://polyfill.io/v3)
#     - [Mermaid](https://mermaid-js.github.io/mermaid/#/)
#
#   To `user_config/docs/theme/` to later be installed to `docs/theme`
#
# """

# Absolute path of the script
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 || return 1; pwd -P )"

# Base URL to download lightgallery files
LG_SOURCE_URL="https://raw.githubusercontent.com/sachinchoolur/lightgallery.js/master/dist/"

# Javascript files
JS_FILES=(
  "${LG_SOURCE_URL}js/lightgallery.js"
  "https://raw.githubusercontent.com/sachinchoolur/lg-video.js/master/dist/lg-video.js"
  "https://raw.githubusercontent.com/sachinchoolur/lg-thumbnail/master/dist/lg-thumbnail.js"
  "https://polyfill.io/v3/polyfill.js"
  "https://cdnjs.cloudflare.com/ajax/libs/tablesort/5.2.1/tablesort.min.js"
  "https://unpkg.com/mermaid/dist/mermaid.js"
)

# CSS files
CSS_FILES=(
  "${LG_SOURCE_URL}css/lightgallery.css"
)

# Font files
FONT_FILES=(
  "${LG_SOURCE_URL}fonts/lg.svg"
  "${LG_SOURCE_URL}fonts/lg.ttf"
  "${LG_SOURCE_URL}fonts/lg.woff"

)

# Image files
IMG_FILES=(
  "${LG_SOURCE_URL}img/loading.gif"
  "${LG_SOURCE_URL}img/vimeo-play.png"
  "${LG_SOURCE_URL}img/video-play.png"
  "${LG_SOURCE_URL}img/youtube-play.png"
)

main()
{
  # """Download a list of files to `docs/theme` to avoid external request
  #
  # Main method downloading list of files that will be put in `docs/theme` to
  # avoid making request to external cdn or external file provider when rendering
  # the website and to serve theme directly.
  #
  # Globals:
  #   JS_FILES
  #   CSS_FILES
  #   IMG_FILES
  #   FONT_FILES
  #
  # Arguments:
  #   None
  #
  # Output:
  #   None
  #
  # Returns:
  #   None
  #
  # """

  download_file()
  {
    # """Download a file to it corresponding `docs/theme` location.
    #
    # Download the file from provided url as first arguments and put it in the
    # right place in `docs/theme/{js,css,img,fonts}` depending on the file type.
    #
    # Globals:
    #   SOURCE_URL
    #
    # Arguments:
    #   $1, string, url of the file to download
    #   $2, string, file type, i.e. subfolder in `docs/theme` where file will be downloaded
    #
    # Output:
    #   Log messages
    #
    # Returns:
    #   None
    #
    # """

    local file_url="$1"
    local file_type="$2"
    local out_file

    out_file="${SCRIPTPATH}/../user_config/docs/theme/${file_type}/$(basename "${file_url}")"

    if ! [[ -d "$(dirname "${out_file}")" ]]
    then
      mkdir -p "$(dirname "${out_file}")"
    fi
    echo "Downloading ${out_file##*${SCRIPTPATH}\/}"
    wget -q "${SOURCE_URL}${i_file}" -O "${out_file}"
  }

  upgrade_mathjax()
  {
    # """Specifically handled the upgrade of mathjax
    #
    # As mathjax requirements is not the same as other, this method handle the
    # upgrade of mathjax only.
    #
    # Globals:
    #   SCRIPTPATH
    #
    # Arguments:
    #   None
    #
    # Output:
    #   None
    #
    # Returns:
    #   None
    #
    # """
    local clone_dir="${SCRIPTPATH}/../user_config/docs/theme/js/mj-tmp"
    local dest_dir="${SCRIPTPATH}/../user_config/docs/theme/js/es5"
    git clone https://github.com/mathjax/MathJax.git "${clone_dir}"
    rm -rf "${dest_dir}"
    mv "${clone_dir}/es5" "${dest_dir}"
    rm -rf "${clone_dir}"
  }

  upgrade_twemoji()
  {
    # """Specifically handled the upgrade of twemoji
    #
    # As twemoji requirements is not the same as other, this method handle the
    # upgrade of twemoji only.
    #
    # Globals:
    #   SCRIPTPATH
    #
    # Arguments:
    #   None
    #
    # Output:
    #   None
    #
    # Returns:
    #   None
    #
    # """
    local clone_dir="${SCRIPTPATH}/../user_config/docs/assets/twemoji-tmp"
    local dest_dir="${SCRIPTPATH}/../user_config/docs/assets/twemoji/svg"
    mkdir -p "${clone_dir}" "${dest_dir}"
    wget https://github.com/twitter/twemoji/archive/master.zip \
      -O "${clone_dir}"/master.zip
    unzip "${clone_dir}"/master.zip -d "${clone_dir}/"
    mv "${clone_dir}"/twemoji-master/assets/svg/* "${dest_dir}"/
    rm -rf "${clone_dir}"
  }

  upgrade_mathjax
  upgrade_twemoji

  for i_file in "${JS_FILES[@]}"
  do
    download_file "${i_file}" "js"
  done

  for i_file in "${CSS_FILES[@]}"
  do
    download_file "${i_file}" "css"
  done

  for i_file in "${IMG_FILES[@]}"
  do
    download_file "${i_file}" "img"
  done

  for i_file in "${FONT_FILES[@]}"
  do
    download_file "${i_file}" "fonts"
  done
}

main "$@"

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
