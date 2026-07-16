# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [4.0.5] - Unreleased

## [4.0.4] - 2026-07-16

### Added

- AnchoredMonthlyRule — a monthly recurrence anchored to the Nth weekday of the month (e.g. Sun/Tue/Thu and the following Sun after the 1st Saturday), with a Rule.from_hash dispatch shim and an "Anchored monthly" option in the recurrence dialog. (40e6310)

### Changed

- Assets are served directly from the engine asset load path under Propshaft and Sprockets, so no install step is required; the ice_cube_select:install generator is now optional and only copies assets for customization. (103c644)
