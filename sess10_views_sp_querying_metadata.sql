/* This session covers working with views, stored procedures and querying database metadata. */
 
  --Switch to the customer database
 use Adan_adse_2509_custdb;

 --Demonstrate creating, modifying and deleting views

 --Create a view to display the details from the Production.Product table in the AD2025 DB
 -- Note: Fixed alias for [name] to match the SELECT in the next step
 Create view vwProductInfo as
 Select ProductID [Product ID], ProductNumber [Product Number], [name] [Product Name],
 SafetyStockLevel as [Safety Stock Level]
 FROM AdventureWorks2022.Production.Product;
 GO

 -- Display the records returned by the Product view
 -- Note: Removed redundant FROM clause and fixed column reference
 Select * 
 from vwProductInfo
 where [Product Name] like '%Lock%';

 --Create a view using a join to get data from multiple tables
 --Create a view to display the personal details of employees using data from the HR.Employee table and Person.Person table in AD2025
 Create view vwPersonalDetails as
 Select P.Title, P.FirstName [First Name], P.MiddleName [Middle Name], P.LastName [Last Name],
 E.JobTitle [Job Title], Year(GetDate()) - Year(E.BirthDate) as [Employee Age], e.Gender
 From AdventureWorks2022.Person.Person P -- Person table alias
 join AdventureWorks2022.HumanResources.Employee E -- Fixed: Added missing dot and ON clause
 on P.BusinessEntityID = E.BusinessEntityID;
 GO

 -- Display all the employees personal details from the PersonalDetails view
 Select * from vwPersonalDetails;

 --Recreate the above view but replace all null values in the title and middlename columns with an empty string using coalesce function.
 Create view vwEmpDetails as
 Select Coalesce(P.Title, '') as [Title], P.FirstName [First Name], Coalesce(P.MiddleName, '') [Middle Name], P.LastName [Last Name],
 E.JobTitle [Job Title], Year(GetDate()) - Year(E.BirthDate) as [Employee Age], e.Gender
 From AdventureWorks2025.Person.Person P -- Person table alias
 join AdventureWorks2025.HumanResources.Employee E -- Fixed: Added missing dot
 on P.BusinessEntityID = E.BusinessEntityID;
 GO

 --Display all the employee personal details from the EmpDetails view
 -- Note: Fixed view name to match creation
 Select * from vwEmpDetails;

 use Adan_adse_2509_custdb;
 -- create tables to ;be used as the base tables for the employeee detsails view 
 create table Employee_Personal_Deteails
 (
     EmpID int not null primary key,
	 FirstName nvarchar(30) not null,
	 LastName nvarchar (30),
	 Address nvarchar(30)
	 );
	 create table Employee_Salary_Details
	 (    
	   EmpID int not null primary key,
	   Designation nvarchar(30) not null,
	   Salary int not null,
	   Foreign Key(EmpID) references Employee_Personal_Deteails
	);
insert into dbo.Employee_Personal_Deteails
values
(1,'Jack','Wilson','24, Park Ave.'),
(2,'Susan','Andrews','12, Hill Road.'),
(3,'Jack','Wilson','24, Park Ave.');

insert into dbo.Employee_Salary_Details
values
(1,'Accountant', 8000),
(2,'Reviewer', 12000),
(3,'Admin', 12500);

select * from dbo.Employee_Personal_Deteails
select * from dbo.Employee_Salary_Details

 -- Create a view to display the employee's personal and salary details
 create view vwEmpDetails as
 Select PD.EmpID [Employee ID], PD.FirstName, PD.LastName, SD.Designation, SD.Salary
 from Employee_Personal_Details PD
 join Employee_Salary_Details SD
 on PD.EmpID = SD.EmpID;

 -- Display the data returned by the employee details view
 Select * from vwEmpDetails;

 -- Try to insert the details of a new employee using the Employee details view
 Insert into vwEmpDetails
 values
 (2, 'Jack', 'Wilson', 'Software Developer', 160000); -- will not work as it gets its data from
   multiple base tables.

create view vwEmp_Details as 
select EmpID, FirstName, LastName, Address
from  Employee_Personal_Deteails;

select * from vwEmp_Details;
--Add Jack Wilson details using the Emp_Details  view
insert into vwEmp_Details
values 
(4,'Jack','Wilson','New York');

--create a product deatails table and its corresponding view tha twill be used to modify records int the table
create table Product_Details -- tbl in some companies
(
ProductID int not null,
ProductName nvarchar (35) not null,
Rate money not null
);

insert into Product_Details
values 
(5,'DVD Writer', 2250),
(6,'DVD Writer', 1250),
(7,'DVD Writer', 1250);


select * from  Product_Details;

Create view vwProduct_Details as 
select ProductID, ProductName, Rate
from Product_Details;

select * from vwProduct_Details;

--update the price the priv eof dvd writers to 3k
update vwProduct_Details
set Rate = 3000
where ProductName like 'DVD Writer';

--modify the product details tagleto add a description column 
alter table dbo.Product_Details
add [Description] nvarchar(MAX);

-- Add/insert more records into the product_details table
Insert into Product_Details
values
(1, 'Hard Disk Drive', 3750,'Internal 120 GB'),
(7,	'Portable Disk Drive',5580,'Internal 500 GB'),
(8,	'Hard Disk Drive',5580,'Internal 500 GB'),
(9,	'Hard Disk Drive',3750,'Internal 120 GB'),
(10,'Portable Disk Drive',3750,'Internal 500 GB');

