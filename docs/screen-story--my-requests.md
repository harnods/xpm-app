# Screen Story: My Requests

> **Handover type:** Designer → Engineer  
> **Screen:** My Requests (Tab 2 of bottom nav)  
> **Platform:** Mobile — Flutter (Mekari Pixel 2.4)  
> **Status:** Ready for dev — v2 (bug fixes applied)  
> **Last updated:** 2026-05-25  

---

## 1. Overview

The **My Requests** screen is the primary hub for employees to track all their expense claims and business trips. It surfaces a monthly spend summary, credit availability, and a scrollable timeline-grouped list of requests. Users can filter by type and create new requests from this screen.

---

## 2. Screen Layout (top → bottom)

```
┌────────────────────────────────────┐
│  AppBar — "My requests"            │
├────────────────────────────────────┤
│  Search bar + Filter button        │
├────────────────────────────────────┤
│  ┌── Monthly Summary Card ───────┐ │  ← ONE card container
│  │  Label + Total amount         │ │
│  │  [Pending][Awaiting][Disbursed│ │
│  │  ─────── internal divider ────│ │
│  │  Auto-fill Credits Row        │ │
│  │  ▓▓▓░░░░░ progress bar        │ │
│  └───────────────────────────────┘ │
├────────────────────────────────────┤
│  Filter Tabs — All / Claims / Trips│
├────────────────────────────────────┤
│  Date section header — "13 JUL"   │
│  ─── List items (transactions) ─── │
│  Date section header — "12 JUL"   │
│  ─── List items (transactions) ─── │
├────────────────────────────────────┤
│  FAB — "+ Request"                 │
├────────────────────────────────────┤
│  Bottom Navigation Bar             │
└────────────────────────────────────┘
```

**Layout scaffold:** `MpBasicLayout` with `extendStageBottom: true` to allow content to flow behind the bottom nav.

---

## 3. Component Specifications

### 3.1 AppBar — "My requests"

| Property | Value |
|---|---|
| **Pixel component** | `MpTextAppBar` |
| **Title** | `"My requests"` |
| **Title style** | `MpTextStyles.xl` — 24px / 32px line-height / semiBold |
| **Title color** | `MpColors.text.primary` → `#272B32` |
| `centerTitle` | `false` (left-aligned) |
| `automaticallyImplyLeading` | `false` (no back button on this tab root) |
| **Background** | `MpColors.bg.surface` (white) |
| **Elevation** | `0` (no shadow, flat) |

```dart
MpTextAppBar(
  title: 'My requests',
  centerTitle: false,
  automaticallyImplyLeading: false,
  elevation: 0,
)
```

**Restrictions:**
- No actions/icons in the trailing area — leave trailing empty.
- Title must not truncate; it is always short enough to fit.

---

### 3.2 Search Bar

> ⚠️ **Bug fix (v2):** Previous version incorrectly used `MpIcons.interfaceEssential.tableViewFilter` (funnel icon) inside a raw `IconButton`. The design uses horizontal-lines filter icon via the dedicated `MpFilterButton` component. See below.

| Property | Value |
|---|---|
| **Pixel component (search)** | `MpSearch` — inline widget below the AppBar |
| **Pixel component (filter action)** | `MpFilterButton` — placed as the `action` prop of `MpSearch` |
| **Hint text** | `"Search vendor, type, or amount"` |
| **Prefix icon** | Search icon → `MpIcons.interfaceEssential.search` (default, no override needed) |
| **Filter icon** | `MpIcons.feature.filter` — horizontal lines `≡` (default icon of `MpFilterButton`) |
| **Shape** | Full pill — `MpRadius.full` (999px) |
| **Background** | `MpColors.bg.surface` (white) |
| **Border** | `MpColors.border.primary` at 1px |
| **Hint color** | `MpColors.text.secondary` → `#758195` |

```dart
MpSearch(
  hintText: 'Search vendor, type, or amount',
  // prefixIcon defaults to MpIcons.interfaceEssential.search — no override needed
  action: MpFilterButton(
    // icon defaults to MpIcons.feature.filter (horizontal lines ≡)
    selectedCount: _activeFilterCount,   // drives the count badge automatically
    showCountBadge: true,
    onTap: () => _openFilterSheet(context),
  ),
  delayTextChanged: 500,
  onTextChanged: (q) => _filterList(q),
)
```

