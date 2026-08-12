{{
    config(
        materialized = 'table',
        tags         = ['gold', 'demo-alert']
    )
}}

/*
   Gold model: Provider Summary
   Aggregates SILVER.PROVIDER2 by provider type and status.
   Used in the break-detect-recover demo.
*/

SELECT
    PROVIDER_TYPE,
    PRPR_STS,
    COUNT(*)                          AS provider_count,
    COUNT(DISTINCT PRPR_NPI)          AS unique_npi_count,
    SUM(ACTIVE_NETWORK_COUNT)         AS total_network_participations,
    SUM(IS_PCP_ELIGIBLE)              AS pcp_eligible_count,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS last_refreshed_at
FROM {{ ref('provider2') }}
GROUP BY PROVIDER_TYPE, PRPR_STS
