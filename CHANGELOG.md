# Changelog

## 1.5.0 (2026-01-18)

# [1.5.0](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.4.0...v1.5.0) (2026-01-18)


### Bug Fixes

* capture PR number directly from gh pr create output ([b4690d9](https://github.com/MBanucu/subscriptions-to-csv/commit/b4690d9b2edd135488983787a6c0b3523be912a2))
* close existing PRs and create fresh ones for automated releases ([c440679](https://github.com/MBanucu/subscriptions-to-csv/commit/c44067981353c7fdac184c986e25e4443f4d9b7e))
* enable auto-merge for automatically generated release PRs ([d83289a](https://github.com/MBanucu/subscriptions-to-csv/commit/d83289aaed03170aabe0e48a787644a2fd24a1f6))
* use GH_TOKEN secret instead of default GITHUB_TOKEN for PR operations ([86553d2](https://github.com/MBanucu/subscriptions-to-csv/commit/86553d2b880fe786ac2d92ae2a47438c9b458e40))


### Features

* add workflow test feature to verify automated release process ([4f53751](https://github.com/MBanucu/subscriptions-to-csv/commit/4f537514a13a847a1ef8482264a244d61ba3e9cc))





# Changelog

## 1.4.0 (2026-01-18)

# [1.4.0](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.3.0...v1.4.0) (2026-01-18)


### Bug Fixes

* remove auto-merge step from release workflow since it's repo-wide ([4c65c97](https://github.com/MBanucu/subscriptions-to-csv/commit/4c65c97006f9e8c04fa60d17bc27d6def8b79137))
* remove auto-merge step from release workflow since it's repo-wide ([90acbdd](https://github.com/MBanucu/subscriptions-to-csv/commit/90acbdd1bd75d3628e60487cfb602b20ee33e3bb))
* remove unsupported --json flag from gh pr create in release workflow ([9d83fdf](https://github.com/MBanucu/subscriptions-to-csv/commit/9d83fdf65f2bc2ba96c0026842ed93e2e3566665))
* remove unsupported --json flag from gh pr create in release workflow ([1342c4b](https://github.com/MBanucu/subscriptions-to-csv/commit/1342c4b7cc86883aec28089ed3f8a8f3f2d352f7))
* remove unsupported --json flag from gh release create command ([7538bf3](https://github.com/MBanucu/subscriptions-to-csv/commit/7538bf35b059b3a4c7157004efba4d2198ae4844))
* reorder publish workflow to create GitHub releases before PyPI ([5239b1a](https://github.com/MBanucu/subscriptions-to-csv/commit/5239b1a9b8889fb2f22dda89ad6892aa1bfd695f))


### Features

* add test feature to verify release workflow ([7018bda](https://github.com/MBanucu/subscriptions-to-csv/commit/7018bdaf263b20c3524835b6cded23459b7304a4))





# Changelog

## 1.3.1 (2026-01-18)

## [1.3.1](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.3.0...v1.3.1) (2026-01-18)


### Bug Fixes

* reorder publish workflow to create GitHub releases before PyPI ([5239b1a](https://github.com/MBanucu/subscriptions-to-csv/commit/5239b1a9b8889fb2f22dda89ad6892aa1bfd695f))





# Changelog

## 1.3.1 (2026-01-18)

## [1.3.1](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.3.0...v1.3.1) (2026-01-18)


### Bug Fixes

* reorder publish workflow to create GitHub releases before PyPI ([5239b1a](https://github.com/MBanucu/subscriptions-to-csv/commit/5239b1a9b8889fb2f22dda89ad6892aa1bfd695f))





# Changelog

## 1.3.0 (2026-01-18)

# [1.3.0](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.2.1...v1.3.0) (2026-01-18)


### Bug Fixes

* add branch filter to workflow_run trigger ([e9bcebd](https://github.com/MBanucu/subscriptions-to-csv/commit/e9bcebd767597fe657f34c95745f66628c39e4c6))
* add GH_TOKEN for GitHub CLI in release workflow ([e2b0b15](https://github.com/MBanucu/subscriptions-to-csv/commit/e2b0b151d6878d8a9766f888f894484b0f56eaca))
* add GH_TOKEN to push release branch step ([aef0a83](https://github.com/MBanucu/subscriptions-to-csv/commit/aef0a83a760922d5c2fcf3bfa49f1a7aaadea769))
* correct Codecov setup with v5 action and proper parameters ([5998347](https://github.com/MBanucu/subscriptions-to-csv/commit/59983471d7a31a06a1c6edff75da06d2359c9726))
* enhance release automation with rebase merges and PR updates ([bc9640f](https://github.com/MBanucu/subscriptions-to-csv/commit/bc9640fec7bf4f6e8c47bc12d5b53171224422df))
* force push release branches to handle existing branches ([c6f00ff](https://github.com/MBanucu/subscriptions-to-csv/commit/c6f00ff6750f7973b17325718a310e18d8da83cd))
* prevent release workflow from triggering on PR branches ([8c3cc87](https://github.com/MBanucu/subscriptions-to-csv/commit/8c3cc87b9b6092e1a46a18545e47bf00375f003c))
* remove non-existent label from PR creation ([0282209](https://github.com/MBanucu/subscriptions-to-csv/commit/028220934f33ef0c987facc08624ba027b831350))
* separate publishing into post-merge workflow ([2e1415e](https://github.com/MBanucu/subscriptions-to-csv/commit/2e1415e04631ca361d413342a9f3b385a7a3caff))
* temporarily disable Codecov due to OIDC token issues in PR context ([9fbe29a](https://github.com/MBanucu/subscriptions-to-csv/commit/9fbe29a61c6d173ec94fe34c8de97386e2171b9e))
* temporarily disable Codecov upload ([4f1b99f](https://github.com/MBanucu/subscriptions-to-csv/commit/4f1b99f28603f82bce87494b07258a8e2d38ef86))
* update license field format for PEP 621 compliance ([c3fbc13](https://github.com/MBanucu/subscriptions-to-csv/commit/c3fbc13f358844f6db2a45898759f4a1d3effe2d))


### Features

* add CI success summary job for GitHub ruleset ([c8c7fcf](https://github.com/MBanucu/subscriptions-to-csv/commit/c8c7fcfb6c265b5abce05eef07e2f51709432a16))
* add Python version matrix to CI ([356878c](https://github.com/MBanucu/subscriptions-to-csv/commit/356878c40b94baad118092758e4a58a3fb5c7333))
* implement proper Codecov setup with branch coverage ([068b862](https://github.com/MBanucu/subscriptions-to-csv/commit/068b862dd6aa66d5ad49dd0ef647b1ecbb3dddbf))
* implement release via PR workflow ([f8953ff](https://github.com/MBanucu/subscriptions-to-csv/commit/f8953ff28d80178006a160a6a4c9120c78887f78))





## [1.2.1](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.2.0...v1.2.1) (2026-01-18)


### Bug Fixes

* make release workflow depend on CI success ([f3eaa9a](https://github.com/MBanucu/subscriptions-to-csv/commit/f3eaa9aae05007112c2e0927377a9bf43718d20e))

# [1.2.0](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.1.5...v1.2.0) (2026-01-18)


### Features

* add CI workflow with pytest ([5783486](https://github.com/MBanucu/subscriptions-to-csv/commit/578348676bb655e6849d037813b2b8b19d0d0124))

## [1.1.5](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.1.4...v1.1.5) (2026-01-18)


### Bug Fixes

* update flake.nix version automatically in releases ([04f6a9a](https://github.com/MBanucu/subscriptions-to-csv/commit/04f6a9a698de9c13b93a5883ad22ac3b964a6df7))

## [1.1.4](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.1.3...v1.1.4) (2026-01-18)


### Bug Fixes

* move version file updates to semantic release exec plugin ([59ab1b4](https://github.com/MBanucu/subscriptions-to-csv/commit/59ab1b4884fd3960a74339ebb0913de0f78ef952))
* remove problematic @semantic-release/exec plugin ([909ec33](https://github.com/MBanucu/subscriptions-to-csv/commit/909ec338d556a1582756125b16302ffc880f6649))

## [1.1.3](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.1.2...v1.1.3) (2026-01-18)


### Bug Fixes

* add exec plugin to update version files before git commit ([e828fe4](https://github.com/MBanucu/subscriptions-to-csv/commit/e828fe42a8dce39121135cb4a92c5cfe9ed29953))
* install exec plugin and manually update version files ([2eb456e](https://github.com/MBanucu/subscriptions-to-csv/commit/2eb456ea08a572d5369458bc1aff1dd4e1b84c99))
* remove problematic exec plugin, use manual version update ([ee857d7](https://github.com/MBanucu/subscriptions-to-csv/commit/ee857d7c9b15860b315fea9a3458e608995108cb))

## [1.1.2](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.1.1...v1.1.2) (2026-01-18)


### Bug Fixes

* configure semantic-release to update version files ([064d148](https://github.com/MBanucu/subscriptions-to-csv/commit/064d14871795a63a59680608b15c0772e1305b37))

## [1.1.1](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.1.0...v1.1.1) (2026-01-18)


### Bug Fixes

* add workflow_dispatch trigger for manual releases ([897273c](https://github.com/MBanucu/subscriptions-to-csv/commit/897273cdfc8441cfd055411ebab1fba9356affef))

# [1.1.0](https://github.com/MBanucu/subscriptions-to-csv/compare/v1.0.1...v1.1.0) (2026-01-18)


### Features

* add automated semantic release workflow ([4b7d3f0](https://github.com/MBanucu/subscriptions-to-csv/commit/4b7d3f0a56096cfb87a25501161a5c28331e352e))
