CREATE DATABASE baitap3_thong
GO
USE baitap3_thong
GO

CREATE TABLE KHOAHOC
(
	makh VARCHAR(10) NOT NULL,
	tenkh NVARCHAR(60) NOT NULL,
	bd DATE NOT NULL,
	kt DATE NOT NULL,
	-- Tạo ràng buộc ngày bắt đầu & kết thúc
	CONSTRAINT kt_ngaythang CHECK (bd < kt),
	-- Tạo khoá chính: makh
	CONSTRAINT pk_khoahoc PRIMARY KEY (makh)
)

CREATE TABLE HOCVIEN
(
	mahv INT NOT NULL,
	ho NVARCHAR(30) NOT NULL,
	ten NVARCHAR(10) NOT NULL,
	ntns DATE NOT NULL,
	dchi NVARCHAR(60) NOT NULL,
	nnghiep NVARCHAR(50) NOT NULL,
	CONSTRAINT kt_ntns_hv CHECK (YEAR(ntns) < YEAR(GETDATE()) ),
	-- Tạo khoá chính: mahv
	CONSTRAINT pk_hocvien PRIMARY KEY (mahv)
)

CREATE TABLE GIAOVIEN
(
	magv INT NOT NULL,
	hoten NVARCHAR(50) NOT NULL,
	ntns DATE NOT NULL,
	dc NVARCHAR(60) NOT NULL,
	CONSTRAINT kt_ntns_gv CHECK (YEAR(GETDATE()) - YEAR(ntns) > 18),
	-- Tạo khoá chính: magv
	CONSTRAINT pk_giaovien PRIMARY KEY (magv)
)

