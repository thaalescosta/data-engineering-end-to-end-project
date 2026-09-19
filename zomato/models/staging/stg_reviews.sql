-- Join raw review data to the cleaned restaurant dimension and standardize review-level fields.
-- This model keeps only meaningful review text and adds the restaurant city for geographic analysis.
select
    -- Preserve the review key and the order association from the source system.
    r.review_id,
    r.order_id,
    -- Cast user id to a numeric customer key to align with the customer dimension.
    r.user_id::number as customer_id,
    -- Use a string restaurant id so it matches the raw source join key when joining to restaurants.
    r.restaurant_id::string as restaurant_id,
    -- Convert rating to a numeric value for comparisons and aggregate metrics.
    r.rating::number as rating,
    -- Normalize the review comment to a string before filtering for non-null text.
    r.comment::string as comment,
    -- Standardize the review date to a proper date type.
    r.review_date::date as review_date,
    -- Pull the cleaned city field from the restaurant staging model to enrich the review grain.
    res.city as city
from {{ source('raw', 'reviews') }} r
left join {{ ref('stg_restaurants') }} res on r.restaurant_id = res.restaurant_id
where r.comment is not null