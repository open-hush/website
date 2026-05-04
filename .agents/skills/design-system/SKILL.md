---
name: design-system
description: Enforces the OpenHush website design system. Use when creating or editing any UI in this project (.astro, .css, components, pages, layouts), when adding colors/spacing/typography, when reviewing UI for accessibility, or when the user asks for a design audit. Ensures all UI consumes design tokens from src/styles/tokens.css instead of raw hex/px/font values, follows accessibility and writing-tone standards, and detects drift between design.md and the implemented tokens.
---

# OpenHush Design System

## Mission

Keep the OpenHush UI consistent, accessible, and faithful to the design intent declared in `design.md`. Every component must consume tokens, respect interaction states, and meet WCAG 2.2 AA. When aesthetics and accessibility conflict, accessibility wins.

## Brand

OpenHush aims for a clear, confident, and friendly visual style: bright accents, rounded shapes, generous spacing, and tactile interactive elements. Personality without noise — guidance over decoration.

## Sources of truth

- **`src/styles/tokens.css`** — operational source of truth. Every CSS variable consumed by components lives here.
- **`design.md`** — design intent (frontmatter spec). Used as a reference, but the code does not read it.

When in conflict, **`tokens.css` wins for code**. Drift between the two must be flagged, never silently propagated.

---

## Hard rules when writing or editing UI

1. **Never write raw hex colors** in `.astro`, `.css`, or inline styles. Use `var(--color-*)`.
2. **Never write raw `px`/`rem` font sizes**. Use `var(--fs-*)`.
3. **Never write raw spacing values** (margin/padding/gap). Use `var(--space-*)`.
4. **Never write raw `border-radius` pixel values**. Use `var(--radius-*)`.
5. **Never hardcode a `font-family`** outside `tokens.css`. Use `var(--font-sans|display|mono)`.
6. **Never invent shadows**. Use `var(--shadow-sm|md|lg)`.
7. If a needed token doesn't exist, **add it to `tokens.css` first**, then reference it. Do not bypass.
8. Theme-aware components must rely on the `[data-theme="tech"]` overrides, not duplicated rules.

Exceptions: `tokens.css` itself, third-party CSS imports, and SVG `fill`/`stroke` attributes inside `public/` assets.

---

## Do

- Prefer **semantic tokens** (`--color-fg`, `--color-surface`, `--color-border`) over accent tokens for structural elements, so components respect theme overrides automatically.
- **Preserve visual hierarchy** through size, weight, and spacing — not arbitrary color shifts.
- Make **interaction states explicit**: every interactive element must define `:hover`, `:focus-visible`, `:active`, and `[disabled]` (and `[aria-busy="true"]` if it can load).
- Anchor every spacing decision to the `--space-*` scale; rhythm comes from reuse, not bespoke values.
- Pair color with a non-color signal (icon, weight, underline) for any state that conveys meaning.

## Don't

- Avoid **low-contrast text** (see Accessibility below).
- Avoid **inconsistent spacing rhythm** — don't mix `--space-3` and `--space-5` adjacently without a structural reason.
- Avoid **decorative motion without purpose**. Animation must communicate state, position, or causality.
- Avoid **ambiguous labels** ("Click here", "Submit", "OK"). Use action + object ("Save changes", "Open developer guide").
- Avoid **mixing visual metaphors** (e.g., neumorphism + flat + glassmorphism in the same view).
- Avoid **inaccessible hit areas**: interactive targets must be ≥ 24×24 CSS px (44×44 recommended on touch).

Pair every "do" with a concrete "don't" when proposing rules.

---

## Accessibility (WCAG 2.2 AA, testable)

Every UI change must satisfy these acceptance criteria:

- **Contrast**: body text ≥ 4.5:1, large text (≥ 18.66px bold or ≥ 24px regular) ≥ 3:1, non-text UI (borders, focus rings, icons that convey state) ≥ 3:1.
- **Keyboard**: every interactive element reachable via Tab in DOM order, operable with Enter/Space, dismissible (modals, menus) with Escape.
- **Focus visible**: a clearly visible `:focus-visible` outline using a token-defined color and ≥ 2px thickness. Never `outline: none` without a replacement.
- **Hit target**: minimum 24×24 CSS px; aim for 44×44 on primary touch targets.
- **Semantics**: use the right element (`<button>` for actions, `<a>` for navigation). ARIA only when no native element fits.
- **Motion**: respect `prefers-reduced-motion: reduce` — disable non-essential animations and transitions.
- **Forms**: every input has a programmatically associated `<label>`; errors are announced (`aria-describedby`, `role="alert"`) and not communicated by color alone.
- **Images**: `alt=""` for decorative, descriptive `alt` for informational. SVG icons used as buttons need an accessible name.

Each criterion above is testable in implementation or code review. If a design proposal conflicts with accessibility, flag it and prioritize accessibility.

---

## Writing tone

- **Concise, confident, helpful.** Active voice. Imperative for actions ("Save", "Continue", "Try the developer guide").
- Lead with the user's goal, not the system's mechanism.
- Avoid jargon unless the section is for developers. In `/developers`, technical precision is encouraged.
- Errors describe **what happened + what to do next**, never blame the user.
- Empty states explain **what will appear here** and **how to get there**.

Examples:

