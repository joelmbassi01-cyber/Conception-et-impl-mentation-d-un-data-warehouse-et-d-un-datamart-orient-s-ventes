use AdventureWorks_Priv
set language 'english'

-------------------------------------- I- CHARGEMENT DES TABLES DE LA BASE DONNÉES SOURCE (ADVENTUREWORKS) ------------------------------------------------

---- CHARGEMENT DE LA TABLE AdventureWorks_Calendar_Lookup
BULK INSERT [dbo].[AdventureWorks_Calendar_Lookup]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\AdventureWorks Calendar Lookup.csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '65001');


---- CHARGEMENT DE LA TABLE AdventureWorks_Customer_Lookup
BULK INSERT [dbo].[AdventureWorks_Customer_Lookup]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\AdventureWorks Customer Lookup.csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '1252');


---- CHARGEMENT DE LA TABLE AdventureWorks_Product_Categories_Lookup
BULK INSERT [dbo].[AdventureWorks_Product_Categories_Lookup]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\AdventureWorks Product Categories Lookup.csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '65001');



---- CHARGEMENT DE LA TABLE AdventureWorks_Product_Subcategories_Lookup
BULK INSERT [dbo].[AdventureWorks_Product_Subcategories_Lookup]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\AdventureWorks Product Subcategories Lookup.csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '65001');



---- CHARGEMENT DE LA TABLE AdventureWorks_Returns_Data
	BULK INSERT [dbo].[AdventureWorks_Returns_Data]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\AdventureWorks Returns Data.csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '65001');



---- CHARGEMENT DE LA TABLE AdventureWorks_Territory_Lookup
	BULK INSERT [dbo].[AdventureWorks_Territory_Lookup]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\AdventureWorks Territory Lookup.csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '65001');



---- CHARGEMENT DE LA TABLE Product_Category_Sales
	BULK INSERT [dbo].[Product_Category_Sales]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\Product Category Sales (Unpivot Demo).csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '65001');



---- CHARGEMENT DE LA TABLE ventes2020
	BULK INSERT [dbo].[ventes2020]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\AdventureWorks Sales Data 2020.csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '65001');



---- CHARGEMENT DE LA TABLE ventes2021
	BULK INSERT [dbo].[ventes2021]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\AdventureWorks Sales Data 2021.csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '65001');



---- CHARGEMENT DE LA TABLE ventes2022
	BULK INSERT [dbo].[ventes2022]
FROM 'C:\Users\joelm\Downloads\AdventureWorks Sales Data.csv\AdventureWorks Sales Data 2022.csv'
WITH (
    FIRSTROW = 2,           -- Ignore l'en-tête (ligne 1)
    FIELDTERMINATOR = ',',  -- Délimiteur de colonne (ex: virgule)
    ROWTERMINATOR = '\n',   -- Fin de ligne (utilisez '\r\n' si Windows)
    CODEPAGE = '65001');

----NB : Impossible de charger correctement la table AdventureWorks_Product_Lookup via SSMS car la structure des données
----	 n'est pas prise en charge par SSMS. La aolution était de charger cette table via SSIS



-------------------------------------------- II- CREATION DU DATAMART (TABLES DE DIMENSION ET DES TABLES DE FAIT) --------------------------------------------------

---- 1) Création de la DimCustomer
create table DimCustomer (
	Customer_SK int primary key identity,
	CustomerKey int not null,
	FirstName nvarchar(30) not null,
	LastName nvarchar(30) not null,
	MaritalStatus nvarchar(3) not null,
	Gender nvarchar(3) not null,
	AnnualIncome int not null,
	TotalChildren int not null,
	EducationLevel nvarchar(50) not null,
	Occupation nvarchar(50) not null
);



---- 2) Création de la Dim_Product_Category
create table Dim_Product_Category (
	ProductCategory_SK int primary key identity,
	ProductCategoryKey int not null,
	CategoryName nvarchar(25) not null
);



