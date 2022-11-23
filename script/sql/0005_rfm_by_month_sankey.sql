with tbl_rfm as (
  select
      user_id
    , date_trunc(created_at, month) as month
    , date_diff(current_date('Asia/Tokyo'), cast(max(created_at) as date), day) as recency
    , count(user_id) as frequency
    , sum(sale_price) as monetary
  from
    `bigquery-public-data.thelook_ecommerce.order_items`
  group by
    1, 2
)

, tbl_rfm_rank as (
  select
      *
    , r_rank + f_rank + m_rank as rfm_rank
    , case
        when (r_rank + f_rank + m_rank) <= 5 then 'C'
        when (r_rank + f_rank + m_rank) <= 7 then 'B'
        else 'A'
      end as segment
    , max(month) over() as current_month
  from (
    select
        *
      , case
          when recency <= percentile_cont(recency, 0.33) over(partition by (month)) then 3
          when recency <= percentile_cont(recency, 0.66) over(partition by (month)) then 2
          else 1
        end r_rank
      , case
          when frequency <= percentile_cont(frequency, 0.33) over(partition by (month)) then 1
          when frequency <= percentile_cont(frequency, 0.66) over(partition by (month)) then 2
          else 3
        end f_rank
      , case
          when monetary <= percentile_cont(monetary, 0.33) over(partition by (month)) then 1
          when monetary <= percentile_cont(monetary, 0.66) over(partition by (month)) then 2
          else 3
        end m_rank
    from
      tbl_rfm
  )
)

, tmp as (
  select
    *
    --   user_id
    -- , month
    -- , rfm_rank
    , concat(extract(year from month), '_', extract(month from month), '_', segment) as show_segment
    -- , segment
    , dense_rank() over(order by month) as sort_value
  from
    tbl_rfm_rank
  where
    date_sub(cast(current_month as date), interval 5 month) <= cast(month as date)
  order by
    user_id, month
)

, tmp_2 as (
  select
      *
    , concat(sort_value, '_', show_segment) as show_segment_2
  from
    tmp
  order by
    user_id, month
)

, tmp_3 as (
  select
      *
    , lead(show_segment_2) over(partition by user_id order by month) as next_show_segment
  from
    tmp_2
)

select
  *
from
  tmp_3
where
  next_show_segment is not null

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