- ✅ "Save changes" / ❌ "OK"
- ✅ "We couldn't reach the server. Check your connection and try again." / ❌ "Error 503."
- ✅ "No projects yet. Create your first project to start." / ❌ "List is empty."

---

## Available tokens (read from `src/styles/tokens.css`)

Before suggesting a value, **read `src/styles/tokens.css`** to confirm the current token names and values. Do not rely on memory — tokens evolve.

Categories: `--color-*`, `--fs-100..900`, `--space-1..9`, `--radius-{sm,md,lg,xl,pill}`, `--font-{sans,display,mono}`, `--shadow-{sm,md,lg}`, `--container-*`, `--nav-height`, `--ease-out`, `--duration*`.

---

## When creating new components

1. Read `src/styles/tokens.css` first.
2. Check `src/components/` for an existing component that already does what you need — prefer composition over duplication.
3. Use semantic tokens (`--color-fg`, `--color-surface`, `--color-border`) before reaching for accent tokens, so the component automatically respects `[data-theme="tech"]`.
4. Define **all required states**: `default`, `hover`, `focus-visible`, `active`, `disabled`, plus `loading` and `error` if applicable.
5. Specify **interaction behavior** for keyboard, pointer, and touch.
6. State **token usage explicitly** in the component (no magic numbers).
7. Handle **edge cases**: long labels (truncate or wrap?), empty states, overflow, narrow viewports.
8. If a needed value has no token, add the token to `tokens.css` in the appropriate group, then use it.

---

## Audit procedure

Run when the user asks for a design audit, or proactively after non-trivial UI changes. Read-only by default — only edit when explicitly asked.

### Step 1 — Scan for raw values that should be tokens

From the project root:

```bash
# Raw hex colors in components/styles (excluding tokens.css and public assets)
grep -rEn '#[0-9a-fA-F]{3,8}\b' src --include='*.astro' --include='*.css' --include='*.ts' \
  | grep -v 'src/styles/tokens.css'

# Raw font-family declarations outside tokens.css
grep -rEn 'font-family\s*:' src --include='*.astro' --include='*.css' \
  | grep -v 'src/styles/tokens.css'

# Raw px/rem in font-size, padding, margin, gap, border-radius
grep -rEn '(font-size|padding|margin|gap|border-radius)\s*:\s*[0-9.]+(px|rem)' src \
  --include='*.astro' --include='*.css' \
  | grep -v 'src/styles/tokens.css'
```

### Step 2 — Detect drift between `design.md` and `tokens.css`

Compare:

- Colors in `design.md` frontmatter (`colors:` block) vs. `--color-*` in `tokens.css`.
- Typography fonts in `design.md` vs. `--font-*`.
- Spacing/radius scales in `design.md` vs. `--space-*` / `--radius-*`.

Report any value present in one but missing or different in the other. **Do not auto-fix this** — surface it to the user and ask which side is canonical.

### Step 3 — Report format

```
## Design audit

### Raw values (should be tokens)
- src/components/Hero.astro:42 — color: #e8643c → use var(--color-primary)
- ...

### design.md ↔ tokens.css drift
- primary: design.md says #58cc02, tokens.css uses #e8643c (--color-accent)
- ...

### Accessibility findings
- src/components/CTA.astro: button without :focus-visible style
- ...

### Suggested fixes
<concrete edits, only if requested>
```

---

## QA checklist (run in code review)

Tick every item before approving a UI change:

- [ ] No raw hex / px / rem / font-family / shadow values outside `tokens.css`.
- [ ] All new tokens added to `tokens.css`, grouped correctly.
- [ ] Interactive elements define `:hover`, `:focus-visible`, `:active`, `[disabled]`.
- [ ] Focus indicator visible and ≥ 2px, using a token color.
- [ ] Color contrast verified (body ≥ 4.5:1, large text ≥ 3:1, non-text UI ≥ 3:1).
- [ ] Hit targets ≥ 24×24 CSS px.
- [ ] Keyboard reachable in DOM order; Escape dismisses overlays.
- [ ] `prefers-reduced-motion` respected.
- [ ] Native semantic element used (or ARIA justified).
- [ ] Labels are action+object, not "OK"/"Submit"/"Click here".
- [ ] Empty/error/loading states defined for stateful components.
- [ ] No new visual metaphor introduced unless a migration plan is included.
- [ ] `design.md` ↔ `tokens.css` drift not increased.

---

## Anti-patterns to reject

- `style="color: #fff"` inline.
- `font-family: Inter, sans-serif` repeated in a component.
- `padding: 16px` instead of `var(--space-4)`.
- New CSS variable defined inside a component instead of in `tokens.css`.
- Copy-pasting a hex from `design.md` into a component without going through a token.
- `outline: none` on `:focus` without a replacement focus style.
- `<div onclick=...>` instead of `<button>`.
- Color-only error states (red text without icon or text label).
- Animations without `prefers-reduced-motion` fallback.
- Generic labels: "OK", "Submit", "Click here", "Read more" without context.

---

## Migration notes

When updating a component to follow these rules:

1. Replace raw values with tokens **one category at a time** (colors, then spacing, then typography). Easier to review.
2. Add missing interaction states in the same PR — don't defer accessibility.
3. If you introduce a new token, document its intent in a comment inside `tokens.css`.
4. After the change, run the audit (Step 1) on the touched files to confirm zero raw values.
