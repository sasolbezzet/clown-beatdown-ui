# Deploy workflow fix

- Added secret `GH_TOKEN` with `repo` and `workflow` scopes.
- Updated `deploy.yml` to use `${{ secrets.GH_TOKEN }}`.
- Workflow now pushes to `gh-pages` successfully.
