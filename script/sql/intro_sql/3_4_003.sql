select
  *
from
  `practice-sql-373212.intro_sql.customers`
WHERE
  birthday is not null
  and is_premium is true
order by
  birthday desc,
  register_date
limit
  3