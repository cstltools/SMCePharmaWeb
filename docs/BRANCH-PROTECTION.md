# Branch Protection Setup

Configure under **Settings → Branches → Branch protection rules**.

## `main`

- Require a pull request before merging (require at least 1 approval).
- Require status checks to pass before merging:
  - `build-and-test` (from `development.yml` / whichever workflow runs on PRs
    targeting `main`).
- Require branches to be up to date before merging.
- Do not allow force pushes; do not allow deletions.
- Restrict who can push directly (admins only, or nobody).

## `staging`

- Require a pull request before merging from `develop`/feature branches.
- Require the `build-and-test` status check to pass.
- Do not allow force pushes.
- (Optional) Restrict direct pushes to release managers only — pushing here
  triggers `staging.yml`'s deploy job, so treat it like a deploy trigger, not
  a scratch branch.

## `develop`

- Require pull requests for feature branches merging in (lighter-weight —
  this is the integration branch, protected mainly to keep history clean).
- Require the `build-and-test` status check to pass.

## Tags (`v*.*.*`)

Production deploys trigger off version tags, not a branch. Protect tag
creation too:

- **Settings → Tag protection rules → New rule → pattern `v*.*.*`**
- Restrict tag creation/deletion to release managers.

This, combined with the `production` environment's **required reviewers**
(see `GITHUB-SECRETS.md`), gives two independent gates before anything
reaches production: (1) only authorized people can create the release tag,
and (2) the deploy job still pauses for explicit approval even after the tag
exists.
