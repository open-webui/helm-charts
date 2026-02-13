
# Changelog

All notable changes to the Open WebUI Helm chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v12.0.0]

### Changed - BREAKING CHANGES

#### Standard Helm Naming Conventions

**⚠️ This is a breaking change that requires action when upgrading from chart version < 12.0.0**

The chart now follows standard Helm naming conventions to align with best practices used in major open-source Helm charts.

**What changed:**
- `fullnameOverride` now defaults to `""` (empty string) instead of `"open-webui"`
- Resource names are now dynamically generated based on release name and chart name
- Removed redundant `websocket.redis.name` configuration value
- `serviceAccount.name` now defaults to `""` (empty string)

**Impact:**
- **New installations**: No action required. Resources will be named using standard Helm patterns.
- **Existing deployments upgrading**: You **MUST** set `fullnameOverride: "open-webui"` to maintain existing resource names.

**Migration guide for existing deployments:**

To upgrade safely without recreating resources:

```yaml
# In your values.yaml or via --set flag
fullnameOverride: "open-webui"
```

Or via command line:
```bash
helm upgrade open-webui open-webui/open-webui --set fullnameOverride="open-webui"
```

Without this override, Helm will create new resources with different names, leaving your existing StatefulSet, PVC, and Services orphaned.

**Benefits of this change:**
- Aligns with Helm community standards
- Enables easier multi-instance deployments in the same namespace
- Provides more predictable and flexible resource naming
- Simplifies chart maintenance and understanding for users familiar with Helm conventions

**Examples of new naming behavior:**

| Release Name | Chart Name | Result (with empty fullnameOverride) |
|--------------|------------|--------------------------------------|
| `open-webui` | `open-webui` | Resources named `open-webui` |
| `open-webui-dev` | `open-webui` | Resources named `open-webui-dev` |
| `production` | `open-webui` | Resources named `production-open-webui` |
| `my-chat` | `open-webui` | Resources named `my-chat-open-webui` |

### Removed

- **`websocket.redis.name`** configuration value (was unused and redundant with fullname helper)

### Documentation

- Added comprehensive "Resource Naming" section to README explaining naming behavior
- Added detailed upgrade instructions for users on older chart versions
- Improved inline documentation in values.yaml for naming-related parameters

---

Previous releases did not maintain a changelog. This changelog starts from version 12.0.0.