**Why `MpFilterButton` not `IconButton`:**  
`MpFilterButton` is the Pixel-standard component for this pattern. It:  
- Renders `MpIcons.feature.filter` (three horizontal lines `≡`) by default — matching the design  
- Automatically shows a count badge when `selectedCount > 0` via `showCountBadge: true`  
- No manual badge wiring needed — drop `MpBadge.informativeMenu` from the old approach

**Interactions:**
- Tapping the search field activates the keyboard; the list below filters in real-time with a 500 ms debounce (`delayTextChanged: 500`).
- Tapping `MpFilterButton` opens the **Filter Bottom Sheet** (separate screen story).
- `selectedCount` is driven by the number of active filter selections — update state after bottom sheet closes.

**Restrictions:**
- Do not navigate away on search focus — keep the user on this screen.
- Search matches against: vendor/merchant name, expense category, amount string.
- Do **not** use `MpIcons.interfaceEssential.tableViewFilter` (funnel shape) — that is a different icon for table-view column filtering, not this pattern.

---

### 3.3 Monthly Summary Card *(single card container)*

> ⚠️ **Bug fix (v2):** The stats section and the Auto-fill Credits row are **inside one shared card container** — not two separate widgets. Do not split them. The internal divider is a `Divider` widget inside the card, not a card boundary.

**Card container:**

| Property | Value |
|---|---|
| **Background** | `MpColors.bg.surface` |
| **Border radius** | `MpRadius.large` → 8px |
| **Padding** | `MpSpacing.medium` (16px) all sides |
| **Border** | `MpColors.border.subtle` at 1px |
| **Elevation** | 0 (flat, no shadow) |
| **Internal structure** | `Column` with 4 children: label+amount → sub-cards → `Divider` → auto-fill row |

```dart
Container(
  decoration: BoxDecoration(
    color: MpColors.bg.surface,
    borderRadius: BorderRadius.circular(MpRadius.large),  // 8px
    border: Border.all(color: MpColors.border.subtle, width: 1),
  ),
  padding: EdgeInsets.all(MpSpacing.medium),  // 16px
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 3.3a — Label + Total
      // 3.3b — Three sub-cards
      Divider(color: MpColors.border.subtle, height: MpSpacing.medium),  // 3.3c
      // 3.3d — Auto-fill credits row
    ],
  ),
)
```

---

#### 3.3a — Label + Total amount

| Element | Token / Value |
|---|---|
| Label `"This month"` | `MpTextStyles.sm` (14px/20px) · `MpColors.text.secondary` |
| Amount `"Rp1.511.000"` | `MpTextStyles.xl.semiBold` (24px/32px) · `MpColors.text.primary` |
| Vertical gap between label and amount | `MpSpacing.xSmall3` → 4px |
| Bottom gap before sub-cards | `MpSpacing.small` → 12px |

---

#### 3.3b — Three status sub-cards

Render as a `Row` with `MainAxisAlignment.spaceBetween`. Each sub-card:

| Property | Value |
|---|---|
| **Border radius** | `MpRadius.medium` → 6px |
| **Padding** | `MpSpacing.small` (12px) horizontal · `MpSpacing.xSmall` (8px) vertical |
| **Gap between label and value** | `MpSpacing.xSmall3` → 4px |
| **Label style** | `MpTextStyles.xs` (12px/16px) · `MpColors.text.secondary` |
| **Value style** | `MpTextStyles.sm.semiBold` (14px/20px) |

| Sub-card | Background token | Value color token |
|---|---|---|
| **Pending** (count of claims) | `MpColorPalette.indigo.100` | `MpColorPalette.indigo.500` (`#4B61DC`) |
| **Awaiting payment** (amount) | `MpColorPalette.orange.100` | `MpColorPalette.orange.600` |
| **Disbursed** (amount) | `MpColorPalette.green.100` | `MpColorPalette.green.600` |

