{{ config(materialized='table') }}

WITH crl AS (

    SELECT * FROM {{ ref('stg_plm_cross_reference_list') }}

),

lnce AS (

    SELECT * FROM {{ ref('stg_lnce_item_business_document') }}

),

dku_old AS (

    SELECT * FROM {{ ref('stg_dku_item_cleanup_details') }}

),

dku_new AS (

    SELECT * FROM {{ ref('stg_dku_item_cleanup_details') }}

)

SELECT
    crl.PART_NUMBER,
    crl.PART_DESCRIPTION,
    crl.NEW_PART_NUMBER,
    crl.NEW_PART_DESCRIPTION,
    crl.EXTENDED_DESCRIPTION,

    lnce.EXTERNAL_ITEM_CODE AS matched_in_equivalent,
    lnce.ITEM_CODE          AS golden_code,

    dku_old.item_full       AS matched_in_LN,
    dku_old.item_description,
    dku_old.inv_allocated,
    dku_old.inv_in_transit,
    dku_old.inv_on_order,
    dku_old.inv_on_hand,
    dku_old.total_inventory,
    dku_old.is_active,
    dku_old.ready_to_obsolete,
    dku_old.entity,
    dku_old.item_group,
    dku_old.global_unit     AS old_unit,

    dku_new.global_unit     AS new_unit,

    CASE
        WHEN lnce.EXTERNAL_ITEM_CODE IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS found_in_equivalent_flag,

    CASE
        WHEN dku_old.item_full IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS found_in_dku_flag,

    CASE
        WHEN dku_old.global_unit = dku_new.global_unit THEN FALSE
        WHEN dku_old.global_unit IS NULL OR dku_new.global_unit IS NULL THEN NULL
        ELSE TRUE
    END AS unit_mismatch_flag

FROM crl

LEFT JOIN lnce
    ON crl.part_number_key = lnce.external_item_code_key

LEFT JOIN dku_old
    ON crl.part_number_key = dku_old.item_full_key

LEFT JOIN dku_new
    ON crl.new_part_number_key = dku_new.item_full_key