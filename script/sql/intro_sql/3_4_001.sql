select
  * except (revenue),
  revenue * 1.1 as revenue_with_tax
from
  `practice-sql-373212.intro_sql.sales`
ORDER BY
  order_id
limit
  3