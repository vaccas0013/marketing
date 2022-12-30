select
  cid,
  count(cid) as number_of_visits
from
  `practice-sql-373212.intro_sql.web_log`
GROUP BY
  1
ORDER BY
  2 DESC
LIMIT
  3