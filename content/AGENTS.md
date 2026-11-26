---
title: Instructions for coding agents
draft: true
---

# Instructions for coding agents

This folder is the `content/` folder of Houjun's digital garden. It is an Obsidian vault, and Quartz publishes it as a public website. Right now the main work here is a series of lecture notes on the Ngô fundamental lemma seminar, written from photos of the boards and from Ngô's paper. This file explains how those notes are organized and written, so that you can continue them in the same way.

(The `draft: true` line at the top keeps this file off the published site.)

## 1. Ground rules

- Talk to Houjun in Chinese. Write the notes in English.
- Houjun also edits these files in Obsidian. Read a file again right before you change it, and never overwrite changes he made. When he asks for a specific fix, change only that part.
- Work only on the files the task is about. Leave the other folders (`daily/`, `novel/`, `private/`, `reading/`, `research/`, `.obsidian/`) alone unless he asks.
- Every Markdown file in this folder can end up on the public site. Do not leave drafts, logs or other scratch files here. Use `/tmp`, or ask Houjun where to put them.
- When you draw figures, keep the TikZ sources so that the figures can be changed later. Ask Houjun where to keep them (a folder next to `content/` works well). The sources of the existing figures were lost; see section 5.

## 2. Where things are

- `notes/`: one note per file. The file name is the title of the note.
- `attachments/`: images, including the figures of the notes.
- `templates/note.md`: the template for the frontmatter.

The seminar notes so far:

- `notes/Affine Springer fibers and their symmetries.md`: the talk of 2026-10-23 on Ngô §3.6–3.11. The boards covered the set-up and the GL_n case. The rest (sections 3–8 of the note) is written from the paper, including Ngô §8.2–8.3. Figures: `affine-springer-fig1-disc-arcs.svg`, `affine-springer-fig2-kostant-sl2.svg`, `affine-springer-fig3-fiber-over-a.svg`, `affine-springer-fig4-node-chains.svg`.
- `notes/The Hitchin fibration.md`: the talk of 2026-10-30 on Ngô chapter 4. The boards covered §4.1–4.3 and §4.5–4.7. The dimension formulas (§4.4), the product formula and the density theorem (§4.13–4.14), and the proof sketches are written from the paper. Figures: `hitchin-fibration-fig1-local-orbits.svg`, `hitchin-fibration-fig2-spectral-curve.svg`, `hitchin-fibration-fig3-cameral-cover.svg`.
- Both notes link to `notes/Endoscopy.md`.

Sources:

- The board photos are in Houjun's Google Drive, in the folder "Talks from others", subfolder "Ngo Fundamental Lemma". The files are named `IMG_YYYYMMDD_HHMMSS.jpg`, and the time in the name gives the order of the boards. Neighbouring photos often show the same board again; use them to recover parts hidden by the speaker. If you cannot open Drive, ask Houjun to put the photos in a local folder.
- The paper is B. C. Ngô, *Le lemme fondamental pour les algèbres de Lie*, Publ. Math. IHÉS 111 (2010), arXiv:0801.0446. All "Ngô x.y.z" numbers in the notes follow the arXiv version. The LaTeX source on arXiv (the "e-print") is the easiest way to read the exact statements.

## 3. How a note is written

Houjun gave this feedback on earlier versions. Please follow it.

- **A lecture note that reads from start to end.** Use numbered sections in the order of the talk, with connected paragraphs. Do not use tables, callout boxes, "Board 3 says..." fragments, or bullet lists in place of explanations. Lists are fine only for short enumerations, such as the parts of a theorem or a short summary.
- **Not too terse.** Say why a definition is needed before giving it. Add transitions between sections ("Now that we have ..., we can ..."). Use soft words such as "roughly speaking", "in other words", "note that", "intuitively", "it turns out that", "one can think of", "let us now". At the same time keep the English plain: Houjun is a non-native speaker, so avoid idioms and very long sentences.
- **Boards and paper fused.** The boards decide the order and the emphasis. The paper gives the precise statements, the numbering and the missing steps. Cover everything on the boards, including examples, remarks, margin notes and pictures. The introduction says which parts come from the boards and which come from the paper.
- **Depth where it matters.** After each core definition, add a paragraph that unwinds it ("Let us unwind this definition..."): what the objects are, what the condition really says, and, if possible, a one-line slogan in bold. State non-core results without proof. When a proof is too long, do the case of GL_n or SL_2 (or the smallest interesting example) by hand instead.
- **The whole picture.** Start with an introduction: the context, the guiding principle in bold, a plan of the sections, and the sources. Use running examples that come back several times. End with a section on how the results are used later ("Outlook").
- **Accuracy.** Check every statement against the paper, and redo the computations in the examples. If the board and the paper disagree, if a claim on the board was struck out, or if the paper has a typo, say so in the text in one sentence.

