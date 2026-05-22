# Request Reimbursement — Designer → Engineer Handover

**Screen:** Request reimbursement form  
**Product:** Mekari Expense (XPM) Mobile  
**Design system:** Pixel 2.4  
**Last updated:** 2026-05-22

---

## 1. Story

A user wants to claim back money they spent out-of-pocket. They reach this screen after tapping **+ Request** from the home FAB, then choosing "Reimbursement" from the action sheet.

There are two entry paths into the form:

| Path | Trigger | Effect on form |
|---|---|---|
| **Snap receipt** | User scans a receipt via camera | Vendor, amount, category, and attachment thumbnails are pre-filled by AI |
| **Fill manually** | User taps "Fill manually instead" on the camera screen | Form opens blank |

The form collects the minimum data needed to submit a reimbursement claim: category, date, vendor, amount, and at least one receipt attachment. Description is optional. On submit, the claim is sent for manager approval and a success toast is shown.

---

## 2. Screen Structure

```
┌─────────────────────────────┐
│       iOS Status Bar        │
│         Page Header         │  ← Back + Title
├─────────────────────────────┤
│       Scrollable Form       │
│  · Claim category  (req)    │
│  · Transaction date (req)   │
│  · Vendor           (req)   │
│  · Amount           (req)   │
│  · Attachment       (req)   │
│  · Description      (opt)   │
├─────────────────────────────┤
│        Action Buttons       │  ← Submit + Cancel
│       Home Indicator        │
└─────────────────────────────┘
```

---

## 3. Design Specification

### Design Tokens

| Token | Value |
|---|---|
| Font family | Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif |
| `space-3xs` | 4px |
| `space-2xs` | 6px |
| `space-xs` | 8px |
| `space-sm` | 12px |
| `space-md` | 16px |
| `space-lg` | 20px |
| `radii-md` | 6px |
| `radii-full` | 999px |
| `color-default` | `#272B32` |
| `color-secondary` | `#656F80` |
| `color-link` | `#4B61DC` |
| `color-inverse` | `#ffffff` |
| `color-border-primary` | `#DCDFE4` |

---

### iOS Status Bar

| Property | Value |
|---|---|
| Background | `#ffffff` |
| Font family | SF Pro (system) |
| Time | 17px / 600 / `#000` / lh 22px |
| Accessories SVG | 77.5 × 13px |

---

### Page Header

| Property | Value |
|---|---|
| Height | 56px |
| Background | `#ffffff` |
| Padding | 0 16px |
| Back button | 36 × 36px, `radii-full`, icon `ti-arrow-left` 22px, transparent background |
| Back button (pressed) | `rgba(0,0,0,0.06)` |
| Title | 24px / 600 / `#272B32` / lh 32px / letter-spacing -0.2px |

---

### Form Layout

| Property | Value |
|---|---|
| Form background | `#ffffff` |
| Form padding | 16px horizontal, 20px bottom |
| Field separator | `1px solid #DCDFE4` (bottom border per field) |
| Field padding | 12px top and bottom |
| Field gap (label → value) | 4px |

---

### Form Field Anatomy (shared across all fields)

| Element | Spec |
|---|---|
| Label | 14px / 600 / `#272B32` / lh 20px |
| Required mark `*` | color `#D52B1E`, margin-left 2px |
| Input / value text | 16px / 400 / `#272B32` / lh 24px |
| Placeholder text | 16px / 400 / `#A6ACBE` / lh 24px |
| Helper text | 12px / 400 / `#656F80` / lh 16px |

---

### Claim Category Field

| Property | Value |
|---|---|
| Type | Select row (tap to open bottom sheet) |
| Trailing icon | Chevron SVG, 20 × 20px, rotated 90° |
| Placeholder | "Select category" — color `#A6ACBE` |
| Filled state | Selected value — color `#272B32` |
| AI badge (when AI-prefilled) | Label "AI", 10px / 700 / `#3b4ec0`, bg `#E5EBFF`, padding 2px 6px, `border-radius` 4px, margin-left 8px, letter-spacing 0.3px |

---

### Transaction Date Field

| Property | Value |
|---|---|
| Type | Row trigger (tap to open date sheet) |
| Default value | Today's date, format: `Thu, 21 May 2026` |
| Trailing icon | `ti-calendar`, 20px / `#758195` |

---

### Vendor Field

| Property | Value |
|---|---|
| Type | Text input |
| Keyboard | Default |
| AI pre-fill | Populated from scanned receipt when entry path = snap |

---

### Amount Field

