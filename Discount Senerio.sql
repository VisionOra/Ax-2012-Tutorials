Create Database Sales;

/*Temperory Table Only for Computation*/
create table itemsIDS(
PKitemsIDS int NOT NULL    IDENTITY    PRIMARY KEY,
itemids int,
amount int,
invoive int
)
CREATE TABLE ItemTable (
    
    ItemID INT   NOT NULL    IDENTITY    PRIMARY KEY,
	ItemName varchar(255),
    Amount int,
    
);
CREATE TABLE SalesDiscount (
    InvoiceID INT ,
	ItemID int FOREIGN KEY REFERENCES ItemTable(ItemID),
	Quantity int,
    Total_Amount int,
    Discount int,
    New_Amount int 
);

INSERT INTO ItemTable ( ItemName, Amount)
VALUES ( 'Milk', 100);

INSERT INTO ItemTable ( ItemName, Amount)
VALUES ( 'Yougurt', 50);

INSERT INTO ItemTable (ItemName, Amount)
VALUES ('Bread', 75);

INSERT INTO ItemTable (ItemName, Amount)
VALUES ( 'Eggs', 130);

INSERT INTO ItemTable ( ItemName, Amount)
VALUES ('Biscuits', 30);

INSERT INTO ItemTable ( ItemName, Amount)
VALUES ( 'Choclates', 75);

/* Insert Items in Items Table*/
CREATE PROCEDURE Insert_Item  @ItemName1 nvarchar(30), @Amount1 int
AS

INSERT INTO ItemTable( ItemName, Amount)
VALUES ( @ItemName1, @Amount1)



EXEC Insert_Item 'Candy', 10;
select * from ItemTable


/* Insert Sales Discount*/
Create Procedure InsertSales @itemName1 nvarchar(30) , @Quantity int, @invoiceID int
as 
begin
/*Making Variables which are used in sql*/
declare @amount int
set @amount= (select Amount from ItemTable where ItemName = @itemName1)

declare @itemID int 
set @itemID=(select ItemID from ItemTable where ItemName = @itemName1)



/*Insertion Quries*/ 
Insert into SalesDiscount(InvoiceID,itemID,Quantity,Total_Amount) values (@invoiceID,@itemID,@Quantity,@amount*@Quantity)

end;

create procedure discount_calculation   @invoiceID int, @dicount decimal
as

/*declaring array to store itemids and their prices */
/*Create new table because by this I am able to store only values which are in same invoive will be easy to calculate discount*/
TRUNCATE TABLE dbo.itemsIDS;
insert into dbo.itemsIDS (itemids,amount,invoive)  ( select ItemID,Total_Amount,InvoiceID from SalesDiscount where invoiceID=@invoiceID )
select * from itemsIDS


/* loop to calculate discounted amount for every item*/
declare @TotalAmountofInvoice decimal
set @TotalAmountofInvoice=(select sum(Total_Amount) from SalesDiscount where invoiceID=@invoiceID )
print @TotalAmountofInvoice


declare @TotalNumberOfItemsInvoice int
set @TotalNumberOfItemsInvoice=(select count(ItemID) from SalesDiscount where invoiceID=@invoiceID )
print @TotalNumberOfItemsInvoice

declare @temp int 
set @temp=0
while @temp < @TotalNumberOfItemsInvoice

Begin
	set @temp = @temp+1
	print @temp
	
	
	declare @tempAmount decimal
	set @tempAmount= (select amount from itemsIDS where PKitemsIDS=@temp)
	select @tempAmount as tempamount
	
	declare @percent decimal
	set @percent = ( (@tempAmount / @TotalAmountofInvoice) *100)
	select @percent as percent1
	

	declare @itemNumber int
	set @itemNumber=(select itemids from itemsIDS where PKitemsIDS=@temp)
	 

	declare @AmountofItem int
	set @AmountofItem= (select amount from itemsIDS where PKitemsIDS=@temp)
	

	declare @amountDicounted decimal
	set @amountDicounted= (@dicount * (@percent/100))
	select @amountDicounted as DiscountAmount


	declare @discountedPrice int
	set @discountedPrice=(@AmountofItem - @amountDicounted)
	select @discountedPrice as discountprice

	declare @invoice int
	set  @invoiceID=(select invoive from itemsIDS where PKitemsIDS=@temp)
	print @invoiceID
	
	UPDATE SalesDiscount
	SET Discount = @percent, New_Amount= @discountedPrice
	WHERE ItemID = @itemNumber and InvoiceID=@invoiceID;
	print @itemNumber
	print @invoiceID

end;
DELETE FROM dbo.itemsIDS
/*Because we now dont need this table*/
	



EXEC InsertSales 'Milk',3,2





EXEC discount_calculation 1,30


select * from SalesDiscount
select * from itemsIDS

declare @taa decimal
set @taa= 100


declare @te decimal 
set @te=62
print ((@te/100)*@taa)


