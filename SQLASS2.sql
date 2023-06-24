USE Master
GO
IF EXISTS (SELECT * FROM sys.databases WHERE Name='Slot7_Assignment_MSSQL_2')

create database ASS2
go

CREATE TABLE company (
  id INT PRIMARY KEY,
  company_code INT,
  company_name VARCHAR(255),
  address VARCHAR(255),
  phone_number VARCHAR(255)
 );
 create table product (
  product_name VARCHAR(255),
  product_description VARCHAR(255),
  unit VARCHAR(255),
  price INT,
  quantity INT
);

--them du lieu vao bang

insert into company(id, company_code, company_name, address, phone_number)
	VALUES (1, 123, 'Asus', 'USA', '983232'),
		   (2, 123, 'Asus', 'USA', '983232'),
		   (3, 123, 'Asus', 'USA', '983232');

insert into product (product_name, product_description, unit, price, quantity)
	values ('Máy TínhT450', 'Máy nhập cũ', 'Chiếc', 1000, 10),
		  ('Điện Thoại Nokia5670', 'Điện thoại hot', 'Chiếc', 200, 200),
		  ('Máy In Samsung 450', 'Máy in đang loạibình', 'Chiếc', 100, 1);

--hiển thị hãng sản xuất

SELECT DISTINCT company_name FROM company;

--hiển thị sản phẩm

SELECT * FROM product;

--liệt kê tên ngược alphabet

SELECT DISTINCT company_name FROM company ORDER BY company_name DESC;

--liệt kê giá giảm dần

SELECT * FROM product ORDER BY price DESC;

--hiển thị thông tin hãng

SELECT * FROM company WHERE id = '123'

--Liệt kê danh sách sản phẩm còn ít hơn 11 chiếc trong kho

SELECT * FROM product WHERE quantity < 11

--Liệt kê danh sách sản phẩm của hãng Asus

SELECT product_name FROM product 

--Số hãng sản phẩm mà cửa hàng có.

SELECT COUNT(DISTINCT product_name) AS SoHangSanXuat FROM product

--Số mặt hàng mà cửa hàng bán.

select COUNT(distinct product_name) as SoMatHang from product

-- Tổng số loại sản phẩm của mỗi hãng có trong cửa hàng.
SELECT s.Company_name, COUNT(*) AS TotalProductCategories
FROM Suppliers s
JOIN Products p ON s.Supplier_ID = p.Supplier_ID
GROUP BY s.Company_name;

-- Tổng số đầu sản phẩm của toàn cửa hàng
SELECT SUM(Quantity) AS TotalProduct
FROM Products

--  Thay đổi những thay đổi sau trên cơ sở dữ liệu
-- Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương(>0).
UPDATE Products
SET UnitPrice = ABS(UnitPrice)
WHERE UnitPrice < 0;

--Viết câu lệnh để thay đổi số điện thoại phải bắt đầu bằng 0.
UPDATE Suppliers
SET Phone = '0' + RIGHT(Phone, LEN(Phone))
WHERE LEFT(Phone,1) != '0';

--TEST
SELECT * FROM Suppliers

-- Viết các câu lệnh để xác định các khóa ngoại và khóa chính của các bảng

-- Xem thông tin các khóa chính của bảng Suppliers
SELECT COLUMN_NAME, CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'Suppliers' AND CONSTRAINT_NAME LIKE 'PK_%';

-- Xem thông tin các khóa chính của bảng Products
SELECT COLUMN_NAME, CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'Products' AND CONSTRAINT_NAME LIKE 'PK_%';

-- Xem thông tin các khóa ngoại của bảng Products
SELECT CONSTRAINT_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'Products' AND CONSTRAINT_NAME = 'Supplier_ID_FK';

-- Thiết lập chỉ mục (Index) cho các cột sau: Tên hàng và Mô tả hàng để tăng hiệu suất truy vấn dữ liệu từ 2 cột này
CREATE INDEX idx_pName_pDesc
ON Products (Product_name, Description);

-- Viết các View sau:
-- View_SanPham: với các cột Mã sản phẩm, Tên sản phẩm, Giá bán
CREATE VIEW View_SanPham AS
SELECT p.Product_ID, p.Product_name, p.UnitPrice
FROM Products p;

SELECT * FROM View_SanPham;

-- View_SanPham_Hang: với các cột Mã SP, Tên sản phẩm, Hãng sản xuất
CREATE VIEW View_SanPham_Hang AS
SELECT p.Product_ID, p.Product_name, p.UnitPrice, s.Company_name
FROM Products p
INNER JOIN Suppliers s ON p.Supplier_ID = s.Supplier_ID;

SELECT * FROM View_SanPham_Hang;

-- Viết các Store Procedure sau:
-- SP_SanPham_TenHang: Liệt kê các sản phẩm với tên hãng truyền vào store
CREATE PROCEDURE SP_SanPham_TenHang
@Company_name NVARCHAR(50)
AS
BEGIN
	SELECT p.*
	FROM Products p
	INNER JOIN Suppliers s ON p.Supplier_ID = s.Supplier_ID
	WHERE @Company_name = s.Company_name
END;
-- RUN
EXEC SP_SanPham_TenHang @Company_name = 'Asus';

-- SP_SanPham_Gia: Liệt kê các sản phẩm có giá bán lớn hơn hoặc bằng giá bán truyền vào
CREATE PROCEDURE SP_SanPham_Gia
@UnitPrice MONEY
AS
BEGIN
	SELECT p.Product_name
	FROM Products p
	WHERE p.UnitPrice >= @UnitPrice;
END;
-- RUN
EXEC SP_SanPham_Gia @UnitPrice = 500;

-- SP_SanPham_HetHang: Liệt kê các sản phẩm đã hết hàng (số lượng = 0)
CREATE PROCEDURE SP_SanPham_HetHang
AS
BEGIN
	SELECT p.*
	FROM Products p
	WHERE p.Quantity = 0;
END;

-- RUN
EXEC SP_SanPham_HetHang;

-- Viết Trigger sau:
-- TG_Xoa_Hang: Ngăn không cho xóa hãng
CREATE TRIGGER TG_Xoa_Hang
ON Suppliers AFTER DELETE
AS
	BEGIN
		RAISERROR('It is not allowed to delete the company', 16, 1)
		ROLLBACK TRANSACTION
	END;

-- TEST TRIGGER TG_Xoa_Hang
DELETE FROM Products WHERE Supplier_ID = 123;
DELETE FROM Suppliers WHERE Supplier_ID = 123;
SELECT *  FROM Suppliers
SELECT *  FROM Products

-- TG_Xoa_SanPham: Chỉ cho phép xóa các sản phẩm đã hết hàng (số lượng = 0)
CREATE TRIGGER TG_Xoa_SanPham
ON Products AFTER DELETE
AS
	BEGIN
		IF EXISTS(SELECT * FROM deleted WHERE Quantity !=0)
		BEGIN
			RAISERROR('Only products that are out of stock are allowed to be deleted.', 16, 1)
			ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
			DELETE FROM Products 
			WHERE Product_ID IN (SELECT Product_ID FROM deleted);
		END
	END;
-- TEST TRIGGER TG_Xoa_SanPham
UPDATE Products
SET Quantity = 0
WHERE Product_ID = 2;

DELETE FROM Products WHERE Product_ID = 1;
DELETE FROM Products WHERE Product_ID = 2;
DELETE FROM Products WHERE Product_ID = 3;

SELECT * FROM Products;

