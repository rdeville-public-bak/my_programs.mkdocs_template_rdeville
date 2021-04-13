## [SaneHeaders](https://facelessuser.github.io/pymdown-extensions/extensions/saneheaders)

??? info "SaneHeaders"
    ### Examples


    The syntax when using SaneHeaders is exactly like Python Markdown's default
    logic with the only exception being that SaneHeaders will not treat hashes
    at the beginning of a line as a header if they do not have space after
    them.

    In Python Markdown, both of these are treated as headers:

    ```
    ## Header

    ##Also a Header
    ```

    With SaneHeaders, only the first is a header:

    ```
    ## Header

    ##Not a Header
    ```
