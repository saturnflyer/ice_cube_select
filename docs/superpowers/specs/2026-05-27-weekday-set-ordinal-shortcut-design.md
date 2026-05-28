# Weekday-set ordinal shortcut

**Status:** Design
**Date:** 2026-05-27
**Scope:** First of a two-part series. This spec covers the convenience shortcut for selecting a set of weekdays at a given ordinal of the month (e.g. "the first 5 weekdays of the month"). The companion week-span feature — treating a week as one contiguous block via an `IceCube::Schedule` with duration — will be designed in a separate spec.

## Goal

Allow a user to select common day-of-week sets at a chosen ordinal of the month in one action instead of clicking individual cells in the monthly "day of week" grid. The output is the same `IceCube::Rule` the grid produces today; no representation or storage change.

User stories:

- "Schedule on the first 5 weekdays of the month" — one action picks Mon–Fri at instance 1.
- "Schedule on the last weekend of the month" — one action picks Sat–Sun at instance -1.
- Composable: "first weekdays + last weekend" should be a two-action sequence that produces the union.

## Mapping to iCal / ice_cube

The shortcut is pure UI sugar over `day_of_week` validations. Two examples:

- First 5 weekdays of the month → `RRULE:FREQ=MONTHLY;BYDAY=1MO,1TU,1WE,1TH,1FR`
  → `IceCube::Rule.monthly.day_of_week(monday:[1], tuesday:[1], wednesday:[1], thursday:[1], friday:[1])`
- Last weekend → `RRULE:FREQ=MONTHLY;BYDAY=-1SA,-1SU`
  → `IceCube::Rule.monthly.day_of_week(saturday:[-1], sunday:[-1])`

"First 5 weekdays" equals "the 5 earliest Mon–Fri dates in the month" for every month-start weekday. The proof: the first occurrence of each weekday name lies within days 1–7, and days 1–7 contain exactly 5 weekdays. Verified empirically against months starting Sun/Mon/Tue/Wed/Thu/Fri/Sat.

## UI

A global control sits above the existing monthly "day of week" calendar grid (`.ice_cube_select_calendar_week` in `app/assets/javascripts/ice_cube_select_dialog.js`):

```
Apply: [Weekdays ▾]   to: [1st ▾]    (Set)  (Clear)

1st   S M T W T F S
2nd   S M T W T F S
3rd   S M T W T F S
4th   S M T W T F S
Last  S M T W T F S
```

### Controls

- **Apply** dropdown: `Weekdays` (Mon–Fri), `Weekend` (Sat–Sun), `All days` (Sun–Sat). Default `Weekdays`.
- **To** dropdown: ordinal values, populated from the same `IceCubeSelect.options.monthly.show_week` array that drives which rows the grid renders, so the picker can never target a row that isn't visible. Default: the first visible ordinal (typically `1st`).
- **Set** button: marks the cells implied by *(Apply, To)* as selected (union with existing selection). Cumulative — does not clear cells outside the targeted set.
- **Clear** button: removes the selected mark from the cells implied by *(Apply, To)*. Does not touch cells outside that set.

### Day-set definitions

- `Weekdays` → days-of-week `{1, 2, 3, 4, 5}` (Mon, Tue, Wed, Thu, Fri) regardless of `first_day_of_week`.
- `Weekend` → `{0, 6}` (Sun, Sat) regardless of `first_day_of_week`.
- `All days` → `{0, 1, 2, 3, 4, 5, 6}`.

### Wiring

`Set` and `Clear` add or remove the `.selected` class on the corresponding `a[day=…][instance=…]` cells in the existing grid, then dispatch the existing `click` handler path so the established `weekOfMonthChanged` rebuilds `currentRule.hash.validations.day_of_week` from the DOM. No new data path; the shortcut is a DOM helper.

### Activation

The control is rendered alongside the calendar_week grid and is only visible while the "day of week" monthly rule type is active (same visibility rule as `.ice_cube_select_calendar_week`).

## Data model

No change. The rule hash produced is the same shape `dirty_hash_to_rule` already accepts. Re-opening the dialog on a rule created by the shortcut shows the same cells selected via the existing rehydration in `initCalendarWeeks`.

## Backend

No change. `IceCubeSelect.dirty_hash_to_rule`, `is_valid_rule?`, the translate/summary middleware, and the form helper continue to operate on `day_of_week` validations as today.

## i18n

Three new keys under the `ice_cube_select` namespace, surfaced through the existing `IceCubeSelect.texts` channel the dialog template reads:

```yaml
en:
  ice_cube_select:
    apply: "Apply"
    to: "to"
    set: "Set"
    clear: "Clear"
    weekdays: "Weekdays"
    weekend: "Weekend"
    all_days: "All days"
```

Ordinal labels in the "To" dropdown (1st, 2nd, 3rd, 4th, 5th, Last) are read from the existing `IceCubeSelect.texts.order` array — the same source the calendar grid uses for its row labels — so no new ordinal strings are introduced.

The French locale file at `app/assets/javascripts/ice_cube_select/fr.js` gets parallel entries.

## Testing

System spec via the existing `capybara-playwright-driver` stack in `spec/`, exercising the dummy app:

1. **Basic Weekdays/1st**: open dialog → Monthly → "day of week" → Apply=Weekdays, To=1st → Set → save. Persisted hidden-field JSON has `validations.day_of_week == {1:[1], 2:[1], 3:[1], 4:[1], 5:[1]}` and `rule_type == "IceCube::MonthlyRule"`.
2. **Weekend/Last**: same flow with Apply=Weekend, To=Last → `day_of_week == {0:[-1], 6:[-1]}`.
3. **Composability (union)**: Apply Weekdays/1st → Set, then Apply Weekend/Last → Set. Result `{1:[1],…,5:[1], 0:[-1], 6:[-1]}`.
4. **Clear is targeted**: After step 3, Apply=Weekend, To=Last → Clear leaves only the weekday entries.
5. **Round-trip**: with a stored rule of `day_of_week:{1:[1],…,5:[1]}`, re-opening the dialog highlights row 1's Mon–Fri cells.
6. **first_day_of_week independence**: with `first_day_of_week=1`, Weekdays still resolves to days `{1,2,3,4,5}`.
7. **`show_week` respect**: with `show_week` hiding the 5th-row, "5th" does not appear in the To dropdown.

No Ruby code changes ⇒ no new RSpec coverage required for `lib/`. Existing specs for `dirty_hash_to_rule`/`is_valid_rule?` continue to apply unchanged.

## Out of scope (deferred to companion spec)

- Week-as-span representation (`IceCube::Schedule` with duration). Separate design.
- Cross-ordinal selections like "first 10 weekdays" (would span ordinals 1 and 2 in a non-uniform way; not expressible as a single ordinal+set).
- Weekly / Yearly shortcuts. Monthly only.
- Configurable day-set definitions beyond Weekdays / Weekend / All days.

## Risks

- **Visual clutter in narrow dialogs.** The added row of two dropdowns + two buttons must fit the dialog's locked width. Mitigation: compact labels and CSS sizing aligned to the existing `.controls` style; verified in the system spec by snapshot or by checking the dialog still positions correctly.
- **Discoverability.** A global control above the grid is less spatially obvious than per-row buttons. Mitigation: section heading and clear labels; an ARIA `aria-controls` link from the control region to the calendar grid.
