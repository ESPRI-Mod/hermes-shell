-- Drop column: conso.tbl_allocation.total_hrs
ALTER TABLE conso.tbl_allocation DROP COLUMN total_hrs;

-- Create column: conso.tbl_allocation.total_hrs
ALTER TABLE conso.tbl_allocation ADD COLUMN total_hrs double precision;
