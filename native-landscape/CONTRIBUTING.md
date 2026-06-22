# Contributing

Thanks for your interest in contributing to the Native Landscape project — an
ecologically intelligent native-landscape design tool, starting with the Upper
Midwest. Contributions of code, data, and documentation are all welcome.

Please read this document before opening a pull request, because **by
contributing you agree to license your contribution under the terms below.**

## The two licenses (and what you're agreeing to)

This project deliberately uses two licenses (see [`DATA-LICENSE.md`](./DATA-LICENSE.md)):

| Contribution type | Licensed under | What it means |
|---|---|---|
| **Code** (source, schema, scripts, config) | **AGPL-3.0** ([`LICENSE`](./LICENSE)) | Anyone who distributes *or runs as a network service* a modified version must release their full source under AGPL-3.0. |
| **Data** (plant records, ecological relationships, regional data, docs) | **CC BY-NC-SA 4.0** | Free to share and adapt with attribution, for non-commercial use, under the same license. |

**By submitting a contribution, you certify that:**

1. You wrote the contribution yourself, or you have the right to submit it under
   the applicable license above.
2. You agree to license your code contribution under **AGPL-3.0** and your data
   contribution under **CC BY-NC-SA 4.0**.
3. You understand the project's intent: **open and shareable, but not for
   commercial exploitation.**

This is, in effect, a lightweight
[Developer Certificate of Origin](https://developercertificate.org/). Sign your
commits with `git commit -s` to record your agreement.

## Contributing data — provenance matters most

The ecological data is the heart of this project and the hardest part to get
right. When adding or editing plant records:

- **Record the source.** Every species record carries a `data_source` field. Fill
  it in. If a fact comes from USDA PLANTS, iNaturalist, a native plant society,
  Xerces Society, or your own field observation, say so.
- **Never paste copyrighted text verbatim.** Facts are not copyrightable;
  specific wording and compilations can be. Capture the underlying fact in your
  own words/structure.
- **Respect source licenses.** Do not import data whose license forbids
  redistribution or non-commercial sharing. iNaturalist records in particular
  carry per-observation licenses — check before bulk import.
- **Cite, when possible.** A record that says *why* a plant belongs on a site (its
  ecological rationale) is far more valuable with a citation than without.

If you are unsure whether a source can be incorporated, open an issue and ask
before submitting.

## Contributing code

- Keep changes focused; one logical change per pull request.
- Match the existing style and naming conventions in the surrounding code.
- For schema changes, include a migration and update any affected documentation.
- Add or update tests where they exist.

## License headers in source files

Every source file you add should carry a short copyright and SPDX header.
Copy-paste templates for SQL, Python, JavaScript/TypeScript, HTML, CSS, and
shell are in [`docs/license-headers.md`](./docs/license-headers.md). Data
files (CSV, JSON, YAML) use CC BY-NC-SA 4.0, not AGPL-3.0 — the same doc
explains how to mark those.

If a file you are editing is missing a header, please add one as part of your
change. The `NOTICE` file must also be updated if you are adding a new
third-party data source.

## Getting started

1. Fork the repository and create a branch for your change.
2. Make your change, with `git commit -s` to sign off.
3. Open a pull request describing **what** changed and **why**, and — for data —
   **where it came from**.

## Reporting issues

Bug reports, data corrections, and feature ideas are all valuable. Open an issue
and include enough context to reproduce or understand the request. For data
corrections, please cite a source where you can.

## Questions about commercial use

The licenses here do not permit commercial use of the code or data. If you have a
commercial use case, open an issue or contact the maintainer — a separate
commercial license can be discussed.
