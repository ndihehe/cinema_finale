Cách thiết lập database cho dự án:

1. Copy repo dự án về máy.
2. Mở terminal hoặc CMD, vào thư mục dự án:
      cd DuongDanToi/QuanLyBanVeXemPhim

3. Import DB:
   Cách 1: Dùng MySQL Workbench
     - Mở file db/schema_and_data.sql trong VS Code/Notepad++.
     - Copy nội dung → dán vào tab Query trong MySQL Workbench → Execute.

   Cách 2: Dùng lệnh (Windows/macOS/Linux)
     mysql -u root -p < db/schema_and_data.sql

4. Kiểm tra:
   SELECT * FROM Phim;
