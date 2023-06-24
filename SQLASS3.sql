-- CREATE AND RESET: DATABASE
USE Master
GO
IF EXISTS (SELECT * FROM sys.databases WHERE Name='Slot8_Assignment_03')


create database ASS3
go

CREATE TABLE Khach_Hang (
  tenKH VARCHAR(255) not null,
  so_cmt INT not null,
  dia_chi VARCHAR(255) not null,
  PRIMARY KEY (so_cmt)
);

CREATE TABLE Thue_Bao (
  so_thue_bao INT not null,
  loai_thue_bao VARCHAR(255) not null,
  ngay_dang_ky DATE not null,
  PRIMARY KEY (so_thue_bao)
);

CREATE TABLE dang_ky (
  ma_khach_hang INT not null,
  so_thue_bao INT not null,
  ngay_dang_ky DATE not null,
  FOREIGN KEY (ma_khach_hang) REFERENCES khach_hang(so_cmt),
  FOREIGN KEY (so_thue_bao) REFERENCES thue_bao(so_thue_bao),
  PRIMARY KEY (ma_khach_hang, so_thue_bao)
);

INSERT INTO khach_hang (tenKH, so_cmt, dia_chi)
VALUES ('Nguyễn Nguyệt Nga', 123456789, 'Hà Nội');

INSERT INTO thue_bao (so_thue_bao, loai_thue_bao, ngay_dang_ky)
VALUES (123456789, 'Trả trước', '2002-12-12');

INSERT INTO dang_ky (ma_khach_hang, so_thue_bao, ngay_dang_ky)
VALUES (123456789, 123456789, '2002-12-12');

SELECT *
FROM khach_hang
INNER JOIN dang_ky ON khach_hang.so_cmt = dang_ky.ma_khach_hang
INNER JOIN thue_bao ON dang_ky.so_thue_bao = thue_bao.so_thue_bao;


SELECT * FROM thue_bao;

SELECT *
FROM thue_bao
INNER JOIN dang_ky ON thue_bao.so_thue_bao = dang_ky.so_thue_bao
INNER JOIN khach_hang ON dang_ky.ma_khach_hang = khach_hang.so_cmt
WHERE thue_bao.so_thue_bao = '0123456789';

SELECT *
FROM khach_hang
INNER JOIN dang_ky ON khach_hang.so_cmt = dang_ky.ma_khach_hang
INNER JOIN thue_bao ON dang_ky.so_thue_bao = thue_bao.so_thue_bao
WHERE khach_hang.so_cmt = '123456789';


SELECT thue_bao.so_thue_bao
FROM khach_hang
INNER JOIN dang_ky ON khach_hang.so_cmt = dang_ky.ma_khach_hang
INNER JOIN thue_bao ON dang_ky.so_thue_bao = thue_bao.so_thue_bao
WHERE khach_hang.so_cmt = '123456789';

SELECT * FROM dang_ky WHERE ngay_dang_ky = '2002-12-12';


SELECT * FROM Khach_Hang WHERE dia_chi LIKE '%Hà Nội%';


SELECT COUNT(*) AS 'Tổng số khách hàng' FROM khach_hang;

SELECT COUNT(*) AS 'Tổng số thuê bao' FROM thue_bao;

SELECT COUNT(*) AS 'Tổng số thuê bao đăng ký' FROM dang_ky WHERE ngay_dang_ky = '2009-12-12';

SELECT *
FROM khach_hang
INNER JOIN dang_ky ON khach_hang.so_cmt = dang_ky.ma_khach_hang
INNER JOIN thue_bao ON dang_ky.so_thue_bao = thue_bao.so_thue_bao;

ALTER TABLE dang_ky
ALTER COLUMN ngay_dang_ky DATE NOT NULL;

ALTER TABLE dang_ky
ADD CONSTRAINT ngay_dang_ky CHECK (ngay_dang_ky <= CURRENT_DATE);

