---
title: Novel
description: Fiction in progress.
---

The working space for a novel: outline, characters, world notes, and scenes. Drafts
live one file per scene, so they can be reordered without touching a monolith.

> [!warning] Where the drafts live
> `draft: true` keeps a note off the built site — but the Markdown still gets
> committed, so on a public repo anyone can read it. `content/private/` is
> gitignored as well as unbuilt, so nothing in it leaves this machine. That's
> where the fiction goes.

## Working files

All under `content/private/novel/`, which never reaches GitHub:

- `outline.md` — structure, beats, what the book is arguing
- `characters.md` — who wants what, and what's stopping them
- `scenes/` — the drafts themselves, one file per scene

Still editable in Obsidian exactly like any other note — `private/` is inside the
vault, just outside the build and outside git. New scenes belong there too, not in
`content/novel/`.

## Working rules

- **Scene = a change.** If nothing is different at the end, it's not a scene yet.
- **Outline in pencil.** The outline serves the draft, not the other way around. When
  the draft contradicts the outline and the draft is better, update the outline.
- **Log the abandoned versions.** Cut scenes go to `scenes/cut/` rather than the bin —
  the third act frequently needs something from the discarded first.
