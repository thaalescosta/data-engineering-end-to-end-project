-- Normalize the orders fact table so the business keys and order metrics are ready for downstream marts.
-- The key transformations here are field renames, city cleanup, and a boolean flag for delivered orders.
select
    -- Keep the primary order key and timestamp fields from the raw feed.
    order_id,
    order_timestamp,
    order_date,
    -- Rename the customer field to a standard dimension name used across the warehouse.
    user_id as customer_id,
    -- Standardize the restaurant key name for join consistency.
    r_id as restaurant_id,
    -- Extract the last city token from a possibly comma-delimited location string and trim whitespace.
    trim(coalesce(regexp_substr(restaurant_city, '[^,]+$'), restaurant_city)) as city,
    -- Preserve the cuisine, item count, and sales metrics as provided by the upstream order feed.
    cuisine,
    items_count,
    sales_qty,
    subtotal,
    discount,
    delivery_fee,
    gst,
    sales_amount,
    currency,
    payment_method,
    order_status,
    -- Convert the order status into a simple delivered/not-delivered boolean for filtering and KPI logic.
    (order_status = 'Delivered') as is_delivered,
    customer_rating,
    delivery_time_min
from {{ source('raw', 'orders') }}