# Contributing to the Open WebUI Helm Charts

## How to Contribute

1. **Fork the repository** and create your branch from `main`.
2. **Make your changes** and ensure they follow the guidelines below.
3. **Test your changes** locally to ensure everything works as expected. This should include deploying your updates to a live Kubernetes cluster (whether local or remote).
4. **Update the CHANGELOG** - Add your changes to the `[Unreleased]` section in the chart's `CHANGELOG.md` file (e.g., `charts/open-webui/CHANGELOG.md`). Follow the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format and categorize changes appropriately (Added, Changed, Deprecated, Removed, Fixed, Security). Breaking changes should be clearly marked.
5. **Run [helm-docs]** to ensure that the README is updated with the latest changes. 
6. **Commit your changes** using a descriptive commit message that follows the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.
7. **Push your changes** to your forked repository.
8. **Create a Pull Request** and provide a detailed description of your changes. Please consider dropping us your redacted `values.yaml` file used during your testing in the PR so we can make sure we see consistent results. 

## Guidelines

- **Semantic Versioning**: This repository follows [Semantic Versioning](https://semver.org/) for versioning the Helm Charts. When making changes, please ensure that you update the version in the `Chart.yaml` file according to the following rules:
  - `MAJOR` version increment for incompatible chart changes
  - `MINOR` version increment for backwards-compatible functionality additions
  - `PATCH` version increment for backwards-compatible bug fixes

- **Chart.yaml Updates**: When submitting a Pull Request, ensure that you have updated the `Chart.yaml` file with the appropriate version increment and a brief description of the changes in the `appVersion` field.

- **CHANGELOG Updates**: All changes must be documented in the `CHANGELOG.md` file within the chart directory (e.g., `charts/open-webui/CHANGELOG.md`). Add your changes under the `[Unreleased]` section using the appropriate category:
  - `Added` for new features
  - `Changed` for changes in existing functionality (mark as **BREAKING CHANGES** if backwards incompatible)
  - `Deprecated` for soon-to-be removed features
  - `Removed` for removed features
  - `Fixed` for bug fixes
  - `Security` for vulnerability fixes
  
  Breaking changes should be clearly highlighted and include migration instructions when applicable.

- **Code Style**: Follow the existing code style and conventions used in the repository.

- **Documentation**: If your changes require documentation updates, please include them in your Pull Request.

- **Testing**: Before submitting your Pull Request, ensure that your changes work as expected by testing them locally. This should include deploying your updates to a live Kubernetes cluster (whether local or remote).

- **Issues**: If you find any issues or have suggestions for improvements, please create a new issue in the repository before working on a Pull Request.

- **Actions Updates**: If your Pull Request includes adding a new chart dependency, ensure to make the necessary updates to Github Actions to add the chart repo dependency, or else the release run will fail.

## Getting Help

If you need any help or have questions about contributing, feel free to reach out to the maintainers of the repository.

Thank you for your contributions!

[helm-docs]: https://github.com/norwoodj/helm-docs
