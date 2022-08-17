WITH val_bin AS(
SELECT
  --階級幅を入力(ここでは階級幅=5)
  CONCAT(bin_min, '~', bin_min + 1000 - 1) AS bin,
  cnt
FROM(
  SELECT
    --階級幅を入力
    FLOOR(monetary / 1000) * 1000 AS bin_min,
    COUNT(monetary) AS cnt
  FROM
    marketing-359704.purchase_history.online_ratail_rfm
  GROUP BY
    bin_min
 ) 
)

, array_bin AS(
SELECT 
  bin_min,
  --階級幅を入力
  CONCAT(bin_min, '~', bin_min + 1000 - 1) AS bin,
 FROM 
  --x軸の最小値,最大値,ヒストグラムの階級幅を入力
   UNNEST(GENERATE_ARRAY(0, 280206, 1000)) AS bin_min
)

SELECT 
  ROW_NUMBER() OVER(ORDER BY bin_min ASC) num,
  bin,
  IF(cnt IS NULL, 0, cnt) AS cnt
FROM 
  array_bin
LEFT JOIN
  val_bin
USING(bin)
ORDER BY
  bin_min