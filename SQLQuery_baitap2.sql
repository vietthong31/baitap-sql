CREATE DATABASE baitap2_thong
GO
USE baitap2_thong
GO

-- Tạo bảng: phongban > diadiem_phg, nhanvien, dean > phancong, thannhan

CREATE TABLE phongban
(
	maphg INT NOT NULL,
	tenphg NVARCHAR(30) NOT NULL,
	trphg INT NOT NULL,
	ng_nhanchuc DATE NOT NULL,
	CONSTRAINT kt_nhanchuc CHECK (ng_nhanchuc <= GETDATE()),
	CONSTRAINT pk_phongban PRIMARY KEY (maphg)
)

CREATE TABLE diadiem_phg
(
	maphg INT NOT NULL,
	diadiem NVARCHAR(20) NOT NULL,
	CONSTRAINT pk_diadiemphg PRIMARY KEY (maphg, diadiem),
	CONSTRAINT fk_diadiem_phongban FOREIGN KEY (maphg) REFERENCES phongban(maphg) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE nhanvien
(
	manv INT NOT NULL,
	honv NVARCHAR(10) NOT NULL,
	tenlot NVARCHAR(20) NOT NULL,
	tennv NVARCHAR(10) NOT NULL,
	ngsinh DATE NOT NULL,
	dchi NVARCHAR(100) NOT NULL,
	phai BIT NOT NULL,
	luong INT NOT NULL,
	ma_nql INT,
	phg INT NOT NULL,
	CONSTRAINT kt_ngsinh CHECK (YEAR(ngsinh) < YEAR(GETDATE())),
	CONSTRAINT kt_luong CHECK (luong > 0),
	CONSTRAINT pk_nhanvien PRIMARY KEY (manv),
	CONSTRAINT fk_nhanvien_phongban FOREIGN KEY (phg) REFERENCES phongban(maphg) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE dean
(
	mada INT NOT NULL,
	tenda NVARCHAR(40) NOT NULL,
	ddiem_da NVARCHAR(20) NOT NULL,
	phong INT NOT NULL,
	CONSTRAINT pk_dean PRIMARY KEY (mada),
	CONSTRAINT fk_dean_phongban FOREIGN KEY (phong) REFERENCES phongban(maphg) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE phancong
(
	ma_nvien INT NOT NULL,
	soda INT NOT NULL,
	thoigian DECIMAL(3,1),
	CONSTRAINT kt_thoigian CHECK (thoigian > 0),
	CONSTRAINT pk_phancong PRIMARY KEY (ma_nvien, soda),
	CONSTRAINT fk_phancong_dean FOREIGN KEY (soda) REFERENCES dean(mada) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE thannhan
(
	ma_nvien INT NOT NULL,
	tentn NVARCHAR(30) NOT NULL,
	phai BIT NOT NULL,
	ngsinh DATE NOT NULL,
	quanhe NVARCHAR(20) NOT NULL,
	CONSTRAINT kt_ngsinh_thannhan CHECK (ngsinh < GETDATE()),
	CONSTRAINT pk_thannhan PRIMARY KEY (ma_nvien, tentn),
	CONSTRAINT fk_thannhan_nhanvien FOREIGN KEY (ma_nvien) REFERENCES nhanvien(manv)
)

-- insert data - phongban -> nhanvien, dean -> phancong, diadiem_phg, thannhan

INSERT INTO phongban(tenphg, maphg, trphg, ng_nhanchuc) VALUES
(N'Nghiên cứu', 5, 333445555, '1978-05-22'),
(N'Điều hành', 4, 987987987, '1985-01-01'),
(N'Quản lý', 1, 888665555, '1971-06-19')
SELECT * FROM phongban


INSERT INTO nhanvien(honv, tenlot, tennv, manv, ngsinh, dchi, phai, luong, ma_nql, phg) VALUES
(N'Đinh', 'Ba', 'Tien', 123456789, '1955-01-09', N'731 Trần Hưng Đạo, Q1, TPHCM', 1, 30000, 333445555, 5),
('Nguyen', 'Thanh', 'Tung', 333445555, '1945-12-08', N'638 Nguyễn Văn Cừ, Q5, TPHCM', 1, 40000, 888665555, 5),
('Bui', 'Thuy', 'Vu', 999887777, '1958-07-19', N'332 Nguyễn Thái Học, Q1, TPHCM', 1, 25000, 987654321, 4),
('Le', 'Thi', 'Nhan', 987654321, '1931-06-20', N'291 Hồ văn Huê, QPN, TPHCM', 0, 43000, 888665555, 4),
('Nguyen', 'Manh', 'Hung', 666884444, '1952-09-15', N'975 Bà Rịa, Vũng Tàu', 1, 38000, 333445555, 5),
('Tran', 'Thanh', 'Tam', 453453453, '1962-07-31', N'543 Mai Thị Lựu, Q1, TPHCM', 1, 25000, 333445555, 5),
('Tran', 'Hong', 'Quang', 987987987, '1959-03-29', N'980 Lê Hồng Phong, Q10, TPHCM', 1, 25000, 987654321, 4),
('Vuong', 'Ngoc', 'Quyen', 888665555, '1927-10-10', N'450 Trưng Vương, Hà Nội', 0, 55000, NULL, 1)
SELECT * FROM nhanvien


INSERT INTO dean(tenda, mada, ddiem_da, phong) VALUES
(N'Sản phẩm X', 1, N'VŨNG TÀU', 5),
(N'Sản phẩm Y', 2, N'NHA TRANG', 5),
(N'Sản phẩm Z', 3, 'TP HCM', 5),
('Tin hoc hoa', 10, N'HÀ NỘI', 4),
(N'Cáp quang', 20, 'TP HCM', 1),
(N'Đào tạo', 30, N'HÀ NỘI', 4)
SELECT * FROM dean


INSERT INTO phancong(ma_nvien, soda, thoigian) VALUES
(123456789, 1, 32.5),
(123456789, 2, 7.5),
(666884444, 3, 40.0),
(453453453, 1, 20.0),
(453453453, 2, 20.0),
(333445555, 3, 10.0),
(333445555, 10, 10.0),
(333445555, 20, 10.0),
(999887777, 30, 30.0),
(999887777, 10, 30.0),
(987987987, 10, 35.0),
(987987987, 30, 5.0),
(987654321, 30, 20.0),
(987654321, 20, 15.0),
(888665555, 20, NULL)
SELECT * FROM phancong


INSERT INTO diadiem_phg(maphg, diadiem) VALUES
(1,'TP HCM'),
(4, N'HÀ NỘI'),
(5, N'VŨNG TÀU'),
(5, 'NHA TRANG'),
(5, 'TP HCM')
SELECT * FROM diadiem_phg


INSERT INTO thannhan(ma_nvien, tentn, phai, ngsinh, quanhe) VALUES
(333445555, 'Quang', 0, '1976-04-05', N'Con gái'),
(123456789, 'Duy', 1, '1978-01-01', 'Con trai'),
(333445555, 'Khang', 1, '1973-10-25', 'Con trai'),
(333445555, 'Duong', 0, '1948-05-03', N'Vợ chồng'),
(987654321, 'Dang', 1, '1932-02-29', N'Vợ chồng'),
(123456789, 'Chau', 0, '1978-12-31', N'Con gái'),
(123456789, 'Phuong', 0, '1957-05-05', N'Vợ chồng')
SELECT * FROM thannhan

-- QUERY:

-- 1. Tìm tên và địa chỉ của các nhân viên của phòng "Nghien cuu"
SELECT tennv 'Tên nhân viên', dchi 'Địa chỉ'
FROM nhanvien, phongban
WHERE nhanvien.phg = phongban.maphg AND phongban.tenphg = N'Nghiên cứu'

/*
2. Với các đề án ở "HA NOI", liệt kê các mã số đề án (MADA), mã số phòng ban chủ trì đề án (PHONG),
họ tên trưởng phòng (TENNV, HONV) cũng như địa chỉ (DCHI) và ngày sinh (NGSINH) của người ấy.
*/
SELECT mada 'Mã đề án', phong 'Phòng', tennv 'Tên', honv 'Họ', dchi 'Địa chỉ', ngsinh 'Ngày sinh'
FROM nhanvien, phongban, dean
WHERE nhanvien.phg = phongban.maphg AND phongban.maphg = dean.phong AND dean.ddiem_da = N'HÀ NỘI' AND manv IN (SELECT trphg FROM phongban)

-- 3. Tìm tên (TENNV, HONV) của các nhân viên làm việc cho tất cả các đề án mà phòng số 5 chủ trì
SELECT honv, tenlot, tennv FROM nhanvien WHERE manv IN
(
	SELECT ma_nvien
	FROM phancong, dean
	WHERE phancong.soda = dean.mada AND phong = 5
	GROUP BY ma_nvien
	HAVING COUNT(ma_nvien) = (SELECT COUNT(mada) FROM dean WHERE phong = 5)
)

SELECT ma_nvien
FROM phancong
WHERE soda IN (SELECT mada FROM dean WHERE phong = 5)
GROUP BY ma_nvien
HAVING COUNT(ma_nvien) = (SELECT COUNT(mada) FROM dean WHERE phong = 5)

/*
4. Danh sách các đề án (MADA) có:
	- nhân công với họ (HONV) là "Dinh" hoặc,
	- có người trưởng phòng chủ trì đề án với họ (HONV) là "Dinh".
*/
SELECT mada FROM dean, phancong, phongban
WHERE dean.mada = phancong.soda AND dean.phong = phongban.maphg
	  AND (ma_nvien = (SELECT manv FROM nhanvien WHERE honv = N'Đinh') OR trphg = (SELECT manv FROM nhanvien WHERE honv = N'Đinh'))


-- 5. Danh sách những nhân viên (HOVN, TENNV) có trên 2 thân nhân.
SELECT honv 'Họ', tennv 'Tên', COUNT(tentn) AS [Số thân nhân]
FROM nhanvien, thannhan
WHERE nhanvien.manv = thannhan.ma_nvien
GROUP BY honv, tennv
HAVING COUNT(ma_nvien) > 2

-- 6. Danh sách những nhân viên (HOVN, TENNV) không có thân nhân nào.
SELECT honv 'Họ', tennv 'Tên'
FROM nhanvien
WHERE manv NOT IN (SELECT DISTINCT ma_nvien FROM thannhan)

-- 7. Danh sách những trưởng phòng có tối thiểu một thân nhân.
SELECT honv 'Họ', tennv 'Tên'
FROM nhanvien, thannhan
WHERE nhanvien.manv = thannhan.ma_nvien AND manv IN (SELECT trphg FROM phongban)
GROUP BY honv, tennv
HAVING COUNT(ma_nvien) >= 1

-- 8. Tên những nhân viên phòng số 5 có tham gia vào đề án San pham X với thời gian làm việc trên 10 giờ / tuần
-- Mã đề án San pham X:
SELECT mada FROM dean WHERE tenda = N'Sản phẩm X'
-- Mã nhân viên tham gia đề án San pham X với thời gian làm việc trên 10 giờ/ tuần:
SELECT ma_nvien FROM phancong WHERE soda = (SELECT mada FROM dean WHERE tenda = N'Sản phẩm X') AND thoigian > 10

SELECT honv + ' ' + tenlot + ' ' + tennv 'Tên nhân viên'
FROM nhanvien
WHERE phg = 5 AND manv IN (SELECT ma_nvien FROM phancong WHERE soda = (SELECT mada FROM dean WHERE tenda = N'Sản phẩm X') AND thoigian > 10)

-- 9. Danh sách những nhân viên (HONV, TENNV) có cùng tên với người thân.
SELECT tennv 'Tên nhân viên'
FROM nhanvien, thannhan
WHERE nhanvien.manv = thannhan.ma_nvien AND tennv = tentn

-- 10. Danh sách những nhân viên (HONV, TENNV) được "Nguyen Thanh Tung" phụ trách trực tiếp.
SELECT honv 'Họ', tennv 'Tên'
FROM nhanvien
WHERE ma_nql = (SELECT manv FROM nhanvien WHERE CONCAT(honv, ' ', tenlot, ' ', tennv) = 'Nguyen Thanh Tung')

-- 11. Với mỗi đề án, liệt kê tên đề án (TENDA) và tổng số giờ làm việc của tất cả các nhân viên tham dự đề án đó.
SELECT tenda 'Tên đề án', SUM(thoigian) 'Tổng thời gian'
FROM dean, phancong
WHERE dean.mada = phancong.soda
GROUP BY tenda

-- 12. Danh sách những nhân viên (HONV, TENNV) làm việc cho tất cả đề án.
INSERT INTO phancong(ma_nvien, soda, thoigian) VALUES
(123456789, 3, 20.0),
(123456789, 10, 10.0),
(123456789, 20, 10.0),
(123456789, 30, 10.0)

SELECT honv 'Họ', tennv 'Tên' FROM nhanvien
WHERE manv IN (
		SELECT ma_nvien
		FROM phancong
		GROUP BY ma_nvien
		HAVING COUNT(ma_nvien) = (SELECT COUNT(tenda) FROM dean)
)

-- 13. Danh sách những nhân viên (HONV, TENNV) không làm việc cho một đề án nào.
SELECT honv 'Họ', tennv 'Tên'
FROM nhanvien
WHERE manv NOT IN (SELECT ma_nvien FROM phancong)

-- 14. Với mỗi phòng ban, liệt kê tên phòng ban (TENPHG) và lương trung bình của những nhân viên làm việc cho phòng ban đó.
SELECT tenphg, AVG(luong) 'Lương trung bình'
FROM phongban, nhanvien
WHERE phongban.maphg = nhanvien.phg
GROUP BY tenphg

-- 15. Lương trung bình của tất cả các nữ nhân viên.
SELECT AVG(luong) 'Lương trung bình (nữ)'
FROM nhanvien
WHERE phai = 0

/* 
16. Tìm họ tên (honv, tenlot, tennv) và địa chỉ (dchi) của những nhân viên làm việc cho một đề án ở TPHCM 
	nhưng phòng ban mà họ trực thuộc tất cả không toạ lạc ở TPHCM 
*/
SELECT manv, honv, tenlot, tennv, dchi FROM nhanvien
WHERE manv IN (SELECT ma_nvien FROM phancong, dean WHERE phancong.soda = dean.mada AND ddiem_da = 'TP HCM')
	  AND phg NOT IN (SELECT maphg FROM diadiem_phg WHERE diadiem = 'TP HCM')

-- 17. Tìm họ (HONV) của những trưởng phòng chưa có gia đình.
SELECT honv FROM nhanvien
WHERE manv IN
(
	SELECT trphg FROM phongban -- trưởng phòng
	WHERE trphg NOT IN (SELECT ma_nvien FROM thannhan) -- không có trong bản thannhan
)

/*
18. Tổng quát câu 16, tìm họ tên và địa chỉ của các nhân viên làm việc cho một đề án ở một thành phố 
	nhưng phòng ban mà họ trực thuộc tất cả không toạ lạc ở thành phố đó.
*/


-- 19. Cho biết họ tên nhân viên (HONV, TENNV) có mức lương trên mức lương trung bình của phòng "Nghien cuu".
-- Mức lương trung bình phòng nghiên cứu:
SELECT AVG(luong) FROM nhanvien WHERE phg = (SELECT maphg FROM phongban WHERE tenphg = N'Nghiên cứu')

-- Các nhân viên có lương trên mức lương trung bình phòng nghiên cứu:
SELECT honv, tennv FROM nhanvien
WHERE luong > (SELECT AVG(luong) FROM nhanvien WHERE phg = (SELECT maphg FROM phongban WHERE tenphg = N'Nghiên cứu'))

-- 20. Với các phòng ban có mức lương trung bình trên 30,000. Liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó.
SELECT tenphg 'Tên phòng', COUNT(manv) 'Số lượng nhân viên'
FROM nhanvien, phongban
WHERE nhanvien.phg = phongban.maphg
GROUP BY tenphg
HAVING AVG(luong) > 30000

-- 21. Cho biết họ tên nhân viên (HONV, TENNV) và tên các đề án mà nhân viên ấy tham gia nếu có.


-- 22. Cho biết phòng ban họ tên trưởng phòng của phòng ban có đông nhân viên nhất.
-- Số nhân viên đông nhất (trong 1 phòng):
SELECT TOP 1 COUNT(phg) FROM nhanvien GROUP BY phg ORDER BY COUNT(phg) DESC
-- Các phòng có đông nhân viên nhất:
SELECT phg FROM nhanvien GROUP BY phg HAVING COUNT(phg) = (SELECT TOP 1 COUNT(phg) FROM nhanvien GROUP BY phg ORDER BY COUNT(phg) DESC)

-- Phòng ban, họ tên trưởng phòng có đông nhân viên nhất:
SELECT tenphg, honv, tennv
FROM phongban, nhanvien
WHERE nhanvien.phg = phongban.maphg 
	  AND manv IN (SELECT trphg FROM phongban)
	  AND phg IN (
				 SELECT phg FROM nhanvien 
				 GROUP BY phg 
				 HAVING COUNT(phg) = (SELECT TOP 1 COUNT(phg) FROM nhanvien GROUP BY phg ORDER BY COUNT(phg) DESC)
				 )