# CINEMA FINALE

## 1. Giới thiệu
Cinema Finale là phần mềm quản lý và đặt vé rạp chiếu phim được xây dựng bằng Java Swing theo mô hình MVC, sử dụng Hibernate/JPA để kết nối MySQL.

Hệ thống gồm 2 luồng chính:
- Staff: đăng nhập quản trị, quản lý phim, suất chiếu, phòng chiếu, khách hàng, khuyến mãi...
- User: xem phim, chọn suất chiếu, chọn ghế, chọn sản phẩm, thanh toán.

## 2. Công nghệ sử dụng
- Java 21
- Java Swing
- Maven
- Hibernate / JPA
- MySQL

## 3. Cấu trúc project
cinema_finale/
├─ src/
│  ├─ main/
│  │  ├─ java/org/example/cinema_finale/
│  │  │  ├─ controller/
│  │  │  ├─ dao/
│  │  │  ├─ dto/
│  │  │  ├─ entity/
│  │  │  ├─ enums/
│  │  │  ├─ service/
│  │  │  ├─ tablemodel/
│  │  │  ├─ util/
│  │  │  ├─ view/
│  │  │  └─ MainApp.java
│  │  └─ resources/
│  │     ├─ META-INF/
│  │     └─ images/
├─ database.sql
├─ README.md
├─ pom.xml
└─ .gitignore

## 4. Cách chạy project
### Bước 1: Tạo database
Tạo database MySQL: "quanlybanvexemphim.sql"

### Bước 2: Cấu hình kết nối
Chỉnh file:
`src/main/resources/META-INF/persistence.xml`

Cập nhật:
- username MySQL
- password MySQL
- tên database

### Bước 3: Import dữ liệu
Chạy file SQL khởi tạo dữ liệu.

### Bước 4: Chạy chương trình
Chạy file:
`MainApp.java`

## 5. Tài khoản đăng nhập mẫu
Ví dụ:
- Staff: `staff01 / nv12345`
- User: `user01 / user12345`

## 6. Lưu ý
- Poster phim chỉ hiển thị ở giao diện user khi phim đã được upload poster từ phía staff trong chức năng "Quản lý phim".
- Nếu phim chưa được upload poster, giao diện user sẽ không hiển thị ảnh poster tương ứng.