| Property | Value |
|---|---|
| Type | Text input |
| Keyboard | Numeric (`inputmode="numeric"`) |
| Helper text | "Remaining balance for [Month Year]: Rp [amount]" — always visible below input |
| AI pre-fill | Populated from scanned receipt when entry path = snap |

---

### Attachment Field

| Element | Spec |
|---|---|
| Thumbnail | 80 × 80px, `radii-md` (6px), bg `#1E2230` |
| Remove button | 20 × 20px, `border-radius: 50%`, bg `rgba(15,17,21,0.7)`, icon `ti-x` 12px / `#fff`, absolute top: 4px / right: 4px |
| Add button | 80 × 80px, `radii-md`, border `1.5px dashed #C8D0E0`, icon `ti-plus` 24px / `#4B61DC` |
| Wrap layout | Flex wrap, gap 8px |
| Helper text | 12px / 400 / `#656F80` |
| Add button position | Always last in the list |

---

### Description Field

| Property | Value |
|---|---|
| Type | Multiline textarea |
| Min rows | 2 |
| Max characters | 600 |
| Character counter | Right-aligned below textarea, `0/600`, 12px / `#656F80` |
| Resize | Disabled |
| Required | No |

---

### Action Buttons

| Button | Height | Radius | Background | Text |
|---|---|---|---|---|
| Submit | 48px | 6px | `#4B61DC` | 16px / 600 / `#ffffff` |
| Submit (disabled) | 48px | 6px | `#C8D0E0` | 16px / 600 / `#ffffff`, `cursor: not-allowed` |
| Cancel | 48px | 6px | `#ffffff` | 16px / 600 / `#4B61DC`, border `1px solid #DCDFE4` |

Action bar padding: 12px vertical, 16px horizontal. Gap between buttons: 6px. Background: `#ffffff`.

---

### Home Indicator

| Property | Value |
|---|---|
| Bar size | 134 × 5px |
| Color | `#000000` |
| Border-radius | 999px |
| Padding | 21px 0 8px |

---

## 4. Interactions

### Back Button
- Tap → closes the screen, discards all form state, no confirmation dialog

### Claim Category
- Tap → opens **Category Bottom Sheet**
  - Contains a search input to filter categories
  - 11 options: Meals & Entertainment, Transport, Lodging, Subscription, Office Supplies, Communication, Training & Development, Client Entertainment, Marketing, Health & Wellness, Other
  - Active/selected item is visually highlighted
  - Tap an item → sets value, closes sheet
- Tap backdrop → closes sheet without changing value

### Transaction Date
- Tap → opens **Date Bottom Sheet** with 3 options:
  1. **Today** — shows full formatted date on the right
  2. **Yesterday** — shows full formatted date on the right
  3. **Select date** → closes sheet, opens **Calendar Date Picker**
     - Full month grid view
     - Prev / next month navigation
     - Selected day is highlighted
     - **Confirm** → writes formatted date back to the field
     - **Cancel** → closes picker, no change
- Active option (matches current field value) is visually highlighted
- Tap backdrop → closes sheet without changing value

### Vendor
- Tap → focuses text input, raises native keyboard
- AI snap path: field is pre-filled; user can edit freely

### Amount
- Tap → raises numeric keyboard
- AI snap path: field is pre-filled; user can edit freely
- Remaining balance helper text is always shown, does not update dynamically in this version

### Attachment
- Tap **Add (+) button** → triggers file/camera picker (native OS behavior)
- Tap **Remove (×) button** on a thumbnail → removes that attachment from the list; add button reappears if count was at max
- Max 5 files: add button is hidden once 5 thumbnails are present
- AI snap path: thumbnails are pre-populated from captured photos

### Description
- Tap → focuses textarea, raises native keyboard
- Typing → character counter updates live
- At 600 characters, input is blocked by `maxlength`

### Submit Button
- Tap → submits claim, closes form, navigates to originating tab, shows **success toast**: "Reimbursement submitted"
- Disabled state: shown when required fields are incomplete (category, date, vendor, amount, attachment)

### Cancel Button
- Tap → closes the form, discards all state, returns to previous screen. No toast shown.

---

## 5. Restrictions