alter view vwProduct_Details
select ProductID, ProductName, Rate, [Description]
from Product_Details;

update vwProduct_Details
set [Description] .write(N'Ex',0,2)
where ProductName like 'Portable Disk Drive';

create table Customer_Details
(
  CustID nvarchar(7) not null primary key,
  AccNo int identity(1,1) not null,
  AccName nvarchar (20)not null,
  [Date of Birth] date not null,
  City nvarchar (25) not null
);

insert into dbo.Customer_Details
(CustID,AccName,[Date of Birth],City)
Values
('C0001','Jane','1980-02-02','Topeka'),
('C0002','Haris','1978-12-15','Lansing'),
('C0003','Pitts','1985-11-10','Columbus'),
('C0004','Monaliza','1980-11-12','Topeka');

select * from dbo.Customer_Details;

create view vwCustDetails as
select CustID, AccNo [Account Number], AccName [Account Name],[Date of Birth],City
from Customer_Details

select * from vwCustDetails;

delete from vwCustDetails
where CustID like 'C0004';

create view vw2Delete as 
Select ProductID [Product ID], ProductNumber [Product Number], [name] [Product Name],
 SafetyStockLevel as [Safety Stock Level]
 FROM AdventureWorks2022.Production.Product;

 select * from vw2Delete;

 -- remove/delete the vw2Delete view
 drop view vw2Delete;

 -- view the statements that were used to create the customer details view
 execute sp_helptext vwCustDetails;

 --create a view to display the average price of produvts using the inbuilt AVG()
 create view vwAvgPrice as
 select  ProductName, AVG(Rate)as [Average Price]
 from dbo.Product_Details
 group by ProductName;

 select * from vwAvgPrice;

 create view vwProductInformation as
 select ProductID as [Product ID], productNumber [Product Number], [name] [Product Name], safetystocklevel [Safety Stock Level], ReorderPoint [Reorder Point]
 from AdventureWorks2022.Production.Product
 where safetyStocklevel <= 1000
 with check option;

 select * from vwProductInformation;

 --rey to make changes to the vwProductInformation
 update vwProductInformation
 set [Safety Stock Level] = 2500
 where [Product ID] = 321;

 if OBJECT_ID('Customer')is null
    create table Customer
	(
	  CustID int,
	  CustName nvarchar(50),
	  Address nvarchar(60)
	);
	else
	    print('The ''Customer'' Table already exists and will not be recreated!');
create view vwCustomer as
select *from Customer;

select * from vwCustomer;

alter table Customer
add Age tinyint;

--use the sp_refreshview stored procedure to refresh the custoemr view to include the 'age' column
exec sp_refreshview 'vwCustomer';

exec xp_fileexists 'c:\classfile.txt';

exec xp_fileexists 'C:\Users\a.yusuf\Documents\School Work\adse2509_sqlsvr\ADSE2509_SQLSVR2022.sln';

create procedure uspCustTerritory as
select top 10 C.CustomerID [Customer ID], C.TerritoryID [Territory ID], T.Name as [Territory Name]
from AdventureWorks2022.Sales.Customer C
join AdventureWorks2022.Sales.SalesTerritory T
on C.TerritoryID = T.TerritoryID;

exec uspCustTerritory;

--view the definition of the statements used to create the customer territory view
 execute sp_helptext uspCustTerritory;

 --create a custom user defined stored procedure that accepts input parameters
 create proc uspGetSales
 @territory nvarchar(40) --input variable to store the name of the region
 as 
 select BusinessEntityID, ST.SalesYTD[Sales Year to Date],ST.SalesLastYear as [Sales Last Year]
 from AdventureWorks2022.Sales.SalesPerson SP
 join AdventureWorks2022.Sales.SalesTerritory ST
 on SP.TerritoryID = ST.TerritoryID
 where ST.Name like @territory;

 --get the sales details for the northwest and northeast regions using the get 
 --sales custom stored procedure
 exec uspGetSales 'NorthWest';
  exec uspGetSales 'NorthEast';

   --create a custom user defined stored procedure that accepts both input and output parameters
 create proc uspGetToTotalSales
 @salesTerritory nvarchar(40), --input variable to store the name of the region
 @sum int output --return variable to hold   the total sals for the spacified region
 as 
 select @sum = SUM(ST.SalesYTD)
 from AdventureWorks2022.Sales.SalesPerson SP
 join AdventureWorks2022.Sales.SalesTerritory ST
 on SP.TerritoryID = ST.TerritoryID
 where ST.Name like @salesTerritory;

 -- get and display the total sales for the 'northwest' and 'northeasst' regions
 Declare @northWestSales money --variable to hold the northwest total sales
 exec uspGetToTotalSales 'northWest', @sum = @northWestSales output;
 --Display the sales for the northwesst region
 print 'The year-to-date total for the ''NorthWest'' region is Kes.' + convert(nvarchar(100),@northWestSales);

 --get and display the total sales for the 'northeast' region
 Declare @northEastSales money --variable to hold the northeast total sales
 exec uspGetToTotalSales 'northEastSales', @sum = @northEastSales output;
 --Display the sales for the northEast region
 print 'The year-to-date total for the ''NorthEast'' region is Kes.' + convert(nvarchar(100),@northEastSales);
