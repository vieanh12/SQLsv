-- EDIT DATABASE
USE Master
GO
IF EXISTS (SELECT * FROM sys.databases WHERE Name='Slot6_Assignment_MSSQL_1')
DROP DATABASE Slot6_Assignment_MSSQL_1
GO
-- CREATE DATABASE
create database ASS1
go

--tạo bảng

CREATE TABLE don_hang (
    ma_so INT PRIMARY KEY not null,
    nguoi_dat_hang VARCHAR(255) not null,
    dia_chi VARCHAR(255) not null,
    dien_thoai INT not null,
    ngay_dat_hang DATE
);

CREATE TABLE chi_tiet_don_hang (
    id INT PRIMARY KEY not null,
    ma_so_don_hang INT not null,
    ten_hang VARCHAR(255) not null,
    mo_ta_hang VARCHAR(255) not null,
    don_vi VARCHAR(255) not null,
    gia INT not null,
    so_luong INT not null,
    thanh_tien INT not null,
    FOREIGN KEY (ma_so_don_hang) REFERENCES don_hang(ma_so)
);

--Thêm dữ liệu vào bảng

INSERT INTO don_hang (ma_so, nguoi_dat_hang, dia_chi, dien_thoai, ngay_dat_hang)
VALUES (123, 'Nguyễn Văn An', '111 Nguyễn Trãi, Thanh Xuân, Hà Nội', 987654321, '2009-11-18');

INSERT INTO don_hang (ma_so, nguoi_dat_hang, dia_chi, dien_thoai, ngay_dat_hang)
VALUES (456, 'Nguyễn Thị Bình', '123 Lê Lợi, Hoàn Kiếm, Hà Nội', 123456789, '2010-06-12'),
	   (789, 'Nguyễn Văn Chung', '123 Nguyễn Tuân, Thanh Xuân, Hà Nội', 123456798, '2011-12-12');
	   

INSERT INTO chi_tiet_don_hang (id, ma_so_don_hang, ten_hang, mo_ta_hang, don_vi, gia, so_luong, thanh_tien)
VALUES (1, 123, 'Máy TínhT450', 'Máy nhập mới', 'Chiếc', 1000, 1, 1000),
       (2, 123, 'Điện Thoại Nokia5670', 'Điện thoại đang hot', 'Chiếc', 200, 2, 400),
       (3, 123, 'Máy In Samsung 450', 'Máy in đang ế', 'Chiếc', 100, 1, 100);

--Liệt kê danh sách khách hàng đã mua hàng ở cửa hàng

SELECT nguoi_dat_hang, dia_chi, dien_thoai
FROM don_hang;

--Liệt kê danh sách sản phẩm của của hàng 

SELECT ten_hang, mo_ta_hang, gia
FROM chi_tiet_don_hang;

--Liệt kê danh sách các đơn đặt hàng của cửa hàng từ bảng trên

SELECT ma_so, nguoi_dat_hang, dia_chi, dien_thoai, ngay_dat_hang
FROM don_hang;

--Liệt kê danh sách khách hàng theo thứ thự alphabet

SELECT nguoi_dat_hang, dia_chi, dien_thoai
FROM don_hang
ORDER BY nguoi_dat_hang ASC;

--Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần.

SELECT ten_hang, mo_ta_hang, gia
FROM chi_tiet_don_hang
ORDER BY gia DESC;

--Liệt kê các sản phẩm mà khách hàng Nguyễn Văn An đã mua.

SELECT chi_tiet_don_hang.ma_so_don_hang, chi_tiet_don_hang.so_luong, chi_tiet_don_hang.gia
FROM don_hang
JOIN chi_tiet_don_hang ON don_hang.ma_so = chi_tiet_don_hang.id
WHERE don_hang.nguoi_dat_hang = 'Nguyễn Văn An';

--Số khách hàng đã mua ở cửa hàng.

SELECT COUNT(DISTINCT nguoi_dat_hang) AS so_luong_khach_hang_da_mua
FROM don_hang;

--Số mặt hàng mà cửa hàng bán

