## [EscapeAll](https://facelessuser.github.io/pymdown-extensions/extensions/escapeall)

??? info "EscapeAll"

    ### Examples

    If you ever have to stop and try to remember, *Can I escape this char?* or
    *Will a backslash escape this?*, you are not alone.  EscapeAll makes `\`
    escape everything making such questions moot.  Now instead of questioning
    or looking up what can be escaped, you can expect that `\` will escape the
    character following it.  So if you need a literal `\`, just escape it:
    `\\`.  Keep in mind this will not escape things in code blocks of any kind.

    !!! example "Escape Example"

        === "Output"
            \W\e\ \c\a\n\ \e\s\c\a\p\e
            \e\v\e\r\y\t\h\i\n\g\!\ \
            \❤\😄

        === "Markdown"
            ```
            \W\e\ \c\a\n\ \e\s\c\a\p\e
            \e\v\e\r\y\t\h\i\n\g\!\ \
            \❤\😄
            ```