**Restrictions:**
- Amount values use Indonesian Rupiah formatting: `Rp` prefix, period (`.`) as thousand separator, no decimal (e.g. `Rp1.511.000`).
- Sub-card widths are equal — each wrapped in `Expanded` with `MpSpacing.xSmall` (8px) gap between.
- If a value is zero, still render the sub-card — show `"Rp0"` or `"0 claims"`.
- Sub-cards are non-tappable (informational only).

---

#### 3.3c — Internal Divider

A `Divider` separating the sub-cards from the auto-fill credits row, **inside the same card**:

| Property | Value |
|---|---|
| **Widget** | Flutter `Divider` |
| **Color** | `MpColors.border.subtle` |
| **Height** (spacing above + below) | `MpSpacing.medium` → 16px (`height: 16`) |
| **Thickness** | 1px |
| **Indent / end indent** | 0 (full-width inside card padding) |

---

#### 3.3d — Auto-fill Credits Row

A tappable row at the **bottom of the same card**, below the divider.

| Element | Token / Value |
|---|---|
| Leading icon | Sparkle / AI icon · `MpColors.icon.brand` (`#4B61DC`) · 20×20px |
| Label `"Auto-fill credits"` | `MpTextStyles.sm.semiBold` · `MpColors.text.primary` |
| Trailing `"12 remaining"` | `MpTextStyles.sm` · `MpColorPalette.indigo.500` (brand blue) |
| Vertical gap between row and progress bar | `MpSpacing.xSmall3` → 4px |

**Progress bar below the row:**

| Property | Value |
|---|---|
| **Widget** | `LinearProgressIndicator` (or `MpProgressIndicator` linear variant) |
| **Value** | `creditsUsed / creditsTotal` — fraction 0.0 → 1.0 |
| **Color** (filled) | `MpColorPalette.indigo.500` (`#4B61DC`) |
| **Background** (empty) | `MpColorPalette.indigo.100` |
| **Height** | 3px |
| **Border radius** | `MpRadius.full` (pill ends) |
| **Width** | Full width of the card content area |

> The bar is a **credit usage indicator**, not a decorative border. Its fill width = `creditsUsed / creditsTotal`. As `remaining` decreases, the filled portion grows.

```dart
GestureDetector(
  onTap: _remainingCredits > 0 ? () => _openAutoFillScreen(context) : null,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          MpIcons.interfaceEssential.magic.toIcon(
            color: MpColors.icon.brand,
            size: 20,
          ),
          SizedBox(width: MpSpacing.xSmall),  // 8px
          Text('Auto-fill credits',
              style: MpTextStyles.sm.semiBold
                  .copyWith(color: MpColors.text.primary)),
          Spacer(),
          Text('$_remainingCredits remaining',
              style: MpTextStyles.sm
                  .copyWith(color: MpColorPalette.indigo.s500)),
        ],
      ),
      SizedBox(height: MpSpacing.xSmall3),  // 4px
      ClipRRect(
        borderRadius: BorderRadius.circular(MpRadius.full),
        child: LinearProgressIndicator(
          value: _creditsUsed / _creditsTotal,
          minHeight: 3,
          backgroundColor: MpColorPalette.indigo.s100,
          valueColor: AlwaysStoppedAnimation(MpColorPalette.indigo.s500),
        ),
      ),
    ],
  ),
)
```

**Interactions:**
- Entire row + bar is tappable → navigates to the **Auto-fill Credits** explanation screen.
- `remaining` count updates in real-time from the summary API response.

**Restrictions:**
- When `remaining == 0`, trailing label changes to `"Out of credits"` in `MpColors.text.secondary`, progress bar shows 100% full, and the row is **non-tappable** (`onTap: null`).
- Progress bar is always rendered — even at 0% (empty bar) or 100% (full bar).
- Do **not** render this row as a standalone card or separate widget outside the monthly summary card.

---

### 3.4 Filter Tabs — All / Claims / Trips

