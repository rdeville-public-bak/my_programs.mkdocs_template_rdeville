## [Caret](https://facelessuser.github.io/pymdown-extensions/extensions/caret/)

??? info "Caret"

    ### Example Insert

    To wrap content in an **insert** tag, simply surround the text with double
    `^`. You can also enable `smart_insert` in the options. Smart
    behavior of **insert** models that of BetterEm.

    !!! example "Insert Example"

        === "Output"
            ^^Insert me^^

        === "Markdown"
            ```
            ^^Insert me^^
            ```

    ### Example Superscript

    To denote a superscript, you can surround the desired content in single
    `^`.  It uses Pandoc style logic, so if your superscript needs to have
    spaces, you must escape the spaces.

    !!! example "Superscript Example"

        === "Output"
            H^2^0

            text^a\ superscript^

        === "Markdown"
            ```
            H^2^0

            text^a\ superscript^
            ```
