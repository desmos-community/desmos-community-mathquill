# Desmos Community Mathquill

MathQuill is a web formula editor designed to make typing math easy and beautiful.

## Mathquill vs. Desmos Mathquill

The original Mathquill repository can be found at [mathquill/mathquill](https://github.com/mathquill/mathquill). However, it is lacking many features and not well-maintained. This package is built from the [desmosinc/mathquill](https://github.com/desmosinc/mathquill) fork, which contains many new features and bug fixes.

One caveat of Desmos Mathquill is the fact that it only supports the "basic" build type, meaning that interactively adding LaTeX commands is not supported. Instead, you're expected to use the `autoOperatorNames` and `autoCommands` options to automatically replace typed text with their respective operatornames/symbols.

As this fork is meant to be continuously integrated into the Desmos graphing calculator, it does not provide any form of official pre-built packages. This package is an **unofficial release**, automatically built nightly from the Desmos Mathquill repository. As such, it does not distinguish between breaking and non-breaking changes.

## Installation and Usage
You can use this package in one of two ways:

### Use via CDN

Add the following tags to your HTML:

```html
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/@desmos-community/mathquill@2025.12.3-experimental/dist/style.css"
      integrity="sha384-EwTGPJ5T8P/KXJk/NW5ysp5Sp2u6Tv6HQZgViiSZBtUW4jGQW0JHIjLjAdD9qHMu"
      crossorigin="anonymous"
      referrerpolicy="no-referrer">
<script src="https://cdn.jsdelivr.net/npm/@desmos-community/mathquill@2025.12.3-experimental/dist/index.global.js"
        integrity="sha384-Y2IEyQlqHgLMtNeUtGOvMVwi7F+xkxu/apGQwYoJEMvNDxFuq4qIlyR5d3fBJbUw"
        crossorigin="anonymous"
        referrerpolicy="no-referrer"></script>
```

`MathQuill` is available globally:

```js
const MQ = MathQuill.getInterface(3);
```

Alternatively, you can use the ESM version via a CDN. There are multiple ways to do this, so I'll leave that up to you, the user :)

### Use with a bundler

First, install the package from npm:

```bash
npm install --save-exact @desmos-community/mathquill
```

> [!IMPORTANT]
> Since this package uses calendar versioning instead of semantic versioning, it is **highly recommended** to use `--save-exact`.

The package can then be used as an ES Module:

```ts
import MathQuill from '@desmos-community/mathquill';
const MQ = MathQuill.getInterface(3);
```

Or using the global version for compatibility:

```ts
import '@desmos-community/mathquill/global';
const MQ = MathQuill.getInterface(3);
```

## Versioning

For the reasons explained above, this package does not follow semantic versioning. Instead, it uses calendar versioning, in the format `YYYY-MM-DD`. Because breaking changes can and do happen within a year, this package should be installed `--save-exact`. Alternatively, if you want continuous updates, you can manually update the dependency version in `package.json` to "latest". This will update to the latest version every time the lockfile is regenerated.

---

<details>

<summary>

## Original README.md

</summary>

# [MathQuill](http://mathquill.com)

by [Han](http://github.com/laughinghan), [Jeanine](http://github.com/jneen), and [Mary](http://github.com/stufflebear) (<maintainers@mathquill.com>) [<img alt="slackin.mathquill.com" src="http://slackin.mathquill.com/badge.svg" align="top">](http://slackin.mathquill.com)

MathQuill is a web formula editor designed to make typing math easy and beautiful.

[<img alt="homepage demo" src="https://cloud.githubusercontent.com/assets/225809/15163580/1bc048c4-16be-11e6-98a6-de467d00cff1.gif" width="260">](http://mathquill.com)

The MathQuill project is supported by its [partners](http://mathquill.com/partners.html). We hold ourselves to a compassionate [Code of Conduct](http://docs.mathquill.com/en/latest/Code_of_Conduct/).

MathQuill is resuming active development and we're committed to getting things running smoothly. Find a dusty corner? [Let us know in Slack.](http://slackin.mathquill.com) (Prefer IRC? We're `#mathquill` on Freenode.)

## Getting Started

MathQuill has a simple interface. This brief example creates a MathQuill element and renders, then reads a given input:

```javascript
var htmlElement = document.getElementById('some_id');
var config = {
  handlers: { edit: function(){ ... } },
  restrictMismatchedBrackets: true
};
var mathField = MQ.MathField(htmlElement, config);

mathField.latex('2^{\\frac{3}{2}}'); // Renders the given LaTeX in the MathQuill field
mathField.latex(); // => '2^{\\frac{3}{2}}'
```

Check out our [Getting Started Guide](http://docs.mathquill.com/en/latest/Getting_Started/) for setup instructions and basic MathQuill usage.

## Docs

Most documentation for MathQuill is located on [ReadTheDocs](http://docs.mathquill.com/en/latest/).

Some older documentation still exists on the [Wiki](https://github.com/mathquill/mathquill/wiki).

## Open-Source License

The Source Code Form of MathQuill is subject to the terms of the Mozilla Public
License, v. 2.0: [http://mozilla.org/MPL/2.0/](http://mozilla.org/MPL/2.0/)

The quick-and-dirty is you can do whatever if modifications to MathQuill are in
public GitHub forks. (Other ways to publicize modifications are also fine, as
are private use modifications. See also: [MPL 2.0 FAQ](https://www.mozilla.org/en-US/MPL/2.0/FAQ/))

</details>