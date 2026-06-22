-- SPDX-License-Identifier: AGPL-3.0-only
-- Copyright (C) 2026 [Your Name or Organization]
--
-- This file is part of Native Landscape.
-- Native Landscape is free software: you can redistribute it and/or
-- modify it under the terms of the GNU Affero General Public License
-- as published by the Free Software Foundation, version 3.
-- See the LICENSE file for details.
--
-- Native Landscape — proposed database schema
-- Target: PostgreSQL + PostGIS
--
-- Scope decisions reflected here:
--   * Homeowners AND professionals, with role separation (designers manage
--     multiple client sites).
--   * GIS-lite: real-world lat/lng geometry per plant (PostGIS).
--   * Upper Midwest first, but regions/ecoregions modeled for expansion.
--   * Recurring maintenance via RFC 5545 RRULE, materialized into task rows.
--
-- This is a design sketch, not a migration. Enum/type choices are illustrative;
-- in a real migration you'd decide between native ENUM types and lookup tables.

-- Requires: CREATE EXTENSION IF NOT EXISTS postgis;

-- =====================================================================
-- 1. Auth & Identity
-- =====================================================================

CREATE TABLE users (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email       text UNIQUE NOT NULL,
    name        text,
    role        text NOT NULL CHECK (role IN ('homeowner','professional','admin')),
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE organizations (          -- professional design firms
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text NOT NULL,
    owner_id    uuid NOT NULL REFERENCES users(id)
);

CREATE TABLE org_memberships (
    org_id      uuid NOT NULL REFERENCES organizations(id),
    user_id     uuid NOT NULL REFERENCES users(id),
    role        text NOT NULL CHECK (role IN ('owner','member')),
    PRIMARY KEY (org_id, user_id)
);

-- =====================================================================
-- 2. Geography Reference
-- =====================================================================

CREATE TABLE regions (                -- hierarchical: US > Midwest > Upper Midwest
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text NOT NULL,
    code        text,                 -- e.g. 'upper_midwest'
    parent_id   uuid REFERENCES regions(id),
    geom        geometry(MultiPolygon, 4326)
);

CREATE TABLE ecoregions (             -- EPA Level III/IV ecoregions
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text NOT NULL,
    epa_code    text,                 -- e.g. '51a'
    level       smallint,             -- 3 or 4
    region_id   uuid REFERENCES regions(id),
    geom        geometry(MultiPolygon, 4326)
);

-- =====================================================================
-- 3. Plant & Species Catalog
-- =====================================================================

CREATE TABLE species (
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    scientific_name   text UNIQUE NOT NULL,
    genus             text,
    family            text,
    common_names      text[],
    usda_symbol       text,           -- USDA PLANTS linkage
    inat_taxon_id     bigint,         -- iNaturalist linkage
    growth_form       text CHECK (growth_form IN
                        ('forb','grass','sedge','shrub','small_tree',
                         'canopy_tree','vine','fern','moss')),
    lifespan          text CHECK (lifespan IN ('annual','biennial','perennial')),
    height_min_cm     smallint,
    height_max_cm     smallint,
    spread_min_cm     smallint,
    spread_max_cm     smallint,
    bloom_start_month smallint CHECK (bloom_start_month BETWEEN 1 AND 12),
    bloom_end_month   smallint CHECK (bloom_end_month BETWEEN 1 AND 12),
    sun_requirements  text[],         -- ['full_sun','part_shade']
    moisture_needs    text[],         -- ['mesic','hydric']
    soil_preferences  text[],         -- ['loam','clay','sand']
    wildlife_value    jsonb,          -- {pollinators:[...], birds:[...]}
    data_source       text CHECK (data_source IN
                        ('internal','usda','inat','seeded')),
    notes             text,
    extra_attributes  jsonb,          -- escape hatch for future attributes
    created_at        timestamptz NOT NULL DEFAULT now(),
    updated_at        timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE species_nativity (       -- species x ecoregion
    species_id      uuid NOT NULL REFERENCES species(id),
    ecoregion_id    uuid NOT NULL REFERENCES ecoregions(id),
    nativity_status text NOT NULL CHECK (nativity_status IN
                      ('native','introduced','invasive','extirpated')),
    confidence      text CHECK (confidence IN
                      ('confirmed','probable','uncertain')),
    source_notes    text,
    PRIMARY KEY (species_id, ecoregion_id)
);

CREATE TABLE wildlife_taxa (          -- insects, birds, mammals in relationships
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    scientific_name text,
    common_names    text[],
    taxon_rank      text,             -- genus, species, family, order
    kingdom         text,
    inat_taxon_id   bigint
);

CREATE TABLE ecological_relationships (
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    plant_species_id  uuid NOT NULL REFERENCES species(id),
    relationship_type text NOT NULL CHECK (relationship_type IN
                        ('larval_host_for','nectar_source_for','seed_dispersed_by',
                         'pollinated_by','competes_with','companion_to')),
    wildlife_taxon_id uuid REFERENCES wildlife_taxa(id),
    related_species_id uuid REFERENCES species(id),
    notes             text,
    -- exactly one of the two targets must be set
    CHECK ( (wildlife_taxon_id IS NOT NULL)::int
          + (related_species_id IS NOT NULL)::int = 1 )
);

-- =====================================================================
-- 4. Sites & Spatial
-- =====================================================================

CREATE TABLE sites (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name          text NOT NULL,
    address       text,
    centroid      geometry(Point, 4326),
    boundary      geometry(Polygon, 4326),   -- rough property outline
    area_sq_m     numeric,
    owner_id      uuid NOT NULL REFERENCES users(id),
    ecoregion_id  uuid REFERENCES ecoregions(id),  -- derived, stored for speed
    created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE site_collaborators (     -- pro designers on a homeowner's site
    site_id     uuid NOT NULL REFERENCES sites(id),
    user_id     uuid NOT NULL REFERENCES users(id),
    role        text NOT NULL CHECK (role IN ('viewer','editor','designer')),
    invited_at  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (site_id, user_id)
);

CREATE TABLE site_conditions (        -- mapped microclimates within a site
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id         uuid NOT NULL REFERENCES sites(id),
    condition_type  text NOT NULL CHECK (condition_type IN
                      ('sun_exposure','moisture','soil_type','soil_ph',
                       'slope','drainage')),
    value           text,             -- 'full_sun', 'hydric', '6.2'
    geom            geometry(Polygon, 4326),
    notes           text
);

CREATE TABLE site_zones (             -- named beds, areas, garden rooms
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id     uuid NOT NULL REFERENCES sites(id),
    name        text NOT NULL,        -- 'Front Rain Garden'
    zone_type   text CHECK (zone_type IN
                  ('bed','lawn','woodland_edge','prairie','rain_garden',
                   'pond_margin','meadow','path','structure')),
    geom        geometry(Polygon, 4326),
    notes       text
);

CREATE TABLE site_plants (            -- individual plants in the ground
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id         uuid NOT NULL REFERENCES sites(id),
    zone_id         uuid REFERENCES site_zones(id),
    species_id      uuid NOT NULL REFERENCES species(id),
    common_name_tag text,             -- override or informal name
    source          text CHECK (source IN
                      ('planted','discovered','inat_imported')),
    planted_date    date,
    location        geometry(Point, 4326),
    health_status   text CHECK (health_status IN
                      ('excellent','good','fair','poor','dead','removed')),
    notes           text,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now()
);

-- =====================================================================
-- 5. Design Projects
-- =====================================================================

CREATE TABLE projects (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id     uuid NOT NULL REFERENCES sites(id),
    name        text NOT NULL,
    description text,
    designer_id uuid REFERENCES users(id),
    status      text CHECK (status IN
                  ('draft','proposed','active','completed','archived')),
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE project_design_goals (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id  uuid NOT NULL REFERENCES projects(id),
    goal_type   text CHECK (goal_type IN
                  ('pollinator_habitat','bird_habitat','butterfly_host',
                   'rain_garden','erosion_control','screening',
                   'food_forest','aesthetic','seasonal_interest')),
    priority    smallint,             -- 1 = highest
    notes       text
);

CREATE TABLE project_plant_selections (
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id        uuid NOT NULL REFERENCES projects(id),
    zone_id           uuid REFERENCES site_zones(id),
    species_id        uuid NOT NULL REFERENCES species(id),
    quantity          smallint,
    rationale         text,           -- why this plant for this site
    proposed_location geometry(Point, 4326),
    status            text CHECK (status IN
                        ('proposed','approved','rejected','installed')),
    installed_site_plant_id uuid REFERENCES site_plants(id)  -- linked once installed
);

-- =====================================================================
-- 6. Maintenance
-- =====================================================================

CREATE TABLE maintenance_schedules (  -- recurring task templates
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id       uuid NOT NULL REFERENCES sites(id),
    zone_id       uuid REFERENCES site_zones(id),       -- null = site-wide
    site_plant_id uuid REFERENCES site_plants(id),      -- null = not plant-specific
    task_type     text NOT NULL CHECK (task_type IN
                    ('water','fertilize','prune','deadhead','divide','mulch',
                     'weed','seed','transplant','pest_treatment','cutback',
                     'observation_walk','other')),
    title         text,
    notes         text,
    rrule         text,               -- RFC 5545 RRULE, e.g. 'FREQ=WEEKLY;BYDAY=MO,TH'
    starts_on     date,
    ends_on       date,               -- null = no end
    created_by    uuid REFERENCES users(id)
);

CREATE TABLE maintenance_tasks (      -- generated instances from schedules
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    schedule_id   uuid REFERENCES maintenance_schedules(id),  -- null = ad-hoc
    site_id       uuid NOT NULL REFERENCES sites(id),
    site_plant_id uuid REFERENCES site_plants(id),
    task_type     text NOT NULL,      -- same domain as schedule.task_type
    title         text,
    due_date      date,
    completed_at  timestamptz,        -- null = not done
    completed_by  uuid REFERENCES users(id),
    notes         text,
    created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE maintenance_logs (       -- free-form work journal entries
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id       uuid NOT NULL REFERENCES sites(id),
    task_id       uuid REFERENCES maintenance_tasks(id),
    performed_at  timestamptz NOT NULL DEFAULT now(),
    performed_by  uuid REFERENCES users(id),
    description   text,
    observations  text                -- what they noticed while working
);

-- =====================================================================
-- 7. Diagnostics
-- =====================================================================

CREATE TABLE diagnostic_reports (
    id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    site_plant_id        uuid NOT NULL REFERENCES site_plants(id),
    reported_by          uuid REFERENCES users(id),
    reported_at          timestamptz NOT NULL DEFAULT now(),
    symptoms             text,
    diagnosis            text,
    diagnosis_source     text CHECK (diagnosis_source IN
                           ('user_guess','ai_assist','expert_review',
                            'plantix_api','plantnet_api')),
    severity             text CHECK (severity IN
                           ('monitoring','low','moderate','high','critical')),
    treatment_recommended text,
    treatment_applied    text,
    resolved_at          timestamptz   -- null = ongoing
);

-- =====================================================================
-- 8. Phenology & Observations
-- =====================================================================

CREATE TABLE phenology_observations ( -- observed plant life-cycle events
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    site_plant_id uuid REFERENCES site_plants(id),
    species_id    uuid REFERENCES species(id),  -- for region-level records
    event_type    text CHECK (event_type IN
                    ('leaf_out','first_bloom','peak_bloom','end_bloom',
                     'fruiting','seed_set','dormant','cutback')),
    observed_date date,
    observer_id   uuid REFERENCES users(id),
    notes         text
);

CREATE TABLE site_observations (      -- iNat-style biodiversity sightings
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id           uuid NOT NULL REFERENCES sites(id),
    observer_id       uuid REFERENCES users(id),
    observed_at       timestamptz,
    taxon_name        text,           -- as identified
    species_id        uuid REFERENCES species(id),         -- if matched to DB
    wildlife_taxon_id uuid REFERENCES wildlife_taxa(id),   -- if animal/insect
    location          geometry(Point, 4326),
    quality           text CHECK (quality IN
                        ('needs_id','research_grade','casual')),
    inat_obs_id       bigint,         -- if imported from iNaturalist
    notes             text
);

-- =====================================================================
-- 9. iNaturalist Integration
-- =====================================================================

CREATE TABLE inat_sync_configs (
    id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id        uuid NOT NULL REFERENCES users(id),
    inat_username  text,
    sync_radius_km numeric,
    center_lat     numeric,
    center_lng     numeric,
    last_synced_at timestamptz,
    enabled        boolean NOT NULL DEFAULT true
);

-- =====================================================================
-- 10. Media
-- =====================================================================

CREATE TABLE media (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_type  text NOT NULL CHECK (owner_type IN
                  ('site','site_plant','site_observation',
                   'diagnostic_report','project','maintenance_log')),
    owner_id    uuid NOT NULL,        -- polymorphic; resolve against owner_type
    storage_url text NOT NULL,
    media_type  text CHECK (media_type IN ('photo','video','document','plan_pdf')),
    caption     text,
    taken_at    timestamptz,
    uploaded_by uuid REFERENCES users(id),
    created_at  timestamptz NOT NULL DEFAULT now()
);
