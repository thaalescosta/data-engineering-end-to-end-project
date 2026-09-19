-- Clean the raw food dimension and standardize the field names used downstream.
-- Keep only valid food records, normalize the food label, and title-case the veg status.
select
    -- Preserve the business key and rename it to a clearer staging field name.
    f_id,
    -- Keep the human-readable item name as the food name.
    item as food_name,
    -- Convert the veg flag to a consistent capitalized format such as 'Veg' or 'Non Veg'.
    initcap(veg_or_non_veg) as veg_or_non_veg
from {{ source('raw', 'food') }}
where f_id is not null
