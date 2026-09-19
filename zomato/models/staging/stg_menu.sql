-- Standardize the menu fact table by cleaning restaurant identifiers and validating price values.
-- This keeps only menu rows that can be joined to a valid restaurant and priced correctly.
select
    -- Keep the source menu key as-is for traceability.
    menu_id,
    -- Convert the restaurant identifier to a numeric key for consistent joins.
    try_to_number(r_id) as restaurant_id,
    -- Preserve the food reference used to connect menu items to the food dimension.
    f_id,
    -- Keep the cuisine label as provided by the source.
    cuisine,
    -- Cast the menu price to a decimal with 2 places so downstream analytics treat it as money.
    try_to_decimal(price, 10, 2) as price
from {{ source('raw', 'menu') }}
where try_to_number(r_id) is not null
  and try_to_decimal(price, 10, 2) > 0
