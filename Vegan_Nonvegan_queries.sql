--Vegan/Non Vegan queries (set up for interesting queries regarding top consumers and suppliers)
--Define categories
select *
from
	(

		select 
			CategoryID,
			CategoryName,
			case 
				when CategoryName = 'Meat/Poultry' or CategoryName = 'Seafood' or CategoryName = 'Dairy Products' then
					'Not Vegan'
				when CategoryName = 'Produce' or CategoryName = 'Grains/Cereals' then
					'Vegan'
				else
					'Who knows'
			end as Decision
		from 
		Categories
		
	) as CategoryDecisions


-- How many Products are in each Decision (Vegan, Not Vegan, Who knows)?
SELECT     CategoryDecisions.Decision, COUNT(productid) as ProductCount
FROM       
        Products
        inner join
        Categories ON Products.CategoryID = Categories.CategoryID inner join
	(

		select 
			CategoryID,
			CategoryName,
			case 
				when CategoryName = 'Meat/Poultry' or CategoryName = 'Seafood' or CategoryName = 'Dairy Products' then
					'Not Vegan'
				when CategoryName = 'Produce' or CategoryName = 'Grains/Cereals' then
					'Vegan'
				else
					'Who knows'
			end as Decision
		from 
		Categories
		
	) as CategoryDecisions on Categories.CategoryName = CategoryDecisions.CategoryName
group by
	CategoryDecisions.Decision


-- Which single Customer buys the most Vegan products (and how many)?

SELECT   top 1   Customers.CompanyName, Decision, COUNT(distinct Products.Productid) as DecisionCount
FROM         Customers INNER JOIN
                      Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                      [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                      Products ON [Order Details].ProductID = Products.ProductID INNER JOIN
                      Categories ON Products.CategoryID = Categories.CategoryID inner join
	(

		select 
			CategoryID,
			CategoryName,
			case 
				when CategoryName = 'Meat/Poultry' or CategoryName = 'Seafood' or CategoryName = 'Dairy Products' then
					'Not Vegan'
				when CategoryName = 'Produce' or CategoryName = 'Grains/Cereals' then
					'Vegan'
				else
					'Who knows'
			end as Decision
		from 
		Categories
		
	) as CategoryDecisions on Categories.CategoryID = CategoryDecisions.CategoryID
where Decision = 'Vegan'	
GROUP BY Customers.CompanyName, Decision
order by DecisionCount desc, Customers.CompanyName


-- Which Supplier supplies the most 'Not Vegan' products to Northwind?
SELECT  top 1 Suppliers.CompanyName, CategoryDecisions.Decision, COUNT(distinct ProductID) as ProductCount
FROM         
	Suppliers INNER JOIN
	Products ON Suppliers.SupplierID = Products.SupplierID INNER JOIN
  Categories ON Products.CategoryID = Categories.CategoryID
  inner join
	(

		select 
			CategoryID,
			CategoryName,
			case 
				when CategoryName = 'Meat/Poultry' or CategoryName = 'Seafood' or CategoryName = 'Dairy Products' then
					'Not Vegan'
				when CategoryName = 'Produce' or CategoryName = 'Grains/Cereals' then
					'Vegan'
				else
					'Who knows'
			end as Decision
		from 
		Categories
		
	) as CategoryDecisions on Categories.CategoryID = CategoryDecisions.CategoryID
where CategoryDecisions.Decision = 'Not Vegan'
group by Suppliers.CompanyName, CategoryDecisions.Decision	
order by ProductCount desc, Suppliers.CompanyName
