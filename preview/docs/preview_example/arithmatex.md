## [Arithmatex](https://facelessuser.github.io/pymdown-extensions/extensions/arithmatex/)

??? info "Arithmatex"

    ### Overview

    Arithmatex is an extension that preserves LaTeX math equations during the
    Markdown conversion process so that they can be used with libraries like
    MathJax.

    Arithmatex searches for the patterns `#!tex $...$` and `#!tex \(...\)` for
    inline math, and `#!tex $$...$$`, `#!tex \[...\]`, and `#!tex
    \begin{}...\end{}` for block math. By default, all formats are enabled, but
    each format can individually be disabled if desired.


    ### Examples

    !!! example "Inline Examples"

        === "Output"
            $p(x|y) = \frac{p(y|x)p(x)}{p(y)}$, \(p(x|y) = \frac{p(y|x)p(x)}{p(y)}\).

        === "Markdown"
            ```tex
            $p(x|y) = \frac{p(y|x)p(x)}{p(y)}$, \(p(x|y) = \frac{p(y|x)p(x)}{p(y)}\).
            ```

    !!! example "Block Examples"

        === "Output"
            $$
            E(\mathbf{v}, \mathbf{h}) = -\sum_{i,j}w_{ij}v_i h_j - \sum_i b_i v_i - \sum_j c_j h_j
            $$

            \[3 < 4\]

            \begin{align}
                p(v_i=1|\mathbf{h}) & = \sigma\left(\sum_j w_{ij}h_j + b_i\right) \\
                p(h_j=1|\mathbf{v}) & = \sigma\left(\sum_i w_{ij}v_i + c_j\right)
            \end{align}

        === "Markdown"
            ```tex
            $$
            E(\mathbf{v}, \mathbf{h}) = -\sum_{i,j}w_{ij}v_i h_j - \sum_i b_i v_i - \sum_j c_j h_j
            $$

            \[3 < 4\]

            \begin{align}
                p(v_i=1|\mathbf{h}) & = \sigma\left(\sum_j w_{ij}h_j + b_i\right) \\
                p(h_j=1|\mathbf{v}) & = \sigma\left(\sum_i w_{ij}v_i + c_j\right)
            \end{align}
            ```

    ### Alternative Math Blocks

    !!! example "Inline Math"

        === "Output"
            `#!math p(x|y) = \frac{p(y|x)p(x)}{p(y)}`

        === "Markdown"
            ```
            `#!math p(x|y) = \frac{p(y|x)p(x)}{p(y)}`
            ```


    !!! example "Math Fences"

        === "Output"
            ```math
            \begin{align}
                p(v_i=1|\mathbf{h}) & = \sigma\left(\sum_j w_{ij}h_j + b_i\right) \\
                p(h_j=1|\mathbf{v}) & = \sigma\left(\sum_i w_{ij}v_i + c_j\right)
            \end{align}
            ```

        === "Markdown"
            ````
            ```math
            \begin{align}
                p(v_i=1|\mathbf{h}) & = \sigma\left(\sum_j w_{ij}h_j + b_i\right) \\
                p(h_j=1|\mathbf{v}) & = \sigma\left(\sum_i w_{ij}v_i + c_j\right)
            \end{align}
            ```
            ````

    #### Subset h3 example
