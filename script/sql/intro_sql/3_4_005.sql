select
  *
from
  `practice-sql-373212.intro_sql.customers`
WHERE
  prefecture not in ('東京', '千葉', '埼玉', '神奈川')
  and is_premium is true
order by
  birthday desc
limit
  3