| Rule | Detail |
|---|---|
| Required fields | Claim category, Transaction date, Vendor, Amount, Attachment — all must be filled before Submit is enabled |
| Attachment file types | JPG, JPEG, PNG, PDF, CSV, XLSX only |
| Attachment max size | 20 MB per file |
| Attachment max count | 5 files total; add button hidden when limit is reached |
| Description max length | 600 characters; enforced via `maxlength`, counter shown |
| Amount keyboard | Numeric only (`inputmode="numeric"`); no currency symbol entered by user |
| Date range | No future dates — date picker should disable dates after today |
| AI pre-fill | Only applies when entry path is **Snap receipt** AND user has AI credits remaining; with 0 credits, form always opens blank |
| AI badge | Only shown on Category field when AI assigned the value; must be removable if user manually changes the category |
| Form reset | Every time the screen opens (both snap and manual paths), all fields reset to default state before pre-fill is applied |
| Submit disabled state | Button visually changes to `#C8D0E0` bg, `cursor: not-allowed`; must not be tappable |

---

## 6. States Summary

| Component | States |
|---|---|
| Claim category | Empty (placeholder) · Filled · Filled + AI badge |
| Transaction date | Default (today) · Custom selected |
| Vendor | Empty · Filled (manual or AI) |
| Amount | Empty · Filled (manual or AI) |
| Attachment | Empty (add button only) · Partial (1–4 thumbs + add button) · Full (5 thumbs, no add button) |
| Description | Empty (counter 0/600) · Filling (counter updates) · At limit (600/600) |
| Submit button | Disabled · Enabled · Pressed (opacity 0.9) |

---

## 7. Entry Flow Diagram

```
FAB "+ Request"
      │
      ▼
  Action sheet
      │
      ├─ "Reimbursement" ──► Camera / Scan screen
      │                            │
      │                 ┌──────────┴──────────┐
      │                 │                     │
      │           Snap receipt          "Fill manually"
      │           + Confirm                   │
      │                 │                     │
      │                 ▼                     ▼
      │         Form (pre-filled)      Form (blank)
      │                 │                     │
      └─────────────────┴──────────────────── ┤
                                              ▼
                                    Fill → Submit
                                              │
                                      Success toast
                                   Navigate to origin tab
```

---

## 8. Mekari Pixel Component Mapping

Each UI element in this screen maps to an official Pixel component. Use these as the implementation baseline — do not build custom widgets when a Pixel component covers the spec.

---

### Page Header

| Prototype element | Pixel component | Key props |
|---|---|---|
| Back button + title bar | `MpTextAppBar` | `title: 'Request reimbursement'`, `automaticallyImplyLeading: true` (auto-adds back button), `backgroundColor: MpColors.bg.stage` |

```dart
MpTextAppBar(
  title: 'Request reimbursement',
  automaticallyImplyLeading: true,
  backgroundColor: MpColors.bg.stage.light,
)
```

---

### Claim Category Field

| Prototype element | Pixel component | Key props |
|---|---|---|
| Category select row + bottom sheet list | `MpSelect<String>` | `label: 'Claim category'`, `required: true`, `hint: 'Select category'`, `multiSelection: false` |

The bottom sheet and searchable list are handled internally by `MpSelect`. Pass `getItems` to supply the 11 category options. The AI badge on the selected value is a custom inline widget appended to the field's value row — not a native Pixel prop; render it as `MpBadge.informative` (see Badge section below).

```dart
MpSelect<String>(
  label: 'Claim category',
  required: true,
  hint: 'Select category',
  getItems: (_) async => categoryOptions,
  getItemLabel: (item) => item,
  onSelectionChanged: (value) { /* update state */ },
)
```

---

### Transaction Date Field

| Prototype element | Pixel component | Key props |
|---|---|---|
| Date row + date picker sheet | `MpDatePickerField` | `label: 'Transaction date'`, `required: true`, `selectedDate: DateTime.now()`, `lastDate: DateTime.now()` (no future dates) |

`MpDatePickerField` opens `MpDatePicker` bottom sheet automatically on tap. Use `MpDatePickerPattern.dayShortMonthNameYear` for the `Thu, 21 May 2026` display format.

```dart
MpDatePickerField(
  label: 'Transaction date',
  required: true,
  selectedDate: DateTime.now(),
  lastDate: DateTime.now(),
  datePattern: MpDatePickerPattern.dayShortMonthNameYear,
  onChanged: (date) { /* update state */ },
)
```

---

### Vendor Field

| Prototype element | Pixel component | Key props |
|---|---|---|
| Free-text vendor input | `MpTextField` | `label: 'Vendor'`, `required: true`, `textInputType: TextInputType.text` |

```dart
MpTextField(
  label: 'Vendor',
  required: true,
  textInputType: TextInputType.text,
  textInputAction: TextInputAction.next,
  controller: vendorController,
)
```

