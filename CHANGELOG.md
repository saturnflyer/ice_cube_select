# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [4.0.1] - Unreleased

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
