# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## Commands

Package manager **pnpm 10.33** on Node **24.14.1** (see `.nvmrc`). All scripts are also wrapped in the `Makefile`.

- `pnpm dev` — dev server at http://localhost:4321
- `pnpm build` — static build to `dist/`
- `pnpm preview` — serve `dist/` locally
- `pnpm check` — `astro check` (Astro + TypeScript). This is the only test gate; there is no unit-test suite.

## Architecture

Astro 5 static site, vanilla CSS, TypeScript strict (`astro/tsconfigs/strict`). **Zero JS by default** — only ship client JS when a component genuinely needs it.

- **`src/config/site.ts`** — single source for site metadata (`SITE`) and `NAV_LINKS`. Edit here, not in components.
- **`src/layouts/BaseLayout.astro`** — owns `<head>`, SEO, OpenGraph, JSON-LD, skip link, `<Nav>` and `<Footer>`. All pages should wrap in this layout and pass `title` / `description` / `pathname`.
- **`design.md`** — **canonical** design contract. Defines the brand palette (lime primary `#58cc02`, purple secondary, success/warning/danger), typography (Nunito + JetBrains Mono), and spacing/radius scales (`12/14/16/20/24/32`, `4/8/12/16/24/32`, radii `4/8`). An `Extensions` section documents derived tokens that the canonical contract doesn't cover (e.g., `--color-primary-strong`, `--color-muted`, `--space-7..9`).
- **`src/styles/tokens.css`** — operational mirror of `design.md`. Holds every CSS variable consumed by components (`--color-*`, `--fs-*`, `--space-*`, `--radius-*`, `--font-*`, `--shadow-*`, motion). A `[data-theme="tech"]` block remaps semantic tokens for dark/tech sections (used in dev pages and code blocks).
- **`src/styles/global.css`** — font imports, reset, base element styles, and the `prefers-reduced-motion` fallback. No component styles.
- **Path alias `~/*` → `src/*`** (configured in `tsconfig.json`). Use it in imports instead of relative paths.
- **`@astrojs/sitemap`** integration emits `/sitemap-index.xml` automatically; site origin is hardcoded to `https://open-hush.com` in `astro.config.mjs`.

## Design system (load-bearing)

A project-specific **`design-system`** skill lives at `.claude/skills/design-system/SKILL.md` and MUST be consulted when creating or editing any UI (`.astro`, `.css`, components, pages, layouts). Hard rules:

1. Never write raw hex colors, raw `px`/`rem` font sizes, raw spacing values, raw `border-radius` px, raw `font-family`, or invented shadows in `.astro`/`.css`/inline styles. Always use `var(--color-*)`, `var(--fs-*)`, `var(--space-*)`, `var(--radius-*)`, `var(--font-*)`, `var(--shadow-*)`.
2. If a needed token doesn't exist, **add it to `tokens.css` first** (and document it under `design.md > Extensions` if it's structural), then reference it. Do not bypass.
3. Prefer semantic tokens (`--color-fg`, `--color-surface`, `--color-border`) over accent tokens for structural elements so components respect the `data-theme="tech"` override automatically — don't duplicate theme rules.
4. `design.md` is the canonical design contract; `tokens.css` is what code reads and must mirror it. When they disagree, **`design.md` wins** — update `tokens.css` to match (or, if the divergent value belongs in the system, promote it to `design.md > Extensions`). Flag drift, never silently propagate it.
5. Use the AA-compliant `--color-*-strong` variants (`--color-primary-strong`, `--color-secondary-strong`) whenever a brand color appears as foreground (text, icon, focus ring) on a light background — the canonical bright colors (`#58cc02`, `#ce82ff`) fail WCAG AA on white. The `[data-theme="tech"]` block remaps the strong variants back to the canonical brights, since dark backgrounds already pass contrast.
6. Every interactive element must define `:hover`, `:focus-visible`, `:active`, and `[disabled]` states. Hit areas ≥ 24×24 CSS px (44×44 preferred for primary touch targets).

Exceptions to the "no raw values" rule: `tokens.css` itself, third-party CSS imports, SVG `fill`/`stroke` inside `public/` assets, and convention-bound colors documented in code (Apple traffic-light dots in `CodeBlock`, `mask-image` alpha, `<meta name="theme-color">` HTML attribute).

## Conventions

- All source artifacts (code, comments, copy in components) are in **English**, even when the conversation is in Spanish.
- One Astro component per concern in `src/components/` — keep them small and composable rather than adding props for variants.
- For local images, place them in `src/assets/` and use `<Image>` from `astro:assets`. Files in `public/` are served as-is.
- Markdown code blocks render with Shiki theme `github-dark` (configured in `astro.config.mjs`).
- Local visual-review artifacts (screenshots, browser snapshots) go in `.review/` and `.playwright-mcp/` — both gitignored.

## Deployment

`pnpm build` produces a fully static `dist/`. The included `Dockerfile` is a multi-stage build that compiles the site with pnpm and serves `dist/` from `nginx` on port 80 (used for Dokploy). Any static host (Vercel, Cloudflare Pages, Netlify) also works — no SSR adapter is configured.
