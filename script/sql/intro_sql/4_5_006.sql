select
  birthday,
  count(distinct user_id) as cnt_user
from
  `practice-sql-373212.intro_sql.customers`
where
  birthday is not null
GROUP BY
  1
HAVING
  cnt_user >= 2