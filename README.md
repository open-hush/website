# OpenHush — Website

Public site for the [OpenHush](https://open-hush.com) project. Built with [Astro](https://astro.build) — static, fast, and zero JS by default.

## Stack

- **Astro 5** — static site generator
- **Vanilla CSS** — design tokens in `src/styles/tokens.css`, no Tailwind
- **TypeScript** — strict mode
- **`@fontsource/*`** — self-hosted Inter, Fraunces, JetBrains Mono
- **`@astrojs/sitemap`** — automatic sitemap generation

## Project structure

```
src/
├── config/site.ts         # Site metadata + nav links
├── styles/
│   ├── tokens.css         # Color, type, spacing tokens
│   └── global.css         # Reset + base styles
├── layouts/BaseLayout.astro
├── components/            # Astro components (one .astro per concern)
├── pages/
│   ├── index.astro        # Landing
│   ├── developers.astro   # Developer guide
│   └── 404.astro
└── assets/                # Local images & icons (use astro:assets)
public/                    # Static files served as-is
```

## Develop

```bash
pnpm install
pnpm dev          # http://localhost:4321
```

## Build

```bash
pnpm build        # outputs to dist/
pnpm preview      # serve dist/ locally
pnpm check        # type-check Astro + TS
```

## Deploy

The `dist/` folder is fully static — drop it on Vercel, Cloudflare Pages, Netlify, or any static host.

## TODOs before going public

- Replace placeholder URLs in `src/config/site.ts` (GitHub, repos, social).
- Add a real `public/og-image.png` (1200×630) — currently missing.
- Pick a license and update `SITE.license`.
- Hook up analytics (Plausible recommended).