## 4. Format

Frontmatter and header, as in the existing notes:

```
---
title: <Title>
description: "Lecture notes for the talk on <topic> in the Ngô fundamental lemma seminar (<YYYY-MM-DD>), combining the boards with the paper."
tags:
  - fundamental-lemma
  - <topic-tag>
  - seminar-notes
stage: 🌱 seedling
date: <YYYY-MM-DD of the talk>
---

# <Title>

*Notes on the talk "<title on the board>", Ngô fundamental lemma seminar, <date, e.g. 30 October 2026>. Reference: B. C. Ngô, Le lemme fondamental pour les algèbres de Lie, Publ. Math. IHÉS 111 (2010), <chapter>; numbering as in [arXiv:0801.0446](https://arxiv.org/abs/0801.0446). <One sentence linking the previous talk.>*
```

The note ends with `## References` and a line like `Related: [[Endoscopy]] · next talk: [[<Title>]]`.

Statements and proofs:

- `**Definition 2.1** (Hitchin space; Ngô 4.2.1).`, `**Proposition 3.2** (Ngô 4.3.3).`, `**Theorem 3.3** (Bezrukavnikov; Ngô §3.7).`
- `*Proof.* ... ∎`, `*Sketch of proof.* ... ∎`, `*Ideas of the proofs.* ... ∎`
- In each note, definitions, propositions, lemmas, corollaries, theorems and examples share one counter per section: Definition 2.1, Lemma 2.2, Corollary 2.4, Example 2.5, and so on. A displayed equation that is referred to later gets `\tag{2.1}`; equations have their own counter.

Math:

- Quartz renders math with KaTeX. Use `$...$` inline and `$$...$$` for displays, with standard LaTeX only (no custom macros). Keep the `$` signs balanced.
- Reuse the notation of the existing notes: `\breve{\mathcal O}=\bar k[[\pi]]`, `\breve F=\bar k((\pi))`, `\mathfrak c=\mathfrak t/\!/W`, `\chi` for the Chevalley map, `\epsilon` for the Kostant section, `\mathfrak c^\heartsuit`, `J_a`, `\mathcal P(J_a)` for the local symmetry group and `\mathcal P_a` for the global one, `\mathcal M_a`, `\delta_a`, `B^\flat`, `\mathcal A^\heartsuit\supset\mathcal A^\diamondsuit`.

Links:

- Link notes with `[[Note title]]`, and embed figures with `![[file-name.svg]]`. The names must match the files exactly.
- When a note refers to an earlier talk, write it like "Lemma 2.2 of the previous note". Link the notes in both directions: in the last paragraph of the earlier note and in both "Related:" lines.
- The Hitchin note refers to these items of the affine Springer note: Definition 1.1, Proposition 1.6, Proposition 1.8, Lemma 2.2, equation (2.1), Example 2.6, Corollary 3.2, Theorem 3.3, Lemma 4.3, Proposition 6.1, §7, Example 8.2, and Figures 1(a), 1(b), 2(b) and 3. If you renumber anything in one note, update the references in the other one.

## 5. Figures

- Every drawing on the boards is redrawn by computer and placed where it belongs. First redraw it faithfully, then add what helps the reader: labels, and sometimes a second panel with a concrete case. If a board drawing is unclear, draw the standard version and tell Houjun.
- In the note, keep blank lines around the embed and the caption, and follow the caption with a paragraph that explains how to read the picture:

```
<the paragraph the figure illustrates>

![[<note-slug>-figN-<what>.svg]]

*Figure N. (a) ... (b) ...*

Panel (a) is the picture drawn on the board. <What each part of the picture is, and what to notice in it.>
```

- Name the files `<note-slug>-figN-<what>.svg`, so that they are unique in the vault, and put them in `attachments/`.
- Style: TikZ, compiled with pdflatex, converted with `pdftocairo -svg`, and scaled by 1.6 so that labels are about 13px. Each figure sits on a white rounded card, so it can be read in dark mode. The colours have a fixed meaning in all figures: blue = generic or regular, red = degenerate or non-regular (for example the discriminant), orange = a distinguished section or curve, grey = background.
- The TikZ sources of the seven existing figures were not kept, only the SVGs. To change one of them, edit the SVG directly or redraw it with the preamble below.

`preamble.tex`, next to the figure files:

