# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

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

## [3.0.1] - 2022-05-30

### 

- * Change the name to not clash with existing repository.
  * Add sprockets engine to support rails 7

## [2.0.0] - 2015-09-24

### Removed

- * Dropping support for rails 3.X - Upgrade to sass-rails 4

### Fixed

- * Rename all css.scss to .scss [#86](https://github.com/GetJobber/ice_cube_select/pull/86)

## [1.2.4] - 2014-10-17

### Added

- * Options to show 5th week and last week in monthly recurring UI. [#66](https://github.com/GetJobber/ice_cube_select/pull/66) (thanks @naomiaro)

## [1.2.3] - 2014-10-01

### Removed

- * Revert fix hidden dialog when called from Bootstrap modal. [#47](https://github.com/GetJobber/ice_cube_select/pull/47)

## [1.2.2] - 2014-09-29

### Changed

- * Show currently selected rule first when selected [#65](https://github.com/GetJobber/ice_cube_select/pull/65) (thanks @ericmwalsh)
  * Travis CI: Testing against latest point releases of Rails.

### Fixed

- * Add some explicit CSS rules to fix issues with Zurb Foundation. [#50](https://github.com/GetJobber/ice_cube_select/pull/50) (thanks @ndbroadbent)
  * Fix hidden dialog when called from Bootstrap modal. [#47](https://github.com/GetJobber/ice_cube_select/pull/47) (thanks @rgrwatson85)
  * Fix dialog in IE. [#46](https://github.com/GetJobber/ice_cube_select/pull/46) (thanks @ttp)
  * Fix rebinding for day of the week selection [#60](https://github.com/GetJobber/ice_cube_select/pull/60) (thanks @joshjordan)

## [1.2.1] - 2014-02-12

### Added

- * Add LICENSE to gemspec
  * Testing JRuby on Travis CI, removing appraisal.

## [1.2.1.rc3] - 2013-11-11

### Fixed

- * Issue where the select sometimes throws an uninitialized
  constant (thanks @fourseven)

## [1.2.1.rc2] - 2013-10-30

### Fixed

- * Recurring select input displays inconsistently in development
  * dirty_hash_to_rule was modifying its argument [#35](https://github.com/GetJobber/ice_cube_select/pull/35) (thanks @asgeo1)
  * Handle empty hashes [#36](https://github.com/GetJobber/ice_cube_select/pull/36) (thanks @asgeo1)

## [1.2.1.rc1] - 2013-08-07

### Fixed

- * For blank select fields.

### Added

- * Testing multiple Rails versions in Travis CI.

## [1.2.0] - 2013-07-03

### Changed

- * I18n aware [#19](https://github.com/GetJobber/ice_cube_select/pull/19) (thanks @vddgil)

### Removed

- * remove IceCube::ValidatedRule#to_s monkey patch [#21](https://github.com/GetJobber/ice_cube_select/pull/21) (thanks @ajsharp)

## [1.1.0] - 2013-06-27

### Changed

- * Rails 4 support (thanks @afhammad) #17

## [1.0.2] - 2013-04-30

### Changed

- *  Allow dialog summary to wrap (thanks @mhchen) #4

## [1.0.1] - 2013-04-25

### Fixed

- * convert week_start value to integer (thanks @rubenrails) #2
  * ice_cube_select should be able to handle a string as the input #1

## [1.0.0] - 2013-04-16

### Added

- * First public release
