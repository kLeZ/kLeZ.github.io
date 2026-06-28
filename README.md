# kLeZ.github.io

[![Build Status](https://github.com/kLeZ/kLeZ.github.io/actions/workflows/main.yaml/badge.svg?branch=master)](https://github.com/kLeZ/kLeZ.github.io/actions/workflows/main.yaml)

My personal (static) website built with [Jekyll] and continuously deployed by [GitHub-Actions].  
It's all completely automated (full CI & CD), to the point where I can write a simple markdown document with a smartphone, push it to [GitHub], and see it in "production" (a.k.a. the public facing website) in seconds (or very few minutes).  
Jekyll is a very simple but powerful software to build public websites in, and the integration with GitHub Actions is awesome. So awesome that I can completely automate the build and publish steps of a static website generated with a static site generator, thus making the entire process so smooth to feel like I'm posting to a CMS engine like WordPress (that is dynamic, with all the issues and complexities of dynamic websites).

Thanks [Jekyll], thanks [GitHub-Actions], thanks [GitHub], for making it possible.

Double licensing is provided: [GNU GPL v3] for the site code which you can freely use and modify, and [CC-BY-NC-ND 4.0] for the contents of the site, which are my personal knowledge and life experience, and represent an intellectual property of mine.

Please be gentle :-)

## Development

Working on this repo (humans and AI agents alike)? Start here:

- [`AGENTS.md`](AGENTS.md) — how to set up, build, test, and the working conventions.
- [`CONTEXT.md`](CONTEXT.md) — project architecture, branch model, and toolchain.

Note: `master` is the single long-lived branch — it holds the Jekyll source and
is the default branch. Pushing to it builds the site and publishes it to GitHub
Pages via GitHub Actions (Pages Source = "GitHub Actions"). Pure blog content
written on the owner's own machine is committed straight to `master`; source or
feature changes — and anything not coming from the owner's machine — go on a
short-lived branch off `master` with a PR. See [`AGENTS.md`](AGENTS.md) for the
full convention.

[Jekyll]: https://jekyllrb.com/
[GitHub-Actions]: https://github.com/features/actions
[GitHub]: https://github.com
[GNU GPL v3]: http://www.gnu.org/licenses/gpl.html
[CC-BY-NC-ND 4.0]: https://creativecommons.org/licenses/by-nc-nd/4.0/
