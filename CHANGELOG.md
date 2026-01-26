# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [4.0.2] - 2026-01-26

### Added

- System tests for dialog functionality using Playwright (952b7a3)
- Simplecov test coverage support (a570783)
- Rails generator to copy CSS and JavaScript assets to host app (07f86f4)
- Comprehensive test suite for install generator (07f86f4)
- Post-install message directing users to run generator (07f86f4)
- package.json with Playwright test dependency (b0af11e)
- package-lock.json for dependency version locking (b0af11e)

### Changed

- README with generator installation instructions (07f86f4)
- .gitignore to exclude node_modules and Playwright artifacts (b0af11e)

## [4.0.1] - 2026-01-18

### Changed

- CSS colors now use custom properties for easy theming (d4cdcb0)
- Code style updated to conform to StandardRB conventions (ace89a9)
- Dummy app Gemfile now specifies Ruby version from .ruby-version (cdd4435)
- Lockfiles include ruby platform for Heroku compatibility (cdd4435)
- Sample form uses unique attribute names for each field (6a7c3c3)
- Create view displays all submitted values in a table (6a7c3c3)
- SVG icons now use mask-image for CSS variable theming support (59b95b4)

### Added

- OKLCH color system with base variables for quick theme customization (d4cdcb0)
- Fallback hex values for browsers without OKLCH support (d4cdcb0)
- StandardRB linting to CI workflow on Ruby 4.0 (ace89a9)
- Procfile for Heroku deployment (6ef9feb)

### Fixed

- Set the CI branch to check against main (1284115)
- Heroku deployment now uses correct Ruby version from .ruby-version (ea6d6b5)
- Reference to original at gregschmit/recurring_select (85d3187)
- Dialog no longer expands horizontally during user interaction (145f28a)

### Removed

- Reference to heroku demo site. (85d3187)
