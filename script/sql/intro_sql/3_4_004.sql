select
  *
from
  `practice-sql-373212.intro_sql.customers`
WHERE
  (
    is_premium is true
    or extract(
      year
      FROM
        birthday
    ) = 1970
  )
  and name like '%美'
  and gender = 2
order by
  birthday
limit
  3