SELECT COUNT(*) AS so_luong_mat_hang
FROM chi_tiet_don_hang;

--Tổng tiền của từng đơn hàng.

SELECT don_hang.ma_so, SUM(chi_tiet_don_hang.so_luong * chi_tiet_don_hang.gia) AS tong_tien
FROM don_hang
JOIN chi_tiet_don_hang ON don_hang.ma_so = chi_tiet_don_hang.id
GROUP BY don_hang.ma_so;

-- 7. Thay đổi những thông tin sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương(>0).
UPDATE Products
SET UnitPrice = ABS(UnitPrice)
WHERE UnitPrice < 0;

--b) Viết câu lệnh để thay đổi ngày đặt hàng của khách hàng phải nhỏ hơn ngày hiện tại.
UPDATE Orders
SET Order_Date = DATEADD(day, -1, GETDATE())
WHERE Order_Date > GETDATE();

--c) Viết câu lệnh để thêm trường ngày xuất hiện trên thị trường của sản phẩm.
ALTER TABLE Products
ADD MarketDate DATE; 

-- 8. Thực hiện các yêu cầu sau
--a) Đặt chỉ mục (index) cho cột Tên hàng và Người đặt hàng để tăng tốc độ truy vấn dữ liệu trên các cột này
CREATE INDEX idx_Product_name
ON Products (Product_name);

CREATE INDEX idx_Customer_name
ON Customers (Customer_name);

--b) Xây dựng các view sau đây:
-- View_KhachHang với các cột: Tên khách hàng, Địa chỉ, Điện thoại.
CREATE VIEW View_KhachHang AS
SELECT c.Customer_name, c.Address, c.Phone
FROM Customers c;

SELECT * FROM View_KhachHang;

-- View_SanPham với các cột: Tên sản phẩm, Giá bán.
CREATE VIEW View_SanPham AS
SELECT p.Product_name, p.UnitPrice
FROM Products p;

SELECT * FROM View_SanPham;

-- View_KhachHang_SanPham với các cột: Tên khách hàng, Số điện thoại, Tên sản phẩm, Số lượng, Ngày mua.
CREATE VIEW View_KhachHang_SanPham AS
SELECT c.Customer_name, c.Phone, p.Product_name, od.Quantity, o.Order_Date
FROM Customers c
INNER JOIN Orders o ON c.Customer_ID = o.Customer_ID
INNER JOIN OrderDetails od ON o.Order_ID = od.Order_ID
INNER JOIN Products p ON od.Product_ID = p.Product_ID;

SELECT * FROM View_KhachHang_SanPham;

--c) Viết các Store Procedure (Thủ tục lưu trữ) sau:
-- SP_TimKH_MaKH: Tìm khách hàng theo mã khách hàng
CREATE PROCEDURE SP_TimKH_MaKH
    @MaKH INT
AS
BEGIN
    SELECT *
    FROM Customers
    WHERE Customer_ID = @MaKH;
END;

EXEC SP_TimKH_MaKH @MaKH = 1;

-- SP_TimKH_MaHD: Tìm thông tin khách hàng theo mã hóa đơn
CREATE PROCEDURE SP_TimKH_MaHD
	@MaHD INT
AS
BEGIN
	SELECT c.*
	FROM Customers c
	INNER JOIN Orders o ON o.Customer_ID = c.Customer_ID
	WHERE  o.Order_ID = @MaHD;
END;

EXEC SP_TimKH_MaHD @MaHD = 123;

-- SP_SanPham_MaKH: Liệt kê các sản phẩm được mua bởi khách hàng có mã được truyền vào Store.
CREATE PROCEDURE SP_SanPham_MaKH
	@MaKH INT
AS
BEGIN
	SELECT p.*
	FROM Products p
	INNER JOIN OrderDetails od ON p.Product_ID = od.Product_ID
	INNER JOIN Orders o ON od.Order_ID = o.Order_ID
	WHERE o.Customer_ID = @MaKH;
END;

EXEC SP_SanPham_MaKH @MaKH = 1;


