create database dbfinance

 

drop database dbfinance

 

create database dbPFinance
create procedure Insert_Proc(@bankname varchar(30), @accno int, @ifsc varchar(11), @name varchar(30), @email varchar(30), @phone varchar(10),
@username varchar(20), @password nvarchar(20), @address text, @cardtype bit, @feespaid bit, @document varchar(50))
as 
begin
    insert into BankDetails values(@bankname, @accno, @ifsc)
    insert into Register values(@name, @email, @phone, @username, @password, @address, @cardtype, @feespaid, @document)
end

 

create table RegisterBank
(
Name varchar(30) not null,
email varchar(30) not null unique,
Phone_No varchar(10) not null unique,
username varchar(20) primary key,
Password nvarchar(20) not null,
Address text not null,
Card_Type bit not null,
Fees_Paid bit,
Bank_Name varchar(30) not null,
Account_Number int unique not null,
IFSC_Code varchar(11) not null,
document varchar(max) not null
)
select * from RegisterBank

 

insert into RegisterBank values
('XYZ', 'xyz@gmail.com', '8787512497', 'xyz123', 'xyzN1230', '711-2880 Nulla St. Mankato Mississippi 96522 (257) 563-7401', 0, 0,'HDFC Bank', 2051373512,'10055100668','C:\Users\nehan\Downloads\Final Project Teams - Case Studies\Case Study - Finance.pdf'),
('ABC', 'abc@gmail.com', '7541294124', 'abc123', 'abcN9870', 'P.O. Box 283 8562 Fusce Rd. Frederick Nebraska 20620 (372) 587-2335', 1, 1,'Kotak Bank', 1021257854,'20099000665','C:\Users\nehan\Downloads\Final Project Teams - Case Studies\Case Study - Finance.pdf')

 


select * from Register

 


drop table Register

 

drop table BankDetails
(
Bank_Name varchar(30) not null,
Account_Number int primary key,
IFSC_Code varchar(11) not null
)

 

select * from BankDetails

 


insert into BankDetails values
('Kotak Bank', 1021257854, 'KM00124598'),
('State Bank of India', 2051373512, 'SBIN001245')

 


select * from BankDetails

 


drop table BankDetails

 

 

create table Admin
(
username varchar(20) primary key,
Password nvarchar(20) not null,
Phone varchar(10) not null,
Email varchar(30) not null
)

 


insert into Admin values
('aaa', 'aaa123','7235391272','aaa@gmail.com')

 


select * from Admin

 


create table Products
(
Product_ID int primary key,
Name varchar(20) not null,
Cost money not null,
imagePath varchar(50),
Details varchar(max) not null
)

 


insert into Products values
('101', 'Camera', 25999, 'assets/images/camera.jpg', 'DSLR'),
('102', 'Headphone', 2399, 'assets/images/headphone.jpg', 'Boat bluetooth headset'),
('103', 'Phone', 17999, 'assets/images/phone.jpg', 'Sumsung M31'),
('104', 'Shoes', 1230, 'assets/images/shoes.jpg', 'Nike Shoes'),
('105', 'Watch', 9799, 'assets/images/watch.jpg', 'Apple smart watch')

 


select * from Products

 


drop table Products

 


create table Cart
(
Card_ID int identity,
Product_ID int references Products(Product_ID),
Quantity int,
constraint compkey primary key(Card_ID, Product_ID)
)

 


drop table Cart

 


create table EMICard
(
Card_Number int primary key,
username varchar(20) not null references RegisterBank(username),
Card_Type bit references Card(Card_Type),
/* Credit_Used money, */
valid date not null,
Active bit not null default 0,
admin_username varchar(20) references Admin(username)
)

 

 


insert into EMICard values
('0000112154', 'abc123', 1, DateAdd(yy,5,GetDate()), 0, 'aaa'),
('0001225481', 'xyz123', 0, DateAdd(yy,5,GetDate()), 1, 'aaa')

 

select * from EMICard1

 

 

update EMICard set Active=0
where username='xyz'

 


create table Card
(
Card_Type bit primary key,
Total_Credit money not null,
)

 


insert into Card values
(0, 50000),
(1, 100000)

 


select * from Card

 


create table Transactions
(
Transaction_ID int primary key,
Product_ID int references Products(Product_ID),
Date date not null,
Amount_Paid money not null,
Card_Number int references EMICard(Card_Number)
)

 

alter table Transactions
alter 

 


insert into Transactions values
/* ('0048571249', '102', '12-27-2020', 39999, '0000112154'), */
('0022458674', '102', '12-30-2020', 2399, '0000112154'),
('0012489321', '101', '12-28-2020', 8666.33, '0000112154'),
('0013489456', '101', '1-5-2021', 8666.33, '0000112154')

 


select * from Transactions

 


drop table Transactions

 


create proc sp_GetAllRegister
as
begin
select * from Register join EMICard
on Register.username = EMICard.username
where Active=0
end

 


alter proc sp_UserTransactions
(@username varchar(20))
as
begin
select p.Name, t.Date, t.Amount_Paid from Transactions t join EMICard c
on t.Card_Number = c.Card_Number
join Products p on t.Product_ID = p.Product_ID
where username = @username
end

 


sp_UserTransactions 'abc'

 


drop proc sp_LoginCheck

 


create proc sp_AdminLoginCheck
(@username varchar(20), @password nvarchar(20))
as
begin
select username from Admin where username=@username and Password=@password
end

 


sp_AdminLoginCheck 'aaa', 'aaa123'

 


create proc sp_UserLoginCheck
(@username varchar(20), @password nvarchar(20))
as
begin
select * from Register where username=@username and Password=@password
end

 


sp_UserLoginCheck 'abc', 'abc987'

 

 

create proc sp_GetBalanceCredit
(@cardNumber int)
as
begin
select Sum(Cost) from Transactions t join EMICard c
on t.Card_Number = c.Card_Number
join Products p on t.Product_ID = p.Product_ID
where t.Card_Number = @cardNumber
group by t.Card_Number
end

 


sp_GetBalanceCredit 112154

 


drop proc sp_GetBalanceCredit

 


alter proc sp_UserProducts
(@username varchar(20))
as
begin
select p.Name, Sum(t.Amount_Paid) as 'Amount Paid', p.Details, p.imagePath, p.Cost, (p.Cost-Sum(t.Amount_Paid)) as Balance from Transactions t join EMICard c
on t.Card_Number = c.Card_Number
join Products p on t.Product_ID = p.Product_ID
where username = @username
group by p.Product_ID, p.Name, p.Cost, p.Details, p.imagePath
end

 


sp_UserProducts 'abc'