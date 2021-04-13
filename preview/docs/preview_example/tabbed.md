## [Tabbed](https://facelessuser.github.io/pymdown-extensions/extensions/tabbed)

??? info "Tabbed"

    ### Examples

    Tabs start with `===` to signify a tab followed by a quoted title.
    Consecutive tabs are grouped into a tab set.

    !!! example "Example Tabs"

        === "Output"
            === "Tab 1"
                Markdown **content**.

                Multiple paragraphs.

            === "Tab 2"
                More Markdown **content**.

                - list item a
                - list item b

        === "Markdown"
            ```
            === "Tab 1"
                Markdown **content**.

                Multiple paragraphs.

            === "Tab 2"
                More Markdown **content**.

                - list item a
                - list item b
            ```

    In the rare case that you want to follow two separate tab sets right after
    each other, you can explicitly mark the start of a new tab set with `!`.


    !!! example "Example Tab Breaks"

        === "Output"
            === "Tab 1"
                Markdown **content**.

                Multiple paragraphs.

            === "Tab 2"
                More Markdown **content**.

                - list item a
                - list item b

            ===! "Tab A"
                Different tab set.

            === "Tab B"
                ```
                More content.
                ```

        === "Markdown"

            ```
            === "Tab 1"
                Markdown **content**.

                Multiple paragraphs.

            === "Tab 2"
                More Markdown **content**.

                - list item a
                - list item b

            ===! "Tab A"
                Different tab set.

            === "Tab B"
                ```
                More content.
                ```
            ```

