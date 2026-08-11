-- Real-time provider view using Snowflake dynamic table materialization
-- Co-authored with CoCo
{{ config(
    materialized='dynamic_table',
    target_lag='1 minute',
    snowflake_warehouse='OPENFLOW_MERGE_WH'
) }}

/*
  Dynamic table — automatically refreshes within 1 minute of source changes.
  No dbt run needed; Snowflake handles incremental refresh internally.

  Use case: near real-time dashboards, APIs, or downstream queries
  that need fresh data without waiting for the dbt task to fire.
*/

SELECT
    p.PRPR_ID,
    p.PRPR_NPI,
    p.PRPR_NAME,
    CASE p.PRPR_ENTITY
        WHEN 'I' THEN 'Individual (Type 1)'
        WHEN 'O' THEN 'Organization (Type 2)'
        ELSE 'Unknown'
    END                                                AS PROVIDER_TYPE,
    p.PRPR_ENTITY,
    CASE p.PRPR_STS
        WHEN 'AC' THEN 'Active'
        WHEN 'IN' THEN 'Inactive'
        WHEN 'SU' THEN 'Suspended'
        ELSE p.PRPR_STS
    END                                                AS STATUS_DESC,
    p.PRPR_STS,
    p.PRPR_MCTR_TYPE,
    p.PRPR_TAXONOMY_CD,
    p.PRPR_TERM_DT                                     AS TERM_DT,
    addr.PRAD_ADDR1                                    AS PRACTICE_ADDR1,
    addr.PRAD_CITY                                     AS PRACTICE_CITY,
    addr.PRAD_ST                                       AS PRACTICE_STATE,
    addr.PRAD_ZIP                                      AS PRACTICE_ZIP,
    p._SNOWFLAKE_UPDATED_AT                            AS BRONZE_UPDATED_AT,
    p._SNOWFLAKE_DELETED                               AS IS_DELETED
FROM {{ source('raw', 'CMC_PRPR_PROV') }} p
LEFT JOIN {{ source('raw', 'CMC_PRAD_ADDRESS') }} addr
    ON p.PRPR_ID = addr.PRPR_ID
    AND addr.PRAD_TYPE = 'PR'
WHERE p.PRPR_NPI REGEXP '^[0-9]{10}$'