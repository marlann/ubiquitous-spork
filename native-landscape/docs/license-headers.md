# License headers for source files

Every source file in this project should carry a brief copyright and license
header. It lets anyone who encounters the file standalone understand its terms
without hunting for the root `LICENSE` file.

Replace `[Your Name or Organization]` and update the year range as needed.
The SPDX identifier on the first line is machine-readable and used by GitHub,
FOSSA, and other license-scanning tools.

---

## SQL (`.sql`)

```sql
-- SPDX-License-Identifier: AGPL-3.0-only
-- Copyright (C) 2026 [Your Name or Organization]
--
-- This file is part of Native Landscape.
-- Native Landscape is free software: you can redistribute it and/or
-- modify it under the terms of the GNU Affero General Public License
-- as published by the Free Software Foundation, version 3.
-- See the LICENSE file for details.
```

---

## Python (`.py`)

```python
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright (C) 2026 [Your Name or Organization]
#
# This file is part of Native Landscape.
# Native Landscape is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation, version 3.
# See the LICENSE file for details.
```

---

## JavaScript / TypeScript (`.js`, `.ts`, `.jsx`, `.tsx`)

```js
// SPDX-License-Identifier: AGPL-3.0-only
// Copyright (C) 2026 [Your Name or Organization]
//
// This file is part of Native Landscape.
// Native Landscape is free software: you can redistribute it and/or
// modify it under the terms of the GNU Affero General Public License
// as published by the Free Software Foundation, version 3.
// See the LICENSE file for details.
```

---

## HTML (`.html`)

```html
<!--
  SPDX-License-Identifier: AGPL-3.0-only
  Copyright (C) 2026 [Your Name or Organization]

  This file is part of Native Landscape.
  Native Landscape is free software: you can redistribute it and/or
  modify it under the terms of the GNU Affero General Public License
  as published by the Free Software Foundation, version 3.
  See the LICENSE file for details.
-->
```

---

## CSS / SCSS (`.css`, `.scss`)

```css
/*
 * SPDX-License-Identifier: AGPL-3.0-only
 * Copyright (C) 2026 [Your Name or Organization]
 *
 * This file is part of Native Landscape.
 * Native Landscape is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License
 * as published by the Free Software Foundation, version 3.
 * See the LICENSE file for details.
 */
```

---

## Shell / Bash (`.sh`)

```sh
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright (C) 2026 [Your Name or Organization]
#
# This file is part of Native Landscape.
# Native Landscape is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation, version 3.
# See the LICENSE file for details.
```

---

## Data files (CSV, JSON, YAML seed data)

Data files in this project are licensed under **CC BY-NC-SA 4.0**, not
AGPL-3.0. Many formats don't support inline comments; use a companion
`_LICENSE` or `README` file in the same directory, or add a `"license"` key
where the format allows it.

For JSON:

```json
{
  "_license": "CC BY-NC-SA 4.0 — https://creativecommons.org/licenses/by-nc-sa/4.0/",
  "_copyright": "Copyright (C) 2026 [Your Name or Organization]",
  "_source": "internal",
  ...
}
```

For YAML:

```yaml
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
# Copyright (C) 2026 [Your Name or Organization]
# Source: internal
```

---

## A note on automation

If the project grows to many files, consider
[`addlicense`](https://github.com/google/addlicense) or
[`reuse`](https://reuse.software/) (implements the REUSE specification) to
check and apply headers automatically in CI. The SPDX identifiers above are
already compatible with both tools.
