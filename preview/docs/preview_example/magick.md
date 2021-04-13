## [MagicLink](https://facelessuser.github.io/pymdown-extensions/extensions/magiclink)

??? info "MagicLink"

    !!! note "Icons"
        This documentation implements additional styling with CSS that inserts
        icons before special links, such as GitHub, logos, bug icons, etc.
        MagicLink does not inject icons or CSS to insert icons, but it is left
        to the user to implement (if desired) via the provided [classes](#css).
        User's are free to reference this documentation's source to learn how.


    ### Auto-Linking

    MagicLink supports auto-linking HTTP, FTP and email links. You can specify
    these links in raw text and they should get auto-linked. There are some
    limitations placed on MagicLink to keep it from aggressively auto-linking
    text that is not part of links. If you have a link that cannot be detected,
    you can always use the old style angle bracketed link format: `#!md
    <https://www.link.com>`.

    !!! example "Auto-Linking Example"

        === "Output"
            - Just paste links directly in the document like this: https://google.com.
            - Or even an email address: fake.email@email.com.

        === "Markdown"
            ```
            - Just paste links directly in the document like this: https://google.com.
            - Or even an email address: fake.email@email.com.
            ```

    ### Repository Link Shortener

    MagicLink can also recognize issue, pull request, commit, and compare
    links, and render them in the same output format as the repository
    shortcut links feature.

    If we specify long form URLs from external providers, they will be
    shortened appropriately.

    !!! example "External Provider Example"

        === "Output"
            - https://github.com/facelessuser
            - https://github.com/facelessuser/pymdown-extensions
            - https://gitlab.com/pycqa/flake8/issues/385
            - https://bitbucket.org/mrabarnett/mrab-regex/issues/260/extremely-slow-matching-using-ignorecase

        === "Markdown"
            ```
            - https://github.com/facelessuser
            - https://github.com/facelessuser/pymdown-extensions
            - https://gitlab.com/pycqa/flake8/issues/385
            - https://bitbucket.org/mrabarnett/mrab-regex/issues/260/extremely-slow-matching-using-ignorecase
            ```

    When specifying links that reference the configured `provider`, `user`, and
    `repo`, some links will be shortened differently in light of that context.

    !!! example "Internal Provider Example"

        === "Output"
            - https://github.com/facelessuser/pymdown-extensions/issues/1
            - https://github.com/facelessuser/pymdown-extensions/pull/13
            - https://github.com/facelessuser/pymdown-extensions/commit/3f6b07a8eeaa9d606115758d90f55fec565d4e2a
            - https://github.com/facelessuser/pymdown-extensions/compare/e2ed7e0b3973f3f9eb7a26b8ef7ae514eebfe0d2...90b6fb8711e75732f987982cc024e9bb0111beac
            - https://github.com/facelessuser/Rummage/commit/181c06d1f11fa29961b334e90606ed1f1ec7a7cc

        === "Markdown"
            ```
            - https://github.com/facelessuser/pymdown-extensions/issues/1
            - https://github.com/facelessuser/pymdown-extensions/pull/13
            - https://github.com/facelessuser/pymdown-extensions/commit/3f6b07a8eeaa9d606115758d90f55fec565d4e2a
            - https://github.com/facelessuser/pymdown-extensions/compare/e2ed7e0b3973f3f9eb7a26b8ef7ae514eebfe0d2...90b6fb8711e75732f987982cc024e9bb0111beac
            - https://github.com/facelessuser/Rummage/commit/181c06d1f11fa29961b334e90606ed1f1ec7a7cc
            ```
