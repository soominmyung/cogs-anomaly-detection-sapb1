# COGS Anomaly Detection and Profitability Correction (SAP Business One 9.3)

This repository provides an anonymised demonstration of how to detect missing-COGS anomalies 
in SAP Business One 9.3 and reconstruct corrected profitability metrics. 

The workflow identifies invoice lines where SAP reports unrealistically high gross profit 
(typically 99–100% margin), which occurs when warehouse-level item costs (OITW.AvgPrice) 
are missing or zero. It then attaches an expected unit cost using a landed-cost moving-average 
logic to compute more realistic profitability.

All SQL shown here is pseudocode and intended for illustrative purposes.

---

## 🔍 Problem Overview

SAP B1 computes line-level `GrssProfit` using warehouse-specific item cost. If a warehouse 
has no recorded cost for an item, SAP effectively treats the cost as zero:

Revenue > 0
COGS = 0
GrossProfit = Revenue
ProfitRatio = 100%


This results in distorted margin reporting.

This repository shows how to:

1. Rebuild invoice-level revenue and profit ratio from `OINV` and `INV1`
2. Detect near-100% margin anomalies (`ProfitRatio ≥ 0.99`)
3. Attach an expected unit cost based on a landed-cost moving-average method
4. Reconstruct corrected COGS, gross profit, and profit ratios

---

## 📁 Repository Structure

```
cogs-anomaly-detection-sapb1/
│
├─ README.md
│
├─ queries/
│ ├─ sales_fact_construction.sql
│ ├─ anomaly_detection.sql
│ ├─ expected_cost_lookup.sql
│ └─ corrected_profitability.sql
│
└─ sample_output/
└─ corrected_profitability_example.csv
```


---

## 🧱 Workflow Summary

### **1. Sales Fact Construction (OINV, INV1)**  
Compute invoice-level metrics:

- Revenue = Quantity × Price  
- SAPGrossProfit = `INV1.GrssProfit`  
- ProfitRatio = SAPGrossProfit / Revenue  

See: `queries/sales_fact_construction.sql`

---

### **2. Anomaly Detection**

Flag invoice lines where margin is unrealistically high:
```
ProfitRatio ≥ 0.99
```


These cases strongly correlate with missing warehouse item cost.

See: `queries/anomaly_detection.sql`

---

### **3. Expected Unit Cost (Landed Cost Reference)**

ExpectedUnitCost is derived using a landed-cost moving-average method.  
The full SQL logic for this calculation is available here:

👉 https://github.com/soominmyung/SAPb1-SQL-queries/blob/main/landed_cost_moving_avg.sql

This repository does **not** reimplement the view; instead, the pseudocode demonstrates how 
the landed-cost output would be joined to invoices to supply an expected cost value.

See: `queries/expected_cost_lookup.sql`

---

### **4. Corrected Profitability**

Recompute profitability using expected cost:
```
CorrectedCOGS = ExpectedUnitCost × Quantity
CorrectedGrossProfit = Revenue – CorrectedCOGS
CorrectedProfitRatio = CorrectedGrossProfit / Revenue
```

See: `queries/corrected_profitability.sql`

---

## 📊 Example Output

`sample_output/corrected_profitability_example.csv`
```
| Invoice | ItemCode | WhsCode | Revenue | CorrectedCOGS | CorrectedProfitRatio |
|---------|----------|---------|-- ------|---------------|----------------------|
| 18239   | ITM-441  | WH03    | 740     | 518           | 0.30                 |
```
---

## 📌 Notes

- Data in this repository is anonymised and simplified.  
- The SQL files are pseudocode designed to reflect the analytical workflow.  
- The landed cost SQL is maintained in a separate repo linked above.

---

## 📄 License

MIT (or another license of your choice).
