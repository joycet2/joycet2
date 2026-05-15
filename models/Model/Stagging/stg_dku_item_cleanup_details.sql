{{ config(materialized='view') }}

SELECT
    TRIM(UPPER("item_full"))          AS item_full_key,

    "item_full"                       AS item_full,
    "item_description"                AS item_description,
    "inv_allocated"                   AS inv_allocated,
    "inv_in_transit"                  AS inv_in_transit,
    "inv_on_order"                    AS inv_on_order,
    "inv_on_hand"                     AS inv_on_hand,
    "total_inventory"                 AS total_inventory,
    "is_active"                       AS is_active,
    "ready_to_obsolete"               AS ready_to_obsolete,
    "ENTITY"                          AS entity,
    "item_group"                      AS item_group,
    "global_unit"                     AS global_unit

FROM {{ source('gsc_integration', 'DKU_ITEM_CLEANUP_DETAILS') }}