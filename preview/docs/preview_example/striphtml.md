## [StripHTML](https://facelessuser.github.io/pymdown-extensions/extensions/striphtml)

??? info "StripHTML"

    ### Examples

    StripHTML (formally known as PlainHTML) is a simple extension that is run
    at the end of post-processing.  It searches the final output stripping out
    unwanted comments and/or tag attributes. Though it does its best to be
    loaded at the very end of the process, it helps to include this one last
    when loading up your extensions.

    !!! example "Strip Comment"

        === "HTML"
            ```html
            <p>Here is a <strong>test</strong>.</p>
            ```

        === "Markdown"
            ```
            <!-- We are only allowing strip_comments and strip_js_on_attributes
                 in this example. -->
            Here is a <strong onclick="myFunction();">test</strong>.
            ```

