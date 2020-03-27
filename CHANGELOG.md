# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

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
