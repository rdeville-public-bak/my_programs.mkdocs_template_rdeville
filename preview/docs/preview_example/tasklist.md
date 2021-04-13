## [Tasklist](https://facelessuser.github.io/pymdown-extensions/extensions/tasklist)

??? info "Tasklist"
    ### Overview

    The Tasklist extension adds GFM style task lists.  They follow the same
    syntax as GFM. Simply start each list item with a square bracket pair
    containing either a space (an unchecked item) or a `x` (a checked item).

    !!! example "Task List Example"

        All task lists in this documentation are generated with [`custom_checkbox`](#options) enabled.

        === "Output"
            Task List

            - [X] item 1
                * [X] item A
                * [ ] item B
                    more text
                    + [x] item a
                    + [ ] item b
                    + [x] item c
                * [X] item C
            - [ ] item 2
            - [ ] item 3


        === "Markdown"
            ```
            Task List

            - [X] item 1
                * [X] item A
                * [ ] item B
                    more text
                    + [x] item a
                    + [ ] item b
                    + [x] item c
                * [X] item C
            - [ ] item 2
            - [ ] item 3
            ```
