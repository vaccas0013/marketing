select
  user_id
  , count(user_id) as pagebiews
from
  `practice-sql-373212.intro_sql.web_log`
where
  user_id is not null
  AND
  media = 'email'
GROUP BY
  1
HAVING
  pagebiews >= 10