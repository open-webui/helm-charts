# Changelog

All notable changes to the Terminals Helm chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
