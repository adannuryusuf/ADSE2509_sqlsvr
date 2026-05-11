/* Session 05 covers creating and managing database in SQL Server. */

-- Create the Customer database
create database [Adan_adse_2509_custdb]
on Primary -- File group where the customer database will be created
( Name = 'Adan_adse_2509_custdb',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQL_SVR2025\MSSQL\DATA\Adan_adse_2509_custdb.mdf') -- Location of the master datafile
Log on
( Name = 'Customer_DB_ADSE2509_Log',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQL_SVR2025\MSSQL\DATA\Adan_adse_2509_custdb_Log.ldf') -- Location of the database log file
Collate SQL_latin1_General_CP1_CI_AS;

-- Change the name of the Customer_DB to Cust_DB
alter database Adan_adse_2509_custdb
modify name = [Adan_adse_2509_custdb];

-- Switch to the Customer database
use Adan_adse_2509_custdb;

-- Drop (Permanently Delete!) NB: take a full back-up to prevent accidental data loss
drop database Adan_adse_2509_custdb;  -- Drop operation cannot be undone!