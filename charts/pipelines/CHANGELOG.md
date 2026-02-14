# Changelog

All notable changes to the Pipelines Helm chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.10.1]

### Fixed

#### Resource Naming Collision

Fixed a bug where resources would be named using only the release name, causing collisions when used as a subchart with matching release names.

**What was fixed:**
- Added proper `pipelines.fullname` helper following standard Helm naming conventions
- Resources now generate unique names by combining release name and chart name
- Added support for `fullnameOverride` value to allow custom resource naming

**Impact:**
- **Standalone installations**: Resource names may change (e.g., from "my-release" to "my-release-pipelines")
- **Subchart usage**: Prevents name collisions with parent chart resources

**Migration:**
To maintain existing resource names during upgrade, set:
```yaml
fullnameOverride: "<your-current-release-name>"
```

### Added
- `fullnameOverride` configuration value for complete control over resource naming
- `pipelines.fullname` helper template for consistent resource name generation

---

## [v0.10.0]

Previous releases did not maintain a changelog.
