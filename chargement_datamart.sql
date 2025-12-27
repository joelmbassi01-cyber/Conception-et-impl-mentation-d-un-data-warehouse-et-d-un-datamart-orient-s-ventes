create database DW_AdventureWorks_Priv

---------------------------------------------- CHARGEMENT DE LA TABLE DIM_CUSTOMER---------------------------------------------

insert into [DW_AdventureWorks_Priv].[dbo].[DimCustomer]  (
	CustomerKey,
	FirstName,
	LastName,
	MaritalStatus,
	Gender,
	AnnualIncome,
	TotalChildren,
	EducationLevel,
	Occupation
)
select CustomerKey,
	FirstName,
	LastName,
	MaritalStatus,
	Gender,
	AnnualIncome,
	TotalChildren,
	EducationLevel,
	Occupation
from [AdventureWorks_Priv].[dbo].[AdventureWorks_Customer_Lookup];



----------------------------------------------- CHARGEMENT DE LA TABLE DIM_PRODUCTCATEGORY----------------------------------------------------

insert into [DW_AdventureWorks_Priv].[dbo].Dim_Product_Category (
	ProductCategoryKey,
	CategoryName
)
select ProductCategoryKey,
	   CategoryName
from [AdventureWorks_Priv].[dbo].[AdventureWorks_Product_Categories_Lookup];





----------------------------------------------- CHARGEMENT DE LA TABLE DIM_PRODUCTSUBCATEGORY----------------------------------------------------

insert into [DW_AdventureWorks_Priv].[dbo].Dim_Product_SubCategory (
	ProductSubcategoryKey,
	SubcategoryName,
	ProductCategoryKey   
)
select ProductSubcategoryKey, 
	   SubcategoryName, 
	   ProductCategoryKey  
from   [AdventureWorks_Priv].[dbo].[AdventureWorks_Product_Subcategories_Lookup];
	





----------------------------------------------- CHARGEMENT DE LA TABLE DIM_PRODUCT----------------------------------------------------

insert into [DW_AdventureWorks_Priv].[dbo].Dim_Product (
	ProductKey, 
	ProductSubcategoryKey, 
	ProductSKU, 
	ProductName, 
	ModelName, 
	ProductCost, 
	ProductPrice
)
select  ProductKey, 
		ProductSubcategoryKey, 
		ProductSKU, 
		ProductName, 
		ModelName, 
		ProductCost, 
		ProductPrice
from [AdventureWorks_Priv].[dbo].[AdventureWorks_Product_Lookup];
	


----------------------------------------------- CHARGEMENT DE LA TABLE DIM_TERRITORY---------------------------------------------------

insert into [DW_AdventureWorks_Priv].[dbo].Dim_Territory (
	SalesTerritoryKey,
	Region,
	Country,
	Continent
)
select  SalesTerritoryKey,
		Region,
		Country,
		Continent
from [AdventureWorks_Priv].[dbo].[AdventureWorks_Territory_Lookup];



----------------------------------------------- CHARGEMENT DE LA DIM_VENTES---------------------------------------------------

-------- Utilisation du union all car on veut mettre dans cette table de dimension les ventes contenues dans trois tables (2020, 2021, 2022)
insert into [DW_AdventureWorks_Priv].[dbo].Dim_Ventes (
	OrderDate,
	StockDate,
	OrderNumber,
	ProductKey,
	CustomerKey,
	TerritoryKey,
	OrderLineItem,
	OrderQuantity
)
select 
	OrderDate,
	StockDate,
	OrderNumber,
	ProductKey,
	CustomerKey,
	TerritoryKey,
	OrderLineItem,
	OrderQuantity
from [AdventureWorks_Priv].[dbo].[ventes2020]
union all
select 
	OrderDate,
	StockDate,
	OrderNumber,
	ProductKey,
	CustomerKey,
	TerritoryKey,
	OrderLineItem,
	OrderQuantity
