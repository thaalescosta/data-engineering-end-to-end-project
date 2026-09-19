-- Clean the customer dimension so user data is consistent and joinable across tables.
-- The main logic here is ID normalization, lowercasing email, and numeric conversions for age and household size.
select
    -- Cast the user id to a numeric customer key and discard invalid records.
    user_id::number as customer_id,
    -- Keep the customer name in its original form for reporting and identification.
    name as customer_name,
    -- Standardize email addresses to lowercase to avoid duplicate identities caused by casing differences.
    lower(email) as email,
    -- Convert age to a numeric type so it can be used in age-based aggregations safely.
    try_to_number(age) as age,
    -- Keep gender, marital status, occupation, and education as stable categorical fields.
    gender,
    marital_status,
    occupation,
    -- Preserve the income bucket label as provided by the source.
    monthly_income as income_band,
    education,
    -- Convert family size to a numeric field for household-count analysis.
    try_to_number(family_size) as family_size
from {{ source('raw', 'users') }}
where try_to_number(user_id) is not null