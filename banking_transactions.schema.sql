-- Banking Transactions
--
-- Customers, accounts, merchants and two years of posted transactions for a retail bank, with no stored balances.
--
-- Run this from the directory holding the data files:
--   duckdb -c ".read banking_transactions.schema.sql"

CREATE TABLE branches (
  branch_id INTEGER NOT NULL,
  branch_name VARCHAR NOT NULL,
  city VARCHAR NOT NULL,
  country VARCHAR NOT NULL,
  opened_on DATE NOT NULL,
  PRIMARY KEY (branch_id)
);

CREATE TABLE merchants (
  merchant_id INTEGER NOT NULL,
  merchant_name VARCHAR NOT NULL,
  category VARCHAR NOT NULL,
  country VARCHAR NOT NULL,
  PRIMARY KEY (merchant_id)
);

CREATE TABLE customers (
  customer_id INTEGER NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  email VARCHAR NOT NULL,
  city VARCHAR NOT NULL,
  country VARCHAR NOT NULL,
  home_branch_id INTEGER NOT NULL,
  joined_on DATE NOT NULL,
  risk_band VARCHAR,
  PRIMARY KEY (customer_id),
  FOREIGN KEY (home_branch_id) REFERENCES branches (branch_id)
);

CREATE TABLE accounts (
  account_id INTEGER NOT NULL,
  customer_id INTEGER NOT NULL,
  account_type VARCHAR NOT NULL,
  currency VARCHAR NOT NULL,
  opened_on DATE NOT NULL,
  closed_on DATE,
  overdraft_limit DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (account_id),
  FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE TABLE transactions (
  transaction_id INTEGER NOT NULL,
  account_id INTEGER NOT NULL,
  merchant_id INTEGER,
  posted_at TIMESTAMP NOT NULL,
  transaction_type VARCHAR NOT NULL,
  direction VARCHAR NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  channel VARCHAR NOT NULL,
  description VARCHAR NOT NULL,
  PRIMARY KEY (transaction_id),
  FOREIGN KEY (account_id) REFERENCES accounts (account_id),
  FOREIGN KEY (merchant_id) REFERENCES merchants (merchant_id)
);

COPY branches FROM 'branches.parquet' (FORMAT PARQUET);
COPY merchants FROM 'merchants.parquet' (FORMAT PARQUET);
COPY customers FROM 'customers.parquet' (FORMAT PARQUET);
COPY accounts FROM 'accounts.parquet' (FORMAT PARQUET);
COPY transactions FROM 'transactions.parquet' (FORMAT PARQUET);