---- 3) Création de la Dim_Product_SubCategory
create table Dim_Product_SubCategory (
	ProductSubcategory_SK int primary key identity,
	ProductSubcategoryKey int not null,
	SubcategoryName nvarchar(50) not null,
	ProductCategoryKey int not null                        
);



---- 4) Création de la Dim_Product
create table Dim_Product (
	Product_SK int primary key identity,
	ProductKey int not null,
	ProductSubcategoryKey int not null,   
	ProductSKU nvarchar(30) not null,
	ProductName nvarchar(200) not null,
	ModelName nvarchar(200) not null,
	ProductCost float not null,
	ProductPrice float not null
);



---- 5) Création de la Dim_Territory
create table Dim_Territory (
	SalesTerritory_SK int primary key identity,
	SalesTerritoryKey int not null,
	Region nvarchar(20) not null,
	Country nvarchar(20) not null,
	Continent nvarchar(20) not null,
);



---- 6) Création de la Dim_Ventes
create table Dim_Ventes (
	Order_SK int primary key identity,
	OrderDate date not null,
	StockDate date not null,
	OrderNumber nvarchar(20) not null,
	ProductKey int not null, 
	CustomerKey int not null, 
	TerritoryKey int not null, 
	OrderLineItem int not null, 
	OrderQuantity int not null
);



---- 7) Création de la Dim_Dates
CREATE TABLE Dim_Dates (
    Date_SK INT NOT NULL PRIMARY KEY,               
    FullDate DATE NOT NULL,                
    DayName NVARCHAR(20) NOT NULL,
	Day INT NOT NULL,
    DayOfWeek NVARCHAR(20) NOT NULL,                         
    Week INT NOT NULL,
    Month INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    Quarter INT NOT NULL,
	QuarterName nvarchar(20) NOT NULL,
    Year INT NOT NULL,
	YearName nvarchar(20) NOT NULL
);


use DW_AdventureWorks_Priv
---- 8) Création de la Fact_Orders
create table Fact_Orders (
	OrderDetailsKey INT NOT NULL PRIMARY KEY IDENTITY,
	Date_SK int,
	Order_SK int,
	Customer_SK int,
	Product_SK int,
	ProductCategory_SK int,
	ProductSubcategory_SK int,
	SalesTerritory_SK int,
	Quantity int,
	UnitPrice float,
	Sales_Amount float
)



---- 9) Création des contraintes d'intégrité référentielles
ALTER TABLE Fact_Orders ADD CONSTRAINT FK_Fact_Orders_DimDates FOREIGN KEY (Date_SK) REFERENCES dbo.Dim_Dates(Date_SK);
ALTER TABLE Fact_Orders ADD CONSTRAINT FK_Fact_Orders_DimProduct FOREIGN KEY (Product_SK) REFERENCES dbo.Dim_Product(Product_SK);
ALTER TABLE Fact_Orders ADD CONSTRAINT FK_Fact_Orders_DimProduct_Category FOREIGN KEY (ProductCategory_SK) REFERENCES dbo.Dim_Product_Category(ProductCategory_SK);
ALTER TABLE Fact_Orders ADD CONSTRAINT FK_Fact_Orders_DimProduct_Subcategory FOREIGN KEY (ProductSubcategory_SK) REFERENCES dbo.Dim_Product_SubCategory(ProductSubcategory_SK);
ALTER TABLE Fact_Orders ADD CONSTRAINT FK_Fact_Orders_DimTerritory FOREIGN KEY (SalesTerritory_SK) REFERENCES dbo.Dim_Territory(SalesTerritory_SK);
ALTER TABLE Fact_Orders ADD CONSTRAINT FK_Fact_Orders_DimVentes FOREIGN KEY (Order_SK) REFERENCES dbo.Dim_Ventes(Order_SK);
ALTER TABLE Fact_Orders ADD CONSTRAINT FK_Fact_Orders_DimCustomer FOREIGN KEY (Customer_SK) REFERENCES dbo.DimCustomer(Customer_SK);