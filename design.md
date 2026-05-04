---
name: OpenHush Website
colors:
  primary: "#58cc02"
  secondary: "#ce82ff"
  success: "#58cc02"
  warning: "#ffc800"
  danger: "#ff4b4b"
  surface: "#FFFFFF"
  text: "#3c3c3c"
  neutral: "#FFFFFF"
typography:
  h1:
    fontFamily: "Nunito"
    fontSize: 2rem
  body-md:
    fontFamily: "Nunito"
    fontSize: 1rem
  label-caps:
    fontFamily: "JetBrains Mono"
    fontSize: 0.75rem
  sourceScale: "12/14/16/20/24/32"
  weights: "400, 500, 600, 700, 800, 900"
rounded:
  sm: 4px
  md: 8px
spacing:
  sm: 4px
  md: 8px
  sourceScale: "4/8/12/16/24/32"
---

## Overview

Playful, minimal design with bright colors, rounded shapes, tactile 3D borders, and friendly illustrations for approachable interfaces.

## Style Foundations

- **Visual style:** bold, playful
- **Typography scale:** 12/14/16/20/24/32
- **Typography fonts:** primary=Nunito, display=Nunito, mono=JetBrains Mono
- **Typography weights:** 400, 500, 600, 700, 800, 900
- **Color palette:** primary, neutral, success, warning, danger
- **Spacing scale:** 4/8/12/16/24/32

## Colors

- **Primary (#58cc02):** Token from style foundations.
- **Secondary (#ce82ff):** Token from style foundations.
- **Success (#58cc02):** Token from style foundations.
- **Warning (#ffc800):** Token from style foundations.
- **Danger (#ff4b4b):** Token from style foundations.
- **Surface (#FFFFFF):** Token from style foundations.
- **Text (#3c3c3c):** Token from style foundations.
- **Neutral (#FFFFFF):** Derived from the surface token for official format compatibility.

## Extensions (derived tokens)

These tokens are not part of the canonical design contract but are required to
implement the system in code. They derive from the canonical palette and must
not be edited without updating `src/styles/tokens.css` in lockstep.

- `--color-bg`: alias of `surface` (page background)
- `--color-muted`: `#6f6f6f` — secondary text, ≥ 4.5:1 contrast on surface
- `--color-border`: `#e5e5e5` — hairline borders
- `--color-accent`: alias of `primary` — decorative fill role only
- `--color-accent-soft`: `#dff5c2` — 12% tint of primary, used for chips, code background, soft fills
- `--color-primary-strong`: `#3d8c00` — darkened primary for foreground use on light backgrounds (4.24:1 on white). On `[data-theme="tech"]` falls back to canonical `primary`
- `--color-secondary-strong`: `#9333d9` — darkened secondary for foreground use on light backgrounds (5.65:1 on white). On `[data-theme="tech"]` falls back to canonical `secondary`
- `--color-focus-ring`: alias of `secondary-strong` — used for `:focus-visible` outlines
- `--radius-lg`: `16px` — cards, mini-cards, code blocks
- `--radius-xl`: `24px` — device illustrations
- `--radius-pill`: `999px` — pill buttons and tags
- `--space-7/8/9`: clamp() values for section-level vertical padding
- `--icon-stroke`: `2px` — decorative line strokes
- `--hit-target-min`: `44px` — minimum interactive target

### Tech theme overrides

The `[data-theme="tech"]` block maps the canonical palette onto a dark
GitHub-Primer-inspired surface for developer-facing sections. Primary,
secondary, success, warning, and danger remain unchanged across themes; only
`--color-bg`, `--color-fg`, `--color-muted`, `--color-surface`,
`--color-border`, `--color-accent` and `--color-accent-soft` are remapped.