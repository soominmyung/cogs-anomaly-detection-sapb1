-- Attach ExpectedUnitCost from landed-cost view (https://github.com/soominmyung/SAPb1-SQL-queries/blob/main/landed_cost_moving_avg.sql)
SELECT
    s.*,
    lc.ExpectedUnitCost
FROM sales_fact s
LEFT JOIN LandedCostView lc
    ON lc.ItemCode = s.ItemCode
   AND lc.WhsCode  = s.WhsCode;
