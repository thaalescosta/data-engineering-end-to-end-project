-- Standardize the order-item grain and cast monetary and quantity values to analytic-friendly types.
-- This gives downstream models consistent numeric behavior for item-level revenue and quantity analysis.
select
    -- Keep the item-level surrogate key and the parent order references.
    order_item_id,
    order_id,
    -- Align restaurant identifiers with the rest of the warehouse schema.
    r_id as restaurant_id,
    -- Keep the food reference linking each line item to the menu/food dimensions.
    f_id,
    -- Cast the item price to a fixed-precision decimal for consistent financial calculations.
    price::decimal(10, 2) as price,
    -- Convert quantity to a numeric type so repeated-item calculations behave reliably.
    quantity::number as quantity,
    -- Normalize the extended line amount to a decimal so it matches other currency fields.
    line_amount::decimal(10, 2) as line_amount
from {{ source('raw', 'order_items') }}