# PHÂN CÔNG NHÓM - CINEMA_FINALE

## Thành viên nhóm
- Duy: phụ trách flow lõi, kiến trúc chung, tích hợp, merge code
- Tùng: phụ trách giao diện, controller, thao tác người dùng, một phần module dữ liệu độc lập
- Thành viên 3: phụ trách báo cáo Word, tài liệu kỹ thuật, dữ liệu mẫu, test case

---

## Quy ước làm việc
- Nhánh chính: `main`
- Duy là người giữ `main` và là người merge cuối cùng
- Không code trực tiếp trên `main`
- Mỗi thành viên code trên branch riêng
- Trước khi làm phải pull code mới nhất từ `main`
- Commit rõ nội dung
- Không tự ý sửa `pom.xml`, `persistence.xml`, `JpaUtil`, `MainApp` nếu chưa trao đổi
- Nếu có conflict thì báo Duy xử lý merge

---

## Phân công Duy
### 1. Khung chung của project
- Quản lý Git/GitHub của nhóm
- Tạo và quản lý repo
- Review code trước khi merge
- Quản lý cấu trúc package chung
- `pom.xml`
- `.gitignore`
- `JpaUtil`
- `persistence.xml`
- `MainApp`
- `MainFrame` khung chính của hệ thống

### 2. Flow lõi / nghiệp vụ chính
#### Entity
- `Phim`
- `TheLoai`
- `PhimTheLoai`
- `SuatChieu`

#### DAO
- `PhimDao`
- `SuatChieuDao`

#### Service
- `PhimService`
- `SuatChieuService`

#### DTO
- `PhimDTO`
- `SuatChieuDTO`

### 3. Chức năng
- CRUD phim
- Quản lý thể loại cho phim
- CRUD suất chiếu
- Tìm kiếm phim theo tên
- Lọc suất chiếu theo ngày
- Hiển thị danh sách phim / suất chiếu
- Viết các JPQL lõi liên quan đến phim và suất chiếu
- Tích hợp các module để hệ thống chạy chung

---

## Phân công Tùng
### 1. Giao diện và thao tác người dùng
#### View
- `PhimPanel`
- `SuatChieuPanel`
- `PhongChieuPanel`
- `GhePanel`
- `VePanel`
- `HoaDonPanel`

#### TableModel
- `PhimTableModel`
- `SuatChieuTableModel`
- `VeTableModel`
- `HoaDonTableModel`

#### Controller
- `PhimController`
- `SuatChieuController`
- `VeController`
- `HoaDonController`

### 2. Module dữ liệu độc lập
#### Entity
- `PhongChieu`
- `LoaiGhe`
- `Ghe`

#### DAO
- `PhongChieuDao`
- `GheDao`

#### Service
- `PhongChieuService`
- `GheService`

### 3. Chức năng Tùng phụ trách
- Thiết kế giao diện các form chính
- Bắt sự kiện button, combobox, table
- Hiển thị dữ liệu lên JTable
- Validate dữ liệu nhập trên giao diện
- CRUD phòng chiếu
- CRUD ghế
- Hỗ trợ giao diện cho phim và suất chiếu
- Nối View với Controller và Service
- Hoàn thiện trải nghiệm thao tác người dùng

---

## Phân công Gấm 
### 1. Báo cáo Word
- Khảo sát hiện trạng
- Mô tả bài toán quản lý rạp chiếu phim
- Mục tiêu hệ thống
- Các chức năng chính của hệ thống
- Xác định các thực thể
- Xác định thuộc tính khóa, thuộc tính mô tả
- Xác định mối liên kết
- Trình bày ERD
- Chuẩn hóa đến 3NF
- Chuyển ERD thành các bảng dữ liệu MySQL
- Mô tả mô hình Java Swing MVC + Hibernate/JPA
- Tổng hợp JPQL của hệ thống
- Chụp và mô tả giao diện khi hoàn thành

### 2. Hỗ trợ kỹ thuật
- Viết dữ liệu mẫu để test
- Chuẩn bị script insert dữ liệu mẫu
- Viết các test case / kịch bản chạy thử
- Kiểm tra đối chiếu giữa code và báo cáo
- Tổng hợp ảnh minh họa cho báo cáo

---

## Cách đặt tên branch
- Duy: `feature/duy-core-flow`
- Tùng: `feature/tung-ui-controller`
- Thành viên 3: `docs/report`

---

## Quy trình làm việc với Git
### Duy
- Là người merge vào `main`
- Review code của Tùng trước khi merge
- Giải quyết conflict nếu có

### Tùng
1. Pull code mới nhất từ `main`
2. Checkout branch cá nhân
3. Code phần được giao
4. Commit rõ nội dung
5. Push branch lên GitHub
6. Báo Duy review và merge

### Thành viên 3
- Có thể làm ngoài code
- Nếu cần lưu báo cáo hoặc tài liệu thì làm trên branch `docs/report`

---

