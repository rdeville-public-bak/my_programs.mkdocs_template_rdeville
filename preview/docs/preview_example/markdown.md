## Basic Markdown

??? info "Basic Markdown"

    ### Basic Markdown

    #### Headings

    === "Output"

        ## h2 Heading
        ### h3 Heading
        #### h4 Heading
        ##### h5 Heading
        ###### h6 Heading

    === "Markdown"

        ````markdown
        ## h2 Heading
        #### h3 Heading
        ##### h4 Heading
        ###### h5 Heading
        ####### h6 Heading
        ````

    #### Horizontal Rules

    === "Output"

        ___

        ---

        ***

    === "Markdown"

        ````markdown
        ___

        ---

        ***
        ````


    #### Typographic replacements

    === "Output"

        (c) (C) (r) (R) (tm) (TM) (p) (P) +-

        test.. test... test..... test?..... test!....

        !!!!!! ???? ,,  -- ---

        "Smartypants, double quotes" and 'single quotes'

    === "Markdown"
        ````markdown

        (c) (C) (r) (R) (tm) (TM) (p) (P) +-

        test.. test... test..... test?..... test!....

        !!!!!! ???? ,,  -- ---

        "Smartypants, double quotes" and 'single quotes'

        ````

    #### Emphasis

    === "Output"

        **This is bold text**

        __This is bold text__

        *This is italic text*

        _This is italic text_

        ~~Strikethrough~~

    === "Markdown"
        ````markdown

        **This is bold text**

        __This is bold text__

        *This is italic text*

        _This is italic text_

        ~~Strikethrough~~

        ````

    #### Blockquotes

    === "Output"

        > Blockquotes can also be nested...
        >> ...by using additional greater-than signs right next to each other...
        > > > ...or with spaces between arrows.

    === "Markdown"
        ````markdown

        > Blockquotes can also be nested...
        >> ...by using additional greater-than signs right next to each other...
        > > > ...or with spaces between arrows.
        ````


    #### Lists

    === "Output"

        Unordered

        + Create a list by starting a line with `+`, `-`, or `*`
        + Sub-lists are made by indenting 2 spaces:
          - Marker character change forces new list start:
            * Ac tristique libero volutpat at
            + Facilisis in pretium nisl aliquet
            - Nulla volutpat aliquam velit
        + Very easy!

        Ordered

        1. Lorem ipsum dolor sit amet
        2. Consectetur adipiscing elit
        3. Integer molestie lorem at massa


        1. You can use sequential numbers...
        1. ...or keep all the numbers as `1.`

        Start numbering with offset:

        57. foo
        1. bar

    === "Markdown"
        ````markdown

        Unordered

        + Create a list by starting a line with `+`, `-`, or `*`
        + Sub-lists are made by indenting 2 spaces:
          - Marker character change forces new list start:
            * Ac tristique libero volutpat at
            + Facilisis in pretium nisl aliquet
            - Nulla volutpat aliquam velit
        + Very easy!

        Ordered

        1. Lorem ipsum dolor sit amet
        2. Consectetur adipiscing elit
        3. Integer molestie lorem at massa


        1. You can use sequential numbers...
        1. ...or keep all the numbers as `1.`

        Start numbering with offset:

        57. foo
        1. bar
        ````


    #### Code

    === "Output"

        Inline `code`

        Indented code

            // Some comments
            line 1 of code
            line 2 of code
            line 3 of code


        Block code "fences"

        ```
        Sample text here...
        ```

        Syntax highlighting

        ```js
        var foo = function (bar) {
          return bar++;
        };

        console.log(foo(5));
        ```

    === "Markdown"
        ````markdown

        Inline `code`

        Indented code

            // Some comments
            line 1 of code
            line 2 of code
            line 3 of code


        Block code "fences"

        ```
        Sample text here...
        ```

        Syntax highlighting

        ```js
        var foo = function (bar) {
          return bar++;
        };

        console.log(foo(5));
        ```
        ````

    #### Tables

    === "Output"

        | Option  | Description                                                               |
        | ------  | -----------                                                               |
        | data    | path to data files to supply the data that will be passed into templates. |
        | engine  | engine to be used for processing templates. Handlebars is the default.    |
        | ext     | extension to be used for dest files.                                      |

        Right aligned columns

        | Option  | Description                                                               |
        | ------: | -----------:                                                              |
        | data    | path to data files to supply the data that will be passed into templates. |
        | engine  | engine to be used for processing templates. Handlebars is the default.    |
        | ext     | extension to be used for dest files.                                      |


    === "Markdown"
        ````markdown

        | Option  | Description                                                               |
        | ------  | -----------                                                               |
        | data    | path to data files to supply the data that will be passed into templates. |
        | engine  | engine to be used for processing templates. Handlebars is the default.    |
        | ext     | extension to be used for dest files.                                      |

        Right aligned columns

        | Option  | Description                                                               |
        | ------: | -----------:                                                              |
        | data    | path to data files to supply the data that will be passed into templates. |
        | engine  | engine to be used for processing templates. Handlebars is the default.    |
        | ext     | extension to be used for dest files.                                      |

        ````

    #### Links

    === "Output"

        [link text](http://dev.nodeca.com)

        [link with title](http://nodeca.github.io/pica/demo/ "title text!")

        Autoconverted link https://github.com/nodeca/pica (enable linkify to see)

    === "Markdown"

        ````markdown

        [link text](http://dev.nodeca.com)

        [link with title](http://nodeca.github.io/pica/demo/ "title text!")

        Autoconverted link https://github.com/nodeca/pica (enable linkify to see)

        ````


    #### Images

    === "Output"

        Like links, Images also have a footnote style syntax

        ![Alt text][id]

        With a reference later in the document defining the URL location:

        [id]: https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat"

    === "Markdown"
        ````markdown

        Like links, Images also have a footnote style syntax

        ![Alt text][id]

        With a reference later in the document defining the URL location:

        [id]: https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat"

        ````

??? info "Markdown Extension"

    ### Markdown Extension

    #### Footnotes

    === "Output"

        Footnote 1 link[^first].

        Footnote 2 link[^second].

        Inline footnote^[Text of inline footnote] definition.

        Duplicated footnote reference[^second].

        [^first]: Footnote **can have markup**

            and multiple paragraphs.

        [^second]: Footnote text.

    === "Markdown"
        ````markdown

        Footnote 1 link[^first].

        Footnote 2 link[^second].

        Inline footnote^[Text of inline footnote] definition.

        Duplicated footnote reference[^second].

        [^first]: Footnote **can have markup**

            and multiple paragraphs.

        [^second]: Footnote text.
        ````


    #### Abbreviations

    === "Output"
        This is HTML abbreviation example.

        It converts "HTML", but keep intact partial entries like "xxxHTMLyyy" and so on.

        *[HTML]: Hyper Text Markup Language

    === "Markdown"
        ````markdown
        This is HTML abbreviation example.

        It converts "HTML", but keep intact partial entries like "xxxHTMLyyy" and so on.

        *[HTML]: Hyper Text Markup Language

        ````
