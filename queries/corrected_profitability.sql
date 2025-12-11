SELECT
    sf.*,
    (sf.ExpectedUnitCost * sf.Quantity) AS CorrectedCOGS,
    (sf.Revenue - (sf.ExpectedUnitCost * sf.Quantity)) AS CorrectedGrossProfit,
    ((sf.Revenue - (sf.ExpectedUnitCost * sf.Quantity)) / sf.Revenue) AS CorrectedProfitRatio
FROM expected_cost_join sf;
