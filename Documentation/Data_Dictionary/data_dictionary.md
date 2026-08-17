# BankingDW Data Dictionary

The BankingDW warehouse contains six dimension tables and two primary
fact tables.

## Dimension Tables

- DimBranch
- DimCustomer
- DimAccount
- DimLoanType
- DimCreditScoreTier
- DimDate

## Fact Tables

### FactTransactions

Stores individual banking transaction activity.

**Volume:** 1,000,000 rows

Primary analytical areas include:

- Transaction volume
- Transaction value
- Revenue
- Processing time
- Transaction status
- Channel performance
- Customer activity
- Branch performance

### FactLoans

Stores banking loan portfolio and credit-risk information.

**Volume:** 30,000 rows

Primary analytical areas include:

- Loan amount
- Outstanding balance
- Interest rate
- Loan status
- Days past due
- Non-performing loans
- Credit-score tiers
- Loan type
- Origination and maturity dates