| Property | Value |
|---|---|
| **Pixel component** | `MpTabsChips` |
| **Items** | `["All", "Claims", "Trips"]` |
| `currentIndex` | Index of selected tab (default: `0` = All) |
| `horizontalResizing` | `false` (chips are content-sized, not stretched) |
| **Active chip background** | `MpColors.bg.inverse` (`#1D2125` — near black) |
| **Active chip text color** | `MpColors.text.inverse` (`#FFFFFF`) |
| **Inactive chip background** | Transparent / `MpColors.bg.surface` |
| **Inactive chip text color** | `MpColors.text.primary` |
| **Inactive chip border** | `MpColors.border.primary` at 1px |
| **Chip border radius** | `MpRadius.full` (pill) |
| **Padding (row)** | `MpSpacing.medium` (16px) horizontal |

```dart
MpTabsChips(
  items: [
    MpTabsItemData(label: 'All'),
    MpTabsItemData(label: 'Claims'),
    MpTabsItemData(label: 'Trips'),
  ],
  currentIndex: _selectedTabIndex,
  onTap: (index) => setState(() => _selectedTabIndex = index),
)
```

**Interactions:**
- Tapping a chip filters the list below immediately (no loading spinner unless server-side fetch).
- "All" shows both Claims and Trips interleaved chronologically.
- "Claims" shows only `type == 'claim'` items.
- "Trips" shows only `type == 'trip'` items.

**Restrictions:**
- Only one tab can be active at a time — single-select.
- Do not add icons to the chips (text-only as per design).

---

### 3.5 Date Section Header

The section header renders **two stacked labels** inside one header block — a day+month in notice color, and a month+year below it in secondary color.

```
25 MAY       ← day label (notice orange)
MAY 2026     ← month-year label (secondary grey)
```

| Property | Value |
|---|---|
| **Pixel component** | `MpSubHeaderListTileX` with custom `content` (two-line `Column`) |
| **Background** | `MpColors.bg.stage` (light grey page background) |
| **Padding** | `MpSpacing.medium` (16px) horizontal · `MpSpacing.xSmall` (8px) vertical |

| Sub-element | Style | Color |
|---|---|---|
| Day label — `"25 MAY"` | `MpTextStyles.xs.semiBold` (12px/16px) · uppercase | `MpColorPalette.orange.600` |
| Month-year label — `"MAY 2026"` | `MpTextStyles.xs` (12px/16px) · uppercase | `MpColors.text.secondary` |
| Gap between lines | `MpSpacing.xSmall4` → 2px | — |

```dart
MpSubHeaderListTileX(
  label: '',   // not used — override via content
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        DateFormat('dd MMM').format(groupDate).toUpperCase(),  // e.g. "25 MAY"
        style: MpTextStyles.xs.semiBold
            .copyWith(color: MpColorPalette.orange.s600),
      ),
      SizedBox(height: MpSpacing.xSmall4),  // 2px
      Text(
        DateFormat('MMM yyyy').format(groupDate).toUpperCase(),  // e.g. "MAY 2026"
        style: MpTextStyles.xs
            .copyWith(color: MpColors.text.secondary),
      ),
    ],
  ),
)
```

**Restrictions:**
- Both labels are always uppercase.
- Group key is the **calendar date** of `createdAt` (strip time component).
- Do not render a section header if it would have no items under it.
- Use the **request creation date** (not submission or approval date) for grouping.

---

### 3.6 Request List Item

Each request is a list tile with **leading icon · overline type + title + status badge** on the left and **timestamp + amount** on the right.

#### Actual anatomy

```
┌──────────────────────────────────────────────────────┐
│ [icon]  Reimbursement              24 May 2026, 17:42 │
│         Multicompany subcategory         Rp18.002     │
│         [Awaiting approval]                           │
├──────────────────────────────────────────────────────┤
│ [icon]  Cash advance               24 May 2026, 17:41 │
│         Multicompany subcategory         Rp30.002     │
│         [Awaiting approval]                           │
└──────────────────────────────────────────────────────┘
```

| Property | Value |
|---|---|
| **Pixel component** | `MpHeaderListTileX` |
| **Row padding** | `MpSpacing.medium` (16px) horizontal · `MpSpacing.small` (12px) vertical |
| **Divider** | `MpColors.border.subtle` 1px bottom |
| **Background** | `MpColors.bg.surface` |
| `crossAxisAlignment` | `CrossAxisAlignment.start` |

