{{ config(materialized='view') }}

SELECT
    TRIM(UPPER(PART_NUMBER))          AS part_number_key,
    TRIM(UPPER(NEW_PART_NUMBER))      AS new_part_number_key,

    PART_NUMBER,
    PART_DESCRIPTION,
    NEW_PART_NUMBER,
    NEW_PART_DESCRIPTION,
    EXTENDED_DESCRIPTION

FROM {{ source('plm_raw', 'KES_CROSS_REFERENCE_LIST') }}