```latex
\usepackage{amsmath,amssymb}
\usepackage{tikz}
\usetikzlibrary{arrows.meta,backgrounds,calc,intersections}
\definecolor{regcol}{RGB}{31,94,168}
\definecolor{nrcol}{RGB}{192,48,40}
\definecolor{seccol}{RGB}{214,120,0}
\definecolor{ink}{RGB}{35,35,35}
\definecolor{soft}{RGB}{125,125,125}
\tikzset{
  card/.style={show background rectangle,
    background rectangle/.style={fill=white, rounded corners=6pt},
    inner frame sep=9pt},
  >={Stealth[length=2.3mm,width=1.7mm]},
  lab/.style={font=\footnotesize, align=center, text=ink},
  ttl/.style={font=\small, text=ink},
  halo/.style={preaction={draw=white, line width=3.2pt, -}},
  nreg/.style={circle, draw=nrcol, fill=white, line width=1pt, inner sep=0pt, minimum size=5.2pt},
  regdot/.style={circle, fill=regcol, inner sep=0pt, minimum size=5.6pt},
}
```

A figure file, for example `fig1.tex`:

```latex
\documentclass[border=0pt]{standalone}
\input{preamble}
\begin{document}
\begin{tikzpicture}[card]
  \draw[regcol, very thick] (0,0) -- (3,1);
  \node[nreg] at (0,0) {};  \node[lab, text=nrcol, below] at (0,-0.1) {$L_{m,n}$};
  \node[ttl] at (1.5,-1) {(a) caption inside the figure};
\end{tikzpicture}
\end{document}
```

`figbuild.sh`, run inside the figures folder as `bash figbuild.sh fig1.tex <note-slug>-fig1-<what>.svg`. It compiles the figure, writes a PNG preview, and writes the scaled SVG:

```bash
#!/usr/bin/env bash
# usage: bash figbuild.sh figN.tex <final-name>.svg [scale]   (run inside the figs folder)
set -euo pipefail
tex="$1"; out="$2"; scale="${3:-1.6}"; base="${tex%.tex}"
pdflatex -interaction=nonstopmode -halt-on-error "$tex" > "$base.log" 2>&1 || { grep -A6 '^!' "$base.log"; exit 1; }
pdftocairo -svg "$base.pdf" "$base.raw.svg"
pdftocairo -png -r 170 -singlefile "$base.pdf" "$base.preview"
python3 - "$base.raw.svg" "$out" "$scale" <<'PY'
import re, sys
src, dst, f = sys.argv[1], sys.argv[2], float(sys.argv[3])
s = open(src).read()
head = re.search(r'<svg[^>]*>', s).group(0)
new = head
for a in ('width', 'height'):
    v = float(re.search(r'(?<=\s)' + a + r'="([\d.]+)', head).group(1))
    new = re.sub(r'(?<=\s)' + a + r'="[\d.]+(?:pt)?"', f'{a}="{v*f:.1f}"', new, count=1)
assert 'viewBox' in new
open(dst, 'w').write(s.replace(head, new, 1))
print('wrote', dst, '|', new[new.find('width'):new.find('viewBox')])
PY
```

Look at each preview and fix overlapping or crowded labels before you copy the SVG into `attachments/`. Two TikZ tips: a path named inside a scope (for example under `\clip`) needs `name path global=` to be intersected outside it, and `\foreach` over values that contain commas fails, so compute them first with `\pgfmathsetmacro`.

## 6. Checks before you finish

1. **Formulas.** Render every formula with KaTeX. It must print `errors 0`.

```bash
mkdir -p /tmp/katexcheck && cd /tmp/katexcheck
npm init -y >/dev/null && npm install katex@0.16.11 >/dev/null 2>&1
cat > check.js <<'EOF'
// usage: node check.js note.md  -> renders every $...$ and $$...$$ with KaTeX; prints errors
const fs = require('fs'), katex = require('katex');
const body = fs.readFileSync(process.argv[2], 'utf8').replace(/^---[\s\S]*?---/, '');
const re = /\$\$([\s\S]*?)\$\$|\$([^$\n]+?)\$/g; let m, n = 0, bad = 0;
while ((m = re.exec(body)) !== null) {
  n++; const tex = (m[1] ?? m[2]).replace(/^>\s?/gm, '');
  try { katex.renderToString(tex, {displayMode: !!m[1], throwOnError: true, strict: false}); }
  catch (e) { bad++; console.log('ERR:', e.message.slice(0, 160), '\n  in:', tex.slice(0, 120)); }
}
console.log('segments', n, 'errors', bad);
EOF
node check.js "<path to the note>"
```

2. **Coverage.** Every item on the boards is in the note.
3. **Accuracy.** The numbered statements agree with the paper, and the computations in the examples have been redone.
4. **Figures and links.** Every `![[...]]` has its file in `attachments/`, and every `[[...]]` points to an existing note.
5. **Cross-references.** The numbers that one note quotes from the other still match (section 4).
6. **Readability.** Read the note from top to bottom as a reader would. Each paragraph should lead to the next.

At the end, tell Houjun in Chinese, briefly: what you changed or added, which figures come from the boards, anything on the boards you could not read, and any place where the boards and the paper disagree.