---

#### Leading icon

| Property | Value |
|---|---|
| **Widget** | `MpIcons.feature.*` rendered via `.toIcon()` |
| **Size** | 24×24px |
| **Color** | `MpColors.icon.primary` (`#758195`) |
| **Spacing to content** | `MpSpacing.small` → 12px (`spacing` param of `MpHeaderListTileX`) |

| Request type | Icon |
|---|---|
| `reimbursement` | `MpIcons.feature.expense` |
| `cash_advance` | `MpIcons.feature.cashAdvance` (or closest feature icon) |
| `trip` | `MpIcons.feature.trip` (or `MpIcons.feature.travel`) |

---

#### Left content column

Build as a `Column` passed to `content:` of `MpHeaderListTileX`.

| Row | Element | Token |
|---|---|---|
| 1 | **Type overline** — e.g. `"Reimbursement"`, `"Cash advance"` | `MpTextStyles.xs` (12px/16px) · `MpColors.text.secondary` |
| 2 | **Name / description** — merchant or trip name, can wrap to 2 lines | `MpTextStyles.md` (16px/24px) · `MpColors.text.primary` |
| 3 | **Status badge** — `MpBadge` (see badge mapping below) | See table |
| Gap 1→2 | | `MpSpacing.xSmall4` → 2px |
| Gap 2→3 | | `MpSpacing.xSmall3` → 4px |

---

#### Right column (trailing)

Build as a `Column` passed to `trailing:` of `MpHeaderListTileX`.

| Row | Element | Token |
|---|---|---|
| 1 | **Timestamp** — `"24 May 2026, 17:42"` | `MpTextStyles.xs` (12px/16px) · `MpColors.text.secondary` · right-aligned |
| 2 | **Amount** — `"Rp18.002"` | `MpTextStyles.md` (16px/24px) · `MpColors.text.primary` · right-aligned |
| Gap 1→2 | | `MpSpacing.xSmall4` → 2px |

Timestamp format: `d MMM yyyy, HH:mm` (e.g. `"24 May 2026, 17:42"`)

---

#### Status badge mapping

Status is rendered as `MpBadge` — **not** plain colored text.

| Status | `MpBadge` variant | Example |
|---|---|---|
| `Awaiting approval` | `MpBadge.notice(text: 'Awaiting approval')` | Orange chip |
| `Awaiting payment` | `MpBadge.notice(text: 'Awaiting payment')` | Orange chip |
| `Awaiting report` | `MpBadge.notice(text: 'Awaiting report')` | Orange chip |
| `Pending` | `MpBadge.informative(text: 'Pending')` | Blue chip |
| `Approved` | `MpBadge.positive(text: 'Approved')` | Green chip |
| `Disbursed` | `MpBadge.positive(text: 'Disbursed')` | Green chip |
| `Rejected` | `MpBadge.negative(text: 'Rejected')` | Red chip |
| `Cancelled` | `MpBadge.neutral(text: 'Cancelled')` | Grey chip |

> **Why `MpBadge`, not plain text:** The actual implementation renders the status as a colored chip/pill (rounded background + text), not inline text. Use the `MpBadge.*` status variants consistently.

---

#### Full code example

```dart
MpHeaderListTileX(
  leading: _iconForType(item.type),   // MpIcons.feature.* .toIcon()
  spacing: MpSpacing.small,           // 12px gap leading → content
  crossAxisAlignment: CrossAxisAlignment.start,
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        item.typeLabel,               // e.g. "Reimbursement"
        style: MpTextStyles.xs.copyWith(color: MpColors.text.secondary),
      ),
      SizedBox(height: MpSpacing.xSmall4),  // 2px
      Text(
        item.name,
        style: MpTextStyles.md.copyWith(color: MpColors.text.primary),
        // allow wrapping — no maxLines restriction
      ),
      SizedBox(height: MpSpacing.xSmall3),  // 4px
      _badgeForStatus(item.status),   // MpBadge.notice / .positive / etc.
    ],
  ),
  trailing: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(
        DateFormat('d MMM yyyy, HH:mm').format(item.createdAt),
        style: MpTextStyles.xs.copyWith(color: MpColors.text.secondary),
      ),
      SizedBox(height: MpSpacing.xSmall4),  // 2px
      Text(
        _formatRupiah(item.amountInCents),  // e.g. "Rp18.002"
        style: MpTextStyles.md.copyWith(color: MpColors.text.primary),
      ),
    ],
  ),
  onTap: () => _openDetail(context, item),
  padding: EdgeInsets.symmetric(
    horizontal: MpSpacing.medium,   // 16px
    vertical: MpSpacing.small,      // 12px
  ),
)
```

