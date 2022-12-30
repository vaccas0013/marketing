select
  order_id,
  quantity,
  quantity + 1 as new_qty,
  revenue,
  (revenue / quantity) * (quantity + 1) as new_revenue
from
  `practice-sql-373212.intro_sql.sales`
ORDER BY
  new_revenue desc
limit
  3