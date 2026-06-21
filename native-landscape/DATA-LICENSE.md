# Data License

The **software** in this directory (source code, schema definitions, scripts,
and configuration) is licensed under the **GNU Affero General Public License,
version 3** — see [`LICENSE`](./LICENSE).

The **data** assets — the curated plant catalog, ecological-relationship
records, regional/ecoregion data, and any accompanying documentation in this
project — are a separate work and are licensed under:

> **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
> (CC BY-NC-SA 4.0)**
> https://creativecommons.org/licenses/by-nc-sa/4.0/

Under this license you are free to **share** and **adapt** the data, provided
you:

- **Attribution** — credit the project and link to this license.
- **NonCommercial** — you may not use the data for commercial purposes.
- **ShareAlike** — if you remix or build on the data, you must distribute your
  contributions under the same license.

## Why two licenses?

Code and data are legally different kinds of work. Copyright applies to code
cleanly, but database and factual content are handled better by a license
written for data. Using AGPL for the application and CC BY-NC-SA for the data
keeps each protected by the instrument designed for it, while expressing the
same intent: **the project is open and shareable, but not for commercial
exploitation.**

> **Note on "open source":** The CC BY-NC-SA NonCommercial restriction means the
> *data* is **source-available**, not "open source" under the strict Open Source
> Initiative definition (which requires permitting commercial use). The AGPL
> *code* is fully OSI-approved open source; its strong copyleft — including the
> §13 requirement that anyone running a modified version as a network service
> publish their source — is the practical deterrent against closed commercial
> forks. This is an intentional, well-understood trade-off.

## Provenance of incorporated data

The plant catalog may incorporate or derive from third-party sources, each with
its own terms. **You must preserve and comply with the original license of any
incorporated source.** Track provenance per record (the schema's `data_source`
field on the `species` table exists for this purpose). Known source categories:

| Source | Typical terms | Notes |
|---|---|---|
| USDA PLANTS Database | U.S. Government public domain | Free to incorporate; attribution courteous |
| iNaturalist observations | Per-observation CC license (varies) | Check each record; many are CC BY-NC |
| Xerces Society host-plant lists | Copyrighted | Use facts, not verbatim text; verify terms |
| Native plant society lists | Varies | Confirm before redistribution |
| Original contributions | CC BY-NC-SA 4.0 (this project) | Your own curated additions |

Facts themselves (e.g., "Asclepias tuberosa is native to Minnesota") are not
copyrightable, but a particular *compilation*, *wording*, or *dataset* can be.
When in doubt, record only the underlying fact and cite the source.

## Commercial use

If you wish to use either the code or the data commercially, the licenses above
do not permit it. A separate commercial license may be negotiated with the
copyright holder. Open an issue or contact the maintainer to discuss.
