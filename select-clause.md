Trình bày liệt kê tất cả các trường hợp xảy ra sau mệnh đề SELECT trong câu lệnh truy vấn lựa chọn SELECT. Cho ví dụ minh hoạ từng trường hợp.

---

Danh sách chọn trong câu lệnh SELECT được dùng để chỉ định các trường, biểu thường cần hiển thị trong cột của kết quả truy vấn. Các trường, biểu thức này ngay sau từ khoá SELECT, cách sau bởi dấu phẩy.

1. Chọn tất cả cột trong bảng: dùng kí tự * <br />
   `SELECT * FROM nhanvien`
2. Chọn các trường trong một bảng:<br />
   `SELECT hoten, ngaysinh, dchi FROM nhanvien`
3. Dùng cấu trúc CASE để hiển thị kết quả khác nhau dựa vào dữ liệu. <br />
   `SELECT hoten, ngaysinh, dchi, CASE WHEN gioi = 0 THEN 'Nam' ELSE N'Nữ' END FROM nhanvien`
4. Hiển thị số dòng nhất định trong kết quả truy xuất: dùng từ khoá TOP trước danh sách chọn. <br />
   `SELECT TOP 5 hoten FROM nhanvien` <br />
   `SELECT TOP 20 PERCENT hoten FROM nhanvien`
5. Loại bỏ các dòng trùng lặp trong kết quả truy xuất: thêm từ khoá DISTINCT trước danh sách chọn<br />
   `SELECT DISTINCT hoten FROM nhanvien`
6. Đặt tên cho các cột: dùng từ khoá AS hoặc dấu ngoặc đơn <br />
   `SELECT hoten AS [Họ tên], ngaysinh 'Ngày sinh' FROM nhanvien`
7. Tạo bảng mới bằng câu lệnh SELECT ... INTO <br />
   `SELECT masv, hoten, lop INTO hocvien2000 FROM hocvien WHERE YEAR(ngaysinh) = 2000`
8. Sử dụng hàm gộp trong danh sách chọn, các trường không sử dụng hàm gộp phải đặt trong GROUP BY <br />
   `SELECT tenlop, COUNT(mahv) FROM lop, hocvien WHERE lop.malop = hocvien.malop GROUP BY tenlop`
9. Hằng và biểu thức trong danh sách chọn <br />
   ```
   SELECT tenhang, soluong, soluong * gia AS thanhtien
   FROM donhang, sanpham
   WHERE donhang.mahang = sanpham.masp
   ```