CREATE TABLE LOPHOC
(
	malop INT NOT NULL,
	tenlop NVARCHAR(40) NOT NULL,
	makh VARCHAR(10) NOT NULL,
	magv INT NOT NULL,
	sisodk INT NOT NULL,
	ltrg INT,
	phhoc VARCHAR(20) NOT NULL,
	CONSTRAINT kt_sisodk CHECK (sisodk > 0),
	-- Tạo khoá chính: malop
	CONSTRAINT pk_lophoc PRIMARY KEY (malop),
	-- Tạo khoá ngoại: makh & magv
	CONSTRAINT fk_lophoc_khoahoc FOREIGN KEY (makh) REFERENCES KHOAHOC(makh) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_lophoc_giaovien FOREIGN KEY (magv) REFERENCES GIAOVIEN(magv) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE BIENLAI
(
	makh VARCHAR(10) NOT NULL,
	malh INT NOT NULL,
	mahv INT NOT NULL,
	sobl INT NOT NULL,
	diem DECIMAL(2,1) NOT NULL,
	kqua BIT NOT NULL,
	xeploai NVARCHAR(10) NOT NULL,
	tiennop DECIMAL(6,3),
	-- Ràng buộc:
	CONSTRAINT kt_diem CHECK (diem >= 0 AND diem <= 10),
	CONSTRAINT kt_xeploai CHECK (xeploai in (N'KHÁ', N'GIỎI', 'TB', N'YẾU')),
	CONSTRAINT kt_tiennop CHECK (tiennop > 0),
	-- Tạo khoá chính: sobl
	CONSTRAINT pk_bienlai PRIMARY KEY (sobl),
	-- Tạo khoá ngoại: makh & mahv
	CONSTRAINT fk_bienlai_hocvien FOREIGN KEY (mahv) REFERENCES HOCVIEN(mahv) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_bienlai_lophoc FOREIGN KEY (malh) REFERENCES LOPHOC(malop) ON UPDATE CASCADE ON DELETE CASCADE
)

-- INSERT DATA: giaovien, hocvien, khoahoc -> lophoc, bienlai

INSERT INTO GIAOVIEN(magv, hoten, ntns, dc) VALUES
(1, N'Trần Thanh', '1959-01-02', N'12/4 Trần B. Trọng Q1'),
(2, N'Nguyễn Nam', '1960-02-04', N'30 Điện Biên Phủ Q1'),
(3, N'Hồ Nhân', '1960-03-04', N'123 Hồ Quý Cáp Q1'),
(4, N'Dương Hùng', '1958-03-03', N'23 Hai Bà Trưng'),
(5, N'Lê Thương', '1965-05-07', N'61/4 Huỳnh Mẫn Đạt')
SELECT * FROM GIAOVIEN


INSERT INTO HOCVIEN(mahv, ho, ten, ntns, dchi, nnghiep) VALUES
(0, N'Hồ Thanh', N'Sơn', '1968-01-01', N'209 Trần Hưng Đạo Q5', N'Bác sĩ'),
(1, N'Trần Tâm', 'Thanh', '1960-03-04', '109/2 CMTT F10 QTB', N'Giáo viên'),
(2, N'Đỗ Nghiêm', 'Phung', '1979-01-12', N'34 Vo Duy Duong Q5', N'Học sinh'),
(3, N'Trần Nam', N'Sơn', '1980-08-03', N'190/2A Hồ Tùng Mậu Q1', N'Học sinh'),
(4, N'Nguyễn Tiến', N'Dũng', '1969-03-04', N'23/8 Thái Văn Lung Q1', N'Giáo viên'),
(5, 'Mai Thanh', 'Nam', '1976-08-02', '12 DBP Q1', N'Công nhân'),
(6, N'Trần Đoàn', N'Hùng', '1968-01-19', '189 Tran Van Bo Q4', N'Giáo viên'),
(7, N'Nguyễn Mạnh', N'Hùng', '1967-01-29', N'68 Nguyễn Thiện Thuật Q3', N'Diễn viên'),
(8, N'Trần Văn', N'Tiên', '1979-02-03', N'18 Lê Duẩn Q1', N'Thợ may'),
(9, N'Nguyễn Thị Khánh', N'Vân', '1959-04-03', N'48/3 Hồ Tùng Mậu Q1', N'Nội trợ'),
(10, N'Trần Định Lê', N'Hương', '1970-03-07', N'44A Cư xá Tự Do F4 QTB', N'Người mẫu'),
(11, N'Lê Thị Gia', N'Trần', '1968-03-19', N'34 Lý Thường Kiệt QTB', N'Giáo viên'),
(12, N'Nguyễn Thị Kim', N'Cương', '1969-05-28', N'356/2F Lý Thường Kiệt QTB', N'Thợ may'),
(13, N'Nguyễn Thị Tuyết', 'Anh', '1968-04-02', N'789 Phan Đăng Lưu QBT', N'Bán hàng'),
(15, N'Nguyễn Thị Hồng', 'Loan', '1970-03-06', '567/23 XVNT P25 QBT', N'Người mẫu'),
(16, N'Nguyễn Thị Kim', 'Thoa', '1971-02-20', N'34 Thala Tân Biên Tây Ninh', N'Bán hàng'),
(17, N'Nguyễn Thị Kim', 'Mai', '1969-02-07', '78 XVNT QBT', N'Thợ may'),
(19, N'Nguyễn Tường', 'Lan', '1971-09-30', '456 CNTT F13 QTB', N'Sinh viên'),
(20, N'Nguyễn Thị Ngọc', 'Mai', '1956-12-12', N'124 Nguyễn Duy Dương Q5', N'Bán hàng'),
(21, N'Trần Thị Khánh', N'Tường', '1970-03-02', N'24 Lý Thường Kiệt QTB', N'Bác sĩ'),
(22, N'Nguyễn Hà', N'Thảo', '1973-03-19', N'56 Bùi Đình Tuý QTB', N'Kỹ sư'),
(23, N'Nguyễn Thị Kim', N'Ngân', '1969-03-04', N'178 Võ T. Trang F11 QTB', N'Thợ uốn tóc')
SELECT * FROM HOCVIEN


INSERT INTO KHOAHOC(makh, tenkh, bd, kt) VALUES
('PT197', N'Tiếng Pháp phổ thông khoá 1/97', '1997-02-15', '1997-05-15'),
('PT297', N'Tiếng Pháp phổ thông khoá 2/97', '1997-05-30', '1997-08-30'),
('CT297', N'Tiếng Pháp chuyên từ khoá 2/97', '1997-05-30', '1997-08-30')
SELECT * FROM KHOAHOC


INSERT INTO LOPHOC(malop, tenlop, makh, magv, sisodk, ltrg, phhoc) VALUES
(1, N'Tiếng Pháp phổ Thông 1.1', 'PT197', 1, 10, 9, '101'),
(2, N'Tiếng Pháp phổ Thông 2.1', 'PT297', 2, 10, 6, '201'),
(3, N'Tiếng Pháp phổ thông 1.2', 'PT297', 3, 20, 17, '202'),
(4, N'Tiếng Pháp chuyên từ A', 'CT297', 4, 15, NULL, '203')
SELECT * FROM LOPHOC


-- varchar int int int decimal(2,1) bit varchar decimal(6,3)
INSERT INTO BIENLAI(makh, malh, mahv, sobl, diem, kqua, xeploai, tiennop) VALUES
('PT197', 1, 1, 1, 8,     1, N'KHÁ', 100.000),
('PT197', 1, 2, 2, 4,     0, N'YẾU', 100.000),
('PT197', 1, 3, 3, 4,     0, N'YẾU', 100.000),
('PT197', 1, 4, 4, 3,     0, N'YẾU', 100.000),
('PT197', 1, 5, 5, 4,     0, N'YẾU', 100.000),
('PT197', 1, 6, 6, 9,     1, N'GIỎI', 100.000),
('PT197', 1, 7, 7, 6.5,   1, 'TB', NULL),
('PT197', 1, 8, 8, 5,     1, 'TB', 100.000),
('PT197', 1, 9, 9, 7,     1, N'KHÁ', 100.000),
('PT197', 1, 10, 10, 8,   1, N'KHÁ', 100.000),
('PT197', 1, 11, 11, 6,   1, N'TB', 100.000),
('PT197', 1, 12, 12, 9,   1, N'GIỎI', 100.000),
('PT197', 1, 0, 34, 3,    0, N'YẾU', NULL),
('PT297', 2, 1, 13, 4,    0, N'YẾU', 100.000),
('PT297', 2, 13, 14, 7,   1, N'GIỎI', 100.000),
('PT297', 2, 3, 15, 2,    0, N'YẾU', 100.000),
('PT297', 2, 15, 17, 6,   1, N'TB', 100.000),
('PT297', 2, 6, 18, 9,    1, N'GIỎI', NULL),
('PT297', 2, 7, 19, 6.5,  1, 'TB', 100.000),
('PT297', 2, 8, 20, 4.5,  0, N'YẾU', NULL),
('PT297', 2, 9, 21, 8,    1, N'KHÁ', 100.000),
('PT297', 2, 10, 22, 9.5, 1, N'GIỎI', 100.000),
('PT297', 2, 11, 23, 7,   1, N'KHÁ', 100.000),
('PT297', 3, 16, 24, 5,   1, 'TB', 100.000),
('PT297', 3, 17, 25, 9,   1, N'GIỎI', 100.000),
('PT297', 3, 19, 27, 9,   1, N'GIỎI', 100.000),
('PT297', 3, 20, 28, 5,   1, 'TB', 100.000),
('PT297', 3, 21, 29, 3,   0, N'YẾU', 100.000),
('PT297', 3, 22, 30, 6.5, 1, 'TB', 100.000),
('PT297', 3, 23, 31, 7.5, 1, N'KHÁ', 100.000)
SELECT * FROM BIENLAI


-- QUERY:

-- 1. Cho biết kết quả cuối khoá (điểm, kết quả, xếp loại) của các học viên do giáo viên "Tran Thanh" hoặc "Ho Nhan" dạy trong khoá có mã số "PT197".
SELECT ho 'Họ', ten 'Tên', tenlop 'Tên lớp', diem 'Điểm', CASE WHEN kqua = 0 THEN N'Không đậu' ELSE N'Đậu' END AS [Kết quả], xeploai 'Xếp loại'
FROM BIENLAI, HOCVIEN, LOPHOC, GIAOVIEN
WHERE BIENLAI.mahv = HOCVIEN.mahv AND BIENLAI.malh = LOPHOC.malop AND LOPHOC.magv = GIAOVIEN.magv 
	  AND (GIAOVIEN.hoten = N'Trần Thanh' OR GIAOVIEN.hoten = N'Hồ Nhân')
	  AND BIENLAI.makh = 'PT197'

-- 2. Cho biết danh sách lớp học và số lượng học viên thực sự của lớp đó.
SELECT tenlop 'Tên lớp', COUNT(mahv) 'Số lượng học viên'
FROM BIENLAI, LOPHOC
WHERE BIENLAI.malh = LOPHOC.malop
GROUP BY tenlop

-- 3. Cho biết họ tên, NTNS, địa chỉ của học viên có điểm cao nhất trong khoá có mã số "PT297"
SELECT ho 'Họ', ten 'Tên', ntns 'NTNS', dchi 'Địa chỉ'
FROM HOCVIEN, BIENLAI
WHERE HOCVIEN.mahv = BIENLAI.mahv AND diem = (SELECT TOP 1 diem FROM BIENLAI ORDER BY diem DESC) AND BIENLAI.makh = 'PT297'

-- 4. Cho biết tên các lớp học và điểm trung bình, điểm cao nhất của tất cả học viên trong lớp.
SELECT tenlop 'Tên lớp', AVG(diem) 'Điểm trung bình', MAX(diem) 'Điểm cao nhất'
FROM LOPHOC, BIENLAI
WHERE BIENLAI.malh = LOPHOC.malop
GROUP BY tenlop

-- 5. Cho biết tên lớp học và lượng số học viên xếp loại khá hoặc giỏi trong lớp đó.
SELECT tenlop 'Tên lớp', COUNT(xeploai) 'Xếp loại (khá/ giỏi)'
FROM BIENLAI, LOPHOC
WHERE BIENLAI.malh = LOPHOC.malop AND (xeploai = N'KHÁ' OR xeploai = N'GIỎI')
GROUP BY tenlop

-- 6. Cho biết họ tên những học viên, tên lớp học mà học viên đó theo học và số biên lai tương ứng, các lớp này phải thuộc về các khoá học kết thúc trước 30/5/97.
SELECT ho 'Họ', ten 'Tên', tenlop 'Tên lớp học', sobl 'Số biên lai'
FROM BIENLAI, HOCVIEN, LOPHOC
WHERE BIENLAI.mahv = HOCVIEN.mahv AND BIENLAI.malh = LOPHOC.malop
	  AND malh IN (SELECT malop FROM LOPHOC, KHOAHOC WHERE KHOAHOC.makh = LOPHOC.makh AND kt < '1997-05-30')

-- 7. Cho biết tên những lớp học có sỉ số thực sự vượt sĩ số dự kiến
SELECT tenlop 'Tên lớp'
FROM LOPHOC, BIENLAI
WHERE BIENLAI.malh = LOPHOC.malop
GROUP BY tenlop, sisodk
HAVING COUNT(mahv) > sisodk

-- 8. Cho biết tên và mã số các lớp học có sỉ số thực sự ít nhất.
SELECT TOP 1 COUNT(mahv) FROM bienlai GROUP BY malh ORDER BY malh DESC -- Số học viên ít nhất trong 1 lớp.

SELECT malop 'Mã lớp', tenlop 'Tên lớp'
FROM LOPHOC, BIENLAI
WHERE BIENLAI.malh = LOPHOC.malop
GROUP BY malop, tenlop
HAVING COUNT(mahv) = (SELECT TOP 1 COUNT(mahv) FROM bienlai GROUP BY malh ORDER BY malh DESC)

-- 9. Cho biết họ tên, địa chỉ của những học viên là giáo viên đồng thời là lớp trưởng.
SELECT ho 'Họ', ten 'Tên', dchi 'Địa chỉ'
FROM HOCVIEN
WHERE nnghiep = N'Giáo viên' AND mahv IN (SELECT ltrg FROM LOPHOC)

-- 10. Cho biết họ tên và số lượng lớp mà giáo viên đó đã dạy.
SELECT hoten 'Họ tên', COUNT(LOPHOC.magv)
FROM GIAOVIEN, LOPHOC
WHERE LOPHOC.magv = GIAOVIEN.magv
GROUP BY hoten

-- 11. Cho biết họ tên và kết quả học tập (điểm, xếp loại, kết quả) của những học viên được học miễn phí.
SELECT ho 'Họ', ten 'Tên', diem 'Điểm', tenlop 'Lớp học', CASE kqua WHEN 1 THEN N'ĐẬU' ELSE N'KHÔNG ĐẬU' END 'Kết quả', xeploai 'Xếp loại'
FROM BIENLAI, HOCVIEN, LOPHOC
WHERE BIENLAI.mahv = HOCVIEN.mahv AND BIENLAI.malh = LOPHOC.malop AND tiennop IS NULL

-- 12. Cho biết tên các khoá học và số lượng các lớp học trong khoá.
SELECT tenkh 'Tên khoá học', COUNT(LOPHOC.makh) 'Số lượng lớp học'
FROM KHOAHOC, LOPHOC
WHERE KHOAHOC.makh = LOPHOC.makh
GROUP BY tenkh

-- 13. Cho biết tên các lớp học, tên giáo viên phụ trách, sỉ số dự kiến của lớp và phòng học của các lớp học đang diễn ra vào ngày 17/4/97.
SELECT tenlop 'Tên lớp', hoten 'Giáo viên', sisodk 'Sỉ số dự kiến', phhoc 'Phòng'
FROM LOPHOC, GIAOVIEN
WHERE LOPHOC.magv = GIAOVIEN.magv AND makh = (SELECT makh FROM KHOAHOC WHERE bd <= '1997-04-17' AND kt >= '1997-04-17')

-- 14.Cho biết họ tên và kết quả học tập của những học viên lớp trưởng của từng lớp.
SELECT tenlop 'Lớp', ho 'Họ', ten 'Tên', BIENLAI.makh 'Mã KH', diem 'Điểm', CASE kqua WHEN 1 THEN N'ĐẬU' ELSE N'KHÔNG ĐẬU' END 'Kết quả', xeploai 'Xếp loại'
FROM BIENLAI, HOCVIEN, LOPHOC
WHERE BIENLAI.malh = LOPHOC.malop AND BIENLAI.mahv = HOCVIEN.mahv AND BIENLAI.mahv IN (SELECT ltrg FROM LOPHOC)

-- 15. Cho biết tên lớp học và số lượng số học viên "không đậu", số lượng số học viên xếp loại trung bình hoặc yếu trong lớp đó.

-- Tên lớp học & số lượng học viên không đậu:
SELECT tenlop AS 'Tên lớp', COUNT(kqua) '(không đậu)'
FROM LOPHOC, BIENLAI
WHERE BIENLAI.malh = LOPHOC.malop AND kqua = 0
GROUP BY tenlop

-- Tên lớp học & số lượng học viên xếp loại trung bình hoặc yếu:
SELECT tenlop 'Tên lớp', COUNT(xeploai) 'Xếp loại (TB/ YẾU)'
FROM LOPHOC, BIENLAI
WHERE BIENLAI.malh = LOPHOC.malop AND xeploai IN ('TB', N'YẾU')
GROUP BY tenlop

-- 16. Cho biết mã số và họ tên những học viên ở lại lớp ít nhất 1 lần.
SELECT BIENLAI.mahv 'Mã số', ho 'Họ', ten 'Tên', COUNT(kqua) '(không đậu)'
FROM BIENLAI, HOCVIEN
WHERE BIENLAI.mahv = HOCVIEN.mahv AND (kqua) = 0
GROUP BY ho, ten, BIENLAI.mahv, kqua
HAVING COUNT(kqua) >= 1

-- 17. Cho biết các học viên có Họ "Nguyễn".
SELECT *
FROM HOCVIEN
WHERE ho LIKE N'Nguyễn%'

-- 18. Cho biết các học viên học tất cả các khoá "Tiếng Pháp phổ thông" mở vào năm 1997.
SELECT BIENLAI.mahv, ho 'Họ', ten 'Tên'
FROM BIENLAI, HOCVIEN
WHERE BIENLAI.mahv = HOCVIEN.mahv AND makh IN (SELECT makh FROM KHOAHOC WHERE tenkh LIKE N'Tiếng Pháp phổ thông%' AND YEAR(bd) = '1997')
GROUP BY BIENLAI.mahv, ho, ten
HAVING COUNT(makh) = (SELECT COUNT(makh) FROM KHOAHOC WHERE tenkh LIKE N'Tiếng Pháp phổ thông%' AND YEAR(bd) = '1997')

-- 19. Cho biết các học viên luôn luôn xếp loại GIỎI trong tất cả các khoá theo học.
SELECT ho 'Họ', ten 'Tên'
FROM BIENLAI, HOCVIEN
WHERE BIENLAI.mahv = HOCVIEN.mahv
GROUP BY ho, ten
HAVING COUNT(makh) = COUNT(CASE WHEN xeploai = N'GIỎI' THEN 1 ELSE NULL END)

-- 20. Cho biết 3 số biên lai của khoá "PT197" có điểm xếp cao nhất.
SELECT TOP 3 sobl 'Số biên lai'
FROM BIENLAI
WHERE makh = 'PT197' AND diem = (SELECT TOP 1 diem FROM BIENLAI WHERE makh = 'PT197' ORDER BY diem DESC)

SELECT TOP 3 sobl 'Số biên lai'
FROM BIENLAI
WHERE makh = 'PT197'
ORDER BY diem DESC