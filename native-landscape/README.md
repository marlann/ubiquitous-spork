# Native Landscape

*Ecologically intelligent native-landscape design — starting with the Upper
Midwest.*

Most tools solve one slice of native gardening: species ID (iNaturalist),
maintenance tracking (Gardenize/PlantTagg), or disease diagnosis (PlantNet). None
connect **site conditions → ecological fit → spatial design → maintenance →
citizen science** in one place. This project aims to fill that gap.

## Status

Early design. This directory currently contains the proposed **database schema**
and **project licensing**. See [`schema.sql`](./schema.sql) for the data model.

## Scope at launch

- **Users:** homeowners and professionals (with role separation; designers manage
  multiple client sites).
- **Spatial:** GIS-lite — real-world coordinates per plant, importable from
  GPS/GIS, built on PostGIS.
- **Region:** Upper Midwest first, but the schema models regions/ecoregions from
  day one for later expansion.
- **Maintenance:** recurring tasks via RFC 5545 `RRULE`, materialized into
  dated task instances.

## Licensing

This project uses **two licenses**, by design:

- **Code** → [GNU AGPL-3.0](./LICENSE). Strong copyleft, including for software
  run as a network service (§13).
- **Data** (plant catalog, ecological relationships, regional data) →
  [CC BY-NC-SA 4.0](./DATA-LICENSE.md). Attribution, non-commercial, share-alike.

The shared intent: **open and shareable, but not for commercial exploitation.**
The data's NonCommercial term means it is *source-available* rather than
OSI-"open source"; the AGPL code is fully open source. See
[`DATA-LICENSE.md`](./DATA-LICENSE.md) for the reasoning and for how third-party
data provenance (USDA PLANTS, iNaturalist, etc.) is handled.

Commercial use is not permitted under these licenses; a separate commercial
license can be discussed — open an issue.

## Contributing

See [`CONTRIBUTING.md`](./CONTRIBUTING.md). In short: sign off your commits
(`git commit -s`), license code under AGPL-3.0 and data under CC BY-NC-SA 4.0,
and **always record the provenance of any data you add.**
