# Microcontact site translation

Manual for translators


## Important!

These files are directly fed into the Microcontact web application. For this reason, they are made computer-friendly and they have to stay that way. This means that you have to follow some strict rules. The following rules are particularly important in order to ensure that files stay computer-readable and that special characters will show correctly on the web:

 - When creating a new translation, **always** start by copying an existing translation file on disk, *then* change the name of the copy and *finally* edit the new copy. **Never** open an existing file and tell your editor to “Save as...” or “Export”.
 - **Always** edit the translation files with a proper, computer-language-aware plain text editor. Examples that are available free of charge include *[Notepad++][1]* (Windows), *[Sublime Text][2]* (cross-platform) and *[TextMate][3]* (macOS). Linux systems tend to have *gedit* or *gvim* installed by default, both of which are acceptable.
 - **Never** edit the translation files with standard office software such as *Notepad* or *WordPad* on Windows, *TextEdit* or *Pages* on macOS, or anything that has “Office” in the name, such as *Microsoft Office* (*Word*), *LibreOffice*, *OpenOffice*, etcetera. In case of doubt, contact the developer.
 - If the choice is presented to you, **always** select **UTF-8** as the text encoding.

[1]: https://notepad-plus-plus.org/
[2]: https://www.sublimetext.com/
[3]: http://macromates.com/


## Anatomy of a translation file

The files contain *comments* and *strings* (“string” is programmer jargon for any piece of text, from “string of characters”). Each string has a *key* and a *value*. Comments start with a hash (`#`) and run until the end of the line, like this:

    # This is a comment.

Comments are purely for documentation. They are only visible to the translators and the developer. You can write anything you want in a comment, but please do it in English.

Strings look like this:

    theName: 'Here comes some text that should be translated.'

`theName` is the key and `Here comes some text that should be translated.` is the value. There is always a colon (`:`) between the key and the value and the value is always between straight quotes. More about quotes below. The string value may contain arbitrary amounts of whitespace, including line endings, but all whitespace is contracted to single spaces before website visitors get to see them.

Values may sometimes contain computer code. You can recognize computer code because it contains unusual character sequences and/or strangely spelled (English) words. Some examples:

 - `<br>`
 - `<p class="collapse welcome-more">`
 - `</em>`
 - `{{pins.length}}`
 - `&ldquo;`
 - `{0}`

*Don’t worry* about the computer code. Usually you can just ignore it. Sometimes it is a placeholder for something that will be inserted into a sentence later; in that case, there is usually a comment directly after the string to explain the intention.

The top of each translation file contains a few general comments about the target language, the source language and the translator. The rest of the file contains the strings, grouped by topic, with a comment at the top of each group that names the topic. The first few groups are general, the remainder of the groups is more or less sorted in the order in which a site visitor is most likely to see the text.


## Syntax highlighting

The recommended editors (see top of this manual) support *syntax highlighting*. This means that parts of a file with different meanings get different markup, usually a color. In the case of the translation files, this could for example mean that comments look grey, keys look black and values look blue. This is very helpful for finding the right parts of your file. In addition, it can often provide an early warning about notational mistakes, because the color of a part of a file will suddenly change.

It is beyond the scope of this manual to explain how syntax highlighting works in the various editors. However, usually it is on by default. You just need to select the right *syntax* (in this case meaning a computer language grammar) to make the editor correctly recognize comments, keys and values. The official syntax for the translation files is called *CoffeeScript*, but when that is not available, *Ini*, *bash*, *shell* or *YAML* should work, too.


## What (not) to translate

You only need to translate the values, omitting any computer code. For example, the following string in the English file

    bornHereLabel: 'I was born in {{countryName}}.'

was translated as follows in the Italian version.

    bornHereLabel: 'Sono nato in {{countryName}}.'

In case of doubt, compare the English and Italian versions to see which parts should be translated and which shouldn’t.


## Quotes

String values are delimited by straight quotes (`'`) or by triple straight quotes (`'''`). Since computers take everything literally, a string value cannot contain the character(s) it is delimited by (so a value delimited by `'` cannot itself contain `'`). At first sight, this may seem limiting, but in practice, you should prefer to use *typographical quotes*, anyway. Typographical quotes are the asymmetrical ones, `‘` and `’` or their double variants `“` and `”`, also called “educated quotes” or “curvy quotes”. Straight quotes are for computers while typographical quotes are for human readers. Since you are translating for human readers, typographical quotes are what should appear inside your string values.

Unfortunately, only straight quotes are easily accessible from the keyboard. Every system has ways to type them, but this manual cannot cover the myriad of ways this has been solved. If necessary, you can copy them from this manual instead. Here is a quick palette: `“”‘’‛‟‚„`.
