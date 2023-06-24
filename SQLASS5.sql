create database ASS6
go


CREATE TABLE Customers (
	Customer_ID INT IDENTITY(1,1) NOT NULL UNIQUE,
	Customer_name NVARCHAR(50) NOT NULL,
	Address NVARCHAR(255) NOT NULL,
	Birthday DATE NOT NULL,
	PRIMARY KEY (Customer_ID)
);


CREATE TABLE PhoneNumbers (
	Phone_ID INT IDENTITY(1,1) NOT NULL UNIQUE,
	Customer_ID INT NOT NULL,
	Numbers INT NOT NULL,
	PRIMARY KEY (Phone_ID),
	CONSTRAINT Customer_ID_FK FOREIGN KEY(Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Customers
	VALUES ('Nguyễn Văn An', '111 Nguyễn Trãi, Thanh Xuân, Hà Nội', '1987-11-18');
SELECT * FROM Customers;


INSERT INTO PhoneNumbers
	VALUES  (1, 987654321),
			(1, 09873452),
			(1, 09832323),
			(1, 09434343);
SELECT * FROM PhoneNumbers;


SELECT * FROM Customers;
 

SELECT * FROM PhoneNumbers;


SELECT * FROM Customers
ORDER BY Customer_name ASC;


SELECT pn.* 
FROM PhoneNumbers pn
INNER JOIN Customers c ON c.Customer_ID = pn.Customer_ID
WHERE c.Customer_name = 'Nguyễn Văn An';


SELECT * 
FROM Customers
WHERE Birthday = '12-12-2009';


SELECT c.Customer_name, COUNT(pn.Phone_ID) AS TotalPhoneNumbers
FROM PhoneNumbers pn
INNER JOIN Customers c ON c.Customer_ID = pn.Customer_ID
GROUP BY c.Customer_name;


SELECT COUNT(*) AS TotalBirthday12
FROM Customers
WHERE MONTH(Birthday) = 12;


SELECT * 
FROM PhoneNumbers pn
FULL JOIN Customers c ON c.Customer_ID = pn.Customer_ID;


SELECT c.*
FROM PhoneNumbers pn
INNER JOIN Customers c ON c.Customer_ID = pn.Customer_ID
WHERE pn.Numbers = 123456789;


UPDATE Customers
SET Birthday = DATEADD(day, -1, GETDATE())
WHERE Birthday > GETDATE();


SELECT COLUMN_NAME, CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'Customers' AND CONSTRAINT_NAME LIKE 'PK_%';


SELECT COLUMN_NAME, CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'PhoneNumbers' AND CONSTRAINT_NAME LIKE 'PK_%';


SELECT CONSTRAINT_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'PhoneNumbers' AND CONSTRAINT_NAME LIKE '%FK';


ALTER TABLE Customers
ADD StartDate DATE;
SELECT * FROM Customers;


CREATE INDEX IX_HoTen
ON Customers (Customer_name);


CREATE INDEX IX_SoDienThoai
ON PhoneNumbers (Numbers);


CREATE VIEW View_SoDienThoai AS
SELECT c.Customer_name, pn.Numbers
FROM Customers c
INNER JOIN PhoneNumbers pn ON c.Customer_ID = pn.Customer_ID;
 

SELECT * FROM View_SoDienThoai;


CREATE VIEW View_SinhNhat AS
SELECT c.Customer_name, c.Birthday ,pn.Numbers
FROM Customers c
INNER JOIN PhoneNumbers pn ON c.Customer_ID = pn.Customer_ID
WHERE MONTH(Birthday) = GETDATE();

SELECT * FROM View_SinhNhat;


CREATE Procedure SP_Them_DanhBa
	@Customer_name NVARCHAR(50),
	@Address NVARCHAR(255),
	@Birthday DATE
AS
BEGIN
	INSERT INTO Customers(Customer_name, Address, Birthday)
		VALUES (@Customer_name, @Address, @Birthday)
	BEGIN
	PRINT 'ADD NEW SUCCESS';
	END
END;

--RUN
EXEC SP_Them_DanhBa 'Phạm Văn Nam', '8A Tôn Thất Thuyết, Cầu Giấy, Hà Nội', '2002-5-9';
EXEC SP_Them_DanhBa 'Phạm Bao Cuong', 'Đống Đa, Hà Nội', '2002-5-9';
EXEC SP_Them_DanhBa 'Phạm Văn Nam', '8A Tôn Thất Thuyết, Cầu Giấy, Hà Nội', '2002-5-9';
SELECT * FROM Customers;


CREATE Procedure SP_Tim_DanhBa
	@Customer_name NVARCHAR(50)
AS
BEGIN
	IF EXISTS (
		SELECT *
		FROM Customers
		WHERE Customer_name LIKE '%' + @Customer_name + '%'
	)
	BEGIN
		SELECT *
		FROM Customers
		WHERE Customer_name LIKE '%' + @Customer_name + '%';
	END
	ELSE
	BEGIN
		PRINT 'Không tìm được tên nào phù hợp'
	END
END;
--TEST
SELECT * FROM Customers;
EXEC SP_Tim_DanhBa 'AN';
EXEC SP_Tim_DanhBa 'NAM';
EXEC SP_Tim_DanhBa 'TRẦN';
EXEC SP_Tim_DanhBa 'PHẠM';