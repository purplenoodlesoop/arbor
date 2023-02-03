# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.2.0] – 2023-02-03
### Added
- Modules can now override their parents' dependencies of exact types

### Changed
- [BREAKING] Observers are declared as getters and not passed to the super constructor
- `Lifecycle.init()` is not `@internal` anymore
- `HasParent.parent` is not `@internal` anymore

### Fixed
- Documentation link to `example` project


## [0.1.0] – 2023-01-23
### Added
  - Initial version