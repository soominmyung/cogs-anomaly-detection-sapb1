-- Build invoice-level sales fact from SAP B1 tables (OINV, INV1)

SELECT
    l.DocEntry,
    l.LineNum,
    l.ItemCode,
    l.WhsCode,
    l.Quantity,
    l.Price,
    (l.Quantity * l.Price) AS Revenue,
    l.GrssProfit AS SAPGrossProfit,
    (l.GrssProfit / NULLIF(l.Quantity * l.Price, 0)) AS ProfitRatio
FROM INV1 l
JOIN OINV h ON h.DocEntry = l.DocEntry;