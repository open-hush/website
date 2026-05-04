# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

Package manager is **pnpm 10.33** (Node 24.14.1, see `.nvmrc`). All commands also wrap in the `Makefile`.

- `pnpm dev` — dev server at http://localhost:4321
- `pnpm build` — static build to `dist/`
- `pnpm preview` — serve `dist/` locally
- `pnpm check` — type-check Astro + TS (`astro check`); this is the only "test" gate, there is no unit-test suite

## Architecture

Astro 5 static site, vanilla CSS, TypeScript strict. **Zero JS by default** — only ship client JS when a component genuinely needs it.

- **`src/config/site.ts`** — single source for site metadata (`SITE`) and `NAV_LINKS`. Edit here, not in components.
- **`src/layouts/BaseLayout.astro`** — owns `<head>`, SEO, OpenGraph, JSON-LD, skip link, `<Nav>` and `<Footer>`. All pages should wrap in this layout and pass `title` / `description` / `pathname`.
- **`design.md`** — **canonical** design contract. Defines the brand palette, typography, spacing, and radii; an `Extensions` section documents derived tokens that the contract doesn't cover. When `design.md` and `tokens.css` diverge, `design.md` wins — update `tokens.css` to match.
- **`src/styles/tokens.css`** — operational mirror of `design.md`. Holds every CSS variable consumed by components (colors, type scale `--fs-*`, spacing `--space-*`, radii, fonts, shadows, motion). A `[data-theme="tech"]` block remaps semantic tokens for dark/tech sections (used in dev pages and code blocks).
- **`src/styles/global.css`** — reset and base styles only.
- **Path alias `~/*` → `src/*`** (configured in `tsconfig.json`). Use it in imports instead of relative paths.
- **`@astrojs/sitemap`** integration emits `/sitemap-index.xml` automatically; site origin is hardcoded to `https://open-hush.com` in `astro.config.mjs`.

## Design system (load-bearing)

This repo has a project-specific **`design-system`** skill (`.claude/skills/design-system`) that MUST be consulted when creating or editing any UI (`.astro`, `.css`, components, pages, layouts). Hard rules:

1. Never write raw hex colors, raw `px`/`rem` font sizes, raw spacing values, raw `border-radius` px, raw `font-family`, or invented shadows in `.astro`/`.css`/inline styles. Always use `var(--color-*)`, `var(--fs-*)`, `var(--space-*)`, `var(--radius-*)`, `var(--font-*)`, `var(--shadow-*)`.
2. If a needed token doesn't exist, **add it to `tokens.css` first**, then reference it. Do not bypass.
3. Prefer semantic tokens (`--color-fg`, `--color-surface`, `--color-border`) over accent tokens for structural elements so components respect the `data-theme="tech"` override automatically — don't duplicate theme rules.
4. `design.md` is the canonical design contract; `tokens.css` is what code reads and must mirror it. When they disagree, **`design.md` wins** — update `tokens.css` to match (or, if the divergent value belongs in the system, promote it to `design.md > Extensions`). Flag drift, never silently propagate it.
5. Every interactive element must define `:hover`, `:focus-visible`, `:active`, and `[disabled]` states. Hit areas ≥ 24×24 CSS px.

Exceptions to the "no raw values" rule: `tokens.css` itself, third-party CSS imports, and SVG `fill`/`stroke` inside `public/` assets.

## Conventions

- All source artifacts (code, comments, copy in components) are in **English**, even when the conversation is in Spanish.
- One Astro component per concern in `src/components/` — keep them small and composable rather than adding props for variants.
- Use `astro:assets` (`<Image>`) for local images in `src/assets/`. Files in `public/` are served as-is.
- Markdown code blocks render with Shiki theme `github-dark` (configured in `astro.config.mjs`).

## Deployment

`pnpm build` produces a fully static `dist/`. The included `Dockerfile` is a two-stage build that compiles the site and serves `dist/` from `nginx` on port 80 (used for Dokploy). Any static host (Vercel, Cloudflare Pages, Netlify) also works — no SSR adapter is configured.