---

**Interactions:**
- Tapping anywhere on the row → navigates to Request Detail screen.
- No swipe actions.
- Light haptic feedback on tap.

**Restrictions:**
- Name field can wrap to multiple lines — do **not** clamp with `maxLines: 1`.
- Amount uses `Rp` + period thousand separator (e.g. `Rp18.002`, `Rp1.300.000`).
- Timestamp always shows **date + time** (`d MMM yyyy, HH:mm`), not date only.
- Leading icon is **always shown** — every request type must have a mapped icon; use `MpIcons.feature.expense` as fallback for unknown types.
- Status must use `MpBadge` variants — do **not** use plain colored `Text` for status.

---

### 3.7 Empty State

Shown when the list is empty (no results or filtered to zero).

| Property | Value |
|---|---|
| **Illustration** | Custom empty state asset (no requests illustration) |
| **Title** | `"No requests yet"` · `MpTextStyles.l` · `MpColors.text.primary` |
| **Subtitle** | `"Tap + Request to submit your first claim or trip."` · `MpTextStyles.sm` · `MpColors.text.secondary` |
| **Layout** | Vertically centered in the list area |

**Restrictions:**
- When the empty state is from a search/filter (not zero data), change the title to `"No results found"` and subtitle to `"Try a different keyword or filter."`.
- Do not show the empty state during initial load — show `MpProgressIndicator` (see §5) instead.

---

### 3.8 Floating Action Button — "+ Request"

| Property | Value |
|---|---|
| **Pixel component** | `MpFloatingActionButton` (extended variant with label) |
| **Icon** | `MpIcons.interfaceEssential.add` |
| **Label** | `"Request"` |
| **Background** | `MpColors.bg.inverse` → `#1D2125` (near-black) |
| **Icon + text color** | `MpColors.text.inverse` → `#FFFFFF` |
| **Shape** | `MpRadius.full` (pill, 999px) |
| **Placement** | Bottom-right, above bottom nav bar |
| **Scroll behavior** | Shrinks to icon-only on scroll down; expands back on scroll up (use `MpFloatingActionButtonStack` with `shrinkOnScroll: true`) |

```dart
MpFloatingActionButtonStack(
  floatingActionButton: MpFloatingActionButton(
    icon: MpIcons.interfaceEssential.add.toIcon(color: MpColors.white),
    label: 'Request',
    onPressed: () => _openRequestBottomSheet(context),
  ),
  floatingActionButtonLocation: Alignment.bottomRight,
  scrollController: _scrollController,
  child: _listView,
)
```

**Interactions:**
- Tap → opens a **Request Type Picker** bottom sheet (choose between Claim or Trip).
- FAB is always visible regardless of list state (including empty state).

**Restrictions:**
- Do not hide the FAB on any tab (All / Claims / Trips).
- Minimum bottom clearance from FAB to bottom nav: `MpSpacing.medium` (16px).

---

### 3.9 Bottom Navigation Bar

| Property | Value |
|---|---|
| **Pixel component** | `MpBottomNavBar` |
| `currentIndex` | `1` (My requests is index 1) |
| **Elevation** | `0` |
| **Background** | `MpColors.bg.surface` |
| **Active color** | `MpColorPalette.indigo.500` (`#4B61DC`) |
| **Inactive color** | `MpColors.icon.primary` (`#758195`) |

| Index | Label | Icon |
|---|---|---|
| 0 | `Home` | `MpIcons.feature.home` |
| 1 | `My requests` | `MpIcons.feature.receipt` (or document list icon) |
| 2 | `Purchases` | `MpIcons.feature.purchase` |
| 3 | `My cards` | `MpIcons.feature.card` |

