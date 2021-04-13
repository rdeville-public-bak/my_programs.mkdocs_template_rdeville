## [SuperFences](https://facelessuser.github.io/pymdown-extensions/extensions/superfences)

??? info "SuperFences"

    ### Preserve Tabs

    !!! example "Tabs in Content"

        === "Output"
            ```
            ============================================================
            T	Tp	Sp	D	Dp	S	D7	T
            ------------------------------------------------------------
            A	F#m	Bm	E	C#m	D	E7	A
            A#	Gm	Cm	F	Dm	D#	F7	A#
            B♭	Gm	Cm	F	Dm	E♭m	F7	B♭
            ```

        === "Markdown"
            ````
            ```
            ============================================================
            T	Tp	Sp	D	Dp	S	D7	T
            ------------------------------------------------------------
            A	F#m	Bm	E	C#m	D	E7	A
            A#	Gm	Cm	F	Dm	D#	F7	A#
            B♭	Gm	Cm	F	Dm	E♭m	F7	B♭
            ```
            ````

    ### Code Highlighting

    !!! example "Highlight Example"

        === "Output"
            ```py3
            import foo.bar
            ```

        === "Markdown"
            ````
            ```py3
            import foo.bar
            ```
            ````

    ### Showing Line Numbers

    !!! example "Line Number Example"

        === "Output"
            ``` {linenums="1"}
            import foo.bar
            ```

        === "Markdown"
            ````
            ``` {linenums="1"}
            import foo.bar
            ```
            ````

    !!! example "Nth Line Example"

        === "Output"
            ``` {linenums="2 2"}
            """Some file."""
            import foo.bar
            import boo.baz
            import foo.bar.baz
            ```

        === "Markdown"
            ````
            ``` {linenums="2 2"}
            """Some file."""
            import foo.bar
            import boo.baz
            import foo.bar.baz
            ```
            ````

    !!! example "Special Line Example"

        === "Output"
            ``` {linenums="1 1 2"}
            """Some file."""
            import foo.bar
            import boo.baz
            import foo.bar.baz
            ```

        === "Markdown"
            ````
            ``` {linenums="1 1 2"}
            """Some file."""
            import foo.bar
            import boo.baz
            import foo.bar.baz
            ```
            ````

    ### Highlighting Lines


    !!! example "Highlight Lines Example"

        === "Output"
            ```{.py3 hl_lines="1 3"}
            """Some file."""
            import foo.bar
            import boo.baz
            import foo.bar.baz
            ```

        === "Markdown"
            ````
            ```{.py3 hl_lines="1 3"}
            """Some file."""
            import foo.bar
            import boo.baz
            import foo.bar.baz
            ```
            ````

    !!! example "Highlight Lines with Line Numbers Example"

        === "Output"
            ```{.py3 hl_lines="1 3" linenums="2"}
            """Some file."""
            import foo.bar
            import boo.baz
            import foo.bar.baz
            ```

        === "Markdown"
            ````
            ```{.py3 hl_lines="1 3" linenums="2"}
            """Some file."""
            import foo.bar
            import boo.baz
            import foo.bar.baz
            ```
            ````

    !!! example "Highlight Ranges"

        === "Output"
            ```{.py3 hl_lines="1-2 5 7-8"}
            import foo
            import boo.baz
            import foo.bar.baz

            class Foo:
               def __init__(self):
                   self.foo = None
                   self.bar = None
                   self.baz = None
            ```

        === "Markdown"
            ````
            ```{.py3 hl_lines="1-2 5 7-8"}
            import foo
            import boo.baz
            import foo.bar.baz

            class Foo:
               def __init__(self):
                   self.foo = None
                   self.bar = None
                   self.baz = None
            ```
            ````

    ### Custom Fences

    !!! example "Flow Chart Example"

        === "Output"
            ```mermaid
            graph TD
                A[Hard] -->|Text| B(Round)
                B --> C{Decision}
                C -->|One| D[Result 1]
                C -->|Two| E[Result 2]
            ```

        === "Markdown"
            ````
            ```mermaid
            graph TD
                A[Hard] -->|Text| B(Round)
                B --> C{Decision}
                C -->|One| D[Result 1]
                C -->|Two| E[Result 2]
            ```
            ````
