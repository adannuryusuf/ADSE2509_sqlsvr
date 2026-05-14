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