from [AdventureWorks_Priv].[dbo].[ventes2021]
union all
select 
	OrderDate,
	StockDate,
	OrderNumber,
	ProductKey,
	CustomerKey,
	TerritoryKey,
	OrderLineItem,
	OrderQuantity
from [AdventureWorks_Priv].[dbo].[ventes2022];




----------------------------------------------- CHARGEMENT DE LA DIM_DATES---------------------------------------------------

--  Détermination de la plage de dates
DECLARE @StartDate DATE, @EndDate DATE;

SELECT 
    @StartDate = MIN(MINDate),
    @EndDate = MAX(MAXDate)
FROM (
    SELECT MIN(Date) AS MINDate, MAX(Date) AS MAXDate FROM [AdventureWorks_Priv].[dbo].[AdventureWorks_Calendar_Lookup]
) AS DateRange;

PRINT 'Start = ' + CONVERT(VARCHAR,@StartDate);
PRINT 'End   = ' + CONVERT(VARCHAR,@EndDate);

--  Chargement de DimDates 
DECLARE @CurrentDate DATE = @StartDate;
WHILE @CurrentDate <= @EndDate
BEGIN
INSERT INTO [DW_AdventureWorks_Priv].[dbo].[Dim_Dates] ( 
  Date_SK,
  FullDate,                
  DayName,
  Day,
  DayOfWeek ,                         
  Week,
  Month,
  MonthName ,
  Quarter,
  QuarterName ,
  Year,
  YearName
) 
values (  
  CONVERT(INT, FORMAT(@CurrentDate,'yyyyMMdd')),
  @CurrentDate,
  DATENAME(WEEKDAY, @CurrentDate),
  DAY(@CurrentDate),
  DATENAME(WEEKDAY, @CurrentDate),
  DATENAME(WEEK, @CurrentDate),
  MONTH(@CurrentDate),
  DATENAME(MONTH, @CurrentDate),
  DATENAME(QUARTER, @CurrentDate),
  'Q'+ datename(quarter,@CurrentDate) + '-' + cast (year(@CurrentDate) as nvarchar(50)),
  YEAR(@CurrentDate),
  cast(year(@CurrentDate) as nvarchar(50))
);	
SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;




----------------------------------------------- CHARGEMENT DE LA FACT_ORDERS---------------------------------------------------

insert into [DW_AdventureWorks_Priv].[dbo].Fact_Orders (
	Date_SK,
	Order_SK,
	Customer_SK,
	Product_SK,
	ProductCategory_SK,
	ProductSubcategory_SK,
	SalesTerritory_SK,
	Quantity,
	UnitPrice,
	Sales_Amount
)
select 
	dd.Date_SK,
	dv.Order_SK,
	dc.Customer_SK,
	dp.Product_SK,
	dpc.ProductCategory_SK,
	dps.ProductSubcategory_SK,
	dt.SalesTerritory_SK,
	dv.OrderQuantity,
	dp.ProductPrice,
	dp.ProductPrice * dv.OrderQuantity as Sales_Amount
from
	[DW_AdventureWorks_Priv].[dbo].[Dim_Dates] dd join 
	[DW_AdventureWorks_Priv].[dbo].[Dim_Ventes] dv on dd.FullDate = dv.OrderDate join
	[DW_AdventureWorks_Priv].[dbo].[DimCustomer] dc on dv.CustomerKey = dc.CustomerKey join
	[DW_AdventureWorks_Priv].[dbo].[Dim_Product] dp on dv.ProductKey = dp.ProductKey join
	[DW_AdventureWorks_Priv].[dbo].[Dim_Product_SubCategory] dps on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey join
	[DW_AdventureWorks_Priv].[dbo].[Dim_Product_Category] dpc on dps.ProductCategoryKey = dpc.ProductCategoryKey join
	[DW_AdventureWorks_Priv].[dbo].[Dim_Territory] dt on dv.TerritoryKey = dt.SalesTerritoryKey 




