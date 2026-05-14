{{ config(
    materialized='table'
) }}

WITH base AS (

    SELECT
        TRIM(a.ITEM_CODE)              AS original_item,
        TRIM(a.EXTERNAL_ITEM_CODE)     AS external_item_code,

        TRIM(b.item_full)              AS equivalent_item,
        b.item_description             AS equivalent_description,

        b.total_inventory,
        b.inv_on_hand,
        b.inv_in_transit,
        b.inv_on_order,

        b.is_active,
        b.ready_to_obsolete

    FROM KES_PRD_LNCE_DB.INTEGRATION.STG_LNCE__TXN_ITEM_BUSINESS_DOCUMENT a

    LEFT JOIN KES_WRKSPC_GSC_DB.INTEGRATION.DKU_ITEM_CLEANUP_DETAILS b
        ON TRIM(a.EXTERNAL_ITEM_CODE) = TRIM(b.item_full)

)

SELECT
    original_item,
    equivalent_item,
    equivalent_description,

    total_inventory,
    inv_on_hand,
    inv_in_transit,
    inv_on_order,

    is_active,
    ready_to_obsolete,

    --  Inventory 分类
    CASE 
        WHEN total_inventory > 0 THEN 'Has Inventory'
        WHEN total_inventory = 0 THEN 'No Inventory'
        ELSE 'Unknown'
    END AS inventory_status,

    --  Active 状态
    CASE 
        WHEN is_active = TRUE THEN 'Active'
        ELSE 'Inactive'
    END AS active_status,

    --  Obsolete 判断
    CASE 
        WHEN ready_to_obsolete = TRUE THEN 'Ready to Obsolete'
        ELSE 'Keep'
    END AS obsolete_status

FROM base
``