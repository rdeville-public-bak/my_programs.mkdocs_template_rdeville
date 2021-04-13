## [Critic](https://facelessuser.github.io/pymdown-extensions/extensions/critic/)

??? info "Critic"

    ### Examples

    !!! example "Critic Markup Preview Example"

        === "Output"
            Here is some {--*incorrect*--} Markdown.  I am adding this{++
            here++}.  Here is some more {--text that I am removing--}text.  And
            here is even more {++text that I am ++}adding.{~~

            ~>  ~~}Paragraph was deleted and replaced with some spaces.{~~  ~>

            ~~}Spaces were removed and a paragraph was added.

            And here is a comment on {==some text==}{>>This works quite well. I
            just wanted to comment on it.<<}. Substitutions {~~is~>are~~}
            great!

            General block handling.

            {--

            * test remove
            * test remove
            * test remove
                * test remove
            * test remove

            --}

            {++

            * test add
            * test add
            * test add
                * test add
            * test add

            ++}