UPDATE khach_hang
SET so_thue_bao = CONCAT('09', SUBSTRING(so_thue_bao, 3))
WHERE so_thue_bao LIKE '0%';

ALTER TABLE thue_bao ADD diem_thuong INT DEFAULT 0;

ALTER TABLE Phone_numbers
ALTER COLUMN Registration_Date DATE NOT NULL;


ALTER TABLE Phone_numbers
ADD CONSTRAINT Check_Registration_Date
CHECK (Registration_Date <= GETDATE());


UPDATE Phone_numbers
SET Numbers = '09' + RIGHT(Numbers, LEN(Numbers) - 2)
WHERE LEFT(Numbers, 2) != '09';


SELECT * FROM Phone_numbers;



ALTER TABLE Phone_numbers
ADD RewardPoints INT DEFAULT 0;

UPDATE Phone_numbers
SET RewardPoints = 1;
 

CREATE INDEX idx_Customer_name
ON Customers (Customer_name);


CREATE VIEW View_KhachHang AS
SELECT c.Customer_ID, c.Customer_name, c.Address
FROM Customers c;

SELECT * FROM View_KhachHang;


CREATE VIEW View_KhachHang_ThueBao AS
SELECT c.Customer_ID, c.Customer_name, pn.Numbers
FROM Customers c
INNER JOIN Phone_numbers pn ON pn.Customer_ID = c.Customer_ID;

SELECT * FROM View_KhachHang_ThueBao;


CREATE PROCEDURE SP_TimKH_ThueBao 
	@SoTB NVARCHAR(20) 
AS 
BEGIN
	SELECT c.*
	FROM Customers c
	INNER JOIN Phone_numbers pn ON c.Customer_ID = pn.PhoneNumber_ID
	WHERE @SoTB = pn.Numbers
END;
SELECT * FROM Phone_numbers;
EXEC SP_TimKH_ThueBao @SoTB = '093456789';
EXEC SP_TimKH_ThueBao @SoTB = '123456789';


CREATE PROCEDURE SP_TimTB_KhachHang
	@Cus_name NVARCHAR(50)
AS
BEGIN
	SELECT pn.Numbers
	FROM Phone_numbers pn
	INNER JOIN Customers c ON c.Customer_ID = pn.Customer_ID
	WHERE @Cus_name = c.Customer_name
END;

EXEC SP_TimTB_KhachHang @Cus_name = 'Nguyễn Nguyệt Nga';


CREATE PROCEDURE SP_ThemTB
	@PhoneNumber_ID INT,
	@Customer_ID INT,
	@Numbers NVARCHAR(20),
	@Subscriber_type NVARCHAR(255),
	@Registration_Date DATE
AS
BEGIN
	IF EXISTS (SELECT * FROM Customers WHERE Customer_ID = @Customer_ID) AND 
	   NOT EXISTS (SELECT * FROM Phone_numbers WHERE Numbers = @Numbers)
	BEGIN	
		INSERT INTO Phone_numbers
			VALUES (@PhoneNumber_ID, @Customer_ID, @Numbers, @Subscriber_type, @Registration_Date)
		PRINT 'Add new subscriber success'; 
	END
	ELSE
	BEGIN
		PRINT 'CANNOT ADD A Subscriber NUMBER';
	END
END;
DROP PROCEDURE SP_ThemTB;

EXEC SP_ThemTB 2, 1, '0123456', 'aasd', '2023-6-10';
EXEC SP_ThemTB 3, 1, '0123456', 'aasd', '2023-6-10';
EXEC SP_ThemTB 3, 1, '123456789', 'aasd', '2023-6-10';
EXEC SP_ThemTB 3, 1, '04198421', 'ABC', '2023-6-10';

SELECT * FROM Phone_numbers;


CREATE PROCEDURE SP_HuyTB_MaKH
	@MaKH INT
AS
BEGIN
	DELETE FROM Phone_numbers
	WHERE Customer_ID = @MaKH;
END;

EXEC SP_HuyTB_MaKH @MaKH = 1;

SELECT * FROM Phone_numbers;


