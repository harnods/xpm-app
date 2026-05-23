# XPM Mobile — Design Implementation Spec

> **Purpose:** This document is the source-of-truth contract between the HTML prototype (`index.html`) and the future Flutter implementation. AI coding agents converting this prototype to Flutter MUST follow the token mappings and rules in this doc exactly. Do not infer or guess tokens — every CSS variable used in `index.html` has an explicit Flutter Dart equivalent listed below.
>
> **Target framework:** Flutter (Mekari Pixel 2.4 design system)
> **Source of truth:** `index.html` (single-file HTML prototype, all screens/overlays/sheets in one file)
> **Last updated:** keep this updated as `index.html` evolves — see [Changelog](#changelog) at bottom

---

## 1. How to read this doc

- CSS variables in `index.html` use the prefix `--MpColors-*`, `--MpSpacing-*`, `--MpRadius-*`, `--MpTextStyles-*`, `--MpFont-*`. These mirror Pixel Flutter Dart class names (`MpColors`, `MpSpacing`, `MpRadius`, `MpTextStyles`, `MpFont`).
- Mapping rule: `--{Category}-{path}` in CSS → `{Category}.{path}` in Dart.
  - Example: `var(--MpColors-text-primary)` → `MpColors.text.primary.resolve(context)`
  - Example: `var(--MpSpacing-medium)` → `MpSpacing.medium`
  - Example: `var(--MpTextStyles-md-fontSize)` → `MpTextStyles.md.fontSize` (or use the full `MpTextStyles.md` TextStyle).
- Custom XPM-only tokens use the prefix `--XpmColors-*`. These do NOT exist in Pixel Flutter — they must be defined in the Flutter app's theme as project-local constants.
- Any hex value left hardcoded in `index.html` is intentionally outside the token system (prototype chrome — see [§6](#6-excluded-from-flutter-prototype-chrome)).

---

## 2. Typography tokens

All app text uses one of the six MpTextStyles sizes. Font family is **Inter** (`MpFont.inter`).

| CSS variable | Dart path | Value |
|---|---|---|
| `--MpTextStyles-xxs-fontSize` | `MpTextStyles.xxs.fontSize` | `10px` |
| `--MpTextStyles-xxs-lineHeight` | `MpTextStyles.xxs.height` | `12px` |
| `--MpTextStyles-xs-fontSize` | `MpTextStyles.xs.fontSize` | `12px` |
| `--MpTextStyles-xs-lineHeight` | `MpTextStyles.xs.height` | `16px` |
| `--MpTextStyles-sm-fontSize` | `MpTextStyles.sm.fontSize` | `14px` |
| `--MpTextStyles-sm-lineHeight` | `MpTextStyles.sm.height` | `20px` |
| `--MpTextStyles-md-fontSize` | `MpTextStyles.md.fontSize` | `16px` |
| `--MpTextStyles-md-lineHeight` | `MpTextStyles.md.height` | `24px` |
| `--MpTextStyles-l-fontSize` | `MpTextStyles.l.fontSize` | `20px` |
| `--MpTextStyles-l-lineHeight` | `MpTextStyles.l.height` | `28px` |
| `--MpTextStyles-xl-fontSize` | `MpTextStyles.xl.fontSize` | `24px` |
| `--MpTextStyles-xl-lineHeight` | `MpTextStyles.xl.height` | `32px` |
| `--MpTextStyles-regular` | `FontWeight.w400` | `400` |
| `--MpTextStyles-semiBold` | `FontWeight.w600` | `600` |
| `--MpTextStyles-letterSpacingDense` | letter spacing | `-0.2px` |
| `--MpFont-inter` | `MpFont.inter` | `Inter` |

**Rule:** Only `regular (400)` and `semiBold (600)` exist in Pixel. There is no `bold (700)` or `medium (500)` token — any HTML occurrence of those weights has been rounded to `semiBold (600)`.

---

## 3. Spacing tokens

All padding, margin, and gap values in app UI use these tokens.

| CSS variable | Dart path | Value |
|---|---|---|
| `--MpSpacing-xSmall4` | `MpSpacing.xSmall4` | `2px` |
| `--MpSpacing-xSmall3` | `MpSpacing.xSmall3` | `4px` |
| `--MpSpacing-xSmall2` | `MpSpacing.xSmall2` | `6px` |
| `--MpSpacing-xSmall` | `MpSpacing.xSmall` | `8px` |
| `--MpSpacing-small` | `MpSpacing.small` | `12px` |
| `--MpSpacing-medium` | `MpSpacing.medium` | `16px` |
| `--MpSpacing-large` | `MpSpacing.large` | `20px` |
| `--MpSpacing-xLarge` | `MpSpacing.xLarge` | `24px` |
| `--MpSpacing-xLarge2` | `MpSpacing.xLarge2` | `32px` |
| `--MpSpacing-xLarge3` | `MpSpacing.xLarge3` | `40px` |

**Exceptions (intentionally hardcoded — no token exists):**
- `1px`, `3px`, `5px` — fine-tuning offsets for visual alignment.
- `10px`, `14px` — between-token values; use closest token (`xSmall=8` or `small=12` for 10; `small=12` or `medium=16` for 14) when implementing in Flutter.
- Negative margins (e.g. `margin-left:-8px`) — these are typically icon-overlap layouts; reconsider with Stack/Positioned in Flutter.

---

## 4. Radius tokens

| CSS variable | Dart path | Value |
|---|---|---|
| `--MpRadius-small` | `MpRadius.small` | `4px` |
| `--MpRadius-medium` | `MpRadius.medium` | `6px` |
| `--MpRadius-xLarge` | `MpRadius.xLarge` | `12px` |
| `--MpRadius-full` | `MpRadius.full` | `999px` (use `BorderRadius.circular(999)` or `StadiumBorder`) |

---

## 5. Color tokens

### 5.1 Background — `MpColors.bg.*`

| CSS variable | Dart path | Hex | Use case |
|---|---|---|---|
| `--MpColors-bg-surface` | `MpColors.bg.surface` | `#F2EFED` | Primary app surface |
| `--MpColors-bg-stage` | `MpColors.bg.stage` | `#FFFFFF` | Card / sheet / elevated content |
| `--MpColors-bg-subtle` | `MpColors.bg.subtle` | `#F0F1F3` | Subtle interactive bg, list-item active state, unread notification bg |
| `--MpColors-bg-inverse` | `MpColors.bg.inverse` | `#1D2125` | Dark FAB pill, inverse surfaces |
| `--MpColors-bg-disabled` | `MpColors.bg.disabled` | `rgba(29,31,36,0.04)` | Disabled button bg |
| `--MpColors-bg-brand` | `MpColors.bg.brand` | `#EEF0FC` | Light brand bg (action tiles, icon boxes, AI tag bg, OCR bar, info banner) |
| `--MpColors-bg-brandBold` | `MpColors.bg.brandBold` | `#4B61DC` | Primary buttons, unread dot, progress fill, "Approve" badges |
| `--MpColors-bg-highlight` | `MpColors.bg.highlight` | `#F3F1FC` | Light violet bg (trip card icon, highlight icon boxes) |
| `--MpColors-bg-warning` | `MpColors.bg.warning` | `#FDF6DD` | Warning banner / avatar / icon box bg |
| `--MpColors-bg-success` | `MpColors.bg.success` | `#F2F9F6` | Success icon box bg |
| `--MpColors-bg-successBold` | `MpColors.bg.successBold` | `#1C8459` | Bold success surfaces |
| `--MpColors-bg-danger` | `MpColors.bg.danger` | `#FCEEEE` | Danger icon box bg |
| `--MpColors-bg-dangerBold` | `MpColors.bg.dangerBold` | `#C33E35` | Notification badge bg |

### 5.2 Text — `MpColors.text.*`

| CSS variable | Dart path | Hex | Use case |
|---|---|---|---|
| `--MpColors-text-primary` | `MpColors.text.primary` | `#272B32` | Main body text, headings, avatar initials, form labels |
| `--MpColors-text-secondary` | `MpColors.text.secondary` | `#656F80` | Supporting/secondary text, inactive tab, timestamp, reject-button text |
| `--MpColors-text-secondaryPressed` | `MpColors.text.secondaryPressed` | `#4C5460` | Pressed secondary text |
| `--MpColors-text-placeholder` | `MpColors.text.placeholder` | `#758195` | Form placeholder, muted calendar cell, optional/hint text, empty state icon |
| `--MpColors-text-link` | `MpColors.text.link` | `#4B61DC` | Hyperlink text, "Mark all as read", clickable icons |
| `--MpColors-text-inverse` | `MpColors.text.inverse` | `#FFFFFF` | Text on dark backgrounds (badge, primary button label, budget card text) |
| `--MpColors-text-warning` | `MpColors.text.warning` | `#A14A0B` | Warning text & icon |
| `--MpColors-text-danger` | `MpColors.text.danger` | `#C33E35` | Danger text, required-field asterisk |
| `--MpColors-text-highlight` | `MpColors.text.highlight` | `#5F519F` | AI tag text (violet800) |

### 5.3 Icon — `MpColors.icon.*`

| CSS variable | Dart path | Hex | Use case |
|---|---|---|---|
| `--MpColors-icon-success` | `MpColors.icon.success` | `#1C8459` | Success check icon, success amount text |
| `--MpColors-icon-highlight` | `MpColors.icon.highlight` | `#6F5FBA` | Violet trip / highlight icons |

### 5.4 Border — `MpColors.border.*`

| CSS variable | Dart path | Hex / value | Use case |
|---|---|---|---|
| `--MpColors-border-primary` | `MpColors.border.primary` | `#DCDFE4` | Default component border, sheet handle bg |
| `--MpColors-border-subtle` | `MpColors.border.subtle` | `#F0F1F3` | Dividers, list separators, soft borders |
| `--MpColors-border-bold` | `MpColors.border.bold` | `#758195` | Emphasized border |
| `--MpColors-border-form` | `MpColors.border.form` | `rgba(29,31,36,0.16)` | Form input borders, secondary button borders, dashed-upload borders |
| `--MpColors-border-disabled` | `MpColors.border.disabled` | `rgba(29,31,36,0.08)` | Disabled element borders |
| `--MpColors-border-selected` | `MpColors.border.selected` | `#4B61DC` | Selected / active borders (e.g. unread notification left border) |
| `--MpColors-border-success` | `MpColors.border.success` | `#1C8459` | Success toast border |
| `--MpColors-border-warning` | `MpColors.border.warning` | `#F5CD47` | Warning banner border |
| `--MpColors-border-danger` | `MpColors.border.danger` | `#C33E35` | Error toast border |

### 5.5 Chart — `MpColors.chart.*`

Used for data visualization in budget progress bars (each category's progress fill).

| CSS variable | Dart path | Hex | Use case |
|---|---|---|---|
| `--MpColors-chart-cat02Bold` | `MpColors.chart.cat02Bold` | `#119E8F` | Teal — healthy budget fill (25% range) |
| `--MpColors-chart-cat04Bold` | `MpColors.chart.cat04Bold` | `#E46910` | Orange — moderate budget fill (63% range) |
| `--MpColors-chart-cat05Bold` | `MpColors.chart.cat05Bold` | `#8690A2` | Neutral — empty/0% budget fill |
| `--MpColors-chart-cat06Bold` | `MpColors.chart.cat06Bold` | `#E2483D` | Red — over-budget fill (88%+ range) |
| `--MpColors-chart-cat07` | `MpColors.chart.cat07` | `#83CA16` | Lime — online presence dot |

### 5.6 Custom XPM tokens — `XpmColors.*`

These are XPM-specific colors that do NOT exist in Pixel Flutter. Define them in the Flutter app theme as project-local constants.

| CSS variable | Suggested Dart constant | Hex | Use case |
|---|---|---|---|
| `--XpmColors-bg-base` | `XpmColors.bgBase` | `#F2F3F9` | Page background, separators, neutral surfaces (used wherever a light grayish-blue base is needed) |
| `--XpmColors-budget-cardBg` | `XpmColors.budgetCardBg` | `#1C3A6F` | Budget summary card dark navy background |
| `--XpmColors-budget-trackBg` | `XpmColors.budgetTrackBg` | `#4B618C` | Budget progress track background (on dark card) |

---

## 6. Excluded from Flutter (prototype chrome)

The following are HTML-only prototype scaffolding. **Do NOT port these to Flutter.** They are not part of the app UI.

| Element | What it is | CSS marker |
|---|---|---|
| iPhone frame shell | Dark rounded shell containing the app | `.iphone-frame`, `border-radius:52px/42px`, colors `#1E2230`, `#2a2a2c`, `#4a4a4e`, `#0F1115`, `#3a3a3c`, `#1c1c1e` |
| Dynamic island | Top island cutout | `.dynamic-island`, `border-radius:20px` |
| iOS status bar | Time / signal / battery faux UI | `.status-bar`, `padding:13px 26px 9px 16px`, `line-height:22px` |
| Home indicator | Bottom bar | `.home-indicator` |
| Body wrapper | Pale lavender bg behind the iPhone frame | `body { background:#D8DEF0; padding:32px 20px 60px; }` |
| Prototype labels | Above-frame labels (e.g. "PROTOTYPE", hint text) | `.proto-label` (`#7B8BAA`), `.proto-hint` (`#9CA3AF`) |
| Camera/scan overlay UI | The receipt-scan camera fake UI: flash button, credits chip, banner title, preview badges | `.scan-overlay *`, colors `#FBBF24`, `#FFE082`, `#FDE68A`, `#0F1115` |
| Receipt texture | Faux receipt paper inside scan preview | `#F5F1E6`, `#E8E2D2`, `#8a7a4b` |
| Skeleton shimmer | `.tx-skel-line` shimmer animation gradient | `#E8EBF4` (only inside the gradient) |
| Empty-state large icon | `.tx-empty i { font-size:32px }` | `font-size:32px` |
| Receipt thumb micro-number | Tiny "1/3" label on receipt thumbs | `font-size:9px` |

**Rule for AI coding agent:** When porting to Flutter, render the app screens **directly inside the device viewport** (no iPhone frame). Status bar, home indicator, and dynamic island are provided by the OS / Flutter's `SafeArea`.

---

## 7. Token usage rules

These are hard rules. Violating them produces visually-correct but semantically-wrong code that will break in dark mode or theme changes.

1. **Text tokens are for text only.** Never use `MpColors.text.*` as a background or border color, even if the hex happens to match.
2. **Border tokens are for borders only.** Never use `MpColors.border.*` as a background, unless explicitly listed in the table above (the sheet-handle bg is a documented exception).
3. **Background tokens are for backgrounds only.** Don't use them as text color.
4. **Icon tokens are for icons.** Reusing them for adjacent text is allowed only when the color is identical and semantic intent matches (e.g. success icon + success amount label both green).
5. **Use `XpmColors-*` only when a Pixel token does NOT exist for the use case.** If you find yourself needing a new XPM color, first verify no Pixel token covers it.
6. **Form borders** specifically use `--MpColors-border-form` (a translucent overlay), NOT `--MpColors-border-primary`. This applies to input fields, secondary button outlines, and dashed upload borders.
7. **Disabled states** use the dedicated disabled tokens (`bg-disabled`, `border-disabled`), not opacity hacks.
8. **Page background** is `--XpmColors-bg-base`, not `--MpColors-bg-surface`. The surface token is reserved for Pixel's surface contract.

---

## 8. Screens & overlays inventory

The prototype is a single-file SPA. Screens are switched by toggling `.screen.active`, overlays slide over the current screen, and sheets slide up from bottom.

### 8.1 Screens (bottom-nav level)

| ID | Title | Notes |
|---|---|---|
| `screen-home` | Home | Greeting header, "This month" widget, "Needs your attention", "Budget categories" (2×2 grid of dark navy cards), "Recent transactions" |
| `screen-requests` | My requests | Search + filter bar, "This month" stats + AI credits, active-filters strip, request list, infinite-scroll anchor |

### 8.2 Overlays (full-screen, slide in)

| ID | Purpose |
|---|---|
| `overlay-inbox` | Notifications inbox with approve/reject swipe-actions |
| `overlay-request-detail` | Single request detail view |
| `overlay-trip` | Trip detail view (multi-expense report grouping) |
| `overlay-create-report` | Create / submit report form |
| `overlay-reimb` (`scan-overlay`) | Receipt scan camera UI ⚠️ contains prototype chrome — see §6 |
| `overlay-reimb-form` | Receipt expense form (manual entry / OCR-assisted) |
| `overlay-classify` (`trip-overlay`) | AI category classification confirmation |
| `overlay-receipt-preview` (`trip-overlay`) | Receipt image preview |
| `overlay-trip-form` (`reimb-form-overlay`) | Trip-expense entry form (one of N) |

### 8.3 Bottom sheets

| ID | Purpose |
|---|---|
| `sheet-fab` | FAB menu (New expense / New trip / etc.) |
| `sheet-filter` | Filter requests by period, status, amount |
| `sheet-trip-select` | Select trip for expense |
| `sheet-trip-success` | Success state after trip submission |
| `sheet-split` | Split expense between categories |
| `sheet-trip-cat` | Pick category for trip expense |
| `sheet-category` | Pick category for general expense |

All sheets use `border-radius: var(--MpRadius-xLarge) var(--MpRadius-xLarge) 0 0` (top corners only, 12px).

---

## 9. Component patterns

These patterns repeat across screens. Implement them as reusable Flutter widgets.

### 9.1 Toast (`.app-toast`)

- White background (`bg-stage`), 1.5px colored border (`border-success` / `border-danger`), shadow `0 4px 3px rgba(0,0,0,0.05), 0 10px 7.5px rgba(0,0,0,0.10)`.
- Padding: `xSmall` vertical × `small` horizontal.
- Text: regular weight, `text-primary`.

### 9.2 Notification badge (`.badge`)

- `bg-dangerBold` background, `text-inverse` text, font-size `xxs`, semiBold weight.
- `border-radius: full`, padding `xSmall4` vertical × `xSmall` horizontal.
- Shadow `0 4px 6px -2px rgba(0,0,0,0.05), 0 10px 15px -3px rgba(0,0,0,0.10)`.

### 9.3 Status pill (`.trip-card-status`)

- Padding: `xSmall4` × `xSmall`, `border-radius: full`, semiBold weight.
- Variants: `.warn` (text-warning on bg-warning), `.danger` (text-danger on bg-danger).

### 9.4 Tab bar (`.tab-btn`)

- Padding `small` vertical, no horizontal padding.
- Inactive: `text-secondary`. Active: `text-link` color + `text-link` bottom border.

### 9.5 Budget card (dark navy)

- Background: `XpmColors.budgetCardBg` (dark navy).
- All text uses `text-inverse` (white).
- Progress track: `XpmColors.budgetTrackBg`, progress fill: a `MpColors.chart.cat*Bold` token chosen by spent ratio:
  - 0% / no limit → `cat05Bold` (neutral)
  - Healthy (≤25%) → `cat02Bold` (teal)
  - Moderate (~25–75%) → `cat04Bold` (orange)
  - Over-budget (>75%) → `cat06Bold` (red)

### 9.6 AI tag (`.ai-tag`)

- Text color: `text-highlight` (violet800), background: `bg-brand` (light blue).
- Font size `xxs`, semiBold, letter-spacing `0.3px`, radius `small`, padding `xSmall4` × `xSmall2`.

### 9.7 Primary action button

- Background: `bg-brandBold`, text: `text-inverse`, semiBold.
- Border radius `xLarge` (12px), padding `small` vertical.

### 9.8 Secondary action button

- Background: `bg-stage`, text: `text-secondary`, semiBold.
- Border: 1.5px solid `border-form`.
- Border radius `xLarge`.

### 9.9 Form input

- Border: 1.5px solid `border-form`.
- Padding: `xSmall` vertical × `small` horizontal.
- Placeholder color: `text-placeholder`.
- Disabled bg: `bg-disabled`.

---

## 10. Layout constants

- **App max width:** Flutter implementation should size to the actual device viewport. The HTML prototype's 390px width is a Pixel-mobile design canvas — match the design's logical pixel dimensions (390 width baseline).
- **Bottom nav height:** check `.bottom-nav` in `index.html` — usually 64px including safe area.
- **Header height:** check `.app-header` — varies per screen.

---

## 11. Changelog

Add a row each time tokens change or this doc is updated. Newest first.

| Date | Change | By |
|---|---|---|
| 2026-05-23 | Initial doc. Captures complete token system after full tokenization pass: all colors, typography, spacing, and radius in app UI use design tokens. Prototype chrome (iPhone frame, scan overlay, receipt texture) intentionally hardcoded. | Claude + ds@mekari.com |

---

## 12. Open questions / TODO

Things not yet resolved — update as decisions are made.

- [ ] **`font-size:32px`** for empty-state icon — no Pixel token covers this. For Flutter, decide: use `xl` (24px) or define a new icon-size scale.
- [ ] **`font-weight:500/700`** were collapsed to `semiBold (600)` in the prototype. Verify Figma design intent matches this — if Figma shows medium (500) anywhere, that's a divergence to track.
- [ ] **`#1E40AF`** dark blue (was mapped to `text-primary` for avatar initials + info banner text) — confirm Figma intent; consider adding an info-text token if needed.
- [ ] Dark mode — every color token in this doc has a documented dark-mode value in Pixel. The HTML prototype is light-mode only. Flutter implementation should resolve via `MpColors.*.resolve(context)` which handles theme automatically.
- [ ] Skeleton shimmer animation — currently hardcoded `#E8EBF4` gradient endpoints. In Flutter, prefer a shimmer package or a theme-aware shimmer color.