---

### Amount Field

| Prototype element | Pixel component | Key props |
|---|---|---|
| Numeric input + helper text | `MpTextField` | `label: 'Amount'`, `required: true`, `textInputType: TextInputType.number`, `helper: 'Remaining balance for ...'` |

```dart
MpTextField(
  label: 'Amount',
  required: true,
  textInputType: TextInputType.number,
  textInputAction: TextInputAction.next,
  helper: 'Remaining balance for May 2026: Rp 1.500.000',
  controller: amountController,
)
```

---

### Attachment Field

| Prototype element | Pixel component | Key props |
|---|---|---|
| Thumbnail grid + add button | `MpMultiUpload` | `size: Size(80, 80)`, `spacing: 8`, `onTapDropzone`, `onTapDelete` |

`MpMultiUpload` handles the dropzone (add button with dashed border), thumbnail rendering, and delete button per thumbnail. Set `radius: 6` to match the `radii-md` token.

```dart
MpMultiUpload(
  label: MpUploadLabel(text: 'Attachment', required: true),
  caption: 'Files must be JPG, JPEG, PNG, PDF, CSV, or XLSX. Max 20MB. Up to 5 files.',
  size: const Size(80, 80),
  spacing: 8,
  radius: 6,
  onTapDropzone: (_) { /* open file/camera picker */ },
  onTapDelete: (_) { /* remove attachment */ },
)
```

---

### Description Field

| Prototype element | Pixel component | Key props |
|---|---|---|
| Multiline textarea + character counter | `MpTextField` | `label: 'Description'`, `required: false`, `textInputType: TextInputType.multiline`, `maxLength: 600`, `maxLines: null` |

`MpTextField` with `TextInputType.multiline` expands vertically. The character counter (`0/600`) is rendered automatically when `maxLength` is set.

```dart
MpTextField(
  label: 'Description',
  textInputType: TextInputType.multiline,
  maxLength: 600,
  controller: descController,
)
```

---

### AI Badge (Claim Category)

| Prototype element | Pixel component | Key props |
|---|---|---|
| "AI" tag inline in category value | `MpBadge.informative` | `text: 'AI'`, `size: MpBadgeSize.small` |

Rendered inline alongside the selected category text in the `MpSelect` value row. Remove the badge when the user manually changes the category.

```dart
MpBadge.informative(
  text: 'AI',
  size: MpBadgeSize.small,
)
```

---

### Action Buttons

| Prototype element | Pixel component | Key props |
|---|---|---|
| Submit + Cancel stacked vertically | `MpActionGroup` | `actions: [MpButton.primary(...), MpButton.secondary(...)]` |
| Submit | `MpButton.primary` | `label: 'Submit'`, `onPressed: submitHandler`, disabled when required fields empty |
| Cancel | `MpButton.secondary` | `label: 'Cancel'`, `onPressed: closeHandler` |

```dart
MpActionGroup(
  actions: [
    MpButton.primary(
      label: 'Submit',
      onPressed: isFormValid ? submitReimb : null,
    ),
    MpButton.secondary(
      label: 'Cancel',
      onPressed: closeForm,
    ),
  ],
)
```

---

### Success Toast (on Submit)

| Prototype element | Pixel component | Key props |
|---|---|---|
| "Reimbursement submitted" feedback | `MpToast.done` | `message: 'Reimbursement submitted'` |

```dart
MpToast.done('Reimbursement submitted').show(context);
```

---

### Summary Table

| Screen element | Pixel component | File |
|---|---|---|
| Page header + back button | `MpTextAppBar` | `text_app_bar` |
| Claim category select | `MpSelect<String>` | `select` |
| Category bottom sheet | Built into `MpSelect` | `select_list` |
| Transaction date | `MpDatePickerField` | `date_picker_field` |
| Date picker sheet | Built into `MpDatePickerField` | `date_picker` |
| Vendor input | `MpTextField` | `text_field` |
| Amount input | `MpTextField` | `text_field` |
| Description textarea | `MpTextField` (multiline) | `text_field` |
| Attachment uploader | `MpMultiUpload` | `multi_upload` |
| AI badge | `MpBadge.informative` | `badge` |
| Submit button | `MpButton.primary` | `button` |
| Cancel button | `MpButton.secondary` | `secondary_button` |
| Button container | `MpActionGroup` | `action_group` |
| Success feedback | `MpToast.done` | `toast` |

---

*Prepared from prototype source: [`index.html`](../index.html) — branch `mcp-test`*
