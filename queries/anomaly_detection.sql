-- Flag near-100% profit ratio lines (likely missing COGS)
SELECT *
FROM sales_fact
WHERE Revenue > 0
  AND ProfitRatio >= 0.99;
