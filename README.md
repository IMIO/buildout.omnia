# buildout.omnia

This repository is a `zc.buildout` project used for local development of the
`imio.omnia.*` package family.

It assembles the Omnia packages in one Plone buildout, wires their development
checkouts, and provides a runnable local instance for integration work and
testing.

This repo is intended for development purposes, not as a standalone Python
package to publish.

For more information about the Omnia suite of add-ons, see
[`imio.omnia.core`](https://github.com/imio/imio.omnia.core).

## Scope

- `imio.omnia.core`
- `imio.omnia.tinymce`
- `imio.omnia.assistant`
- other `imio.omnia.*` packages as needed

## Local setup

```bash
make setup
make fg
```

`make setup` creates the project-root virtualenv (`bin/`, `lib/`, `include/`,
`pyvenv.cfg`), installs the pinned buildout tooling from
[`requirements-6.2.txt`](requirements-6.2.txt),
copies `secrets.example.cfg` to `secrets.local.cfg` when needed, and runs
buildout.

`secrets.local.cfg` contains local-only configuration and must not be
committed.

Run `make help` to see the available shortcuts for buildout, instance control,
and tests.
