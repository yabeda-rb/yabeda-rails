# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 0.8.0 - 2022-05-30

### Added

- Add ability to expose custom Apdex target value for later use in graphs/alerts. [@Envek][] in [#18](https://github.com/yabeda-rb/yabeda-rails/pull/18)

### Changed

- Reduce number of dependencies by depending only on railties instead of the whole Ruby on Rails. [@lautis][] in [#23](https://github.com/yabeda-rb/yabeda-rails/pull/23).

## 0.7.2 - 2021-03-15

### Fixed

- Fix undesirable overwrite of metric tags when global `default_tag` is declared with one of tag names that are being used by yabeda-rails, like `controller`. [@liaden] in [#19](https://github.com/yabeda-rb/yabeda-rails/pull/19)

## 0.7.1 - 2020-10-02

### Changed

 - Explicitly require previously removed railtie to fix case when it doesn't get required in `yabeda` gem (if `yabeda` is required before `rails`). See [yabeda-rb/yabeda#15](https://github.com/yabeda-rb/yabeda/issues/15). @Envek

## 0.7.0 - 2020-08-21

### Removed

 - Railtie to configure Yabeda – it is moved into Yabeda itself. Increase required Yabeda version to keep behavior for users who require only `yabeda-rails` in their Gemfiles. @Envek

## 0.6.0 - 2020-08-06

### Added

 - Ability to add default/custom tags to metrics from controllers. @raivil in [#13](https://github.com/yabeda-rb/yabeda-rails/pull/13)

## 0.5.0 - 2020-03-27

### Added

 - Support for Unicorn application server. @vast in [#9](https://github.com/yabeda-rb/yabeda-rails/pull/9)

## 0.4.0 - 2020-01-28

### Changed

 - Configure Yabeda after application initialization as since 0.4.0 Yabeda requires to call configuration logic explicitly. @Envek

## 0.2.0 - 2020-01-14

### Changed

 - Added `tags` option to metric declarations for compatibility with yabeda and yabeda-prometheus 0.2. @Envek

## 0.1.2 - 2019-01-19

### Added

 - Support for Puma application server. @daffydowden

## 0.1.1 - 2018-10-17

### Changed

 - Renamed evil-metrics-rails gem to yabeda-rails. @Envek

## 0.1.0 - 2018-10-03

 - Initial release of evil-metrics-rails gem. @Envek

   Basic metrics for request durations by controller, action, status, format, and method. ActiveRecord and ActionView timings.

[@Envek]: https://github.com/Envek "Andrey Novikov"
[@liaden]: https://github.com/liaden "Joel Johnson"
[@lautis]: https://github.com/lautis "Ville Lautanala"
