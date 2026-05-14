SELECT
    a.*,
    b."item_full" AS matched_equivalent_item,
    b."item_description",
    b."extended_description",
    b."item_group",
    b."item_signal",
    b."global_unit",
    b."inv_on_hand",
    b."inv_in_transit",
    b."inv_on_order",
    b."total_inventory",
    b."is_active",
    b."ready_to_obsolete",
    b."ENTITY",
    c."item_description" AS New_Item_description
FROM KES_PRD_LNCE_DB.INTEGRATION.STG_LNCE__TXN_ITEM_BUSINESS_DOCUMENT a
LEFT JOIN KES_WRKSPC_GSC_DB.INTEGRATION.DKU_ITEM_CLEANUP_DETAILS b
    ON TRIM(a.EXTERNAL_ITEM_CODE) = TRIM(b."item_full")
LEFT JOIN KES_WRKSPC_GSC_DB.INTEGRATION.DKU_ITEM_CLEANUP_DETAILS c
    ON TRIM(a.ITEM_CODE) = TRIM(c."item_full")
