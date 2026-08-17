# Quality Assurance Summary

## SQL Data Validation

The BankingDW warehouse was validated for:

- Table row counts
- Null values
- Referential integrity
- Customer/account consistency
- Transaction amount validity
- Loan balance validity
- Loan-status values
- Non-performing loan flags
- Origination-date integrity
- Maturity-date integrity

## Validated Warehouse Volumes

| Dataset | Rows |
|---|---:|
| Branches | 100 |
| Customers | 50,000 |
| Accounts | 75,000 |
| Transactions | 1,000,000 |
| Loans | 30,000 |
| Date Dimension | 16,802 |

Date dimension coverage:

**2020-01-01 through 2065-12-31**

## Power BI QA

The report was tested for:

- KPI accuracy
- Slicer interactions
- Cross-page State synchronization
- Drill-through
- Report tooltips
- Bookmarks
- Navigation
- Conditional formatting
- Mobile layouts
- Full model refresh

## Performance Testing

Power BI Performance Analyzer was used on key report pages.

Credit Risk visuals generally completed in approximately 167–261 ms.

The heaviest Executive Summary visuals remained below one second during
testing, with the slowest observed visual at approximately 699 ms.

State-filter interaction testing remained responsive with no visuals
taking multiple seconds.