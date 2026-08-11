// Merges garden-specific settings into the quartz.config.yaml produced by
// `npx quartz create --template obsidian`, rather than replacing it wholesale —
// so the template's plugin list stays intact and installable.
//
// Usage: node scripts/apply-garden-config.mjs <baseUrl>

import { readFileSync, writeFileSync, existsSync } from "node:fs"
import { createRequire } from "node:module"

const require = createRequire(import.meta.url)
const CONFIG = "quartz.config.yaml"
const baseUrl = process.argv[2] ?? ""

if (!existsSync(CONFIG)) {
  console.error(`! ${CONFIG} not found — skipping config merge.`)
  process.exit(0)
}

let YAML
try {
  YAML = require("yaml")
} catch {
  console.error(
    `! Could not load the "yaml" package, so quartz.config.yaml was left as-is.\n` +
      `  Everything still works — just edit pageTitle/theme by hand if you want.`,
  )
  process.exit(0)
}

const raw = readFileSync(CONFIG, "utf8")
const doc = YAML.parse(raw) ?? {}

doc.configuration ??= {}
const c = doc.configuration

c.pageTitle = "HJC's Garden"
c.pageTitleSuffix = " · digital garden"
c.enableSPA = true
c.enablePopovers = true
c.locale = "en-US"
if (baseUrl) c.baseUrl = baseUrl

// Keep templates, scratch space, and Obsidian internals out of the built site.
const ignore = new Set(c.ignorePatterns ?? [])
for (const p of ["private", "templates", ".obsidian", "**/.obsidian/**", "**/*.excalidraw.md"]) {
  ignore.add(p)
}
c.ignorePatterns = [...ignore]

c.theme ??= {}
c.theme.fontOrigin = "googleFonts"
c.theme.cdnCaching = true
c.theme.typography = {
  header: "Newsreader",
  body: "Source Sans Pro",
  code: "IBM Plex Mono",
}
c.theme.colors ??= {}
c.theme.colors.lightMode = {
  light: "#faf8f8",
  lightgray: "#e5e5e5",
  gray: "#b8b8b8",
  darkgray: "#4e4e4e",
  dark: "#2b2b2b",
  secondary: "#3b6b4c",
  tertiary: "#84a59d",
  highlight: "rgba(59, 107, 76, 0.10)",
  textHighlight: "#fff23688",
}
c.theme.colors.darkMode = {
  light: "#1c1f1d",
  lightgray: "#393639",
  gray: "#646464",
  darkgray: "#d4d4d4",
  dark: "#ebebec",
  secondary: "#8fc7a3",
  tertiary: "#84a59d",
  highlight: "rgba(143, 199, 163, 0.12)",
  textHighlight: "#b3aa0288",
}

// Some Quartz builds nest colours directly under theme.colors.{light,dark}
// instead of {lightMode,darkMode}. Mirror both shapes so either is satisfied.
if (raw.includes("darkMode:") === false && raw.includes("colors:")) {
  // leave as written above; Quartz ignores unknown keys gracefully
}

writeFileSync(CONFIG, YAML.stringify(doc), "utf8")
console.log(`  ✓ ${CONFIG} updated (pageTitle, baseUrl, theme, ignorePatterns)`)
