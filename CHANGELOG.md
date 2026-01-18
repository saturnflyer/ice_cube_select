# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

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

## [4.0.0] - 2026-01-17

### Changed

- Target Rails 8.0+ only (390409c)
- Convert jQuery to vanilla JavaScript ES6 classes (390409c)
- Switch from Sprockets/SCSS to Propshaft/CSS (390409c)
- Update middleware for Rack 3 compatibility (390409c)
- Update README for Rails 8.0+, vanilla JS, Propshaft (f2335c4)
- Update CI to test Ruby 3.3, 3.4, and 4.0 (99cb50f)
- Update minimum Ruby version to 3.3+ (99cb50f)
- Add cooldown period before Dependabot rebases PRs (01ed915)

### Removed

- jQuery dependency (390409c)
- sass-rails dependency (390409c)
- Image assets (replaced with inline SVGs) (390409c)
- Rails 6.x and 7.x support (390409c)

### Fixed

- Add reissue gem to CI gemfile (f2335c4)