```dart
MpBottomNavBar(
  items: [
    MpBottomNavBarItemData(label: 'Home', icon: MpIcons.feature.home),
    MpBottomNavBarItemData(label: 'My requests', icon: MpIcons.feature.receipt),
    MpBottomNavBarItemData(label: 'Purchases', icon: MpIcons.feature.purchase),
    MpBottomNavBarItemData(label: 'My cards', icon: MpIcons.feature.card),
  ],
  currentIndex: 1,
  onTap: (index) => _onNavTap(index),
)
```

**Restrictions:**
- Active tab label uses `MpTextStyles.xs.semiBold` in active color.
- The bottom nav persists across all tabs within this screen — it is part of the root scaffold, not per-tab.
- Do not add badges to any nav item unless a separate notification spec is defined.

---

## 4. Data Model (surface-level for FE)

```dart
enum RequestType { claim, trip }

enum RequestStatus {
  pending,
  awaitingApproval,
  awaitingPayment,
  awaitingReport,
  approved,
  rejected,
  disbursed,
  cancelled,
}

class RequestItem {
  final String id;
  final RequestType type;
  final String title;          // Merchant name or trip title
  final String? category;      // e.g. "Meals & Entertainment" (claim only)
  final String? dateRange;     // e.g. "12 Jun – 16 Jun 2023" (trip only)
  final int? expenseCount;     // e.g. 4 (trip only)
  final int amountInCents;     // Display as Rp with period separators
  final RequestStatus status;
  final DateTime createdAt;    // Used for date-group headers
}
```

**Monthly summary** is a separate API response:
```dart
class MonthlySummary {
  final int totalAmountInCents;
  final int pendingClaimsCount;
  final int awaitingPaymentAmountInCents;
  final int disbursedAmountInCents;
  final int autoFillCreditsRemaining;
}
```

---

## 5. States & Loading

> ⚠️ **Bug fix (v2):** Previous version said "show skeleton loaders" without naming a Pixel component, causing the engineer to build custom grey boxes. Use `MpProgressIndicator` for the list loading state as specified below.

| State | Pixel component | Behaviour |
|---|---|---|
| **Initial load** | `MpProgressIndicator` | Show a **centered spinner** in the list area while data is fetching. Do NOT build custom shimmer boxes. |
| **Loading more** (pagination) | `MpProgressIndicator` (small, inline) | Show a small centered spinner as the last row while the next page loads |
| **Pull-to-refresh** | Flutter `RefreshIndicator` wrapping the list | Reload both summary card and list; spinner shows at top |
| **Search / filter active** | No loading indicator | Filter is local/fast — show results inline immediately |
| **Error** | Custom error widget | Full-area error with "Retry" button + `MpColors.text.secondary` message text |
| **Empty (no data)** | Custom empty state (see §3.8) | Empty state illustration + text |
| **Empty (filtered)** | Custom empty state (see §3.8) | "No results found" variant |

**Why `MpProgressIndicator`, not custom skeleton:**  
`MpHeaderListTileX` has no `.loading` factory constructor (unlike `MpProfileMenuItem` which does). Building custom shimmer grey boxes is non-standard and will not match Pixel's visual language. Use `MpProgressIndicator` centered in the list area for all list-level loading states.

```dart
// Initial load state
if (_isLoading) {
  return Center(
    child: MpProgressIndicator(),
  );
}

// Pagination — append as the last list item
if (_isLoadingMore) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: MpSpacing.medium),
    child: Center(child: MpProgressIndicator()),
  );
}
```

---

## 6. Interactions Summary

| Trigger | Action |
|---|---|
| Tap search field | Focus keyboard, begin debounced filtering |
| Tap filter icon | Open Filter Bottom Sheet |
| Tap auto-fill credits row | Navigate to Auto-fill Credits screen |
| Tap `All` / `Claims` / `Trips` chip | Filter list by type |
| Tap request list item | Navigate to Request Detail screen |
| Tap `+ Request` FAB | Open Request Type Picker bottom sheet |
| Scroll down | FAB shrinks to icon-only |
| Scroll up | FAB expands with label |
| Pull down list | Trigger refresh |
| Tap bottom nav item | Switch to that section |

