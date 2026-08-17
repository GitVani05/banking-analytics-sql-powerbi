# Banking Analytics Architecture

## End-to-End Data Flow

Python Data Generation
        ↓
CSV Staging Files
        ↓
SQL Server - BankingDW
        ↓
Dimension & Fact Tables
        ↓
SQL Views / Stored Procedures / Functions
        ↓
Power BI Semantic Model
        ↓
DAX Measures
        ↓
Interactive Banking Analytics Dashboard

## Data Warehouse

### Dimensions
- DimBranch
- DimCustomer
- DimAccount
- DimLoanType
- DimCreditScoreTier
- DimDate

### Fact Tables
- FactTransactions
- FactLoans

## SQL Reporting Layer

The SQL reporting layer includes:

- Reporting views
- Stored procedures
- Reusable SQL functions
- ETL execution logging
- Nonclustered indexes
- Data-quality validation

## Power BI Layer

The Power BI report provides:

- Executive Summary
- Transaction Performance
- Customer Analytics
- Branch Performance
- Portfolio Overview
- Loan Portfolio Analysis
- Credit Risk
- Loan Details drill-through

Additional report functionality includes synchronized slicers, report
tooltips, bookmarks, navigation controls, conditional formatting,
mobile layouts, and performance testing.