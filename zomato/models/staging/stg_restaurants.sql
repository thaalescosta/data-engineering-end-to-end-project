-- Clean the raw restaurant dimension by removing messy rating and price text and standardizing ids.
-- The source contains placeholders, currency symbols, and city strings that need normalization before use.
select
    -- Cast the raw restaurant id to a numeric business key and keep only valid rows.
    id::number as restaurant_id,
    -- Preserve the restaurant name as it is used for display and join logic.
    name as restaurant_name,
    -- Extract the final city segment from a varying comma-delimited location string and trim whitespace.
    trim(coalesce(regexp_substr(city, '[^,]+$'), city)) as city,
    -- Convert placeholder values like '--' into NULL before casting the rating to decimal.
    try_to_decimal(nullif(rating, '--'), 3, 1) as rating,
    -- Extract only the numeric portion of rating_count so values like '50+' become 50.
    try_to_number(regexp_substr(rating_count, '[0-9]+')) as rating_count,
    -- Strip currency symbols and text from cost and keep the numeric value for cost-for-two.
    try_to_number(regexp_substr(cost, '[0-9]+')) as cost_for_two,
    -- Keep the cuisine and license number as the source provides them.
    cuisine,
    lic_no as license_no
from {{ source('raw', 'restaurants') }}
where try_to_number(id) is not null