# Your digital garden

A [Quartz 5](https://quartz.jzhao.xyz/) site: you write Markdown in Obsidian, and the
same files get built into a website. No export step.

Everything is scaffolded and ready. One command finishes the install.

---

## 1. Run the setup

Open Terminal and run:

```bash
cd ~/"Digital Garden"
bash setup.sh
```

It will ask for a **baseUrl** — the address the site will live at. If you don't know
yet, press Enter to accept `hjc-garden.pages.dev`; it's a one-line change later
in `quartz.config.yaml`.

The script clones Quartz, installs dependencies, applies the Obsidian template, drops
in your content and theme, and runs a test build. Takes two or three minutes.

**Prerequisites:** Node 22+ (`node -v` to check, [nodejs.org](https://nodejs.org) to
install) and git. Nothing else.

---

## 2. Preview it

```bash
cd ~/"Digital Garden"
npx quartz build --serve
```

> **Node lives in `~/.local/node`** on this machine — it was installed as a
> plain tarball rather than system-wide, so `node` and `npx` are only on your
> PATH if you say so. Add this line to `~/.zshrc` once and every new terminal
> will find them:
>
> ```
> export PATH="$HOME/.local/node/bin:$PATH"
> ```
>
> Until you do, prefix commands with it: `PATH="$HOME/.local/node/bin:$PATH" npx quartz build --serve`

Open <http://localhost:8080>. It live-reloads as you edit, so leave it running while
you write.

---

## 3. Write in it

Open Obsidian → **Open folder as vault** → choose `~/Digital Garden/content`.

The vault arrives pre-configured:

- **Daily notes** (`Cmd+P` → "Open today's daily note") creates `daily/YYYY-MM-DD.md` from the daily template
- **Templates** (`Cmd+P` → "Insert template") gives you note, research, reading, and scene templates
- **Wikilinks** are on, set to shortest-path, which is what Quartz expects
- **Graph view** is colour-coded by section

### What's where

```
content/
├── index.md          the homepage
├── daily/            dated log — raw capture, one file per day
├── notes/            evergreen notes — one idea each, heavily linked
├── research/         papers, experiments, open questions
├── reading/          book and article notes
├── novel/            outline, characters, scenes/
├── templates/        note templates (not published)
└── private/          anything you never want built (not published)
```

`templates/`, `private/`, and `.obsidian/` are excluded from the built site. Any note
with `draft: true` in its frontmatter is also excluded — the novel files ship with
that set, so nothing fictional goes public by accident.

### Math

KaTeX is on. Inline math goes between single dollars, display math between
double:

```markdown
The variance is $\sigma^2 = \mathbb{E}[(X - \mu)^2]$.

$$
\int_{-\infty}^{\infty} e^{-x^2}\,dx = \sqrt{\pi}
$$
```

Obsidian renders the same syntax in the editor, so what you see while writing is
what ships. KaTeX covers essentially all of standard LaTeX math — sums, integrals,
matrices, aligned environments — but not full LaTeX documents: no `\usepackage`,
no TikZ. For diagrams use Mermaid (also enabled) in a ```mermaid fence.

### Frontmatter that does something

```yaml
---
title: The title shown on the page
description: Used for link previews
tags: [thinking, method]
date: 2026-08-10
draft: true # excludes it from the built site
---
```

---

## 4. Publish to Cloudflare Pages

### a. Put it on GitHub

Create an empty repo at [github.com/new](https://github.com/new) — **no** README,
license, or .gitignore, since Quartz ships its own and they'd conflict. Then:

```bash
cd ~/"Digital Garden"
git remote set-url origin https://github.com/<your-username>/<your-repo>.git
npx quartz sync --no-pull
```

Note the branch name it pushes to (`v5`) — Cloudflare needs it in the next step.

### b. Connect Cloudflare

In the [Cloudflare dashboard](https://dash.cloudflare.com/): **Compute (Workers)** →
**Workers & Pages** → **Create application** → **Pages** → **Connect to Git**, pick
your repo, then set:

| Setting | Value |
| --- | --- |
| Production branch | `v5` |
| Framework preset | `None` |
| Build command | `git fetch --unshallow \|\| true && npx quartz plugin install && npx quartz build` |
| Build output directory | `public` |

The `git fetch --unshallow` matters: Cloudflare does a shallow clone by default, and
Quartz reads git history to date your notes. Without it every page shows the same date.

Save and deploy. About a minute later you'll have a `*.pages.dev` URL.

### c. Match the baseUrl

If the deployed URL differs from what you entered during setup, open
`quartz.config.yaml` and fix `baseUrl` (no `https://`, no trailing slash). It only
affects RSS and sitemaps, but those break silently if it's wrong.

Custom domain: Cloudflare's [docs](https://developers.cloudflare.com/pages/platform/custom-domains/).

---

## Day to day

```bash
npx quartz build --serve   # write with live preview
npx quartz sync            # commit + push; Cloudflare redeploys automatically
```

That's the whole loop. Write in Obsidian, run `npx quartz sync`, site updates.

---

## Making it yours

- **Title, colours, fonts** — `quartz.config.yaml`, under `configuration:`
- **Sidebar and page layout** — `quartz.config.yaml`, under `layout:` and each plugin's `layout:` block
- **Custom CSS** — `quartz/styles/custom.scss`
- **More plugins** — `npx quartz plugin add github:quartz-community/<name>` ([list](https://quartz.jzhao.xyz/plugins/))
- **Update Quartz later** — `npx quartz upgrade`

---

## If something breaks

- **Plugins fail on a fresh clone** — `npx quartz plugin install --latest`
- **Node too old** — Quartz 5 needs 22+; `node -v`
- **Changes not showing on the live site** — you probably didn't `npx quartz sync`
- Full [troubleshooting guide](https://quartz.jzhao.xyz/troubleshooting) · [Discord](https://discord.gg/cRFFHYye7t)

---

## A note on the habit

The tooling is the easy part. The thing that makes a garden work is a weekly pass over
the last seven daily notes, promoting anything you've now written down twice into a
real note in `notes/`. Without that, this becomes a folder of files. With it, it
compounds.
