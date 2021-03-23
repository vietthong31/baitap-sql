CREATE DATABASE baitap1_thong
GO
USE baitap1_thong
GO

CREATE TABLE SVIEN
(
	ten NVARCHAR(30) NOT NULL,
	masv INT NOT NULL,
	nam TINYINT,
	khoa VARCHAR(10) NOT NULL,
	CONSTRAINT kt_masv CHECK (masv > 0),
	-- Tạo khoá chính MASV --
	CONSTRAINT pk_svien PRIMARY KEY (masv)
)

CREATE TABLE MHOC
(
	ten_mh NVARCHAR(50),
	mamh CHAR(8) NOT NULL,
	tinchi TINYINT NOT NULL CHECK(TINCHI >=1 AND TINCHI <= 4),
	khoa CHAR(4),
	-- Tạo khoá chính (MAMH) --
	CONSTRAINT pk_mhoc PRIMARY KEY (mamh)
)

CREATE TABLE DKIEN
(
	mamh CHAR(8) NOT NULL,
	mamh_truoc CHAR(8),
	-- Tạo khoá chính (mamh, mamh_truoc)
	CONSTRAINT pk_dkien PRIMARY KEY (mamh, mamh_truoc),
	-- Tạo khoá ngoại DKIEN(mamh) -> MHOC(mamh)
	CONSTRAINT fk_dkien_mhoc FOREIGN KEY (mamh) REFERENCES mhoc(mamh) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE K_HOC
(
	makh INT NOT NULL,
	mamh CHAR(8) NOT NULL,
	hocky TINYINT,
	nam TINYINT,
	gv NVARCHAR(10),
	CONSTRAINT kt_hocky CHECK (hocky >= 1),
	-- Tạo khoá chính: makh
	CONSTRAINT pk_khoc PRIMARY KEY (makh),
	-- Tạo khoá ngoại nối với mhoc
	CONSTRAINT fk_khoc_mhoc FOREIGN KEY (mamh) REFERENCES MHOC(mamh) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE KQUA
(
	masv INT NOT NULL,
	makh INT NOT NULL,
	diem TINYINT NOT NULL,
	CONSTRAINT kt_diem CHECK (diem <= 10),
	-- Tạo khoá chính bảng kqua (masv, makh)
	CONSTRAINT pk_kqua PRIMARY KEY (masv, makh),
	-- Tạo khoá ngoại: KQUA(makh) -> K_HOC(makh)
	CONSTRAINT fk_kqua_khoc FOREIGN KEY (makh) REFERENCES K_HOC(makh) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_kqua_svien FOREIGN KEY (masv) REFERENCES SVIEN(masv) ON UPDATE CASCADE ON DELETE CASCADE
)

-- Nhập dữ liệu: svien, mhoc > k_hoc > dkien, kqua


INSERT INTO SVIEN VALUES
(N'Sơn', 17, 1, 'CNTT'),
(N'Bảo', 8, 2, 'CNTT')
SELECT * FROM SVIEN


INSERT INTO MHOC VALUES
(N'Nhập môn tin học', 'COSC1310', 4, 'CNTT'),
(N'Cấu trúc dữ liệu', 'COSC3320', 4, 'CNTT'),
(N'Toán rời rạc', 'MATH2410', 3, 'TOAN'),
(N'Cơ sở dữ liệu', 'COSC3380', 3, 'CNTT')
SELECT * FROM MHOC


INSERT INTO K_HOC VALUES
(85, 'MATH2410', 1, 86, 'Kim'),
(92, 'COSC1310', 1, 86, 'An'),
(102, 'COSC3320', 2, 87, N'Niên'),
(112, 'MATH2410', 1, 87, N'Chân'),
(119, 'COSC1310', 1, 87, 'An'),
(135, 'COSC3380', 1, 87, N'Sơn')
SELECT * FROM K_HOC


INSERT INTO DKIEN VALUES
('COSC3380', 'COSC3320'),
('COSC3380', 'MATH2410'),
('COSC3320', 'COSC1310')
SELECT * FROM DKIEN


INSERT INTO KQUA VALUES
(17, 112, 8),
(17, 119, 6),
(8, 85, 10),
(8, 92, 10),
(8, 102, 8),
(8, 135, 10)
SELECT * FROM KQUA



-- 2. Thêm vào SVIEN bộ <"Nam", 25, 2, "CNTT">
INSERT INTO SVIEN(TEN, MASV, NAM, KHOA) VALUES ('Nam', 25, 2, 'CNTT')

-- 3. Thêm vào KQUA 2 bộ <25,102,7>,<25,135,9>
INSERT INTO KQUA VALUES (25,102,7), (25, 135,9)

-- 4. Sửa bộ <8,102,8> thành <8,102,9>
UPDATE KQUA
SET diem = 9
WHERE (masv = 8) AND (makh = 102)

-- 5. Xoá bộ <8,135,10>
DELETE FROM KQUA WHERE (masv = 8) AND (makh = 135)


-- QUERY:

-- 6. In ra tên các sinh viên
SELECT ten 'Tên' FROM SVIEN

-- 7. In ra tên các môn học và số tín chỉ
SELECT ten_mh 'Tên môn học', tinchi 'Tín chỉ' FROM MHOC

-- 8. Cho biết kết quả học tập của sinh viên có mã số 8
SELECT ten_mh 'Tên môn học', MHOC.mamh 'Mã môn học', diem 'Điểm'
FROM SVIEN, K_HOC, MHOC, KQUA
WHERE SVIEN.masv = KQUA.masv AND KQUA.makh = K_HOC.makh AND K_HOC.mamh = MHOC.mamh AND SVIEN.masv = 8

-- 9. Cho biết các mã số môn học phải học trước môn mã số COSC3320
SELECT mamh_truoc FROM DKIEN WHERE mamh = 'COSC3320'

-- 10. Cho biết các mã số môn học phải học sau môn có mã số COSC3320
SELECT mamh FROM DKIEN WHERE mamh_truoc = 'COSC3320'

-- 11. Cho biết tên sinh viên và các môn học mà sinh viên đó tham gia
--     với kết quả cuối khoá trên 7 điểm
SELECT ten 'Tên', ten_mh 'Tên môn học', diem 'Điểm'
FROM SVIEN, MHOC, KQUA, K_HOC
WHERE SVIEN.masv = KQUA.masv AND KQUA.makh = K_HOC.makh AND K_HOC.mamh = MHOC.mamh AND KQUA.diem > 7

-- 12. Cho biết tên các sinh viên thuộc về khoa có phụ trách môn học "Toán rời rạc"
SELECT ten 'Tên'
FROM SVIEN
WHERE SVIEN.khoa in (SELECT khoa FROM MHOC WHERE ten_mh = N'Toán rời rạc')

SELECT ten
FROM SVIEN
WHERE SVIEN.khoa in (SELECT khoa FROM MHOC WHERE ten_mh = N'Cơ sở dữ liệu')

-- 13. Cho biến tên các môn học phải học ngay trước môn "Cơ sở dữ liệu"
SELECT ten_mh 'Tên môn học'
FROM MHOC
WHERE mamh IN (SELECT mamh_truoc FROM DKIEN WHERE mamh IN (SELECT mamh FROM MHOC WHERE ten_mh = N'Cơ sở dữ liệu'))

-- 14. Cho biết tên các môn phải học liền sau môn "Cơ sở dữ liệu"
SELECT ten_mh 'Tên môn học'
FROM MHOC
WHERE mamh IN (SELECT mamh FROM DKIEN WHERE mamh_truoc = (SELECT mamh FROM MHOC WHERE ten_mh = N'Cơ sở dữ liệu'))

-- 15. Cho biết tên sinh viên và điểm trung bình của sinh viên đó trong từng học kỳ của từng niên học
SELECT ten 'Tên sinh viên', AVG(diem) 'Điểm trung bình', hocky 'Học kỳ', K_HOC.nam 'Năm'
FROM SVIEN, KQUA, K_HOC
WHERE SVIEN.masv = KQUA.masv AND KQUA.makh = K_HOC.makh
GROUP BY ten, hocky, K_HOC.nam

-- 16. Cho biết tên sinh viên đạt điểm cao nhất
SELECT ten
FROM SVIEN
WHERE masv IN (SELECT masv FROM KQUA WHERE diem = (SELECT MAX(diem) FROM KQUA))

-- 17. Cho biết tên sinh viên tham dự tất cả môn học
SELECT SVIEN.ten 'Tên'
FROM KQUA, SVIEN
WHERE KQUA.masv = SVIEN.masv
GROUP BY ten
HAVING COUNT(makh) = (SELECT COUNT(mamh) FROM MHOC)