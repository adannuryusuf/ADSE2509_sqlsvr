/* Session 16 covers the enhancements introduced in SQL Server 2019. */

-- Switch to the customer database
use Cust_db_adse2509;

-- Enable ANSI warning to catch data truncation
SET ANSI_WARNINGS on;

-- Try to create the colours table when it doesn't exist
IF OBJECT_ID('dbo.tbl_Colour','U') is not null
	drop table dbo.tbl_Colour;
Create table dbo.tbl_Colour
(
	ColourID int identity not null,
	ColourName nvarchar(3) not null
);

-- Attempt to insert colour values with valid (3 or less char.) and invalid (more than 3 char.), which will throw an error instead of truncating
Insert into dbo.tbl_Colour
values
('Red'), -- will work
('Blue'), -- will cause an error
('Green'); -- will cause an error

-- Remedy for the above
-- 1. Declare a temporary table variable to simulate source data
Declare @Colours table(ColourName nvarchar(100));

-- 2. Insert the colours into the above temp. table
insert into @Colours
values ('Red'), ('Blue'), ('Green'); 

-- 3. Insert only those values/rows that won't be truncated
Insert into tbl_Colour(ColourName)
select colourname from @Colours
where LEN(colourname) <= 3;

-- 4. Notify the user about the rejected values
select colourname as 'Truncated Values'
from @Colours
where LEN(colourname) > 3;
