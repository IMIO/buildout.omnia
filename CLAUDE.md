# imio.omnia — Buildout root

Plone 6.1 buildout aggregating the **Omnia** add-on suite — iMio's AI-assisted features for Plone. Python 3.12, managed with `zc.buildout` + `mr.developer`.

## Packages

All source packages live under `src/` and are registered as develop eggs:

| Package | Role |
|---------|------|
| `imio.omnia.core` | Shared infrastructure: settings, control panel, services wrapping the Omnia APIs, extension point interfaces (`IOrganizationIDProvider`, `IOmniaActionsProvider`, …) |
| `imio.omnia.tinymce` | TinyMCE integration: AI text actions (expand, improve, reduce, correct, translate, accessibility) inside the rich-text editor. Depends on `core`. |
| `imio.omnia.assistant` | Floating AI chat assistant widget: streaming chat via the OpenAI-compatible API, page-content injection, configurable via a control panel tab in the shared Omnia settings UI. Depends on `core`. |

`imio.omnia.classification` is declared in `sources.cfg` but not yet active (not in `develop` or `eggs`).

Additionally, `sources.cfg` auto-checks out two support packages via `mr.developer`:

- `imio.helpers` — iMio shared Plone helpers
- `collective.fingerpointing` — audit-log add-on

## Backend APIs

The Plone add-ons talk to two upstream services hosted behind `ipa.imio.be`:

- **Omnia Core API** (`/imio/omnia/core/v1/agents/`) — text expansion, improvement, correction, translation, categorization, etc.
- **Omnia OpenAI API** (`/imio/omnia/openai/v1/`) — OpenAI-compatible gateway (models list, chat completions with streaming).

Connection settings are configured via environment variables synced to the Plone registry at startup.

## Quick start

```bash
make setup   # copy secrets, create virtualenv, run buildout
make fg      # Plone on :8080  (admin:admin)
```

Or manually:

```bash
cp secrets.example.cfg secrets.local.cfg
bin/buildout          # build everything
bin/instance fg       # Plone on :8080  (admin:admin)
```

Local secrets live in `secrets.local.cfg`, which is loaded automatically by
`buildout.cfg` through `optional-extends`. Keep that file untracked and commit
only `secrets.example.cfg`.

### Makefile targets

| Target | Action |
|--------|--------|
| `make setup` | Copy secrets, create virtualenv, run buildout |
| `make buildout` | Run buildout only |
| `make fg` | Start instance in foreground |
| `make start` / `make stop` / `make restart` | Manage background instance |
| `make test` | Run the test suite |
| `make clean-all` | Remove all generated buildout state and virtualenv |

## Environment variables

Set in `buildout.cfg` → `[instance] environment-vars`, or export in your shell:

| Variable | Purpose |
|----------|---------|
| `SITE_ID` | Plone site ID in the ZODB (default: `Plone`) |
| `OMNIA_CORE_API_URL` | Omnia Core API base URL |
| `OMNIA_OPENAI_API_URL` | Omnia OpenAI API base URL |
| `OMNIA_APPLICATION_ID` | Application identifier sent in request headers |
| `OMNIA_ORGANIZATION_ID` | Default organization / municipality ID |

## Code style

- **Black** (line length 88), **isort** (`profile = plone`), **flake8**
- i18n domain per package (`imio.omnia.core`, `imio.omnia.tinymce`, `imio.omnia.assistant`, …)
- Each sub-package has its own `tox.ini` for tests and linting
