select
  CASE
    WHEN cost between 0 and 299 THEN '0円以上300円未満'
    WHEN cost between 300 and 599 THEN '300円以上600円未満'
    WHEN cost between 600 and 899 THEN '600円以上900円未満'
    WHEN cost between 900 and 1199 THEN '900円以上1199円未満'
    else null
  END as cost_range,
  count(distinct product_id) as items
from
  `practice-sql-373212.intro_sql.products`
GROUP BY
  1
ORDER BY
  1