---

## 7. Restrictions & Edge Cases

1. **Currency formatting** — always `Rp` prefix + period thousand separators, no decimal places (e.g. `Rp1.511.000`).
2. **Date headers** — group by local `createdAt` date, format as `DD MMM` uppercase. If multiple items share the same date, they go under one header.
3. **Auto-fill row** — hide entirely if the feature flag `autofill_credits_enabled` is `false`.
4. **Empty filter tab** — if `Claims` or `Trips` tab has zero items, show the filtered empty state, not a generic one.
5. **Long merchant names** — truncate at 1 line with `ellipsis`; do not wrap to 2 lines in the tile title.
6. **Offline** — show a `MpBanner.warning` at the top of the list reading `"You're offline. Data may be outdated."`.
7. **Zero credits remaining** — auto-fill row label becomes `"Out of credits"` in secondary color; row is non-tappable.
8. **Status fallback** — if an unknown status string is received from API, render it in `MpColors.text.secondary` (neutral) without crashing.
9. **Accessibility** — all interactive rows must have `semantics` strings. FAB label must be read by screen reader as `"Create new request"`.
10. **Android back button** — from this screen (root tab), pressing back should show an app-exit confirmation or do nothing (standard Android pattern for root tabs).

---

## 8. Pixel Component Reference Index

| Component used | Pixel class | Figma node |
|---|---|---|
| Screen scaffold | `MpBasicLayout` | — |
| Page title bar | `MpTextAppBar` | [Figma](https://www.figma.com/file/Lp6VSWJnP5wI4SdztB5H2f/Mobile-Kit-2.1-(WIP)?node-id=44%3A558) |
| Search bar | `MpSearch` | [Figma](https://www.figma.com/design/djepS92jOSLv9ayVBIcH4M/Mobile-Pixel-2.4?node-id=17356-6423) |
| Filter button (beside search) | `MpFilterButton` + `MpIcons.feature.filter` | [Figma](https://www.figma.com/design/djepS92jOSLv9ayVBIcH4M/Mobile-Pixel-2.4?node-id=17391-18567) |
| Status badge (nav) | `MpBadge.informative` / `.notice` / `.positive` / `.negative` | [Figma](https://www.figma.com/design/djepS92jOSLv9ayVBIcH4M/Mobile-Pixel-2.4?node-id=17337-1048) |
| Filter chips | `MpTabsChips` | [Figma](https://www.figma.com/design/djepS92jOSLv9ayVBIcH4M/Mobile-Pixel-2.4?node-id=17359-9407) |
| Date section header | `MpSubHeaderListTileX` | [Figma](https://www.figma.com/design/djepS92jOSLv9ayVBIcH4M/Mobile-Pixel-2.4?node-id=17367-19901) |
| List row | `MpHeaderListTileX` | [Figma](https://www.figma.com/design/djepS92jOSLv9ayVBIcH4M/Mobile-Pixel-2.4?node-id=17367-19901) |
| Row content (2-line) | `MpDoubleListTileXContent` | — |
| Row content (3-line) | `MpOverlineListTileXContent` | — |
| FAB | `MpFloatingActionButton` + `MpFloatingActionButtonStack` | [Figma](https://www.figma.com/design/Lp6VSWJnP5wI4SdztB5H2f/Mobile-Kit-2.1?node-id=17587-13389) |
| Bottom nav | `MpBottomNavBar` | [Figma](https://www.figma.com/file/Lp6VSWJnP5wI4SdztB5H2f/Mobile-Kit-2.1-(WIP)?node-id=44%3A827) |
| List loading state | `MpProgressIndicator` | [Figma](https://www.figma.com/design/djepS92jOSLv9ayVBIcH4M/Mobile-Pixel-2.4?node-id=17829-50116) |
| Offline banner | `MpBanner.warning` | [Figma](https://www.figma.com/file/Lp6VSWJnP5wI4SdztB5H2f/Mobile-Kit-2.1-(In-test)?node-id=1959%3A24743) |
