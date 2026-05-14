/*This session covers how to work with indexes in SQL server*/
--switch to the customer database
use Adan_adse_2509_custdb;

-- -------------------------------------------------
-- Demonstrate creating, modifying and deleting indexes
-- -------------------------------------------------
-- 1. Create an Employee_details table
if OBJECT_ID('Cust_Details') is null
	create table Cust_Details
	(
		AccNo nvarchar(10) not null,
		AccName nvarchar(180) not null,
		Country nvarchar(70)
	);
else
	print('The ''Cust_Details'' table already exists and will not be recreated')

--2. insert rows into the Employee_details table
insert into dbo.Cust_Details
(AccNo, AccName, Country)
values
('CN001','John Keena','Spain'),
('CN020','Smith Jones','Russia'),
('CN011','Albert Walker','Germany'),
('CN021','Rosa Stines','Italy');

select * from Cust_Details;

--3. Create anon-clustered index on the country field
 create index ixCountry on Cust_Details(Country);

--Create a clustered index on the productID  field of the product_details table
create clustered index ix_ProductID on dbo.Product_Details(ProductID);

--3. Create anon-clustered index on the city field in the Customer_Details
 create index ixCity on Customer_Details(City);

 --Add a primary key constraint to the 'CricketTeam' table
 alter table dbo.CricketTeam
 add constraint PK_TeamID primary key clustered(TeamID);

 --create a primary xml index on the 'Cricketteam' table on the teaminfo field
 Create primary xml index PXML_Teaminfo
 on dbo.cricketTeam(teaminfo)

 --create a secondary index for value()=> optimises value() method which is useful when extracting scalar values
 Create XML Index SXML_TeamInfo_Value
 on dbo.CricketTeam(Teaminfo)
 using XML Index PXML_Teaminfo
 for value;
 
 --create a secondary index for Path()=> optimises exists() method and path based lookups
 Create XML Index SXML_TeamInfo_Path
 on dbo.CricketTeam(Teaminfo)
 using XML Index PXML_Teaminfo
 for Path;

 
  --create a secondary index for Property()=> best y=used with typed xml columns(the teaminfo column is using the CricketSchemaCollection xsd)
 Create XML Index SXML_TeamInfo_Property
 on dbo.CricketTeam(Teaminfo)
 using XML Index PXML_Teaminfo
 for Property;

 --Todo 1. Create a non-clustered index on the productname field in the 'Product_Details' table.
 create index ix_ProductName on dbo.Product_Details(ProductName);

-- Modify alter the name of the ixProductName non_clustered index to 'ixProdName'
exec sp_rename N'dbo.product_details.ix_ProductName', N'ixProdName', N'Index';

--Modify the ixProdName to disable it
alter index ixProdName on dbo.product_details Disable;

--Modify the ixProdName to enable it
alter index ixProdName on dbo.product_details rebuild;

-- Remove Delete the ixProdName non-clustered index if it exists
drop index if exists ixProdName on dbo.product_details;

--Create a table with computed values then index the computed column field
if OBJECT_ID('tblCalcArea') is null
   create table tblCalcArea
   (
     length Decimal(10,2),
	 Breadth Decimal(10,2),
	 Area as length * breadth -- => computed column given by multiplying the lenght and breadth to get the shapes area

   );
else
   print('The ''tblCalcArea'' table already exists and will not be recreated')

--Add records in the table
insert into tblCalcArea(length,Breadth)
values
(34,10),
(20,20),
(33.4,4),
(12,7);

--check the records
select * from tblCalcArea;

--create an index on the area computed column
create index ixArea on tblCalcArea(Area);

--The above index will be used in a query to get shapes with an area less than 400
select *
from tblCalcArea
where Area < 400;

--Create a unique index on the 'Emp_Cellular' phone table for the personid column
create unique index ixPersonID on dbo.Emp_CellularPhone(PersonID);

--Create a filtered index for products sold for 4000 or more on the product_details
create index ixExpensiveProduct on dbo.product_details(rate)
where rate >= 4000;

-- use the above index to get products costing 4000 or more
select productID, ProductName [Product Name], Rate, coalesce(Description,'') [Description] -- Use the coalesce function to remove nulls from the resultset
from Product_Details
where rate >= 4000;


-- -------------------------------------------------
-- Extra, not in syllabus: Demonstrate working with cursors
-- -------------------------------------------------
--1. Create an Employee's Table
Create Table Employee
(
	EmpID int not null primary key,
	EmpName nvarchar(100) not null,
	Salary int not null,
	Address nvarchar(200) not null
);
 
--2. Insert employee records
Insert into dbo.Employee
values
(1,'Derek', 12000, 'Houston'),
(2,'David', 25000, 'Texas'),
(3,'Alan', 22000, 'New York'),
(4,'Matthew', 22000, 'Las Vegas'),
(5,'Joseph', 28000, 'Chicago');
 
--3. Confirm entry of records into the Employee's Table
Select * from Employee;
 
--4. Declare a cursor on the Employee's Table
set nocount on
declare @id int, @name nvarchar(100), @salary int
--A cursor is declared by defining sql statements that return a resultset
declare curEmp Cursor
static for 
Select EmpID, EmpName, Salary from employee
--A cursor is opened and populated by executing the statement(s) 
--defined in the cursor
open curEmp
--Execute the statements below if the emp cursor contains rows
if @@CURSOR_ROWS > 0
	begin
		--Rows are fetched from the cursor one by one or in a block
		--for data manipulation
		Fetch next from curEmp into @id, @name, @salary
		while @@FETCH_STATUS = 0
		begin
			print 'ID: ' + convert(nvarchar(20),@id) + char(13) +
			'Name: ' + @name + char(13) +
			'Salary: ' + convert(nvarchar(20),@salary) + char(13)--> used for line break
			Fetch next from curEmp into @id, @name, @salary
		End
	End
--Close the cursor explicitly
Close curEmp
--Delete the cursor definition and release all the system resources associated
--with the cursor
deallocate curEmp
set nocount off