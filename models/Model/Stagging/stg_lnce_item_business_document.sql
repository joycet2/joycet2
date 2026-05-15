{{ config(materialized='view') }}

SELECT
    TRIM(UPPER(EXTERNAL_ITEM_CODE))   AS external_item_code_key,
    TRIM(UPPER(ITEM_CODE))            AS item_code_key,

    EXTERNAL_ITEM_CODE,
    ITEM_CODE

FROM {{ source('lnce_integration', 'STG_LNCE__TXN_ITEM_BUSINESS_DOCUMENT') }}