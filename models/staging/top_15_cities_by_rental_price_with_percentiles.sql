{{ config(materialized='view') }}

with rent_stats as (
    select
        city,
        count(id) as total_listings,
        approx_quantiles(price, 100)[offset(50)] as median_price,
        approx_quantiles(price, 100)[offset(75)] as percentile_75_price,
        approx_quantiles(price, 100)[offset(95)] as percentile_95_price
    from {{ source('polish_flats', 'apartments_rent_aggregated') }}
    group by city
)

select *
from rent_stats
order by total_listings desc
    limit 15
