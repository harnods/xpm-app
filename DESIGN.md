# XPM Mobile — Design Implementation Spec

> **Purpose:** This document is the source-of-truth contract between the HTML prototype (`index.html`) and the future Flutter implementation. AI coding agents converting this prototype to Flutter MUST follow the token mappings and rules in this doc exactly. Do not infer or guess tokens — every CSS variable used in `index.html` has an explicit Flutter Dart equivalent listed below.
>
> **Target framework:** Flutter (Mekari Pixel 2.4 design system)
> **Source of truth:** Multi-page HTML prototype — each screen is its own `.html` file (see §8 for inventory). Shared design tokens in `styles.css`, shared JS utilities in `app.js`.
> **Last updated:** keep this updated as prototype files evolve — see [Changelog](#changelog) at bottom

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

The prototype is a **multi-page HTML app (MPA)**. Each screen is a separate `.html` file; navigation uses plain `<a href>` links. Shared styles in `styles.css`, shared utilities in `app.js`. `index.html` redirects to `home.html`.

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

## 10. Pixel Flutter component map

This section maps every visible UI element in the prototype to its exact Pixel 2.4 Flutter widget class. **Use these exact class names** — do not use Flutter's built-in Material widgets if a Pixel equivalent exists.

### 10.1 Screen scaffold

| Prototype element | Pixel widget | Notes |
|---|---|---|
| Every screen (Home, My Requests, Inbox, etc.) | `MpBasicLayout` | Wraps `appBar` + `stage` + `bottomNavigationBar`. Set `extendStageBottom: true` so content flows behind bottom nav |
| Bottom navigation bar | `MpBottomNavBar` | 4 tabs: Home, My requests, Purchases, My cards |
| Each bottom nav item | `MpBottomNavBarItemData(label:, icon:)` | `icon` is a Tabler icon path from `MpIcons.*` |
| Notification badge on nav item | `MpBadge.negativeMenu(text: '3')` | Pass via `MpBottomNavBarItemData(badge:)` |

### 10.2 App bar variants

| Screen | Pixel widget | Key props |
|---|---|---|
| Home (greeting + avatar + inbox icon) | `MpBaseAppBar` with custom `title` widget | `backgroundColor: transparent`, `elevation: 0`. Title widget = `Column(Good morning / name)`. Actions = inbox `MpIconButton` |
| Non-home screens (title only — My Requests, Purchases, My Cards) | `MpTextAppBar` | `title: 'My requests'`, `backgroundColor: transparent` |
| Overlay screens with back arrow (Inbox, Trip detail, etc.) | `MpTextAppBar` | `leading: MpIconButton(back)`, title text |
| Overlay screens with no title (form flows) | `MpBaseAppBar` or `MpEmptyAppBar` | Transparent bg, just back arrow |

### 10.3 FAB (floating action button)

| Element | Pixel widget | Notes |
|---|---|---|
| "+ Request" pill button | `MpFloatingActionButton(label: 'Request', icon: …)` | Use inside `MpFloatingActionButtonStack` when `Scaffold.floatingActionButton` can't be used (e.g. screens with custom scroll). Icon = `MpIcons.interfaceEssential.add` |
| FAB menu sheet (New expense / New trip / etc.) | `MpBottomSheet.show()` + `MpBottomSheetContent` | Body = list of `MpListTileX` items. Sheet is triggered on FAB tap; no Pixel FAB menu component — implement as a standard `MpBottomSheet` |

### 10.4 Bottom sheets

| Prototype sheet | Pixel widget | Notes |
|---|---|---|
| All bottom sheets (FAB menu, filter, category, date, split, success) | `MpBottomSheet.show(context, builder: (_) => MpBottomSheetContent(…))` | `MpBottomSheetContent` accepts `header`, `body`, `footer` |
| Sheet header (with title + optional close button) | `MpBottomSheetHeader(title: Text('…'), implyCloseable: true)` | Pass to `MpBottomSheetContent(header:)` |
| Sheet drag handle | `MpBottomSheetHandler` | Auto-included in `MpBottomSheetContent` by default (`showHandlerIndicator: true`) |
| Sheet footer with CTA buttons | `MpActionGroup(actions: [MpButton.primary(…), MpButton.secondary(…)])` | Pass to `MpBottomSheetContent(footer:)` |

### 10.5 List tiles

| Prototype element | Pixel widget | Variant / notes |
|---|---|---|
| Transaction list item (vendor + category + status + amount) | `MpListTileX` | `leading` = `MpIconAvatar`, `content` = double-line text, `trailing` = amount + status badge |
| FAB menu item (New expense / New trip row) | `MpListTileX` | `leading` = icon, `content` = label text |
| Inbox notification item | `MpListTileX` | `leading` = `MpIconAvatar` (colored), `content` = title + subtitle + timestamp, `trailing` = unread dot |
| Section header in request list (date "13 JUL") | `MpHeaderListTileX` | `content` = date label, no leading/trailing |
| Category pick row (in category sheet) | `MpListTileX` | `trailing` = chevron or radio |

### 10.6 Buttons

| Prototype element | Pixel widget | Notes |
|---|---|---|
| Primary CTA (Submit, Approve, Create report) | `MpButton.primary(label: '…', onPressed: …)` | Full-width in forms |
| Secondary CTA (Cancel, Reject, Back) | `MpButton.secondary(label: '…', onPressed: …)` | Border uses `MpColors.border.form` automatically |
| Ghost / text-only action (e.g. "Mark all as read") | `MpButton.ghost(label: '…')` or `MpActionText` | Check context — use `MpActionText` for inline link-style buttons |

### 10.7 Badges & status pills

| Prototype element | Pixel widget | Variant |
|---|---|---|
| Notification count dot on inbox icon | `MpBadge.negative(text: '3', size: MpBadgeSize.small)` | Red negative badge |
| "Pending" / "Awaiting approval" status text | `MpBadge.noticeStatus(text: 'Awaiting approval')` | Notice = amber/yellow |
| "Rejected" status text | `MpBadge.negativeStatus(text: 'Rejected')` | Negative = red |
| "Disbursed" / "Completed" status text | `MpBadge.positiveStatus(text: 'Disbursed')` | Positive = green |
| "Awaiting report" (trip) | `MpBadge.neutralStatus(text: 'Awaiting report')` | Neutral = gray |

### 10.8 Search & filter

| Prototype element | Pixel widget | Notes |
|---|---|---|
| Search bar in My Requests | `MpSearch(hintText: 'Search vendor, type, or amount', onFilterPressed: …)` | Has built-in filter icon button; `onFilterPressed` opens the filter sheet |
| All / Claims / Trips tab strip | `MpSingleFilter(tags: […], selectedIndex: 0, onTapTag: …)` | Single-select pill tabs |
| Active filter chips (below search, e.g. "May 2026") | `MpFilter(tags: […], onTapFilter: …, onTapTag: …)` | Shows active filter chips + filter button with count badge |

### 10.9 Avatar

| Prototype element | Pixel widget | Notes |
|---|---|---|
| User photo avatar (top-right home header) | `MpAvatar.image(path: photoUrl)` | With online indicator: use `MpAvatarVariationIcon` |
| Initials avatar fallback | `MpAvatar.text(text: 'Rizal Chandra')` | Pixel auto-generates initials and bg color |
| Icon avatar (colored circle with icon — inbox, transaction) | `MpIconAvatar` | `icon`, `backgroundColor` props |

### 10.10 Toast

| Prototype element | Pixel widget | Notes |
|---|---|---|
| Success toast (claim submitted, approved) | `MpToast.done('Claim submitted').show(context)` | Green border, check icon |
| Error toast (action failed) | `MpToast.error('Something went wrong').show(context)` | Red border |
| Info toast | `MpToast.info('…').show(context)` | Blue border |

### 10.11 Date picker

| Prototype element | Pixel widget | Notes |
|---|---|---|
| Date field in reimbursement / trip form | `MpFullDatePickerSheet` | Show via `MpBottomSheet.show()`. Returns selected `DateTime` |

### 10.12 AI credits chip (custom — no Pixel equivalent)

The "Auto-fill credits · 12 remaining" row with the sparkle icon and blue progress bar is **custom** — no direct Pixel component. Build as a `Container` with `MpColors.bg.brand` bg + `MpColors.text.link` text + custom progress indicator using `MpColors.bg.brandBold`.

### 10.13 Form inputs

All form fields use `MpTextField`. **Never use Flutter's raw `TextField` or `TextFormField`.**

| Field type | Widget | Key constructor props |
|---|---|---|
| Plain text (vendor, name) | `MpTextField` | `label`, `hint`, `required: true`, `validator` |
| Currency / amount | `MpTextField` | `prefix: Text('Rp')`, `textInputType: TextInputType.numberWithOptions(decimal: true)`, `inputFormatters: [CurrencyTextInputFormatter]` |
| Date (read-only, opens picker) | `MpTextField` | `readOnly: true`, `suffixIcon: MpIcons.dateTime.calendar`, `onPressed: () => MpBottomSheet.show(MpFullDatePickerSheet(...))` |
| Category / trip picker | `MpTextField` | `readOnly: true`, `suffixIcon: MpIcons.interfaceEssential.chevronRight`, `onPressed: openSheet` |
| Multiline notes | `MpTextField` | `minLines: 3`, `maxLines: 5` |
| Disabled field | `MpTextField` | `disable: true` |

### 10.14 Banners

| Prototype element | Pixel widget | Notes |
|---|---|---|
| OCR info banner (after scan) | `MpBanner.info(message: 'Receipt scanned. Review and confirm.')` | Top of reimb-form |
| AI classify suggestion | `MpBanner.info(title: 'AI suggestion', message: '...', actions: [MpBannerAction(text: 'Review', onTap: openClassify)])` | With action link |
| Warning / over-budget banner | `MpBanner.warning(message: '...')` | `bg-warning` bg, `text-warning` text automatically |

### 10.15 Progress indicators (budget bars)

Budget category progress bars are **not** a Pixel component — use Flutter's built-in `LinearProgressIndicator`:

```dart
LinearProgressIndicator(
  value: spentRatio,                                    // 0.0–1.0
  backgroundColor: XpmColors.budgetTrackBg,
  color: MpColors.chart.cat02Bold.resolve(context),     // pick by ratio — see §9.5
  borderRadius: BorderRadius.circular(999),
  minHeight: 6,
)
```

---

## 11. Per-screen component breakdown

This section maps **every visible UI element per screen** to its exact Pixel 2.4 Flutter widget. Use this when building a screen — every row is one element with its Pixel class and key props.

**Legend:**
- `Custom` = no Pixel equivalent; build with standard Flutter primitives
- `↑ §10.x` = additional detail in the referenced §10 sub-section

---

### 11.1 `home.html` — Home

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | `.prototype-wrap` | `MpBasicLayout` | `extendStageBottom: true`, `extendStageTop: true` |
| App bar | `.app-header` | `MpBaseAppBar` | `backgroundColor: transparent`, `title: Column([greeting, name])`, `actions: [Stack(MpIconButton + MpBadge)]` |
| Greeting text | `.greeting` | `Text` | `style: MpTextStyles.sm`, `color: MpColors.text.secondary` |
| User name | `.user-name` | `Text` | `style: MpTextStyles.l.semiBold`, `color: MpColors.text.primary` |
| Inbox icon button | header `<a>` | `MpIconButton(icon: MpIcons.alert.bell)` | Inside `Stack` with `MpBadge` |
| Inbox unread badge | `.badge` on icon | `MpBadge.negative(text: '3', size: MpBadgeSize.small)` | `Positioned` inside `Stack` over inbox icon |
| User avatar | `.avatar` | `MpAvatar.image(path: photoUrl)` | Wrap in `Stack` + `Positioned(MpAvatarVariationIcon.available)` for online dot |
| "This month" summary card | `.card` | `Custom Container` | `color: MpColors.bg.stage`, `borderRadius: MpRadius.xLarge`, `padding: MpSpacing.medium` |
| Stat cell (Pending / Awaiting / Disbursed) | `.stat-cell` | `Custom Column` in `Row` | Dividers: `VerticalDivider(color: MpColors.border.subtle)` |
| Disbursed amount text | disbursed `.stat-amount` | `Text` | `color: MpColors.icon.success`, `style: MpTextStyles.md.semiBold` |
| Awaiting payment amount | awaiting `.stat-amount` | `Text` | `color: MpColors.text.warning` |
| "Needs your attention" card | `.attn-card` | `Custom Container` | Same card style as "This month" |
| Attention tile (Claims / Trips / Purchases) | `.attn-tile` | `InkWell` + `Column(MpIconAvatar, count Text, label Text)` | `onTap: navigate to my-requests.html` |
| "Categories limit" section header | `.budget-header` | `MpHeaderListTileX.double(label: 'Categories limit', caption: 'View all')` | `trailing: Icon(chevron_right, color: MpColors.text.link)` |
| Budget card wrapper | `.budget-widget` | `Custom Container` | `color: MpColors.bg.stage`, `borderRadius: MpRadius.medium` |
| Individual budget card | `.budget-card` | `Custom Container` | `color: XpmColors.budgetCardBg`, `borderRadius: MpRadius.xLarge`, `padding: MpSpacing.small` |
| Budget card title | `.budget-card-title` | `Text` | `style: MpTextStyles.xs.semiBold`, `color: MpColors.text.inverse` |
| Budget amount | `.budget-card-amount` | `Text` | `style: MpTextStyles.md.semiBold`, `color: MpColors.text.inverse` |
| Budget "No limit set" | `.budget-card-amount.muted` | `Text` | `color: MpColors.text.secondary` (NOT italic) |
| Budget progress track | `.budget-progress-track` | `LinearProgressIndicator` (Flutter built-in) | `backgroundColor: XpmColors.budgetTrackBg`, `minHeight: 6`, `borderRadius: BorderRadius.circular(999)` |
| Budget progress fill | `.budget-progress-fill` | — (part of `LinearProgressIndicator`) | `color: MpColors.chart.cat*Bold` — pick by spent ratio ↑ §9.5 |
| "Recent transactions" header | `.tx-header` | `MpHeaderListTileX.double(label: 'Recent transactions', caption: 'View all')` | — |
| Transaction date header | `.tx-date-label` | `MpHeaderListTileX.single(label: 'May 2026')` | `backgroundColor: MpColors.bg.subtle` |
| Type filter strip (All / Disbursed / Awaiting approval) | `.tab-btn` row | `MpSingleFilter(tags: [MpSingleFilterTagData(label: 'All'), ...], selectedIndex: 0, onTapTag: filterList)` | — |
| Transaction list item | `.tx-item` | `MpListTileX(leading: MpIconAvatar, content: MpListTileXContent.double(label: vendor, caption: category), trailing: Column(amount, MpBadge.*Status), onTap: navigate)` | — |
| Transaction status badge | `.tx-status` | `MpBadge.*Status` ↑ §10.7 | positiveStatus / noticeStatus / negativeStatus / neutralStatus |
| FAB "+ Request" | `.fab-pill` | `MpFloatingActionButton(label: 'Request', icon: MpIcons.interfaceEssential.add.toIcon(), onPressed: openFabSheet)` | Use `MpFloatingActionButtonStack` for scroll-aware collapse |
| Bottom nav | `.bottom-nav` | `MpBottomNavBar(items: [...], currentIndex: 0, onTap: navigate)` | 4 items: Home (`currentIndex: 0`), My requests, Purchases, My cards |

---

### 11.2 `my-requests.html` — My Requests

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | — | `MpBasicLayout` | `extendStageBottom: true` |
| App bar | `.app-header` | `MpTextAppBar(title: 'My requests', backgroundColor: transparent)` | — |
| Search bar | `.search-row input` | `MpSearch(hintText: 'Search vendor, type, or amount', onFilterPressed: openFilterSheet)` | Built-in filter icon on right triggers filter sheet |
| "This month" summary card | `.card` | Same `Custom Container` as Home | — |
| AI credits row | `.credits-row` | `Custom Container` | `backgroundColor: MpColors.bg.brand`, sparkle icon, `text: MpColors.text.link`, credits `LinearProgressIndicator` — **no Pixel equivalent** ↑ §10.12 |
| Type tab strip (All / Claims / Trips) | `.tab-btn` row | `MpSingleFilter(tags: [...], selectedIndex: 0, onTapTag: filterList)` | — |
| Active filter chips | `.active-filters` | `MpFilter(tags: [MpFilterTagData(label: 'May 2026')], onTapFilter: openFilterSheet, onTapTag: removeFilter)` | Shows removable chip per active filter |
| Date section header | `.tx-date-label` | `MpHeaderListTileX.single(label: '13 JUL')` | — |
| Claim list item | `.tx-item` (claim) | `MpListTileX(leading: MpIconAvatar, content: MpListTileXContent.triple(label: vendor, caption: category, description: 'Reimbursement · Status'), trailing: amount Text, onTap: navigate)` | — |
| Trip list item | `.tx-item` (trip) | `MpListTileX.overline(label: tripName, caption: dateRange, leading: MpIconAvatar, trailing: Column(amount, expense-count Text), onTap: navigate)` | — |
| Status badge | `.tx-status` | `MpBadge.positiveStatus` / `.noticeStatus` / `.negativeStatus` / `.neutralStatus` | Map: Disbursed→positive, Awaiting approval→notice, Rejected→negative, Awaiting report→neutral |
| FAB | `.fab-pill` | `MpFloatingActionButton(label: 'Request', ...)` | Same as Home |
| Bottom nav | `.bottom-nav` | `MpBottomNavBar` | `currentIndex: 1` (My requests active) |

---

### 11.3 `inbox.html` — Inbox / Notifications

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | — | `MpBasicLayout` | No `bottomNavigationBar` |
| App bar | `.app-header` | `MpTextAppBar(title: 'Inbox', leading: back MpIconButton, actions: [MpButton.ghost(label: 'Mark all as read')])` | — |
| Tab strip | `.tab-btn` row | `MpSingleFilter(tags: [MpSingleFilterTagData(label: 'Notifications'), MpSingleFilterTagData(label: 'Need my approval')], ...)` | — |
| Tab unread badge | `.badge` on tab | `MpBadge.negative(text: '3', size: MpBadgeSize.small)` | Pass as `MpSingleFilterTagData(icon: MpBadge(...))` |
| **Unread** notification item | `.notif-item.unread` | Wrap `MpListTileX` in `Container(decoration: BoxDecoration(border: Border(left: BorderSide(color: MpColors.border.selected, width: 2))))` | `MpListTileX(backgroundColor: MpColors.bg.subtle, leading: MpIconAvatar, content: double-line, trailing: unread dot)` |
| Unread dot indicator | `.action-dot` | `Custom Container(8×8, decoration: circle, color: MpColors.bg.brandBold)` | Trailing widget of `MpListTileX` |
| **Read** notification item | `.notif-item` | `MpListTileX(backgroundColor: MpColors.bg.stage, leading: MpIconAvatar, content: double-line)` | No left border, no trailing dot |
| Notification icon avatar | `.notif-icon` | `MpIconAvatar(icon: MpIcons.*, backgroundColor: MpColors.bg.*)` | success=bg-success, danger=bg-danger, warning=bg-warning, info=bg-brand |
| Swipe-to-dismiss | `.notif-swipe-wrap` | Flutter `Dismissible(direction: DismissDirection.endToStart, background: Container(color: MpColors.bg.successBold, child: Row([Icon(check, white), Text('Mark as read', white)])))` | **No Pixel swipe component** — use Flutter built-in |

---

### 11.4 `reimb.html` — Receipt Scan (Camera)

> ⚠️ This screen is mostly **prototype chrome** (§6). The camera viewfinder is OS-provided in Flutter (`CameraPreview`).

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | `.scan-overlay` | `Scaffold` (not `MpBasicLayout`) | `backgroundColor: Color(0xFF0F1115)` (full dark) |
| Close button (top-left) | `.close-btn` | `MpIconButton(icon: MpIcons.interfaceEssential.x, iconColor: MpColors.text.inverse)` | — |
| AI credits chip (top-right) | `.credits-chip` | `Custom Container` pill | `bg-inverse`, `text-inverse`, `borderRadius: MpRadius.full` — **no Pixel equivalent** |
| Camera viewfinder | — | `CameraPreview` (camera package) | Full-screen; OS-provided |
| Scan frame corners | `.scan-frame` | `Custom CustomPaint` | Draw 4 white corner brackets only |
| "Fill manually instead" button | `.manual-btn` | `MpButton.ghost(label: 'Fill manually instead')` | Override text color to `MpColors.text.inverse` |
| Shutter (capture) button | `.shutter-btn` | `Custom GestureDetector` + `Container` | 64×64 white circle, `border-radius: full`, `onTap: capture` |
| Gallery browse button | `.browse-btn` | `MpIconButton(icon: MpIcons.file.image)` + `Text('Browse')` | Column layout: icon above label |
| Flash toggle | `.flash-btn` | `MpIconButton(icon: MpIcons.weather.lightning)` | Toggle between on/off state |

---

### 11.5 `reimb-form.html` — Reimbursement Form

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | — | `MpBasicLayout` | No bottom nav |
| App bar | `.app-header` | `MpTextAppBar(title: 'New expense', leading: back MpIconButton, actions: [MpIconButton(close)])` | — |
| OCR info banner | `.ocr-banner` | `MpBanner.info(message: 'Receipt scanned. Review and confirm the details.')` | Shown when arriving from camera scan |
| Vendor name field | `.field-vendor` | `MpTextField(label: 'Vendor', hint: 'e.g. Grab, Starbucks', required: true)` | — |
| Amount field | `.field-amount` | `MpTextField(label: 'Amount', hint: 'Rp 0', prefix: Text('Rp'), textInputType: TextInputType.numberWithOptions(decimal: true), inputFormatters: [CurrencyTextInputFormatter])` | — |
| Date field | `.field-date` | `MpTextField(label: 'Date', readOnly: true, suffixIcon: MpIcons.dateTime.calendar, onPressed: showDatePicker)` | Triggers `MpFullDatePickerSheet` via `MpBottomSheet.show()` |
| Category field | `.field-category` | `MpTextField(label: 'Category', readOnly: true, suffixIcon: MpIcons.interfaceEssential.chevronRight, onPressed: openCategorySheet)` | Opens category `MpBottomSheet` |
| Notes field | `.field-notes` | `MpTextField(label: 'Notes', hint: 'Optional description', minLines: 3, maxLines: 5)` | — |
| Receipt upload area | `.receipt-upload` | `Custom GestureDetector` + dashed-border `Container` | `border: DashedBorder(color: MpColors.border.form)`, `backgroundColor: MpColors.bg.subtle` — **no Pixel dropzone** |
| Uploaded receipt thumbnail | `.receipt-thumb` | `Custom Stack(ClipRRect(Image.file) + Positioned(delete MpIconButton))` | — |
| AI classify banner | `.classify-banner.ai` | `MpBanner.info(title: 'AI suggestion', actions: [MpBannerAction(text: 'Review', onTap: openClassify)])` | Shown after OCR detects category |
| AI tag chip | `.ai-tag` | `Custom Container` chip ↑ §9.6 | `bg-brand`, `text-highlight`, `borderRadius: MpRadius.small` |
| Submit button | `.filter-btn.primary` | `MpButton.primary(label: 'Submit')` | Full-width |
| Cancel / close | — | `MpButton.ghost(label: 'Cancel')` | — |

---

### 11.6 `classify.html` — AI Category Classification

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | — | `MpBasicLayout` | No bottom nav |
| App bar | `.app-header` | `MpTextAppBar(title: 'Classify expense', leading: back MpIconButton)` | — |
| AI suggestion banner | `.classify-banner.ai` | `MpBanner.info(title: 'AI suggestion', message: 'We detected this as Transport. Is that correct?')` | — |
| Receipt thumbnail | `.classify-thumb` | `ClipRRect(borderRadius: MpRadius.medium, child: Image.file(...))` | — |
| Thumbnail page count | `.classify-thumb-badge` | `Custom Container` chip with `Text('1/3')` | Small label overlay on image |
| "Edit" button on thumb | `.classify-thumb-btn` | `MpButton.ghost(label: 'Edit')` or `MpIconButton` | Small, positioned over thumbnail |
| Category item — **selected** | `.classify-list .selected` | `MpListTileX(backgroundColor: MpColors.bg.brand, leading: MpIconAvatar, content: category label, trailing: Radio(value: true), onTap: ...)` | — |
| Category item — **unselected** | `.classify-list .item` | `MpListTileX(leading: MpIconAvatar, content: category label, trailing: Radio(value: false), onTap: ...)` | — |
| Category icon avatar | `.classify-label i` | `MpIconAvatar(icon: MpIcons.*, backgroundColor: MpColors.bg.*)` | Color per category type |
| Confirm button | `.confirm-btn` | `MpButton.primary(label: 'Confirm')` | Full-width |
| Edit / back button | `.classify-edit` | `MpButton.ghost(label: 'Edit manually')` | — |

---

### 11.7 `receipt-preview.html` — Receipt Image Preview

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | — | `Scaffold` (not `MpBasicLayout`) | Dark/transparent overlay; `backgroundColor: Colors.black87` |
| App bar | — | `MpBaseAppBar(backgroundColor: transparent, leading: MpIconButton(close, color: MpColors.text.inverse))` | — |
| Receipt image viewer | `.receipt-preview-img` | `InteractiveViewer(child: Image.network(...))` | Pinch-to-zoom; **no Pixel equivalent** |
| Page indicator ("1/3") | `.preview-indicator` | `Custom Row` of dots or `Text('1/3', style: inverse)` | — |
| Thumbnail strip | `.preview-thumbs` | `ListView.builder(scrollDirection: Axis.horizontal, itemBuilder: thumb)` | `GestureDetector` per thumb to switch page |

---

### 11.8 `trip-form.html` — Trip Expense Form

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | — | `MpBasicLayout` | No bottom nav |
| App bar | `.app-header` | `MpTextAppBar(title: 'New trip expense', leading: back MpIconButton)` | — |
| Trip selector field | `.field-trip` | `MpTextField(label: 'Trip', readOnly: true, suffixIcon: chevron, onPressed: openTripSelectSheet)` | Opens trip-select `MpBottomSheet` |
| Category field | `.field-category` | `MpTextField(label: 'Category', readOnly: true, suffixIcon: chevron, onPressed: openCategorySheet)` | — |
| Vendor field | `.field-vendor` | `MpTextField(label: 'Vendor', required: true)` | — |
| Amount field | `.field-amount` | `MpTextField(label: 'Amount', prefix: Text('Rp'), textInputType: TextInputType.numberWithOptions(decimal: true))` | — |
| Date field | `.field-date` | `MpTextField(label: 'Date', readOnly: true, suffixIcon: MpIcons.dateTime.calendar, onPressed: showDatePicker)` | → `MpFullDatePickerSheet` |
| Notes field | `.field-notes` | `MpTextField(label: 'Notes', minLines: 3, maxLines: 5)` | — |
| Receipt upload area | `.receipt-upload` | Same `Custom` dashed-border `Container` as §11.5 | — |
| Save expense button | `.submit-btn` | `MpButton.primary(label: 'Save expense')` | Full-width |
| Cancel button | `.cancel-btn` | `MpButton.ghost(label: 'Cancel')` | — |

---

### 11.9 `trip-detail.html` — Trip Detail

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | — | `MpBasicLayout` | No bottom nav |
| App bar | `.app-header` | `MpTextAppBar(title: tripName, leading: back MpIconButton)` | e.g. `'Business trip · Surabaya'` |
| Trip status pill | `.trip-card-status` | `MpBadge.noticeStatus` / `.neutralStatus` / `.positiveStatus` / `.negativeStatus` | Map: Awaiting report→neutral, Awaiting approval→notice, Approved→positive, Rejected→negative |
| Trip summary info row | `.trip-summary` | `MpListTileX(leading: MpIconAvatar(trip icon, bg-highlight), content: MpListTileXContent.double(label: dates, caption: budget summary))` | — |
| Expense item in trip | `.tx-item` | `MpListTileX` | Same structure as §11.2 claim item |
| "Add expense" button | `.add-expense-btn` | `MpButton.secondary(label: '+ Add expense')` | Navigates to `trip-form.html` |
| "Create report" CTA | `.create-report-btn` | `MpButton.primary(label: 'Create report')` | Full-width; navigates to `create-report.html` |

---

### 11.10 `create-report.html` — Create Expense Report

| Element | CSS class | Pixel widget | Key props / notes |
|---|---|---|---|
| Screen scaffold | — | `MpBasicLayout` | No bottom nav |
| App bar | `.app-header` | `MpTextAppBar(title: 'Create report', leading: back MpIconButton)` | — |
| Trip summary tile | `.trip-summary` | `MpListTileX(leading: MpIconAvatar, content: MpListTileXContent.double(label: tripName, caption: dateRange), trailing: total-amount Text)` | — |
| Expense count summary | `.expense-count` | `MpHeaderListTileX.double(label: 'Expenses', caption: 'N items')` or `Custom Text` | — |
| Report name field | `.field-name` | `MpTextField(label: 'Report name', required: true)` | — |
| Notes / purpose field | `.field-notes` | `MpTextField(label: 'Notes / purpose', minLines: 3, maxLines: 5)` | — |
| Submit report button | `.submit-btn` | `MpButton.primary(label: 'Submit report')` | Full-width |
| Cancel button | `.cancel-btn` | `MpButton.ghost(label: 'Cancel')` | — |

---

### 11.11 Bottom sheets (all screens)

| Sheet | Trigger | Pixel widget | Content structure |
|---|---|---|---|
| FAB menu | FAB tap | `MpBottomSheet.show() + MpBottomSheetContent` | `header: MpBottomSheetHeader(title: Text('New'))`, `body: Column([MpListTileX(icon, 'New expense'), MpListTileX(icon, 'New trip'), MpListTileX(icon, 'Scan receipt')])` |
| Filter | `MpSearch.onFilterPressed` | `MpBottomSheet.show() + MpBottomSheetContent` | `header: MpBottomSheetHeader('Filter')`, `body: Column([period MpSingleFilter, status MpSingleFilter, Row([MpTextField(min), MpTextField(max)])])`, `footer: MpActionGroup([MpButton.ghost('Reset'), MpButton.primary('Apply')])` |
| Category picker | Category field `onPressed` | `MpBottomSheet.show() + MpBottomSheetContent` | `header: MpSearch(hint: 'Search category')`, `body: ListView.builder(MpListTileX per category, trailing: Radio)` |
| Trip selector | Trip field `onPressed` | `MpBottomSheet.show() + MpBottomSheetContent` | `body: ListView.builder(MpListTileX per trip)` |
| Split expense | Split button | `MpBottomSheet.show() + MpBottomSheetContent` | `body: Column(split-allocation rows with MpTextField per category)`, `footer: MpActionGroup([MpButton.primary('Confirm split')])` |
| Success confirmation | After trip submit | `MpBottomSheet.show() + MpBottomSheetContent` | `body: Column(success icon, title Text, subtitle Text)`, `footer: MpActionGroup([MpButton.primary('Done')])` |
| Date picker | Date field `onPressed` | `MpBottomSheet.show(builder: (_) => MpFullDatePickerSheet(onDateSelected: onSelected))` | `MpFullDatePickerSheet` used directly as the sheet body |

---

## 12. Layout constants

- **App max width:** Flutter implementation should size to the actual device viewport. The HTML prototype's 390px width is a Pixel-mobile design canvas — match the design's logical pixel dimensions (390 width baseline).
- **Bottom nav height:** check `.bottom-nav` in `index.html` — usually 64px including safe area.
- **Header height:** check `.app-header` — varies per screen.

---

## 13. Changelog

Add a row each time tokens change or this doc is updated. Newest first.

| Date | Change | By |
|---|---|---|
| 2026-05-25 | Added §10.13–10.15 (form inputs via `MpTextField`, banners via `MpBanner`, budget progress via `LinearProgressIndicator`) and new §11 per-screen component breakdown — every UI element on all 10 HTML screens mapped to its exact Pixel 2.4 widget, constructor variant, and key props. Updated intro and §8 for MPA architecture. | Claude + ds@mekari.com |
| 2026-05-25 | Added §10 Pixel Flutter component map — explicit mapping of every UI element to its exact Pixel 2.4 widget class (`MpBasicLayout`, `MpBottomNavBar`, `MpFloatingActionButton`, `MpBottomSheet`, `MpListTileX`, `MpButton`, `MpBadge`, `MpSearch`, `MpSingleFilter`, `MpAvatar`, `MpToast`, `MpFullDatePickerSheet`). | Claude + ds@mekari.com |
| 2026-05-25 | Prototype refactored from SPA to multi-page (`multi-page` branch). `index.html` splits into `home.html`, `my-requests.html`, `inbox.html`, etc. Shared CSS in `styles.css`, shared JS in `app.js`. | Claude + ds@mekari.com |
| 2026-05-23 | Initial doc. Captures complete token system after full tokenization pass: all colors, typography, spacing, and radius in app UI use design tokens. Prototype chrome (iPhone frame, scan overlay, receipt texture) intentionally hardcoded. | Claude + ds@mekari.com |

---

## 14. Open questions / TODO

Things not yet resolved — update as decisions are made.

- [ ] **`font-size:32px`** for empty-state icon — no Pixel token covers this. For Flutter, decide: use `xl` (24px) or define a new icon-size scale.
- [ ] **`font-weight:500/700`** were collapsed to `semiBold (600)` in the prototype. Verify Figma design intent matches this — if Figma shows medium (500) anywhere, that's a divergence to track.
- [ ] **`#1E40AF`** dark blue (was mapped to `text-primary` for avatar initials + info banner text) — confirm Figma intent; consider adding an info-text token if needed.
- [ ] Dark mode — every color token in this doc has a documented dark-mode value in Pixel. The HTML prototype is light-mode only. Flutter implementation should resolve via `MpColors.*.resolve(context)` which handles theme automatically.
- [ ] Skeleton shimmer animation — currently hardcoded `#E8EBF4` gradient endpoints. In Flutter, prefer a shimmer package or a theme-aware shimmer color.
