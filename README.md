# caldemo_dw dbt project

This folder contains a scaffolded dbt project for the `caldemo_dw` workspace.

## Structure

- `dbt_project.yml` — dbt project configuration
- `packages.yml` — dbt package dependencies
- `profiles.yml` — dbt profile targets
- `models/` — dbt models
- `macros/` — dbt macros
- `analysis/` — dbt analysis scripts
- `snapshots/` — dbt snapshots
- `tests/` — dbt tests

## Next steps #Deepak Kumar
1. Update `profiles.yml` with your Snowflake connection values.
2. Add your models under `models/`.
3. Run `dbt debug` from `caldemo_dw/` to verify the project.
