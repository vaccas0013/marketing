select
  prefecture,
  count(distinct user_id) as cnt_premium_user
from
  `practice-sql-373212.intro_sql.customers`
where
  is_premium is true
GROUP BY
  1
ORDER BY
  2 DESC
LIMIT
  1