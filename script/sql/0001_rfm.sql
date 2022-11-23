with tbl_rfm as (
  select
      user_id
    , date_diff(current_date('Asia/Tokyo'), cast(max(created_at) as date), day) as recency
    , count(user_id) as frequency
    , sum(sale_price) as monetary
  from
    `bigquery-public-data.thelook_ecommerce.order_items`
  group by
    1
)

, tbl_rfm_rank as (
  select
      *
    , r_rank + f_rank + m_rank as rfm_rank
  from (
    select
        *
      , case
          when recency <= percentile_cont(recency, 0.33) OVER() then 3
          when recency <= percentile_cont(recency, 0.66) OVER() then 2
          else 1
        end r_rank
      , case
          when frequency <= percentile_cont(frequency, 0.33) OVER() then 1
          when frequency <= percentile_cont(frequency, 0.66) OVER() then 2
          else 3
        end f_rank
      , case
          when monetary <= percentile_cont(monetary, 0.33) OVER() then 1
          when monetary <= percentile_cont(monetary, 0.66) OVER() then 2
          else 3
        end m_rank
    from
      tbl_rfm
  )
)

select
  *
from
  tbl_rfm_rank

-- data portal vega histgram style json
--  {
--   "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
--   "mark": {"type": "bar", "color": "tomato", "opacity": 1},
--   "encoding": {
--     "x": {
--       "bin": {"step": 1},
--       "field": "$metric0",
--       "title": "Frequency (bin=1)"
--     },
--     "y": {
--       "aggregate": "count",
--       "title": ""
--     }
--   }
--  }