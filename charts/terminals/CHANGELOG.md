# Changelog

All notable changes to the Terminals Helm chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.4.0]

### Fixed
- Terminal CRD no longer hardcodes an empty `storageClass` default, which broke
  PVC provisioning on managed Kubernetes (AWS EKS, GKE, AKS) where the cluster's
  default StorageClass should be used. When `terminalDefaults.persistence.storageClass`
  is unset (the chart default), the field is omitted from the CRD entirely so
  PVCs fall through to the cluster default ([#392](https://github.com/open-webui/helm-charts/issues/392)).

### Added
- `terminalDefaults.persistence.{enabled,size,storageClass}` values to configure
  the persistence defaults baked into the Terminal CRD.

## [v0.3.0]

### Changed
Updated Terminals chart AppVersion to `v0.0.3`, the latest release with bug fixes.

## [v0.2.0]

### Fixed
Updated the Terminals chart AppVersion to `v0.0.1`, which is the first versioned release.

## [v0.1.0]

### Added
- Initial release of the Terminals subchart
- CRD for `Terminal` custom resource (`terminals.openwebui.com`)
- Operator deployment (Kopf controller that watches Terminal CRs)
- Orchestrator deployment (FastAPI service that proxies and provisions terminals)
- RBAC resources for operator and orchestrator
- API key Secret with auto-generation support
- Configurable idle timeout, terminal image, and resource limits
- Support for `kubernetes-operator`, `kubernetes`, `docker`, `local`, and `static` backends
