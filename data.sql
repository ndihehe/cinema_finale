DROP DATABASE IF EXISTS QuanLyBanVeXemPhim;
CREATE DATABASE QuanLyBanVeXemPhim CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE QuanLyBanVeXemPhim;

CREATE TABLE ChucVu (
    MaChucVu INT AUTO_INCREMENT PRIMARY KEY,
    TenChucVu VARCHAR(100) NOT NULL,
    MoTa VARCHAR(255) NULL,
    CONSTRAINT UK_ChucVu_Ten UNIQUE (TenChucVu)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE NhanVien (
    MaNhanVien INT AUTO_INCREMENT PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    NgaySinh DATE NULL,
    GioiTinh VARCHAR(10) NULL,
    SoDienThoai VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NULL,
    DiaChi VARCHAR(255) NULL,
    MaChucVu INT NOT NULL,
    TrangThaiLamViec VARCHAR(30) NOT NULL DEFAULT 'Đang làm',
    CONSTRAINT UK_NhanVien_SDT UNIQUE (SoDienThoai),
    CONSTRAINT UK_NhanVien_Email UNIQUE (Email),
    CONSTRAINT FK_NhanVien_ChucVu FOREIGN KEY (MaChucVu) REFERENCES ChucVu(MaChucVu),
    CONSTRAINT CK_NhanVien_GioiTinh CHECK (GioiTinh IS NULL OR GioiTinh IN ('Nam', 'Nữ', 'Khác')),
    CONSTRAINT CK_NhanVien_TrangThai CHECK (TrangThaiLamViec IN ('Đang làm', 'Nghỉ việc'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE KhachHang (
    MaKhachHang INT AUTO_INCREMENT PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15) NULL,
    Email VARCHAR(100) NULL,
    GioiTinh VARCHAR(10) NULL,
    NgaySinh DATE NULL,
    DiemTichLuy INT NOT NULL DEFAULT 0,
    HangThanhVien VARCHAR(30) NOT NULL DEFAULT 'Thường',
    CONSTRAINT UK_KhachHang_SDT UNIQUE (SoDienThoai),
    CONSTRAINT UK_KhachHang_Email UNIQUE (Email),
    CONSTRAINT CK_KhachHang_GioiTinh CHECK (GioiTinh IS NULL OR GioiTinh IN ('Nam', 'Nữ', 'Khác')),
    CONSTRAINT CK_KhachHang_Diem CHECK (DiemTichLuy >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE TaiKhoan (
    MaTaiKhoan INT AUTO_INCREMENT PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    LoaiTaiKhoan VARCHAR(20) NOT NULL,
    MaNhanVien INT NULL,
    MaKhachHang INT NULL,
    TrangThaiTaiKhoan VARCHAR(30) NOT NULL DEFAULT 'Hoạt động',
    NgayTao DATETIME NOT NULL,
    CONSTRAINT UK_TaiKhoan_TenDangNhap UNIQUE (TenDangNhap),
    CONSTRAINT UK_TaiKhoan_MaNhanVien UNIQUE (MaNhanVien),
    CONSTRAINT UK_TaiKhoan_MaKhachHang UNIQUE (MaKhachHang),
    CONSTRAINT FK_TaiKhoan_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    CONSTRAINT FK_TaiKhoan_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
    CONSTRAINT CK_TaiKhoan_Loai CHECK (LoaiTaiKhoan IN ('NhanVien', 'KhachHang')),
    CONSTRAINT CK_TaiKhoan_TrangThai CHECK (TrangThaiTaiKhoan IN ('Hoạt động', 'Khóa')),
    CONSTRAINT CK_TaiKhoan_ChuSoHuu CHECK (
        (LoaiTaiKhoan = 'NhanVien' AND MaNhanVien IS NOT NULL AND MaKhachHang IS NULL)
        OR
        (LoaiTaiKhoan = 'KhachHang' AND MaKhachHang IS NOT NULL AND MaNhanVien IS NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE LoaiKhuyenMai (
    MaLoaiKhuyenMai INT AUTO_INCREMENT PRIMARY KEY,
    TenLoaiKhuyenMai VARCHAR(100) NOT NULL,
    MoTa VARCHAR(255) NULL,
    CONSTRAINT UK_LoaiKhuyenMai_Ten UNIQUE (TenLoaiKhuyenMai)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE KhuyenMai (
    MaKhuyenMai INT AUTO_INCREMENT PRIMARY KEY,
    TenKhuyenMai VARCHAR(150) NOT NULL,
    MaLoaiKhuyenMai INT NOT NULL,
    KieuGiaTri VARCHAR(10) NOT NULL,
    GiaTri DECIMAL(18,2) NOT NULL,
    NgayBatDau DATETIME NOT NULL,
    NgayKetThuc DATETIME NOT NULL,
    DonHangToiThieu DECIMAL(18,2) NOT NULL DEFAULT 0,
    TrangThai VARCHAR(30) NOT NULL DEFAULT 'Hoạt động',
    CONSTRAINT FK_KhuyenMai_Loai FOREIGN KEY (MaLoaiKhuyenMai) REFERENCES LoaiKhuyenMai(MaLoaiKhuyenMai),
    CONSTRAINT CK_KhuyenMai_Kieu CHECK (KieuGiaTri IN ('%', 'TIEN')),
    CONSTRAINT CK_KhuyenMai_GiaTri CHECK (GiaTri > 0),
    CONSTRAINT CK_KhuyenMai_Percent CHECK (KieuGiaTri <> '%' OR GiaTri <= 100),
    CONSTRAINT CK_KhuyenMai_ThoiGian CHECK (NgayKetThuc >= NgayBatDau),
    CONSTRAINT CK_KhuyenMai_DonHangToiThieu CHECK (DonHangToiThieu >= 0),
    CONSTRAINT CK_KhuyenMai_TrangThai CHECK (TrangThai IN ('Hoạt động', 'Ngừng'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE DanhMucSanPham (
    MaDanhMucSanPham INT AUTO_INCREMENT PRIMARY KEY,
    TenDanhMucSanPham VARCHAR(100) NOT NULL,
    MoTa VARCHAR(255) NULL,
    CONSTRAINT UK_DanhMucSanPham_Ten UNIQUE (TenDanhMucSanPham)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE LoaiSanPham (
    MaLoaiSanPham INT AUTO_INCREMENT PRIMARY KEY,
    TenLoaiSanPham VARCHAR(100) NOT NULL,
    MaDanhMucSanPham INT NOT NULL,
    MoTa VARCHAR(255) NULL,
    CONSTRAINT UK_LoaiSanPham_Ten UNIQUE (TenLoaiSanPham),
    CONSTRAINT FK_LoaiSanPham_DanhMuc FOREIGN KEY (MaDanhMucSanPham) REFERENCES DanhMucSanPham(MaDanhMucSanPham)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE SanPham (
    MaSanPham INT AUTO_INCREMENT PRIMARY KEY,
    TenSanPham VARCHAR(150) NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    SoLuongTon INT NOT NULL DEFAULT 0,
    MaLoaiSanPham INT NOT NULL,
    TrangThai VARCHAR(30) NOT NULL DEFAULT 'Đang bán',
    CONSTRAINT FK_SanPham_Loai FOREIGN KEY (MaLoaiSanPham) REFERENCES LoaiSanPham(MaLoaiSanPham),
    CONSTRAINT CK_SanPham_DonGia CHECK (DonGia >= 0),
    CONSTRAINT CK_SanPham_SoLuong CHECK (SoLuongTon >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE LoaiGheNgoi (
    MaLoaiGheNgoi INT AUTO_INCREMENT PRIMARY KEY,
    TenLoaiGheNgoi VARCHAR(50) NOT NULL,
    PhuThu DECIMAL(18,2) NOT NULL DEFAULT 0,
    CONSTRAINT UK_LoaiGheNgoi_Ten UNIQUE (TenLoaiGheNgoi),
    CONSTRAINT CK_LoaiGheNgoi_PhuThu CHECK (PhuThu >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE PhongChieu (
    MaPhongChieu INT AUTO_INCREMENT PRIMARY KEY,
    TenPhongChieu VARCHAR(50) NOT NULL,
    LoaiManHinh VARCHAR(50) NULL,
    HeThongAmThanh VARCHAR(100) NULL,
    TrangThaiPhong VARCHAR(30) NOT NULL DEFAULT 'Hoạt động',
    CONSTRAINT UK_PhongChieu_Ten UNIQUE (TenPhongChieu),
    CONSTRAINT CK_PhongChieu_TrangThai CHECK (TrangThaiPhong IN ('Hoạt động', 'Bảo trì', 'Ngưng sử dụng'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE GheNgoi (
    MaGheNgoi INT AUTO_INCREMENT PRIMARY KEY,
    MaPhongChieu INT NOT NULL,
    HangGhe VARCHAR(5) NOT NULL,
    SoGhe INT NOT NULL,
    MaLoaiGheNgoi INT NOT NULL,
    TrangThaiGhe VARCHAR(30) NOT NULL DEFAULT 'Hoạt động',
    CONSTRAINT FK_GheNgoi_Phong FOREIGN KEY (MaPhongChieu) REFERENCES PhongChieu(MaPhongChieu),
    CONSTRAINT FK_GheNgoi_Loai FOREIGN KEY (MaLoaiGheNgoi) REFERENCES LoaiGheNgoi(MaLoaiGheNgoi),
    CONSTRAINT UK_GheNgoi_ViTri UNIQUE (MaPhongChieu, HangGhe, SoGhe),
    CONSTRAINT CK_GheNgoi_SoGhe CHECK (SoGhe > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Phim (
    MaPhim INT AUTO_INCREMENT PRIMARY KEY,
    TenPhim VARCHAR(200) NOT NULL,
    TheLoai VARCHAR(100) NULL,
    DaoDien VARCHAR(100) NULL,
    ThoiLuong INT NOT NULL,
    GioiHanTuoi INT NULL,
    DinhDang VARCHAR(30) NULL,
    PosterUrl VARCHAR(500) NULL,
    NgayKhoiChieu DATE NULL,
    TrangThaiPhim VARCHAR(30) NOT NULL DEFAULT 'Sắp chiếu',
    CONSTRAINT CK_Phim_ThoiLuong CHECK (ThoiLuong > 0),
    CONSTRAINT CK_Phim_GioiHanTuoi CHECK (GioiHanTuoi IS NULL OR GioiHanTuoi >= 0),
    CONSTRAINT CK_Phim_TrangThai CHECK (TrangThaiPhim IN ('Sắp chiếu', 'Đang chiếu', 'Ngừng chiếu'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE SuatChieu (
    MaSuatChieu INT AUTO_INCREMENT PRIMARY KEY,
    MaPhim INT NOT NULL,
    MaPhongChieu INT NOT NULL,
    NgayGioChieu DATETIME NOT NULL,
    GiaVeCoBan DECIMAL(18,2) NOT NULL,
    TrangThaiSuatChieu VARCHAR(30) NOT NULL DEFAULT 'Sắp chiếu',
    CONSTRAINT FK_SuatChieu_Phim FOREIGN KEY (MaPhim) REFERENCES Phim(MaPhim),
    CONSTRAINT FK_SuatChieu_Phong FOREIGN KEY (MaPhongChieu) REFERENCES PhongChieu(MaPhongChieu),
    CONSTRAINT UK_SuatChieu_Phong_ThoiGian UNIQUE (MaPhongChieu, NgayGioChieu),
    CONSTRAINT CK_SuatChieu_GiaVe CHECK (GiaVeCoBan >= 0),
    CONSTRAINT CK_SuatChieu_TrangThai CHECK (TrangThaiSuatChieu IN ('Sắp chiếu', 'Đang chiếu', 'Đã chiếu', 'Hủy'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE LoaiVe (
    MaLoaiVe INT AUTO_INCREMENT PRIMARY KEY,
    TenLoaiVe VARCHAR(100) NOT NULL,
    PhuThuGia DECIMAL(18,2) NOT NULL DEFAULT 0,
    MoTa VARCHAR(255) NULL,
    CONSTRAINT UK_LoaiVe_Ten UNIQUE (TenLoaiVe),
    CONSTRAINT CK_LoaiVe_PhuThu CHECK (PhuThuGia >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Ve (
    MaVe INT AUTO_INCREMENT PRIMARY KEY,
    MaSuatChieu INT NOT NULL,
    MaGheNgoi INT NOT NULL,
    MaLoaiVe INT NOT NULL,
    GiaVe DECIMAL(18,2) NOT NULL,
    TrangThaiVe VARCHAR(30) NOT NULL DEFAULT 'Chưa bán',
    CONSTRAINT FK_Ve_SuatChieu FOREIGN KEY (MaSuatChieu) REFERENCES SuatChieu(MaSuatChieu),
    CONSTRAINT FK_Ve_GheNgoi FOREIGN KEY (MaGheNgoi) REFERENCES GheNgoi(MaGheNgoi),
    CONSTRAINT FK_Ve_LoaiVe FOREIGN KEY (MaLoaiVe) REFERENCES LoaiVe(MaLoaiVe),
    CONSTRAINT UK_Ve_SuatChieu_Ghe UNIQUE (MaSuatChieu, MaGheNgoi),
    CONSTRAINT CK_Ve_Gia CHECK (GiaVe >= 0),
    CONSTRAINT CK_Ve_TrangThai CHECK (TrangThaiVe IN ('Chưa bán', 'Đã bán', 'Đã sử dụng', 'Đã hủy'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE DonHang (
    MaDonHang INT AUTO_INCREMENT PRIMARY KEY,
    MaKhachHang INT NULL,
    MaNhanVien INT NOT NULL,
    MaKhuyenMai INT NULL,
    NgayLap DATETIME NOT NULL,
    TrangThaiDonHang VARCHAR(30) NOT NULL DEFAULT 'Chưa thanh toán',
    GhiChu VARCHAR(255) NULL,
    CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
    CONSTRAINT FK_DonHang_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    CONSTRAINT FK_DonHang_KhuyenMai FOREIGN KEY (MaKhuyenMai) REFERENCES KhuyenMai(MaKhuyenMai),
    CONSTRAINT CK_DonHang_TrangThai CHECK (TrangThaiDonHang IN ('Chưa thanh toán', 'Đã thanh toán', 'Đã hủy'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ChiTietDonHangVe (
    MaChiTietVe INT AUTO_INCREMENT PRIMARY KEY,
    MaDonHang INT NOT NULL,
    MaVe INT NOT NULL,
    DonGiaBan DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_CTDHVe_DonHang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    CONSTRAINT FK_CTDHVe_Ve FOREIGN KEY (MaVe) REFERENCES Ve(MaVe),
    CONSTRAINT UK_CTDHVe_MaVe UNIQUE (MaVe),
    CONSTRAINT CK_CTDHVe_DonGia CHECK (DonGiaBan >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ChiTietDonHangSanPham (
    MaChiTietSP INT AUTO_INCREMENT PRIMARY KEY,
    MaDonHang INT NOT NULL,
    MaSanPham INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGiaBan DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_CTDHSP_DonHang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    CONSTRAINT FK_CTDHSP_SanPham FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham),
    CONSTRAINT CK_CTDHSP_SoLuong CHECK (SoLuong > 0),
    CONSTRAINT CK_CTDHSP_DonGia CHECK (DonGiaBan >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ThanhToan (
    MaThanhToan INT AUTO_INCREMENT PRIMARY KEY,
    MaDonHang INT NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL,
    PhuongThucThanhToan VARCHAR(50) NOT NULL,
    ThoiGianThanhToan DATETIME NOT NULL,
    TrangThaiThanhToan VARCHAR(30) NOT NULL DEFAULT 'Thành công',
    CONSTRAINT FK_ThanhToan_DonHang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    CONSTRAINT CK_ThanhToan_SoTien CHECK (SoTien >= 0),
    CONSTRAINT CK_ThanhToan_TrangThai CHECK (TrangThaiThanhToan IN ('Thành công', 'Thất bại'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
CREATE TRIGGER TRG_Ve_KiemTraGheThuocPhong
BEFORE INSERT ON Ve
FOR EACH ROW
BEGIN
    DECLARE vPhongSuat INT;
    DECLARE vPhongGhe INT;

    SELECT MaPhongChieu INTO vPhongSuat
    FROM SuatChieu
    WHERE MaSuatChieu = NEW.MaSuatChieu;

    SELECT MaPhongChieu INTO vPhongGhe
    FROM GheNgoi
    WHERE MaGheNgoi = NEW.MaGheNgoi;

    IF vPhongSuat IS NULL OR vPhongGhe IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Suất chiếu hoặc ghế không tồn tại.';
    END IF;

    IF vPhongSuat <> vPhongGhe THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ghế không thuộc phòng của suất chiếu.';
    END IF;
END$$
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE ThanhToan;
TRUNCATE TABLE ChiTietDonHangSanPham;
TRUNCATE TABLE ChiTietDonHangVe;
TRUNCATE TABLE DonHang;
TRUNCATE TABLE Ve;
TRUNCATE TABLE LoaiVe;
TRUNCATE TABLE SuatChieu;
TRUNCATE TABLE Phim;
TRUNCATE TABLE GheNgoi;
TRUNCATE TABLE PhongChieu;
TRUNCATE TABLE LoaiGheNgoi;
TRUNCATE TABLE SanPham;
TRUNCATE TABLE LoaiSanPham;
TRUNCATE TABLE DanhMucSanPham;
TRUNCATE TABLE KhuyenMai;
TRUNCATE TABLE LoaiKhuyenMai;
TRUNCATE TABLE TaiKhoan;
TRUNCATE TABLE KhachHang;
TRUNCATE TABLE NhanVien;
TRUNCATE TABLE ChucVu;
SET FOREIGN_KEY_CHECKS = 1;


SET NAMES utf8mb4;
SET time_zone = '+07:00';

START TRANSACTION;

INSERT INTO ChucVu (TenChucVu, MoTa) VALUES
('Quản lý rạp', 'Quản lý vận hành tổng thể của rạp chiếu phim'),
('Phó quản lý', 'Hỗ trợ điều phối ca làm và vận hành'),
('Thu ngân', 'Thanh toán vé và sản phẩm'),
('Nhân viên quầy vé', 'Tư vấn lịch chiếu và hỗ trợ đặt vé'),
('Nhân viên bắp nước', 'Phục vụ quầy đồ ăn thức uống'),
('Nhân viên kỹ thuật', 'Vận hành máy chiếu, âm thanh, ánh sáng'),
('Kiểm soát vé', 'Soát vé và hướng dẫn khách vào phòng'),
('Tạp vụ', 'Vệ sinh khu vực sảnh và phòng chiếu');

INSERT INTO NhanVien (HoTen, NgaySinh, GioiTinh, SoDienThoai, Email, DiaChi, MaChucVu, TrangThaiLamViec) VALUES
('Nguyễn Minh Anh', '1990-05-12', 'Nam', '0901000001', 'minhanh01@gmail.com', 'Quận 1, TP.HCM', 1, 'Đang làm'),
('Trần Thu Hà', '1995-08-21', 'Nữ', '0901000002', 'thuha02@gmail.com', 'Quận 3, TP.HCM', 3, 'Đang làm'),
('Lê Quốc Bảo', '1998-03-15', 'Nam', '0901000003', 'quocbao03@gmail.com', 'Bình Thạnh, TP.HCM', 3, 'Đang làm'),
('Phạm Ngọc Lan', '1997-11-09', 'Nữ', '0901000004', 'ngoclan04@gmail.com', 'Quận 10, TP.HCM', 4, 'Đang làm'),
('Đỗ Thành Công', '1992-02-18', 'Nam', '0901000005', 'thanhcong05@gmail.com', 'Thủ Đức, TP.HCM', 6, 'Đang làm'),
('Võ Mỹ Duyên', '1999-07-01', 'Nữ', '0901000006', 'myduyen06@gmail.com', 'Gò Vấp, TP.HCM', 5, 'Đang làm'),
('Bùi Gia Hưng', '1996-12-11', 'Nam', '0901000007', 'giahung07@gmail.com', 'Tân Bình, TP.HCM', 7, 'Đang làm'),
('Ngô Khánh Linh', '2000-06-23', 'Nữ', '0901000008', 'khanhlinh08@gmail.com', 'Phú Nhuận, TP.HCM', 4, 'Đang làm'),
('Đặng Phúc Thịnh', '1994-09-30', 'Nam', '0901000009', 'phucthinh09@gmail.com', 'Quận 7, TP.HCM', 5, 'Đang làm'),
('Hoàng Yến Nhi', '1998-04-16', 'Nữ', '0901000010', 'yennhi10@gmail.com', 'Tân Phú, TP.HCM', 7, 'Đang làm'),
('Lý Anh Khoa', '1993-10-05', 'Nam', '0901000011', 'anhkhoa11@gmail.com', 'Bình Tân, TP.HCM', 2, 'Đang làm'),
('Phan Tú Uyên', '1997-01-27', 'Nữ', '0901000012', 'tuyen12@gmail.com', 'Quận 5, TP.HCM', 3, 'Đang làm'),
('Trương Nhật Duy', '2001-08-14', 'Nam', '0901000013', 'nhatduy13@gmail.com', 'Quận 12, TP.HCM', 5, 'Đang làm'),
('Mai Phương Thảo', '1999-03-08', 'Nữ', '0901000014', 'phuongthao14@gmail.com', 'Nhà Bè, TP.HCM', 8, 'Đang làm'),
('Vũ Thành Đạt', '1991-11-02', 'Nam', '0901000015', 'thanhdat15@gmail.com', 'Quận 11, TP.HCM', 6, 'Nghỉ việc');

INSERT INTO KhachHang (HoTen, SoDienThoai, Email, GioiTinh, NgaySinh, DiemTichLuy, HangThanhVien) VALUES
('Nguyễn Thị Mai', '0912000001', 'nguyenthimai01@gmail.com', 'Nữ', '1989-02-04', 20, 'Thường'),
('Trần Văn Hùng', '0912000002', 'tranvanhung02@gmail.com', 'Nam', '1990-03-07', 40, 'Thường'),
('Lê Ngọc Anh', '0912000003', 'lengocanh03@gmail.com', 'Nữ', '1991-04-10', 75, 'Thường'),
('Phạm Đức Long', '0912000004', 'phamduclong04@gmail.com', 'Nam', '1992-05-13', 110, 'Bạc'),
('Võ Thu Trang', '0912000005', 'vothutrang05@gmail.com', 'Nữ', '1993-06-16', 180, 'Bạc'),
('Bùi Khánh Vy', '0912000006', 'buikhanhvy06@gmail.com', 'Nữ', '1994-07-19', 260, 'Bạc'),
('Đặng Quang Minh', '0912000007', 'dangquangminh07@gmail.com', 'Nam', '1995-08-22', 420, 'Vàng'),
('Hoàng Hải Yến', '0912000008', 'hoanghaiyen08@gmail.com', 'Nữ', '1996-09-25', 680, 'Kim cương'),
('Ngô Anh Tuấn', '0912000009', 'ngoanhtuan09@gmail.com', 'Nam', '1997-10-01', 0, 'Thường'),
('Lý Bảo Trâm', '0912000010', 'lybaotram10@gmail.com', 'Nữ', '1998-11-04', 20, 'Thường'),
('Phan Gia Bảo', '0912000011', 'phangiabao11@gmail.com', 'Nam', '1999-12-07', 40, 'Thường'),
('Trương Thanh Tâm', '0912000012', 'truongthanhtam12@gmail.com', 'Nữ', '2000-01-10', 75, 'Thường'),
('Mai Quốc Khánh', '0912000013', 'maiquockhanh13@gmail.com', 'Nam', '2001-02-13', 110, 'Bạc'),
('Vũ Hồng Nhung', '0912000014', 'vuhongnhung14@gmail.com', 'Nữ', '2002-03-16', 180, 'Bạc'),
('Đỗ Nhật Nam', '0912000015', 'donhatnam15@gmail.com', 'Nam', '1988-04-19', 260, 'Bạc'),
('Tạ Minh Khuê', '0912000016', 'taminhkhue16@gmail.com', 'Nữ', '1989-05-22', 420, 'Vàng'),
('Dương Gia Hân', '0912000017', 'duonggiahan17@gmail.com', 'Nữ', '1990-06-25', 680, 'Kim cương'),
('Lâm Hoài Phương', '0912000018', 'lamhoaiphuong18@gmail.com', 'Nữ', '1991-07-01', 0, 'Thường'),
('Hồ Đức Anh', '0912000019', 'hoducanh19@gmail.com', 'Nữ', '1992-08-04', 20, 'Thường'),
('Cao Mỹ Linh', '0912000020', 'caomylinh20@gmail.com', 'Nữ', '1993-09-07', 40, 'Thường'),
('Nguyễn Gia Huy', '0912000021', 'nguyengiahuy21@gmail.com', 'Nam', '1994-10-10', 75, 'Thường'),
('Trần Bích Ngọc', '0912000022', 'tranbichngoc22@gmail.com', 'Nữ', '1995-11-13', 110, 'Bạc'),
('Lê Minh Triết', '0912000023', 'leminhtriet23@gmail.com', 'Nam', '1996-12-16', 180, 'Bạc'),
('Phạm Quỳnh Anh', '0912000024', 'phamquynhanh24@gmail.com', 'Nữ', '1997-01-19', 260, 'Bạc'),
('Võ Trần Nam', '0912000025', 'votrannam25@gmail.com', 'Nam', '1998-02-22', 420, 'Vàng'),
('Bùi Tường Vy', '0912000026', 'buituongvy26@gmail.com', 'Nữ', '1999-03-25', 680, 'Kim cương'),
('Đặng Tiến Đạt', '0912000027', 'dangtiendat27@gmail.com', 'Nam', '2000-04-01', 0, 'Thường'),
('Hoàng Phúc Khang', '0912000028', 'hoangphuckhang28@gmail.com', 'Nam', '2001-05-04', 20, 'Thường'),
('Ngô Thuỳ Dương', '0912000029', 'ngothuyduong29@gmail.com', 'Nữ', '2002-06-07', 40, 'Thường'),
('Lý Quốc Việt', '0912000030', 'lyquocviet30@gmail.com', 'Nam', '1988-07-10', 75, 'Thường'),
('Phan Thanh Hà', '0912000031', 'phanthanhha31@gmail.com', 'Nữ', '1989-08-13', 110, 'Bạc'),
('Trương Gia Linh', '0912000032', 'truonggialinh32@gmail.com', 'Nữ', '1990-09-16', 180, 'Bạc'),
('Mai Anh Thư', '0912000033', 'maianhthu33@gmail.com', 'Nữ', '1991-10-19', 260, 'Bạc'),
('Vũ Thành Nhân', '0912000034', 'vuthanhnhan34@gmail.com', 'Nam', '1992-11-22', 420, 'Vàng'),
('Đỗ Thảo Vy', '0912000035', 'dothaovy35@gmail.com', 'Nữ', '1993-12-25', 680, 'Kim cương'),
('Tạ Đức Huy', '0912000036', 'taduchuy36@gmail.com', 'Nam', '1994-01-01', 0, 'Thường'),
('Dương Minh Châu', '0912000037', 'duongminhchau37@gmail.com', 'Nữ', '1995-02-04', 20, 'Thường'),
('Lâm Nhật Hạ', '0912000038', 'lamnhatha38@gmail.com', 'Nữ', '1996-03-07', 40, 'Thường'),
('Hồ Minh Khang', '0912000039', 'hominhkhang39@gmail.com', 'Nam', '1997-04-10', 75, 'Thường'),
('Cao Tú Linh', '0912000040', 'caotulinh40@gmail.com', 'Nữ', '1998-05-13', 110, 'Bạc');

INSERT INTO TaiKhoan (
    TenDangNhap, MatKhau, LoaiTaiKhoan, MaNhanVien, MaKhachHang, TrangThaiTaiKhoan, NgayTao
) VALUES
('staff01', 'nv12345', 'NhanVien', 1, NULL, 'Hoạt động', '2026-03-01 09:00:00'),
('staff02', 'nv12345', 'NhanVien', 2, NULL, 'Hoạt động', '2026-03-01 09:00:00'),
('staff03', 'nv12345', 'NhanVien', 3, NULL, 'Hoạt động', '2026-03-01 09:00:00'),
('user01',  'user12345', 'KhachHang', NULL, 1, 'Hoạt động', '2026-03-02 10:00:00');

INSERT INTO LoaiKhuyenMai (TenLoaiKhuyenMai, MoTa) VALUES
('Giảm theo phần trăm', 'Giảm trực tiếp theo phần trăm trên tổng đơn'),
('Giảm tiền trực tiếp', 'Trừ trực tiếp số tiền cố định'),
('Ưu đãi suất khuya', 'Áp dụng cho các suất chiếu sau 21:00'),
('Ưu đãi thành viên', 'Ưu đãi cho khách hàng có tài khoản thành viên');

INSERT INTO KhuyenMai (TenKhuyenMai, MaLoaiKhuyenMai, KieuGiaTri, GiaTri, NgayBatDau, NgayKetThuc, DonHangToiThieu, TrangThai) VALUES
('Giảm 10% toàn bộ vé cuối tuần', 1, '%', 10, '2026-03-20 00:00:00', '2026-04-30 23:59:59', 0, 'Hoạt động'),
('Giảm 30K cho đơn từ 250K', 2, 'TIEN', 30000, '2026-03-25 00:00:00', '2026-04-30 23:59:59', 250000, 'Hoạt động'),
('Giảm 15% cho thành viên Vàng/Kim cương', 4, '%', 15, '2026-04-01 00:00:00', '2026-04-30 23:59:59', 150000, 'Hoạt động'),
('Ưu đãi suất khuya giảm 20K', 3, 'TIEN', 20000, '2026-04-01 00:00:00', '2026-04-20 23:59:59', 120000, 'Hoạt động'),
('Combo gia đình giảm 50K cho đơn từ 400K', 2, 'TIEN', 50000, '2026-04-01 00:00:00', '2026-04-15 23:59:59', 400000, 'Hoạt động'),
('Flash sale ngày đầu tháng', 2, 'TIEN', 15000, '2026-04-01 00:00:00', '2026-04-03 23:59:59', 100000, 'Ngừng'),
('Khuyến mãi tháng 2 đã kết thúc', 1, '%', 12, '2026-02-01 00:00:00', '2026-02-28 23:59:59', 0, 'Ngừng');

INSERT INTO DanhMucSanPham (TenDanhMucSanPham, MoTa) VALUES
('Đồ ăn', 'Các món ăn nhanh dùng tại rạp'),
('Đồ uống', 'Nước giải khát và đồ uống đóng chai'),
('Combo', 'Combo bắp nước phổ biến'),
('Merchandise', 'Ly, bucket và quà lưu niệm theo phim');

INSERT INTO LoaiSanPham (TenLoaiSanPham, MaDanhMucSanPham, MoTa) VALUES
('Bắp rang', 1, 'Các vị bắp rang phổ biến'),
('Snack', 1, 'Snack và đồ ăn vặt'),
('Kem', 1, 'Kem cây và kem ly'),
('Nước ngọt', 2, 'Nước có ga'),
('Trà/Trà sữa', 2, 'Trà đóng chai và trà sữa'),
('Cà phê', 2, 'Cà phê lon/chai'),
('Combo cá nhân', 3, 'Combo cho 1 người'),
('Combo cặp đôi', 3, 'Combo cho 2 người'),
('Combo gia đình', 3, 'Combo cho nhóm gia đình'),
('Merch phim', 4, 'Quà lưu niệm theo phim');

INSERT INTO SanPham (TenSanPham, DonGia, SoLuongTon, MaLoaiSanPham, TrangThai) VALUES
('Bắp rang bơ size S', 45000, 160, 1, 'Đang bán'),
('Bắp rang bơ size M', 59000, 220, 1, 'Đang bán'),
('Bắp rang caramel size M', 65000, 180, 1, 'Đang bán'),
('Bắp rang phô mai size L', 79000, 120, 1, 'Đang bán'),
('Nachos phô mai', 55000, 90, 2, 'Đang bán'),
('Khoai tây lắc phô mai', 49000, 110, 2, 'Đang bán'),
('Xúc xích nướng', 35000, 140, 2, 'Đang bán'),
('Kem vani socola', 30000, 85, 3, 'Đang bán'),
('Coca-Cola', 32000, 300, 4, 'Đang bán'),
('Pepsi Black', 32000, 180, 4, 'Đang bán'),
('7Up', 32000, 150, 4, 'Đang bán'),
('Aquafina', 25000, 200, 4, 'Đang bán'),
('Trà đào', 39000, 120, 5, 'Đang bán'),
('Trà sữa trân châu', 45000, 100, 5, 'Đang bán'),
('Cà phê sữa lon', 35000, 90, 6, 'Đang bán'),
('Combo 1 bắp M + 1 nước', 89000, 150, 7, 'Đang bán'),
('Combo 1 bắp caramel + 1 nước', 95000, 120, 7, 'Đang bán'),
('Combo 2 bắp M + 2 nước', 169000, 100, 8, 'Đang bán'),
('Combo đôi 1 bắp L + 2 nước + 1 snack', 199000, 80, 8, 'Đang bán'),
('Combo gia đình 2 bắp L + 4 nước + 2 snack', 329000, 60, 9, 'Đang bán'),
('Ly sưu tầm Super Mario Thiên Hà', 99000, 45, 10, 'Đang bán'),
('Bucket Quỷ Nhập Tràng 2', 149000, 25, 10, 'Đang bán'),
('Móc khóa Hẹn Em Ngày Nhật Thực', 59000, 50, 10, 'Đang bán');

-- 1. Xóa dữ liệu cũ để tránh xung đột
DELETE FROM SanPham;

-- 2. Chèn lại dữ liệu với tên cực kỳ đơn giản (không dấu gạch nối, không khoảng trắng thừa)
INSERT INTO SanPham (TenSanPham, DonGia, SoLuongTon, MaLoaiSanPham, TrangThai) VALUES
('Bap rang bo size S', 45000, 160, 1, 'Đang bán'),
('Coca Cola', 32000, 300, 4, 'Đang bán'), -- Bỏ dấu gạch nối '-'
('Combo 1 bap M + 1 nuoc', 89000, 150, 7, 'Đang bán'),
('Combo 2 bap M + 2 nuoc', 169000, 100, 8, 'Đang bán'),
('Combo gia dinh', 329000, 60, 9, 'Đang bán'); -- Rút ngắn tên để tránh sai sót

INSERT INTO LoaiGheNgoi (TenLoaiGheNgoi, PhuThu) VALUES
('Ghế thường', 0),
('Ghế VIP', 20000),
('Ghế đôi', 50000),
('Ghế Deluxe', 30000);

INSERT INTO PhongChieu (TenPhongChieu, LoaiManHinh, HeThongAmThanh, TrangThaiPhong) VALUES
('Phòng 1', '2D', 'Dolby 7.1', 'Hoạt động'),
('Phòng 2', '2D', 'Dolby Atmos', 'Hoạt động'),
('Phòng 3', '3D', 'Dolby Atmos', 'Hoạt động'),
('Phòng 4', 'IMAX', 'Dolby Atmos', 'Hoạt động'),
('Phòng 5', '2D', 'Dolby 7.1', 'Hoạt động'),
('Phòng 6', '2D', 'Dolby 7.1', 'Bảo trì');

INSERT INTO GheNgoi (MaPhongChieu, HangGhe, SoGhe, MaLoaiGheNgoi, TrangThaiGhe)
SELECT
    pc.MaPhongChieu,
    h.HangGhe,
    s.SoGhe,
    CASE
        WHEN h.HangGhe IN ('A', 'B') THEN (SELECT MaLoaiGheNgoi FROM LoaiGheNgoi WHERE TenLoaiGheNgoi = 'Ghế VIP' LIMIT 1)
        WHEN h.HangGhe IN ('F', 'G') THEN (SELECT MaLoaiGheNgoi FROM LoaiGheNgoi WHERE TenLoaiGheNgoi = 'Ghế Deluxe' LIMIT 1)
        WHEN h.HangGhe = 'H' THEN (SELECT MaLoaiGheNgoi FROM LoaiGheNgoi WHERE TenLoaiGheNgoi = 'Ghế đôi' LIMIT 1)
        ELSE (SELECT MaLoaiGheNgoi FROM LoaiGheNgoi WHERE TenLoaiGheNgoi = 'Ghế thường' LIMIT 1)
    END AS MaLoaiGheNgoi,
    CASE
        WHEN pc.TrangThaiPhong = 'Bảo trì' THEN 'Bảo trì'
        ELSE 'Hoạt động'
    END AS TrangThaiGhe
FROM PhongChieu pc
CROSS JOIN (
    SELECT 'A' AS HangGhe
    UNION ALL SELECT 'B'
    UNION ALL SELECT 'C'
    UNION ALL SELECT 'D'
    UNION ALL SELECT 'E'
    UNION ALL SELECT 'F'
    UNION ALL SELECT 'G'
    UNION ALL SELECT 'H'
) h
CROSS JOIN (
    SELECT 1 AS SoGhe
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    UNION ALL SELECT 10
    UNION ALL SELECT 11
    UNION ALL SELECT 12
) s;

INSERT INTO Phim
(TenPhim, TheLoai, DaoDien, ThoiLuong, GioiHanTuoi, DinhDang, NgayKhoiChieu, TrangThaiPhim)
VALUES
('Hẹn Em Ngày Nhất Thực', 'Gia đình, Tình cảm','Lê Thiện Viễn', 118, 16, '2D' , '2026-03-30', 'Đang chiếu'),
('Thoát Khỏi Tận Thế', 'Khoa học viễn tưởng, Phiêu lưu','Phil Lord, Christopher Miller', 157, 13, '4D' , '2026-03-20', 'Đang chiếu'),
('Cú Nhảy Kỳ Diệu', 'Gia đình, Hài, Hoạt hình, Phiêu lưu', 'Daniel Chong', 105, 0, '4DX', '2026-03-13', 'Đang chiếu'),
('Quỷ Nhập Tràng 2', 'Hồi hộp, Kinh dị', 'Pom Nguyễn', 126, 18, '2D', '2026-03-13', 'Đang chiếu'),
('Đêm Ngày Xa Mẹ', 'Gia đình', 'Kim Tae-yong', 109, 13, '2D', '2026-03-20', 'Đang chiếu'),
('Chúng Sẽ Đoạt Mạng', 'Hài, Hành động, Kinh dị', 'Kirill Sokolov', 95, 18, '2D', '2026-03-27', 'Đang chiếu'),
('Tứ Hổ Đại Náo', 'Hài, Hành động, Thần thoại', ' Kongkiat Komesiri', 122, 18, '2D', '2026-03-27', 'Đang chiếu'),
('Vùng Đất Luân Hồi', 'Hoạt hình, Thần thoại', 'Tommy Kai Chung Ng', 110, 13, '3D', '2026-03-27', 'Đang chiếu'),
('Kung Fu Quái Chưởng', 'Hài, Hành động, Thần thoại', 'Giddens Ko', 127, 18, '2D', '2026-03-27', 'Đang chiếu'),
('Project Y: Gái Ngoan Đổi Đời', 'Hồi hộp, Tâm lý', 'Hwan Lee', 109, 18, '2D', '2026-03-27', 'Đang chiếu'),
('Cô Bé Coraline', 'Gia đình, Hoạt hình, Thần thoại', 'Henry Selick', 101, 13, '3D', '2026-03-27', 'Đang chiếu'),
('Mặt Nạ Da Người', 'Bí ẩn, Hồi hộp, Kinh dị', 'Agus Riyanto', 86, 18, '2D', '2026-03-27', 'Đang chiếu'),
('Tài', 'Gia đình, Hành động, Tâm lý', 'Mai Tài Phến', 101, 16, '2D', '2026-03-06', 'Đang chiếu'),
('Tiếng Thét 7', 'Bí ẩn, Kinh dị', 'Kevin Williamson', 114, 18, '4DX', '2026-03-20', 'Đang chiếu'),
('Trận Chiến Sau Trận Chiến (Chiếu Lại)', 'Hành động, Hồi hộp, Tâm lý','William', 162, 18, '2D', '2026-03-20', 'Đang chiếu'),
('La Tiểu Hắc Chiến Ký 2', 'Hành động, Hoạt hình', 'MTJJ, Gu Jie', 120, 13, '2D', '2026-03-20', 'Đang chiếu'),
('Cá Voi Nhỏ Chu Du Đại Dương', 'Gia đình, Hoạt hình, Thần thoại', 'Pavel Hrubos, Steven Majaury, Reza Memari', 92, 0, '2D', '2026-03-20', 'Đang chiếu'),
('Cánh Đồi Mờ Xám', 'Lịch sử, Tâm lý', 'Kei Ishikawa', 123, 13, '2D', '2026-03-20', 'Đang chiếu'),
('Omukade: Con Rết Người', 'Kinh dị', 'Pakphum Wongjinda, Chalit Krileadmongkon', 93, 18, '3D', '2026-03-20', 'Đang chiếu'),
('Bus – Chuyến Xe Một Chiều', 'Kinh dị, Tâm lý', 'Luk Vân', 94, 16, '2D', '2026-03-20', 'Đang chiếu'),
('Cô Dâu!', 'Kinh dị, Nhạc kịch, Tình cảm', 'Maggie Gyllenhaal', 126, 18, '2D', '2026-03-13', 'Đang chiếu'),
('Greenland 2: Đại Di Cư', 'Hành động, Hồi hộp', 'Ric Roman Waugh', 97, 13, '3D', '2026-03-13', 'Đang chiếu'),
('Báu Vật Trời Cho', 'Gia đình, Hài, Tình cảm', 'Lê Thanh Sơn', 124, '16', '2D', '2026-02-17', 'Đang chiếu'),
('Đồi Gió Hú', 'Tâm lý, Tình cảm', 'Emerald Fennell', 136, 18, ' 2D', '2026-02-27', 'Đang chiếu'),
('Không Còn Chúng Ta', 'Tâm lý, Tình cảm', 'Kim Do-Young', 114, 13, '2D', '2026-03-06', 'Đang chiếu'),
('Quốc Bảo', 'Tâm lý', 'Lee Sang-i', 174, 16, '2D', '2026-03-06', 'Đang chiếu');

INSERT INTO SuatChieu (MaPhim, MaPhongChieu, NgayGioChieu, GiaVeCoBan, TrangThaiSuatChieu) VALUES
(13, 1, '2026-04-01 09:00:00', 75000, 'Đã chiếu'),
(1, 1, '2026-04-01 12:15:00', 85000, 'Đã chiếu'),
(4, 1, '2026-04-01 15:30:00', 95000, 'Đã chiếu'),
(3, 1, '2026-04-01 18:45:00', 105000, 'Đã chiếu'),
(16, 1, '2026-04-01 22:00:00', 95000, 'Đã chiếu'),
(14, 2, '2026-04-01 09:40:00', 80000, 'Đã chiếu'),
(23, 2, '2026-04-01 12:55:00', 90000, 'Đã chiếu'),
(2, 2, '2026-04-01 16:10:00', 100000, 'Đã chiếu'),
(7, 2, '2026-04-01 19:25:00', 110000, 'Đã chiếu'),
(1, 2, '2026-04-01 22:30:00', 100000, 'Đã chiếu'),
(3, 3, '2026-04-01 10:10:00', 90000, 'Đã chiếu'),
(10, 3, '2026-04-01 13:40:00', 100000, 'Đã chiếu'),
(1, 3, '2026-04-01 17:10:00', 110000, 'Đã chiếu'),
(4, 3, '2026-04-01 20:40:00', 120000, 'Đã chiếu'),
(14, 4, '2026-04-01 11:00:00', 125000, 'Đã chiếu'),
(11, 4, '2026-04-01 14:45:00', 135000, 'Đã chiếu'),
(3, 4, '2026-04-01 18:30:00', 145000, 'Đã chiếu'),
(13, 4, '2026-04-01 22:15:00', 155000, 'Đã chiếu'),
(22, 5, '2026-04-01 08:50:00', 70000, 'Đã chiếu'),
(1, 5, '2026-04-01 12:05:00', 80000, 'Đã chiếu'),
(21, 5, '2026-04-01 15:20:00', 90000, 'Đã chiếu'),
(16, 5, '2026-04-01 18:35:00', 100000, 'Đã chiếu'),
(6, 5, '2026-04-01 21:50:00', 90000, 'Đã chiếu'),
(2, 1, '2026-04-02 09:00:00', 75000, 'Đã chiếu'),
(25, 1, '2026-04-02 12:15:00', 85000, 'Đã chiếu'),
(4, 1, '2026-04-02 15:30:00', 95000, 'Đã chiếu'),
(1, 1, '2026-04-02 18:45:00', 105000, 'Đã chiếu'),
(2, 1, '2026-04-02 22:00:00', 95000, 'Đã chiếu'),
(22, 2, '2026-04-02 09:40:00', 80000, 'Đã chiếu'),
(13, 2, '2026-04-02 12:55:00', 90000, 'Đã chiếu'),
(20, 2, '2026-04-02 16:10:00', 100000, 'Đã chiếu'),
(16, 2, '2026-04-02 19:25:00', 110000, 'Đã chiếu'),
(9, 2, '2026-04-02 22:30:00', 100000, 'Đã chiếu'),
(26, 3, '2026-04-02 10:10:00', 90000, 'Đã chiếu'),
(6, 3, '2026-04-02 13:40:00', 100000, 'Đã chiếu'),
(11, 3, '2026-04-02 17:10:00', 110000, 'Đã chiếu'),
(19, 3, '2026-04-02 20:40:00', 120000, 'Đã chiếu'),
(13, 4, '2026-04-02 11:00:00', 125000, 'Đã chiếu'),
(22, 4, '2026-04-02 14:45:00', 135000, 'Đã chiếu'),
(10, 4, '2026-04-02 18:30:00', 145000, 'Đã chiếu'),
(14, 4, '2026-04-02 22:15:00', 155000, 'Đã chiếu'),
(1, 5, '2026-04-02 08:50:00', 70000, 'Đã chiếu'),
(4, 5, '2026-04-02 12:05:00', 80000, 'Đã chiếu'),
(5, 5, '2026-04-02 15:20:00', 90000, 'Đã chiếu'),
(2, 5, '2026-04-02 18:35:00', 100000, 'Đã chiếu'),
(5, 5, '2026-04-02 21:50:00', 90000, 'Đã chiếu'),
(2, 1, '2026-04-03 09:00:00', 75000, 'Đã chiếu'),
(4, 1, '2026-04-03 12:15:00', 85000, 'Đã chiếu'),
(13, 1, '2026-04-03 15:30:00', 95000, 'Đã chiếu'),
(5, 1, '2026-04-03 18:45:00', 115000, 'Đã chiếu'),
(6, 1, '2026-04-03 22:00:00', 105000, 'Đã chiếu'),
(3, 2, '2026-04-03 09:40:00', 80000, 'Đã chiếu'),
(4, 2, '2026-04-03 12:55:00', 90000, 'Đã chiếu'),
(25, 2, '2026-04-03 16:10:00', 100000, 'Đã chiếu'),
(14, 2, '2026-04-03 19:25:00', 120000, 'Đã chiếu'),
(12, 2, '2026-04-03 22:30:00', 110000, 'Đã chiếu'),
(2, 3, '2026-04-03 10:10:00', 90000, 'Đã chiếu'),
(17, 3, '2026-04-03 13:40:00', 100000, 'Đã chiếu'),
(2, 3, '2026-04-03 17:10:00', 110000, 'Đã chiếu'),
(7, 3, '2026-04-03 20:40:00', 130000, 'Đã chiếu'),
(26, 4, '2026-04-03 11:00:00', 125000, 'Đã chiếu'),
(14, 4, '2026-04-03 14:45:00', 135000, 'Đã chiếu'),
(11, 4, '2026-04-03 18:30:00', 155000, 'Đã chiếu'),
(16, 4, '2026-04-03 22:15:00', 165000, 'Đã chiếu'),
(23, 5, '2026-04-03 08:50:00', 70000, 'Đã chiếu'),
(18, 5, '2026-04-03 12:05:00', 80000, 'Đã chiếu'),
(3, 5, '2026-04-03 15:20:00', 90000, 'Đã chiếu'),
(1, 5, '2026-04-03 18:35:00', 110000, 'Đã chiếu'),
(7, 5, '2026-04-03 21:50:00', 100000, 'Đã chiếu'),
(3, 1, '2026-04-04 09:00:00', 85000, 'Đã chiếu'),
(2, 1, '2026-04-04 12:15:00', 95000, 'Đang chiếu'),
(25, 1, '2026-04-04 15:30:00', 105000, 'Sắp chiếu'),
(21, 1, '2026-04-04 18:45:00', 115000, 'Sắp chiếu'),
(4, 1, '2026-04-04 22:00:00', 105000, 'Sắp chiếu'),
(13, 2, '2026-04-04 09:40:00', 90000, 'Đã chiếu'),
(6, 2, '2026-04-04 12:55:00', 100000, 'Đang chiếu'),
(24, 2, '2026-04-04 16:10:00', 110000, 'Sắp chiếu'),
(7, 2, '2026-04-04 19:25:00', 120000, 'Sắp chiếu'),
(3, 2, '2026-04-04 22:30:00', 110000, 'Sắp chiếu'),
(3, 3, '2026-04-04 10:10:00', 100000, 'Đã chiếu'),
(11, 3, '2026-04-04 13:40:00', 110000, 'Đang chiếu'),
(4, 3, '2026-04-04 17:10:00', 120000, 'Sắp chiếu'),
(13, 3, '2026-04-04 20:40:00', 130000, 'Sắp chiếu'),
(23, 4, '2026-04-04 11:00:00', 135000, 'Đã chiếu'),
(6, 4, '2026-04-04 14:45:00', 145000, 'Đang chiếu'),
(2, 4, '2026-04-04 18:30:00', 155000, 'Sắp chiếu'),
(26, 4, '2026-04-04 22:15:00', 165000, 'Sắp chiếu'),
(9, 5, '2026-04-04 08:50:00', 80000, 'Đã chiếu'),
(1, 5, '2026-04-04 12:05:00', 90000, 'Đang chiếu'),
(2, 5, '2026-04-04 15:20:00', 100000, 'Sắp chiếu'),
(2, 5, '2026-04-04 18:35:00', 110000, 'Sắp chiếu'),
(15, 5, '2026-04-04 21:50:00', 100000, 'Sắp chiếu'),
(18, 1, '2026-04-05 09:00:00', 85000, 'Sắp chiếu'),
(6, 1, '2026-04-05 12:15:00', 95000, 'Sắp chiếu'),
(1, 1, '2026-04-05 15:30:00', 105000, 'Sắp chiếu'),
(7, 1, '2026-04-05 18:45:00', 115000, 'Sắp chiếu'),
(26, 1, '2026-04-05 22:00:00', 105000, 'Sắp chiếu'),
(8, 2, '2026-04-05 09:40:00', 90000, 'Sắp chiếu'),
(25, 2, '2026-04-05 12:55:00', 100000, 'Sắp chiếu'),
(20, 2, '2026-04-05 16:10:00', 110000, 'Sắp chiếu'),
(1, 2, '2026-04-05 19:25:00', 120000, 'Sắp chiếu'),
(15, 2, '2026-04-05 22:30:00', 110000, 'Sắp chiếu'),
(14, 3, '2026-04-05 10:10:00', 100000, 'Sắp chiếu'),
(8, 3, '2026-04-05 13:40:00', 110000, 'Sắp chiếu'),
(3, 3, '2026-04-05 17:10:00', 120000, 'Sắp chiếu'),
(13, 3, '2026-04-05 20:40:00', 130000, 'Sắp chiếu'),
(2, 4, '2026-04-05 11:00:00', 135000, 'Sắp chiếu'),
(7, 4, '2026-04-05 14:45:00', 145000, 'Sắp chiếu'),
(6, 4, '2026-04-05 18:30:00', 155000, 'Sắp chiếu'),
(24, 4, '2026-04-05 22:15:00', 165000, 'Sắp chiếu'),
(23, 5, '2026-04-05 08:50:00', 80000, 'Sắp chiếu'),
(4, 5, '2026-04-05 12:05:00', 90000, 'Sắp chiếu'),
(11, 5, '2026-04-05 15:20:00', 100000, 'Sắp chiếu'),
(3, 5, '2026-04-05 18:35:00', 110000, 'Sắp chiếu'),
(23, 5, '2026-04-05 21:50:00', 100000, 'Sắp chiếu'),
(22, 1, '2026-04-06 09:00:00', 70000, 'Sắp chiếu'),
(4, 1, '2026-04-06 12:15:00', 85000, 'Sắp chiếu'),
(14, 1, '2026-04-06 15:30:00', 95000, 'Sắp chiếu'),
(11, 1, '2026-04-06 18:45:00', 105000, 'Sắp chiếu'),
(2, 1, '2026-04-06 22:00:00', 95000, 'Sắp chiếu'),
(17, 2, '2026-04-06 09:40:00', 75000, 'Sắp chiếu'),
(9, 2, '2026-04-06 12:55:00', 90000, 'Sắp chiếu'),
(18, 2, '2026-04-06 16:10:00', 100000, 'Sắp chiếu'),
(8, 2, '2026-04-06 19:25:00', 110000, 'Sắp chiếu'),
(1, 2, '2026-04-06 22:30:00', 100000, 'Sắp chiếu'),
(4, 3, '2026-04-06 10:10:00', 85000, 'Sắp chiếu'),
(1, 3, '2026-04-06 13:40:00', 100000, 'Sắp chiếu'),
(25, 3, '2026-04-06 17:10:00', 110000, 'Sắp chiếu'),
(22, 3, '2026-04-06 20:40:00', 120000, 'Sắp chiếu'),
(20, 4, '2026-04-06 11:00:00', 120000, 'Sắp chiếu'),
(5, 4, '2026-04-06 14:45:00', 135000, 'Sắp chiếu'),
(2, 4, '2026-04-06 18:30:00', 145000, 'Sắp chiếu'),
(23, 4, '2026-04-06 22:15:00', 155000, 'Sắp chiếu'),
(25, 5, '2026-04-06 08:50:00', 65000, 'Sắp chiếu'),
(2, 5, '2026-04-06 12:05:00', 80000, 'Sắp chiếu'),
(10, 5, '2026-04-06 15:20:00', 90000, 'Sắp chiếu'),
(2, 5, '2026-04-06 18:35:00', 100000, 'Sắp chiếu'),
(17, 5, '2026-04-06 21:50:00', 90000, 'Sắp chiếu'),
(16, 1, '2026-04-07 09:00:00', 70000, 'Sắp chiếu'),
(2, 1, '2026-04-07 12:15:00', 85000, 'Sắp chiếu'),
(8, 1, '2026-04-07 15:30:00', 95000, 'Sắp chiếu'),
(10, 1, '2026-04-07 18:45:00', 105000, 'Sắp chiếu'),
(4, 1, '2026-04-07 22:00:00', 95000, 'Sắp chiếu'),
(23, 2, '2026-04-07 09:40:00', 75000, 'Sắp chiếu'),
(7, 2, '2026-04-07 12:55:00', 90000, 'Sắp chiếu'),
(3, 2, '2026-04-07 16:10:00', 100000, 'Sắp chiếu'),
(12, 2, '2026-04-07 19:25:00', 110000, 'Sắp chiếu'),
(16, 2, '2026-04-07 22:30:00', 100000, 'Sắp chiếu'),
(3, 3, '2026-04-07 10:10:00', 85000, 'Sắp chiếu'),
(5, 3, '2026-04-07 13:40:00', 100000, 'Sắp chiếu'),
(26, 3, '2026-04-07 17:10:00', 110000, 'Sắp chiếu'),
(14, 3, '2026-04-07 20:40:00', 120000, 'Sắp chiếu'),
(7, 4, '2026-04-07 11:00:00', 120000, 'Sắp chiếu'),
(11, 4, '2026-04-07 14:45:00', 135000, 'Sắp chiếu'),
(2, 4, '2026-04-07 18:30:00', 145000, 'Sắp chiếu'),
(4, 4, '2026-04-07 22:15:00', 155000, 'Sắp chiếu'),
(6, 5, '2026-04-07 08:50:00', 65000, 'Sắp chiếu'),
(14, 5, '2026-04-07 12:05:00', 80000, 'Sắp chiếu'),
(4, 5, '2026-04-07 15:20:00', 90000, 'Sắp chiếu'),
(3, 5, '2026-04-07 18:35:00', 100000, 'Sắp chiếu'),
(1, 5, '2026-04-07 21:50:00', 90000, 'Sắp chiếu'),
(13, 1, '2026-04-08 09:00:00', 75000, 'Sắp chiếu'),
(3, 1, '2026-04-08 12:15:00', 85000, 'Sắp chiếu'),
(24, 1, '2026-04-08 15:30:00', 95000, 'Sắp chiếu'),
(20, 1, '2026-04-08 18:45:00', 105000, 'Sắp chiếu'),
(1, 1, '2026-04-08 22:00:00', 95000, 'Sắp chiếu'),
(4, 2, '2026-04-08 09:40:00', 80000, 'Sắp chiếu'),
(15, 2, '2026-04-08 12:55:00', 90000, 'Sắp chiếu'),
(4, 2, '2026-04-08 16:10:00', 100000, 'Sắp chiếu'),
(2, 2, '2026-04-08 19:25:00', 110000, 'Sắp chiếu'),
(25, 2, '2026-04-08 22:30:00', 100000, 'Sắp chiếu'),
(12, 3, '2026-04-08 10:10:00', 90000, 'Sắp chiếu'),
(9, 3, '2026-04-08 13:40:00', 100000, 'Sắp chiếu'),
(19, 3, '2026-04-08 17:10:00', 110000, 'Sắp chiếu'),
(18, 3, '2026-04-08 20:40:00', 120000, 'Sắp chiếu'),
(3, 4, '2026-04-08 11:00:00', 125000, 'Sắp chiếu'),
(2, 4, '2026-04-08 14:45:00', 135000, 'Sắp chiếu'),
(8, 4, '2026-04-08 18:30:00', 145000, 'Sắp chiếu'),
(9, 4, '2026-04-08 22:15:00', 155000, 'Sắp chiếu'),
(9, 5, '2026-04-08 08:50:00', 70000, 'Sắp chiếu'),
(17, 5, '2026-04-08 12:05:00', 80000, 'Sắp chiếu'),
(15, 5, '2026-04-08 15:20:00', 90000, 'Sắp chiếu'),
(26, 5, '2026-04-08 18:35:00', 100000, 'Sắp chiếu'),
(1, 5, '2026-04-08 21:50:00', 90000, 'Sắp chiếu'),
(7, 1, '2026-04-09 09:00:00', 75000, 'Sắp chiếu'),
(5, 1, '2026-04-09 12:15:00', 85000, 'Sắp chiếu'),
(23, 1, '2026-04-09 15:30:00', 95000, 'Sắp chiếu'),
(4, 1, '2026-04-09 18:45:00', 105000, 'Sắp chiếu'),
(3, 1, '2026-04-09 22:00:00', 95000, 'Sắp chiếu'),
(8, 2, '2026-04-09 09:40:00', 80000, 'Sắp chiếu'),
(9, 2, '2026-04-09 12:55:00', 90000, 'Sắp chiếu'),
(5, 2, '2026-04-09 16:10:00', 100000, 'Sắp chiếu'),
(4, 2, '2026-04-09 19:25:00', 110000, 'Sắp chiếu'),
(24, 2, '2026-04-09 22:30:00', 100000, 'Sắp chiếu'),
(9, 3, '2026-04-09 10:10:00', 90000, 'Sắp chiếu'),
(21, 3, '2026-04-09 13:40:00', 100000, 'Sắp chiếu'),
(13, 3, '2026-04-09 17:10:00', 110000, 'Sắp chiếu'),
(1, 3, '2026-04-09 20:40:00', 120000, 'Sắp chiếu'),
(26, 4, '2026-04-09 11:00:00', 125000, 'Sắp chiếu'),
(19, 4, '2026-04-09 14:45:00', 135000, 'Sắp chiếu'),
(25, 4, '2026-04-09 18:30:00', 145000, 'Sắp chiếu'),
(22, 4, '2026-04-09 22:15:00', 155000, 'Sắp chiếu'),
(19, 5, '2026-04-09 08:50:00', 70000, 'Sắp chiếu'),
(2, 5, '2026-04-09 12:05:00', 80000, 'Sắp chiếu'),
(12, 5, '2026-04-09 15:20:00', 90000, 'Sắp chiếu'),
(4, 5, '2026-04-09 18:35:00', 100000, 'Sắp chiếu'),
(8, 5, '2026-04-09 21:50:00', 90000, 'Sắp chiếu'),
(1, 1, '2026-04-10 09:00:00', 75000, 'Sắp chiếu'),
(7, 1, '2026-04-10 12:15:00', 85000, 'Sắp chiếu'),
(26, 1, '2026-04-10 15:30:00', 95000, 'Sắp chiếu'),
(5, 1, '2026-04-10 18:45:00', 115000, 'Sắp chiếu'),
(18, 1, '2026-04-10 22:00:00', 105000, 'Sắp chiếu'),
(8, 2, '2026-04-10 09:40:00', 80000, 'Sắp chiếu'),
(9, 2, '2026-04-10 12:55:00', 90000, 'Sắp chiếu'),
(24, 2, '2026-04-10 16:10:00', 100000, 'Sắp chiếu'),
(25, 2, '2026-04-10 19:25:00', 120000, 'Sắp chiếu'),
(13, 2, '2026-04-10 22:30:00', 110000, 'Sắp chiếu'),
(15, 3, '2026-04-10 10:10:00', 90000, 'Sắp chiếu'),
(2, 3, '2026-04-10 13:40:00', 100000, 'Sắp chiếu'),
(6, 3, '2026-04-10 17:10:00', 110000, 'Sắp chiếu'),
(24, 3, '2026-04-10 20:40:00', 130000, 'Sắp chiếu'),
(13, 4, '2026-04-10 11:00:00', 125000, 'Sắp chiếu'),
(10, 4, '2026-04-10 14:45:00', 135000, 'Sắp chiếu'),
(16, 4, '2026-04-10 18:30:00', 155000, 'Sắp chiếu'),
(1, 4, '2026-04-10 22:15:00', 165000, 'Sắp chiếu'),
(14, 5, '2026-04-10 08:50:00', 70000, 'Sắp chiếu'),
(8, 5, '2026-04-10 12:05:00', 80000, 'Sắp chiếu'),
(20, 5, '2026-04-10 15:20:00', 90000, 'Sắp chiếu'),
(3, 5, '2026-04-10 18:35:00', 110000, 'Sắp chiếu'),
(23, 5, '2026-04-10 21:50:00', 100000, 'Sắp chiếu'),
(1, 1, '2026-04-11 09:00:00', 85000, 'Sắp chiếu'),
(4, 1, '2026-04-11 12:15:00', 95000, 'Sắp chiếu'),
(13, 1, '2026-04-11 15:30:00', 105000, 'Sắp chiếu'),
(15, 1, '2026-04-11 18:45:00', 115000, 'Sắp chiếu'),
(4, 1, '2026-04-11 22:00:00', 105000, 'Sắp chiếu'),
(2, 2, '2026-04-11 09:40:00', 90000, 'Sắp chiếu'),
(21, 2, '2026-04-11 12:55:00', 100000, 'Sắp chiếu'),
(6, 2, '2026-04-11 16:10:00', 110000, 'Sắp chiếu'),
(13, 2, '2026-04-11 19:25:00', 120000, 'Sắp chiếu'),
(14, 2, '2026-04-11 22:30:00', 110000, 'Sắp chiếu'),
(7, 3, '2026-04-11 10:10:00', 100000, 'Sắp chiếu'),
(15, 3, '2026-04-11 13:40:00', 110000, 'Sắp chiếu'),
(10, 3, '2026-04-11 17:10:00', 120000, 'Sắp chiếu'),
(23, 3, '2026-04-11 20:40:00', 130000, 'Sắp chiếu'),
(3, 4, '2026-04-11 11:00:00', 135000, 'Sắp chiếu'),
(17, 4, '2026-04-11 14:45:00', 145000, 'Sắp chiếu'),
(5, 4, '2026-04-11 18:30:00', 155000, 'Sắp chiếu'),
(7, 4, '2026-04-11 22:15:00', 165000, 'Sắp chiếu'),
(16, 5, '2026-04-11 08:50:00', 80000, 'Sắp chiếu'),
(5, 5, '2026-04-11 12:05:00', 90000, 'Sắp chiếu'),
(7, 5, '2026-04-11 15:20:00', 100000, 'Sắp chiếu'),
(18, 5, '2026-04-11 18:35:00', 110000, 'Sắp chiếu'),
(1, 5, '2026-04-11 21:50:00', 100000, 'Sắp chiếu'),
(7, 1, '2026-04-12 09:00:00', 85000, 'Sắp chiếu'),
(25, 1, '2026-04-12 12:15:00', 95000, 'Sắp chiếu'),
(24, 1, '2026-04-12 15:30:00', 105000, 'Sắp chiếu'),
(1, 1, '2026-04-12 18:45:00', 115000, 'Sắp chiếu'),
(5, 1, '2026-04-12 22:00:00', 105000, 'Sắp chiếu'),
(7, 2, '2026-04-12 09:40:00', 90000, 'Sắp chiếu'),
(19, 2, '2026-04-12 12:55:00', 100000, 'Sắp chiếu'),
(17, 2, '2026-04-12 16:10:00', 110000, 'Sắp chiếu'),
(18, 2, '2026-04-12 19:25:00', 120000, 'Sắp chiếu'),
(7, 2, '2026-04-12 22:30:00', 110000, 'Sắp chiếu'),
(2, 3, '2026-04-12 10:10:00', 100000, 'Sắp chiếu'),
(17, 3, '2026-04-12 13:40:00', 110000, 'Sắp chiếu'),
(15, 3, '2026-04-12 17:10:00', 120000, 'Sắp chiếu'),
(12, 3, '2026-04-12 20:40:00', 130000, 'Sắp chiếu'),
(21, 4, '2026-04-12 11:00:00', 135000, 'Sắp chiếu'),
(14, 4, '2026-04-12 14:45:00', 145000, 'Sắp chiếu'),
(1, 4, '2026-04-12 18:30:00', 155000, 'Sắp chiếu'),
(16, 4, '2026-04-12 22:15:00', 165000, 'Sắp chiếu'),
(4, 5, '2026-04-12 08:50:00', 80000, 'Sắp chiếu'),
(12, 5, '2026-04-12 12:05:00', 90000, 'Sắp chiếu'),
(19, 5, '2026-04-12 15:20:00', 100000, 'Sắp chiếu'),
(8, 5, '2026-04-12 18:35:00', 110000, 'Sắp chiếu'),
(10, 5, '2026-04-12 21:50:00', 100000, 'Sắp chiếu');

INSERT INTO LoaiVe (TenLoaiVe, PhuThuGia, MoTa) VALUES
('Vé thường', 0, 'Áp dụng cho ghế thường'),
('Vé VIP', 20000, 'Áp dụng cho ghế VIP'),
('Vé đôi', 50000, 'Áp dụng cho ghế đôi'),
('Vé Deluxe', 30000, 'Áp dụng cho ghế Deluxe');

INSERT INTO Ve (MaSuatChieu, MaGheNgoi, MaLoaiVe, GiaVe, TrangThaiVe)
SELECT
    sc.MaSuatChieu,
    g.MaGheNgoi,
    lv.MaLoaiVe,
    sc.GiaVeCoBan + lv.PhuThuGia,
    'Chưa bán'
FROM SuatChieu sc
JOIN GheNgoi g ON g.MaPhongChieu = sc.MaPhongChieu
JOIN LoaiGheNgoi lgn ON lgn.MaLoaiGheNgoi = g.MaLoaiGheNgoi
JOIN LoaiVe lv ON (
    (lgn.TenLoaiGheNgoi = 'Ghế thường' AND lv.TenLoaiVe = 'Vé thường') OR
    (lgn.TenLoaiGheNgoi = 'Ghế VIP' AND lv.TenLoaiVe = 'Vé VIP') OR
    (lgn.TenLoaiGheNgoi = 'Ghế đôi' AND lv.TenLoaiVe = 'Vé đôi') OR
    (lgn.TenLoaiGheNgoi = 'Ghế Deluxe' AND lv.TenLoaiVe = 'Vé Deluxe')
);

INSERT INTO DonHang (MaDonHang, MaKhachHang, MaNhanVien, MaKhuyenMai, NgayLap, TrangThaiDonHang, GhiChu) VALUES
(1, 3, 12, NULL, '2026-04-01 07:45:00', 'Đã thanh toán', 'Đơn realistic #0001'),
(2, NULL, 2, NULL, '2026-04-01 07:38:00', 'Đã thanh toán', 'Đơn realistic #0002'),
(3, 9, 3, NULL, '2026-04-01 10:08:00', 'Đã thanh toán', 'Đơn realistic #0003'),
(4, 20, 3, NULL, '2026-04-01 11:50:00', 'Đã thanh toán', 'Đơn realistic #0004'),
(5, NULL, 12, NULL, '2026-04-01 09:50:00', 'Đã thanh toán', 'Đơn realistic #0005'),
(6, 8, 3, NULL, '2026-04-01 10:54:00', 'Đã thanh toán', 'Đơn realistic #0006'),
(7, NULL, 12, NULL, '2026-04-01 09:43:00', 'Đã thanh toán', 'Đơn realistic #0007'),
(8, 11, 3, NULL, '2026-04-01 15:10:00', 'Đã thanh toán', 'Đơn realistic #0008'),
(9, 18, 3, NULL, '2026-04-01 13:04:00', 'Đã thanh toán', 'Đơn realistic #0009'),
(10, 26, 2, 3, '2026-04-01 13:24:00', 'Đã thanh toán', 'Đơn realistic #0010'),
(11, 11, 8, NULL, '2026-04-01 13:36:00', 'Đã thanh toán', 'Đơn realistic #0011'),
(12, 35, 4, 3, '2026-04-01 12:57:00', 'Đã thanh toán', 'Đơn realistic #0012'),
(13, 5, 8, NULL, '2026-04-01 12:43:00', 'Đã thanh toán', 'Đơn realistic #0013'),
(14, 31, 8, NULL, '2026-04-01 13:14:00', 'Đã thanh toán', 'Đơn realistic #0014'),
(15, 6, 8, NULL, '2026-04-01 13:06:00', 'Đã thanh toán', 'Đơn realistic #0015'),
(16, NULL, 2, NULL, '2026-04-01 17:40:00', 'Đã thanh toán', 'Đơn realistic #0016'),
(17, 4, 8, NULL, '2026-04-01 16:00:00', 'Đã thanh toán', 'Đơn realistic #0017'),
(18, NULL, 12, NULL, '2026-04-01 17:38:00', 'Đã thanh toán', 'Đơn realistic #0018'),
(19, NULL, 12, 2, '2026-04-01 16:20:00', 'Đã thanh toán', 'Đơn realistic #0019'),
(20, 10, 3, NULL, '2026-04-01 16:46:00', 'Đã thanh toán', 'Đơn realistic #0020'),
(21, 36, 2, NULL, '2026-04-01 16:24:00', 'Đã thanh toán', 'Đơn realistic #0021'),
(22, 34, 8, NULL, '2026-04-01 17:21:00', 'Đã thanh toán', 'Đơn realistic #0022'),
(23, NULL, 4, NULL, '2026-04-01 21:18:00', 'Đã thanh toán', 'Đơn realistic #0023'),
(24, 36, 8, NULL, '2026-04-01 21:08:00', 'Đã thanh toán', 'Đơn realistic #0024'),
(25, NULL, 4, NULL, '2026-04-01 20:06:00', 'Đã thanh toán', 'Đơn realistic #0025'),
(26, 8, 12, NULL, '2026-04-01 19:56:00', 'Đã thanh toán', 'Đơn realistic #0026'),
(27, 23, 4, NULL, '2026-04-01 21:24:00', 'Đã thanh toán', 'Đơn realistic #0027'),
(28, 37, 12, NULL, '2026-04-01 08:23:00', 'Đã thanh toán', 'Đơn realistic #0028'),
(29, NULL, 4, 2, '2026-04-01 08:23:00', 'Đã thanh toán', 'Đơn realistic #0029'),
(30, 17, 4, NULL, '2026-04-01 09:19:00', 'Đã thanh toán', 'Đơn realistic #0030'),
(31, 39, 4, NULL, '2026-04-01 11:07:00', 'Đã thanh toán', 'Đơn realistic #0031'),
(32, 26, 8, NULL, '2026-04-01 10:23:00', 'Đã thanh toán', 'Đơn realistic #0032'),
(33, NULL, 3, 2, '2026-04-01 12:24:00', 'Đã thanh toán', 'Đơn realistic #0033'),
(34, 36, 4, NULL, '2026-04-01 10:58:00', 'Đã thanh toán', 'Đơn realistic #0034'),
(35, 11, 12, 2, '2026-04-01 15:10:00', 'Đã thanh toán', 'Đơn realistic #0035'),
(36, 11, 4, NULL, '2026-04-01 15:26:00', 'Đã thanh toán', 'Đơn realistic #0036'),
(37, 11, 3, 5, '2026-04-01 15:13:00', 'Đã thanh toán', 'Đơn realistic #0037'),
(38, NULL, 4, NULL, '2026-04-01 15:47:00', 'Đã thanh toán', 'Đơn realistic #0038'),
(39, 13, 8, NULL, '2026-04-01 15:34:00', 'Đã thanh toán', 'Đơn realistic #0039'),
(40, 37, 2, NULL, '2026-04-01 14:54:00', 'Đã thanh toán', 'Đơn realistic #0040'),
(41, NULL, 8, NULL, '2026-04-01 15:06:00', 'Đã thanh toán', 'Đơn realistic #0041'),
(42, NULL, 3, NULL, '2026-04-01 18:50:00', 'Đã thanh toán', 'Đơn realistic #0042'),
(43, 35, 3, NULL, '2026-04-01 18:15:00', 'Đã thanh toán', 'Đơn realistic #0043'),
(44, 37, 3, NULL, '2026-04-01 17:37:00', 'Đã thanh toán', 'Đơn realistic #0044'),
(45, 18, 2, NULL, '2026-04-01 18:01:00', 'Đã thanh toán', 'Đơn realistic #0045'),
(46, 23, 12, NULL, '2026-04-01 18:33:00', 'Đã thanh toán', 'Đơn realistic #0046'),
(47, 16, 12, NULL, '2026-04-01 18:29:00', 'Đã thanh toán', 'Đơn realistic #0047'),
(48, 38, 2, NULL, '2026-04-01 20:59:00', 'Đã thanh toán', 'Đơn realistic #0048'),
(49, NULL, 2, NULL, '2026-04-01 22:02:00', 'Đã thanh toán', 'Đơn realistic #0049'),
(50, NULL, 4, NULL, '2026-04-01 21:01:00', 'Đã thanh toán', 'Đơn realistic #0050'),
(51, 13, 8, NULL, '2026-04-01 20:56:00', 'Đã thanh toán', 'Đơn realistic #0051'),
(52, 35, 12, NULL, '2026-04-01 21:26:00', 'Đã thanh toán', 'Đơn realistic #0052'),
(53, 1, 2, NULL, '2026-04-01 21:39:00', 'Đã thanh toán', 'Đơn realistic #0053'),
(54, NULL, 4, 4, '2026-04-01 21:33:00', 'Đã thanh toán', 'Đơn realistic #0054'),
(55, 11, 8, NULL, '2026-04-01 09:28:00', 'Đã thanh toán', 'Đơn realistic #0055'),
(56, 29, 3, 2, '2026-04-01 08:47:00', 'Đã thanh toán', 'Đơn realistic #0056'),
(57, NULL, 3, NULL, '2026-04-01 08:42:00', 'Đã thanh toán', 'Đơn realistic #0057'),
(58, 40, 3, NULL, '2026-04-01 09:17:00', 'Đã thanh toán', 'Đơn realistic #0058'),
(59, 36, 4, NULL, '2026-04-01 12:59:00', 'Đã thanh toán', 'Đơn realistic #0059'),
(60, NULL, 3, 2, '2026-04-01 12:56:00', 'Đã thanh toán', 'Đơn realistic #0060'),
(61, 4, 3, NULL, '2026-04-01 12:00:00', 'Đã thanh toán', 'Đơn realistic #0061'),
(62, 26, 4, NULL, '2026-04-01 15:56:00', 'Đã thanh toán', 'Đơn realistic #0062'),
(63, 39, 8, NULL, '2026-04-01 16:00:00', 'Đã thanh toán', 'Đơn realistic #0063'),
(64, NULL, 3, NULL, '2026-04-01 16:12:00', 'Đã thanh toán', 'Đơn realistic #0064'),
(65, 18, 12, 2, '2026-04-01 16:44:00', 'Đã thanh toán', 'Đơn realistic #0065'),
(66, 22, 4, 2, '2026-04-01 15:27:00', 'Đã thanh toán', 'Đơn realistic #0066'),
(67, 30, 2, NULL, '2026-04-01 14:44:00', 'Đã thanh toán', 'Đơn realistic #0067'),
(68, NULL, 4, 5, '2026-04-01 19:36:00', 'Đã thanh toán', 'Đơn realistic #0068'),
(69, 24, 12, NULL, '2026-04-01 18:49:00', 'Đã thanh toán', 'Đơn realistic #0069'),
(70, 20, 8, NULL, '2026-04-01 19:06:00', 'Đã thanh toán', 'Đơn realistic #0070'),
(71, NULL, 2, NULL, '2026-04-01 18:05:00', 'Đã thanh toán', 'Đơn realistic #0071'),
(72, 39, 3, NULL, '2026-04-01 19:35:00', 'Đã thanh toán', 'Đơn realistic #0072'),
(73, 12, 12, NULL, '2026-04-01 19:37:00', 'Đã thanh toán', 'Đơn realistic #0073'),
(74, 23, 12, NULL, '2026-04-01 18:23:00', 'Đã thanh toán', 'Đơn realistic #0074'),
(75, 7, 3, 5, '2026-04-01 18:25:00', 'Đã thanh toán', 'Đơn realistic #0075'),
(76, 16, 12, NULL, '2026-04-01 19:32:00', 'Đã thanh toán', 'Đơn realistic #0076'),
(77, 37, 2, NULL, '2026-04-01 19:14:00', 'Đã thanh toán', 'Đơn realistic #0077'),
(78, 32, 8, 2, '2026-04-01 10:38:00', 'Đã thanh toán', 'Đơn realistic #0078'),
(79, 21, 4, NULL, '2026-04-01 10:14:00', 'Đã thanh toán', 'Đơn realistic #0079'),
(80, NULL, 8, 5, '2026-04-01 09:46:00', 'Đã thanh toán', 'Đơn realistic #0080'),
(81, 8, 8, NULL, '2026-04-01 09:50:00', 'Đã thanh toán', 'Đơn realistic #0081'),
(82, 3, 8, NULL, '2026-04-01 12:54:00', 'Đã thanh toán', 'Đơn realistic #0082'),
(83, 16, 2, NULL, '2026-04-01 14:02:00', 'Đã thanh toán', 'Đơn realistic #0083'),
(84, 2, 4, NULL, '2026-04-01 11:50:00', 'Đã thanh toán', 'Đơn realistic #0084'),
(85, 24, 4, NULL, '2026-04-01 16:29:00', 'Đã thanh toán', 'Đơn realistic #0085'),
(86, NULL, 3, 5, '2026-04-01 16:06:00', 'Đã thanh toán', 'Đơn realistic #0086'),
(87, NULL, 3, NULL, '2026-04-01 17:36:00', 'Đã thanh toán', 'Đơn realistic #0087'),
(88, NULL, 12, NULL, '2026-04-01 16:08:00', 'Đã thanh toán', 'Đơn realistic #0088'),
(89, 16, 3, 5, '2026-04-01 17:56:00', 'Đã thanh toán', 'Đơn realistic #0089'),
(90, 21, 2, NULL, '2026-04-01 17:40:00', 'Đã thanh toán', 'Đơn realistic #0090'),
(91, 10, 8, 2, '2026-04-01 21:45:00', 'Đã thanh toán', 'Đơn realistic #0091'),
(92, 15, 12, 2, '2026-04-01 20:10:00', 'Đã thanh toán', 'Đơn realistic #0092'),
(93, NULL, 3, NULL, '2026-04-01 20:44:00', 'Đã thanh toán', 'Đơn realistic #0093'),
(94, 15, 8, NULL, '2026-04-01 21:05:00', 'Đã thanh toán', 'Đơn realistic #0094'),
(95, NULL, 8, NULL, '2026-04-01 19:19:00', 'Đã thanh toán', 'Đơn realistic #0095'),
(96, 18, 4, NULL, '2026-04-01 20:19:00', 'Đã thanh toán', 'Đơn realistic #0096'),
(97, 3, 12, NULL, '2026-04-01 07:25:00', 'Đã thanh toán', 'Đơn realistic #0097'),
(98, 27, 8, NULL, '2026-04-01 07:24:00', 'Đã thanh toán', 'Đơn realistic #0098'),
(99, 3, 12, NULL, '2026-04-01 07:23:00', 'Đã thanh toán', 'Đơn realistic #0099'),
(100, 12, 12, NULL, '2026-04-01 09:35:00', 'Đã thanh toán', 'Đơn realistic #0100'),
(101, 39, 3, NULL, '2026-04-01 10:16:00', 'Đã thanh toán', 'Đơn realistic #0101'),
(102, 28, 3, NULL, '2026-04-01 10:36:00', 'Đã thanh toán', 'Đơn realistic #0102'),
(103, 31, 2, NULL, '2026-04-01 10:12:00', 'Đã thanh toán', 'Đơn realistic #0103'),
(104, 34, 2, NULL, '2026-04-01 13:03:00', 'Đã thanh toán', 'Đơn realistic #0104'),
(105, NULL, 8, NULL, '2026-04-01 13:36:00', 'Đã thanh toán', 'Đơn realistic #0105'),
(106, 23, 4, NULL, '2026-04-01 14:52:00', 'Đã thanh toán', 'Đơn realistic #0106'),
(107, 16, 8, 2, '2026-04-01 17:04:00', 'Đã thanh toán', 'Đơn realistic #0107'),
(108, 2, 12, 2, '2026-04-01 17:18:00', 'Đã thanh toán', 'Đơn realistic #0108'),
(109, 30, 3, NULL, '2026-04-01 15:58:00', 'Đã thanh toán', 'Đơn realistic #0109'),
(110, NULL, 3, 2, '2026-04-01 15:57:00', 'Đã thanh toán', 'Đơn realistic #0110'),
(111, 9, 3, NULL, '2026-04-01 18:00:00', 'Đã thanh toán', 'Đơn realistic #0111'),
(112, NULL, 3, NULL, '2026-04-01 19:44:00', 'Đã thanh toán', 'Đơn realistic #0112'),
(113, NULL, 2, NULL, '2026-04-01 19:54:00', 'Đã thanh toán', 'Đơn realistic #0113'),
(114, 32, 8, NULL, '2026-04-01 18:55:00', 'Đã thanh toán', 'Đơn realistic #0114'),
(115, NULL, 4, 4, '2026-04-01 20:42:00', 'Đã thanh toán', 'Đơn realistic #0115'),
(116, 2, 2, NULL, '2026-04-01 19:00:00', 'Đã thanh toán', 'Đơn realistic #0116'),
(117, 20, 3, 2, '2026-04-01 20:28:00', 'Đã thanh toán', 'Đơn realistic #0117'),
(118, NULL, 8, 2, '2026-04-02 08:12:00', 'Đã thanh toán', 'Đơn realistic #0118'),
(119, 10, 4, NULL, '2026-04-02 07:55:00', 'Đã thanh toán', 'Đơn realistic #0119'),
(120, 39, 8, NULL, '2026-04-02 08:22:00', 'Đã thanh toán', 'Đơn realistic #0120'),
(121, NULL, 2, NULL, '2026-04-02 07:32:00', 'Đã thanh toán', 'Đơn realistic #0121'),
(122, 8, 12, 2, '2026-04-02 09:36:00', 'Đã thanh toán', 'Đơn realistic #0122'),
(123, NULL, 4, NULL, '2026-04-02 10:17:00', 'Đã thanh toán', 'Đơn realistic #0123'),
(124, NULL, 2, NULL, '2026-04-02 11:26:00', 'Đã thanh toán', 'Đơn realistic #0124'),
(125, NULL, 2, NULL, '2026-04-02 14:00:00', 'Đã thanh toán', 'Đơn realistic #0125'),
(126, 12, 3, 2, '2026-04-02 13:59:00', 'Đã thanh toán', 'Đơn realistic #0126'),
(127, NULL, 2, NULL, '2026-04-02 13:51:00', 'Đã thanh toán', 'Đơn realistic #0127'),
(128, 13, 12, NULL, '2026-04-02 14:16:00', 'Đã thanh toán', 'Đơn realistic #0128'),
(129, NULL, 8, NULL, '2026-04-02 14:37:00', 'Đã thanh toán', 'Đơn realistic #0129'),
(130, NULL, 12, NULL, '2026-04-02 17:10:00', 'Đã thanh toán', 'Đơn realistic #0130'),
(131, NULL, 4, NULL, '2026-04-02 16:26:00', 'Đã thanh toán', 'Đơn realistic #0131'),
(132, NULL, 2, NULL, '2026-04-02 17:05:00', 'Đã thanh toán', 'Đơn realistic #0132'),
(133, NULL, 3, NULL, '2026-04-02 17:40:00', 'Đã thanh toán', 'Đơn realistic #0133'),
(134, 9, 4, 2, '2026-04-02 17:27:00', 'Đã thanh toán', 'Đơn realistic #0134'),
(135, 27, 2, NULL, '2026-04-02 18:13:00', 'Đã thanh toán', 'Đơn realistic #0135'),
(136, 12, 8, NULL, '2026-04-02 16:49:00', 'Đã thanh toán', 'Đơn realistic #0136'),
(137, NULL, 2, NULL, '2026-04-02 20:04:00', 'Đã thanh toán', 'Đơn realistic #0137'),
(138, NULL, 2, 2, '2026-04-02 19:19:00', 'Đã thanh toán', 'Đơn realistic #0138'),
(139, NULL, 12, NULL, '2026-04-02 19:14:00', 'Đã thanh toán', 'Đơn realistic #0139'),
(140, NULL, 2, NULL, '2026-04-02 20:27:00', 'Đã thanh toán', 'Đơn realistic #0140'),
(141, 38, 8, NULL, '2026-04-02 20:26:00', 'Đã thanh toán', 'Đơn realistic #0141'),
(142, NULL, 3, NULL, '2026-04-02 21:04:00', 'Đã thanh toán', 'Đơn realistic #0142'),
(143, 20, 12, NULL, '2026-04-02 08:58:00', 'Đã thanh toán', 'Đơn realistic #0143'),
(144, 7, 12, NULL, '2026-04-02 08:16:00', 'Đã thanh toán', 'Đơn realistic #0144'),
(145, 31, 12, NULL, '2026-04-02 08:48:00', 'Đã thanh toán', 'Đơn realistic #0145'),
(146, 27, 4, NULL, '2026-04-02 10:09:00', 'Đã thanh toán', 'Đơn realistic #0146'),
(147, 34, 12, NULL, '2026-04-02 11:18:00', 'Đã thanh toán', 'Đơn realistic #0147'),
(148, NULL, 8, NULL, '2026-04-02 10:20:00', 'Đã thanh toán', 'Đơn realistic #0148'),
(149, NULL, 12, NULL, '2026-04-02 11:21:00', 'Đã thanh toán', 'Đơn realistic #0149'),
(150, 26, 2, 2, '2026-04-02 10:29:00', 'Đã thanh toán', 'Đơn realistic #0150'),
(151, 8, 3, NULL, '2026-04-02 11:55:00', 'Đã thanh toán', 'Đơn realistic #0151'),
(152, 4, 3, NULL, '2026-04-02 12:15:00', 'Đã thanh toán', 'Đơn realistic #0152'),
(153, 22, 2, NULL, '2026-04-02 14:16:00', 'Đã thanh toán', 'Đơn realistic #0153'),
(154, NULL, 8, 5, '2026-04-02 13:54:00', 'Đã thanh toán', 'Đơn realistic #0154'),
(155, NULL, 4, NULL, '2026-04-02 14:33:00', 'Đã thanh toán', 'Đơn realistic #0155'),
(156, 31, 3, NULL, '2026-04-02 16:33:00', 'Đã thanh toán', 'Đơn realistic #0156'),
(157, NULL, 12, NULL, '2026-04-02 17:18:00', 'Đã thanh toán', 'Đơn realistic #0157'),
(158, 39, 12, NULL, '2026-04-02 17:53:00', 'Đã thanh toán', 'Đơn realistic #0158'),
(159, 8, 3, NULL, '2026-04-02 16:50:00', 'Đã thanh toán', 'Đơn realistic #0159'),
(160, 40, 12, NULL, '2026-04-02 16:44:00', 'Đã thanh toán', 'Đơn realistic #0160'),
(161, 16, 12, 5, '2026-04-02 21:18:00', 'Đã thanh toán', 'Đơn realistic #0161'),
(162, NULL, 8, NULL, '2026-04-02 21:01:00', 'Đã thanh toán', 'Đơn realistic #0162'),
(163, 29, 12, NULL, '2026-04-02 21:36:00', 'Đã thanh toán', 'Đơn realistic #0163'),
(164, 21, 4, NULL, '2026-04-02 20:48:00', 'Đã thanh toán', 'Đơn realistic #0164'),
(165, NULL, 2, 2, '2026-04-02 09:05:00', 'Đã thanh toán', 'Đơn realistic #0165'),
(166, NULL, 4, 2, '2026-04-02 08:52:00', 'Đã thanh toán', 'Đơn realistic #0166'),
(167, 12, 3, NULL, '2026-04-02 09:36:00', 'Đã thanh toán', 'Đơn realistic #0167'),
(168, 21, 8, 5, '2026-04-02 11:49:00', 'Đã thanh toán', 'Đơn realistic #0168'),
(169, 15, 4, NULL, '2026-04-02 11:22:00', 'Đã thanh toán', 'Đơn realistic #0169'),
(170, 12, 4, NULL, '2026-04-02 13:01:00', 'Đã thanh toán', 'Đơn realistic #0170'),
(171, NULL, 4, NULL, '2026-04-02 15:30:00', 'Đã thanh toán', 'Đơn realistic #0171'),
(172, NULL, 2, NULL, '2026-04-02 16:06:00', 'Đã thanh toán', 'Đơn realistic #0172'),
(173, 37, 2, 2, '2026-04-02 15:17:00', 'Đã thanh toán', 'Đơn realistic #0173'),
(174, 4, 3, NULL, '2026-04-02 14:53:00', 'Đã thanh toán', 'Đơn realistic #0174'),
(175, 22, 4, NULL, '2026-04-02 17:48:00', 'Đã thanh toán', 'Đơn realistic #0175'),
(176, NULL, 8, NULL, '2026-04-02 18:43:00', 'Đã thanh toán', 'Đơn realistic #0176'),
(177, 30, 3, NULL, '2026-04-02 18:22:00', 'Đã thanh toán', 'Đơn realistic #0177'),
(178, 18, 2, NULL, '2026-04-02 20:04:00', 'Đã thanh toán', 'Đơn realistic #0178'),
(179, 3, 3, NULL, '2026-04-02 19:17:00', 'Đã thanh toán', 'Đơn realistic #0179'),
(180, 7, 3, 3, '2026-04-02 19:08:00', 'Đã thanh toán', 'Đơn realistic #0180'),
(181, 9, 2, NULL, '2026-04-02 20:04:00', 'Đã thanh toán', 'Đơn realistic #0181'),
(182, 12, 12, NULL, '2026-04-02 10:03:00', 'Đã thanh toán', 'Đơn realistic #0182'),
(183, NULL, 12, NULL, '2026-04-02 10:07:00', 'Đã thanh toán', 'Đơn realistic #0183'),
(184, 24, 2, 2, '2026-04-02 09:32:00', 'Đã thanh toán', 'Đơn realistic #0184'),
(185, NULL, 3, NULL, '2026-04-02 14:05:00', 'Đã thanh toán', 'Đơn realistic #0185'),
(186, NULL, 3, NULL, '2026-04-02 13:23:00', 'Đã thanh toán', 'Đơn realistic #0186'),
(187, NULL, 8, 2, '2026-04-02 12:26:00', 'Đã thanh toán', 'Đơn realistic #0187'),
(188, 32, 3, NULL, '2026-04-02 13:05:00', 'Đã thanh toán', 'Đơn realistic #0188'),
(189, 3, 8, 2, '2026-04-02 15:59:00', 'Đã thanh toán', 'Đơn realistic #0189'),
(190, NULL, 2, 5, '2026-04-02 16:25:00', 'Đã thanh toán', 'Đơn realistic #0190'),
(191, 6, 3, NULL, '2026-04-02 16:50:00', 'Đã thanh toán', 'Đơn realistic #0191'),
(192, 34, 12, 3, '2026-04-02 15:52:00', 'Đã thanh toán', 'Đơn realistic #0192'),
(193, NULL, 12, NULL, '2026-04-02 18:02:00', 'Đã thanh toán', 'Đơn realistic #0193'),
(194, 2, 2, 2, '2026-04-02 21:17:00', 'Đã thanh toán', 'Đơn realistic #0194'),
(195, NULL, 4, NULL, '2026-04-02 20:14:00', 'Đã thanh toán', 'Đơn realistic #0195'),
(196, 31, 2, NULL, '2026-04-02 21:19:00', 'Đã thanh toán', 'Đơn realistic #0196'),
(197, 28, 12, 4, '2026-04-02 19:40:00', 'Đã thanh toán', 'Đơn realistic #0197'),
(198, 31, 12, NULL, '2026-04-02 19:49:00', 'Đã thanh toán', 'Đơn realistic #0198'),
(199, NULL, 8, NULL, '2026-04-02 20:09:00', 'Đã thanh toán', 'Đơn realistic #0199'),
(200, 2, 4, NULL, '2026-04-02 08:12:00', 'Đã thanh toán', 'Đơn realistic #0200'),
(201, NULL, 8, NULL, '2026-04-02 07:22:00', 'Đã thanh toán', 'Đơn realistic #0201'),
(202, 22, 8, NULL, '2026-04-02 08:18:00', 'Đã thanh toán', 'Đơn realistic #0202'),
(203, 2, 12, NULL, '2026-04-02 11:01:00', 'Đã thanh toán', 'Đơn realistic #0203'),
(204, NULL, 12, 2, '2026-04-02 10:54:00', 'Đã thanh toán', 'Đơn realistic #0204'),
(205, 22, 3, NULL, '2026-04-02 10:19:00', 'Đã thanh toán', 'Đơn realistic #0205'),
(206, NULL, 4, NULL, '2026-04-02 11:12:00', 'Đã thanh toán', 'Đơn realistic #0206'),
(207, NULL, 2, NULL, '2026-04-02 09:35:00', 'Đã thanh toán', 'Đơn realistic #0207'),
(208, 26, 8, NULL, '2026-04-02 13:39:00', 'Đã thanh toán', 'Đơn realistic #0208'),
(209, 40, 8, NULL, '2026-04-02 13:52:00', 'Đã thanh toán', 'Đơn realistic #0209'),
(210, 37, 2, NULL, '2026-04-02 13:19:00', 'Đã thanh toán', 'Đơn realistic #0210'),
(211, 1, 12, NULL, '2026-04-02 16:14:00', 'Đã thanh toán', 'Đơn realistic #0211'),
(212, 35, 2, NULL, '2026-04-02 17:49:00', 'Đã thanh toán', 'Đơn realistic #0212'),
(213, NULL, 12, NULL, '2026-04-02 16:38:00', 'Đã thanh toán', 'Đơn realistic #0213'),
(214, 1, 12, NULL, '2026-04-02 15:52:00', 'Đã thanh toán', 'Đơn realistic #0214'),
(215, 14, 3, NULL, '2026-04-02 18:11:00', 'Đã thanh toán', 'Đơn realistic #0215'),
(216, 38, 8, 2, '2026-04-02 17:07:00', 'Đã thanh toán', 'Đơn realistic #0216'),
(217, 34, 2, NULL, '2026-04-02 18:11:00', 'Đã thanh toán', 'Đơn realistic #0217'),
(218, 16, 3, NULL, '2026-04-02 16:41:00', 'Đã thanh toán', 'Đơn realistic #0218'),
(219, 30, 4, 4, '2026-04-02 19:56:00', 'Đã thanh toán', 'Đơn realistic #0219'),
(220, 6, 2, NULL, '2026-04-02 19:30:00', 'Đã thanh toán', 'Đơn realistic #0220'),
(221, 30, 4, NULL, '2026-04-02 19:03:00', 'Đã thanh toán', 'Đơn realistic #0221'),
(222, 25, 3, 4, '2026-04-02 20:25:00', 'Đã thanh toán', 'Đơn realistic #0222'),
(223, NULL, 2, NULL, '2026-04-02 19:45:00', 'Đã thanh toán', 'Đơn realistic #0223'),
(224, 35, 4, 3, '2026-04-03 08:00:00', 'Đã thanh toán', 'Đơn realistic #0224'),
(225, NULL, 3, NULL, '2026-04-03 08:25:00', 'Đã thanh toán', 'Đơn realistic #0225'),
(226, 26, 3, 3, '2026-04-03 07:32:00', 'Đã thanh toán', 'Đơn realistic #0226'),
(227, NULL, 2, NULL, '2026-04-03 08:06:00', 'Đã thanh toán', 'Đơn realistic #0227'),
(228, 28, 4, NULL, '2026-04-03 08:08:00', 'Đã thanh toán', 'Đơn realistic #0228'),
(229, 30, 3, NULL, '2026-04-03 07:48:00', 'Đã thanh toán', 'Đơn realistic #0229'),
(230, NULL, 12, NULL, '2026-04-03 11:25:00', 'Đã thanh toán', 'Đơn realistic #0230'),
(231, 5, 3, NULL, '2026-04-03 10:41:00', 'Đã thanh toán', 'Đơn realistic #0231'),
(232, NULL, 3, 2, '2026-04-03 10:39:00', 'Đã thanh toán', 'Đơn realistic #0232'),
(233, 14, 4, NULL, '2026-04-03 10:48:00', 'Đã thanh toán', 'Đơn realistic #0233'),
(234, 11, 2, NULL, '2026-04-03 10:09:00', 'Đã thanh toán', 'Đơn realistic #0234'),
(235, 12, 4, 2, '2026-04-03 11:13:00', 'Đã thanh toán', 'Đơn realistic #0235'),
(236, 18, 2, NULL, '2026-04-03 14:40:00', 'Đã thanh toán', 'Đơn realistic #0236'),
(237, 18, 4, NULL, '2026-04-03 14:37:00', 'Đã thanh toán', 'Đơn realistic #0237'),
(238, 36, 4, 2, '2026-04-03 13:58:00', 'Đã thanh toán', 'Đơn realistic #0238'),
(239, 7, 8, 3, '2026-04-03 14:28:00', 'Đã thanh toán', 'Đơn realistic #0239'),
(240, 38, 3, NULL, '2026-04-03 13:52:00', 'Đã thanh toán', 'Đơn realistic #0240'),
(241, 4, 8, NULL, '2026-04-03 12:51:00', 'Đã thanh toán', 'Đơn realistic #0241'),
(242, 3, 12, NULL, '2026-04-03 14:14:00', 'Đã thanh toán', 'Đơn realistic #0242'),
(243, 24, 2, NULL, '2026-04-03 13:21:00', 'Đã thanh toán', 'Đơn realistic #0243'),
(244, 27, 12, NULL, '2026-04-03 18:17:00', 'Đã thanh toán', 'Đơn realistic #0244'),
(245, 32, 2, NULL, '2026-04-03 18:15:00', 'Đã thanh toán', 'Đơn realistic #0245'),
(246, 25, 8, 3, '2026-04-03 17:12:00', 'Đã thanh toán', 'Đơn realistic #0246'),
(247, 22, 2, NULL, '2026-04-03 18:15:00', 'Đã thanh toán', 'Đơn realistic #0247'),
(248, 36, 3, NULL, '2026-04-03 18:12:00', 'Đã thanh toán', 'Đơn realistic #0248'),
(249, NULL, 12, NULL, '2026-04-03 16:29:00', 'Đã thanh toán', 'Đơn realistic #0249'),
(250, 33, 2, 4, '2026-04-03 19:02:00', 'Đã thanh toán', 'Đơn realistic #0250'),
(251, NULL, 2, NULL, '2026-04-03 21:25:00', 'Đã thanh toán', 'Đơn realistic #0251'),
(252, 12, 12, NULL, '2026-04-03 19:27:00', 'Đã thanh toán', 'Đơn realistic #0252'),
(253, 31, 3, 4, '2026-04-03 19:33:00', 'Đã thanh toán', 'Đơn realistic #0253'),
(254, NULL, 8, NULL, '2026-04-03 19:29:00', 'Đã thanh toán', 'Đơn realistic #0254'),
(255, 2, 8, NULL, '2026-04-03 21:33:00', 'Đã thanh toán', 'Đơn realistic #0255'),
(256, NULL, 4, NULL, '2026-04-03 20:32:00', 'Đã thanh toán', 'Đơn realistic #0256'),
(257, 20, 12, NULL, '2026-04-03 08:56:00', 'Đã thanh toán', 'Đơn realistic #0257'),
(258, 25, 4, NULL, '2026-04-03 08:26:00', 'Đã thanh toán', 'Đơn realistic #0258'),
(259, NULL, 2, NULL, '2026-04-03 08:19:00', 'Đã thanh toán', 'Đơn realistic #0259'),
(260, NULL, 3, NULL, '2026-04-03 09:04:00', 'Đã thanh toán', 'Đơn realistic #0260'),
(261, NULL, 3, NULL, '2026-04-03 08:26:00', 'Đã thanh toán', 'Đơn realistic #0261'),
(262, 5, 2, NULL, '2026-04-03 10:51:00', 'Đã thanh toán', 'Đơn realistic #0262'),
(263, NULL, 2, 2, '2026-04-03 11:05:00', 'Đã thanh toán', 'Đơn realistic #0263'),
(264, 35, 4, 2, '2026-04-03 11:32:00', 'Đã thanh toán', 'Đơn realistic #0264'),
(265, 15, 2, NULL, '2026-04-03 12:11:00', 'Đã thanh toán', 'Đơn realistic #0265'),
(266, 37, 2, NULL, '2026-04-03 11:32:00', 'Đã thanh toán', 'Đơn realistic #0266'),
(267, 26, 2, NULL, '2026-04-03 11:14:00', 'Đã thanh toán', 'Đơn realistic #0267'),
(268, 7, 8, NULL, '2026-04-03 12:30:00', 'Đã thanh toán', 'Đơn realistic #0268'),
(269, 32, 4, NULL, '2026-04-03 15:36:00', 'Đã thanh toán', 'Đơn realistic #0269'),
(270, 13, 2, 2, '2026-04-03 14:16:00', 'Đã thanh toán', 'Đơn realistic #0270'),
(271, 7, 2, NULL, '2026-04-03 13:18:00', 'Đã thanh toán', 'Đơn realistic #0271'),
(272, NULL, 8, NULL, '2026-04-03 15:30:00', 'Đã thanh toán', 'Đơn realistic #0272'),
(273, NULL, 3, NULL, '2026-04-03 13:37:00', 'Đã thanh toán', 'Đơn realistic #0273'),
(274, 29, 12, NULL, '2026-04-03 17:47:00', 'Đã thanh toán', 'Đơn realistic #0274'),
(275, 35, 8, NULL, '2026-04-03 18:08:00', 'Đã thanh toán', 'Đơn realistic #0275'),
(276, 17, 8, NULL, '2026-04-03 18:02:00', 'Đã thanh toán', 'Đơn realistic #0276'),
(277, 4, 2, 2, '2026-04-03 17:40:00', 'Đã thanh toán', 'Đơn realistic #0277'),
(278, 1, 2, NULL, '2026-04-03 18:56:00', 'Đã thanh toán', 'Đơn realistic #0278'),
(279, 22, 4, NULL, '2026-04-03 18:22:00', 'Đã thanh toán', 'Đơn realistic #0279'),
(280, 29, 3, 5, '2026-04-03 18:08:00', 'Đã thanh toán', 'Đơn realistic #0280'),
(281, NULL, 12, NULL, '2026-04-03 17:57:00', 'Đã thanh toán', 'Đơn realistic #0281'),
(282, NULL, 8, 5, '2026-04-03 19:54:00', 'Đã thanh toán', 'Đơn realistic #0282'),
(283, NULL, 3, 4, '2026-04-03 20:45:00', 'Đã thanh toán', 'Đơn realistic #0283'),
(284, 1, 8, NULL, '2026-04-03 21:26:00', 'Đã thanh toán', 'Đơn realistic #0284'),
(285, 28, 8, NULL, '2026-04-03 22:04:00', 'Đã thanh toán', 'Đơn realistic #0285'),
(286, 28, 2, NULL, '2026-04-03 21:28:00', 'Đã thanh toán', 'Đơn realistic #0286'),
(287, NULL, 4, NULL, '2026-04-03 19:56:00', 'Đã thanh toán', 'Đơn realistic #0287'),
(288, 34, 2, NULL, '2026-04-03 09:34:00', 'Đã thanh toán', 'Đơn realistic #0288'),
(289, NULL, 8, NULL, '2026-04-03 09:44:00', 'Đã thanh toán', 'Đơn realistic #0289'),
(290, 13, 2, NULL, '2026-04-03 08:59:00', 'Đã thanh toán', 'Đơn realistic #0290'),
(291, 27, 4, NULL, '2026-04-03 09:18:00', 'Đã thanh toán', 'Đơn realistic #0291'),
(292, 17, 12, NULL, '2026-04-03 08:56:00', 'Đã thanh toán', 'Đơn realistic #0292'),
(293, 21, 4, 2, '2026-04-03 09:05:00', 'Đã thanh toán', 'Đơn realistic #0293'),
(294, NULL, 2, NULL, '2026-04-03 08:42:00', 'Đã thanh toán', 'Đơn realistic #0294'),
(295, NULL, 12, NULL, '2026-04-03 13:16:00', 'Đã thanh toán', 'Đơn realistic #0295'),
(296, 34, 2, 5, '2026-04-03 11:56:00', 'Đã thanh toán', 'Đơn realistic #0296'),
(297, 22, 3, NULL, '2026-04-03 12:50:00', 'Đã thanh toán', 'Đơn realistic #0297'),
(298, 14, 3, NULL, '2026-04-03 15:10:00', 'Đã thanh toán', 'Đơn realistic #0298'),
(299, NULL, 4, NULL, '2026-04-03 14:23:00', 'Đã thanh toán', 'Đơn realistic #0299'),
(300, 23, 12, NULL, '2026-04-03 15:00:00', 'Đã thanh toán', 'Đơn realistic #0300'),
(301, NULL, 12, 2, '2026-04-03 14:52:00', 'Đã thanh toán', 'Đơn realistic #0301'),
(302, NULL, 2, NULL, '2026-04-03 15:35:00', 'Đã thanh toán', 'Đơn realistic #0302'),
(303, 26, 3, NULL, '2026-04-03 15:38:00', 'Đã thanh toán', 'Đơn realistic #0303'),
(304, 35, 12, 3, '2026-04-03 15:20:00', 'Đã thanh toán', 'Đơn realistic #0304'),
(305, 26, 3, NULL, '2026-04-03 15:25:00', 'Đã thanh toán', 'Đơn realistic #0305'),
(306, 3, 3, NULL, '2026-04-03 14:53:00', 'Đã thanh toán', 'Đơn realistic #0306'),
(307, NULL, 4, NULL, '2026-04-03 14:28:00', 'Đã thanh toán', 'Đơn realistic #0307'),
(308, 20, 8, NULL, '2026-04-03 19:07:00', 'Đã thanh toán', 'Đơn realistic #0308'),
(309, 11, 8, NULL, '2026-04-03 19:11:00', 'Đã thanh toán', 'Đơn realistic #0309'),
(310, 30, 3, NULL, '2026-04-03 19:07:00', 'Đã thanh toán', 'Đơn realistic #0310'),
(311, 20, 8, NULL, '2026-04-03 19:24:00', 'Đã thanh toán', 'Đơn realistic #0311'),
(312, 22, 2, NULL, '2026-04-03 18:57:00', 'Đã thanh toán', 'Đơn realistic #0312'),
(313, NULL, 2, 5, '2026-04-03 19:49:00', 'Đã thanh toán', 'Đơn realistic #0313'),
(314, 26, 12, NULL, '2026-04-03 17:50:00', 'Đã thanh toán', 'Đơn realistic #0314'),
(315, NULL, 4, NULL, '2026-04-03 09:36:00', 'Đã thanh toán', 'Đơn realistic #0315'),
(316, 25, 3, NULL, '2026-04-03 09:33:00', 'Đã thanh toán', 'Đơn realistic #0316'),
(317, NULL, 4, NULL, '2026-04-03 10:03:00', 'Đã thanh toán', 'Đơn realistic #0317'),
(318, 27, 2, NULL, '2026-04-03 10:12:00', 'Đã thanh toán', 'Đơn realistic #0318'),
(319, 13, 8, NULL, '2026-04-03 14:22:00', 'Đã thanh toán', 'Đơn realistic #0319'),
(320, 1, 2, NULL, '2026-04-03 12:06:00', 'Đã thanh toán', 'Đơn realistic #0320'),
(321, 26, 4, NULL, '2026-04-03 13:22:00', 'Đã thanh toán', 'Đơn realistic #0321'),
(322, NULL, 4, NULL, '2026-04-03 13:19:00', 'Đã thanh toán', 'Đơn realistic #0322'),
(323, NULL, 3, NULL, '2026-04-03 12:20:00', 'Đã thanh toán', 'Đơn realistic #0323'),
(324, NULL, 2, NULL, '2026-04-03 17:47:00', 'Đã thanh toán', 'Đơn realistic #0324'),
(325, NULL, 8, 2, '2026-04-03 16:09:00', 'Đã thanh toán', 'Đơn realistic #0325'),
(326, 34, 8, NULL, '2026-04-03 16:59:00', 'Đã thanh toán', 'Đơn realistic #0326'),
(327, 34, 12, NULL, '2026-04-03 16:04:00', 'Đã thanh toán', 'Đơn realistic #0327'),
(328, 13, 2, NULL, '2026-04-03 17:14:00', 'Đã thanh toán', 'Đơn realistic #0328'),
(329, 23, 12, 5, '2026-04-03 20:46:00', 'Đã thanh toán', 'Đơn realistic #0329'),
(330, 22, 4, NULL, '2026-04-03 20:45:00', 'Đã thanh toán', 'Đơn realistic #0330'),
(331, 21, 12, NULL, '2026-04-03 21:40:00', 'Đã thanh toán', 'Đơn realistic #0331'),
(332, 17, 12, 3, '2026-04-03 21:22:00', 'Đã thanh toán', 'Đơn realistic #0332'),
(333, 5, 4, 2, '2026-04-03 21:17:00', 'Đã thanh toán', 'Đơn realistic #0333'),
(334, 16, 12, NULL, '2026-04-03 19:43:00', 'Đã thanh toán', 'Đơn realistic #0334'),
(335, 27, 12, NULL, '2026-04-03 07:27:00', 'Đã thanh toán', 'Đơn realistic #0335'),
(336, NULL, 2, NULL, '2026-04-03 07:58:00', 'Đã thanh toán', 'Đơn realistic #0336'),
(337, 31, 2, NULL, '2026-04-03 07:56:00', 'Đã thanh toán', 'Đơn realistic #0337'),
(338, 19, 8, NULL, '2026-04-03 07:44:00', 'Đã thanh toán', 'Đơn realistic #0338'),
(339, 19, 8, NULL, '2026-04-03 09:52:00', 'Đã thanh toán', 'Đơn realistic #0339'),
(340, 38, 3, 2, '2026-04-03 11:07:00', 'Đã thanh toán', 'Đơn realistic #0340'),
(341, NULL, 8, NULL, '2026-04-03 11:45:00', 'Đã thanh toán', 'Đơn realistic #0341'),
(342, 30, 12, NULL, '2026-04-03 14:18:00', 'Đã thanh toán', 'Đơn realistic #0342'),
(343, NULL, 8, NULL, '2026-04-03 14:54:00', 'Đã thanh toán', 'Đơn realistic #0343'),
(344, NULL, 12, NULL, '2026-04-03 13:17:00', 'Đã thanh toán', 'Đơn realistic #0344'),
(345, NULL, 2, NULL, '2026-04-03 14:32:00', 'Đã thanh toán', 'Đơn realistic #0345'),
(346, 7, 12, NULL, '2026-04-03 13:51:00', 'Đã thanh toán', 'Đơn realistic #0346'),
(347, 15, 4, 2, '2026-04-03 17:53:00', 'Đã thanh toán', 'Đơn realistic #0347'),
(348, NULL, 3, NULL, '2026-04-03 17:06:00', 'Đã thanh toán', 'Đơn realistic #0348'),
(349, 14, 12, NULL, '2026-04-03 16:26:00', 'Đã thanh toán', 'Đơn realistic #0349'),
(350, NULL, 12, NULL, '2026-04-03 15:40:00', 'Đã thanh toán', 'Đơn realistic #0350'),
(351, 17, 3, NULL, '2026-04-03 16:57:00', 'Đã thanh toán', 'Đơn realistic #0351'),
(352, 5, 12, NULL, '2026-04-03 15:37:00', 'Đã thanh toán', 'Đơn realistic #0352'),
(353, NULL, 3, NULL, '2026-04-03 17:15:00', 'Đã thanh toán', 'Đơn realistic #0353'),
(354, NULL, 4, NULL, '2026-04-03 16:58:00', 'Đã thanh toán', 'Đơn realistic #0354'),
(355, NULL, 3, 4, '2026-04-03 19:40:00', 'Đã thanh toán', 'Đơn realistic #0355'),
(356, 11, 2, NULL, '2026-04-03 20:32:00', 'Đã thanh toán', 'Đơn realistic #0356'),
(357, NULL, 4, 4, '2026-04-03 19:56:00', 'Đã thanh toán', 'Đơn realistic #0357'),
(358, NULL, 4, NULL, '2026-04-03 18:51:00', 'Đã thanh toán', 'Đơn realistic #0358'),
(359, NULL, 8, 4, '2026-04-03 20:51:00', 'Đã thanh toán', 'Đơn realistic #0359'),
(360, NULL, 4, NULL, '2026-04-03 20:24:00', 'Đã thanh toán', 'Đơn realistic #0360'),
(361, NULL, 3, 5, '2026-04-03 20:51:00', 'Đã thanh toán', 'Đơn realistic #0361'),
(362, 37, 2, NULL, '2026-04-03 20:48:00', 'Đã thanh toán', 'Đơn realistic #0362'),
(363, NULL, 4, 2, '2026-04-04 07:59:00', 'Đã thanh toán', 'Đơn realistic #0363'),
(364, 2, 3, NULL, '2026-04-04 08:37:00', 'Đã thanh toán', 'Đơn realistic #0364'),
(365, NULL, 3, NULL, '2026-04-04 08:36:00', 'Đã thanh toán', 'Đơn realistic #0365'),
(366, 8, 2, NULL, '2026-04-04 08:31:00', 'Đã thanh toán', 'Đơn realistic #0366'),
(367, NULL, 4, NULL, '2026-04-04 11:36:00', 'Đã thanh toán', 'Đơn realistic #0367'),
(368, 5, 4, 2, '2026-04-04 10:20:00', 'Đã thanh toán', 'Đơn realistic #0368'),
(369, NULL, 8, NULL, '2026-04-04 11:10:00', 'Đã thanh toán', 'Đơn realistic #0369'),
(370, NULL, 3, NULL, '2026-04-04 11:10:00', 'Đã thanh toán', 'Đơn realistic #0370'),
(371, 22, 2, NULL, '2026-04-04 10:39:00', 'Đã thanh toán', 'Đơn realistic #0371'),
(372, NULL, 8, NULL, '2026-04-04 09:37:00', 'Đã thanh toán', 'Đơn realistic #0372'),
(373, 23, 3, NULL, '2026-04-04 11:54:00', 'Đã thanh toán', 'Đơn realistic #0373'),
(374, 22, 3, NULL, '2026-04-04 10:46:00', 'Đã thanh toán', 'Đơn realistic #0374'),
(375, 10, 3, NULL, '2026-04-04 11:49:00', 'Đã thanh toán', 'Đơn realistic #0375'),
(376, 32, 8, NULL, '2026-04-04 13:17:00', 'Đã thanh toán', 'Đơn realistic #0376'),
(377, NULL, 4, NULL, '2026-04-04 12:35:00', 'Đã thanh toán', 'Đơn realistic #0377'),
(378, NULL, 8, 1, '2026-04-04 14:46:00', 'Đã thanh toán', 'Đơn realistic #0378'),
(379, 39, 3, 1, '2026-04-04 13:36:00', 'Đã thanh toán', 'Đơn realistic #0379'),
(380, 18, 4, NULL, '2026-04-04 12:56:00', 'Đã thanh toán', 'Đơn realistic #0380'),
(381, NULL, 3, NULL, '2026-04-04 13:29:00', 'Đã thanh toán', 'Đơn realistic #0381'),
(382, NULL, 4, NULL, '2026-04-04 17:46:00', 'Đã thanh toán', 'Đơn realistic #0382'),
(383, NULL, 2, 1, '2026-04-04 17:25:00', 'Đã thanh toán', 'Đơn realistic #0383'),
(384, 39, 4, 1, '2026-04-04 18:10:00', 'Đã thanh toán', 'Đơn realistic #0384'),
(385, NULL, 3, 1, '2026-04-04 17:36:00', 'Đã thanh toán', 'Đơn realistic #0385'),
(386, 40, 8, 2, '2026-04-04 16:23:00', 'Đã thanh toán', 'Đơn realistic #0386'),
(387, 25, 3, 3, '2026-04-04 19:52:00', 'Đã thanh toán', 'Đơn realistic #0387'),
(388, 40, 8, 1, '2026-04-04 20:57:00', 'Đã thanh toán', 'Đơn realistic #0388'),
(389, 28, 8, 5, '2026-04-04 19:11:00', 'Đã thanh toán', 'Đơn realistic #0389'),
(390, 2, 8, NULL, '2026-04-04 21:33:00', 'Đã thanh toán', 'Đơn realistic #0390'),
(391, 19, 2, 5, '2026-04-04 20:53:00', 'Đã thanh toán', 'Đơn realistic #0391'),
(392, 15, 12, NULL, '2026-04-04 20:04:00', 'Đã thanh toán', 'Đơn realistic #0392'),
(393, NULL, 8, NULL, '2026-04-04 21:03:00', 'Đã thanh toán', 'Đơn realistic #0393'),
(394, 7, 8, 2, '2026-04-04 20:26:00', 'Đã thanh toán', 'Đơn realistic #0394'),
(395, 18, 8, NULL, '2026-04-04 19:51:00', 'Đã thanh toán', 'Đơn realistic #0395'),
(396, 8, 12, NULL, '2026-04-04 21:34:00', 'Đã thanh toán', 'Đơn realistic #0396'),
(397, 40, 3, 4, '2026-04-04 20:45:00', 'Đã thanh toán', 'Đơn realistic #0397'),
(398, 23, 3, NULL, '2026-04-04 20:21:00', 'Đã thanh toán', 'Đơn realistic #0398'),
(399, 25, 3, NULL, '2026-04-04 21:03:00', 'Đã thanh toán', 'Đơn realistic #0399'),
(400, 34, 4, 3, '2026-04-04 08:33:00', 'Đã thanh toán', 'Đơn realistic #0400'),
(401, NULL, 2, 1, '2026-04-04 08:26:00', 'Đã thanh toán', 'Đơn realistic #0401'),
(402, 34, 3, 2, '2026-04-04 08:34:00', 'Đã thanh toán', 'Đơn realistic #0402'),
(403, NULL, 2, NULL, '2026-04-04 08:23:00', 'Đã thanh toán', 'Đơn realistic #0403'),
(404, 4, 3, 1, '2026-04-04 11:11:00', 'Đã thanh toán', 'Đơn realistic #0404'),
(405, 40, 4, 5, '2026-04-04 11:30:00', 'Đã thanh toán', 'Đơn realistic #0405'),
(406, NULL, 4, NULL, '2026-04-04 11:57:00', 'Đã thanh toán', 'Đơn realistic #0406'),
(407, NULL, 8, NULL, '2026-04-04 11:41:00', 'Đã thanh toán', 'Đơn realistic #0407'),
(408, NULL, 2, 1, '2026-04-04 12:29:00', 'Đã thanh toán', 'Đơn realistic #0408'),
(409, NULL, 8, NULL, '2026-04-04 14:55:00', 'Đã thanh toán', 'Đơn realistic #0409'),
(410, 19, 3, NULL, '2026-04-04 13:42:00', 'Đã thanh toán', 'Đơn realistic #0410'),
(411, 19, 8, NULL, '2026-04-04 14:41:00', 'Đã thanh toán', 'Đơn realistic #0411'),
(412, 37, 12, NULL, '2026-04-04 15:22:00', 'Đã thanh toán', 'Đơn realistic #0412'),
(413, 11, 12, NULL, '2026-04-04 15:22:00', 'Đã thanh toán', 'Đơn realistic #0413'),
(414, NULL, 2, NULL, '2026-04-04 14:48:00', 'Đã thanh toán', 'Đơn realistic #0414'),
(415, 3, 12, NULL, '2026-04-04 16:33:00', 'Đã thanh toán', 'Đơn realistic #0415'),
(416, 22, 8, 2, '2026-04-04 16:40:00', 'Đã thanh toán', 'Đơn realistic #0416'),
(417, NULL, 2, 2, '2026-04-04 16:58:00', 'Đã thanh toán', 'Đơn realistic #0417'),
(418, 25, 2, NULL, '2026-04-04 16:26:00', 'Đã thanh toán', 'Đơn realistic #0418'),
(419, 20, 8, NULL, '2026-04-04 17:00:00', 'Đã thanh toán', 'Đơn realistic #0419'),
(420, 36, 4, NULL, '2026-04-04 19:02:00', 'Đã thanh toán', 'Đơn realistic #0420'),
(421, NULL, 4, NULL, '2026-04-04 16:44:00', 'Đã thanh toán', 'Đơn realistic #0421'),
(422, 15, 2, NULL, '2026-04-04 17:45:00', 'Đã thanh toán', 'Đơn realistic #0422'),
(423, 27, 4, NULL, '2026-04-04 16:49:00', 'Đã thanh toán', 'Đơn realistic #0423'),
(424, 35, 2, NULL, '2026-04-04 18:51:00', 'Đã thanh toán', 'Đơn realistic #0424'),
(425, 6, 3, 5, '2026-04-04 20:35:00', 'Đã thanh toán', 'Đơn realistic #0425'),
(426, NULL, 2, 2, '2026-04-04 20:56:00', 'Đã thanh toán', 'Đơn realistic #0426'),
(427, 9, 8, 1, '2026-04-04 21:04:00', 'Đã thanh toán', 'Đơn realistic #0427'),
(428, NULL, 3, NULL, '2026-04-04 20:38:00', 'Đã thanh toán', 'Đơn realistic #0428'),
(429, NULL, 8, NULL, '2026-04-04 20:20:00', 'Đã thanh toán', 'Đơn realistic #0429'),
(430, 13, 4, NULL, '2026-04-04 19:51:00', 'Đã thanh toán', 'Đơn realistic #0430'),
(431, 30, 2, NULL, '2026-04-04 20:17:00', 'Đã thanh toán', 'Đơn realistic #0431'),
(432, 18, 4, NULL, '2026-04-04 21:50:00', 'Đã thanh toán', 'Đơn realistic #0432'),
(433, 27, 8, NULL, '2026-04-04 09:31:00', 'Đã thanh toán', 'Đơn realistic #0433'),
(434, NULL, 8, NULL, '2026-04-04 09:30:00', 'Đã thanh toán', 'Đơn realistic #0434'),
(435, 7, 12, 2, '2026-04-04 09:45:00', 'Đã thanh toán', 'Đơn realistic #0435'),
(436, 15, 2, NULL, '2026-04-04 09:50:00', 'Đã thanh toán', 'Đơn realistic #0436'),
(437, NULL, 8, NULL, '2026-04-04 08:54:00', 'Đã thanh toán', 'Đơn realistic #0437'),
(438, 11, 8, NULL, '2026-04-04 12:02:00', 'Đã thanh toán', 'Đơn realistic #0438'),
(439, 24, 8, 5, '2026-04-04 12:51:00', 'Đã thanh toán', 'Đơn realistic #0439'),
(440, NULL, 4, NULL, '2026-04-04 12:41:00', 'Đã thanh toán', 'Đơn realistic #0440'),
(441, NULL, 4, NULL, '2026-04-04 13:08:00', 'Đã thanh toán', 'Đơn realistic #0441'),
(442, 33, 12, NULL, '2026-04-04 10:56:00', 'Đã thanh toán', 'Đơn realistic #0442'),
(443, 13, 8, NULL, '2026-04-04 15:01:00', 'Đã thanh toán', 'Đơn realistic #0443'),
(444, 38, 3, NULL, '2026-04-04 14:11:00', 'Đã thanh toán', 'Đơn realistic #0444'),
(445, 26, 2, 3, '2026-04-04 16:32:00', 'Đã thanh toán', 'Đơn realistic #0445'),
(446, NULL, 12, NULL, '2026-04-04 15:09:00', 'Đã thanh toán', 'Đơn realistic #0446'),
(447, 4, 3, NULL, '2026-04-04 15:53:00', 'Đã thanh toán', 'Đơn realistic #0447'),
(448, 8, 4, NULL, '2026-04-04 14:29:00', 'Đã thanh toán', 'Đơn realistic #0448'),
(449, 15, 2, 2, '2026-04-04 15:18:00', 'Đã thanh toán', 'Đơn realistic #0449'),
(450, 37, 3, 1, '2026-04-04 14:24:00', 'Đã thanh toán', 'Đơn realistic #0450'),
(451, 40, 3, NULL, '2026-04-04 16:13:00', 'Đã thanh toán', 'Đơn realistic #0451'),
(452, 26, 2, 1, '2026-04-04 16:48:00', 'Đã thanh toán', 'Đơn realistic #0452'),
(453, 35, 8, 2, '2026-04-04 19:47:00', 'Đã thanh toán', 'Đơn realistic #0453'),
(454, 19, 12, NULL, '2026-04-04 17:57:00', 'Đã thanh toán', 'Đơn realistic #0454'),
(455, NULL, 2, NULL, '2026-04-04 18:26:00', 'Đã thanh toán', 'Đơn realistic #0455'),
(456, 21, 3, NULL, '2026-04-04 18:36:00', 'Đã thanh toán', 'Đơn realistic #0456'),
(457, 21, 2, NULL, '2026-04-04 18:32:00', 'Đã thanh toán', 'Đơn realistic #0457'),
(458, NULL, 2, NULL, '2026-04-04 18:27:00', 'Đã thanh toán', 'Đơn realistic #0458'),
(459, 36, 3, 5, '2026-04-04 18:50:00', 'Đã thanh toán', 'Đơn realistic #0459'),
(460, 16, 2, NULL, '2026-04-04 19:38:00', 'Đã thanh toán', 'Đơn realistic #0460'),
(461, NULL, 12, 2, '2026-04-04 18:04:00', 'Đã thanh toán', 'Đơn realistic #0461'),
(462, 20, 4, 5, '2026-04-04 19:27:00', 'Đã thanh toán', 'Đơn realistic #0462'),
(463, 36, 12, NULL, '2026-04-04 19:59:00', 'Đã thanh toán', 'Đơn realistic #0463'),
(464, 17, 12, 2, '2026-04-04 10:06:00', 'Đã thanh toán', 'Đơn realistic #0464'),
(465, 21, 8, 5, '2026-04-04 09:32:00', 'Đã thanh toán', 'Đơn realistic #0465'),
(466, 18, 2, NULL, '2026-04-04 10:15:00', 'Đã thanh toán', 'Đơn realistic #0466'),
(467, 6, 4, NULL, '2026-04-04 10:26:00', 'Đã thanh toán', 'Đơn realistic #0467'),
(468, 15, 8, NULL, '2026-04-04 10:25:00', 'Đã thanh toán', 'Đơn realistic #0468'),
(469, NULL, 12, NULL, '2026-04-04 14:08:00', 'Đã thanh toán', 'Đơn realistic #0469'),
(470, 34, 8, 1, '2026-04-04 12:06:00', 'Đã thanh toán', 'Đơn realistic #0470'),
(471, NULL, 8, NULL, '2026-04-04 12:01:00', 'Đã thanh toán', 'Đơn realistic #0471'),
(472, NULL, 4, 2, '2026-04-04 14:01:00', 'Đã thanh toán', 'Đơn realistic #0472'),
(473, NULL, 12, NULL, '2026-04-04 17:12:00', 'Đã thanh toán', 'Đơn realistic #0473'),
(474, NULL, 12, 2, '2026-04-04 16:36:00', 'Đã thanh toán', 'Đơn realistic #0474'),
(475, 8, 3, 1, '2026-04-04 16:48:00', 'Đã thanh toán', 'Đơn realistic #0475'),
(476, NULL, 12, 2, '2026-04-04 17:20:00', 'Đã thanh toán', 'Đơn realistic #0476'),
(477, 19, 12, 2, '2026-04-04 18:05:00', 'Đã thanh toán', 'Đơn realistic #0477'),
(478, 26, 12, NULL, '2026-04-04 18:04:00', 'Đã thanh toán', 'Đơn realistic #0478'),
(479, NULL, 4, NULL, '2026-04-04 16:19:00', 'Đã thanh toán', 'Đơn realistic #0479'),
(480, 39, 4, 5, '2026-04-04 16:22:00', 'Đã thanh toán', 'Đơn realistic #0480'),
(481, 12, 2, NULL, '2026-04-04 16:17:00', 'Đã thanh toán', 'Đơn realistic #0481'),
(482, NULL, 3, 5, '2026-04-04 19:23:00', 'Đã thanh toán', 'Đơn realistic #0482'),
(483, NULL, 12, 4, '2026-04-04 20:25:00', 'Đã thanh toán', 'Đơn realistic #0483'),
(484, 3, 4, NULL, '2026-04-04 21:50:00', 'Đã thanh toán', 'Đơn realistic #0484'),
(485, 19, 3, NULL, '2026-04-04 21:43:00', 'Đã thanh toán', 'Đơn realistic #0485'),
(486, 37, 8, NULL, '2026-04-04 20:26:00', 'Đã thanh toán', 'Đơn realistic #0486'),
(487, 28, 2, NULL, '2026-04-04 08:26:00', 'Đã thanh toán', 'Đơn realistic #0487'),
(488, 19, 8, NULL, '2026-04-04 08:07:00', 'Đã thanh toán', 'Đơn realistic #0488'),
(489, 14, 8, NULL, '2026-04-04 11:09:00', 'Đã thanh toán', 'Đơn realistic #0489'),
(490, 2, 3, 2, '2026-04-04 09:46:00', 'Đã thanh toán', 'Đơn realistic #0490'),
(491, 1, 12, 2, '2026-04-04 10:17:00', 'Đã thanh toán', 'Đơn realistic #0491'),
(492, 20, 8, NULL, '2026-04-04 11:26:00', 'Đã thanh toán', 'Đơn realistic #0492'),
(493, NULL, 2, NULL, '2026-04-04 09:48:00', 'Đã thanh toán', 'Đơn realistic #0493'),
(494, 17, 8, NULL, '2026-04-04 10:30:00', 'Đã thanh toán', 'Đơn realistic #0494'),
(495, 20, 12, 2, '2026-04-04 10:49:00', 'Đã thanh toán', 'Đơn realistic #0495'),
(496, 19, 3, 1, '2026-04-04 14:17:00', 'Đã thanh toán', 'Đơn realistic #0496'),
(497, 8, 12, NULL, '2026-04-04 13:01:00', 'Đã thanh toán', 'Đơn realistic #0497'),
(498, 28, 2, 2, '2026-04-04 13:01:00', 'Đã thanh toán', 'Đơn realistic #0498'),
(499, 11, 3, 1, '2026-04-04 13:18:00', 'Đã thanh toán', 'Đơn realistic #0499'),
(500, 31, 2, NULL, '2026-04-04 14:42:00', 'Đã thanh toán', 'Đơn realistic #0500'),
(501, 7, 12, 1, '2026-04-04 13:12:00', 'Đã thanh toán', 'Đơn realistic #0501'),
(502, NULL, 2, NULL, '2026-04-04 13:51:00', 'Đã thanh toán', 'Đơn realistic #0502'),
(503, 13, 2, NULL, '2026-04-04 14:29:00', 'Đã thanh toán', 'Đơn realistic #0503'),
(504, 12, 2, 1, '2026-04-04 12:58:00', 'Đã thanh toán', 'Đơn realistic #0504'),
(505, 27, 4, NULL, '2026-04-04 12:20:00', 'Đã thanh toán', 'Đơn realistic #0505'),
(506, 6, 3, NULL, '2026-04-04 13:00:00', 'Đã thanh toán', 'Đơn realistic #0506'),
(507, 34, 3, NULL, '2026-04-04 17:26:00', 'Đã thanh toán', 'Đơn realistic #0507'),
(508, 38, 8, NULL, '2026-04-04 16:11:00', 'Đã thanh toán', 'Đơn realistic #0508'),
(509, 37, 8, NULL, '2026-04-04 17:52:00', 'Đã thanh toán', 'Đơn realistic #0509'),
(510, 29, 8, NULL, '2026-04-04 16:25:00', 'Đã thanh toán', 'Đơn realistic #0510'),
(511, 25, 8, NULL, '2026-04-04 16:49:00', 'Đã thanh toán', 'Đơn realistic #0511'),
(512, 40, 3, NULL, '2026-04-04 16:56:00', 'Đã thanh toán', 'Đơn realistic #0512'),
(513, NULL, 3, NULL, '2026-04-04 17:56:00', 'Đã thanh toán', 'Đơn realistic #0513'),
(514, 9, 2, NULL, '2026-04-04 17:24:00', 'Đã thanh toán', 'Đơn realistic #0514'),
(515, NULL, 2, 2, '2026-04-04 17:07:00', 'Đã thanh toán', 'Đơn realistic #0515'),
(516, NULL, 12, 2, '2026-04-04 16:28:00', 'Đã thanh toán', 'Đơn realistic #0516'),
(517, 39, 8, NULL, '2026-04-04 18:06:00', 'Đã thanh toán', 'Đơn realistic #0517'),
(518, 18, 12, NULL, '2026-04-04 20:25:00', 'Đã thanh toán', 'Đơn realistic #0518'),
(519, NULL, 3, NULL, '2026-04-04 19:26:00', 'Đã thanh toán', 'Đơn realistic #0519'),
(520, NULL, 4, NULL, '2026-04-04 21:17:00', 'Đã thanh toán', 'Đơn realistic #0520'),
(521, 11, 4, NULL, '2026-04-04 19:30:00', 'Đã thanh toán', 'Đơn realistic #0521'),
(522, 20, 4, NULL, '2026-04-04 20:34:00', 'Đã thanh toán', 'Đơn realistic #0522'),
(523, 19, 2, 2, '2026-04-04 19:04:00', 'Đã thanh toán', 'Đơn realistic #0523'),
(524, 31, 2, NULL, '2026-04-04 20:05:00', 'Đã thanh toán', 'Đơn realistic #0524'),
(525, NULL, 4, NULL, '2026-04-05 07:35:00', 'Đã thanh toán', 'Đơn realistic #0525'),
(526, NULL, 4, NULL, '2026-04-05 08:08:00', 'Đã thanh toán', 'Đơn realistic #0526'),
(527, 16, 8, 3, '2026-04-05 09:46:00', 'Đã thanh toán', 'Đơn realistic #0527'),
(528, 13, 2, NULL, '2026-04-05 11:45:00', 'Đã thanh toán', 'Đơn realistic #0528'),
(529, 8, 3, NULL, '2026-04-05 10:21:00', 'Đã thanh toán', 'Đơn realistic #0529'),
(530, 10, 3, NULL, '2026-04-05 09:36:00', 'Đã thanh toán', 'Đơn realistic #0530'),
(531, 35, 3, NULL, '2026-04-05 11:52:00', 'Đã thanh toán', 'Đơn realistic #0531'),
(532, 23, 2, NULL, '2026-04-05 11:01:00', 'Đã thanh toán', 'Đơn realistic #0532'),
(533, 1, 12, NULL, '2026-04-05 14:35:00', 'Đã thanh toán', 'Đơn realistic #0533'),
(534, 27, 4, 2, '2026-04-05 13:46:00', 'Đã thanh toán', 'Đơn realistic #0534'),
(535, 33, 12, NULL, '2026-04-05 15:07:00', 'Đã thanh toán', 'Đơn realistic #0535'),
(536, 11, 8, NULL, '2026-04-05 13:54:00', 'Đã thanh toán', 'Đơn realistic #0536'),
(537, 34, 2, 2, '2026-04-05 14:57:00', 'Đã thanh toán', 'Đơn realistic #0537'),
(538, 21, 4, 5, '2026-04-05 12:54:00', 'Đã thanh toán', 'Đơn realistic #0538'),
(539, NULL, 2, NULL, '2026-04-05 12:41:00', 'Đã thanh toán', 'Đơn realistic #0539'),
(540, 37, 3, 2, '2026-04-05 17:56:00', 'Đã thanh toán', 'Đơn realistic #0540'),
(541, 15, 3, NULL, '2026-04-05 17:55:00', 'Đã thanh toán', 'Đơn realistic #0541'),
(542, 2, 2, NULL, '2026-04-05 18:02:00', 'Đã thanh toán', 'Đơn realistic #0542'),
(543, NULL, 2, NULL, '2026-04-05 17:42:00', 'Đã thanh toán', 'Đơn realistic #0543'),
(544, 29, 3, NULL, '2026-04-05 16:13:00', 'Đã thanh toán', 'Đơn realistic #0544'),
(545, 35, 12, NULL, '2026-04-05 18:03:00', 'Đã thanh toán', 'Đơn realistic #0545'),
(546, NULL, 12, NULL, '2026-04-05 17:32:00', 'Đã thanh toán', 'Đơn realistic #0546'),
(547, 32, 8, NULL, '2026-04-05 17:21:00', 'Đã thanh toán', 'Đơn realistic #0547'),
(548, 6, 12, NULL, '2026-04-05 19:43:00', 'Đã thanh toán', 'Đơn realistic #0548'),
(549, 7, 12, 3, '2026-04-05 20:41:00', 'Đã thanh toán', 'Đơn realistic #0549'),
(550, 26, 3, NULL, '2026-04-05 20:09:00', 'Đã thanh toán', 'Đơn realistic #0550'),
(551, 10, 3, NULL, '2026-04-05 21:40:00', 'Đã thanh toán', 'Đơn realistic #0551'),
(552, 32, 2, NULL, '2026-04-05 19:08:00', 'Đã thanh toán', 'Đơn realistic #0552'),
(553, 13, 3, NULL, '2026-04-05 21:30:00', 'Đã thanh toán', 'Đơn realistic #0553'),
(554, NULL, 2, NULL, '2026-04-05 19:44:00', 'Đã thanh toán', 'Đơn realistic #0554'),
(555, 21, 4, 1, '2026-04-05 09:07:00', 'Đã thanh toán', 'Đơn realistic #0555'),
(556, 37, 12, NULL, '2026-04-05 08:48:00', 'Đã thanh toán', 'Đơn realistic #0556'),
(557, 20, 8, 2, '2026-04-05 08:20:00', 'Đã thanh toán', 'Đơn realistic #0557'),
(558, 33, 4, NULL, '2026-04-05 11:00:00', 'Đã thanh toán', 'Đơn realistic #0558'),
(559, 1, 2, NULL, '2026-04-05 11:05:00', 'Đã thanh toán', 'Đơn realistic #0559'),
(560, 26, 2, NULL, '2026-04-05 12:27:00', 'Đã thanh toán', 'Đơn realistic #0560'),
(561, 6, 8, NULL, '2026-04-05 10:23:00', 'Đã thanh toán', 'Đơn realistic #0561'),
(562, 8, 8, 3, '2026-04-05 10:08:00', 'Đã thanh toán', 'Đơn realistic #0562'),
(563, 17, 12, NULL, '2026-04-05 11:25:00', 'Đã thanh toán', 'Đơn realistic #0563'),
(564, 6, 3, 5, '2026-04-05 15:36:00', 'Đã thanh toán', 'Đơn realistic #0564'),
(565, 8, 8, 3, '2026-04-05 14:40:00', 'Đã thanh toán', 'Đơn realistic #0565'),
(566, 4, 8, NULL, '2026-04-05 15:47:00', 'Đã thanh toán', 'Đơn realistic #0566'),
(567, NULL, 8, NULL, '2026-04-05 15:34:00', 'Đã thanh toán', 'Đơn realistic #0567'),
(568, 13, 12, NULL, '2026-04-05 16:26:00', 'Đã thanh toán', 'Đơn realistic #0568'),
(569, NULL, 3, NULL, '2026-04-05 18:04:00', 'Đã thanh toán', 'Đơn realistic #0569'),
(570, 35, 2, 2, '2026-04-05 17:22:00', 'Đã thanh toán', 'Đơn realistic #0570'),
(571, 5, 3, NULL, '2026-04-05 17:01:00', 'Đã thanh toán', 'Đơn realistic #0571'),
(572, 33, 2, NULL, '2026-04-05 17:18:00', 'Đã thanh toán', 'Đơn realistic #0572'),
(573, 13, 2, NULL, '2026-04-05 16:27:00', 'Đã thanh toán', 'Đơn realistic #0573'),
(574, NULL, 2, NULL, '2026-04-05 17:00:00', 'Đã thanh toán', 'Đơn realistic #0574'),
(575, 14, 2, 1, '2026-04-05 16:33:00', 'Đã thanh toán', 'Đơn realistic #0575'),
(576, NULL, 4, 4, '2026-04-05 20:35:00', 'Đã thanh toán', 'Đơn realistic #0576'),
(577, NULL, 4, 1, '2026-04-05 20:42:00', 'Đã thanh toán', 'Đơn realistic #0577'),
(578, 15, 12, NULL, '2026-04-05 20:59:00', 'Đã thanh toán', 'Đơn realistic #0578'),
(579, 33, 4, 2, '2026-04-05 21:35:00', 'Đã thanh toán', 'Đơn realistic #0579'),
(580, 11, 8, NULL, '2026-04-05 20:39:00', 'Đã thanh toán', 'Đơn realistic #0580'),
(581, NULL, 8, NULL, '2026-04-05 20:24:00', 'Đã thanh toán', 'Đơn realistic #0581'),
(582, 18, 3, NULL, '2026-04-05 09:46:00', 'Đã thanh toán', 'Đơn realistic #0582'),
(583, 39, 3, 5, '2026-04-05 08:40:00', 'Đã thanh toán', 'Đơn realistic #0583'),
(584, 23, 2, NULL, '2026-04-05 09:44:00', 'Đã thanh toán', 'Đơn realistic #0584'),
(585, 24, 8, NULL, '2026-04-05 08:42:00', 'Đã thanh toán', 'Đơn realistic #0585'),
(586, 14, 12, NULL, '2026-04-05 09:14:00', 'Đã thanh toán', 'Đơn realistic #0586'),
(587, 18, 2, 2, '2026-04-05 11:22:00', 'Đã thanh toán', 'Đơn realistic #0587'),
(588, NULL, 12, NULL, '2026-04-05 10:58:00', 'Đã thanh toán', 'Đơn realistic #0588'),
(589, 16, 12, NULL, '2026-04-05 12:19:00', 'Đã thanh toán', 'Đơn realistic #0589'),
(590, 12, 3, NULL, '2026-04-05 12:13:00', 'Đã thanh toán', 'Đơn realistic #0590'),
(591, 18, 8, 2, '2026-04-05 15:44:00', 'Đã thanh toán', 'Đơn realistic #0591'),
(592, 10, 2, NULL, '2026-04-05 16:22:00', 'Đã thanh toán', 'Đơn realistic #0592'),
(593, 37, 2, 2, '2026-04-05 14:40:00', 'Đã thanh toán', 'Đơn realistic #0593'),
(594, 28, 12, NULL, '2026-04-05 16:17:00', 'Đã thanh toán', 'Đơn realistic #0594'),
(595, 30, 3, NULL, '2026-04-05 14:59:00', 'Đã thanh toán', 'Đơn realistic #0595'),
(596, NULL, 2, NULL, '2026-04-05 15:42:00', 'Đã thanh toán', 'Đơn realistic #0596'),
(597, 5, 4, NULL, '2026-04-05 19:59:00', 'Đã thanh toán', 'Đơn realistic #0597'),
(598, 6, 4, NULL, '2026-04-05 19:39:00', 'Đã thanh toán', 'Đơn realistic #0598'),
(599, 32, 12, NULL, '2026-04-05 18:23:00', 'Đã thanh toán', 'Đơn realistic #0599'),
(600, 27, 8, 2, '2026-04-05 18:20:00', 'Đã thanh toán', 'Đơn realistic #0600'),
(601, 11, 3, NULL, '2026-04-05 19:11:00', 'Đã thanh toán', 'Đơn realistic #0601'),
(602, 23, 2, NULL, '2026-04-05 17:45:00', 'Đã thanh toán', 'Đơn realistic #0602'),
(603, 31, 2, NULL, '2026-04-05 18:02:00', 'Đã thanh toán', 'Đơn realistic #0603'),
(604, 12, 12, NULL, '2026-04-05 19:20:00', 'Đã thanh toán', 'Đơn realistic #0604'),
(605, 31, 12, NULL, '2026-04-05 18:22:00', 'Đã thanh toán', 'Đơn realistic #0605'),
(606, 35, 2, NULL, '2026-04-05 19:54:00', 'Đã thanh toán', 'Đơn realistic #0606'),
(607, 10, 4, NULL, '2026-04-05 10:15:00', 'Đã thanh toán', 'Đơn realistic #0607'),
(608, 12, 2, 5, '2026-04-05 09:53:00', 'Đã thanh toán', 'Đơn realistic #0608'),
(609, NULL, 12, NULL, '2026-04-05 09:46:00', 'Đã thanh toán', 'Đơn realistic #0609'),
(610, 39, 8, NULL, '2026-04-05 10:15:00', 'Đã thanh toán', 'Đơn realistic #0610'),
(611, NULL, 8, NULL, '2026-04-05 09:33:00', 'Đã thanh toán', 'Đơn realistic #0611'),
(612, 40, 8, NULL, '2026-04-05 09:48:00', 'Đã thanh toán', 'Đơn realistic #0612'),
(613, 13, 12, NULL, '2026-04-05 14:18:00', 'Đã thanh toán', 'Đơn realistic #0613'),
(614, 5, 2, NULL, '2026-04-05 14:07:00', 'Đã thanh toán', 'Đơn realistic #0614'),
(615, 7, 8, NULL, '2026-04-05 13:28:00', 'Đã thanh toán', 'Đơn realistic #0615'),
(616, NULL, 8, NULL, '2026-04-05 13:27:00', 'Đã thanh toán', 'Đơn realistic #0616'),
(617, 7, 12, 2, '2026-04-05 13:28:00', 'Đã thanh toán', 'Đơn realistic #0617'),
(618, 39, 2, 5, '2026-04-05 16:51:00', 'Đã thanh toán', 'Đơn realistic #0618'),
(619, 20, 4, NULL, '2026-04-05 16:45:00', 'Đã thanh toán', 'Đơn realistic #0619'),
(620, 22, 4, 1, '2026-04-05 17:31:00', 'Đã thanh toán', 'Đơn realistic #0620'),
(621, 9, 12, 1, '2026-04-05 17:13:00', 'Đã thanh toán', 'Đơn realistic #0621'),
(622, 19, 8, 4, '2026-04-05 20:47:00', 'Đã thanh toán', 'Đơn realistic #0622'),
(623, 20, 3, NULL, '2026-04-05 20:42:00', 'Đã thanh toán', 'Đơn realistic #0623'),
(624, 18, 2, 5, '2026-04-05 21:17:00', 'Đã thanh toán', 'Đơn realistic #0624'),
(625, NULL, 2, NULL, '2026-04-05 21:06:00', 'Đã thanh toán', 'Đơn realistic #0625'),
(626, 27, 4, NULL, '2026-04-05 07:20:00', 'Đã thanh toán', 'Đơn realistic #0626'),
(627, 19, 4, NULL, '2026-04-05 08:12:00', 'Đã thanh toán', 'Đơn realistic #0627'),
(628, 11, 12, NULL, '2026-04-05 07:51:00', 'Đã thanh toán', 'Đơn realistic #0628'),
(629, NULL, 12, 2, '2026-04-05 09:53:00', 'Đã thanh toán', 'Đơn realistic #0629'),
(630, 30, 2, NULL, '2026-04-05 09:19:00', 'Đã thanh toán', 'Đơn realistic #0630'),
(631, 15, 2, NULL, '2026-04-05 09:16:00', 'Đã thanh toán', 'Đơn realistic #0631'),
(632, NULL, 4, NULL, '2026-04-05 09:33:00', 'Đã thanh toán', 'Đơn realistic #0632'),
(633, 19, 2, 1, '2026-04-05 09:39:00', 'Đã thanh toán', 'Đơn realistic #0633'),
(634, NULL, 12, NULL, '2026-04-05 10:20:00', 'Đã thanh toán', 'Đơn realistic #0634'),
(635, NULL, 8, NULL, '2026-04-05 13:53:00', 'Đã thanh toán', 'Đơn realistic #0635'),
(636, 1, 8, NULL, '2026-04-05 14:34:00', 'Đã thanh toán', 'Đơn realistic #0636'),
(637, 7, 12, 2, '2026-04-05 12:57:00', 'Đã thanh toán', 'Đơn realistic #0637'),
(638, 21, 4, 2, '2026-04-05 14:21:00', 'Đã thanh toán', 'Đơn realistic #0638'),
(639, 28, 4, NULL, '2026-04-05 12:55:00', 'Đã thanh toán', 'Đơn realistic #0639'),
(640, NULL, 8, NULL, '2026-04-05 12:45:00', 'Đã thanh toán', 'Đơn realistic #0640'),
(641, NULL, 4, 1, '2026-04-05 17:43:00', 'Đã thanh toán', 'Đơn realistic #0641'),
(642, 28, 12, NULL, '2026-04-05 16:35:00', 'Đã thanh toán', 'Đơn realistic #0642'),
(643, 25, 8, NULL, '2026-04-05 15:36:00', 'Đã thanh toán', 'Đơn realistic #0643'),
(644, 15, 3, NULL, '2026-04-05 17:31:00', 'Đã thanh toán', 'Đơn realistic #0644'),
(645, 32, 3, NULL, '2026-04-05 17:39:00', 'Đã thanh toán', 'Đơn realistic #0645'),
(646, 14, 8, NULL, '2026-04-05 17:40:00', 'Đã thanh toán', 'Đơn realistic #0646'),
(647, 13, 4, NULL, '2026-04-05 16:45:00', 'Đã thanh toán', 'Đơn realistic #0647'),
(648, 35, 12, NULL, '2026-04-05 15:36:00', 'Đã thanh toán', 'Đơn realistic #0648'),
(649, 21, 8, NULL, '2026-04-05 16:23:00', 'Đã thanh toán', 'Đơn realistic #0649'),
(650, NULL, 4, NULL, '2026-04-05 17:08:00', 'Đã thanh toán', 'Đơn realistic #0650'),
(651, NULL, 2, NULL, '2026-04-05 19:44:00', 'Đã thanh toán', 'Đơn realistic #0651'),
(652, 26, 4, NULL, '2026-04-05 21:26:00', 'Đã thanh toán', 'Đơn realistic #0652'),
(653, NULL, 2, NULL, '2026-04-05 19:24:00', 'Đã thanh toán', 'Đơn realistic #0653'),
(654, NULL, 3, 1, '2026-04-05 18:57:00', 'Đã thanh toán', 'Đơn realistic #0654'),
(655, 2, 3, 2, '2026-04-05 19:57:00', 'Đã thanh toán', 'Đơn realistic #0655'),
(656, 9, 2, NULL, '2026-04-05 21:18:00', 'Đã thanh toán', 'Đơn realistic #0656'),
(657, NULL, 4, 4, '2026-04-05 20:35:00', 'Đã thanh toán', 'Đơn realistic #0657'),
(658, 35, 4, NULL, '2026-04-06 07:58:00', 'Đã thanh toán', 'Đơn realistic #0658'),
(659, NULL, 8, NULL, '2026-04-06 08:12:00', 'Đã thanh toán', 'Đơn realistic #0659'),
(660, NULL, 3, NULL, '2026-04-06 11:22:00', 'Đã thanh toán', 'Đơn realistic #0660'),
(661, NULL, 12, NULL, '2026-04-06 11:02:00', 'Đã thanh toán', 'Đơn realistic #0661'),
(662, 8, 8, NULL, '2026-04-06 10:08:00', 'Đã thanh toán', 'Đơn realistic #0662'),
(663, 12, 2, NULL, '2026-04-06 11:27:00', 'Đã thanh toán', 'Đơn realistic #0663'),
(664, 25, 3, NULL, '2026-04-06 09:55:00', 'Đã thanh toán', 'Đơn realistic #0664'),
(665, 35, 12, NULL, '2026-04-06 14:31:00', 'Đã thanh toán', 'Đơn realistic #0665'),
(666, 12, 2, NULL, '2026-04-06 14:59:00', 'Đã thanh toán', 'Đơn realistic #0666'),
(667, 27, 8, NULL, '2026-04-06 14:54:00', 'Đã thanh toán', 'Đơn realistic #0667'),
(668, 5, 4, NULL, '2026-04-06 12:43:00', 'Đã thanh toán', 'Đơn realistic #0668'),
(669, 32, 2, NULL, '2026-04-06 13:12:00', 'Đã thanh toán', 'Đơn realistic #0669'),
(670, 2, 2, 5, '2026-04-06 16:32:00', 'Đã thanh toán', 'Đơn realistic #0670'),
(671, NULL, 3, NULL, '2026-04-06 17:29:00', 'Đã thanh toán', 'Đơn realistic #0671'),
(672, NULL, 12, NULL, '2026-04-06 16:10:00', 'Đã thanh toán', 'Đơn realistic #0672'),
(673, 24, 12, NULL, '2026-04-06 17:44:00', 'Đã thanh toán', 'Đơn realistic #0673'),
(674, NULL, 3, NULL, '2026-04-06 20:40:00', 'Đã thanh toán', 'Đơn realistic #0674'),
(675, 2, 12, NULL, '2026-04-06 19:57:00', 'Đã thanh toán', 'Đơn realistic #0675'),
(676, 13, 2, NULL, '2026-04-06 19:34:00', 'Đã thanh toán', 'Đơn realistic #0676'),
(677, 7, 8, 3, '2026-04-06 20:55:00', 'Đã thanh toán', 'Đơn realistic #0677'),
(678, NULL, 4, NULL, '2026-04-06 21:29:00', 'Đã thanh toán', 'Đơn realistic #0678'),
(679, 31, 4, 4, '2026-04-06 20:38:00', 'Đã thanh toán', 'Đơn realistic #0679'),
(680, NULL, 8, NULL, '2026-04-06 20:21:00', 'Đã thanh toán', 'Đơn realistic #0680'),
(681, 27, 3, NULL, '2026-04-06 20:53:00', 'Đã thanh toán', 'Đơn realistic #0681'),
(682, 39, 12, NULL, '2026-04-06 08:44:00', 'Đã thanh toán', 'Đơn realistic #0682'),
(683, NULL, 12, NULL, '2026-04-06 08:51:00', 'Đã thanh toán', 'Đơn realistic #0683'),
(684, 7, 4, NULL, '2026-04-06 10:55:00', 'Đã thanh toán', 'Đơn realistic #0684'),
(685, 2, 2, 2, '2026-04-06 10:23:00', 'Đã thanh toán', 'Đơn realistic #0685'),
(686, 14, 4, NULL, '2026-04-06 11:15:00', 'Đã thanh toán', 'Đơn realistic #0686'),
(687, NULL, 2, NULL, '2026-04-06 10:57:00', 'Đã thanh toán', 'Đơn realistic #0687'),
(688, NULL, 12, 5, '2026-04-06 15:01:00', 'Đã thanh toán', 'Đơn realistic #0688'),
(689, 36, 8, NULL, '2026-04-06 15:20:00', 'Đã thanh toán', 'Đơn realistic #0689'),
(690, 40, 12, NULL, '2026-04-06 17:28:00', 'Đã thanh toán', 'Đơn realistic #0690'),
(691, 8, 3, NULL, '2026-04-06 18:55:00', 'Đã thanh toán', 'Đơn realistic #0691'),
(692, 39, 8, NULL, '2026-04-06 18:17:00', 'Đã thanh toán', 'Đơn realistic #0692'),
(693, 1, 4, NULL, '2026-04-06 16:58:00', 'Đã thanh toán', 'Đơn realistic #0693'),
(694, 3, 4, NULL, '2026-04-06 17:44:00', 'Đã thanh toán', 'Đơn realistic #0694'),
(695, 36, 12, 4, '2026-04-06 22:02:00', 'Đã thanh toán', 'Đơn realistic #0695'),
(696, 30, 3, NULL, '2026-04-06 19:33:00', 'Đã thanh toán', 'Đơn realistic #0696'),
(697, 8, 3, NULL, '2026-04-06 19:58:00', 'Đã thanh toán', 'Đơn realistic #0697'),
(698, 20, 12, NULL, '2026-04-06 21:22:00', 'Đã thanh toán', 'Đơn realistic #0698'),
(699, 6, 3, NULL, '2026-04-06 19:49:00', 'Đã thanh toán', 'Đơn realistic #0699'),
(700, NULL, 2, NULL, '2026-04-06 20:03:00', 'Đã thanh toán', 'Đơn realistic #0700'),
(701, 31, 12, NULL, '2026-04-06 20:25:00', 'Đã thanh toán', 'Đơn realistic #0701'),
(702, 40, 2, NULL, '2026-04-06 21:54:00', 'Đã thanh toán', 'Đơn realistic #0702'),
(703, NULL, 2, NULL, '2026-04-06 09:41:00', 'Đã thanh toán', 'Đơn realistic #0703'),
(704, 37, 2, NULL, '2026-04-06 08:45:00', 'Đã thanh toán', 'Đơn realistic #0704'),
(705, 1, 8, 2, '2026-04-06 09:09:00', 'Đã thanh toán', 'Đơn realistic #0705'),
(706, 10, 4, NULL, '2026-04-06 08:47:00', 'Đã thanh toán', 'Đơn realistic #0706'),
(707, 14, 12, NULL, '2026-04-06 11:29:00', 'Đã thanh toán', 'Đơn realistic #0707'),
(708, NULL, 2, NULL, '2026-04-06 10:43:00', 'Đã thanh toán', 'Đơn realistic #0708'),
(709, NULL, 3, NULL, '2026-04-06 12:30:00', 'Đã thanh toán', 'Đơn realistic #0709'),
(710, 15, 3, NULL, '2026-04-06 11:59:00', 'Đã thanh toán', 'Đơn realistic #0710'),
(711, NULL, 8, NULL, '2026-04-06 11:34:00', 'Đã thanh toán', 'Đơn realistic #0711'),
(712, 14, 3, NULL, '2026-04-06 14:21:00', 'Đã thanh toán', 'Đơn realistic #0712'),
(713, 3, 3, NULL, '2026-04-06 15:08:00', 'Đã thanh toán', 'Đơn realistic #0713'),
(714, 10, 3, NULL, '2026-04-06 15:29:00', 'Đã thanh toán', 'Đơn realistic #0714'),
(715, NULL, 2, NULL, '2026-04-06 16:28:00', 'Đã thanh toán', 'Đơn realistic #0715'),
(716, 21, 8, NULL, '2026-04-06 19:07:00', 'Đã thanh toán', 'Đơn realistic #0716'),
(717, 32, 4, NULL, '2026-04-06 18:54:00', 'Đã thanh toán', 'Đơn realistic #0717'),
(718, 12, 8, NULL, '2026-04-06 18:01:00', 'Đã thanh toán', 'Đơn realistic #0718'),
(719, NULL, 8, 5, '2026-04-06 18:40:00', 'Đã thanh toán', 'Đơn realistic #0719'),
(720, NULL, 3, NULL, '2026-04-06 18:19:00', 'Đã thanh toán', 'Đơn realistic #0720'),
(721, 2, 8, NULL, '2026-04-06 18:40:00', 'Đã thanh toán', 'Đơn realistic #0721'),
(722, 19, 2, NULL, '2026-04-06 09:42:00', 'Đã thanh toán', 'Đơn realistic #0722'),
(723, 9, 8, NULL, '2026-04-06 10:23:00', 'Đã thanh toán', 'Đơn realistic #0723'),
(724, 13, 2, 5, '2026-04-06 13:54:00', 'Đã thanh toán', 'Đơn realistic #0724'),
(725, 6, 2, NULL, '2026-04-06 12:41:00', 'Đã thanh toán', 'Đơn realistic #0725'),
(726, 21, 4, NULL, '2026-04-06 12:22:00', 'Đã thanh toán', 'Đơn realistic #0726'),
(727, NULL, 3, NULL, '2026-04-06 17:56:00', 'Đã thanh toán', 'Đơn realistic #0727'),
(728, NULL, 12, NULL, '2026-04-06 16:48:00', 'Đã thanh toán', 'Đơn realistic #0728'),
(729, 22, 2, NULL, '2026-04-06 16:53:00', 'Đã thanh toán', 'Đơn realistic #0729'),
(730, 5, 2, 2, '2026-04-06 17:36:00', 'Đã thanh toán', 'Đơn realistic #0730'),
(731, 18, 4, NULL, '2026-04-06 15:35:00', 'Đã thanh toán', 'Đơn realistic #0731'),
(732, NULL, 12, NULL, '2026-04-06 17:44:00', 'Đã thanh toán', 'Đơn realistic #0732'),
(733, NULL, 3, NULL, '2026-04-06 17:50:00', 'Đã thanh toán', 'Đơn realistic #0733'),
(734, 36, 3, NULL, '2026-04-06 20:54:00', 'Đã thanh toán', 'Đơn realistic #0734'),
(735, NULL, 8, 2, '2026-04-06 20:55:00', 'Đã thanh toán', 'Đơn realistic #0735'),
(736, NULL, 4, 4, '2026-04-06 20:44:00', 'Đã thanh toán', 'Đơn realistic #0736'),
(737, 35, 2, NULL, '2026-04-06 21:15:00', 'Đã thanh toán', 'Đơn realistic #0737'),
(738, NULL, 4, NULL, '2026-04-06 19:50:00', 'Đã thanh toán', 'Đơn realistic #0738'),
(739, 16, 8, NULL, '2026-04-06 07:44:00', 'Đã thanh toán', 'Đơn realistic #0739'),
(740, NULL, 2, NULL, '2026-04-06 07:31:00', 'Đã thanh toán', 'Đơn realistic #0740'),
(741, 39, 4, 5, '2026-04-06 10:17:00', 'Đã thanh toán', 'Đơn realistic #0741'),
(742, NULL, 12, NULL, '2026-04-06 10:49:00', 'Đã thanh toán', 'Đơn realistic #0742'),
(743, 8, 8, 3, '2026-04-06 10:43:00', 'Đã thanh toán', 'Đơn realistic #0743'),
(744, 22, 12, NULL, '2026-04-06 09:42:00', 'Đã thanh toán', 'Đơn realistic #0744'),
(745, 40, 4, NULL, '2026-04-06 10:52:00', 'Đã thanh toán', 'Đơn realistic #0745'),
(746, 6, 4, NULL, '2026-04-06 12:22:00', 'Đã thanh toán', 'Đơn realistic #0746'),
(747, NULL, 2, NULL, '2026-04-06 14:56:00', 'Đã thanh toán', 'Đơn realistic #0747'),
(748, 16, 3, NULL, '2026-04-06 12:20:00', 'Đã thanh toán', 'Đơn realistic #0748'),
(749, 13, 3, NULL, '2026-04-06 16:15:00', 'Đã thanh toán', 'Đơn realistic #0749'),
(750, NULL, 3, NULL, '2026-04-06 15:57:00', 'Đã thanh toán', 'Đơn realistic #0750'),
(751, NULL, 3, NULL, '2026-04-06 17:54:00', 'Đã thanh toán', 'Đơn realistic #0751'),
(752, 11, 12, 2, '2026-04-06 18:08:00', 'Đã thanh toán', 'Đơn realistic #0752'),
(753, 38, 4, NULL, '2026-04-06 17:49:00', 'Đã thanh toán', 'Đơn realistic #0753'),
(754, 37, 8, NULL, '2026-04-06 20:04:00', 'Đã thanh toán', 'Đơn realistic #0754'),
(755, 32, 8, NULL, '2026-04-06 21:29:00', 'Đã thanh toán', 'Đơn realistic #0755'),
(756, 22, 8, NULL, '2026-04-06 20:17:00', 'Đã thanh toán', 'Đơn realistic #0756'),
(757, 27, 4, NULL, '2026-04-07 08:38:00', 'Đã thanh toán', 'Đơn realistic #0757'),
(758, 29, 3, NULL, '2026-04-07 08:13:00', 'Đã thanh toán', 'Đơn realistic #0758'),
(759, 37, 8, NULL, '2026-04-07 11:45:00', 'Đã thanh toán', 'Đơn realistic #0759'),
(760, NULL, 3, NULL, '2026-04-07 10:29:00', 'Đã thanh toán', 'Đơn realistic #0760'),
(761, NULL, 4, NULL, '2026-04-07 10:23:00', 'Đã thanh toán', 'Đơn realistic #0761'),
(762, NULL, 4, NULL, '2026-04-07 09:53:00', 'Đã thanh toán', 'Đơn realistic #0762'),
(763, NULL, 8, NULL, '2026-04-07 10:59:00', 'Đã thanh toán', 'Đơn realistic #0763'),
(764, 9, 4, NULL, '2026-04-07 11:46:00', 'Đã thanh toán', 'Đơn realistic #0764'),
(765, 39, 8, NULL, '2026-04-07 10:31:00', 'Đã thanh toán', 'Đơn realistic #0765'),
(766, 28, 12, NULL, '2026-04-07 13:49:00', 'Đã thanh toán', 'Đơn realistic #0766'),
(767, NULL, 12, 5, '2026-04-07 14:31:00', 'Đã thanh toán', 'Đơn realistic #0767'),
(768, 27, 12, NULL, '2026-04-07 14:03:00', 'Đã thanh toán', 'Đơn realistic #0768'),
(769, 31, 12, NULL, '2026-04-07 13:42:00', 'Đã thanh toán', 'Đơn realistic #0769'),
(770, 16, 12, NULL, '2026-04-07 16:28:00', 'Đã thanh toán', 'Đơn realistic #0770'),
(771, 15, 3, 5, '2026-04-07 18:23:00', 'Đã thanh toán', 'Đơn realistic #0771'),
(772, NULL, 4, NULL, '2026-04-07 17:33:00', 'Đã thanh toán', 'Đơn realistic #0772'),
(773, 15, 3, 2, '2026-04-07 16:58:00', 'Đã thanh toán', 'Đơn realistic #0773'),
(774, 29, 12, NULL, '2026-04-07 16:17:00', 'Đã thanh toán', 'Đơn realistic #0774'),
(775, 19, 12, NULL, '2026-04-07 20:45:00', 'Đã thanh toán', 'Đơn realistic #0775'),
(776, NULL, 4, NULL, '2026-04-07 20:06:00', 'Đã thanh toán', 'Đơn realistic #0776'),
(777, 28, 12, NULL, '2026-04-07 20:38:00', 'Đã thanh toán', 'Đơn realistic #0777'),
(778, 20, 8, NULL, '2026-04-07 19:25:00', 'Đã thanh toán', 'Đơn realistic #0778'),
(779, 21, 2, NULL, '2026-04-07 19:11:00', 'Đã thanh toán', 'Đơn realistic #0779'),
(780, NULL, 3, NULL, '2026-04-07 21:26:00', 'Đã thanh toán', 'Đơn realistic #0780'),
(781, 17, 12, NULL, '2026-04-07 21:21:00', 'Đã thanh toán', 'Đơn realistic #0781'),
(782, 36, 3, NULL, '2026-04-07 08:23:00', 'Đã thanh toán', 'Đơn realistic #0782'),
(783, NULL, 2, NULL, '2026-04-07 08:15:00', 'Đã thanh toán', 'Đơn realistic #0783'),
(784, NULL, 4, NULL, '2026-04-07 08:52:00', 'Đã thanh toán', 'Đơn realistic #0784'),
(785, NULL, 3, NULL, '2026-04-07 10:41:00', 'Đã thanh toán', 'Đơn realistic #0785'),
(786, 1, 4, NULL, '2026-04-07 12:30:00', 'Đã thanh toán', 'Đơn realistic #0786'),
(787, 17, 3, 3, '2026-04-07 10:02:00', 'Đã thanh toán', 'Đơn realistic #0787'),
(788, 2, 3, NULL, '2026-04-07 13:38:00', 'Đã thanh toán', 'Đơn realistic #0788'),
(789, 25, 3, 2, '2026-04-07 15:30:00', 'Đã thanh toán', 'Đơn realistic #0789'),
(790, 8, 3, 3, '2026-04-07 15:12:00', 'Đã thanh toán', 'Đơn realistic #0790'),
(791, 14, 2, NULL, '2026-04-07 15:40:00', 'Đã thanh toán', 'Đơn realistic #0791'),
(792, 40, 3, NULL, '2026-04-07 14:28:00', 'Đã thanh toán', 'Đơn realistic #0792'),
(793, 19, 12, NULL, '2026-04-07 16:57:00', 'Đã thanh toán', 'Đơn realistic #0793'),
(794, 22, 8, NULL, '2026-04-07 17:48:00', 'Đã thanh toán', 'Đơn realistic #0794'),
(795, 12, 4, NULL, '2026-04-07 17:34:00', 'Đã thanh toán', 'Đơn realistic #0795'),
(796, 4, 12, NULL, '2026-04-07 20:17:00', 'Đã thanh toán', 'Đơn realistic #0796'),
(797, NULL, 12, NULL, '2026-04-07 20:32:00', 'Đã thanh toán', 'Đơn realistic #0797'),
(798, 40, 3, NULL, '2026-04-07 19:48:00', 'Đã thanh toán', 'Đơn realistic #0798'),
(799, 13, 2, NULL, '2026-04-07 20:48:00', 'Đã thanh toán', 'Đơn realistic #0799'),
(800, 31, 3, NULL, '2026-04-07 21:54:00', 'Đã thanh toán', 'Đơn realistic #0800'),
(801, 24, 4, NULL, '2026-04-07 08:55:00', 'Đã thanh toán', 'Đơn realistic #0801'),
(802, 12, 4, NULL, '2026-04-07 09:33:00', 'Đã thanh toán', 'Đơn realistic #0802'),
(803, NULL, 3, NULL, '2026-04-07 08:56:00', 'Đã thanh toán', 'Đơn realistic #0803'),
(804, 31, 4, NULL, '2026-04-07 09:33:00', 'Đã thanh toán', 'Đơn realistic #0804'),
(805, 27, 2, 5, '2026-04-07 13:10:00', 'Đã thanh toán', 'Đơn realistic #0805'),
(806, NULL, 3, 5, '2026-04-07 13:18:00', 'Đã thanh toán', 'Đơn realistic #0806'),
(807, 28, 3, NULL, '2026-04-07 15:05:00', 'Đã thanh toán', 'Đơn realistic #0807'),
(808, 10, 8, 2, '2026-04-07 15:18:00', 'Đã thanh toán', 'Đơn realistic #0808'),
(809, 17, 8, NULL, '2026-04-07 16:16:00', 'Đã thanh toán', 'Đơn realistic #0809'),
(810, 7, 3, 2, '2026-04-07 18:24:00', 'Đã thanh toán', 'Đơn realistic #0810'),
(811, NULL, 2, 5, '2026-04-07 19:34:00', 'Đã thanh toán', 'Đơn realistic #0811'),
(812, 28, 12, NULL, '2026-04-07 18:23:00', 'Đã thanh toán', 'Đơn realistic #0812'),
(813, 37, 8, NULL, '2026-04-07 19:35:00', 'Đã thanh toán', 'Đơn realistic #0813'),
(814, 29, 8, 2, '2026-04-07 10:30:00', 'Đã thanh toán', 'Đơn realistic #0814'),
(815, 14, 2, NULL, '2026-04-07 10:29:00', 'Đã thanh toán', 'Đơn realistic #0815'),
(816, 17, 2, NULL, '2026-04-07 12:19:00', 'Đã thanh toán', 'Đơn realistic #0816'),
(817, 13, 8, 2, '2026-04-07 12:01:00', 'Đã thanh toán', 'Đơn realistic #0817'),
(818, 37, 2, NULL, '2026-04-07 14:03:00', 'Đã thanh toán', 'Đơn realistic #0818'),
(819, NULL, 4, NULL, '2026-04-07 17:57:00', 'Đã thanh toán', 'Đơn realistic #0819'),
(820, NULL, 3, NULL, '2026-04-07 17:42:00', 'Đã thanh toán', 'Đơn realistic #0820'),
(821, 23, 2, NULL, '2026-04-07 18:04:00', 'Đã thanh toán', 'Đơn realistic #0821'),
(822, 13, 12, NULL, '2026-04-07 15:41:00', 'Đã thanh toán', 'Đơn realistic #0822'),
(823, 6, 3, NULL, '2026-04-07 17:22:00', 'Đã thanh toán', 'Đơn realistic #0823'),
(824, 36, 8, NULL, '2026-04-07 18:04:00', 'Đã thanh toán', 'Đơn realistic #0824'),
(825, 26, 3, NULL, '2026-04-07 17:31:00', 'Đã thanh toán', 'Đơn realistic #0825'),
(826, 32, 2, NULL, '2026-04-07 17:58:00', 'Đã thanh toán', 'Đơn realistic #0826'),
(827, NULL, 4, 2, '2026-04-07 15:49:00', 'Đã thanh toán', 'Đơn realistic #0827'),
(828, NULL, 12, NULL, '2026-04-07 15:54:00', 'Đã thanh toán', 'Đơn realistic #0828'),
(829, NULL, 8, 2, '2026-04-07 20:41:00', 'Đã thanh toán', 'Đơn realistic #0829'),
(830, 12, 2, NULL, '2026-04-07 21:35:00', 'Đã thanh toán', 'Đơn realistic #0830'),
(831, 25, 2, NULL, '2026-04-07 19:47:00', 'Đã thanh toán', 'Đơn realistic #0831'),
(832, 12, 8, NULL, '2026-04-07 19:17:00', 'Đã thanh toán', 'Đơn realistic #0832'),
(833, 28, 12, NULL, '2026-04-07 20:08:00', 'Đã thanh toán', 'Đơn realistic #0833'),
(834, NULL, 4, NULL, '2026-04-07 21:27:00', 'Đã thanh toán', 'Đơn realistic #0834'),
(835, NULL, 3, 5, '2026-04-07 21:36:00', 'Đã thanh toán', 'Đơn realistic #0835'),
(836, NULL, 3, NULL, '2026-04-07 07:42:00', 'Đã thanh toán', 'Đơn realistic #0836'),
(837, 33, 2, NULL, '2026-04-07 07:46:00', 'Đã thanh toán', 'Đơn realistic #0837'),
(838, 16, 12, 3, '2026-04-07 11:42:00', 'Đã thanh toán', 'Đơn realistic #0838'),
(839, NULL, 3, NULL, '2026-04-07 09:37:00', 'Đã thanh toán', 'Đơn realistic #0839'),
(840, 40, 12, NULL, '2026-04-07 11:36:00', 'Đã thanh toán', 'Đơn realistic #0840'),
(841, NULL, 12, NULL, '2026-04-07 09:12:00', 'Đã thanh toán', 'Đơn realistic #0841'),
(842, NULL, 2, NULL, '2026-04-07 13:44:00', 'Đã thanh toán', 'Đơn realistic #0842'),
(843, 6, 4, NULL, '2026-04-07 14:14:00', 'Đã thanh toán', 'Đơn realistic #0843'),
(844, NULL, 3, NULL, '2026-04-07 14:49:00', 'Đã thanh toán', 'Đơn realistic #0844'),
(845, NULL, 8, NULL, '2026-04-07 13:29:00', 'Đã thanh toán', 'Đơn realistic #0845'),
(846, NULL, 12, NULL, '2026-04-07 13:48:00', 'Đã thanh toán', 'Đơn realistic #0846'),
(847, NULL, 12, 2, '2026-04-07 12:45:00', 'Đã thanh toán', 'Đơn realistic #0847'),
(848, 7, 4, NULL, '2026-04-07 16:18:00', 'Đã thanh toán', 'Đơn realistic #0848'),
(849, NULL, 2, NULL, '2026-04-07 16:01:00', 'Đã thanh toán', 'Đơn realistic #0849'),
(850, 30, 4, NULL, '2026-04-07 16:37:00', 'Đã thanh toán', 'Đơn realistic #0850'),
(851, 36, 4, 5, '2026-04-07 17:28:00', 'Đã thanh toán', 'Đơn realistic #0851'),
(852, 20, 2, NULL, '2026-04-07 15:43:00', 'Đã thanh toán', 'Đơn realistic #0852'),
(853, 1, 3, NULL, '2026-04-07 17:22:00', 'Đã thanh toán', 'Đơn realistic #0853'),
(854, NULL, 2, NULL, '2026-04-07 20:44:00', 'Đã thanh toán', 'Đơn realistic #0854'),
(855, 11, 2, NULL, '2026-04-07 20:01:00', 'Đã thanh toán', 'Đơn realistic #0855'),
(856, 1, 4, NULL, '2026-04-07 20:16:00', 'Đã thanh toán', 'Đơn realistic #0856'),
(857, NULL, 2, 2, '2026-04-07 21:14:00', 'Đã thanh toán', 'Đơn realistic #0857'),
(858, 27, 3, NULL, '2026-04-07 21:00:00', 'Đã thanh toán', 'Đơn realistic #0858'),
(859, 3, 8, NULL, '2026-04-07 19:44:00', 'Đã thanh toán', 'Đơn realistic #0859'),
(860, NULL, 4, NULL, '2026-04-07 20:51:00', 'Đã thanh toán', 'Đơn realistic #0860'),
(861, NULL, 12, NULL, '2026-04-07 21:16:00', 'Đã thanh toán', 'Đơn realistic #0861'),
(862, NULL, 3, NULL, '2026-04-08 08:29:00', 'Đã thanh toán', 'Đơn realistic #0862'),
(863, 2, 3, 2, '2026-04-08 07:40:00', 'Đã thanh toán', 'Đơn realistic #0863'),
(864, NULL, 3, NULL, '2026-04-08 08:15:00', 'Đã thanh toán', 'Đơn realistic #0864'),
(865, NULL, 12, NULL, '2026-04-08 07:45:00', 'Đã thanh toán', 'Đơn realistic #0865'),
(866, 12, 12, NULL, '2026-04-08 09:18:00', 'Đã thanh toán', 'Đơn realistic #0866'),
(867, 25, 3, 3, '2026-04-08 09:57:00', 'Đã thanh toán', 'Đơn realistic #0867'),
(868, NULL, 4, NULL, '2026-04-08 11:04:00', 'Đã thanh toán', 'Đơn realistic #0868'),
(869, 3, 2, NULL, '2026-04-08 09:55:00', 'Đã thanh toán', 'Đơn realistic #0869'),
(870, NULL, 12, NULL, '2026-04-08 10:50:00', 'Đã thanh toán', 'Đơn realistic #0870'),
(871, 32, 8, NULL, '2026-04-08 12:55:00', 'Đã thanh toán', 'Đơn realistic #0871'),
(872, 21, 4, NULL, '2026-04-08 15:07:00', 'Đã thanh toán', 'Đơn realistic #0872'),
(873, 24, 4, 2, '2026-04-08 14:56:00', 'Đã thanh toán', 'Đơn realistic #0873'),
(874, NULL, 12, NULL, '2026-04-08 16:05:00', 'Đã thanh toán', 'Đơn realistic #0874'),
(875, 23, 12, NULL, '2026-04-08 15:51:00', 'Đã thanh toán', 'Đơn realistic #0875'),
(876, NULL, 4, NULL, '2026-04-08 18:09:00', 'Đã thanh toán', 'Đơn realistic #0876'),
(877, 3, 2, NULL, '2026-04-08 17:56:00', 'Đã thanh toán', 'Đơn realistic #0877'),
(878, 5, 8, NULL, '2026-04-08 16:27:00', 'Đã thanh toán', 'Đơn realistic #0878'),
(879, NULL, 3, NULL, '2026-04-08 17:35:00', 'Đã thanh toán', 'Đơn realistic #0879'),
(880, 31, 12, 2, '2026-04-08 20:08:00', 'Đã thanh toán', 'Đơn realistic #0880'),
(881, 18, 2, 2, '2026-04-08 20:16:00', 'Đã thanh toán', 'Đơn realistic #0881'),
(882, NULL, 2, NULL, '2026-04-08 21:30:00', 'Đã thanh toán', 'Đơn realistic #0882'),
(883, NULL, 12, 4, '2026-04-08 20:40:00', 'Đã thanh toán', 'Đơn realistic #0883'),
(884, 39, 8, NULL, '2026-04-08 20:47:00', 'Đã thanh toán', 'Đơn realistic #0884'),
(885, NULL, 2, 4, '2026-04-08 19:29:00', 'Đã thanh toán', 'Đơn realistic #0885'),
(886, 11, 4, NULL, '2026-04-08 21:28:00', 'Đã thanh toán', 'Đơn realistic #0886'),
(887, NULL, 4, NULL, '2026-04-08 08:18:00', 'Đã thanh toán', 'Đơn realistic #0887'),
(888, NULL, 2, NULL, '2026-04-08 08:32:00', 'Đã thanh toán', 'Đơn realistic #0888'),
(889, 27, 12, NULL, '2026-04-08 08:19:00', 'Đã thanh toán', 'Đơn realistic #0889'),
(890, 5, 12, NULL, '2026-04-08 12:21:00', 'Đã thanh toán', 'Đơn realistic #0890'),
(891, NULL, 8, NULL, '2026-04-08 11:26:00', 'Đã thanh toán', 'Đơn realistic #0891'),
(892, NULL, 2, NULL, '2026-04-08 11:24:00', 'Đã thanh toán', 'Đơn realistic #0892'),
(893, 31, 8, NULL, '2026-04-08 10:59:00', 'Đã thanh toán', 'Đơn realistic #0893'),
(894, NULL, 4, NULL, '2026-04-08 10:47:00', 'Đã thanh toán', 'Đơn realistic #0894'),
(895, NULL, 4, NULL, '2026-04-08 13:18:00', 'Đã thanh toán', 'Đơn realistic #0895'),
(896, NULL, 4, NULL, '2026-04-08 14:55:00', 'Đã thanh toán', 'Đơn realistic #0896'),
(897, 23, 12, NULL, '2026-04-08 13:17:00', 'Đã thanh toán', 'Đơn realistic #0897'),
(898, 31, 4, 2, '2026-04-08 13:31:00', 'Đã thanh toán', 'Đơn realistic #0898'),
(899, NULL, 4, NULL, '2026-04-08 14:27:00', 'Đã thanh toán', 'Đơn realistic #0899'),
(900, 36, 2, NULL, '2026-04-08 15:34:00', 'Đã thanh toán', 'Đơn realistic #0900'),
(901, 20, 4, NULL, '2026-04-08 15:23:00', 'Đã thanh toán', 'Đơn realistic #0901'),
(902, NULL, 12, NULL, '2026-04-08 13:57:00', 'Đã thanh toán', 'Đơn realistic #0902'),
(903, 14, 8, NULL, '2026-04-08 14:42:00', 'Đã thanh toán', 'Đơn realistic #0903'),
(904, 39, 8, NULL, '2026-04-08 18:46:00', 'Đã thanh toán', 'Đơn realistic #0904'),
(905, 5, 3, NULL, '2026-04-08 18:37:00', 'Đã thanh toán', 'Đơn realistic #0905'),
(906, 23, 2, NULL, '2026-04-08 17:15:00', 'Đã thanh toán', 'Đơn realistic #0906'),
(907, 7, 3, NULL, '2026-04-08 18:26:00', 'Đã thanh toán', 'Đơn realistic #0907'),
(908, NULL, 8, NULL, '2026-04-08 16:54:00', 'Đã thanh toán', 'Đơn realistic #0908'),
(909, 2, 4, NULL, '2026-04-08 18:26:00', 'Đã thanh toán', 'Đơn realistic #0909'),
(910, NULL, 2, NULL, '2026-04-08 21:33:00', 'Đã thanh toán', 'Đơn realistic #0910'),
(911, NULL, 8, NULL, '2026-04-08 20:11:00', 'Đã thanh toán', 'Đơn realistic #0911'),
(912, NULL, 12, NULL, '2026-04-08 19:48:00', 'Đã thanh toán', 'Đơn realistic #0912'),
(913, NULL, 2, NULL, '2026-04-08 21:34:00', 'Đã thanh toán', 'Đơn realistic #0913'),
(914, 35, 12, NULL, '2026-04-08 19:43:00', 'Đã thanh toán', 'Đơn realistic #0914'),
(915, 9, 3, NULL, '2026-04-08 20:26:00', 'Đã thanh toán', 'Đơn realistic #0915'),
(916, 35, 4, NULL, '2026-04-08 21:25:00', 'Đã thanh toán', 'Đơn realistic #0916'),
(917, 25, 12, NULL, '2026-04-08 20:51:00', 'Đã thanh toán', 'Đơn realistic #0917'),
(918, NULL, 12, NULL, '2026-04-08 09:47:00', 'Đã thanh toán', 'Đơn realistic #0918'),
(919, 33, 4, 2, '2026-04-08 09:27:00', 'Đã thanh toán', 'Đơn realistic #0919'),
(920, 18, 2, NULL, '2026-04-08 11:18:00', 'Đã thanh toán', 'Đơn realistic #0920'),
(921, NULL, 12, NULL, '2026-04-08 11:56:00', 'Đã thanh toán', 'Đơn realistic #0921'),
(922, 23, 3, 5, '2026-04-08 12:28:00', 'Đã thanh toán', 'Đơn realistic #0922'),
(923, 9, 2, NULL, '2026-04-08 15:54:00', 'Đã thanh toán', 'Đơn realistic #0923'),
(924, 5, 12, 2, '2026-04-08 14:31:00', 'Đã thanh toán', 'Đơn realistic #0924'),
(925, NULL, 4, NULL, '2026-04-08 15:04:00', 'Đã thanh toán', 'Đơn realistic #0925'),
(926, 17, 12, 3, '2026-04-08 17:53:00', 'Đã thanh toán', 'Đơn realistic #0926'),
(927, 8, 3, NULL, '2026-04-08 17:58:00', 'Đã thanh toán', 'Đơn realistic #0927'),
(928, NULL, 2, NULL, '2026-04-08 19:41:00', 'Đã thanh toán', 'Đơn realistic #0928'),
(929, 36, 8, 2, '2026-04-08 10:20:00', 'Đã thanh toán', 'Đơn realistic #0929'),
(930, NULL, 12, NULL, '2026-04-08 09:49:00', 'Đã thanh toán', 'Đơn realistic #0930'),
(931, 10, 4, 2, '2026-04-08 10:25:00', 'Đã thanh toán', 'Đơn realistic #0931'),
(932, 1, 4, 2, '2026-04-08 11:54:00', 'Đã thanh toán', 'Đơn realistic #0932'),
(933, 34, 12, NULL, '2026-04-08 13:29:00', 'Đã thanh toán', 'Đơn realistic #0933'),
(934, 18, 3, NULL, '2026-04-08 13:37:00', 'Đã thanh toán', 'Đơn realistic #0934'),
(935, 37, 12, NULL, '2026-04-08 12:53:00', 'Đã thanh toán', 'Đơn realistic #0935'),
(936, 2, 3, NULL, '2026-04-08 12:30:00', 'Đã thanh toán', 'Đơn realistic #0936'),
(937, 22, 8, 2, '2026-04-08 16:24:00', 'Đã thanh toán', 'Đơn realistic #0937'),
(938, 23, 12, NULL, '2026-04-08 17:37:00', 'Đã thanh toán', 'Đơn realistic #0938'),
(939, NULL, 4, NULL, '2026-04-08 15:32:00', 'Đã thanh toán', 'Đơn realistic #0939'),
(940, NULL, 8, 2, '2026-04-08 17:29:00', 'Đã thanh toán', 'Đơn realistic #0940'),
(941, 28, 2, 2, '2026-04-08 17:21:00', 'Đã thanh toán', 'Đơn realistic #0941'),
(942, 29, 12, 5, '2026-04-08 19:27:00', 'Đã thanh toán', 'Đơn realistic #0942'),
(943, NULL, 12, 4, '2026-04-08 21:35:00', 'Đã thanh toán', 'Đơn realistic #0943'),
(944, 21, 2, NULL, '2026-04-08 20:30:00', 'Đã thanh toán', 'Đơn realistic #0944'),
(945, 16, 3, NULL, '2026-04-08 07:50:00', 'Đã thanh toán', 'Đơn realistic #0945'),
(946, 17, 4, NULL, '2026-04-08 11:28:00', 'Đã thanh toán', 'Đơn realistic #0946'),
(947, NULL, 12, NULL, '2026-04-08 09:35:00', 'Đã thanh toán', 'Đơn realistic #0947'),
(948, 22, 8, NULL, '2026-04-08 11:42:00', 'Đã thanh toán', 'Đơn realistic #0948'),
(949, 32, 4, NULL, '2026-04-08 14:04:00', 'Đã thanh toán', 'Đơn realistic #0949'),
(950, 11, 2, NULL, '2026-04-08 14:57:00', 'Đã thanh toán', 'Đơn realistic #0950'),
(951, 17, 12, NULL, '2026-04-08 13:03:00', 'Đã thanh toán', 'Đơn realistic #0951'),
(952, 9, 3, NULL, '2026-04-08 13:12:00', 'Đã thanh toán', 'Đơn realistic #0952'),
(953, NULL, 12, NULL, '2026-04-08 16:27:00', 'Đã thanh toán', 'Đơn realistic #0953'),
(954, NULL, 4, NULL, '2026-04-08 15:53:00', 'Đã thanh toán', 'Đơn realistic #0954'),
(955, NULL, 3, NULL, '2026-04-08 16:55:00', 'Đã thanh toán', 'Đơn realistic #0955'),
(956, NULL, 12, NULL, '2026-04-08 17:41:00', 'Đã thanh toán', 'Đơn realistic #0956'),
(957, 39, 12, NULL, '2026-04-08 17:01:00', 'Đã thanh toán', 'Đơn realistic #0957'),
(958, 8, 3, 3, '2026-04-08 20:44:00', 'Đã thanh toán', 'Đơn realistic #0958'),
(959, 25, 12, NULL, '2026-04-08 19:20:00', 'Đã thanh toán', 'Đơn realistic #0959'),
(960, 6, 2, NULL, '2026-04-08 21:19:00', 'Đã thanh toán', 'Đơn realistic #0960'),
(961, 30, 4, NULL, '2026-04-08 19:30:00', 'Đã thanh toán', 'Đơn realistic #0961'),
(962, 38, 2, 2, '2026-04-08 21:14:00', 'Đã thanh toán', 'Đơn realistic #0962'),
(963, NULL, 2, 4, '2026-04-08 20:45:00', 'Đã thanh toán', 'Đơn realistic #0963'),
(964, NULL, 12, NULL, '2026-04-08 19:10:00', 'Đã thanh toán', 'Đơn realistic #0964'),
(965, 39, 3, NULL, '2026-04-09 07:44:00', 'Đã thanh toán', 'Đơn realistic #0965'),
(966, 33, 12, NULL, '2026-04-09 08:27:00', 'Đã thanh toán', 'Đơn realistic #0966'),
(967, 26, 2, NULL, '2026-04-09 08:00:00', 'Đã thanh toán', 'Đơn realistic #0967'),
(968, NULL, 3, NULL, '2026-04-09 10:58:00', 'Đã thanh toán', 'Đơn realistic #0968'),
(969, 12, 8, NULL, '2026-04-09 10:00:00', 'Đã thanh toán', 'Đơn realistic #0969'),
(970, 16, 4, NULL, '2026-04-09 12:31:00', 'Đã thanh toán', 'Đơn realistic #0970'),
(971, NULL, 4, NULL, '2026-04-09 12:38:00', 'Đã thanh toán', 'Đơn realistic #0971'),
(972, 5, 4, NULL, '2026-04-09 12:39:00', 'Đã thanh toán', 'Đơn realistic #0972'),
(973, 26, 3, NULL, '2026-04-09 13:06:00', 'Đã thanh toán', 'Đơn realistic #0973'),
(974, 27, 4, NULL, '2026-04-09 13:33:00', 'Đã thanh toán', 'Đơn realistic #0974'),
(975, 21, 8, NULL, '2026-04-09 13:51:00', 'Đã thanh toán', 'Đơn realistic #0975'),
(976, 28, 2, NULL, '2026-04-09 13:55:00', 'Đã thanh toán', 'Đơn realistic #0976'),
(977, NULL, 3, NULL, '2026-04-09 17:57:00', 'Đã thanh toán', 'Đơn realistic #0977'),
(978, 39, 4, 2, '2026-04-09 16:43:00', 'Đã thanh toán', 'Đơn realistic #0978'),
(979, NULL, 4, NULL, '2026-04-09 16:55:00', 'Đã thanh toán', 'Đơn realistic #0979'),
(980, NULL, 2, NULL, '2026-04-09 17:56:00', 'Đã thanh toán', 'Đơn realistic #0980'),
(981, NULL, 2, NULL, '2026-04-09 16:59:00', 'Đã thanh toán', 'Đơn realistic #0981'),
(982, 27, 3, NULL, '2026-04-09 18:17:00', 'Đã thanh toán', 'Đơn realistic #0982'),
(983, 1, 8, 2, '2026-04-09 17:16:00', 'Đã thanh toán', 'Đơn realistic #0983'),
(984, 29, 8, NULL, '2026-04-09 18:16:00', 'Đã thanh toán', 'Đơn realistic #0984'),
(985, NULL, 2, NULL, '2026-04-09 19:22:00', 'Đã thanh toán', 'Đơn realistic #0985'),
(986, 20, 3, 4, '2026-04-09 20:08:00', 'Đã thanh toán', 'Đơn realistic #0986'),
(987, 10, 2, NULL, '2026-04-09 21:32:00', 'Đã thanh toán', 'Đơn realistic #0987'),
(988, 31, 12, 2, '2026-04-09 20:02:00', 'Đã thanh toán', 'Đơn realistic #0988'),
(989, 24, 4, NULL, '2026-04-09 21:03:00', 'Đã thanh toán', 'Đơn realistic #0989'),
(990, 9, 8, NULL, '2026-04-09 19:41:00', 'Đã thanh toán', 'Đơn realistic #0990'),
(991, NULL, 12, NULL, '2026-04-09 09:06:00', 'Đã thanh toán', 'Đơn realistic #0991'),
(992, 2, 4, NULL, '2026-04-09 09:12:00', 'Đã thanh toán', 'Đơn realistic #0992'),
(993, 25, 4, NULL, '2026-04-09 08:51:00', 'Đã thanh toán', 'Đơn realistic #0993'),
(994, 37, 4, 2, '2026-04-09 11:38:00', 'Đã thanh toán', 'Đơn realistic #0994'),
(995, 27, 2, NULL, '2026-04-09 11:40:00', 'Đã thanh toán', 'Đơn realistic #0995'),
(996, NULL, 4, NULL, '2026-04-09 10:56:00', 'Đã thanh toán', 'Đơn realistic #0996'),
(997, 2, 3, NULL, '2026-04-09 14:41:00', 'Đã thanh toán', 'Đơn realistic #0997'),
(998, 25, 8, 3, '2026-04-09 13:43:00', 'Đã thanh toán', 'Đơn realistic #0998'),
(999, 15, 12, NULL, '2026-04-09 13:51:00', 'Đã thanh toán', 'Đơn realistic #0999'),
(1000, NULL, 2, NULL, '2026-04-09 14:23:00', 'Đã thanh toán', 'Đơn realistic #1000'),
(1001, NULL, 2, 2, '2026-04-09 18:41:00', 'Đã thanh toán', 'Đơn realistic #1001'),
(1002, 15, 3, NULL, '2026-04-09 16:54:00', 'Đã thanh toán', 'Đơn realistic #1002'),
(1003, 28, 12, NULL, '2026-04-09 17:24:00', 'Đã thanh toán', 'Đơn realistic #1003'),
(1004, NULL, 4, NULL, '2026-04-09 18:06:00', 'Đã thanh toán', 'Đơn realistic #1004'),
(1005, 11, 3, NULL, '2026-04-09 18:13:00', 'Đã thanh toán', 'Đơn realistic #1005'),
(1006, 40, 3, 2, '2026-04-09 17:45:00', 'Đã thanh toán', 'Đơn realistic #1006'),
(1007, 19, 4, NULL, '2026-04-09 17:07:00', 'Đã thanh toán', 'Đơn realistic #1007'),
(1008, 27, 2, 2, '2026-04-09 17:09:00', 'Đã thanh toán', 'Đơn realistic #1008'),
(1009, NULL, 8, NULL, '2026-04-09 18:04:00', 'Đã thanh toán', 'Đơn realistic #1009'),
(1010, 26, 3, 5, '2026-04-09 20:08:00', 'Đã thanh toán', 'Đơn realistic #1010'),
(1011, 5, 4, NULL, '2026-04-09 19:33:00', 'Đã thanh toán', 'Đơn realistic #1011'),
(1012, NULL, 4, 2, '2026-04-09 21:59:00', 'Đã thanh toán', 'Đơn realistic #1012'),
(1013, 19, 3, NULL, '2026-04-09 19:41:00', 'Đã thanh toán', 'Đơn realistic #1013'),
(1014, NULL, 4, NULL, '2026-04-09 08:48:00', 'Đã thanh toán', 'Đơn realistic #1014'),
(1015, NULL, 2, NULL, '2026-04-09 09:18:00', 'Đã thanh toán', 'Đơn realistic #1015'),
(1016, 13, 3, NULL, '2026-04-09 08:49:00', 'Đã thanh toán', 'Đơn realistic #1016'),
(1017, NULL, 2, NULL, '2026-04-09 13:06:00', 'Đã thanh toán', 'Đơn realistic #1017'),
(1018, 25, 8, NULL, '2026-04-09 11:02:00', 'Đã thanh toán', 'Đơn realistic #1018'),
(1019, 5, 4, NULL, '2026-04-09 11:35:00', 'Đã thanh toán', 'Đơn realistic #1019'),
(1020, 23, 8, 2, '2026-04-09 12:18:00', 'Đã thanh toán', 'Đơn realistic #1020'),
(1021, 30, 8, NULL, '2026-04-09 12:56:00', 'Đã thanh toán', 'Đơn realistic #1021'),
(1022, NULL, 2, NULL, '2026-04-09 14:45:00', 'Đã thanh toán', 'Đơn realistic #1022'),
(1023, 8, 12, NULL, '2026-04-09 15:34:00', 'Đã thanh toán', 'Đơn realistic #1023'),
(1024, 40, 12, NULL, '2026-04-09 14:18:00', 'Đã thanh toán', 'Đơn realistic #1024'),
(1025, 3, 8, NULL, '2026-04-09 14:23:00', 'Đã thanh toán', 'Đơn realistic #1025'),
(1026, 14, 2, NULL, '2026-04-09 16:23:00', 'Đã thanh toán', 'Đơn realistic #1026'),
(1027, 15, 3, NULL, '2026-04-09 15:28:00', 'Đã thanh toán', 'Đơn realistic #1027'),
(1028, 9, 12, NULL, '2026-04-09 19:16:00', 'Đã thanh toán', 'Đơn realistic #1028'),
(1029, NULL, 3, NULL, '2026-04-09 19:17:00', 'Đã thanh toán', 'Đơn realistic #1029'),
(1030, NULL, 4, NULL, '2026-04-09 20:14:00', 'Đã thanh toán', 'Đơn realistic #1030'),
(1031, 6, 4, NULL, '2026-04-09 18:48:00', 'Đã thanh toán', 'Đơn realistic #1031'),
(1032, NULL, 2, NULL, '2026-04-09 18:13:00', 'Đã thanh toán', 'Đơn realistic #1032'),
(1033, 10, 4, NULL, '2026-04-09 18:21:00', 'Đã thanh toán', 'Đơn realistic #1033'),
(1034, 18, 2, NULL, '2026-04-09 19:01:00', 'Đã thanh toán', 'Đơn realistic #1034'),
(1035, 29, 12, 2, '2026-04-09 20:06:00', 'Đã thanh toán', 'Đơn realistic #1035'),
(1036, 28, 8, 5, '2026-04-09 10:20:00', 'Đã thanh toán', 'Đơn realistic #1036'),
(1037, 18, 8, 2, '2026-04-09 10:05:00', 'Đã thanh toán', 'Đơn realistic #1037'),
(1038, NULL, 12, NULL, '2026-04-09 10:33:00', 'Đã thanh toán', 'Đơn realistic #1038'),
(1039, NULL, 3, 2, '2026-04-09 12:56:00', 'Đã thanh toán', 'Đơn realistic #1039'),
(1040, NULL, 2, NULL, '2026-04-09 13:31:00', 'Đã thanh toán', 'Đơn realistic #1040'),
(1041, NULL, 4, 2, '2026-04-09 13:07:00', 'Đã thanh toán', 'Đơn realistic #1041'),
(1042, 1, 12, 2, '2026-04-09 17:20:00', 'Đã thanh toán', 'Đơn realistic #1042'),
(1043, 26, 2, NULL, '2026-04-09 16:46:00', 'Đã thanh toán', 'Đơn realistic #1043'),
(1044, 6, 3, 5, '2026-04-09 16:58:00', 'Đã thanh toán', 'Đơn realistic #1044'),
(1045, NULL, 4, NULL, '2026-04-09 17:37:00', 'Đã thanh toán', 'Đơn realistic #1045'),
(1046, NULL, 2, NULL, '2026-04-09 16:21:00', 'Đã thanh toán', 'Đơn realistic #1046'),
(1047, NULL, 8, 2, '2026-04-09 21:36:00', 'Đã thanh toán', 'Đơn realistic #1047'),
(1048, NULL, 8, NULL, '2026-04-09 20:13:00', 'Đã thanh toán', 'Đơn realistic #1048'),
(1049, NULL, 4, NULL, '2026-04-09 20:13:00', 'Đã thanh toán', 'Đơn realistic #1049'),
(1050, NULL, 4, NULL, '2026-04-09 20:05:00', 'Đã thanh toán', 'Đơn realistic #1050'),
(1051, NULL, 12, NULL, '2026-04-09 19:56:00', 'Đã thanh toán', 'Đơn realistic #1051'),
(1052, 21, 2, 2, '2026-04-09 08:28:00', 'Đã thanh toán', 'Đơn realistic #1052'),
(1053, 29, 4, NULL, '2026-04-09 07:38:00', 'Đã thanh toán', 'Đơn realistic #1053'),
(1054, 1, 4, NULL, '2026-04-09 10:18:00', 'Đã thanh toán', 'Đơn realistic #1054'),
(1055, 1, 8, NULL, '2026-04-09 10:07:00', 'Đã thanh toán', 'Đơn realistic #1055'),
(1056, NULL, 8, NULL, '2026-04-09 09:36:00', 'Đã thanh toán', 'Đơn realistic #1056'),
(1057, 26, 4, NULL, '2026-04-09 09:23:00', 'Đã thanh toán', 'Đơn realistic #1057'),
(1058, 15, 3, NULL, '2026-04-09 10:21:00', 'Đã thanh toán', 'Đơn realistic #1058'),
(1059, NULL, 3, NULL, '2026-04-09 10:40:00', 'Đã thanh toán', 'Đơn realistic #1059'),
(1060, 17, 2, NULL, '2026-04-09 14:48:00', 'Đã thanh toán', 'Đơn realistic #1060'),
(1061, 29, 4, NULL, '2026-04-09 13:55:00', 'Đã thanh toán', 'Đơn realistic #1061'),
(1062, 11, 8, NULL, '2026-04-09 17:49:00', 'Đã thanh toán', 'Đơn realistic #1062'),
(1063, 34, 4, NULL, '2026-04-09 17:18:00', 'Đã thanh toán', 'Đơn realistic #1063'),
(1064, 29, 3, NULL, '2026-04-09 17:22:00', 'Đã thanh toán', 'Đơn realistic #1064'),
(1065, NULL, 4, NULL, '2026-04-09 15:38:00', 'Đã thanh toán', 'Đơn realistic #1065'),
(1066, NULL, 3, NULL, '2026-04-09 16:56:00', 'Đã thanh toán', 'Đơn realistic #1066'),
(1067, NULL, 4, NULL, '2026-04-09 17:15:00', 'Đã thanh toán', 'Đơn realistic #1067'),
(1068, NULL, 3, 2, '2026-04-09 15:53:00', 'Đã thanh toán', 'Đơn realistic #1068'),
(1069, NULL, 4, NULL, '2026-04-09 17:41:00', 'Đã thanh toán', 'Đơn realistic #1069'),
(1070, NULL, 2, NULL, '2026-04-09 19:39:00', 'Đã thanh toán', 'Đơn realistic #1070'),
(1071, 5, 12, NULL, '2026-04-09 21:04:00', 'Đã thanh toán', 'Đơn realistic #1071'),
(1072, NULL, 3, NULL, '2026-04-09 21:13:00', 'Đã thanh toán', 'Đơn realistic #1072'),
(1073, 23, 8, 4, '2026-04-09 20:49:00', 'Đã thanh toán', 'Đơn realistic #1073'),
(1074, 2, 8, 2, '2026-04-09 19:08:00', 'Đã thanh toán', 'Đơn realistic #1074'),
(1075, 21, 12, NULL, '2026-04-10 08:32:00', 'Đã thanh toán', 'Đơn realistic #1075'),
(1076, 11, 3, NULL, '2026-04-10 08:23:00', 'Đã thanh toán', 'Đơn realistic #1076'),
(1077, NULL, 3, NULL, '2026-04-10 07:53:00', 'Đã thanh toán', 'Đơn realistic #1077'),
(1078, NULL, 8, NULL, '2026-04-10 07:38:00', 'Đã thanh toán', 'Đơn realistic #1078'),
(1079, 16, 12, NULL, '2026-04-10 11:26:00', 'Đã thanh toán', 'Đơn realistic #1079'),
(1080, 32, 4, NULL, '2026-04-10 09:21:00', 'Đã thanh toán', 'Đơn realistic #1080'),
(1081, 37, 2, NULL, '2026-04-10 10:16:00', 'Đã thanh toán', 'Đơn realistic #1081'),
(1082, NULL, 2, NULL, '2026-04-10 11:33:00', 'Đã thanh toán', 'Đơn realistic #1082'),
(1083, NULL, 3, NULL, '2026-04-10 10:24:00', 'Đã thanh toán', 'Đơn realistic #1083'),
(1084, 39, 2, NULL, '2026-04-10 10:13:00', 'Đã thanh toán', 'Đơn realistic #1084'),
(1085, NULL, 2, NULL, '2026-04-10 13:50:00', 'Đã thanh toán', 'Đơn realistic #1085'),
(1086, NULL, 12, NULL, '2026-04-10 14:44:00', 'Đã thanh toán', 'Đơn realistic #1086'),
(1087, 22, 4, NULL, '2026-04-10 13:09:00', 'Đã thanh toán', 'Đơn realistic #1087'),
(1088, NULL, 8, NULL, '2026-04-10 13:28:00', 'Đã thanh toán', 'Đơn realistic #1088'),
(1089, 35, 4, NULL, '2026-04-10 13:09:00', 'Đã thanh toán', 'Đơn realistic #1089'),
(1090, 13, 4, 2, '2026-04-10 18:23:00', 'Đã thanh toán', 'Đơn realistic #1090'),
(1091, NULL, 4, NULL, '2026-04-10 15:52:00', 'Đã thanh toán', 'Đơn realistic #1091'),
(1092, NULL, 4, NULL, '2026-04-10 17:07:00', 'Đã thanh toán', 'Đơn realistic #1092'),
(1093, 11, 8, NULL, '2026-04-10 16:54:00', 'Đã thanh toán', 'Đơn realistic #1093'),
(1094, 37, 3, NULL, '2026-04-10 16:12:00', 'Đã thanh toán', 'Đơn realistic #1094'),
(1095, 26, 2, NULL, '2026-04-10 17:51:00', 'Đã thanh toán', 'Đơn realistic #1095'),
(1096, NULL, 2, NULL, '2026-04-10 17:33:00', 'Đã thanh toán', 'Đơn realistic #1096'),
(1097, 6, 3, 5, '2026-04-10 19:34:00', 'Đã thanh toán', 'Đơn realistic #1097'),
(1098, 11, 8, 4, '2026-04-10 20:06:00', 'Đã thanh toán', 'Đơn realistic #1098'),
(1099, NULL, 12, 4, '2026-04-10 19:35:00', 'Đã thanh toán', 'Đơn realistic #1099'),
(1100, 28, 12, NULL, '2026-04-10 19:37:00', 'Đã thanh toán', 'Đơn realistic #1100'),
(1101, 5, 8, NULL, '2026-04-10 21:21:00', 'Đã thanh toán', 'Đơn realistic #1101'),
(1102, 1, 3, NULL, '2026-04-10 09:14:00', 'Đã thanh toán', 'Đơn realistic #1102'),
(1103, 37, 12, NULL, '2026-04-10 09:03:00', 'Đã thanh toán', 'Đơn realistic #1103'),
(1104, 32, 4, NULL, '2026-04-10 09:12:00', 'Đã thanh toán', 'Đơn realistic #1104'),
(1105, NULL, 2, 2, '2026-04-10 10:37:00', 'Đã thanh toán', 'Đơn realistic #1105'),
(1106, 25, 3, NULL, '2026-04-10 12:10:00', 'Đã thanh toán', 'Đơn realistic #1106'),
(1107, 32, 2, NULL, '2026-04-10 10:48:00', 'Đã thanh toán', 'Đơn realistic #1107'),
(1108, 2, 4, NULL, '2026-04-10 15:00:00', 'Đã thanh toán', 'Đơn realistic #1108'),
(1109, 34, 12, 2, '2026-04-10 14:11:00', 'Đã thanh toán', 'Đơn realistic #1109'),
(1110, 39, 2, 2, '2026-04-10 14:46:00', 'Đã thanh toán', 'Đơn realistic #1110'),
(1111, 20, 12, 2, '2026-04-10 15:43:00', 'Đã thanh toán', 'Đơn realistic #1111'),
(1112, 9, 12, NULL, '2026-04-10 14:53:00', 'Đã thanh toán', 'Đơn realistic #1112'),
(1113, NULL, 12, NULL, '2026-04-10 18:21:00', 'Đã thanh toán', 'Đơn realistic #1113'),
(1114, 1, 4, NULL, '2026-04-10 19:05:00', 'Đã thanh toán', 'Đơn realistic #1114'),
(1115, NULL, 3, NULL, '2026-04-10 17:44:00', 'Đã thanh toán', 'Đơn realistic #1115'),
(1116, 39, 2, NULL, '2026-04-10 17:42:00', 'Đã thanh toán', 'Đơn realistic #1116'),
(1117, NULL, 3, NULL, '2026-04-10 16:55:00', 'Đã thanh toán', 'Đơn realistic #1117'),
(1118, 14, 8, NULL, '2026-04-10 17:30:00', 'Đã thanh toán', 'Đơn realistic #1118'),
(1119, NULL, 4, 5, '2026-04-10 18:05:00', 'Đã thanh toán', 'Đơn realistic #1119'),
(1120, NULL, 4, NULL, '2026-04-10 17:55:00', 'Đã thanh toán', 'Đơn realistic #1120'),
(1121, 9, 8, NULL, '2026-04-10 20:02:00', 'Đã thanh toán', 'Đơn realistic #1121'),
(1122, 18, 3, NULL, '2026-04-10 21:41:00', 'Đã thanh toán', 'Đơn realistic #1122'),
(1123, 36, 8, NULL, '2026-04-10 22:10:00', 'Đã thanh toán', 'Đơn realistic #1123'),
(1124, NULL, 3, 2, '2026-04-10 19:34:00', 'Đã thanh toán', 'Đơn realistic #1124'),
(1125, 12, 4, 2, '2026-04-10 20:48:00', 'Đã thanh toán', 'Đơn realistic #1125'),
(1126, NULL, 2, NULL, '2026-04-10 21:45:00', 'Đã thanh toán', 'Đơn realistic #1126'),
(1127, NULL, 3, 2, '2026-04-10 19:46:00', 'Đã thanh toán', 'Đơn realistic #1127'),
(1128, 16, 3, 3, '2026-04-10 19:52:00', 'Đã thanh toán', 'Đơn realistic #1128'),
(1129, NULL, 2, NULL, '2026-04-10 21:20:00', 'Đã thanh toán', 'Đơn realistic #1129'),
(1130, 7, 2, NULL, '2026-04-10 09:22:00', 'Đã thanh toán', 'Đơn realistic #1130'),
(1131, 7, 2, NULL, '2026-04-10 09:42:00', 'Đã thanh toán', 'Đơn realistic #1131'),
(1132, NULL, 3, NULL, '2026-04-10 09:41:00', 'Đã thanh toán', 'Đơn realistic #1132'),
(1133, 36, 3, NULL, '2026-04-10 12:27:00', 'Đã thanh toán', 'Đơn realistic #1133'),
(1134, 29, 4, NULL, '2026-04-10 12:30:00', 'Đã thanh toán', 'Đơn realistic #1134'),
(1135, 37, 3, NULL, '2026-04-10 13:00:00', 'Đã thanh toán', 'Đơn realistic #1135'),
(1136, 33, 12, NULL, '2026-04-10 12:13:00', 'Đã thanh toán', 'Đơn realistic #1136'),
(1137, NULL, 8, NULL, '2026-04-10 12:18:00', 'Đã thanh toán', 'Đơn realistic #1137'),
(1138, 6, 12, NULL, '2026-04-10 10:57:00', 'Đã thanh toán', 'Đơn realistic #1138'),
(1139, NULL, 12, NULL, '2026-04-10 12:50:00', 'Đã thanh toán', 'Đơn realistic #1139'),
(1140, NULL, 8, NULL, '2026-04-10 14:55:00', 'Đã thanh toán', 'Đơn realistic #1140'),
(1141, NULL, 4, NULL, '2026-04-10 15:12:00', 'Đã thanh toán', 'Đơn realistic #1141'),
(1142, NULL, 12, NULL, '2026-04-10 15:51:00', 'Đã thanh toán', 'Đơn realistic #1142'),
(1143, 28, 2, NULL, '2026-04-10 16:20:00', 'Đã thanh toán', 'Đơn realistic #1143'),
(1144, 32, 2, NULL, '2026-04-10 15:55:00', 'Đã thanh toán', 'Đơn realistic #1144'),
(1145, 11, 3, NULL, '2026-04-10 20:02:00', 'Đã thanh toán', 'Đơn realistic #1145'),
(1146, NULL, 12, NULL, '2026-04-10 18:15:00', 'Đã thanh toán', 'Đơn realistic #1146'),
(1147, 2, 2, NULL, '2026-04-10 19:31:00', 'Đã thanh toán', 'Đơn realistic #1147'),
(1148, 8, 2, 5, '2026-04-10 19:46:00', 'Đã thanh toán', 'Đơn realistic #1148'),
(1149, NULL, 3, NULL, '2026-04-10 19:41:00', 'Đã thanh toán', 'Đơn realistic #1149'),
(1150, 7, 4, 3, '2026-04-10 10:25:00', 'Đã thanh toán', 'Đơn realistic #1150'),
(1151, 15, 4, NULL, '2026-04-10 09:41:00', 'Đã thanh toán', 'Đơn realistic #1151'),
(1152, 29, 8, NULL, '2026-04-10 09:57:00', 'Đã thanh toán', 'Đơn realistic #1152'),
(1153, NULL, 2, NULL, '2026-04-10 10:21:00', 'Đã thanh toán', 'Đơn realistic #1153'),
(1154, 13, 4, NULL, '2026-04-10 13:33:00', 'Đã thanh toán', 'Đơn realistic #1154'),
(1155, 38, 12, NULL, '2026-04-10 13:45:00', 'Đã thanh toán', 'Đơn realistic #1155'),
(1156, 34, 4, NULL, '2026-04-10 13:56:00', 'Đã thanh toán', 'Đơn realistic #1156'),
(1157, 5, 4, NULL, '2026-04-10 12:25:00', 'Đã thanh toán', 'Đơn realistic #1157'),
(1158, NULL, 8, NULL, '2026-04-10 13:51:00', 'Đã thanh toán', 'Đơn realistic #1158'),
(1159, 14, 12, 2, '2026-04-10 18:06:00', 'Đã thanh toán', 'Đơn realistic #1159'),
(1160, 33, 3, 5, '2026-04-10 17:04:00', 'Đã thanh toán', 'Đơn realistic #1160'),
(1161, 32, 2, NULL, '2026-04-10 17:21:00', 'Đã thanh toán', 'Đơn realistic #1161'),
(1162, 32, 3, NULL, '2026-04-10 18:00:00', 'Đã thanh toán', 'Đơn realistic #1162'),
(1163, NULL, 2, NULL, '2026-04-10 17:21:00', 'Đã thanh toán', 'Đơn realistic #1163'),
(1164, NULL, 3, 2, '2026-04-10 19:33:00', 'Đã thanh toán', 'Đơn realistic #1164'),
(1165, NULL, 2, NULL, '2026-04-10 20:35:00', 'Đã thanh toán', 'Đơn realistic #1165'),
(1166, 16, 3, 2, '2026-04-10 19:17:00', 'Đã thanh toán', 'Đơn realistic #1166'),
(1167, NULL, 4, 2, '2026-04-10 20:41:00', 'Đã thanh toán', 'Đơn realistic #1167'),
(1168, NULL, 3, 4, '2026-04-10 21:47:00', 'Đã thanh toán', 'Đơn realistic #1168'),
(1169, 35, 8, 3, '2026-04-10 21:15:00', 'Đã thanh toán', 'Đơn realistic #1169'),
(1170, 40, 12, 4, '2026-04-10 20:22:00', 'Đã thanh toán', 'Đơn realistic #1170'),
(1171, 33, 2, 2, '2026-04-10 07:43:00', 'Đã thanh toán', 'Đơn realistic #1171'),
(1172, 22, 3, 2, '2026-04-10 07:25:00', 'Đã thanh toán', 'Đơn realistic #1172'),
(1173, 13, 2, NULL, '2026-04-10 07:26:00', 'Đã thanh toán', 'Đơn realistic #1173'),
(1174, 28, 8, NULL, '2026-04-10 11:33:00', 'Đã thanh toán', 'Đơn realistic #1174'),
(1175, 30, 3, NULL, '2026-04-10 11:07:00', 'Đã thanh toán', 'Đơn realistic #1175'),
(1176, 14, 4, NULL, '2026-04-10 10:46:00', 'Đã thanh toán', 'Đơn realistic #1176'),
(1177, NULL, 12, NULL, '2026-04-10 13:13:00', 'Đã thanh toán', 'Đơn realistic #1177'),
(1178, 4, 8, NULL, '2026-04-10 12:27:00', 'Đã thanh toán', 'Đơn realistic #1178'),
(1179, 33, 2, 2, '2026-04-10 12:22:00', 'Đã thanh toán', 'Đơn realistic #1179'),
(1180, NULL, 2, NULL, '2026-04-10 13:17:00', 'Đã thanh toán', 'Đơn realistic #1180'),
(1181, 29, 3, NULL, '2026-04-10 13:33:00', 'Đã thanh toán', 'Đơn realistic #1181'),
(1182, 14, 12, 2, '2026-04-10 16:38:00', 'Đã thanh toán', 'Đơn realistic #1182'),
(1183, 28, 8, NULL, '2026-04-10 17:35:00', 'Đã thanh toán', 'Đơn realistic #1183'),
(1184, NULL, 8, NULL, '2026-04-10 17:43:00', 'Đã thanh toán', 'Đơn realistic #1184'),
(1185, 31, 2, NULL, '2026-04-10 16:29:00', 'Đã thanh toán', 'Đơn realistic #1185'),
(1186, 29, 3, NULL, '2026-04-10 16:44:00', 'Đã thanh toán', 'Đơn realistic #1186'),
(1187, 7, 12, NULL, '2026-04-10 19:49:00', 'Đã thanh toán', 'Đơn realistic #1187'),
(1188, 23, 12, NULL, '2026-04-10 19:51:00', 'Đã thanh toán', 'Đơn realistic #1188'),
(1189, 5, 3, NULL, '2026-04-10 20:38:00', 'Đã thanh toán', 'Đơn realistic #1189'),
(1190, NULL, 4, 2, '2026-04-10 21:04:00', 'Đã thanh toán', 'Đơn realistic #1190'),
(1191, 11, 8, NULL, '2026-04-10 19:33:00', 'Đã thanh toán', 'Đơn realistic #1191'),
(1192, 16, 4, NULL, '2026-04-10 21:17:00', 'Đã thanh toán', 'Đơn realistic #1192'),
(1193, NULL, 12, NULL, '2026-04-10 19:55:00', 'Đã thanh toán', 'Đơn realistic #1193'),
(1194, NULL, 4, NULL, '2026-04-10 19:40:00', 'Đã thanh toán', 'Đơn realistic #1194'),
(1195, 19, 2, NULL, '2026-04-11 07:35:00', 'Đã thanh toán', 'Đơn realistic #1195'),
(1196, 9, 8, 2, '2026-04-11 07:42:00', 'Đã thanh toán', 'Đơn realistic #1196'),
(1197, 28, 2, NULL, '2026-04-11 07:52:00', 'Đã thanh toán', 'Đơn realistic #1197'),
(1198, 2, 12, NULL, '2026-04-11 07:37:00', 'Đã thanh toán', 'Đơn realistic #1198'),
(1199, NULL, 3, NULL, '2026-04-11 07:43:00', 'Đã thanh toán', 'Đơn realistic #1199'),
(1200, 18, 8, NULL, '2026-04-11 08:24:00', 'Đã thanh toán', 'Đơn realistic #1200'),
(1201, NULL, 3, 2, '2026-04-11 10:12:00', 'Đã thanh toán', 'Đơn realistic #1201'),
(1202, 18, 2, NULL, '2026-04-11 11:30:00', 'Đã thanh toán', 'Đơn realistic #1202'),
(1203, 17, 8, NULL, '2026-04-11 10:24:00', 'Đã thanh toán', 'Đơn realistic #1203'),
(1204, 35, 3, NULL, '2026-04-11 09:18:00', 'Đã thanh toán', 'Đơn realistic #1204'),
(1205, NULL, 4, NULL, '2026-04-11 10:38:00', 'Đã thanh toán', 'Đơn realistic #1205'),
(1206, 1, 3, 2, '2026-04-11 10:39:00', 'Đã thanh toán', 'Đơn realistic #1206'),
(1207, 13, 4, NULL, '2026-04-11 09:56:00', 'Đã thanh toán', 'Đơn realistic #1207'),
(1208, 11, 3, NULL, '2026-04-11 14:19:00', 'Đã thanh toán', 'Đơn realistic #1208'),
(1209, 7, 8, NULL, '2026-04-11 13:04:00', 'Đã thanh toán', 'Đơn realistic #1209'),
(1210, 39, 3, 1, '2026-04-11 14:45:00', 'Đã thanh toán', 'Đơn realistic #1210'),
(1211, NULL, 2, NULL, '2026-04-11 14:15:00', 'Đã thanh toán', 'Đơn realistic #1211'),
(1212, NULL, 4, 2, '2026-04-11 14:23:00', 'Đã thanh toán', 'Đơn realistic #1212'),
(1213, NULL, 3, NULL, '2026-04-11 13:23:00', 'Đã thanh toán', 'Đơn realistic #1213'),
(1214, 20, 2, NULL, '2026-04-11 12:41:00', 'Đã thanh toán', 'Đơn realistic #1214'),
(1215, 40, 4, NULL, '2026-04-11 12:44:00', 'Đã thanh toán', 'Đơn realistic #1215'),
(1216, NULL, 4, 2, '2026-04-11 15:57:00', 'Đã thanh toán', 'Đơn realistic #1216'),
(1217, 4, 3, 2, '2026-04-11 17:54:00', 'Đã thanh toán', 'Đơn realistic #1217'),
(1218, 7, 2, NULL, '2026-04-11 16:47:00', 'Đã thanh toán', 'Đơn realistic #1218'),
(1219, NULL, 4, NULL, '2026-04-11 17:20:00', 'Đã thanh toán', 'Đơn realistic #1219'),
(1220, 22, 2, 5, '2026-04-11 17:00:00', 'Đã thanh toán', 'Đơn realistic #1220'),
(1221, 18, 12, NULL, '2026-04-11 18:19:00', 'Đã thanh toán', 'Đơn realistic #1221'),
(1222, 26, 12, NULL, '2026-04-11 19:06:00', 'Đã thanh toán', 'Đơn realistic #1222'),
(1223, NULL, 8, NULL, '2026-04-11 19:18:00', 'Đã thanh toán', 'Đơn realistic #1223'),
(1224, 6, 3, NULL, '2026-04-11 21:37:00', 'Đã thanh toán', 'Đơn realistic #1224'),
(1225, 10, 8, 2, '2026-04-11 21:11:00', 'Đã thanh toán', 'Đơn realistic #1225'),
(1226, NULL, 12, 4, '2026-04-11 21:26:00', 'Đã thanh toán', 'Đơn realistic #1226'),
(1227, 25, 8, 4, '2026-04-11 20:59:00', 'Đã thanh toán', 'Đơn realistic #1227'),
(1228, 35, 8, NULL, '2026-04-11 19:23:00', 'Đã thanh toán', 'Đơn realistic #1228'),
(1229, 36, 12, NULL, '2026-04-11 21:38:00', 'Đã thanh toán', 'Đơn realistic #1229'),
(1230, NULL, 12, 2, '2026-04-11 20:53:00', 'Đã thanh toán', 'Đơn realistic #1230'),
(1231, 15, 8, NULL, '2026-04-11 21:08:00', 'Đã thanh toán', 'Đơn realistic #1231'),
(1232, 30, 3, NULL, '2026-04-11 20:31:00', 'Đã thanh toán', 'Đơn realistic #1232'),
(1233, 22, 3, NULL, '2026-04-11 21:27:00', 'Đã thanh toán', 'Đơn realistic #1233'),
(1234, 19, 12, NULL, '2026-04-11 08:33:00', 'Đã thanh toán', 'Đơn realistic #1234'),
(1235, 17, 3, NULL, '2026-04-11 08:49:00', 'Đã thanh toán', 'Đơn realistic #1235'),
(1236, 1, 3, NULL, '2026-04-11 08:37:00', 'Đã thanh toán', 'Đơn realistic #1236'),
(1237, NULL, 8, NULL, '2026-04-11 08:34:00', 'Đã thanh toán', 'Đơn realistic #1237'),
(1238, NULL, 2, NULL, '2026-04-11 08:28:00', 'Đã thanh toán', 'Đơn realistic #1238'),
(1239, 30, 12, 2, '2026-04-11 11:16:00', 'Đã thanh toán', 'Đơn realistic #1239'),
(1240, NULL, 8, NULL, '2026-04-11 12:30:00', 'Đã thanh toán', 'Đơn realistic #1240'),
(1241, NULL, 8, NULL, '2026-04-11 11:20:00', 'Đã thanh toán', 'Đơn realistic #1241'),
(1242, NULL, 12, 2, '2026-04-11 11:18:00', 'Đã thanh toán', 'Đơn realistic #1242'),
(1243, 5, 12, NULL, '2026-04-11 11:02:00', 'Đã thanh toán', 'Đơn realistic #1243'),
(1244, 33, 8, NULL, '2026-04-11 14:10:00', 'Đã thanh toán', 'Đơn realistic #1244'),
(1245, 8, 4, 1, '2026-04-11 15:04:00', 'Đã thanh toán', 'Đơn realistic #1245'),
(1246, 37, 3, NULL, '2026-04-11 14:32:00', 'Đã thanh toán', 'Đơn realistic #1246'),
(1247, 8, 3, 3, '2026-04-11 13:53:00', 'Đã thanh toán', 'Đơn realistic #1247'),
(1248, NULL, 8, NULL, '2026-04-11 15:33:00', 'Đã thanh toán', 'Đơn realistic #1248'),
(1249, 32, 8, NULL, '2026-04-11 13:56:00', 'Đã thanh toán', 'Đơn realistic #1249'),
(1250, 16, 12, NULL, '2026-04-11 13:47:00', 'Đã thanh toán', 'Đơn realistic #1250'),
(1251, 18, 2, NULL, '2026-04-11 16:40:00', 'Đã thanh toán', 'Đơn realistic #1251'),
(1252, NULL, 12, 1, '2026-04-11 18:52:00', 'Đã thanh toán', 'Đơn realistic #1252'),
(1253, 20, 2, NULL, '2026-04-11 17:03:00', 'Đã thanh toán', 'Đơn realistic #1253'),
(1254, NULL, 8, NULL, '2026-04-11 16:35:00', 'Đã thanh toán', 'Đơn realistic #1254'),
(1255, NULL, 8, NULL, '2026-04-11 16:56:00', 'Đã thanh toán', 'Đơn realistic #1255'),
(1256, 24, 2, NULL, '2026-04-11 18:16:00', 'Đã thanh toán', 'Đơn realistic #1256'),
(1257, NULL, 8, NULL, '2026-04-11 16:47:00', 'Đã thanh toán', 'Đơn realistic #1257'),
(1258, NULL, 4, NULL, '2026-04-11 17:31:00', 'Đã thanh toán', 'Đơn realistic #1258'),
(1259, 37, 12, 1, '2026-04-11 17:39:00', 'Đã thanh toán', 'Đơn realistic #1259'),
(1260, 25, 8, NULL, '2026-04-11 18:58:00', 'Đã thanh toán', 'Đơn realistic #1260'),
(1261, NULL, 4, NULL, '2026-04-11 20:16:00', 'Đã thanh toán', 'Đơn realistic #1261'),
(1262, 6, 2, 5, '2026-04-11 21:05:00', 'Đã thanh toán', 'Đơn realistic #1262'),
(1263, 36, 2, NULL, '2026-04-11 21:42:00', 'Đã thanh toán', 'Đơn realistic #1263'),
(1264, NULL, 8, 2, '2026-04-11 21:49:00', 'Đã thanh toán', 'Đơn realistic #1264'),
(1265, 5, 2, 4, '2026-04-11 21:48:00', 'Đã thanh toán', 'Đơn realistic #1265'),
(1266, NULL, 2, NULL, '2026-04-11 20:28:00', 'Đã thanh toán', 'Đơn realistic #1266'),
(1267, 12, 12, 4, '2026-04-11 21:44:00', 'Đã thanh toán', 'Đơn realistic #1267'),
(1268, NULL, 3, NULL, '2026-04-11 20:05:00', 'Đã thanh toán', 'Đơn realistic #1268'),
(1269, 16, 8, NULL, '2026-04-11 20:20:00', 'Đã thanh toán', 'Đơn realistic #1269'),
(1270, NULL, 4, NULL, '2026-04-11 22:05:00', 'Đã thanh toán', 'Đơn realistic #1270'),
(1271, 39, 3, 2, '2026-04-11 08:53:00', 'Đã thanh toán', 'Đơn realistic #1271'),
(1272, 22, 4, NULL, '2026-04-11 09:13:00', 'Đã thanh toán', 'Đơn realistic #1272'),
(1273, 35, 4, 3, '2026-04-11 08:51:00', 'Đã thanh toán', 'Đơn realistic #1273'),
(1274, 9, 8, NULL, '2026-04-11 09:31:00', 'Đã thanh toán', 'Đơn realistic #1274'),
(1275, NULL, 2, NULL, '2026-04-11 09:30:00', 'Đã thanh toán', 'Đơn realistic #1275'),
(1276, 5, 8, NULL, '2026-04-11 12:31:00', 'Đã thanh toán', 'Đơn realistic #1276'),
(1277, 18, 4, 2, '2026-04-11 12:59:00', 'Đã thanh toán', 'Đơn realistic #1277'),
(1278, 11, 2, 1, '2026-04-11 12:53:00', 'Đã thanh toán', 'Đơn realistic #1278'),
(1279, 30, 12, NULL, '2026-04-11 12:18:00', 'Đã thanh toán', 'Đơn realistic #1279'),
(1280, 8, 2, 2, '2026-04-11 14:32:00', 'Đã thanh toán', 'Đơn realistic #1280'),
(1281, NULL, 4, NULL, '2026-04-11 14:56:00', 'Đã thanh toán', 'Đơn realistic #1281'),
(1282, NULL, 12, NULL, '2026-04-11 14:33:00', 'Đã thanh toán', 'Đơn realistic #1282'),
(1283, 5, 4, 1, '2026-04-11 14:41:00', 'Đã thanh toán', 'Đơn realistic #1283'),
(1284, NULL, 3, NULL, '2026-04-11 15:00:00', 'Đã thanh toán', 'Đơn realistic #1284'),
(1285, 39, 12, NULL, '2026-04-11 18:32:00', 'Đã thanh toán', 'Đơn realistic #1285'),
(1286, NULL, 12, 2, '2026-04-11 19:29:00', 'Đã thanh toán', 'Đơn realistic #1286'),
(1287, 19, 4, 2, '2026-04-11 19:28:00', 'Đã thanh toán', 'Đơn realistic #1287'),
(1288, NULL, 12, NULL, '2026-04-11 19:42:00', 'Đã thanh toán', 'Đơn realistic #1288'),
(1289, 2, 12, NULL, '2026-04-11 19:01:00', 'Đã thanh toán', 'Đơn realistic #1289'),
(1290, 5, 8, NULL, '2026-04-11 18:10:00', 'Đã thanh toán', 'Đơn realistic #1290'),
(1291, 33, 12, NULL, '2026-04-11 19:36:00', 'Đã thanh toán', 'Đơn realistic #1291'),
(1292, 18, 8, 1, '2026-04-11 19:17:00', 'Đã thanh toán', 'Đơn realistic #1292'),
(1293, 31, 8, NULL, '2026-04-11 18:35:00', 'Đã thanh toán', 'Đơn realistic #1293'),
(1294, 2, 4, NULL, '2026-04-11 10:06:00', 'Đã thanh toán', 'Đơn realistic #1294'),
(1295, 5, 3, 2, '2026-04-11 09:45:00', 'Đã thanh toán', 'Đơn realistic #1295'),
(1296, NULL, 3, NULL, '2026-04-11 10:14:00', 'Đã thanh toán', 'Đơn realistic #1296'),
(1297, 25, 12, NULL, '2026-04-11 10:01:00', 'Đã thanh toán', 'Đơn realistic #1297'),
(1298, 23, 8, NULL, '2026-04-11 09:45:00', 'Đã thanh toán', 'Đơn realistic #1298'),
(1299, NULL, 8, NULL, '2026-04-11 09:52:00', 'Đã thanh toán', 'Đơn realistic #1299'),
(1300, 2, 3, NULL, '2026-04-11 12:28:00', 'Đã thanh toán', 'Đơn realistic #1300'),
(1301, 1, 2, NULL, '2026-04-11 12:21:00', 'Đã thanh toán', 'Đơn realistic #1301'),
(1302, NULL, 12, NULL, '2026-04-11 12:07:00', 'Đã thanh toán', 'Đơn realistic #1302'),
(1303, 31, 8, NULL, '2026-04-11 14:13:00', 'Đã thanh toán', 'Đơn realistic #1303'),
(1304, 36, 2, NULL, '2026-04-11 12:14:00', 'Đã thanh toán', 'Đơn realistic #1304'),
(1305, NULL, 3, NULL, '2026-04-11 17:11:00', 'Đã thanh toán', 'Đơn realistic #1305'),
(1306, NULL, 4, NULL, '2026-04-11 16:16:00', 'Đã thanh toán', 'Đơn realistic #1306'),
(1307, 6, 12, 2, '2026-04-11 17:19:00', 'Đã thanh toán', 'Đơn realistic #1307'),
(1308, 36, 8, 2, '2026-04-11 16:53:00', 'Đã thanh toán', 'Đơn realistic #1308'),
(1309, NULL, 4, NULL, '2026-04-11 16:10:00', 'Đã thanh toán', 'Đơn realistic #1309'),
(1310, 4, 4, NULL, '2026-04-11 19:36:00', 'Đã thanh toán', 'Đơn realistic #1310'),
(1311, 8, 12, NULL, '2026-04-11 20:41:00', 'Đã thanh toán', 'Đơn realistic #1311'),
(1312, NULL, 8, NULL, '2026-04-11 20:11:00', 'Đã thanh toán', 'Đơn realistic #1312'),
(1313, NULL, 12, NULL, '2026-04-11 19:28:00', 'Đã thanh toán', 'Đơn realistic #1313'),
(1314, 21, 8, NULL, '2026-04-11 20:59:00', 'Đã thanh toán', 'Đơn realistic #1314'),
(1315, NULL, 12, 5, '2026-04-11 20:53:00', 'Đã thanh toán', 'Đơn realistic #1315'),
(1316, 40, 4, NULL, '2026-04-11 21:54:00', 'Đã thanh toán', 'Đơn realistic #1316'),
(1317, NULL, 12, 1, '2026-04-11 20:33:00', 'Đã thanh toán', 'Đơn realistic #1317'),
(1318, 36, 2, 4, '2026-04-11 21:13:00', 'Đã thanh toán', 'Đơn realistic #1318'),
(1319, NULL, 8, 1, '2026-04-11 08:24:00', 'Đã thanh toán', 'Đơn realistic #1319'),
(1320, 25, 12, NULL, '2026-04-11 08:03:00', 'Đã thanh toán', 'Đơn realistic #1320'),
(1321, NULL, 2, NULL, '2026-04-11 09:19:00', 'Đã thanh toán', 'Đơn realistic #1321'),
(1322, NULL, 2, NULL, '2026-04-11 09:39:00', 'Đã thanh toán', 'Đơn realistic #1322'),
(1323, NULL, 12, NULL, '2026-04-11 10:40:00', 'Đã thanh toán', 'Đơn realistic #1323'),
(1324, NULL, 3, NULL, '2026-04-11 09:53:00', 'Đã thanh toán', 'Đơn realistic #1324'),
(1325, 25, 4, NULL, '2026-04-11 10:52:00', 'Đã thanh toán', 'Đơn realistic #1325'),
(1326, 9, 12, 1, '2026-04-11 13:32:00', 'Đã thanh toán', 'Đơn realistic #1326'),
(1327, 6, 2, NULL, '2026-04-11 13:32:00', 'Đã thanh toán', 'Đơn realistic #1327'),
(1328, NULL, 8, NULL, '2026-04-11 13:23:00', 'Đã thanh toán', 'Đơn realistic #1328'),
(1329, 9, 8, NULL, '2026-04-11 14:51:00', 'Đã thanh toán', 'Đơn realistic #1329'),
(1330, 37, 8, NULL, '2026-04-11 14:28:00', 'Đã thanh toán', 'Đơn realistic #1330'),
(1331, 40, 8, NULL, '2026-04-11 13:34:00', 'Đã thanh toán', 'Đơn realistic #1331'),
(1332, NULL, 12, 1, '2026-04-11 12:50:00', 'Đã thanh toán', 'Đơn realistic #1332'),
(1333, NULL, 4, NULL, '2026-04-11 15:42:00', 'Đã thanh toán', 'Đơn realistic #1333'),
(1334, NULL, 4, NULL, '2026-04-11 17:26:00', 'Đã thanh toán', 'Đơn realistic #1334'),
(1335, 1, 8, 2, '2026-04-11 16:24:00', 'Đã thanh toán', 'Đơn realistic #1335'),
(1336, 7, 8, NULL, '2026-04-11 17:14:00', 'Đã thanh toán', 'Đơn realistic #1336'),
(1337, 19, 3, NULL, '2026-04-11 16:18:00', 'Đã thanh toán', 'Đơn realistic #1337'),
(1338, 1, 12, 2, '2026-04-11 19:31:00', 'Đã thanh toán', 'Đơn realistic #1338'),
(1339, NULL, 12, 4, '2026-04-11 19:08:00', 'Đã thanh toán', 'Đơn realistic #1339'),
(1340, NULL, 12, NULL, '2026-04-11 20:29:00', 'Đã thanh toán', 'Đơn realistic #1340'),
(1341, 27, 4, NULL, '2026-04-11 19:07:00', 'Đã thanh toán', 'Đơn realistic #1341'),
(1342, 16, 3, NULL, '2026-04-11 20:53:00', 'Đã thanh toán', 'Đơn realistic #1342'),
(1343, NULL, 2, 5, '2026-04-11 21:01:00', 'Đã thanh toán', 'Đơn realistic #1343'),
(1344, NULL, 3, NULL, '2026-04-11 20:30:00', 'Đã thanh toán', 'Đơn realistic #1344'),
(1345, 19, 2, NULL, '2026-04-11 18:53:00', 'Đã thanh toán', 'Đơn realistic #1345'),
(1346, NULL, 4, NULL, '2026-04-11 20:06:00', 'Đã thanh toán', 'Đơn realistic #1346'),
(1347, 1, 12, 5, '2026-04-11 19:25:00', 'Đã thanh toán', 'Đơn realistic #1347'),
(1348, 8, 8, NULL, '2026-04-11 20:19:00', 'Đã thanh toán', 'Đơn realistic #1348'),
(1349, 21, 8, NULL, '2026-04-12 08:29:00', 'Đã thanh toán', 'Đơn realistic #1349'),
(1350, 31, 2, NULL, '2026-04-12 07:31:00', 'Đã thanh toán', 'Đơn realistic #1350'),
(1351, 32, 8, NULL, '2026-04-12 07:31:00', 'Đã thanh toán', 'Đơn realistic #1351'),
(1352, NULL, 8, NULL, '2026-04-12 11:19:00', 'Đã thanh toán', 'Đơn realistic #1352'),
(1353, NULL, 8, NULL, '2026-04-12 11:49:00', 'Đã thanh toán', 'Đơn realistic #1353'),
(1354, 5, 12, 5, '2026-04-12 10:47:00', 'Đã thanh toán', 'Đơn realistic #1354'),
(1355, 36, 2, NULL, '2026-04-12 09:55:00', 'Đã thanh toán', 'Đơn realistic #1355'),
(1356, 8, 8, NULL, '2026-04-12 10:20:00', 'Đã thanh toán', 'Đơn realistic #1356'),
(1357, 39, 4, NULL, '2026-04-12 13:17:00', 'Đã thanh toán', 'Đơn realistic #1357'),
(1358, 2, 8, NULL, '2026-04-12 12:50:00', 'Đã thanh toán', 'Đơn realistic #1358'),
(1359, NULL, 2, NULL, '2026-04-12 13:18:00', 'Đã thanh toán', 'Đơn realistic #1359'),
(1360, 16, 2, 2, '2026-04-12 12:42:00', 'Đã thanh toán', 'Đơn realistic #1360'),
(1361, 13, 8, 1, '2026-04-12 17:30:00', 'Đã thanh toán', 'Đơn realistic #1361'),
(1362, 14, 8, NULL, '2026-04-12 17:48:00', 'Đã thanh toán', 'Đơn realistic #1362'),
(1363, 28, 12, NULL, '2026-04-12 17:49:00', 'Đã thanh toán', 'Đơn realistic #1363'),
(1364, 10, 3, 1, '2026-04-12 17:14:00', 'Đã thanh toán', 'Đơn realistic #1364'),
(1365, 12, 3, 1, '2026-04-12 15:57:00', 'Đã thanh toán', 'Đơn realistic #1365'),
(1366, NULL, 8, NULL, '2026-04-12 17:44:00', 'Đã thanh toán', 'Đơn realistic #1366'),
(1367, NULL, 12, NULL, '2026-04-12 15:59:00', 'Đã thanh toán', 'Đơn realistic #1367'),
(1368, 38, 3, NULL, '2026-04-12 17:54:00', 'Đã thanh toán', 'Đơn realistic #1368'),
(1369, 31, 12, NULL, '2026-04-12 16:34:00', 'Đã thanh toán', 'Đơn realistic #1369'),
(1370, 30, 2, NULL, '2026-04-12 17:45:00', 'Đã thanh toán', 'Đơn realistic #1370'),
(1371, 13, 3, NULL, '2026-04-12 16:48:00', 'Đã thanh toán', 'Đơn realistic #1371'),
(1372, 16, 8, 4, '2026-04-12 19:41:00', 'Đã thanh toán', 'Đơn realistic #1372'),
(1373, 35, 4, NULL, '2026-04-12 20:22:00', 'Đã thanh toán', 'Đơn realistic #1373'),
(1374, 14, 4, 4, '2026-04-12 19:02:00', 'Đã thanh toán', 'Đơn realistic #1374'),
(1375, NULL, 3, NULL, '2026-04-12 20:21:00', 'Đã thanh toán', 'Đơn realistic #1375'),
(1376, 1, 3, 5, '2026-04-12 19:39:00', 'Đã thanh toán', 'Đơn realistic #1376'),
(1377, 38, 3, NULL, '2026-04-12 19:56:00', 'Đã thanh toán', 'Đơn realistic #1377'),
(1378, 29, 3, NULL, '2026-04-12 09:06:00', 'Đã thanh toán', 'Đơn realistic #1378'),
(1379, 37, 8, NULL, '2026-04-12 08:39:00', 'Đã thanh toán', 'Đơn realistic #1379'),
(1380, 20, 3, NULL, '2026-04-12 09:01:00', 'Đã thanh toán', 'Đơn realistic #1380'),
(1381, 40, 2, NULL, '2026-04-12 09:20:00', 'Đã thanh toán', 'Đơn realistic #1381'),
(1382, NULL, 4, 1, '2026-04-12 08:36:00', 'Đã thanh toán', 'Đơn realistic #1382'),
(1383, 20, 3, NULL, '2026-04-12 11:51:00', 'Đã thanh toán', 'Đơn realistic #1383'),
(1384, 9, 12, 1, '2026-04-12 10:24:00', 'Đã thanh toán', 'Đơn realistic #1384'),
(1385, 4, 8, NULL, '2026-04-12 10:49:00', 'Đã thanh toán', 'Đơn realistic #1385'),
(1386, NULL, 3, NULL, '2026-04-12 10:40:00', 'Đã thanh toán', 'Đơn realistic #1386'),
(1387, NULL, 3, 2, '2026-04-12 13:17:00', 'Đã thanh toán', 'Đơn realistic #1387'),
(1388, 34, 2, 5, '2026-04-12 14:26:00', 'Đã thanh toán', 'Đơn realistic #1388'),
(1389, NULL, 3, 1, '2026-04-12 15:12:00', 'Đã thanh toán', 'Đơn realistic #1389'),
(1390, 13, 2, NULL, '2026-04-12 13:58:00', 'Đã thanh toán', 'Đơn realistic #1390'),
(1391, 39, 12, NULL, '2026-04-12 14:46:00', 'Đã thanh toán', 'Đơn realistic #1391'),
(1392, 29, 2, NULL, '2026-04-12 17:38:00', 'Đã thanh toán', 'Đơn realistic #1392'),
(1393, 16, 12, 2, '2026-04-12 17:27:00', 'Đã thanh toán', 'Đơn realistic #1393'),
(1394, 19, 12, NULL, '2026-04-12 18:57:00', 'Đã thanh toán', 'Đơn realistic #1394'),
(1395, 39, 8, NULL, '2026-04-12 18:41:00', 'Đã thanh toán', 'Đơn realistic #1395'),
(1396, NULL, 3, NULL, '2026-04-12 16:53:00', 'Đã thanh toán', 'Đơn realistic #1396'),
(1397, NULL, 8, 5, '2026-04-12 18:12:00', 'Đã thanh toán', 'Đơn realistic #1397'),
(1398, NULL, 12, NULL, '2026-04-12 21:31:00', 'Đã thanh toán', 'Đơn realistic #1398'),
(1399, NULL, 8, 1, '2026-04-12 20:21:00', 'Đã thanh toán', 'Đơn realistic #1399'),
(1400, 36, 12, NULL, '2026-04-12 21:34:00', 'Đã thanh toán', 'Đơn realistic #1400'),
(1401, 29, 2, 2, '2026-04-12 21:26:00', 'Đã thanh toán', 'Đơn realistic #1401'),
(1402, 13, 2, NULL, '2026-04-12 19:58:00', 'Đã thanh toán', 'Đơn realistic #1402'),
(1403, NULL, 8, 2, '2026-04-12 22:00:00', 'Đã thanh toán', 'Đơn realistic #1403'),
(1404, 30, 8, NULL, '2026-04-12 19:40:00', 'Đã thanh toán', 'Đơn realistic #1404'),
(1405, 3, 8, NULL, '2026-04-12 19:48:00', 'Đã thanh toán', 'Đơn realistic #1405'),
(1406, 12, 12, NULL, '2026-04-12 20:52:00', 'Đã thanh toán', 'Đơn realistic #1406'),
(1407, NULL, 2, NULL, '2026-04-12 22:03:00', 'Đã thanh toán', 'Đơn realistic #1407'),
(1408, NULL, 4, NULL, '2026-04-12 09:25:00', 'Đã thanh toán', 'Đơn realistic #1408'),
(1409, 5, 4, NULL, '2026-04-12 09:24:00', 'Đã thanh toán', 'Đơn realistic #1409'),
(1410, 24, 3, NULL, '2026-04-12 08:50:00', 'Đã thanh toán', 'Đơn realistic #1410'),
(1411, 18, 8, NULL, '2026-04-12 08:59:00', 'Đã thanh toán', 'Đơn realistic #1411'),
(1412, 11, 3, NULL, '2026-04-12 09:40:00', 'Đã thanh toán', 'Đơn realistic #1412'),
(1413, 4, 8, NULL, '2026-04-12 09:27:00', 'Đã thanh toán', 'Đơn realistic #1413'),
(1414, NULL, 8, NULL, '2026-04-12 08:47:00', 'Đã thanh toán', 'Đơn realistic #1414'),
(1415, NULL, 4, NULL, '2026-04-12 09:20:00', 'Đã thanh toán', 'Đơn realistic #1415'),
(1416, 35, 8, NULL, '2026-04-12 12:58:00', 'Đã thanh toán', 'Đơn realistic #1416'),
(1417, NULL, 3, 2, '2026-04-12 12:51:00', 'Đã thanh toán', 'Đơn realistic #1417'),
(1418, 9, 3, NULL, '2026-04-12 13:07:00', 'Đã thanh toán', 'Đơn realistic #1418'),
(1419, 9, 4, NULL, '2026-04-12 13:17:00', 'Đã thanh toán', 'Đơn realistic #1419'),
(1420, 29, 8, NULL, '2026-04-12 12:35:00', 'Đã thanh toán', 'Đơn realistic #1420'),
(1421, NULL, 12, 2, '2026-04-12 15:21:00', 'Đã thanh toán', 'Đơn realistic #1421'),
(1422, NULL, 4, NULL, '2026-04-12 14:16:00', 'Đã thanh toán', 'Đơn realistic #1422'),
(1423, 26, 12, NULL, '2026-04-12 16:19:00', 'Đã thanh toán', 'Đơn realistic #1423'),
(1424, 14, 2, NULL, '2026-04-12 15:45:00', 'Đã thanh toán', 'Đơn realistic #1424'),
(1425, 13, 4, NULL, '2026-04-12 14:51:00', 'Đã thanh toán', 'Đơn realistic #1425'),
(1426, 11, 8, NULL, '2026-04-12 17:54:00', 'Đã thanh toán', 'Đơn realistic #1426'),
(1427, NULL, 8, NULL, '2026-04-12 18:54:00', 'Đã thanh toán', 'Đơn realistic #1427'),
(1428, 32, 4, NULL, '2026-04-12 20:05:00', 'Đã thanh toán', 'Đơn realistic #1428'),
(1429, 22, 8, NULL, '2026-04-12 20:17:00', 'Đã thanh toán', 'Đơn realistic #1429'),
(1430, NULL, 2, NULL, '2026-04-12 19:08:00', 'Đã thanh toán', 'Đơn realistic #1430'),
(1431, NULL, 4, 2, '2026-04-12 20:04:00', 'Đã thanh toán', 'Đơn realistic #1431'),
(1432, NULL, 8, NULL, '2026-04-12 09:37:00', 'Đã thanh toán', 'Đơn realistic #1432'),
(1433, 1, 3, NULL, '2026-04-12 10:23:00', 'Đã thanh toán', 'Đơn realistic #1433'),
(1434, 29, 8, NULL, '2026-04-12 10:23:00', 'Đã thanh toán', 'Đơn realistic #1434'),
(1435, 21, 8, 2, '2026-04-12 13:07:00', 'Đã thanh toán', 'Đơn realistic #1435'),
(1436, NULL, 8, NULL, '2026-04-12 12:57:00', 'Đã thanh toán', 'Đơn realistic #1436'),
(1437, 25, 8, NULL, '2026-04-12 13:30:00', 'Đã thanh toán', 'Đơn realistic #1437'),
(1438, 19, 12, NULL, '2026-04-12 14:02:00', 'Đã thanh toán', 'Đơn realistic #1438'),
(1439, 6, 12, NULL, '2026-04-12 12:29:00', 'Đã thanh toán', 'Đơn realistic #1439'),
(1440, 35, 4, 2, '2026-04-12 17:33:00', 'Đã thanh toán', 'Đơn realistic #1440'),
(1441, NULL, 3, 2, '2026-04-12 16:53:00', 'Đã thanh toán', 'Đơn realistic #1441'),
(1442, NULL, 3, NULL, '2026-04-12 17:39:00', 'Đã thanh toán', 'Đơn realistic #1442'),
(1443, 32, 4, 1, '2026-04-12 16:39:00', 'Đã thanh toán', 'Đơn realistic #1443'),
(1444, NULL, 4, NULL, '2026-04-12 17:59:00', 'Đã thanh toán', 'Đơn realistic #1444'),
(1445, 36, 4, 2, '2026-04-12 17:59:00', 'Đã thanh toán', 'Đơn realistic #1445'),
(1446, NULL, 2, NULL, '2026-04-12 17:21:00', 'Đã thanh toán', 'Đơn realistic #1446'),
(1447, 28, 3, NULL, '2026-04-12 15:30:00', 'Đã thanh toán', 'Đơn realistic #1447'),
(1448, 36, 2, NULL, '2026-04-12 17:04:00', 'Đã thanh toán', 'Đơn realistic #1448'),
(1449, NULL, 2, NULL, '2026-04-12 19:22:00', 'Đã thanh toán', 'Đơn realistic #1449'),
(1450, 36, 4, 2, '2026-04-12 21:10:00', 'Đã thanh toán', 'Đơn realistic #1450'),
(1451, NULL, 3, NULL, '2026-04-12 21:16:00', 'Đã thanh toán', 'Đơn realistic #1451'),
(1452, 14, 4, 4, '2026-04-12 21:28:00', 'Đã thanh toán', 'Đơn realistic #1452'),
(1453, 28, 4, 2, '2026-04-12 19:37:00', 'Đã thanh toán', 'Đơn realistic #1453'),
(1454, 20, 3, NULL, '2026-04-12 08:16:00', 'Đã thanh toán', 'Đơn realistic #1454'),
(1455, 21, 3, NULL, '2026-04-12 08:01:00', 'Đã thanh toán', 'Đơn realistic #1455'),
(1456, NULL, 3, NULL, '2026-04-12 08:18:00', 'Đã thanh toán', 'Đơn realistic #1456'),
(1457, NULL, 12, NULL, '2026-04-12 08:01:00', 'Đã thanh toán', 'Đơn realistic #1457'),
(1458, NULL, 12, NULL, '2026-04-12 07:49:00', 'Đã thanh toán', 'Đơn realistic #1458'),
(1459, 25, 12, NULL, '2026-04-12 07:22:00', 'Đã thanh toán', 'Đơn realistic #1459'),
(1460, 36, 4, NULL, '2026-04-12 09:21:00', 'Đã thanh toán', 'Đơn realistic #1460'),
(1461, NULL, 4, 1, '2026-04-12 11:25:00', 'Đã thanh toán', 'Đơn realistic #1461'),
(1462, 24, 2, NULL, '2026-04-12 10:01:00', 'Đã thanh toán', 'Đơn realistic #1462'),
(1463, 10, 4, NULL, '2026-04-12 10:20:00', 'Đã thanh toán', 'Đơn realistic #1463'),
(1464, 19, 3, NULL, '2026-04-12 10:59:00', 'Đã thanh toán', 'Đơn realistic #1464'),
(1465, 15, 3, NULL, '2026-04-12 14:38:00', 'Đã thanh toán', 'Đơn realistic #1465'),
(1466, NULL, 8, 2, '2026-04-12 14:23:00', 'Đã thanh toán', 'Đơn realistic #1466'),
(1467, 6, 2, NULL, '2026-04-12 12:34:00', 'Đã thanh toán', 'Đơn realistic #1467'),
(1468, 5, 4, NULL, '2026-04-12 13:16:00', 'Đã thanh toán', 'Đơn realistic #1468'),
(1469, 32, 12, NULL, '2026-04-12 14:44:00', 'Đã thanh toán', 'Đơn realistic #1469'),
(1470, 34, 3, 5, '2026-04-12 17:49:00', 'Đã thanh toán', 'Đơn realistic #1470'),
(1471, 10, 8, 1, '2026-04-12 16:33:00', 'Đã thanh toán', 'Đơn realistic #1471'),
(1472, 12, 3, 5, '2026-04-12 18:07:00', 'Đã thanh toán', 'Đơn realistic #1472'),
(1473, 17, 12, NULL, '2026-04-12 17:16:00', 'Đã thanh toán', 'Đơn realistic #1473'),
(1474, 29, 12, 5, '2026-04-12 15:59:00', 'Đã thanh toán', 'Đơn realistic #1474'),
(1475, 12, 2, NULL, '2026-04-12 18:10:00', 'Đã thanh toán', 'Đơn realistic #1475'),
(1476, 36, 2, 2, '2026-04-12 20:17:00', 'Đã thanh toán', 'Đơn realistic #1476'),
(1477, 4, 4, 4, '2026-04-12 21:21:00', 'Đã thanh toán', 'Đơn realistic #1477'),
(1478, 37, 8, NULL, '2026-04-12 20:26:00', 'Đã thanh toán', 'Đơn realistic #1478'),
(1479, 29, 12, 4, '2026-04-12 21:21:00', 'Đã thanh toán', 'Đơn realistic #1479'),
(1480, NULL, 8, NULL, '2026-04-12 21:01:00', 'Đã thanh toán', 'Đơn realistic #1480');

-- Chi tiết vé thực tế theo từng đơn hàng, phân bổ đều theo ngày và theo phim
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 1
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 2, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 1
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 3, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 2
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 4, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 2
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 5, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 2
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 6, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 2
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 7, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 2
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 8, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 3
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 9, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 3
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 10, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 3
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 11, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 3
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 12, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 3
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 13, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 3
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 14, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 3
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 15, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 3
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 16, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 4
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 17, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 4
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 18, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 4
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 19, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 4
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 20, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 4
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 21, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 4
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 22, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 4
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 23, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 5
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 24, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 5
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 25, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 5
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 26, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 5
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 27, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 5
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 28, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 6
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 29, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 6
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 30, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 6
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 31, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 7
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 32, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 7
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 33, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 7
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 34, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 7
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 35, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 8
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 36, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 8
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 37, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 8
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 38, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 8
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 39, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 8
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 40, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 8
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 41, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 8
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 42, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 9
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 43, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 9
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 44, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 9
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 45, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 9
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 46, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 9
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 47, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 9
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 48, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 10
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 49, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 10
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 50, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 10
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 51, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 10
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 52, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 10
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 53, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 10
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 54, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 10
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 55, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 11
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 56, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 11
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 57, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 11
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 58, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 11
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 59, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 12
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 60, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 12
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 61, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 12
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 62, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 13
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 63, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 13
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 64, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 13
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 65, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 13
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 66, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 13
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 67, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 13
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 68, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 69, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 70, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 71, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 72, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 73, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 74, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 75, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 76, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 77, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 14
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 78, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 15
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 79, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 15
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 80, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 15
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 81, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 15
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 82, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 16
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 83, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 16
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 84, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 16
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 85, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 17
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 86, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 17
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 87, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 17
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 88, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 17
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 89, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 17
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 90, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 17
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 91, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 18
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 92, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 18
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 93, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 18
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 94, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 18
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 95, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 18
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 96, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 18
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 97, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 19
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 98, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 19
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 99, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 19
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 100, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 20
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 101, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 20
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 102, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 20
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 103, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 20
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 104, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 21
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 105, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 21
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 106, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 21
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 107, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 22
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 108, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 22
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 109, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 22
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 110, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 22
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 111, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 22
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 112, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 23
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 113, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 23
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 114, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 23
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 115, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 23
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 116, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 23
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 117, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 23
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 118, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 24
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 119, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 24
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 120, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 24
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 121, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 24
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 122, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 25
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 123, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 25
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 124, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 25
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 125, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 26
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 126, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 26
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 127, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 26
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 128, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 26
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 129, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 26
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 130, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 27
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 131, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 27
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 132, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 27
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 133, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 27
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 134, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 27
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 135, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 27
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 136, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 27
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 137, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 28
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 138, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 28
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 139, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 28
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 140, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 28
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 141, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 28
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 142, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 28
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 143, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 29
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 144, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 29
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 145, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 29
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 146, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 30
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 147, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 30
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 148, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 30
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 149, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 30
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 150, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 30
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 151, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 30
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 152, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 30
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 153, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 31
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 154, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 31
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 155, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 31
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 156, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 32
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 157, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 32
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 158, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 32
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 159, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 32
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 160, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 32
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 161, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 33
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 162, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 33
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 163, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 33
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 164, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 33
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 165, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 34
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 166, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 34
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 167, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 34
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 168, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 35
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 169, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 35
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 170, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 35
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 171, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 36
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 172, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 36
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 173, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 36
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 174, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 36
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 175, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 37
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 176, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 37
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 177, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 37
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 178, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 37
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 179, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 37
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 180, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 37
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 181, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 37
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 182, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 38
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 183, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 38
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 184, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 38
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 185, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 39
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 186, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 39
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 187, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 39
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 188, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 39
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 189, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 40
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 190, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 40
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 191, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 40
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 192, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 40
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 193, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 40
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 194, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 41
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 195, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 41
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 196, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 41
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 197, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 41
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 198, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 41
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 199, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 41
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 200, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 42
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 201, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 42
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 202, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 42
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 203, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 43
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 204, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 43
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 205, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 43
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 206, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 43
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 207, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 43
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 208, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 44
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 209, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 44
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 210, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 44
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 211, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 45
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 212, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 45
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 213, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 45
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 214, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 45
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 215, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 45
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 216, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 45
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 217, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 45
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 218, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 45
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 219, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 46
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 220, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 46
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 221, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 46
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 222, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 46
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 223, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 46
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 224, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 47
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 225, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 47
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 226, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 47
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 227, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 47
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 228, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 47
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 229, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 47
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 230, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 48
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 231, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 48
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 232, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 48
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 233, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 48
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 234, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 48
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 235, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 48
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 236, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 49
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 237, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 49
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 238, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 49
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 239, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 49
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 240, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 49
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 241, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 49
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 242, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 49
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 243, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 49
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 244, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 50
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 245, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 50
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 246, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 50
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 247, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 50
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 248, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 50
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 249, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 50
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 250, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 51
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 251, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 51
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 252, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 51
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 253, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 51
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 254, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 51
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 255, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 51
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 256, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 51
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 257, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 52
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 258, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 52
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 259, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 52
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 260, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 52
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 261, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 52
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 262, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 53
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 263, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 53
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 264, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 53
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 265, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 53
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 266, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 53
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 267, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 53
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 268, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 53
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 269, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 54
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 270, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 54
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 271, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 54
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 272, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 54
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 273, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 54
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 274, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 55
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 275, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 55
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 276, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 55
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 277, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 55
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 278, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 55
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 279, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 55
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 280, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 55
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 281, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 55
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 282, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 56
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 283, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 56
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 284, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 56
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 285, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 56
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 286, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 56
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 287, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 56
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 288, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 57
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 289, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 57
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 290, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 57
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 291, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 57
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 292, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 57
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 293, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 57
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 294, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 57
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 295, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 58
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 296, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 58
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 297, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 58
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 298, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 299, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 300, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 301, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 302, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 303, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 304, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 305, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 306, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 307, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 59
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 308, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 60
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 309, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 60
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 310, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 60
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 311, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 60
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 312, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 60
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 313, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 60
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 314, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 60
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 315, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 61
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 316, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 61
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 317, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 61
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 318, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 61
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 319, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 62
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 320, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 62
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 321, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 62
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 322, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 62
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 323, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 62
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 324, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 63
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 325, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 63
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 326, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 63
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 327, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 63
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 328, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 63
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 329, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 64
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 330, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 64
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 331, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 64
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 332, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 64
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 333, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 64
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 334, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 64
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 335, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 65
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 336, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 65
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 337, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 65
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 338, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 65
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 339, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 66
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 340, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 66
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 341, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 66
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 342, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 67
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 343, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 67
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 344, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 67
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 345, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 67
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 346, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 67
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 347, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 68
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 348, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 68
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 349, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 68
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 350, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 68
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 351, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 68
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 352, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 68
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 353, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 68
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 354, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 68
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 355, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 69
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 356, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 69
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 357, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 69
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 358, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 69
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 359, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 69
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 360, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 69
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 361, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 69
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 362, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 69
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 363, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 70
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 364, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 70
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 365, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 70
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 366, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 70
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 367, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 71
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 368, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 71
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 369, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 71
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 370, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 71
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 371, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 71
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 372, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 71
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 373, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 71
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 374, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 71
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 375, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 71
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 376, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 72
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 377, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 72
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 378, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 72
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 379, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 72
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 380, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 72
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 381, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 72
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 382, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 73
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 383, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 73
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 384, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 73
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 385, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 73
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 386, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 73
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 387, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 388, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 389, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 390, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 391, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 392, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 393, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 394, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 395, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 396, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 397, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 398, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 399, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 74
  AND ((g.HangGhe = 'F' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 400, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 75
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 401, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 75
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 402, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 75
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 403, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 75
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 404, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 76
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 405, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 76
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 406, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 76
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 407, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 76
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 408, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 76
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 409, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 77
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 410, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 77
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 411, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 77
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 412, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 77
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 413, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 77
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 414, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 77
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 415, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 416, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 417, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 418, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 419, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 420, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 421, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 422, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 423, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 424, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 78
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 425, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 79
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 426, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 79
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 427, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 79
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 428, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 79
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 429, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 79
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 430, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 79
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 431, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 79
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 432, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 79
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 433, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 80
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 434, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 80
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 435, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 80
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 436, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 80
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 437, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 80
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 438, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 81
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 439, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 81
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 440, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 81
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 441, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 81
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 442, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 81
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 443, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 444, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 445, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 446, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 447, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 448, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 449, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 450, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 451, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 452, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 82
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 453, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 454, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 455, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 456, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 457, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 458, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 459, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 460, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 461, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 462, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 463, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 83
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 464, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 84
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 465, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 84
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 466, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 84
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 467, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 84
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 468, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 84
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 469, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 85
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 470, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 85
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 471, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 85
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 472, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 85
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 473, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 86
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 474, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 86
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 475, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 86
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 476, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 86
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 477, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 86
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 478, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 86
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 479, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 86
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 480, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 86
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 481, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 86
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 482, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 87
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 483, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 87
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 484, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 87
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 485, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 87
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 486, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 87
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 487, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 88
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 488, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 88
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 489, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 89
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 490, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 89
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 491, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 89
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 492, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 89
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 493, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 89
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 494, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 89
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 495, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 89
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 496, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 497, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 498, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 499, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 500, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 501, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 502, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 503, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 504, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 505, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 506, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 90
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 507, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 508, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 509, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 510, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 511, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 512, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 513, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 514, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 515, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 516, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 517, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 91
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 518, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 92
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 519, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 92
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 520, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 92
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 521, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 92
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 522, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 92
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 523, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 92
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 524, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 92
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 525, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 93
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 526, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 93
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 527, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 94
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 528, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 94
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 529, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 94
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 530, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 94
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 531, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 94
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 532, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 94
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 533, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 95
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 534, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 95
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 535, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 95
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 536, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 95
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 537, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 95
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 538, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 95
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 539, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 95
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 540, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 96
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 541, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 96
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 542, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 96
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 543, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 96
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 544, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 96
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 545, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 96
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 546, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 96
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 547, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 96
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 548, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 97
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 549, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 97
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 550, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 97
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 551, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 97
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 552, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 97
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 553, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 97
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 554, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 97
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 555, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 98
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 556, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 98
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 557, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 98
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 558, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 99
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 559, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 99
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 560, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 99
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 561, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 99
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 562, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 99
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 563, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 99
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 564, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 100
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 565, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 100
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 566, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 100
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 567, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 100
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 568, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 101
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 569, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 101
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 570, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 101
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 571, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 101
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 572, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 101
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 573, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 101
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 574, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 101
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 575, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 101
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 576, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 102
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 577, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 102
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 578, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 102
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 579, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 102
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 580, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 102
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 581, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 102
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 582, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 103
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 583, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 103
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 584, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 103
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 585, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 103
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 586, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 103
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 587, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 104
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 588, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 104
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 589, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 104
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 590, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 104
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 591, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 105
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 592, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 105
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 593, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 105
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 594, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 105
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 595, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 105
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 596, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 105
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 597, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 598, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 599, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 600, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 601, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 602, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 603, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 604, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 605, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 606, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 106
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 607, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 107
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 608, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 107
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 609, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 107
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 610, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 107
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 611, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 107
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 612, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 107
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 613, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 108
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 614, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 108
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 615, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 108
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 616, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 108
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 617, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 108
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 618, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 109
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 619, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 109
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 620, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 109
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 621, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 109
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 622, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 110
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 623, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 110
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 624, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 110
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 625, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 110
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 626, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 111
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 627, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 111
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 628, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 111
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 629, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 112
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 630, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 112
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 631, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 112
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 632, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 112
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 633, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 112
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 634, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 112
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 635, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 113
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 636, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 113
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 637, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 113
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 638, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 113
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 639, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 113
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 640, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 113
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 641, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 642, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 643, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 644, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 645, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 646, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 647, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 648, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 649, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 650, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 114
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 651, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 115
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 652, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 115
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 653, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 115
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 654, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 115
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 655, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 115
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 656, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 115
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 657, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 115
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 658, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 116
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 659, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 116
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 660, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 117
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 661, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 117
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 662, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 117
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 663, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 117
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 664, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 117
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 665, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 118
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 666, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 118
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 667, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 118
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 668, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 118
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 669, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 118
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 670, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 119
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 671, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 119
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 672, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 119
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 673, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 119
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 674, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 120
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 675, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 120
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 676, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 120
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 677, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 120
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 678, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 120
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 679, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 120
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 680, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 120
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 681, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 120
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 682, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 121
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 683, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 121
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 684, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 122
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 685, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 122
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 686, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 122
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 687, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 122
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 688, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 123
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 689, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 123
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 690, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 124
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 691, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 124
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 692, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 124
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 693, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 124
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 694, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 124
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 695, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 125
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 696, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 125
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 697, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 125
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 698, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 125
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 699, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 125
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 700, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 125
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 701, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 125
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 702, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 125
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 703, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 126
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 704, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 126
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 705, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 126
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 706, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 126
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 707, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 127
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 708, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 127
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 709, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 127
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 710, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 127
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 711, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 127
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 712, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 128
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 713, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 128
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 714, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 128
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 715, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 128
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 716, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 129
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 717, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 129
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 718, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 129
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 719, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 129
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 720, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 129
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 721, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 129
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 722, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 130
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 723, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 130
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 724, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 131
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 725, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 131
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 726, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 131
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 727, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 132
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 728, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 132
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 729, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 132
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 730, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 132
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 731, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 132
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 732, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 132
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 733, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 132
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 734, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 133
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 735, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 133
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 736, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 133
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 737, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 133
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 738, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 133
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 739, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 134
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 740, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 134
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 741, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 135
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 742, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 135
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 743, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 135
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 744, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 135
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 745, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 135
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 746, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 136
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 747, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 136
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 748, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 136
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 749, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 137
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 750, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 137
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 751, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 137
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 752, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 137
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 753, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 137
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 754, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 138
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 755, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 138
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 756, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 138
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 757, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 139
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 758, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 139
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 759, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 140
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 760, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 140
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 761, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 140
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 762, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 140
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 763, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 140
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 764, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 140
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 765, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 140
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 766, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 141
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 767, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 141
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 768, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 141
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 769, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 141
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 770, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 142
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 771, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 142
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 772, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 142
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 773, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 142
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 774, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 142
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 775, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 143
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 776, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 143
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 777, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 143
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 778, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 143
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 779, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 143
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 780, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 143
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 781, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 143
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 782, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 144
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 783, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 144
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 784, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 144
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 785, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 145
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 786, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 145
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 787, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 145
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 788, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 146
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 789, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 146
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 790, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 146
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 791, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 146
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 792, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 146
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 793, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 147
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 794, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 147
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 795, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 147
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 796, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 148
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 797, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 148
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 798, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 148
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 799, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 148
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 800, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 148
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 801, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 149
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 802, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 149
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 803, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 149
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 804, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 149
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 805, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 150
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 806, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 150
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 807, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 151
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 808, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 151
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 809, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 151
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 810, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 152
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 811, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 152
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 812, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 152
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 813, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 152
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 814, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 153
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 815, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 153
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 816, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 154
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 817, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 154
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 818, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 154
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 819, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 820, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 821, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 822, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 823, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 824, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 825, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 826, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 827, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 828, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 155
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 829, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 156
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 830, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 156
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 831, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 156
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 832, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 156
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 833, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 156
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 834, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 156
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 835, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 156
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 836, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 157
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 837, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 157
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 838, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 158
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 839, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 158
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 840, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 158
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 841, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 158
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 842, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 159
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 843, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 159
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 844, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 159
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 845, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 159
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 846, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 159
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 847, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 159
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 848, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 160
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 849, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 160
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 850, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 160
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 851, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 160
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 852, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 160
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 853, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 160
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 854, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 161
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 855, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 161
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 856, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 161
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 857, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 161
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 858, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 161
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 859, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 161
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 860, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 161
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 861, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 161
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 862, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 162
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 863, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 162
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 864, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 162
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 865, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 162
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 866, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 163
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 867, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 163
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 868, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 163
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 869, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 163
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 870, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 163
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 871, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 164
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 872, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 164
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 873, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 164
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 874, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 165
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 875, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 165
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 876, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 165
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 877, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 165
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 878, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 165
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 879, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 165
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 880, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 166
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 881, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 166
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 882, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 166
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 883, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 166
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 884, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 166
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 885, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 166
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 886, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 166
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 887, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 167
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 888, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 167
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 889, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 167
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 890, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 168
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 891, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 168
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 892, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 168
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 893, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 168
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 894, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 168
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 895, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 169
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 896, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 169
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 897, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 169
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 898, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 169
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 899, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 169
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 900, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 169
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 901, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 169
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 902, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 169
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 903, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 169
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 904, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 170
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 905, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 170
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 906, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 170
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 907, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 170
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 908, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 170
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 909, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 170
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 910, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 171
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 911, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 171
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 912, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 171
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 913, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 171
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 914, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 171
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 915, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 171
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 916, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 171
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 917, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 171
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 918, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 172
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 919, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 172
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 920, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 173
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 921, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 173
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 922, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 173
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 923, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 174
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 924, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 174
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 925, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 174
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 926, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 175
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 927, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 175
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 928, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 175
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 929, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 176
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 930, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 176
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 931, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 176
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 932, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 177
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 933, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 177
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 934, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 177
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 935, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 177
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 936, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 177
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 937, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 178
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 938, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 178
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 939, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 178
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 940, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 178
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 941, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 178
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 942, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 179
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 943, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 179
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 944, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 179
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 945, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 180
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 946, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 181
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 947, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 181
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 948, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 181
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 949, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 182
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 950, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 182
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 951, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 182
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 952, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 182
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 953, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 183
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 954, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 183
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 955, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 183
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 956, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 183
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 957, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 183
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 958, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 184
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 959, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 184
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 960, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 184
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 961, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 184
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 962, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 184
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 963, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 184
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 964, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 184
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 965, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 185
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 966, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 185
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 967, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 185
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 968, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 186
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 969, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 186
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 970, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 187
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 971, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 187
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 972, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 187
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 973, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 187
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 974, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 187
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 975, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 187
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 976, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 187
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 977, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 188
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 978, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 188
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 979, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 188
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 980, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 188
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 981, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 188
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 982, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 188
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 983, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 188
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 984, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 188
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 985, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 189
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 986, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 189
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 987, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 189
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 988, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 189
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 989, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 189
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 990, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 189
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 991, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 190
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 992, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 190
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 993, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 190
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 994, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 191
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 995, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 191
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 996, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 191
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 997, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 192
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 998, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 192
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 999, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 192
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1000, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 192
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1001, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 193
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1002, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 193
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1003, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 193
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1004, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 193
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1005, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 193
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1006, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 193
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1007, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 193
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1008, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 193
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1009, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 193
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1010, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 194
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1011, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 194
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1012, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 194
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1013, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 194
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1014, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 195
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1015, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 195
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1016, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 195
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1017, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 196
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1018, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 196
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1019, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 196
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1020, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 196
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1021, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 196
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1022, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 197
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1023, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 197
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1024, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 197
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1025, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 197
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1026, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 197
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1027, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 197
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1028, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 198
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1029, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 198
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1030, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 198
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1031, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 198
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1032, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 198
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1033, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 198
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1034, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 198
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1035, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 198
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1036, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 199
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1037, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 199
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1038, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 199
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1039, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 200
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1040, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 200
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1041, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 200
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1042, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 201
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1043, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 201
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1044, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 201
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1045, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 201
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1046, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 201
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1047, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 202
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1048, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 202
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1049, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 202
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1050, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 202
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1051, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 202
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1052, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 203
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1053, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 203
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1054, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 204
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1055, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 204
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1056, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 204
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1057, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 204
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1058, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 204
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1059, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 204
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1060, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 205
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1061, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 205
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1062, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 206
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1063, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 206
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1064, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 206
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1065, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 206
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1066, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 206
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1067, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 206
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1068, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 206
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1069, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 206
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1070, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 207
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1071, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 207
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1072, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 207
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1073, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 207
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1074, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 207
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1075, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 208
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1076, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 208
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1077, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 208
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1078, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 208
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1079, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 209
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1080, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 209
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1081, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 209
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1082, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 209
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1083, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 209
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1084, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 209
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1085, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 210
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1086, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 210
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1087, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 210
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1088, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 210
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1089, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 210
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1090, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 211
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1091, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 211
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1092, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 211
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1093, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 211
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1094, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 211
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1095, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 211
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1096, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 211
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1097, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 212
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1098, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 212
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1099, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 212
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1100, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 212
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1101, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 212
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1102, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 213
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1103, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 213
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1104, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 213
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1105, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 214
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1106, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 214
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1107, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 214
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1108, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 215
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1109, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 215
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1110, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 215
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1111, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 215
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1112, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 215
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1113, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 216
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1114, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 216
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1115, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 216
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1116, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 216
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1117, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 216
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1118, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 216
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1119, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 216
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1120, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 216
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1121, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 217
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1122, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 217
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1123, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 217
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1124, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 217
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1125, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 217
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1126, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 217
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1127, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 217
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1128, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 217
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1129, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 217
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1130, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 218
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1131, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 218
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1132, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 218
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1133, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 219
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1134, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 219
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1135, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 219
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1136, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 219
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1137, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 219
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1138, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 219
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1139, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 219
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1140, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 220
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1141, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 220
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1142, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 220
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1143, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 220
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1144, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 220
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1145, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 221
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1146, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 221
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1147, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 221
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1148, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 221
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1149, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 221
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1150, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 222
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1151, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 222
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1152, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 222
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1153, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 222
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1154, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 223
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1155, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 223
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1156, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 223
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1157, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 223
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1158, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 223
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1159, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 224
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1160, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 224
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1161, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 224
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1162, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 224
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1163, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 224
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1164, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 225
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1165, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 225
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1166, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 225
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1167, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 225
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1168, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 225
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1169, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 225
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1170, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 225
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1171, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 226
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1172, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 226
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1173, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 226
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1174, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 227
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1175, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 227
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1176, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 227
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1177, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 228
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1178, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 228
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1179, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 228
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1180, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 228
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1181, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 228
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1182, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 229
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1183, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 229
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1184, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 229
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1185, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 229
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1186, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 229
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1187, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 230
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1188, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 230
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1189, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 230
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1190, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 230
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1191, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 230
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1192, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 230
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1193, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 230
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1194, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 230
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1195, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 231
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1196, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 231
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1197, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 231
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1198, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 231
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1199, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 231
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1200, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 231
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1201, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 232
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1202, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 232
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1203, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 232
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1204, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 232
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1205, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 232
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1206, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 232
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1207, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 232
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1208, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 233
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1209, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 233
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1210, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 233
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1211, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 233
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1212, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 233
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1213, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 233
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1214, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 233
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1215, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 233
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1216, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 234
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1217, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 234
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1218, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 234
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1219, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 234
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1220, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 234
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1221, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 234
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1222, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1223, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1224, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1225, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1226, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1227, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1228, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1229, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1230, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1231, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1232, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1233, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 235
  AND ((g.HangGhe = 'F' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1234, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 236
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1235, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 236
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1236, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 236
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1237, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 236
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1238, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 236
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1239, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 237
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1240, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 237
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1241, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 237
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1242, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 237
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1243, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 237
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1244, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 238
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1245, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 238
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1246, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 238
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1247, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 238
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1248, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 238
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1249, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 238
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1250, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 238
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1251, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1252, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1253, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1254, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1255, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1256, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1257, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1258, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1259, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1260, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 239
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1261, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1262, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1263, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1264, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1265, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1266, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1267, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1268, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1269, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1270, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 240
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1271, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 241
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1272, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 241
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1273, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 241
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1274, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 241
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1275, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 241
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1276, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 242
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1277, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 242
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1278, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 242
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1279, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 242
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1280, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 243
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1281, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 243
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1282, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 243
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1283, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 243
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1284, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 243
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1285, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 244
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1286, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 244
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1287, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 244
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1288, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 244
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1289, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 244
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1290, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 244
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1291, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 244
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1292, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 244
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1293, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 244
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1294, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 245
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1295, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 245
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1296, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 245
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1297, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 245
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1298, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 245
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1299, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 245
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1300, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 246
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1301, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 246
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1302, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 246
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1303, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 246
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1304, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 246
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1305, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 247
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1306, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 247
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1307, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 247
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1308, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 247
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1309, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 247
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1310, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 248
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1311, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 248
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1312, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 248
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1313, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 248
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1314, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 248
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1315, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 248
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1316, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 248
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1317, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 248
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1318, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 248
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1319, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 249
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1320, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 249
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1321, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 250
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1322, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 250
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1323, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 250
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1324, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 250
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1325, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 250
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1326, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 251
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1327, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 251
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1328, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 251
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1329, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 251
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1330, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 251
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1331, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 251
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1332, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 251
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1333, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 252
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1334, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 252
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1335, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 252
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1336, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 252
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1337, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 252
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1338, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1339, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1340, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1341, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1342, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1343, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1344, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1345, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1346, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1347, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1348, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 253
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1349, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 254
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1350, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 254
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1351, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 254
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1352, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 255
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1353, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 255
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1354, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 255
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1355, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 255
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1356, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 255
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1357, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 256
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1358, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 256
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1359, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 256
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1360, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 256
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1361, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1362, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1363, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1364, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1365, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1366, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1367, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1368, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1369, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1370, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1371, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 257
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1372, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 258
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1373, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 258
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1374, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 258
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1375, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 258
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1376, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 258
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1377, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 258
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1378, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 259
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1379, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 259
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1380, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 259
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1381, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 259
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1382, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 259
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1383, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 260
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1384, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 260
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1385, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 260
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1386, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 260
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1387, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 261
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1388, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 261
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1389, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 261
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1390, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 261
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1391, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 261
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1392, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 262
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1393, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 262
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1394, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 262
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1395, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 262
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1396, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 262
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1397, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 262
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1398, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1399, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1400, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1401, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1402, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1403, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1404, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1405, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1406, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1407, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 263
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1408, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 264
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1409, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 264
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1410, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 264
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1411, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 264
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1412, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 264
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1413, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 264
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1414, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 264
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1415, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 264
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1416, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 265
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1417, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 265
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1418, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 265
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1419, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 265
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1420, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 265
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1421, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 266
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1422, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 266
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1423, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 266
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1424, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 266
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1425, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 266
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1426, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 267
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1427, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 267
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1428, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 267
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1429, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 267
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1430, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 267
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1431, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 267
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1432, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 268
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1433, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 268
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4, 5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1434, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 268
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1435, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 269
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1436, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 269
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1437, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 269
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1438, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 269
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1439, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 269
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1440, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 270
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1441, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 270
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1442, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 270
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1443, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 270
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1444, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 270
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1445, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 270
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1446, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 270
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1447, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 270
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1448, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 270
  AND ((g.HangGhe = 'C' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1449, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 271
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4, 5)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1450, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 271
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (6, 7, 8, 9, 10)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1451, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 271
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1452, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 271
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1453, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 271
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1454, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 272
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1455, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 272
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1456, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 272
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1457, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 272
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1458, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 272
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1459, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 272
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1460, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 273
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1461, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 273
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (2, 3)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1462, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 273
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1463, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 273
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1464, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 273
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1465, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 274
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1466, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 274
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1467, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 274
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1468, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 274
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1469, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 274
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1470, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 275
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1471, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 275
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1472, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 275
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (7, 8, 9, 10, 11)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1473, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 275
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1474, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 275
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1475, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 275
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6, 7)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1476, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 276
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1477, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 276
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (5, 6, 7, 8, 9)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1478, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 276
  AND ((g.HangGhe = 'D' AND g.SoGhe IN (10, 11, 12)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1479, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 276
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (1, 2, 3, 4)));
INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1480, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 276
  AND ((g.HangGhe = 'E' AND g.SoGhe IN (5, 6)));

INSERT INTO ChiTietDonHangSanPham (MaDonHang, MaSanPham, SoLuong, DonGiaBan) VALUES
(2, 19, 1, 199000),
(2, 6, 1, 49000),
(11, 17, 1, 95000),
(17, 17, 1, 95000),
(19, 18, 1, 169000),
(19, 9, 1, 32000),
(20, 20, 1, 329000),
(22, 19, 1, 199000),
(29, 20, 1, 329000),
(30, 13, 1, 39000),
(31, 19, 1, 199000),
(35, 18, 1, 169000),
(37, 20, 1, 329000),
(51, 14, 1, 45000),
(54, 9, 1, 32000),
(62, 19, 1, 199000),
(67, 14, 1, 45000),
(70, 20, 1, 329000),
(73, 16, 1, 89000),
(78, 18, 1, 169000),
(88, 18, 1, 169000),
(110, 19, 1, 199000),
(118, 19, 1, 199000),
(122, 20, 1, 329000),
(125, 19, 1, 199000),
(140, 20, 1, 329000),
(147, 19, 1, 199000),
(154, 19, 1, 199000),
(154, 9, 1, 32000),
(156, 13, 1, 39000),
(159, 18, 1, 169000),
(159, 11, 2, 32000),
(191, 14, 1, 45000),
(204, 18, 1, 169000),
(212, 18, 1, 169000),
(216, 19, 1, 199000),
(221, 19, 1, 199000),
(222, 10, 1, 32000),
(224, 18, 1, 169000),
(224, 10, 1, 32000),
(225, 13, 1, 39000),
(226, 18, 1, 169000),
(227, 20, 1, 329000),
(227, 6, 1, 49000),
(231, 20, 1, 329000),
(232, 19, 1, 199000),
(235, 18, 1, 169000),
(239, 18, 1, 169000),
(239, 13, 1, 39000),
(240, 13, 1, 39000),
(241, 18, 1, 169000),
(245, 18, 1, 169000),
(246, 20, 1, 329000),
(246, 13, 2, 39000),
(247, 16, 1, 89000),
(248, 20, 1, 329000),
(250, 17, 1, 95000),
(253, 19, 1, 199000),
(255, 19, 1, 199000),
(255, 9, 2, 32000),
(258, 20, 1, 329000),
(258, 9, 2, 32000),
(260, 18, 1, 169000),
(260, 6, 1, 49000),
(264, 19, 1, 199000),
(269, 20, 1, 329000),
(270, 18, 1, 169000),
(271, 16, 1, 89000),
(271, 12, 1, 25000),
(272, 18, 1, 169000),
(273, 19, 1, 199000),
(274, 18, 1, 169000),
(277, 16, 1, 89000),
(277, 10, 1, 32000),
(279, 18, 1, 169000),
(284, 20, 1, 329000),
(285, 17, 1, 95000),
(286, 18, 1, 169000),
(287, 16, 1, 89000),
(292, 17, 1, 95000),
(292, 11, 1, 32000),
(299, 19, 1, 199000),
(301, 20, 1, 329000),
(303, 9, 1, 32000),
(305, 19, 1, 199000),
(307, 9, 1, 32000),
(312, 17, 1, 95000),
(314, 19, 1, 199000),
(315, 18, 1, 169000),
(317, 18, 1, 169000),
(324, 19, 1, 199000),
(329, 18, 1, 169000),
(329, 9, 1, 32000),
(330, 20, 1, 329000),
(333, 17, 1, 95000),
(338, 17, 1, 95000),
(342, 18, 1, 169000),
(342, 10, 1, 32000),
(343, 19, 1, 199000),
(349, 19, 1, 199000),
(356, 18, 1, 169000),
(358, 18, 1, 169000),
(360, 16, 1, 89000),
(362, 9, 1, 32000),
(366, 16, 1, 89000),
(368, 20, 1, 329000),
(379, 19, 1, 199000),
(384, 20, 1, 329000),
(385, 18, 1, 169000),
(385, 5, 1, 55000),
(386, 16, 1, 89000),
(386, 9, 1, 32000),
(395, 20, 1, 329000),
(395, 11, 2, 32000),
(401, 20, 1, 329000),
(402, 19, 1, 199000),
(403, 13, 1, 39000),
(405, 19, 1, 199000),
(405, 11, 2, 32000),
(408, 19, 1, 199000),
(416, 19, 1, 199000),
(417, 19, 1, 199000),
(423, 16, 1, 89000),
(424, 18, 1, 169000),
(429, 19, 1, 199000),
(433, 19, 1, 199000),
(436, 17, 1, 95000),
(438, 18, 1, 169000),
(444, 20, 1, 329000),
(444, 11, 1, 32000),
(446, 13, 1, 39000),
(447, 17, 1, 95000),
(449, 18, 1, 169000),
(451, 20, 1, 329000),
(452, 20, 1, 329000),
(458, 19, 1, 199000),
(458, 10, 1, 32000),
(461, 19, 1, 199000),
(461, 9, 1, 32000),
(463, 10, 1, 32000),
(465, 18, 1, 169000),
(471, 20, 1, 329000),
(476, 16, 1, 89000),
(480, 20, 1, 329000),
(481, 18, 1, 169000),
(493, 18, 1, 169000),
(495, 18, 1, 169000),
(496, 19, 1, 199000),
(507, 18, 1, 169000),
(510, 18, 1, 169000),
(515, 16, 1, 89000),
(518, 20, 1, 329000),
(522, 20, 1, 329000),
(526, 20, 1, 329000),
(529, 14, 1, 45000),
(534, 19, 1, 199000),
(539, 19, 1, 199000),
(540, 20, 1, 329000),
(542, 18, 1, 169000),
(545, 19, 1, 199000),
(548, 18, 1, 169000),
(556, 19, 1, 199000),
(556, 9, 2, 32000),
(564, 18, 1, 169000),
(567, 19, 1, 199000),
(569, 18, 1, 169000),
(571, 18, 1, 169000),
(574, 20, 1, 329000),
(575, 18, 1, 169000),
(580, 19, 1, 199000),
(582, 16, 1, 89000),
(583, 20, 1, 329000),
(589, 18, 1, 169000),
(590, 20, 1, 329000),
(592, 20, 1, 329000),
(592, 6, 1, 49000),
(599, 9, 1, 32000),
(606, 19, 1, 199000),
(612, 9, 1, 32000),
(621, 19, 1, 199000),
(632, 14, 1, 45000),
(633, 20, 1, 329000),
(635, 16, 1, 89000),
(639, 14, 1, 45000),
(640, 17, 1, 95000),
(647, 9, 1, 32000),
(648, 20, 1, 329000),
(650, 16, 1, 89000),
(663, 17, 1, 95000),
(672, 18, 1, 169000),
(677, 20, 1, 329000),
(683, 17, 1, 95000),
(685, 18, 1, 169000),
(691, 20, 1, 329000),
(693, 10, 1, 32000),
(694, 16, 1, 89000),
(695, 14, 1, 45000),
(696, 13, 1, 39000),
(699, 19, 1, 199000),
(701, 18, 1, 169000),
(716, 18, 1, 169000),
(719, 20, 1, 329000),
(722, 19, 1, 199000),
(722, 10, 2, 32000),
(724, 20, 1, 329000),
(732, 20, 1, 329000),
(732, 6, 1, 49000),
(735, 18, 1, 169000),
(737, 20, 1, 329000),
(740, 17, 1, 95000),
(741, 20, 1, 329000),
(750, 19, 1, 199000),
(751, 20, 1, 329000),
(752, 18, 1, 169000),
(760, 19, 1, 199000),
(760, 10, 1, 32000),
(765, 10, 1, 32000),
(768, 18, 1, 169000),
(768, 9, 1, 32000),
(792, 16, 1, 89000),
(802, 19, 1, 199000),
(803, 20, 1, 329000),
(812, 9, 1, 32000),
(826, 18, 1, 169000),
(837, 16, 1, 89000),
(845, 18, 1, 169000),
(849, 20, 1, 329000),
(850, 18, 1, 169000),
(857, 18, 1, 169000),
(861, 18, 1, 169000),
(867, 19, 1, 199000),
(871, 18, 1, 169000),
(883, 9, 1, 32000),
(887, 20, 1, 329000),
(888, 18, 1, 169000),
(888, 9, 1, 32000),
(898, 18, 1, 169000),
(899, 16, 1, 89000),
(900, 17, 1, 95000),
(903, 17, 1, 95000),
(909, 18, 1, 169000),
(912, 19, 1, 199000),
(919, 20, 1, 329000),
(925, 18, 1, 169000),
(926, 19, 1, 199000),
(926, 5, 1, 55000),
(938, 16, 1, 89000),
(950, 9, 1, 32000),
(959, 16, 1, 89000),
(959, 10, 1, 32000),
(959, 23, 1, 59000),
(963, 20, 1, 329000),
(972, 20, 1, 329000),
(972, 11, 2, 32000),
(982, 19, 1, 199000),
(982, 10, 2, 32000),
(984, 18, 1, 169000),
(997, 19, 1, 199000),
(1003, 18, 1, 169000),
(1005, 18, 1, 169000),
(1005, 13, 1, 39000),
(1013, 18, 1, 169000),
(1020, 19, 1, 199000),
(1028, 19, 1, 199000),
(1028, 10, 1, 32000),
(1029, 14, 1, 45000),
(1035, 19, 1, 199000),
(1048, 18, 1, 169000),
(1049, 16, 1, 89000),
(1059, 17, 1, 95000),
(1060, 20, 1, 329000),
(1061, 18, 1, 169000),
(1066, 19, 1, 199000),
(1067, 20, 1, 329000),
(1067, 13, 2, 39000),
(1069, 17, 1, 95000),
(1077, 17, 1, 95000),
(1094, 16, 1, 89000),
(1095, 20, 1, 329000),
(1109, 16, 1, 89000),
(1111, 17, 1, 95000),
(1113, 16, 1, 89000),
(1118, 17, 1, 95000),
(1121, 19, 1, 199000),
(1122, 18, 1, 169000),
(1122, 9, 2, 32000),
(1125, 20, 1, 329000),
(1133, 16, 1, 89000),
(1135, 19, 1, 199000),
(1135, 6, 1, 49000),
(1140, 18, 1, 169000),
(1142, 18, 1, 169000),
(1144, 16, 1, 89000),
(1146, 20, 1, 329000),
(1147, 20, 1, 329000),
(1151, 18, 1, 169000),
(1153, 19, 1, 199000),
(1161, 20, 1, 329000),
(1161, 9, 1, 32000),
(1163, 19, 1, 199000),
(1166, 18, 1, 169000),
(1166, 13, 1, 39000),
(1167, 17, 1, 95000),
(1171, 16, 1, 89000),
(1171, 9, 1, 32000),
(1176, 20, 1, 329000),
(1179, 20, 1, 329000),
(1181, 13, 1, 39000),
(1184, 20, 1, 329000),
(1185, 18, 1, 169000),
(1198, 18, 1, 169000),
(1208, 16, 1, 89000),
(1214, 19, 1, 199000),
(1218, 18, 1, 169000),
(1218, 10, 1, 32000),
(1219, 9, 1, 32000),
(1224, 18, 1, 169000),
(1226, 19, 1, 199000),
(1227, 19, 1, 199000),
(1232, 18, 1, 169000),
(1232, 22, 1, 149000),
(1234, 18, 1, 169000),
(1235, 18, 1, 169000),
(1235, 13, 1, 39000),
(1238, 19, 1, 199000),
(1251, 20, 1, 329000),
(1257, 18, 1, 169000),
(1263, 18, 1, 169000),
(1267, 18, 1, 169000),
(1271, 18, 1, 169000),
(1272, 18, 1, 169000),
(1277, 20, 1, 329000),
(1279, 16, 1, 89000),
(1283, 18, 1, 169000),
(1295, 19, 1, 199000),
(1299, 13, 1, 39000),
(1300, 18, 1, 169000),
(1300, 11, 1, 32000),
(1320, 19, 1, 199000),
(1322, 19, 1, 199000),
(1325, 19, 1, 199000),
(1325, 5, 1, 55000),
(1331, 19, 1, 199000),
(1336, 18, 1, 169000),
(1342, 19, 1, 199000),
(1344, 18, 1, 169000),
(1354, 19, 1, 199000),
(1357, 19, 1, 199000),
(1359, 18, 1, 169000),
(1360, 18, 1, 169000),
(1360, 10, 1, 32000),
(1362, 17, 1, 95000),
(1364, 17, 1, 95000),
(1365, 19, 1, 199000),
(1366, 19, 1, 199000),
(1372, 19, 1, 199000),
(1374, 17, 1, 95000),
(1376, 18, 1, 169000),
(1385, 19, 1, 199000),
(1387, 18, 1, 169000),
(1391, 16, 1, 89000),
(1393, 18, 1, 169000),
(1394, 18, 1, 169000),
(1397, 19, 1, 199000),
(1401, 19, 1, 199000),
(1404, 17, 1, 95000),
(1410, 17, 1, 95000),
(1413, 16, 1, 89000),
(1415, 19, 1, 199000),
(1424, 18, 1, 169000),
(1430, 19, 1, 199000),
(1446, 17, 1, 95000),
(1450, 11, 2, 32000),
(1453, 16, 1, 89000),
(1454, 18, 1, 169000),
(1455, 17, 1, 95000),
(1455, 22, 1, 149000),
(1458, 19, 1, 199000),
(1460, 10, 1, 32000),
(1461, 18, 1, 169000),
(1461, 13, 1, 39000),
(1477, 18, 1, 169000);

-- Cập nhật trạng thái vé sau khi được gắn vào đơn hàng
UPDATE Ve v
JOIN ChiTietDonHangVe ct ON ct.MaVe = v.MaVe
SET v.TrangThaiVe = 'Đã bán';

-- Vé của các suất đã diễn ra trước thời điểm mô phỏng được đánh dấu là đã sử dụng
UPDATE Ve v
JOIN ChiTietDonHangVe ct ON ct.MaVe = v.MaVe
JOIN SuatChieu sc ON sc.MaSuatChieu = v.MaSuatChieu
SET v.TrangThaiVe = 'Đã sử dụng'
WHERE sc.NgayGioChieu < '2026-04-04 12:00:00';

SET SQL_SAFE_UPDATES = 0;
-- Trừ tồn kho sản phẩm theo toàn bộ đơn hàng đã thanh toán
UPDATE SanPham sp
JOIN (
    SELECT ctdhsp.MaSanPham, SUM(ctdhsp.SoLuong) AS TongDaBan
    FROM ChiTietDonHangSanPham ctdhsp
    GROUP BY ctdhsp.MaSanPham
) x ON x.MaSanPham = sp.MaSanPham
SET sp.SoLuongTon = GREATEST(0, sp.SoLuongTon - x.TongDaBan);

INSERT INTO ThanhToan (MaDonHang, SoTien, PhuongThucThanhToan, ThoiGianThanhToan, TrangThaiThanhToan) VALUES
(1, 300000, 'Chuyển khoản', '2026-04-01 07:51:00', 'Thành công'),
(2, 623000, 'Chuyển khoản', '2026-04-01 07:56:00', 'Thành công'),
(3, 170000, 'Chuyển khoản', '2026-04-01 10:22:00', 'Thành công'),
(4, 340000, 'Ví điện tử', '2026-04-01 11:55:00', 'Thành công'),
(5, 255000, 'Ví điện tử', '2026-04-01 09:54:00', 'Thành công'),
(6, 255000, 'MoMo', '2026-04-01 11:05:00', 'Thành công'),
(7, 255000, 'MoMo', '2026-04-01 09:50:00', 'Thành công'),
(8, 190000, 'Tiền mặt', '2026-04-01 15:16:00', 'Thành công'),
(9, 190000, 'Tiền mặt', '2026-04-01 13:08:00', 'Thành công'),
(10, 323000, 'Thẻ ngân hàng', '2026-04-01 13:27:00', 'Thành công'),
(11, 285000, 'Thẻ ngân hàng', '2026-04-01 13:41:00', 'Thành công'),
(12, 161500, 'Tiền mặt', '2026-04-01 13:15:00', 'Thành công'),
(13, 380000, 'Thẻ ngân hàng', '2026-04-01 12:52:00', 'Thành công'),
(14, 95000, 'Ví điện tử', '2026-04-01 13:21:00', 'Thành công'),
(15, 190000, 'Tiền mặt', '2026-04-01 13:12:00', 'Thành công'),
(16, 420000, 'Thẻ ngân hàng', '2026-04-01 17:47:00', 'Thành công'),
(17, 305000, 'Thẻ ngân hàng', '2026-04-01 16:08:00', 'Thành công'),
(18, 210000, 'MoMo', '2026-04-01 17:48:00', 'Thành công'),
(19, 591000, 'Chuyển khoản', '2026-04-01 16:23:00', 'Thành công'),
(20, 644000, 'Ví điện tử', '2026-04-01 17:03:00', 'Thành công'),
(21, 210000, 'Ví điện tử', '2026-04-01 16:41:00', 'Thành công'),
(22, 409000, 'Thẻ ngân hàng', '2026-04-01 17:25:00', 'Thành công'),
(23, 380000, 'Tiền mặt', '2026-04-01 21:25:00', 'Thành công'),
(24, 190000, 'Chuyển khoản', '2026-04-01 21:25:00', 'Thành công'),
(25, 285000, 'Tiền mặt', '2026-04-01 20:09:00', 'Thành công'),
(26, 285000, 'Chuyển khoản', '2026-04-01 20:02:00', 'Thành công'),
(27, 190000, 'Chuyển khoản', '2026-04-01 21:35:00', 'Thành công'),
(28, 160000, 'MoMo', '2026-04-01 08:35:00', 'Thành công'),
(29, 699000, 'Thẻ ngân hàng', '2026-04-01 08:36:00', 'Thành công'),
(30, 119000, 'Tiền mặt', '2026-04-01 09:28:00', 'Thành công'),
(31, 649000, 'Thẻ ngân hàng', '2026-04-01 11:25:00', 'Thành công'),
(32, 360000, 'Ví điện tử', '2026-04-01 10:31:00', 'Thành công'),
(33, 240000, 'Thẻ ngân hàng', '2026-04-01 12:31:00', 'Thành công'),
(34, 90000, 'MoMo', '2026-04-01 11:07:00', 'Thành công'),
(35, 439000, 'Ví điện tử', '2026-04-01 15:28:00', 'Thành công'),
(36, 200000, 'Tiền mặt', '2026-04-01 15:44:00', 'Thành công'),
(37, 679000, 'Ví điện tử', '2026-04-01 15:22:00', 'Thành công'),
(38, 300000, 'Thẻ ngân hàng', '2026-04-01 16:04:00', 'Thành công'),
(39, 300000, 'Tiền mặt', '2026-04-01 15:44:00', 'Thành công'),
(40, 400000, 'MoMo', '2026-04-01 15:11:00', 'Thành công'),
(41, 100000, 'Ví điện tử', '2026-04-01 15:13:00', 'Thành công'),
(42, 440000, 'Tiền mặt', '2026-04-01 19:08:00', 'Thành công'),
(43, 440000, 'Tiền mặt', '2026-04-01 18:25:00', 'Thành công'),
(44, 330000, 'Chuyển khoản', '2026-04-01 17:48:00', 'Thành công'),
(45, 110000, 'Thẻ ngân hàng', '2026-04-01 18:17:00', 'Thành công'),
(46, 440000, 'Tiền mặt', '2026-04-01 18:40:00', 'Thành công'),
(47, 220000, 'Thẻ ngân hàng', '2026-04-01 18:32:00', 'Thành công'),
(48, 500000, 'MoMo', '2026-04-01 21:09:00', 'Thành công'),
(49, 400000, 'MoMo', '2026-04-01 22:15:00', 'Thành công'),
(50, 200000, 'Ví điện tử', '2026-04-01 21:16:00', 'Thành công'),
(51, 145000, 'Ví điện tử', '2026-04-01 20:59:00', 'Thành công'),
(52, 200000, 'Tiền mặt', '2026-04-01 21:41:00', 'Thành công'),
(53, 600000, 'Chuyển khoản', '2026-04-01 21:57:00', 'Thành công'),
(54, 112000, 'Ví điện tử', '2026-04-01 21:39:00', 'Thành công'),
(55, 180000, 'Tiền mặt', '2026-04-01 09:38:00', 'Thành công'),
(56, 510000, 'Ví điện tử', '2026-04-01 08:51:00', 'Thành công'),
(57, 180000, 'Thẻ ngân hàng', '2026-04-01 08:58:00', 'Thành công'),
(58, 90000, 'Tiền mặt', '2026-04-01 09:35:00', 'Thành công'),
(59, 200000, 'MoMo', '2026-04-01 13:15:00', 'Thành công'),
(60, 370000, 'Chuyển khoản', '2026-04-01 13:05:00', 'Thành công'),
(61, 400000, 'Chuyển khoản', '2026-04-01 12:08:00', 'Thành công'),
(62, 529000, 'MoMo', '2026-04-01 16:10:00', 'Thành công'),
(63, 440000, 'Tiền mặt', '2026-04-01 16:16:00', 'Thành công'),
(64, 220000, 'Ví điện tử', '2026-04-01 16:16:00', 'Thành công'),
(65, 300000, 'Thẻ ngân hàng', '2026-04-01 17:00:00', 'Thành công'),
(66, 410000, 'MoMo', '2026-04-01 15:38:00', 'Thành công'),
(67, 155000, 'Ví điện tử', '2026-04-01 14:50:00', 'Thành công'),
(68, 550000, 'MoMo', '2026-04-01 19:53:00', 'Thành công'),
(69, 120000, 'MoMo', '2026-04-01 18:52:00', 'Thành công'),
(70, 809000, 'Thẻ ngân hàng', '2026-04-01 19:19:00', 'Thành công'),
(71, 120000, 'Ví điện tử', '2026-04-01 18:12:00', 'Thành công'),
(72, 120000, 'Tiền mặt', '2026-04-01 19:50:00', 'Thành công'),
(73, 329000, 'Chuyển khoản', '2026-04-01 19:40:00', 'Thành công'),
(74, 600000, 'MoMo', '2026-04-01 18:36:00', 'Thành công'),
(75, 430000, 'MoMo', '2026-04-01 18:31:00', 'Thành công'),
(76, 120000, 'Tiền mặt', '2026-04-01 19:45:00', 'Thành công'),
(77, 240000, 'MoMo', '2026-04-01 19:22:00', 'Thành công'),
(78, 514000, 'Chuyển khoản', '2026-04-01 10:43:00', 'Thành công'),
(79, 125000, 'MoMo', '2026-04-01 10:21:00', 'Thành công'),
(80, 450000, 'Thẻ ngân hàng', '2026-04-01 09:59:00', 'Thành công'),
(81, 125000, 'Ví điện tử', '2026-04-01 10:02:00', 'Thành công'),
(82, 270000, 'Ví điện tử', '2026-04-01 13:06:00', 'Thành công'),
(83, 270000, 'Chuyển khoản', '2026-04-01 14:17:00', 'Thành công'),
(84, 540000, 'Tiền mặt', '2026-04-01 11:54:00', 'Thành công'),
(85, 145000, 'Chuyển khoản', '2026-04-01 16:42:00', 'Thành công'),
(86, 530000, 'Chuyển khoản', '2026-04-01 16:24:00', 'Thành công'),
(87, 580000, 'Ví điện tử', '2026-04-01 17:49:00', 'Thành công'),
(88, 604000, 'Tiền mặt', '2026-04-01 16:17:00', 'Thành công'),
(89, 530000, 'Tiền mặt', '2026-04-01 18:07:00', 'Thành công'),
(90, 145000, 'Ví điện tử', '2026-04-01 17:58:00', 'Thành công'),
(91, 590000, 'Tiền mặt', '2026-04-01 21:54:00', 'Thành công'),
(92, 280000, 'Chuyển khoản', '2026-04-01 20:28:00', 'Thành công'),
(93, 465000, 'Tiền mặt', '2026-04-01 20:59:00', 'Thành công'),
(94, 465000, 'Tiền mặt', '2026-04-01 21:18:00', 'Thành công'),
(95, 620000, 'Thẻ ngân hàng', '2026-04-01 19:30:00', 'Thành công'),
(96, 310000, 'MoMo', '2026-04-01 20:24:00', 'Thành công'),
(97, 140000, 'Ví điện tử', '2026-04-01 07:39:00', 'Thành công'),
(98, 280000, 'Tiền mặt', '2026-04-01 07:33:00', 'Thành công'),
(99, 70000, 'Chuyển khoản', '2026-04-01 07:37:00', 'Thành công'),
(100, 320000, 'Tiền mặt', '2026-04-01 09:41:00', 'Thành công'),
(101, 480000, 'Thẻ ngân hàng', '2026-04-01 10:23:00', 'Thành công'),
(102, 160000, 'Tiền mặt', '2026-04-01 10:41:00', 'Thành công'),
(103, 160000, 'Ví điện tử', '2026-04-01 10:21:00', 'Thành công'),
(104, 360000, 'Ví điện tử', '2026-04-01 13:06:00', 'Thành công'),
(105, 450000, 'Ví điện tử', '2026-04-01 13:50:00', 'Thành công'),
(106, 90000, 'Tiền mặt', '2026-04-01 15:00:00', 'Thành công'),
(107, 370000, 'Chuyển khoản', '2026-04-01 17:22:00', 'Thành công'),
(108, 270000, 'Ví điện tử', '2026-04-01 17:31:00', 'Thành công'),
(109, 300000, 'Ví điện tử', '2026-04-01 16:15:00', 'Thành công'),
(110, 369000, 'Ví điện tử', '2026-04-01 16:14:00', 'Thành công'),
(111, 100000, 'MoMo', '2026-04-01 18:04:00', 'Thành công'),
(112, 360000, 'Thẻ ngân hàng', '2026-04-01 20:01:00', 'Thành công'),
(113, 270000, 'Tiền mặt', '2026-04-01 20:07:00', 'Thành công'),
(114, 180000, 'Thẻ ngân hàng', '2026-04-01 19:13:00', 'Thành công'),
(115, 160000, 'Ví điện tử', '2026-04-01 20:57:00', 'Thành công'),
(116, 90000, 'Thẻ ngân hàng', '2026-04-01 19:05:00', 'Thành công'),
(117, 240000, 'Thẻ ngân hàng', '2026-04-01 20:32:00', 'Thành công'),
(118, 394000, 'MoMo', '2026-04-02 08:18:00', 'Thành công'),
(119, 300000, 'Thẻ ngân hàng', '2026-04-02 08:04:00', 'Thành công'),
(120, 150000, 'Tiền mặt', '2026-04-02 08:38:00', 'Thành công'),
(121, 150000, 'Thẻ ngân hàng', '2026-04-02 07:42:00', 'Thành công'),
(122, 639000, 'Tiền mặt', '2026-04-02 09:44:00', 'Thành công'),
(123, 340000, 'MoMo', '2026-04-02 10:29:00', 'Thành công'),
(124, 255000, 'Tiền mặt', '2026-04-02 11:44:00', 'Thành công'),
(125, 579000, 'MoMo', '2026-04-02 14:14:00', 'Thành công'),
(126, 350000, 'Thẻ ngân hàng', '2026-04-02 14:08:00', 'Thành công'),
(127, 380000, 'Thẻ ngân hàng', '2026-04-02 13:57:00', 'Thành công'),
(128, 380000, 'Tiền mặt', '2026-04-02 14:31:00', 'Thành công'),
(129, 285000, 'MoMo', '2026-04-02 14:51:00', 'Thành công'),
(130, 420000, 'Ví điện tử', '2026-04-02 17:16:00', 'Thành công'),
(131, 420000, 'MoMo', '2026-04-02 16:41:00', 'Thành công'),
(132, 210000, 'Ví điện tử', '2026-04-02 17:23:00', 'Thành công'),
(133, 210000, 'MoMo', '2026-04-02 17:47:00', 'Thành công'),
(134, 390000, 'Ví điện tử', '2026-04-02 17:43:00', 'Thành công'),
(135, 210000, 'Ví điện tử', '2026-04-02 18:21:00', 'Thành công'),
(136, 315000, 'Thẻ ngân hàng', '2026-04-02 16:54:00', 'Thành công'),
(137, 570000, 'Ví điện tử', '2026-04-02 20:07:00', 'Thành công'),
(138, 350000, 'Chuyển khoản', '2026-04-02 19:35:00', 'Thành công'),
(139, 190000, 'MoMo', '2026-04-02 19:21:00', 'Thành công'),
(140, 709000, 'Tiền mặt', '2026-04-02 20:31:00', 'Thành công'),
(141, 380000, 'MoMo', '2026-04-02 20:37:00', 'Thành công'),
(142, 380000, 'Chuyển khoản', '2026-04-02 21:09:00', 'Thành công'),
(143, 320000, 'Tiền mặt', '2026-04-02 09:09:00', 'Thành công'),
(144, 160000, 'Chuyển khoản', '2026-04-02 08:28:00', 'Thành công'),
(145, 80000, 'Thẻ ngân hàng', '2026-04-02 09:00:00', 'Thành công'),
(146, 90000, 'Thẻ ngân hàng', '2026-04-02 10:18:00', 'Thành công'),
(147, 559000, 'Tiền mặt', '2026-04-02 11:35:00', 'Thành công'),
(148, 180000, 'Ví điện tử', '2026-04-02 10:30:00', 'Thành công'),
(149, 180000, 'MoMo', '2026-04-02 11:26:00', 'Thành công'),
(150, 240000, 'Thẻ ngân hàng', '2026-04-02 10:42:00', 'Thành công'),
(151, 180000, 'Chuyển khoản', '2026-04-02 12:07:00', 'Thành công'),
(152, 90000, 'Thẻ ngân hàng', '2026-04-02 12:23:00', 'Thành công'),
(153, 400000, 'Tiền mặt', '2026-04-02 14:28:00', 'Thành công'),
(154, 581000, 'MoMo', '2026-04-02 14:04:00', 'Thành công'),
(155, 300000, 'Thẻ ngân hàng', '2026-04-02 14:47:00', 'Thành công'),
(156, 149000, 'MoMo', '2026-04-02 16:46:00', 'Thành công'),
(157, 330000, 'Thẻ ngân hàng', '2026-04-02 17:35:00', 'Thành công'),
(158, 330000, 'Chuyển khoản', '2026-04-02 17:57:00', 'Thành công'),
(159, 783000, 'Chuyển khoản', '2026-04-02 17:01:00', 'Thành công'),
(160, 220000, 'MoMo', '2026-04-02 16:59:00', 'Thành công'),
(161, 350000, 'Tiền mặt', '2026-04-02 21:30:00', 'Thành công'),
(162, 500000, 'MoMo', '2026-04-02 21:17:00', 'Thành công'),
(163, 300000, 'Tiền mặt', '2026-04-02 21:53:00', 'Thành công'),
(164, 200000, 'Chuyển khoản', '2026-04-02 20:58:00', 'Thành công'),
(165, 330000, 'Tiền mặt', '2026-04-02 09:14:00', 'Thành công'),
(166, 330000, 'Tiền mặt', '2026-04-02 08:58:00', 'Thành công'),
(167, 90000, 'Thẻ ngân hàng', '2026-04-02 09:48:00', 'Thành công'),
(168, 350000, 'Thẻ ngân hàng', '2026-04-02 11:59:00', 'Thành công'),
(169, 300000, 'Tiền mặt', '2026-04-02 11:40:00', 'Thành công'),
(170, 300000, 'Tiền mặt', '2026-04-02 13:09:00', 'Thành công'),
(171, 220000, 'Thẻ ngân hàng', '2026-04-02 15:37:00', 'Thành công'),
(172, 220000, 'Ví điện tử', '2026-04-02 16:09:00', 'Thành công'),
(173, 520000, 'Thẻ ngân hàng', '2026-04-02 15:21:00', 'Thành công'),
(174, 220000, 'MoMo', '2026-04-02 15:01:00', 'Thành công'),
(175, 240000, 'Chuyển khoản', '2026-04-02 17:55:00', 'Thành công'),
(176, 480000, 'Tiền mặt', '2026-04-02 18:47:00', 'Thành công'),
(177, 240000, 'Thẻ ngân hàng', '2026-04-02 18:34:00', 'Thành công'),
(178, 240000, 'Tiền mặt', '2026-04-02 20:10:00', 'Thành công'),
(179, 240000, 'Ví điện tử', '2026-04-02 19:33:00', 'Thành công'),
(180, 204000, 'Thẻ ngân hàng', '2026-04-02 19:21:00', 'Thành công'),
(181, 120000, 'Ví điện tử', '2026-04-02 20:15:00', 'Thành công'),
(182, 500000, 'MoMo', '2026-04-02 10:14:00', 'Thành công'),
(183, 500000, 'MoMo', '2026-04-02 10:14:00', 'Thành công'),
(184, 345000, 'Ví điện tử', '2026-04-02 09:47:00', 'Thành công'),
(185, 405000, 'Chuyển khoản', '2026-04-02 14:10:00', 'Thành công'),
(186, 405000, 'Thẻ ngân hàng', '2026-04-02 13:41:00', 'Thành công'),
(187, 375000, 'Ví điện tử', '2026-04-02 12:34:00', 'Thành công'),
(188, 135000, 'MoMo', '2026-04-02 13:21:00', 'Thành công'),
(189, 405000, 'Ví điện tử', '2026-04-02 16:11:00', 'Thành công'),
(190, 530000, 'Thẻ ngân hàng', '2026-04-02 16:32:00', 'Thành công'),
(191, 190000, 'Thẻ ngân hàng', '2026-04-02 17:03:00', 'Thành công'),
(192, 493000, 'Thẻ ngân hàng', '2026-04-02 16:04:00', 'Thành công'),
(193, 145000, 'Tiền mặt', '2026-04-02 18:05:00', 'Thành công'),
(194, 435000, 'MoMo', '2026-04-02 21:28:00', 'Thành công'),
(195, 620000, 'MoMo', '2026-04-02 20:17:00', 'Thành công'),
(196, 620000, 'Thẻ ngân hàng', '2026-04-02 21:30:00', 'Thành công'),
(197, 135000, 'Tiền mặt', '2026-04-02 19:47:00', 'Thành công'),
(198, 465000, 'Ví điện tử', '2026-04-02 19:54:00', 'Thành công'),
(199, 155000, 'MoMo', '2026-04-02 20:17:00', 'Thành công'),
(200, 140000, 'Thẻ ngân hàng', '2026-04-02 08:18:00', 'Thành công'),
(201, 280000, 'Tiền mặt', '2026-04-02 07:34:00', 'Thành công'),
(202, 210000, 'Tiền mặt', '2026-04-02 08:34:00', 'Thành công'),
(203, 480000, 'MoMo', '2026-04-02 11:04:00', 'Thành công'),
(204, 299000, 'Ví điện tử', '2026-04-02 11:06:00', 'Thành công'),
(205, 160000, 'MoMo', '2026-04-02 10:29:00', 'Thành công'),
(206, 160000, 'MoMo', '2026-04-02 11:23:00', 'Thành công'),
(207, 240000, 'MoMo', '2026-04-02 09:42:00', 'Thành công'),
(208, 360000, 'Chuyển khoản', '2026-04-02 13:57:00', 'Thành công'),
(209, 270000, 'Thẻ ngân hàng', '2026-04-02 14:00:00', 'Thành công'),
(210, 360000, 'Tiền mặt', '2026-04-02 13:22:00', 'Thành công'),
(211, 400000, 'Ví điện tử', '2026-04-02 16:19:00', 'Thành công'),
(212, 569000, 'Chuyển khoản', '2026-04-02 17:55:00', 'Thành công'),
(213, 200000, 'Thẻ ngân hàng', '2026-04-02 16:56:00', 'Thành công'),
(214, 200000, 'Thẻ ngân hàng', '2026-04-02 15:56:00', 'Thành công'),
(215, 200000, 'Ví điện tử', '2026-04-02 18:15:00', 'Thành công'),
(216, 569000, 'Ví điện tử', '2026-04-02 17:12:00', 'Thành công'),
(217, 300000, 'MoMo', '2026-04-02 18:26:00', 'Thành công'),
(218, 200000, 'Ví điện tử', '2026-04-02 16:56:00', 'Thành công'),
(219, 340000, 'Ví điện tử', '2026-04-02 20:11:00', 'Thành công'),
(220, 270000, 'Tiền mặt', '2026-04-02 19:39:00', 'Thành công'),
(221, 559000, 'Ví điện tử', '2026-04-02 19:07:00', 'Thành công'),
(222, 102000, 'Ví điện tử', '2026-04-02 20:42:00', 'Thành công'),
(223, 180000, 'Thẻ ngân hàng', '2026-04-02 19:54:00', 'Thành công'),
(224, 298350, 'Tiền mặt', '2026-04-03 08:15:00', 'Thành công'),
(225, 114000, 'Ví điện tử', '2026-04-03 08:42:00', 'Thành công'),
(226, 334900, 'MoMo', '2026-04-03 07:44:00', 'Thành công'),
(227, 678000, 'Ví điện tử', '2026-04-03 08:13:00', 'Thành công'),
(228, 150000, 'Ví điện tử', '2026-04-03 08:19:00', 'Thành công'),
(229, 75000, 'MoMo', '2026-04-03 07:57:00', 'Thành công'),
(230, 255000, 'MoMo', '2026-04-03 11:29:00', 'Thành công'),
(231, 584000, 'MoMo', '2026-04-03 10:58:00', 'Thành công'),
(232, 509000, 'Tiền mặt', '2026-04-03 10:52:00', 'Thành công'),
(233, 170000, 'Ví điện tử', '2026-04-03 10:54:00', 'Thành công'),
(234, 340000, 'MoMo', '2026-04-03 10:21:00', 'Thành công'),
(235, 394000, 'Tiền mặt', '2026-04-03 11:26:00', 'Thành công'),
(236, 380000, 'Chuyển khoản', '2026-04-03 14:54:00', 'Thành công'),
(237, 190000, 'Chuyển khoản', '2026-04-03 14:42:00', 'Thành công'),
(238, 350000, 'Ví điện tử', '2026-04-03 14:09:00', 'Thành công'),
(239, 338300, 'Chuyển khoản', '2026-04-03 14:34:00', 'Thành công'),
(240, 134000, 'Ví điện tử', '2026-04-03 13:56:00', 'Thành công'),
(241, 359000, 'Thẻ ngân hàng', '2026-04-03 13:06:00', 'Thành công'),
(242, 190000, 'MoMo', '2026-04-03 14:27:00', 'Thành công'),
(243, 285000, 'Tiền mặt', '2026-04-03 13:34:00', 'Thành công'),
(244, 230000, 'Tiền mặt', '2026-04-03 18:34:00', 'Thành công'),
(245, 514000, 'Thẻ ngân hàng', '2026-04-03 18:18:00', 'Thành công'),
(246, 932450, 'Thẻ ngân hàng', '2026-04-03 17:23:00', 'Thành công'),
(247, 204000, 'Thẻ ngân hàng', '2026-04-03 18:21:00', 'Thành công'),
(248, 789000, 'Thẻ ngân hàng', '2026-04-03 18:24:00', 'Thành công'),
(249, 115000, 'Tiền mặt', '2026-04-03 16:47:00', 'Thành công'),
(250, 285000, 'Thẻ ngân hàng', '2026-04-03 19:07:00', 'Thành công'),
(251, 315000, 'MoMo', '2026-04-03 21:37:00', 'Thành công'),
(252, 210000, 'Ví điện tử', '2026-04-03 19:42:00', 'Thành công'),
(253, 599000, 'Thẻ ngân hàng', '2026-04-03 19:38:00', 'Thành công'),
(254, 105000, 'Tiền mặt', '2026-04-03 19:32:00', 'Thành công'),
(255, 683000, 'Ví điện tử', '2026-04-03 21:47:00', 'Thành công'),
(256, 315000, 'Tiền mặt', '2026-04-03 20:44:00', 'Thành công'),
(257, 80000, 'Tiền mặt', '2026-04-03 09:04:00', 'Thành công'),
(258, 633000, 'Tiền mặt', '2026-04-03 08:44:00', 'Thành công'),
(259, 160000, 'Ví điện tử', '2026-04-03 08:29:00', 'Thành công'),
(260, 458000, 'Chuyển khoản', '2026-04-03 09:14:00', 'Thành công'),
(261, 80000, 'MoMo', '2026-04-03 08:38:00', 'Thành công'),
(262, 360000, 'Tiền mặt', '2026-04-03 11:09:00', 'Thành công'),
(263, 240000, 'Thẻ ngân hàng', '2026-04-03 11:22:00', 'Thành công'),
(264, 349000, 'MoMo', '2026-04-03 11:49:00', 'Thành công'),
(265, 270000, 'Ví điện tử', '2026-04-03 12:14:00', 'Thành công'),
(266, 180000, 'MoMo', '2026-04-03 11:43:00', 'Thành công'),
(267, 180000, 'Ví điện tử', '2026-04-03 11:20:00', 'Thành công'),
(268, 270000, 'Thẻ ngân hàng', '2026-04-03 12:42:00', 'Thành công'),
(269, 729000, 'Ví điện tử', '2026-04-03 15:46:00', 'Thành công'),
(270, 539000, 'Ví điện tử', '2026-04-03 14:30:00', 'Thành công'),
(271, 314000, 'Chuyển khoản', '2026-04-03 13:21:00', 'Thành công'),
(272, 369000, 'MoMo', '2026-04-03 15:35:00', 'Thành công'),
(273, 499000, 'MoMo', '2026-04-03 13:55:00', 'Thành công'),
(274, 529000, 'MoMo', '2026-04-03 17:56:00', 'Thành công'),
(275, 360000, 'Thẻ ngân hàng', '2026-04-03 18:13:00', 'Thành công'),
(276, 240000, 'Ví điện tử', '2026-04-03 18:13:00', 'Thành công'),
(277, 331000, 'MoMo', '2026-04-03 17:51:00', 'Thành công'),
(278, 240000, 'Thẻ ngân hàng', '2026-04-03 19:05:00', 'Thành công'),
(279, 649000, 'Chuyển khoản', '2026-04-03 18:30:00', 'Thành công'),
(280, 430000, 'Tiền mặt', '2026-04-03 18:13:00', 'Thành công'),
(281, 120000, 'Chuyển khoản', '2026-04-03 18:08:00', 'Thành công'),
(282, 390000, 'Thẻ ngân hàng', '2026-04-03 20:06:00', 'Thành công'),
(283, 200000, 'Thẻ ngân hàng', '2026-04-03 21:02:00', 'Thành công'),
(284, 769000, 'Ví điện tử', '2026-04-03 21:42:00', 'Thành công'),
(285, 315000, 'Thẻ ngân hàng', '2026-04-03 22:14:00', 'Thành công'),
(286, 609000, 'Chuyển khoản', '2026-04-03 21:46:00', 'Thành công'),
(287, 199000, 'MoMo', '2026-04-03 20:14:00', 'Thành công'),
(288, 180000, 'Chuyển khoản', '2026-04-03 09:43:00', 'Thành công'),
(289, 360000, 'Chuyển khoản', '2026-04-03 09:51:00', 'Thành công'),
(290, 180000, 'MoMo', '2026-04-03 09:08:00', 'Thành công'),
(291, 180000, 'Chuyển khoản', '2026-04-03 09:23:00', 'Thành công'),
(292, 307000, 'MoMo', '2026-04-03 09:06:00', 'Thành công'),
(293, 330000, 'Tiền mặt', '2026-04-03 09:18:00', 'Thành công'),
(294, 90000, 'Chuyển khoản', '2026-04-03 08:52:00', 'Thành công'),
(295, 400000, 'MoMo', '2026-04-03 13:20:00', 'Thành công'),
(296, 350000, 'Tiền mặt', '2026-04-03 11:59:00', 'Thành công'),
(297, 200000, 'Ví điện tử', '2026-04-03 12:57:00', 'Thành công'),
(298, 220000, 'Thẻ ngân hàng', '2026-04-03 15:20:00', 'Thành công'),
(299, 639000, 'MoMo', '2026-04-03 14:27:00', 'Thành công'),
(300, 220000, 'Chuyển khoản', '2026-04-03 15:12:00', 'Thành công'),
(301, 739000, 'Thẻ ngân hàng', '2026-04-03 15:07:00', 'Thành công'),
(302, 220000, 'Chuyển khoản', '2026-04-03 15:48:00', 'Thành công'),
(303, 142000, 'Tiền mặt', '2026-04-03 15:41:00', 'Thành công'),
(304, 280500, 'Ví điện tử', '2026-04-03 15:35:00', 'Thành công'),
(305, 419000, 'Tiền mặt', '2026-04-03 15:37:00', 'Thành công'),
(306, 220000, 'MoMo', '2026-04-03 15:06:00', 'Thành công'),
(307, 142000, 'MoMo', '2026-04-03 14:33:00', 'Thành công'),
(308, 260000, 'Chuyển khoản', '2026-04-03 19:13:00', 'Thành công'),
(309, 520000, 'MoMo', '2026-04-03 19:25:00', 'Thành công'),
(310, 130000, 'MoMo', '2026-04-03 19:10:00', 'Thành công'),
(311, 650000, 'MoMo', '2026-04-03 19:42:00', 'Thành công'),
(312, 355000, 'Tiền mặt', '2026-04-03 19:00:00', 'Thành công'),
(313, 600000, 'Ví điện tử', '2026-04-03 20:06:00', 'Thành công'),
(314, 459000, 'MoMo', '2026-04-03 18:02:00', 'Thành công'),
(315, 419000, 'Ví điện tử', '2026-04-03 09:53:00', 'Thành công'),
(316, 250000, 'MoMo', '2026-04-03 09:39:00', 'Thành công'),
(317, 419000, 'Tiền mặt', '2026-04-03 10:20:00', 'Thành công'),
(318, 375000, 'Thẻ ngân hàng', '2026-04-03 10:29:00', 'Thành công'),
(319, 540000, 'Thẻ ngân hàng', '2026-04-03 14:33:00', 'Thành công'),
(320, 405000, 'Chuyển khoản', '2026-04-03 12:14:00', 'Thành công'),
(321, 405000, 'Chuyển khoản', '2026-04-03 13:30:00', 'Thành công'),
(322, 270000, 'MoMo', '2026-04-03 13:35:00', 'Thành công'),
(323, 135000, 'Chuyển khoản', '2026-04-03 12:24:00', 'Thành công'),
(324, 664000, 'MoMo', '2026-04-03 18:03:00', 'Thành công'),
(325, 590000, 'Ví điện tử', '2026-04-03 16:21:00', 'Thành công'),
(326, 620000, 'Thẻ ngân hàng', '2026-04-03 17:07:00', 'Thành công'),
(327, 155000, 'MoMo', '2026-04-03 16:17:00', 'Thành công'),
(328, 310000, 'Thẻ ngân hàng', '2026-04-03 17:17:00', 'Thành công'),
(329, 811000, 'Chuyển khoản', '2026-04-03 21:03:00', 'Thành công'),
(330, 989000, 'Ví điện tử', '2026-04-03 20:49:00', 'Thành công'),
(331, 495000, 'Ví điện tử', '2026-04-03 21:43:00', 'Thành công'),
(332, 140250, 'Thẻ ngân hàng', '2026-04-03 21:30:00', 'Thành công'),
(333, 230000, 'Ví điện tử', '2026-04-03 21:30:00', 'Thành công'),
(334, 165000, 'MoMo', '2026-04-03 20:01:00', 'Thành công'),
(335, 210000, 'Chuyển khoản', '2026-04-03 07:34:00', 'Thành công'),
(336, 140000, 'MoMo', '2026-04-03 08:10:00', 'Thành công'),
(337, 210000, 'MoMo', '2026-04-03 08:11:00', 'Thành công'),
(338, 165000, 'MoMo', '2026-04-03 07:55:00', 'Thành công'),
(339, 320000, 'Thẻ ngân hàng', '2026-04-03 10:02:00', 'Thành công'),
(340, 290000, 'Chuyển khoản', '2026-04-03 11:21:00', 'Thành công'),
(341, 80000, 'MoMo', '2026-04-03 11:52:00', 'Thành công'),
(342, 561000, 'Chuyển khoản', '2026-04-03 14:29:00', 'Thành công'),
(343, 559000, 'Chuyển khoản', '2026-04-03 15:03:00', 'Thành công'),
(344, 270000, 'Chuyển khoản', '2026-04-03 13:28:00', 'Thành công'),
(345, 90000, 'MoMo', '2026-04-03 14:41:00', 'Thành công'),
(346, 450000, 'Tiền mặt', '2026-04-03 14:08:00', 'Thành công'),
(347, 410000, 'MoMo', '2026-04-03 18:03:00', 'Thành công'),
(348, 550000, 'Tiền mặt', '2026-04-03 17:18:00', 'Thành công'),
(349, 419000, 'MoMo', '2026-04-03 16:32:00', 'Thành công'),
(350, 110000, 'MoMo', '2026-04-03 15:48:00', 'Thành công'),
(351, 440000, 'Tiền mặt', '2026-04-03 17:08:00', 'Thành công'),
(352, 440000, 'Ví điện tử', '2026-04-03 15:46:00', 'Thành công'),
(353, 330000, 'Thẻ ngân hàng', '2026-04-03 17:29:00', 'Thành công'),
(354, 110000, 'MoMo', '2026-04-03 17:10:00', 'Thành công'),
(355, 380000, 'Chuyển khoản', '2026-04-03 19:49:00', 'Thành công'),
(356, 369000, 'Thẻ ngân hàng', '2026-04-03 20:41:00', 'Thành công'),
(357, 180000, 'Chuyển khoản', '2026-04-03 20:09:00', 'Thành công'),
(358, 369000, 'Ví điện tử', '2026-04-03 18:57:00', 'Thành công'),
(359, 180000, 'MoMo', '2026-04-03 21:08:00', 'Thành công'),
(360, 289000, 'Ví điện tử', '2026-04-03 20:30:00', 'Thành công'),
(361, 450000, 'Thẻ ngân hàng', '2026-04-03 20:54:00', 'Thành công'),
(362, 132000, 'Chuyển khoản', '2026-04-03 21:02:00', 'Thành công'),
(363, 480000, 'Ví điện tử', '2026-04-04 08:15:00', 'Thành công'),
(364, 340000, 'MoMo', '2026-04-04 08:45:00', 'Thành công'),
(365, 170000, 'MoMo', '2026-04-04 08:39:00', 'Thành công'),
(366, 174000, 'MoMo', '2026-04-04 08:42:00', 'Thành công'),
(367, 285000, 'Thẻ ngân hàng', '2026-04-04 11:52:00', 'Thành công'),
(368, 679000, 'Ví điện tử', '2026-04-04 10:30:00', 'Thành công'),
(369, 190000, 'MoMo', '2026-04-04 11:25:00', 'Thành công'),
(370, 190000, 'Thẻ ngân hàng', '2026-04-04 11:25:00', 'Thành công'),
(371, 95000, 'Tiền mặt', '2026-04-04 10:42:00', 'Thành công'),
(372, 475000, 'Ví điện tử', '2026-04-04 09:45:00', 'Thành công'),
(373, 190000, 'Tiền mặt', '2026-04-04 11:57:00', 'Thành công'),
(374, 190000, 'Chuyển khoản', '2026-04-04 11:04:00', 'Thành công'),
(375, 285000, 'MoMo', '2026-04-04 11:57:00', 'Thành công'),
(376, 315000, 'Tiền mặt', '2026-04-04 13:31:00', 'Thành công'),
(377, 420000, 'Ví điện tử', '2026-04-04 12:53:00', 'Thành công'),
(378, 283500, 'MoMo', '2026-04-04 15:03:00', 'Thành công'),
(379, 388000, 'Thẻ ngân hàng', '2026-04-04 13:50:00', 'Thành công'),
(380, 420000, 'MoMo', '2026-04-04 13:14:00', 'Thành công'),
(381, 315000, 'Chuyển khoản', '2026-04-04 13:37:00', 'Thành công'),
(382, 690000, 'Thẻ ngân hàng', '2026-04-04 18:02:00', 'Thành công'),
(383, 310500, 'Thẻ ngân hàng', '2026-04-04 17:28:00', 'Thành công'),
(384, 639500, 'MoMo', '2026-04-04 18:21:00', 'Thành công'),
(385, 638000, 'Ví điện tử', '2026-04-04 17:51:00', 'Thành công'),
(386, 321000, 'Tiền mặt', '2026-04-04 16:31:00', 'Thành công'),
(387, 178500, 'Ví điện tử', '2026-04-04 19:59:00', 'Thành công'),
(388, 567000, 'Chuyển khoản', '2026-04-04 21:13:00', 'Thành công'),
(389, 370000, 'Thẻ ngân hàng', '2026-04-04 19:16:00', 'Thành công'),
(390, 105000, 'Chuyển khoản', '2026-04-04 21:42:00', 'Thành công'),
(391, 370000, 'Ví điện tử', '2026-04-04 21:10:00', 'Thành công'),
(392, 420000, 'Chuyển khoản', '2026-04-04 20:14:00', 'Thành công'),
(393, 315000, 'Tiền mặt', '2026-04-04 21:11:00', 'Thành công'),
(394, 285000, 'Tiền mặt', '2026-04-04 20:37:00', 'Thành công'),
(395, 708000, 'Tiền mặt', '2026-04-04 20:02:00', 'Thành công'),
(396, 210000, 'Thẻ ngân hàng', '2026-04-04 21:48:00', 'Thành công'),
(397, 295000, 'Tiền mặt', '2026-04-04 20:51:00', 'Thành công'),
(398, 105000, 'MoMo', '2026-04-04 20:32:00', 'Thành công'),
(399, 135000, 'Ví điện tử', '2026-04-04 21:19:00', 'Thành công'),
(400, 306000, 'Tiền mặt', '2026-04-04 08:36:00', 'Thành công'),
(401, 815000, 'MoMo', '2026-04-04 08:30:00', 'Thành công'),
(402, 349000, 'Ví điện tử', '2026-04-04 08:46:00', 'Thành công'),
(403, 129000, 'Ví điện tử', '2026-04-04 08:38:00', 'Thành công'),
(404, 180000, 'Chuyển khoản', '2026-04-04 11:26:00', 'Thành công'),
(405, 613000, 'MoMo', '2026-04-04 11:37:00', 'Thành công'),
(406, 300000, 'Tiền mặt', '2026-04-04 12:07:00', 'Thành công'),
(407, 300000, 'Chuyển khoản', '2026-04-04 11:53:00', 'Thành công'),
(408, 379000, 'Chuyển khoản', '2026-04-04 12:34:00', 'Thành công'),
(409, 220000, 'Ví điện tử', '2026-04-04 15:13:00', 'Thành công'),
(410, 220000, 'Chuyển khoản', '2026-04-04 13:48:00', 'Thành công'),
(411, 660000, 'Chuyển khoản', '2026-04-04 14:59:00', 'Thành công'),
(412, 220000, 'MoMo', '2026-04-04 15:29:00', 'Thành công'),
(413, 220000, 'Thẻ ngân hàng', '2026-04-04 15:32:00', 'Thành công'),
(414, 220000, 'Thẻ ngân hàng', '2026-04-04 14:56:00', 'Thành công'),
(415, 240000, 'Chuyển khoản', '2026-04-04 16:38:00', 'Thành công'),
(416, 529000, 'Chuyển khoản', '2026-04-04 16:50:00', 'Thành công'),
(417, 529000, 'Tiền mặt', '2026-04-04 17:01:00', 'Thành công'),
(418, 120000, 'Ví điện tử', '2026-04-04 16:44:00', 'Thành công'),
(419, 360000, 'Thẻ ngân hàng', '2026-04-04 17:10:00', 'Thành công'),
(420, 360000, 'Ví điện tử', '2026-04-04 19:06:00', 'Thành công'),
(421, 600000, 'Tiền mặt', '2026-04-04 16:57:00', 'Thành công'),
(422, 360000, 'Thẻ ngân hàng', '2026-04-04 17:56:00', 'Thành công'),
(423, 209000, 'MoMo', '2026-04-04 16:55:00', 'Thành công'),
(424, 409000, 'MoMo', '2026-04-04 19:09:00', 'Thành công'),
(425, 390000, 'Tiền mặt', '2026-04-04 20:49:00', 'Thành công'),
(426, 630000, 'MoMo', '2026-04-04 21:03:00', 'Thành công'),
(427, 198000, 'MoMo', '2026-04-04 21:12:00', 'Thành công'),
(428, 220000, 'MoMo', '2026-04-04 20:52:00', 'Thành công'),
(429, 859000, 'MoMo', '2026-04-04 20:30:00', 'Thành công'),
(430, 110000, 'Thẻ ngân hàng', '2026-04-04 20:01:00', 'Thành công'),
(431, 330000, 'Tiền mặt', '2026-04-04 20:26:00', 'Thành công'),
(432, 330000, 'Tiền mặt', '2026-04-04 21:59:00', 'Thành công'),
(433, 399000, 'Thẻ ngân hàng', '2026-04-04 09:45:00', 'Thành công'),
(434, 400000, 'Chuyển khoản', '2026-04-04 09:38:00', 'Thành công'),
(435, 370000, 'Ví điện tử', '2026-04-04 09:56:00', 'Thành công'),
(436, 295000, 'MoMo', '2026-04-04 10:05:00', 'Thành công'),
(437, 600000, 'Thẻ ngân hàng', '2026-04-04 08:58:00', 'Thành công'),
(438, 609000, 'Tiền mặt', '2026-04-04 12:11:00', 'Thành công'),
(439, 610000, 'Ví điện tử', '2026-04-04 13:03:00', 'Thành công'),
(440, 220000, 'Ví điện tử', '2026-04-04 12:55:00', 'Thành công'),
(441, 220000, 'MoMo', '2026-04-04 13:11:00', 'Thành công'),
(442, 110000, 'MoMo', '2026-04-04 11:07:00', 'Thành công'),
(443, 480000, 'Ví điện tử', '2026-04-04 15:14:00', 'Thành công'),
(444, 721000, 'MoMo', '2026-04-04 14:16:00', 'Thành công'),
(445, 204000, 'Tiền mặt', '2026-04-04 16:42:00', 'Thành công'),
(446, 159000, 'Ví điện tử', '2026-04-04 15:14:00', 'Thành công'),
(447, 335000, 'Ví điện tử', '2026-04-04 15:58:00', 'Thành công'),
(448, 360000, 'Tiền mặt', '2026-04-04 14:39:00', 'Thành công'),
(449, 619000, 'Chuyển khoản', '2026-04-04 15:26:00', 'Thành công'),
(450, 216000, 'Chuyển khoản', '2026-04-04 14:30:00', 'Thành công'),
(451, 689000, 'Chuyển khoản', '2026-04-04 16:26:00', 'Thành công'),
(452, 653000, 'Thẻ ngân hàng', '2026-04-04 16:52:00', 'Thành công'),
(453, 490000, 'Tiền mặt', '2026-04-04 19:54:00', 'Thành công'),
(454, 260000, 'Tiền mặt', '2026-04-04 18:05:00', 'Thành công'),
(455, 260000, 'Chuyển khoản', '2026-04-04 18:32:00', 'Thành công'),
(456, 390000, 'Chuyển khoản', '2026-04-04 18:43:00', 'Thành công'),
(457, 130000, 'Chuyển khoản', '2026-04-04 18:35:00', 'Thành công'),
(458, 621000, 'MoMo', '2026-04-04 18:35:00', 'Thành công'),
(459, 470000, 'Ví điện tử', '2026-04-04 19:04:00', 'Thành công'),
(460, 390000, 'Tiền mặt', '2026-04-04 19:44:00', 'Thành công'),
(461, 461000, 'Chuyển khoản', '2026-04-04 18:22:00', 'Thành công'),
(462, 470000, 'Chuyển khoản', '2026-04-04 19:41:00', 'Thành công'),
(463, 162000, 'Ví điện tử', '2026-04-04 20:15:00', 'Thành công'),
(464, 375000, 'Chuyển khoản', '2026-04-04 10:15:00', 'Thành công'),
(465, 659000, 'MoMo', '2026-04-04 09:46:00', 'Thành công'),
(466, 270000, 'Tiền mặt', '2026-04-04 10:20:00', 'Thành công'),
(467, 405000, 'MoMo', '2026-04-04 10:34:00', 'Thành công'),
(468, 405000, 'Ví điện tử', '2026-04-04 10:35:00', 'Thành công'),
(469, 145000, 'Ví điện tử', '2026-04-04 14:25:00', 'Thành công'),
(470, 652500, 'Ví điện tử', '2026-04-04 12:19:00', 'Thành công'),
(471, 909000, 'Chuyển khoản', '2026-04-04 12:11:00', 'Thành công'),
(472, 260000, 'Chuyển khoản', '2026-04-04 14:08:00', 'Thành công'),
(473, 620000, 'Chuyển khoản', '2026-04-04 17:16:00', 'Thành công'),
(474, 590000, 'Chuyển khoản', '2026-04-04 16:46:00', 'Thành công'),
(475, 279000, 'Chuyển khoản', '2026-04-04 17:02:00', 'Thành công'),
(476, 369000, 'Ví điện tử', '2026-04-04 17:31:00', 'Thành công'),
(477, 900000, 'Chuyển khoản', '2026-04-04 18:15:00', 'Thành công'),
(478, 310000, 'Tiền mặt', '2026-04-04 18:20:00', 'Thành công'),
(479, 620000, 'Thẻ ngân hàng', '2026-04-04 16:22:00', 'Thành công'),
(480, 899000, 'Chuyển khoản', '2026-04-04 16:38:00', 'Thành công'),
(481, 479000, 'Thẻ ngân hàng', '2026-04-04 16:30:00', 'Thành công'),
(482, 610000, 'Thẻ ngân hàng', '2026-04-04 19:38:00', 'Thành công'),
(483, 640000, 'Ví điện tử', '2026-04-04 20:39:00', 'Thành công'),
(484, 660000, 'MoMo', '2026-04-04 21:53:00', 'Thành công'),
(485, 495000, 'Tiền mặt', '2026-04-04 21:49:00', 'Thành công'),
(486, 495000, 'Chuyển khoản', '2026-04-04 20:42:00', 'Thành công'),
(487, 480000, 'Ví điện tử', '2026-04-04 08:29:00', 'Thành công'),
(488, 160000, 'Ví điện tử', '2026-04-04 08:14:00', 'Thành công'),
(489, 360000, 'Ví điện tử', '2026-04-04 11:14:00', 'Thành công'),
(490, 240000, 'Chuyển khoản', '2026-04-04 09:58:00', 'Thành công'),
(491, 420000, 'Ví điện tử', '2026-04-04 10:25:00', 'Thành công'),
(492, 360000, 'Thẻ ngân hàng', '2026-04-04 11:42:00', 'Thành công'),
(493, 349000, 'MoMo', '2026-04-04 10:03:00', 'Thành công'),
(494, 180000, 'Ví điện tử', '2026-04-04 10:48:00', 'Thành công'),
(495, 319000, 'MoMo', '2026-04-04 11:01:00', 'Thành công'),
(496, 379000, 'MoMo', '2026-04-04 14:35:00', 'Thành công'),
(497, 300000, 'Ví điện tử', '2026-04-04 13:04:00', 'Thành công'),
(498, 270000, 'MoMo', '2026-04-04 13:05:00', 'Thành công'),
(499, 180000, 'Tiền mặt', '2026-04-04 13:29:00', 'Thành công'),
(500, 200000, 'Tiền mặt', '2026-04-04 14:48:00', 'Thành công'),
(501, 360000, 'Ví điện tử', '2026-04-04 13:20:00', 'Thành công'),
(502, 400000, 'Thẻ ngân hàng', '2026-04-04 13:59:00', 'Thành công'),
(503, 100000, 'Chuyển khoản', '2026-04-04 14:32:00', 'Thành công'),
(504, 180000, 'Chuyển khoản', '2026-04-04 13:10:00', 'Thành công'),
(505, 100000, 'Thẻ ngân hàng', '2026-04-04 12:28:00', 'Thành công'),
(506, 300000, 'Tiền mặt', '2026-04-04 13:10:00', 'Thành công'),
(507, 609000, 'Tiền mặt', '2026-04-04 17:39:00', 'Thành công'),
(508, 110000, 'Tiền mặt', '2026-04-04 16:15:00', 'Thành công'),
(509, 440000, 'Ví điện tử', '2026-04-04 17:59:00', 'Thành công'),
(510, 389000, 'Tiền mặt', '2026-04-04 16:32:00', 'Thành công'),
(511, 110000, 'Tiền mặt', '2026-04-04 17:02:00', 'Thành công'),
(512, 550000, 'Ví điện tử', '2026-04-04 17:14:00', 'Thành công'),
(513, 330000, 'Chuyển khoản', '2026-04-04 18:01:00', 'Thành công'),
(514, 220000, 'Thẻ ngân hàng', '2026-04-04 17:28:00', 'Thành công'),
(515, 279000, 'Tiền mặt', '2026-04-04 17:25:00', 'Thành công'),
(516, 520000, 'Thẻ ngân hàng', '2026-04-04 16:34:00', 'Thành công'),
(517, 440000, 'Thẻ ngân hàng', '2026-04-04 18:23:00', 'Thành công'),
(518, 629000, 'Chuyển khoản', '2026-04-04 20:31:00', 'Thành công'),
(519, 100000, 'Chuyển khoản', '2026-04-04 19:40:00', 'Thành công'),
(520, 200000, 'MoMo', '2026-04-04 21:20:00', 'Thành công'),
(521, 200000, 'Tiền mặt', '2026-04-04 19:46:00', 'Thành công'),
(522, 729000, 'Tiền mặt', '2026-04-04 20:49:00', 'Thành công'),
(523, 370000, 'Tiền mặt', '2026-04-04 19:07:00', 'Thành công'),
(524, 200000, 'MoMo', '2026-04-04 20:22:00', 'Thành công'),
(525, 340000, 'Thẻ ngân hàng', '2026-04-05 07:52:00', 'Thành công'),
(526, 584000, 'MoMo', '2026-04-05 08:26:00', 'Thành công'),
(527, 161500, 'Tiền mặt', '2026-04-05 10:03:00', 'Thành công'),
(528, 285000, 'MoMo', '2026-04-05 12:01:00', 'Thành công'),
(529, 140000, 'MoMo', '2026-04-05 10:38:00', 'Thành công'),
(530, 380000, 'Ví điện tử', '2026-04-05 09:44:00', 'Thành công'),
(531, 190000, 'MoMo', '2026-04-05 12:00:00', 'Thành công'),
(532, 95000, 'Ví điện tử', '2026-04-05 11:16:00', 'Thành công'),
(533, 420000, 'Ví điện tử', '2026-04-05 14:45:00', 'Thành công'),
(534, 589000, 'Ví điện tử', '2026-04-05 13:52:00', 'Thành công'),
(535, 315000, 'MoMo', '2026-04-05 15:13:00', 'Thành công'),
(536, 105000, 'Ví điện tử', '2026-04-05 14:01:00', 'Thành công'),
(537, 495000, 'Thẻ ngân hàng', '2026-04-05 15:15:00', 'Thành công'),
(538, 370000, 'MoMo', '2026-04-05 13:02:00', 'Thành công'),
(539, 409000, 'MoMo', '2026-04-05 12:44:00', 'Thành công'),
(540, 644000, 'Ví điện tử', '2026-04-05 17:59:00', 'Thành công'),
(541, 230000, 'MoMo', '2026-04-05 18:13:00', 'Thành công'),
(542, 859000, 'Ví điện tử', '2026-04-05 18:18:00', 'Thành công'),
(543, 115000, 'Tiền mặt', '2026-04-05 18:00:00', 'Thành công'),
(544, 230000, 'MoMo', '2026-04-05 16:26:00', 'Thành công'),
(545, 774000, 'Tiền mặt', '2026-04-05 18:17:00', 'Thành công'),
(546, 230000, 'MoMo', '2026-04-05 17:40:00', 'Thành công'),
(547, 345000, 'MoMo', '2026-04-05 17:27:00', 'Thành công'),
(548, 484000, 'Ví điện tử', '2026-04-05 19:58:00', 'Thành công'),
(549, 357000, 'MoMo', '2026-04-05 20:44:00', 'Thành công'),
(550, 420000, 'Chuyển khoản', '2026-04-05 20:27:00', 'Thành công'),
(551, 105000, 'Tiền mặt', '2026-04-05 21:48:00', 'Thành công'),
(552, 420000, 'Ví điện tử', '2026-04-05 19:18:00', 'Thành công'),
(553, 210000, 'Ví điện tử', '2026-04-05 21:45:00', 'Thành công'),
(554, 105000, 'Ví điện tử', '2026-04-05 19:56:00', 'Thành công'),
(555, 243000, 'Chuyển khoản', '2026-04-05 09:10:00', 'Thành công'),
(556, 623000, 'Chuyển khoản', '2026-04-05 08:54:00', 'Thành công'),
(557, 240000, 'Tiền mặt', '2026-04-05 08:26:00', 'Thành công'),
(558, 200000, 'Chuyển khoản', '2026-04-05 11:07:00', 'Thành công'),
(559, 200000, 'Chuyển khoản', '2026-04-05 11:17:00', 'Thành công'),
(560, 300000, 'Ví điện tử', '2026-04-05 12:36:00', 'Thành công'),
(561, 500000, 'Ví điện tử', '2026-04-05 10:32:00', 'Thành công'),
(562, 340000, 'Chuyển khoản', '2026-04-05 10:19:00', 'Thành công'),
(563, 100000, 'MoMo', '2026-04-05 11:36:00', 'Thành công'),
(564, 669000, 'Thẻ ngân hàng', '2026-04-05 15:54:00', 'Thành công'),
(565, 374000, 'Ví điện tử', '2026-04-05 14:51:00', 'Thành công'),
(566, 330000, 'MoMo', '2026-04-05 15:53:00', 'Thành công'),
(567, 529000, 'Ví điện tử', '2026-04-05 15:50:00', 'Thành công'),
(568, 360000, 'Ví điện tử', '2026-04-05 16:33:00', 'Thành công'),
(569, 649000, 'Chuyển khoản', '2026-04-05 18:08:00', 'Thành công'),
(570, 330000, 'Ví điện tử', '2026-04-05 17:36:00', 'Thành công'),
(571, 409000, 'MoMo', '2026-04-05 17:04:00', 'Thành công'),
(572, 480000, 'Chuyển khoản', '2026-04-05 17:26:00', 'Thành công'),
(573, 480000, 'MoMo', '2026-04-05 16:34:00', 'Thành công'),
(574, 809000, 'Thẻ ngân hàng', '2026-04-05 17:14:00', 'Thành công'),
(575, 601000, 'Chuyển khoản', '2026-04-05 16:45:00', 'Thành công'),
(576, 200000, 'Thẻ ngân hàng', '2026-04-05 20:51:00', 'Thành công'),
(577, 297000, 'Thẻ ngân hàng', '2026-04-05 20:56:00', 'Thành công'),
(578, 440000, 'Tiền mặt', '2026-04-05 21:05:00', 'Thành công'),
(579, 300000, 'Thẻ ngân hàng', '2026-04-05 21:43:00', 'Thành công'),
(580, 639000, 'Ví điện tử', '2026-04-05 20:52:00', 'Thành công'),
(581, 110000, 'Chuyển khoản', '2026-04-05 20:27:00', 'Thành công'),
(582, 189000, 'MoMo', '2026-04-05 09:55:00', 'Thành công'),
(583, 679000, 'Chuyển khoản', '2026-04-05 08:52:00', 'Thành công'),
(584, 400000, 'Tiền mặt', '2026-04-05 10:01:00', 'Thành công'),
(585, 300000, 'MoMo', '2026-04-05 08:50:00', 'Thành công'),
(586, 200000, 'Thẻ ngân hàng', '2026-04-05 09:28:00', 'Thành công'),
(587, 410000, 'Tiền mặt', '2026-04-05 11:40:00', 'Thành công'),
(588, 440000, 'Thẻ ngân hàng', '2026-04-05 11:02:00', 'Thành công'),
(589, 609000, 'Thẻ ngân hàng', '2026-04-05 12:35:00', 'Thành công'),
(590, 769000, 'Tiền mặt', '2026-04-05 12:23:00', 'Thành công'),
(591, 330000, 'Tiền mặt', '2026-04-05 15:58:00', 'Thành công'),
(592, 858000, 'Chuyển khoản', '2026-04-05 16:36:00', 'Thành công'),
(593, 330000, 'Ví điện tử', '2026-04-05 14:48:00', 'Thành công'),
(594, 240000, 'Chuyển khoản', '2026-04-05 16:32:00', 'Thành công'),
(595, 480000, 'Chuyển khoản', '2026-04-05 15:03:00', 'Thành công'),
(596, 600000, 'Thẻ ngân hàng', '2026-04-05 16:00:00', 'Thành công'),
(597, 260000, 'MoMo', '2026-04-05 20:09:00', 'Thành công'),
(598, 260000, 'Ví điện tử', '2026-04-05 19:56:00', 'Thành công'),
(599, 162000, 'Ví điện tử', '2026-04-05 18:37:00', 'Thành công'),
(600, 490000, 'Thẻ ngân hàng', '2026-04-05 18:28:00', 'Thành công'),
(601, 390000, 'Thẻ ngân hàng', '2026-04-05 19:28:00', 'Thành công'),
(602, 390000, 'Ví điện tử', '2026-04-05 18:01:00', 'Thành công'),
(603, 520000, 'Thẻ ngân hàng', '2026-04-05 18:07:00', 'Thành công'),
(604, 260000, 'Thẻ ngân hàng', '2026-04-05 19:24:00', 'Thành công'),
(605, 390000, 'Chuyển khoản', '2026-04-05 18:34:00', 'Thành công'),
(606, 589000, 'Tiền mặt', '2026-04-05 20:09:00', 'Thành công'),
(607, 405000, 'Ví điện tử', '2026-04-05 10:18:00', 'Thành công'),
(608, 490000, 'Ví điện tử', '2026-04-05 10:05:00', 'Thành công'),
(609, 270000, 'Ví điện tử', '2026-04-05 09:51:00', 'Thành công'),
(610, 405000, 'Tiền mặt', '2026-04-05 10:21:00', 'Thành công'),
(611, 540000, 'MoMo', '2026-04-05 09:37:00', 'Thành công'),
(612, 167000, 'Chuyển khoản', '2026-04-05 10:03:00', 'Thành công'),
(613, 870000, 'Ví điện tử', '2026-04-05 14:21:00', 'Thành công'),
(614, 580000, 'Thẻ ngân hàng', '2026-04-05 14:21:00', 'Thành công'),
(615, 145000, 'MoMo', '2026-04-05 13:40:00', 'Thành công'),
(616, 145000, 'MoMo', '2026-04-05 13:37:00', 'Thành công'),
(617, 405000, 'Thẻ ngân hàng', '2026-04-05 13:31:00', 'Thành công'),
(618, 725000, 'Tiền mặt', '2026-04-05 16:55:00', 'Thành công'),
(619, 775000, 'Ví điện tử', '2026-04-05 16:49:00', 'Thành công'),
(620, 279000, 'Ví điện tử', '2026-04-05 17:35:00', 'Thành công'),
(621, 757000, 'MoMo', '2026-04-05 17:27:00', 'Thành công'),
(622, 310000, 'MoMo', '2026-04-05 20:58:00', 'Thành công'),
(623, 825000, 'Ví điện tử', '2026-04-05 20:52:00', 'Thành công'),
(624, 775000, 'Ví điện tử', '2026-04-05 21:29:00', 'Thành công'),
(625, 660000, 'Thẻ ngân hàng', '2026-04-05 21:17:00', 'Thành công'),
(626, 240000, 'Thẻ ngân hàng', '2026-04-05 07:28:00', 'Thành công'),
(627, 400000, 'Ví điện tử', '2026-04-05 08:25:00', 'Thành công'),
(628, 240000, 'Ví điện tử', '2026-04-05 08:00:00', 'Thành công'),
(629, 330000, 'Tiền mặt', '2026-04-05 09:58:00', 'Thành công'),
(630, 450000, 'MoMo', '2026-04-05 09:28:00', 'Thành công'),
(631, 180000, 'MoMo', '2026-04-05 09:21:00', 'Thành công'),
(632, 135000, 'MoMo', '2026-04-05 09:39:00', 'Thành công'),
(633, 815000, 'Tiền mặt', '2026-04-05 09:43:00', 'Thành công'),
(634, 180000, 'Thẻ ngân hàng', '2026-04-05 10:37:00', 'Thành công'),
(635, 189000, 'Chuyển khoản', '2026-04-05 13:59:00', 'Thành công'),
(636, 200000, 'MoMo', '2026-04-05 14:50:00', 'Thành công'),
(637, 370000, 'Chuyển khoản', '2026-04-05 13:05:00', 'Thành công'),
(638, 370000, 'Ví điện tử', '2026-04-05 14:33:00', 'Thành công'),
(639, 145000, 'Thẻ ngân hàng', '2026-04-05 13:07:00', 'Thành công'),
(640, 295000, 'MoMo', '2026-04-05 12:57:00', 'Thành công'),
(641, 198000, 'MoMo', '2026-04-05 17:55:00', 'Thành công'),
(642, 110000, 'Chuyển khoản', '2026-04-05 16:48:00', 'Thành công'),
(643, 110000, 'Ví điện tử', '2026-04-05 15:41:00', 'Thành công'),
(644, 440000, 'Chuyển khoản', '2026-04-05 17:38:00', 'Thành công'),
(645, 440000, 'Ví điện tử', '2026-04-05 17:54:00', 'Thành công'),
(646, 220000, 'Thẻ ngân hàng', '2026-04-05 17:52:00', 'Thành công'),
(647, 142000, 'Thẻ ngân hàng', '2026-04-05 17:00:00', 'Thành công'),
(648, 659000, 'MoMo', '2026-04-05 15:49:00', 'Thành công'),
(649, 440000, 'Ví điện tử', '2026-04-05 16:26:00', 'Thành công'),
(650, 309000, 'Tiền mặt', '2026-04-05 17:16:00', 'Thành công'),
(651, 400000, 'Tiền mặt', '2026-04-05 19:47:00', 'Thành công'),
(652, 200000, 'MoMo', '2026-04-05 21:31:00', 'Thành công'),
(653, 400000, 'Tiền mặt', '2026-04-05 19:33:00', 'Thành công'),
(654, 180000, 'Tiền mặt', '2026-04-05 19:12:00', 'Thành công'),
(655, 470000, 'Chuyển khoản', '2026-04-05 20:09:00', 'Thành công'),
(656, 400000, 'Ví điện tử', '2026-04-05 21:33:00', 'Thành công'),
(657, 180000, 'Thẻ ngân hàng', '2026-04-05 20:42:00', 'Thành công'),
(658, 210000, 'Tiền mặt', '2026-04-06 08:13:00', 'Thành công'),
(659, 210000, 'MoMo', '2026-04-06 08:22:00', 'Thành công'),
(660, 340000, 'Thẻ ngân hàng', '2026-04-06 11:31:00', 'Thành công'),
(661, 340000, 'Thẻ ngân hàng', '2026-04-06 11:05:00', 'Thành công'),
(662, 340000, 'Thẻ ngân hàng', '2026-04-06 10:15:00', 'Thành công'),
(663, 180000, 'Thẻ ngân hàng', '2026-04-06 11:43:00', 'Thành công'),
(664, 85000, 'Chuyển khoản', '2026-04-06 10:01:00', 'Thành công'),
(665, 380000, 'Chuyển khoản', '2026-04-06 14:40:00', 'Thành công'),
(666, 95000, 'Tiền mặt', '2026-04-06 15:16:00', 'Thành công'),
(667, 285000, 'Ví điện tử', '2026-04-06 14:57:00', 'Thành công'),
(668, 190000, 'MoMo', '2026-04-06 12:58:00', 'Thành công'),
(669, 190000, 'Tiền mặt', '2026-04-06 13:27:00', 'Thành công'),
(670, 370000, 'Chuyển khoản', '2026-04-06 16:40:00', 'Thành công'),
(671, 210000, 'MoMo', '2026-04-06 17:36:00', 'Thành công'),
(672, 484000, 'MoMo', '2026-04-06 16:13:00', 'Thành công'),
(673, 210000, 'Ví điện tử', '2026-04-06 17:50:00', 'Thành công'),
(674, 285000, 'Ví điện tử', '2026-04-06 20:49:00', 'Thành công'),
(675, 380000, 'MoMo', '2026-04-06 20:05:00', 'Thành công'),
(676, 190000, 'Ví điện tử', '2026-04-06 19:52:00', 'Thành công'),
(677, 521900, 'Thẻ ngân hàng', '2026-04-06 21:08:00', 'Thành công'),
(678, 285000, 'Thẻ ngân hàng', '2026-04-06 21:34:00', 'Thành công'),
(679, 360000, 'Chuyển khoản', '2026-04-06 20:42:00', 'Thành công'),
(680, 95000, 'Ví điện tử', '2026-04-06 20:26:00', 'Thành công'),
(681, 95000, 'Ví điện tử', '2026-04-06 21:10:00', 'Thành công'),
(682, 225000, 'Ví điện tử', '2026-04-06 08:50:00', 'Thành công'),
(683, 245000, 'Ví điện tử', '2026-04-06 08:59:00', 'Thành công'),
(684, 180000, 'Tiền mặt', '2026-04-06 10:58:00', 'Thành công'),
(685, 319000, 'Thẻ ngân hàng', '2026-04-06 10:26:00', 'Thành công'),
(686, 270000, 'Tiền mặt', '2026-04-06 11:23:00', 'Thành công'),
(687, 180000, 'Tiền mặt', '2026-04-06 11:01:00', 'Thành công'),
(688, 450000, 'Thẻ ngân hàng', '2026-04-06 15:10:00', 'Thành công'),
(689, 300000, 'Tiền mặt', '2026-04-06 15:28:00', 'Thành công'),
(690, 110000, 'Tiền mặt', '2026-04-06 17:34:00', 'Thành công'),
(691, 989000, 'Chuyển khoản', '2026-04-06 19:04:00', 'Thành công'),
(692, 440000, 'Thẻ ngân hàng', '2026-04-06 18:25:00', 'Thành công'),
(693, 142000, 'Ví điện tử', '2026-04-06 17:08:00', 'Thành công'),
(694, 199000, 'Thẻ ngân hàng', '2026-04-06 18:01:00', 'Thành công'),
(695, 125000, 'MoMo', '2026-04-06 22:09:00', 'Thành công'),
(696, 139000, 'Thẻ ngân hàng', '2026-04-06 19:38:00', 'Thành công'),
(697, 400000, 'Ví điện tử', '2026-04-06 20:01:00', 'Thành công'),
(698, 200000, 'Ví điện tử', '2026-04-06 21:39:00', 'Thành công'),
(699, 499000, 'Thẻ ngân hàng', '2026-04-06 19:58:00', 'Thành công'),
(700, 100000, 'Tiền mặt', '2026-04-06 20:16:00', 'Thành công'),
(701, 469000, 'MoMo', '2026-04-06 20:38:00', 'Thành công'),
(702, 300000, 'Thẻ ngân hàng', '2026-04-06 22:07:00', 'Thành công'),
(703, 255000, 'MoMo', '2026-04-06 09:47:00', 'Thành công'),
(704, 170000, 'Chuyển khoản', '2026-04-06 08:49:00', 'Thành công'),
(705, 310000, 'Tiền mặt', '2026-04-06 09:14:00', 'Thành công'),
(706, 255000, 'Tiền mặt', '2026-04-06 08:52:00', 'Thành công'),
(707, 200000, 'MoMo', '2026-04-06 11:35:00', 'Thành công'),
(708, 500000, 'Ví điện tử', '2026-04-06 10:50:00', 'Thành công'),
(709, 200000, 'Thẻ ngân hàng', '2026-04-06 12:34:00', 'Thành công'),
(710, 300000, 'Thẻ ngân hàng', '2026-04-06 12:04:00', 'Thành công'),
(711, 100000, 'MoMo', '2026-04-06 11:37:00', 'Thành công'),
(712, 440000, 'Chuyển khoản', '2026-04-06 14:38:00', 'Thành công'),
(713, 220000, 'Ví điện tử', '2026-04-06 15:26:00', 'Thành công'),
(714, 220000, 'MoMo', '2026-04-06 15:38:00', 'Thành công'),
(715, 330000, 'Ví điện tử', '2026-04-06 16:40:00', 'Thành công'),
(716, 529000, 'Tiền mặt', '2026-04-06 19:15:00', 'Thành công'),
(717, 240000, 'Tiền mặt', '2026-04-06 19:02:00', 'Thành công'),
(718, 240000, 'Thẻ ngân hàng', '2026-04-06 18:06:00', 'Thành công'),
(719, 759000, 'Chuyển khoản', '2026-04-06 18:49:00', 'Thành công'),
(720, 120000, 'Ví điện tử', '2026-04-06 18:23:00', 'Thành công'),
(721, 120000, 'Ví điện tử', '2026-04-06 18:45:00', 'Thành công'),
(722, 743000, 'MoMo', '2026-04-06 09:47:00', 'Thành công'),
(723, 240000, 'Ví điện tử', '2026-04-06 10:37:00', 'Thành công'),
(724, 819000, 'Thẻ ngân hàng', '2026-04-06 13:57:00', 'Thành công'),
(725, 270000, 'MoMo', '2026-04-06 12:48:00', 'Thành công'),
(726, 270000, 'Chuyển khoản', '2026-04-06 12:28:00', 'Thành công'),
(727, 580000, 'Chuyển khoản', '2026-04-06 18:01:00', 'Thành công'),
(728, 290000, 'Tiền mặt', '2026-04-06 16:57:00', 'Thành công'),
(729, 290000, 'Chuyển khoản', '2026-04-06 17:01:00', 'Thành công'),
(730, 260000, 'Thẻ ngân hàng', '2026-04-06 17:42:00', 'Thành công'),
(731, 290000, 'Ví điện tử', '2026-04-06 15:45:00', 'Thành công'),
(732, 813000, 'Ví điện tử', '2026-04-06 17:53:00', 'Thành công'),
(733, 580000, 'Chuyển khoản', '2026-04-06 18:04:00', 'Thành công'),
(734, 620000, 'Chuyển khoản', '2026-04-06 21:02:00', 'Thành công'),
(735, 449000, 'Ví điện tử', '2026-04-06 20:58:00', 'Thành công'),
(736, 290000, 'Tiền mặt', '2026-04-06 20:57:00', 'Thành công'),
(737, 949000, 'Chuyển khoản', '2026-04-06 21:18:00', 'Thành công'),
(738, 310000, 'Chuyển khoản', '2026-04-06 20:03:00', 'Thành công'),
(739, 260000, 'Chuyển khoản', '2026-04-06 07:54:00', 'Thành công'),
(740, 225000, 'Tiền mặt', '2026-04-06 07:48:00', 'Thành công'),
(741, 599000, 'Tiền mặt', '2026-04-06 10:26:00', 'Thành công'),
(742, 160000, 'Tiền mặt', '2026-04-06 11:03:00', 'Thành công'),
(743, 204000, 'MoMo', '2026-04-06 10:49:00', 'Thành công'),
(744, 240000, 'MoMo', '2026-04-06 09:48:00', 'Thành công'),
(745, 160000, 'Chuyển khoản', '2026-04-06 10:58:00', 'Thành công'),
(746, 270000, 'Thẻ ngân hàng', '2026-04-06 12:31:00', 'Thành công'),
(747, 540000, 'Ví điện tử', '2026-04-06 15:11:00', 'Thành công'),
(748, 90000, 'Ví điện tử', '2026-04-06 12:33:00', 'Thành công'),
(749, 400000, 'MoMo', '2026-04-06 16:27:00', 'Thành công'),
(750, 599000, 'Tiền mặt', '2026-04-06 16:02:00', 'Thành công'),
(751, 729000, 'Thẻ ngân hàng', '2026-04-06 18:10:00', 'Thành công'),
(752, 539000, 'Ví điện tử', '2026-04-06 18:26:00', 'Thành công'),
(753, 400000, 'Thẻ ngân hàng', '2026-04-06 17:54:00', 'Thành công'),
(754, 360000, 'Thẻ ngân hàng', '2026-04-06 20:11:00', 'Thành công'),
(755, 180000, 'Chuyển khoản', '2026-04-06 21:47:00', 'Thành công'),
(756, 360000, 'Ví điện tử', '2026-04-06 20:29:00', 'Thành công'),
(757, 350000, 'MoMo', '2026-04-07 08:44:00', 'Thành công'),
(758, 70000, 'Chuyển khoản', '2026-04-07 08:23:00', 'Thành công'),
(759, 170000, 'Ví điện tử', '2026-04-07 11:52:00', 'Thành công'),
(760, 401000, 'MoMo', '2026-04-07 10:33:00', 'Thành công'),
(761, 170000, 'Tiền mặt', '2026-04-07 10:32:00', 'Thành công'),
(762, 170000, 'Ví điện tử', '2026-04-07 09:56:00', 'Thành công'),
(763, 340000, 'Tiền mặt', '2026-04-07 11:15:00', 'Thành công'),
(764, 255000, 'Thẻ ngân hàng', '2026-04-07 11:53:00', 'Thành công'),
(765, 117000, 'Ví điện tử', '2026-04-07 10:45:00', 'Thành công'),
(766, 380000, 'MoMo', '2026-04-07 14:02:00', 'Thành công'),
(767, 425000, 'Thẻ ngân hàng', '2026-04-07 14:45:00', 'Thành công'),
(768, 391000, 'Thẻ ngân hàng', '2026-04-07 14:20:00', 'Thành công'),
(769, 95000, 'Thẻ ngân hàng', '2026-04-07 13:48:00', 'Thành công'),
(770, 105000, 'Chuyển khoản', '2026-04-07 16:43:00', 'Thành công'),
(771, 580000, 'Ví điện tử', '2026-04-07 18:30:00', 'Thành công'),
(772, 210000, 'MoMo', '2026-04-07 17:40:00', 'Thành công'),
(773, 285000, 'Ví điện tử', '2026-04-07 17:04:00', 'Thành công'),
(774, 210000, 'Thẻ ngân hàng', '2026-04-07 16:21:00', 'Thành công'),
(775, 570000, 'Thẻ ngân hàng', '2026-04-07 20:58:00', 'Thành công'),
(776, 190000, 'Chuyển khoản', '2026-04-07 20:23:00', 'Thành công'),
(777, 380000, 'Tiền mặt', '2026-04-07 20:53:00', 'Thành công'),
(778, 380000, 'MoMo', '2026-04-07 19:37:00', 'Thành công'),
(779, 380000, 'Chuyển khoản', '2026-04-07 19:22:00', 'Thành công'),
(780, 95000, 'Ví điện tử', '2026-04-07 21:43:00', 'Thành công'),
(781, 285000, 'Chuyển khoản', '2026-04-07 21:35:00', 'Thành công'),
(782, 225000, 'Ví điện tử', '2026-04-07 08:26:00', 'Thành công'),
(783, 300000, 'Ví điện tử', '2026-04-07 08:30:00', 'Thành công'),
(784, 75000, 'Ví điện tử', '2026-04-07 09:09:00', 'Thành công'),
(785, 360000, 'Thẻ ngân hàng', '2026-04-07 10:48:00', 'Thành công'),
(786, 360000, 'Tiền mặt', '2026-04-07 12:48:00', 'Thành công'),
(787, 306000, 'Thẻ ngân hàng', '2026-04-07 10:06:00', 'Thành công'),
(788, 400000, 'Chuyển khoản', '2026-04-07 13:51:00', 'Thành công'),
(789, 270000, 'Ví điện tử', '2026-04-07 15:42:00', 'Thành công'),
(790, 340000, 'Chuyển khoản', '2026-04-07 15:16:00', 'Thành công'),
(791, 100000, 'Chuyển khoản', '2026-04-07 15:44:00', 'Thành công'),
(792, 289000, 'MoMo', '2026-04-07 14:35:00', 'Thành công'),
(793, 440000, 'Thẻ ngân hàng', '2026-04-07 17:13:00', 'Thành công'),
(794, 440000, 'Chuyển khoản', '2026-04-07 17:52:00', 'Thành công'),
(795, 440000, 'MoMo', '2026-04-07 17:42:00', 'Thành công'),
(796, 400000, 'Chuyển khoản', '2026-04-07 20:28:00', 'Thành công'),
(797, 400000, 'Chuyển khoản', '2026-04-07 20:47:00', 'Thành công'),
(798, 300000, 'MoMo', '2026-04-07 19:53:00', 'Thành công'),
(799, 100000, 'Tiền mặt', '2026-04-07 20:58:00', 'Thành công'),
(800, 100000, 'Ví điện tử', '2026-04-07 22:08:00', 'Thành công'),
(801, 170000, 'Thẻ ngân hàng', '2026-04-07 09:07:00', 'Thành công'),
(802, 454000, 'Chuyển khoản', '2026-04-07 09:36:00', 'Thành công'),
(803, 754000, 'Tiền mặt', '2026-04-07 09:06:00', 'Thành công'),
(804, 85000, 'MoMo', '2026-04-07 09:45:00', 'Thành công'),
(805, 450000, 'Ví điện tử', '2026-04-07 13:25:00', 'Thành công'),
(806, 450000, 'Tiền mặt', '2026-04-07 13:23:00', 'Thành công'),
(807, 550000, 'Tiền mặt', '2026-04-07 15:21:00', 'Thành công'),
(808, 520000, 'Tiền mặt', '2026-04-07 15:25:00', 'Thành công'),
(809, 110000, 'Thẻ ngân hàng', '2026-04-07 16:20:00', 'Thành công'),
(810, 570000, 'Chuyển khoản', '2026-04-07 18:38:00', 'Thành công'),
(811, 670000, 'Ví điện tử', '2026-04-07 19:48:00', 'Thành công'),
(812, 152000, 'Chuyển khoản', '2026-04-07 18:30:00', 'Thành công'),
(813, 480000, 'Ví điện tử', '2026-04-07 19:47:00', 'Thành công'),
(814, 570000, 'Ví điện tử', '2026-04-07 10:33:00', 'Thành công'),
(815, 480000, 'MoMo', '2026-04-07 10:37:00', 'Thành công'),
(816, 405000, 'Tiền mặt', '2026-04-07 12:27:00', 'Thành công'),
(817, 375000, 'Tiền mặt', '2026-04-07 12:06:00', 'Thành công'),
(818, 270000, 'Thẻ ngân hàng', '2026-04-07 14:17:00', 'Thành công'),
(819, 145000, 'Tiền mặt', '2026-04-07 18:05:00', 'Thành công'),
(820, 290000, 'Thẻ ngân hàng', '2026-04-07 17:47:00', 'Thành công'),
(821, 435000, 'Tiền mặt', '2026-04-07 18:17:00', 'Thành công'),
(822, 290000, 'Ví điện tử', '2026-04-07 15:47:00', 'Thành công'),
(823, 290000, 'Tiền mặt', '2026-04-07 17:35:00', 'Thành công'),
(824, 290000, 'Thẻ ngân hàng', '2026-04-07 18:16:00', 'Thành công'),
(825, 290000, 'Thẻ ngân hàng', '2026-04-07 17:36:00', 'Thành công'),
(826, 459000, 'Thẻ ngân hàng', '2026-04-07 18:12:00', 'Thành công'),
(827, 405000, 'MoMo', '2026-04-07 16:02:00', 'Thành công'),
(828, 145000, 'Ví điện tử', '2026-04-07 16:00:00', 'Thành công'),
(829, 280000, 'Ví điện tử', '2026-04-07 20:46:00', 'Thành công'),
(830, 155000, 'Chuyển khoản', '2026-04-07 21:52:00', 'Thành công'),
(831, 465000, 'Chuyển khoản', '2026-04-07 20:01:00', 'Thành công'),
(832, 465000, 'MoMo', '2026-04-07 19:35:00', 'Thành công'),
(833, 465000, 'Thẻ ngân hàng', '2026-04-07 20:16:00', 'Thành công'),
(834, 620000, 'MoMo', '2026-04-07 21:38:00', 'Thành công'),
(835, 725000, 'Thẻ ngân hàng', '2026-04-07 21:45:00', 'Thành công'),
(836, 195000, 'Chuyển khoản', '2026-04-07 07:52:00', 'Thành công'),
(837, 219000, 'MoMo', '2026-04-07 07:52:00', 'Thành công'),
(838, 272000, 'Chuyển khoản', '2026-04-07 11:59:00', 'Thành công'),
(839, 160000, 'Ví điện tử', '2026-04-07 09:54:00', 'Thành công'),
(840, 240000, 'Tiền mặt', '2026-04-07 11:43:00', 'Thành công'),
(841, 160000, 'Tiền mặt', '2026-04-07 09:15:00', 'Thành công'),
(842, 360000, 'Thẻ ngân hàng', '2026-04-07 13:47:00', 'Thành công'),
(843, 270000, 'Ví điện tử', '2026-04-07 14:26:00', 'Thành công'),
(844, 180000, 'Thẻ ngân hàng', '2026-04-07 15:07:00', 'Thành công'),
(845, 349000, 'Thẻ ngân hàng', '2026-04-07 13:42:00', 'Thành công'),
(846, 90000, 'Ví điện tử', '2026-04-07 13:51:00', 'Thành công'),
(847, 330000, 'Thẻ ngân hàng', '2026-04-07 13:02:00', 'Thành công'),
(848, 200000, 'Tiền mặt', '2026-04-07 16:34:00', 'Thành công'),
(849, 729000, 'Chuyển khoản', '2026-04-07 16:11:00', 'Thành công'),
(850, 369000, 'Ví điện tử', '2026-04-07 16:47:00', 'Thành công'),
(851, 350000, 'Tiền mặt', '2026-04-07 17:41:00', 'Thành công'),
(852, 200000, 'MoMo', '2026-04-07 15:52:00', 'Thành công'),
(853, 300000, 'Thẻ ngân hàng', '2026-04-07 17:40:00', 'Thành công'),
(854, 180000, 'Ví điện tử', '2026-04-07 21:02:00', 'Thành công'),
(855, 90000, 'Thẻ ngân hàng', '2026-04-07 20:15:00', 'Thành công'),
(856, 180000, 'Chuyển khoản', '2026-04-07 20:28:00', 'Thành công'),
(857, 319000, 'Thẻ ngân hàng', '2026-04-07 21:32:00', 'Thành công'),
(858, 270000, 'MoMo', '2026-04-07 21:12:00', 'Thành công'),
(859, 180000, 'Thẻ ngân hàng', '2026-04-07 19:56:00', 'Thành công'),
(860, 450000, 'Chuyển khoản', '2026-04-07 20:57:00', 'Thành công'),
(861, 349000, 'Tiền mặt', '2026-04-07 21:23:00', 'Thành công'),
(862, 150000, 'Thẻ ngân hàng', '2026-04-08 08:32:00', 'Thành công'),
(863, 270000, 'Thẻ ngân hàng', '2026-04-08 07:46:00', 'Thành công'),
(864, 150000, 'Thẻ ngân hàng', '2026-04-08 08:25:00', 'Thành công'),
(865, 75000, 'Tiền mặt', '2026-04-08 07:57:00', 'Thành công'),
(866, 340000, 'MoMo', '2026-04-08 09:24:00', 'Thành công'),
(867, 385900, 'Chuyển khoản', '2026-04-08 10:00:00', 'Thành công'),
(868, 255000, 'Tiền mặt', '2026-04-08 11:11:00', 'Thành công'),
(869, 170000, 'Chuyển khoản', '2026-04-08 09:58:00', 'Thành công'),
(870, 170000, 'Thẻ ngân hàng', '2026-04-08 11:05:00', 'Thành công'),
(871, 454000, 'Ví điện tử', '2026-04-08 13:03:00', 'Thành công'),
(872, 380000, 'Thẻ ngân hàng', '2026-04-08 15:14:00', 'Thành công'),
(873, 350000, 'Chuyển khoản', '2026-04-08 15:00:00', 'Thành công'),
(874, 525000, 'Ví điện tử', '2026-04-08 16:18:00', 'Thành công'),
(875, 210000, 'Ví điện tử', '2026-04-08 16:02:00', 'Thành công'),
(876, 210000, 'Thẻ ngân hàng', '2026-04-08 18:25:00', 'Thành công'),
(877, 210000, 'Ví điện tử', '2026-04-08 18:00:00', 'Thành công'),
(878, 105000, 'Ví điện tử', '2026-04-08 16:30:00', 'Thành công'),
(879, 210000, 'Chuyển khoản', '2026-04-08 17:49:00', 'Thành công'),
(880, 255000, 'Ví điện tử', '2026-04-08 20:13:00', 'Thành công'),
(881, 540000, 'Thẻ ngân hàng', '2026-04-08 20:31:00', 'Thành công'),
(882, 190000, 'Tiền mặt', '2026-04-08 21:33:00', 'Thành công'),
(883, 107000, 'Ví điện tử', '2026-04-08 20:49:00', 'Thành công'),
(884, 285000, 'MoMo', '2026-04-08 20:52:00', 'Thành công'),
(885, 265000, 'Ví điện tử', '2026-04-08 19:35:00', 'Thành công'),
(886, 285000, 'MoMo', '2026-04-08 21:45:00', 'Thành công'),
(887, 729000, 'Ví điện tử', '2026-04-08 08:30:00', 'Thành công'),
(888, 441000, 'Thẻ ngân hàng', '2026-04-08 08:37:00', 'Thành công'),
(889, 160000, 'Tiền mặt', '2026-04-08 08:28:00', 'Thành công'),
(890, 90000, 'Chuyển khoản', '2026-04-08 12:30:00', 'Thành công'),
(891, 180000, 'Chuyển khoản', '2026-04-08 11:36:00', 'Thành công'),
(892, 180000, 'Ví điện tử', '2026-04-08 11:27:00', 'Thành công'),
(893, 180000, 'Thẻ ngân hàng', '2026-04-08 11:03:00', 'Thành công'),
(894, 180000, 'Tiền mặt', '2026-04-08 11:01:00', 'Thành công'),
(895, 200000, 'Chuyển khoản', '2026-04-08 13:24:00', 'Thành công'),
(896, 300000, 'Chuyển khoản', '2026-04-08 15:07:00', 'Thành công'),
(897, 400000, 'Thẻ ngân hàng', '2026-04-08 13:22:00', 'Thành công'),
(898, 339000, 'Thẻ ngân hàng', '2026-04-08 13:43:00', 'Thành công'),
(899, 189000, 'Chuyển khoản', '2026-04-08 14:35:00', 'Thành công'),
(900, 295000, 'MoMo', '2026-04-08 15:38:00', 'Thành công'),
(901, 200000, 'Thẻ ngân hàng', '2026-04-08 15:30:00', 'Thành công'),
(902, 200000, 'Tiền mặt', '2026-04-08 14:10:00', 'Thành công'),
(903, 195000, 'Thẻ ngân hàng', '2026-04-08 14:52:00', 'Thành công'),
(904, 440000, 'Ví điện tử', '2026-04-08 18:58:00', 'Thành công'),
(905, 220000, 'Ví điện tử', '2026-04-08 18:49:00', 'Thành công'),
(906, 660000, 'Ví điện tử', '2026-04-08 17:20:00', 'Thành công'),
(907, 440000, 'Chuyển khoản', '2026-04-08 18:35:00', 'Thành công'),
(908, 440000, 'Tiền mặt', '2026-04-08 17:07:00', 'Thành công'),
(909, 609000, 'Chuyển khoản', '2026-04-08 18:34:00', 'Thành công'),
(910, 200000, 'MoMo', '2026-04-08 21:36:00', 'Thành công'),
(911, 300000, 'Ví điện tử', '2026-04-08 20:23:00', 'Thành công'),
(912, 599000, 'MoMo', '2026-04-08 20:02:00', 'Thành công'),
(913, 100000, 'Tiền mặt', '2026-04-08 21:38:00', 'Thành công'),
(914, 100000, 'Thẻ ngân hàng', '2026-04-08 20:00:00', 'Thành công'),
(915, 100000, 'MoMo', '2026-04-08 20:36:00', 'Thành công'),
(916, 200000, 'Tiền mặt', '2026-04-08 21:42:00', 'Thành công'),
(917, 200000, 'Tiền mặt', '2026-04-08 20:56:00', 'Thành công'),
(918, 180000, 'Chuyển khoản', '2026-04-08 10:02:00', 'Thành công'),
(919, 749000, 'MoMo', '2026-04-08 09:43:00', 'Thành công'),
(920, 200000, 'Thẻ ngân hàng', '2026-04-08 11:36:00', 'Thành công'),
(921, 200000, 'MoMo', '2026-04-08 12:07:00', 'Thành công'),
(922, 550000, 'Tiền mặt', '2026-04-08 12:38:00', 'Thành công'),
(923, 440000, 'Ví điện tử', '2026-04-08 16:12:00', 'Thành công'),
(924, 410000, 'Ví điện tử', '2026-04-08 14:44:00', 'Thành công'),
(925, 499000, 'MoMo', '2026-04-08 15:14:00', 'Thành công'),
(926, 623900, 'Tiền mặt', '2026-04-08 18:09:00', 'Thành công'),
(927, 480000, 'MoMo', '2026-04-08 18:01:00', 'Thành công'),
(928, 480000, 'Ví điện tử', '2026-04-08 19:51:00', 'Thành công'),
(929, 470000, 'Thẻ ngân hàng', '2026-04-08 10:34:00', 'Thành công'),
(930, 375000, 'MoMo', '2026-04-08 09:56:00', 'Thành công'),
(931, 345000, 'Ví điện tử', '2026-04-08 10:39:00', 'Thành công'),
(932, 510000, 'MoMo', '2026-04-08 12:03:00', 'Thành công'),
(933, 675000, 'Ví điện tử', '2026-04-08 13:46:00', 'Thành công'),
(934, 405000, 'MoMo', '2026-04-08 13:51:00', 'Thành công'),
(935, 270000, 'Chuyển khoản', '2026-04-08 13:01:00', 'Thành công'),
(936, 135000, 'Tiền mặt', '2026-04-08 12:48:00', 'Thành công'),
(937, 550000, 'Tiền mặt', '2026-04-08 16:32:00', 'Thành công'),
(938, 234000, 'Tiền mặt', '2026-04-08 17:46:00', 'Thành công'),
(939, 435000, 'Thẻ ngân hàng', '2026-04-08 15:39:00', 'Thành công'),
(940, 550000, 'Ví điện tử', '2026-04-08 17:35:00', 'Thành công'),
(941, 260000, 'Chuyển khoản', '2026-04-08 17:27:00', 'Thành công'),
(942, 725000, 'Ví điện tử', '2026-04-08 19:38:00', 'Thành công'),
(943, 600000, 'Chuyển khoản', '2026-04-08 21:39:00', 'Thành công'),
(944, 465000, 'Ví điện tử', '2026-04-08 20:43:00', 'Thành công'),
(945, 420000, 'Tiền mặt', '2026-04-08 07:55:00', 'Thành công'),
(946, 320000, 'Ví điện tử', '2026-04-08 11:32:00', 'Thành công'),
(947, 160000, 'Thẻ ngân hàng', '2026-04-08 09:43:00', 'Thành công'),
(948, 160000, 'Thẻ ngân hàng', '2026-04-08 11:58:00', 'Thành công'),
(949, 450000, 'MoMo', '2026-04-08 14:10:00', 'Thành công'),
(950, 122000, 'Chuyển khoản', '2026-04-08 15:02:00', 'Thành công'),
(951, 180000, 'Chuyển khoản', '2026-04-08 13:15:00', 'Thành công'),
(952, 180000, 'MoMo', '2026-04-08 13:24:00', 'Thành công'),
(953, 600000, 'MoMo', '2026-04-08 16:38:00', 'Thành công'),
(954, 200000, 'MoMo', '2026-04-08 16:08:00', 'Thành công'),
(955, 300000, 'Thẻ ngân hàng', '2026-04-08 17:08:00', 'Thành công'),
(956, 100000, 'Thẻ ngân hàng', '2026-04-08 17:55:00', 'Thành công'),
(957, 200000, 'MoMo', '2026-04-08 17:08:00', 'Thành công'),
(958, 153000, 'MoMo', '2026-04-08 21:02:00', 'Thành công'),
(959, 360000, 'Chuyển khoản', '2026-04-08 19:26:00', 'Thành công'),
(960, 540000, 'Tiền mặt', '2026-04-08 21:36:00', 'Thành công'),
(961, 180000, 'MoMo', '2026-04-08 19:48:00', 'Thành công'),
(962, 240000, 'Tiền mặt', '2026-04-08 21:24:00', 'Thành công'),
(963, 669000, 'Thẻ ngân hàng', '2026-04-08 20:54:00', 'Thành công'),
(964, 90000, 'Thẻ ngân hàng', '2026-04-08 19:13:00', 'Thành công'),
(965, 225000, 'Chuyển khoản', '2026-04-09 07:58:00', 'Thành công'),
(966, 150000, 'Ví điện tử', '2026-04-09 08:30:00', 'Thành công'),
(967, 225000, 'Chuyển khoản', '2026-04-09 08:17:00', 'Thành công'),
(968, 340000, 'Ví điện tử', '2026-04-09 11:03:00', 'Thành công'),
(969, 510000, 'Thẻ ngân hàng', '2026-04-09 10:12:00', 'Thành công'),
(970, 190000, 'Thẻ ngân hàng', '2026-04-09 12:45:00', 'Thành công'),
(971, 95000, 'Thẻ ngân hàng', '2026-04-09 12:48:00', 'Thành công'),
(972, 963000, 'MoMo', '2026-04-09 12:57:00', 'Thành công'),
(973, 95000, 'Tiền mặt', '2026-04-09 13:15:00', 'Thành công'),
(974, 190000, 'MoMo', '2026-04-09 13:48:00', 'Thành công'),
(975, 190000, 'Ví điện tử', '2026-04-09 13:54:00', 'Thành công'),
(976, 95000, 'Tiền mặt', '2026-04-09 14:00:00', 'Thành công'),
(977, 210000, 'Chuyển khoản', '2026-04-09 18:07:00', 'Thành công'),
(978, 390000, 'Ví điện tử', '2026-04-09 16:53:00', 'Thành công'),
(979, 210000, 'Thẻ ngân hàng', '2026-04-09 17:02:00', 'Thành công'),
(980, 210000, 'Chuyển khoản', '2026-04-09 18:03:00', 'Thành công'),
(981, 210000, 'MoMo', '2026-04-09 17:15:00', 'Thành công'),
(982, 578000, 'MoMo', '2026-04-09 18:35:00', 'Thành công'),
(983, 600000, 'Ví điện tử', '2026-04-09 17:25:00', 'Thành công'),
(984, 379000, 'Thẻ ngân hàng', '2026-04-09 18:27:00', 'Thành công'),
(985, 285000, 'MoMo', '2026-04-09 19:36:00', 'Thành công'),
(986, 360000, 'Chuyển khoản', '2026-04-09 20:18:00', 'Thành công'),
(987, 95000, 'Chuyển khoản', '2026-04-09 21:35:00', 'Thành công'),
(988, 350000, 'Thẻ ngân hàng', '2026-04-09 20:19:00', 'Thành công'),
(989, 380000, 'Thẻ ngân hàng', '2026-04-09 21:18:00', 'Thành công'),
(990, 285000, 'Chuyển khoản', '2026-04-09 19:47:00', 'Thành công'),
(991, 160000, 'Thẻ ngân hàng', '2026-04-09 09:09:00', 'Thành công'),
(992, 80000, 'Thẻ ngân hàng', '2026-04-09 09:28:00', 'Thành công'),
(993, 320000, 'Chuyển khoản', '2026-04-09 09:02:00', 'Thành công'),
(994, 420000, 'Ví điện tử', '2026-04-09 11:55:00', 'Thành công'),
(995, 360000, 'Thẻ ngân hàng', '2026-04-09 11:53:00', 'Thành công'),
(996, 90000, 'MoMo', '2026-04-09 11:06:00', 'Thành công'),
(997, 499000, 'Tiền mặt', '2026-04-09 14:49:00', 'Thành công'),
(998, 425000, 'MoMo', '2026-04-09 13:50:00', 'Thành công'),
(999, 200000, 'MoMo', '2026-04-09 13:58:00', 'Thành công'),
(1000, 200000, 'Tiền mặt', '2026-04-09 14:26:00', 'Thành công'),
(1001, 300000, 'Chuyển khoản', '2026-04-09 18:46:00', 'Thành công'),
(1002, 220000, 'Thẻ ngân hàng', '2026-04-09 17:07:00', 'Thành công'),
(1003, 499000, 'Thẻ ngân hàng', '2026-04-09 17:33:00', 'Thành công'),
(1004, 440000, 'Thẻ ngân hàng', '2026-04-09 18:22:00', 'Thành công'),
(1005, 428000, 'Tiền mặt', '2026-04-09 18:31:00', 'Thành công'),
(1006, 300000, 'Tiền mặt', '2026-04-09 18:02:00', 'Thành công'),
(1007, 220000, 'MoMo', '2026-04-09 17:10:00', 'Thành công'),
(1008, 300000, 'Thẻ ngân hàng', '2026-04-09 17:18:00', 'Thành công'),
(1009, 110000, 'Thẻ ngân hàng', '2026-04-09 18:10:00', 'Thành công'),
(1010, 350000, 'Ví điện tử', '2026-04-09 20:13:00', 'Thành công'),
(1011, 400000, 'Chuyển khoản', '2026-04-09 19:48:00', 'Thành công'),
(1012, 370000, 'Chuyển khoản', '2026-04-09 22:09:00', 'Thành công'),
(1013, 369000, 'MoMo', '2026-04-09 19:46:00', 'Thành công'),
(1014, 270000, 'Tiền mặt', '2026-04-09 08:52:00', 'Thành công'),
(1015, 270000, 'Thẻ ngân hàng', '2026-04-09 09:35:00', 'Thành công'),
(1016, 180000, 'Ví điện tử', '2026-04-09 09:01:00', 'Thành công'),
(1017, 200000, 'Chuyển khoản', '2026-04-09 13:16:00', 'Thành công'),
(1018, 200000, 'Ví điện tử', '2026-04-09 11:11:00', 'Thành công'),
(1019, 200000, 'Chuyển khoản', '2026-04-09 11:45:00', 'Thành công'),
(1020, 369000, 'Chuyển khoản', '2026-04-09 12:29:00', 'Thành công'),
(1021, 100000, 'Ví điện tử', '2026-04-09 13:03:00', 'Thành công'),
(1022, 220000, 'Thẻ ngân hàng', '2026-04-09 14:50:00', 'Thành công'),
(1023, 330000, 'MoMo', '2026-04-09 15:52:00', 'Thành công'),
(1024, 660000, 'Tiền mặt', '2026-04-09 14:32:00', 'Thành công'),
(1025, 110000, 'Chuyển khoản', '2026-04-09 14:31:00', 'Thành công'),
(1026, 440000, 'Chuyển khoản', '2026-04-09 16:26:00', 'Thành công'),
(1027, 110000, 'Tiền mặt', '2026-04-09 15:44:00', 'Thành công'),
(1028, 711000, 'MoMo', '2026-04-09 19:24:00', 'Thành công'),
(1029, 165000, 'Thẻ ngân hàng', '2026-04-09 19:32:00', 'Thành công'),
(1030, 240000, 'Ví điện tử', '2026-04-09 20:18:00', 'Thành công'),
(1031, 480000, 'Thẻ ngân hàng', '2026-04-09 19:00:00', 'Thành công'),
(1032, 120000, 'Tiền mặt', '2026-04-09 18:26:00', 'Thành công'),
(1033, 240000, 'Thẻ ngân hàng', '2026-04-09 18:29:00', 'Thành công'),
(1034, 480000, 'MoMo', '2026-04-09 19:17:00', 'Thành công'),
(1035, 529000, 'Thẻ ngân hàng', '2026-04-09 20:11:00', 'Thành công'),
(1036, 450000, 'Chuyển khoản', '2026-04-09 10:29:00', 'Thành công'),
(1037, 220000, 'Ví điện tử', '2026-04-09 10:10:00', 'Thành công'),
(1038, 250000, 'Tiền mặt', '2026-04-09 10:47:00', 'Thành công'),
(1039, 510000, 'Chuyển khoản', '2026-04-09 13:03:00', 'Thành công'),
(1040, 135000, 'Ví điện tử', '2026-04-09 13:41:00', 'Thành công'),
(1041, 375000, 'Chuyển khoản', '2026-04-09 13:18:00', 'Thành công'),
(1042, 260000, 'Tiền mặt', '2026-04-09 17:37:00', 'Thành công'),
(1043, 580000, 'Ví điện tử', '2026-04-09 16:50:00', 'Thành công'),
(1044, 530000, 'Thẻ ngân hàng', '2026-04-09 17:10:00', 'Thành công'),
(1045, 290000, 'Tiền mặt', '2026-04-09 17:55:00', 'Thành công'),
(1046, 290000, 'Tiền mặt', '2026-04-09 16:39:00', 'Thành công'),
(1047, 280000, 'Tiền mặt', '2026-04-09 21:53:00', 'Thành công'),
(1048, 789000, 'MoMo', '2026-04-09 20:20:00', 'Thành công'),
(1049, 399000, 'Chuyển khoản', '2026-04-09 20:24:00', 'Thành công'),
(1050, 620000, 'Ví điện tử', '2026-04-09 20:10:00', 'Thành công'),
(1051, 310000, 'Tiền mặt', '2026-04-09 20:06:00', 'Thành công'),
(1052, 250000, 'Ví điện tử', '2026-04-09 08:44:00', 'Thành công'),
(1053, 140000, 'Thẻ ngân hàng', '2026-04-09 07:55:00', 'Thành công'),
(1054, 320000, 'Ví điện tử', '2026-04-09 10:22:00', 'Thành công'),
(1055, 320000, 'MoMo', '2026-04-09 10:18:00', 'Thành công'),
(1056, 80000, 'Ví điện tử', '2026-04-09 09:41:00', 'Thành công'),
(1057, 240000, 'Tiền mặt', '2026-04-09 09:28:00', 'Thành công'),
(1058, 160000, 'MoMo', '2026-04-09 10:25:00', 'Thành công'),
(1059, 255000, 'Ví điện tử', '2026-04-09 10:45:00', 'Thành công'),
(1060, 869000, 'Chuyển khoản', '2026-04-09 14:51:00', 'Thành công'),
(1061, 529000, 'Ví điện tử', '2026-04-09 14:02:00', 'Thành công'),
(1062, 200000, 'Thẻ ngân hàng', '2026-04-09 17:54:00', 'Thành công'),
(1063, 400000, 'Ví điện tử', '2026-04-09 17:27:00', 'Thành công'),
(1064, 200000, 'Ví điện tử', '2026-04-09 17:31:00', 'Thành công'),
(1065, 200000, 'Tiền mặt', '2026-04-09 15:47:00', 'Thành công'),
(1066, 399000, 'MoMo', '2026-04-09 17:01:00', 'Thành công'),
(1067, 1007000, 'Ví điện tử', '2026-04-09 17:20:00', 'Thành công'),
(1068, 270000, 'Tiền mặt', '2026-04-09 16:01:00', 'Thành công'),
(1069, 195000, 'Chuyển khoản', '2026-04-09 17:56:00', 'Thành công'),
(1070, 360000, 'MoMo', '2026-04-09 19:47:00', 'Thành công'),
(1071, 270000, 'MoMo', '2026-04-09 21:22:00', 'Thành công'),
(1072, 180000, 'Tiền mặt', '2026-04-09 21:25:00', 'Thành công'),
(1073, 250000, 'Thẻ ngân hàng', '2026-04-09 21:04:00', 'Thành công'),
(1074, 240000, 'MoMo', '2026-04-09 19:21:00', 'Thành công'),
(1075, 225000, 'Ví điện tử', '2026-04-10 08:35:00', 'Thành công'),
(1076, 300000, 'Thẻ ngân hàng', '2026-04-10 08:38:00', 'Thành công'),
(1077, 245000, 'Chuyển khoản', '2026-04-10 07:56:00', 'Thành công'),
(1078, 150000, 'Tiền mặt', '2026-04-10 07:43:00', 'Thành công'),
(1079, 170000, 'Tiền mặt', '2026-04-10 11:41:00', 'Thành công'),
(1080, 255000, 'Thẻ ngân hàng', '2026-04-10 09:39:00', 'Thành công'),
(1081, 340000, 'Thẻ ngân hàng', '2026-04-10 10:31:00', 'Thành công'),
(1082, 170000, 'MoMo', '2026-04-10 11:45:00', 'Thành công'),
(1083, 85000, 'MoMo', '2026-04-10 10:40:00', 'Thành công'),
(1084, 255000, 'Ví điện tử', '2026-04-10 10:28:00', 'Thành công'),
(1085, 380000, 'MoMo', '2026-04-10 14:08:00', 'Thành công'),
(1086, 285000, 'MoMo', '2026-04-10 14:53:00', 'Thành công'),
(1087, 285000, 'Ví điện tử', '2026-04-10 13:13:00', 'Thành công'),
(1088, 190000, 'Chuyển khoản', '2026-04-10 13:46:00', 'Thành công'),
(1089, 190000, 'Thẻ ngân hàng', '2026-04-10 13:27:00', 'Thành công'),
(1090, 430000, 'Thẻ ngân hàng', '2026-04-10 18:27:00', 'Thành công'),
(1091, 115000, 'Thẻ ngân hàng', '2026-04-10 16:06:00', 'Thành công'),
(1092, 345000, 'Chuyển khoản', '2026-04-10 17:16:00', 'Thành công'),
(1093, 345000, 'Thẻ ngân hàng', '2026-04-10 17:00:00', 'Thành công'),
(1094, 204000, 'Thẻ ngân hàng', '2026-04-10 16:20:00', 'Thành công'),
(1095, 674000, 'Chuyển khoản', '2026-04-10 18:04:00', 'Thành công'),
(1096, 230000, 'Thẻ ngân hàng', '2026-04-10 17:44:00', 'Thành công'),
(1097, 370000, 'Tiền mặt', '2026-04-10 19:46:00', 'Thành công'),
(1098, 400000, 'Chuyển khoản', '2026-04-10 20:12:00', 'Thành công'),
(1099, 190000, 'Chuyển khoản', '2026-04-10 19:49:00', 'Thành công'),
(1100, 210000, 'MoMo', '2026-04-10 19:55:00', 'Thành công'),
(1101, 210000, 'Tiền mặt', '2026-04-10 21:32:00', 'Thành công'),
(1102, 160000, 'Ví điện tử', '2026-04-10 09:25:00', 'Thành công'),
(1103, 320000, 'Thẻ ngân hàng', '2026-04-10 09:07:00', 'Thành công'),
(1104, 160000, 'Chuyển khoản', '2026-04-10 09:24:00', 'Thành công'),
(1105, 420000, 'MoMo', '2026-04-10 10:41:00', 'Thành công'),
(1106, 360000, 'Thẻ ngân hàng', '2026-04-10 12:14:00', 'Thành công'),
(1107, 180000, 'Thẻ ngân hàng', '2026-04-10 10:59:00', 'Thành công'),
(1108, 300000, 'Chuyển khoản', '2026-04-10 15:17:00', 'Thành công'),
(1109, 259000, 'MoMo', '2026-04-10 14:22:00', 'Thành công'),
(1110, 470000, 'Tiền mặt', '2026-04-10 14:52:00', 'Thành công'),
(1111, 265000, 'MoMo', '2026-04-10 16:01:00', 'Thành công'),
(1112, 100000, 'MoMo', '2026-04-10 15:00:00', 'Thành công'),
(1113, 329000, 'Thẻ ngân hàng', '2026-04-10 18:38:00', 'Thành công'),
(1114, 240000, 'Tiền mặt', '2026-04-10 19:11:00', 'Thành công'),
(1115, 240000, 'MoMo', '2026-04-10 17:51:00', 'Thành công'),
(1116, 480000, 'MoMo', '2026-04-10 17:52:00', 'Thành công'),
(1117, 120000, 'MoMo', '2026-04-10 17:12:00', 'Thành công'),
(1118, 215000, 'Tiền mặt', '2026-04-10 17:41:00', 'Thành công'),
(1119, 430000, 'Tiền mặt', '2026-04-10 18:17:00', 'Thành công'),
(1120, 360000, 'Tiền mặt', '2026-04-10 18:03:00', 'Thành công'),
(1121, 529000, 'Chuyển khoản', '2026-04-10 20:05:00', 'Thành công'),
(1122, 673000, 'MoMo', '2026-04-10 21:48:00', 'Thành công'),
(1123, 220000, 'Thẻ ngân hàng', '2026-04-10 22:28:00', 'Thành công'),
(1124, 300000, 'Thẻ ngân hàng', '2026-04-10 19:39:00', 'Thành công'),
(1125, 739000, 'Tiền mặt', '2026-04-10 20:57:00', 'Thành công'),
(1126, 220000, 'Chuyển khoản', '2026-04-10 22:03:00', 'Thành công'),
(1127, 300000, 'Ví điện tử', '2026-04-10 19:55:00', 'Thành công'),
(1128, 187000, 'Ví điện tử', '2026-04-10 19:55:00', 'Thành công'),
(1129, 110000, 'Thẻ ngân hàng', '2026-04-10 21:32:00', 'Thành công'),
(1130, 360000, 'Chuyển khoản', '2026-04-10 09:26:00', 'Thành công'),
(1131, 360000, 'Ví điện tử', '2026-04-10 09:49:00', 'Thành công'),
(1132, 90000, 'Ví điện tử', '2026-04-10 09:44:00', 'Thành công'),
(1133, 289000, 'Tiền mặt', '2026-04-10 12:33:00', 'Thành công'),
(1134, 200000, 'Ví điện tử', '2026-04-10 12:37:00', 'Thành công'),
(1135, 548000, 'Tiền mặt', '2026-04-10 13:04:00', 'Thành công'),
(1136, 400000, 'Ví điện tử', '2026-04-10 12:26:00', 'Thành công'),
(1137, 100000, 'Ví điện tử', '2026-04-10 12:24:00', 'Thành công'),
(1138, 400000, 'Chuyển khoản', '2026-04-10 11:08:00', 'Thành công'),
(1139, 400000, 'Ví điện tử', '2026-04-10 12:56:00', 'Thành công'),
(1140, 609000, 'MoMo', '2026-04-10 15:10:00', 'Thành công'),
(1141, 220000, 'Chuyển khoản', '2026-04-10 15:16:00', 'Thành công'),
(1142, 609000, 'Thẻ ngân hàng', '2026-04-10 16:09:00', 'Thành công'),
(1143, 220000, 'Thẻ ngân hàng', '2026-04-10 16:30:00', 'Thành công'),
(1144, 199000, 'Tiền mặt', '2026-04-10 16:04:00', 'Thành công'),
(1145, 260000, 'Chuyển khoản', '2026-04-10 20:09:00', 'Thành công'),
(1146, 719000, 'Ví điện tử', '2026-04-10 18:30:00', 'Thành công'),
(1147, 719000, 'Tiền mặt', '2026-04-10 19:47:00', 'Thành công'),
(1148, 470000, 'Chuyển khoản', '2026-04-10 19:50:00', 'Thành công'),
(1149, 520000, 'Tiền mặt', '2026-04-10 19:44:00', 'Thành công'),
(1150, 212500, 'Thẻ ngân hàng', '2026-04-10 10:37:00', 'Thành công'),
(1151, 419000, 'MoMo', '2026-04-10 09:58:00', 'Thành công'),
(1152, 500000, 'Thẻ ngân hàng', '2026-04-10 10:11:00', 'Thành công'),
(1153, 699000, 'Chuyển khoản', '2026-04-10 10:28:00', 'Thành công'),
(1154, 135000, 'Chuyển khoản', '2026-04-10 13:44:00', 'Thành công'),
(1155, 540000, 'MoMo', '2026-04-10 14:01:00', 'Thành công'),
(1156, 270000, 'Chuyển khoản', '2026-04-10 14:12:00', 'Thành công'),
(1157, 270000, 'Chuyển khoản', '2026-04-10 12:29:00', 'Thành công'),
(1158, 270000, 'Ví điện tử', '2026-04-10 14:01:00', 'Thành công'),
(1159, 280000, 'MoMo', '2026-04-10 18:09:00', 'Thành công'),
(1160, 725000, 'Ví điện tử', '2026-04-10 17:22:00', 'Thành công'),
(1161, 981000, 'Chuyển khoản', '2026-04-10 17:38:00', 'Thành công'),
(1162, 155000, 'Tiền mặt', '2026-04-10 18:17:00', 'Thành công'),
(1163, 509000, 'Tiền mặt', '2026-04-10 17:33:00', 'Thành công'),
(1164, 630000, 'MoMo', '2026-04-10 19:47:00', 'Thành công'),
(1165, 660000, 'MoMo', '2026-04-10 20:40:00', 'Thành công'),
(1166, 508000, 'MoMo', '2026-04-10 19:32:00', 'Thành công'),
(1167, 395000, 'Thẻ ngân hàng', '2026-04-10 20:45:00', 'Thành công'),
(1168, 475000, 'Ví điện tử', '2026-04-10 22:02:00', 'Thành công'),
(1169, 280500, 'MoMo', '2026-04-10 21:27:00', 'Thành công'),
(1170, 805000, 'MoMo', '2026-04-10 20:35:00', 'Thành công'),
(1171, 231000, 'MoMo', '2026-04-10 07:46:00', 'Thành công'),
(1172, 250000, 'Chuyển khoản', '2026-04-10 07:42:00', 'Thành công'),
(1173, 210000, 'Chuyển khoản', '2026-04-10 07:43:00', 'Thành công'),
(1174, 320000, 'Chuyển khoản', '2026-04-10 11:46:00', 'Thành công'),
(1175, 240000, 'Chuyển khoản', '2026-04-10 11:12:00', 'Thành công'),
(1176, 729000, 'MoMo', '2026-04-10 10:51:00', 'Thành công'),
(1177, 270000, 'Thẻ ngân hàng', '2026-04-10 13:31:00', 'Thành công'),
(1178, 180000, 'Thẻ ngân hàng', '2026-04-10 12:45:00', 'Thành công'),
(1179, 839000, 'Chuyển khoản', '2026-04-10 12:36:00', 'Thành công'),
(1180, 90000, 'Thẻ ngân hàng', '2026-04-10 13:28:00', 'Thành công'),
(1181, 129000, 'Tiền mặt', '2026-04-10 13:46:00', 'Thành công'),
(1182, 630000, 'Chuyển khoản', '2026-04-10 16:44:00', 'Thành công'),
(1183, 220000, 'Tiền mặt', '2026-04-10 17:48:00', 'Thành công'),
(1184, 769000, 'Chuyển khoản', '2026-04-10 17:53:00', 'Thành công'),
(1185, 609000, 'Thẻ ngân hàng', '2026-04-10 16:38:00', 'Thành công'),
(1186, 550000, 'Chuyển khoản', '2026-04-10 17:01:00', 'Thành công'),
(1187, 200000, 'Chuyển khoản', '2026-04-10 20:07:00', 'Thành công'),
(1188, 200000, 'Ví điện tử', '2026-04-10 19:57:00', 'Thành công'),
(1189, 300000, 'Ví điện tử', '2026-04-10 20:51:00', 'Thành công'),
(1190, 370000, 'Chuyển khoản', '2026-04-10 21:07:00', 'Thành công'),
(1191, 100000, 'Ví điện tử', '2026-04-10 19:39:00', 'Thành công'),
(1192, 400000, 'MoMo', '2026-04-10 21:34:00', 'Thành công'),
(1193, 300000, 'Ví điện tử', '2026-04-10 20:08:00', 'Thành công'),
(1194, 100000, 'MoMo', '2026-04-10 19:52:00', 'Thành công'),
(1195, 85000, 'Ví điện tử', '2026-04-11 07:45:00', 'Thành công'),
(1196, 310000, 'Chuyển khoản', '2026-04-11 07:58:00', 'Thành công'),
(1197, 340000, 'MoMo', '2026-04-11 08:09:00', 'Thành công'),
(1198, 339000, 'Ví điện tử', '2026-04-11 07:54:00', 'Thành công'),
(1199, 85000, 'Chuyển khoản', '2026-04-11 08:01:00', 'Thành công'),
(1200, 255000, 'Tiền mặt', '2026-04-11 08:31:00', 'Thành công'),
(1201, 350000, 'Ví điện tử', '2026-04-11 10:24:00', 'Thành công'),
(1202, 190000, 'MoMo', '2026-04-11 11:45:00', 'Thành công'),
(1203, 380000, 'Chuyển khoản', '2026-04-11 10:32:00', 'Thành công'),
(1204, 190000, 'Chuyển khoản', '2026-04-11 09:21:00', 'Thành công'),
(1205, 285000, 'Chuyển khoản', '2026-04-11 10:50:00', 'Thành công'),
(1206, 445000, 'Ví điện tử', '2026-04-11 10:48:00', 'Thành công'),
(1207, 285000, 'MoMo', '2026-04-11 10:02:00', 'Thành công'),
(1208, 299000, 'MoMo', '2026-04-11 14:28:00', 'Thành công'),
(1209, 420000, 'MoMo', '2026-04-11 13:15:00', 'Thành công'),
(1210, 378000, 'Thẻ ngân hàng', '2026-04-11 15:03:00', 'Thành công'),
(1211, 210000, 'MoMo', '2026-04-11 14:29:00', 'Thành công'),
(1212, 390000, 'Ví điện tử', '2026-04-11 14:28:00', 'Thành công'),
(1213, 420000, 'Ví điện tử', '2026-04-11 13:34:00', 'Thành công'),
(1214, 409000, 'Ví điện tử', '2026-04-11 12:54:00', 'Thành công'),
(1215, 210000, 'MoMo', '2026-04-11 12:53:00', 'Thành công'),
(1216, 430000, 'Thẻ ngân hàng', '2026-04-11 16:05:00', 'Thành công'),
(1217, 315000, 'Ví điện tử', '2026-04-11 18:09:00', 'Thành công'),
(1218, 661000, 'Chuyển khoản', '2026-04-11 17:04:00', 'Thành công'),
(1219, 147000, 'Tiền mặt', '2026-04-11 17:33:00', 'Thành công'),
(1220, 410000, 'MoMo', '2026-04-11 17:12:00', 'Thành công'),
(1221, 345000, 'Thẻ ngân hàng', '2026-04-11 18:30:00', 'Thành công'),
(1222, 315000, 'Ví điện tử', '2026-04-11 19:13:00', 'Thành công'),
(1223, 210000, 'Tiền mặt', '2026-04-11 19:34:00', 'Thành công'),
(1224, 589000, 'Chuyển khoản', '2026-04-11 21:49:00', 'Thành công'),
(1225, 285000, 'Chuyển khoản', '2026-04-11 21:24:00', 'Thành công'),
(1226, 599000, 'MoMo', '2026-04-11 21:31:00', 'Thành công'),
(1227, 809000, 'Tiền mặt', '2026-04-11 21:09:00', 'Thành công'),
(1228, 210000, 'Ví điện tử', '2026-04-11 19:37:00', 'Thành công'),
(1229, 420000, 'Ví điện tử', '2026-04-11 21:50:00', 'Thành công'),
(1230, 390000, 'Thẻ ngân hàng', '2026-04-11 21:05:00', 'Thành công'),
(1231, 210000, 'Tiền mặt', '2026-04-11 21:19:00', 'Thành công'),
(1232, 528000, 'MoMo', '2026-04-11 20:46:00', 'Thành công'),
(1233, 135000, 'Tiền mặt', '2026-04-11 21:44:00', 'Thành công'),
(1234, 529000, 'Thẻ ngân hàng', '2026-04-11 08:44:00', 'Thành công'),
(1235, 388000, 'Ví điện tử', '2026-04-11 09:03:00', 'Thành công'),
(1236, 360000, 'Chuyển khoản', '2026-04-11 08:46:00', 'Thành công'),
(1237, 180000, 'Chuyển khoản', '2026-04-11 08:49:00', 'Thành công'),
(1238, 469000, 'Tiền mặt', '2026-04-11 08:33:00', 'Thành công'),
(1239, 470000, 'Tiền mặt', '2026-04-11 11:33:00', 'Thành công'),
(1240, 200000, 'Tiền mặt', '2026-04-11 12:44:00', 'Thành công'),
(1241, 200000, 'MoMo', '2026-04-11 11:23:00', 'Thành công'),
(1242, 270000, 'MoMo', '2026-04-11 11:23:00', 'Thành công'),
(1243, 100000, 'Ví điện tử', '2026-04-11 11:11:00', 'Thành công'),
(1244, 330000, 'Chuyển khoản', '2026-04-11 14:16:00', 'Thành công'),
(1245, 198000, 'MoMo', '2026-04-11 15:11:00', 'Thành công'),
(1246, 220000, 'Ví điện tử', '2026-04-11 14:49:00', 'Thành công'),
(1247, 187000, 'Ví điện tử', '2026-04-11 14:09:00', 'Thành công'),
(1248, 330000, 'MoMo', '2026-04-11 15:37:00', 'Thành công'),
(1249, 330000, 'Ví điện tử', '2026-04-11 14:03:00', 'Thành công'),
(1250, 110000, 'Tiền mặt', '2026-04-11 13:55:00', 'Thành công'),
(1251, 689000, 'Tiền mặt', '2026-04-11 16:58:00', 'Thành công'),
(1252, 432000, 'Ví điện tử', '2026-04-11 19:01:00', 'Thành công'),
(1253, 600000, 'Chuyển khoản', '2026-04-11 17:06:00', 'Thành công'),
(1254, 240000, 'Tiền mặt', '2026-04-11 16:48:00', 'Thành công'),
(1255, 480000, 'Thẻ ngân hàng', '2026-04-11 17:02:00', 'Thành công'),
(1256, 360000, 'Ví điện tử', '2026-04-11 18:26:00', 'Thành công'),
(1257, 409000, 'Thẻ ngân hàng', '2026-04-11 16:51:00', 'Thành công'),
(1258, 120000, 'MoMo', '2026-04-11 17:43:00', 'Thành công'),
(1259, 324000, 'Ví điện tử', '2026-04-11 17:46:00', 'Thành công'),
(1260, 240000, 'MoMo', '2026-04-11 19:06:00', 'Thành công'),
(1261, 220000, 'MoMo', '2026-04-11 20:29:00', 'Thành công'),
(1262, 390000, 'MoMo', '2026-04-11 21:11:00', 'Thành công'),
(1263, 389000, 'Thẻ ngân hàng', '2026-04-11 21:50:00', 'Thành công'),
(1264, 410000, 'Chuyển khoản', '2026-04-11 21:53:00', 'Thành công'),
(1265, 310000, 'Ví điện tử', '2026-04-11 21:56:00', 'Thành công'),
(1266, 220000, 'Thẻ ngân hàng', '2026-04-11 20:34:00', 'Thành công'),
(1267, 479000, 'Thẻ ngân hàng', '2026-04-11 21:51:00', 'Thành công'),
(1268, 220000, 'Thẻ ngân hàng', '2026-04-11 20:19:00', 'Thành công'),
(1269, 220000, 'Ví điện tử', '2026-04-11 20:34:00', 'Thành công'),
(1270, 110000, 'Tiền mặt', '2026-04-11 22:17:00', 'Thành công'),
(1271, 539000, 'Thẻ ngân hàng', '2026-04-11 09:06:00', 'Thành công'),
(1272, 769000, 'Ví điện tử', '2026-04-11 09:30:00', 'Thành công'),
(1273, 170000, 'Ví điện tử', '2026-04-11 09:02:00', 'Thành công'),
(1274, 300000, 'Chuyển khoản', '2026-04-11 09:46:00', 'Thành công'),
(1275, 100000, 'Tiền mặt', '2026-04-11 09:48:00', 'Thành công'),
(1276, 440000, 'MoMo', '2026-04-11 12:37:00', 'Thành công'),
(1277, 739000, 'Ví điện tử', '2026-04-11 13:13:00', 'Thành công'),
(1278, 396000, 'Thẻ ngân hàng', '2026-04-11 12:59:00', 'Thành công'),
(1279, 199000, 'Chuyển khoản', '2026-04-11 12:21:00', 'Thành công'),
(1280, 690000, 'MoMo', '2026-04-11 14:42:00', 'Thành công'),
(1281, 240000, 'MoMo', '2026-04-11 15:10:00', 'Thành công'),
(1282, 480000, 'Ví điện tử', '2026-04-11 14:47:00', 'Thành công'),
(1283, 601000, 'MoMo', '2026-04-11 14:52:00', 'Thành công'),
(1284, 120000, 'Ví điện tử', '2026-04-11 15:14:00', 'Thành công'),
(1285, 260000, 'Tiền mặt', '2026-04-11 18:36:00', 'Thành công'),
(1286, 490000, 'Chuyển khoản', '2026-04-11 19:37:00', 'Thành công'),
(1287, 490000, 'Thẻ ngân hàng', '2026-04-11 19:40:00', 'Thành công'),
(1288, 260000, 'Thẻ ngân hàng', '2026-04-11 19:57:00', 'Thành công'),
(1289, 390000, 'Tiền mặt', '2026-04-11 19:19:00', 'Thành công'),
(1290, 520000, 'Chuyển khoản', '2026-04-11 18:24:00', 'Thành công'),
(1291, 390000, 'Chuyển khoản', '2026-04-11 19:46:00', 'Thành công'),
(1292, 234000, 'Ví điện tử', '2026-04-11 19:26:00', 'Thành công'),
(1293, 260000, 'MoMo', '2026-04-11 18:53:00', 'Thành công'),
(1294, 540000, 'Chuyển khoản', '2026-04-11 10:12:00', 'Thành công'),
(1295, 574000, 'Thẻ ngân hàng', '2026-04-11 10:03:00', 'Thành công'),
(1296, 270000, 'MoMo', '2026-04-11 10:30:00', 'Thành công'),
(1297, 405000, 'Thẻ ngân hàng', '2026-04-11 10:13:00', 'Thành công'),
(1298, 405000, 'Ví điện tử', '2026-04-11 09:57:00', 'Thành công'),
(1299, 174000, 'Thẻ ngân hàng', '2026-04-11 10:08:00', 'Thành công'),
(1300, 491000, 'Tiền mặt', '2026-04-11 12:37:00', 'Thành công'),
(1301, 435000, 'Tiền mặt', '2026-04-11 12:32:00', 'Thành công'),
(1302, 580000, 'Thẻ ngân hàng', '2026-04-11 12:16:00', 'Thành công'),
(1303, 290000, 'Thẻ ngân hàng', '2026-04-11 14:21:00', 'Thành công'),
(1304, 145000, 'Chuyển khoản', '2026-04-11 12:26:00', 'Thành công'),
(1305, 620000, 'Thẻ ngân hàng', '2026-04-11 17:26:00', 'Thành công'),
(1306, 620000, 'Tiền mặt', '2026-04-11 16:25:00', 'Thành công'),
(1307, 590000, 'Chuyển khoản', '2026-04-11 17:25:00', 'Thành công'),
(1308, 435000, 'Ví điện tử', '2026-04-11 17:10:00', 'Thành công'),
(1309, 465000, 'Chuyển khoản', '2026-04-11 16:26:00', 'Thành công'),
(1310, 660000, 'Ví điện tử', '2026-04-11 19:50:00', 'Thành công'),
(1311, 495000, 'MoMo', '2026-04-11 20:46:00', 'Thành công'),
(1312, 330000, 'MoMo', '2026-04-11 20:15:00', 'Thành công'),
(1313, 330000, 'Thẻ ngân hàng', '2026-04-11 19:42:00', 'Thành công'),
(1314, 165000, 'Ví điện tử', '2026-04-11 21:07:00', 'Thành công'),
(1315, 610000, 'MoMo', '2026-04-11 20:59:00', 'Thành công'),
(1316, 495000, 'Tiền mặt', '2026-04-11 22:02:00', 'Thành công'),
(1317, 297000, 'Tiền mặt', '2026-04-11 20:50:00', 'Thành công'),
(1318, 310000, 'Chuyển khoản', '2026-04-11 21:16:00', 'Thành công'),
(1319, 432000, 'Ví điện tử', '2026-04-11 08:34:00', 'Thành công'),
(1320, 359000, 'MoMo', '2026-04-11 08:10:00', 'Thành công'),
(1321, 180000, 'Chuyển khoản', '2026-04-11 09:23:00', 'Thành công'),
(1322, 559000, 'Thẻ ngân hàng', '2026-04-11 09:56:00', 'Thành công'),
(1323, 360000, 'Thẻ ngân hàng', '2026-04-11 10:46:00', 'Thành công'),
(1324, 180000, 'Thẻ ngân hàng', '2026-04-11 09:59:00', 'Thành công'),
(1325, 524000, 'Thẻ ngân hàng', '2026-04-11 11:09:00', 'Thành công'),
(1326, 180000, 'Chuyển khoản', '2026-04-11 13:39:00', 'Thành công'),
(1327, 300000, 'Chuyển khoản', '2026-04-11 13:46:00', 'Thành công'),
(1328, 400000, 'Tiền mặt', '2026-04-11 13:35:00', 'Thành công'),
(1329, 300000, 'Tiền mặt', '2026-04-11 15:09:00', 'Thành công'),
(1330, 400000, 'Ví điện tử', '2026-04-11 14:38:00', 'Thành công'),
(1331, 399000, 'Ví điện tử', '2026-04-11 13:41:00', 'Thành công'),
(1332, 180000, 'Chuyển khoản', '2026-04-11 13:01:00', 'Thành công'),
(1333, 110000, 'MoMo', '2026-04-11 15:50:00', 'Thành công'),
(1334, 330000, 'Tiền mặt', '2026-04-11 17:38:00', 'Thành công'),
(1335, 630000, 'Tiền mặt', '2026-04-11 16:42:00', 'Thành công'),
(1336, 389000, 'Tiền mặt', '2026-04-11 17:31:00', 'Thành công'),
(1337, 440000, 'Tiền mặt', '2026-04-11 16:36:00', 'Thành công'),
(1338, 270000, 'MoMo', '2026-04-11 19:36:00', 'Thành công'),
(1339, 180000, 'MoMo', '2026-04-11 19:14:00', 'Thành công'),
(1340, 100000, 'Ví điện tử', '2026-04-11 20:34:00', 'Thành công'),
(1341, 200000, 'Chuyển khoản', '2026-04-11 19:10:00', 'Thành công'),
(1342, 599000, 'Thẻ ngân hàng', '2026-04-11 20:57:00', 'Thành công'),
(1343, 350000, 'Chuyển khoản', '2026-04-11 21:16:00', 'Thành công'),
(1344, 369000, 'Ví điện tử', '2026-04-11 20:38:00', 'Thành công'),
(1345, 200000, 'Chuyển khoản', '2026-04-11 19:03:00', 'Thành công'),
(1346, 400000, 'Thẻ ngân hàng', '2026-04-11 20:18:00', 'Thành công'),
(1347, 350000, 'Tiền mặt', '2026-04-11 19:37:00', 'Thành công'),
(1348, 100000, 'MoMo', '2026-04-11 20:28:00', 'Thành công'),
(1349, 255000, 'MoMo', '2026-04-12 08:42:00', 'Thành công'),
(1350, 340000, 'MoMo', '2026-04-12 07:43:00', 'Thành công'),
(1351, 340000, 'Tiền mặt', '2026-04-12 07:40:00', 'Thành công'),
(1352, 380000, 'MoMo', '2026-04-12 11:27:00', 'Thành công'),
(1353, 380000, 'Thẻ ngân hàng', '2026-04-12 12:02:00', 'Thành công'),
(1354, 529000, 'Tiền mặt', '2026-04-12 10:56:00', 'Thành công'),
(1355, 285000, 'Tiền mặt', '2026-04-12 10:05:00', 'Thành công'),
(1356, 190000, 'Chuyển khoản', '2026-04-12 10:23:00', 'Thành công'),
(1357, 619000, 'Ví điện tử', '2026-04-12 13:23:00', 'Thành công'),
(1358, 420000, 'MoMo', '2026-04-12 12:55:00', 'Thành công'),
(1359, 589000, 'Tiền mặt', '2026-04-12 13:21:00', 'Thành công'),
(1360, 486000, 'Tiền mặt', '2026-04-12 12:50:00', 'Thành công'),
(1361, 414000, 'Ví điện tử', '2026-04-12 17:47:00', 'Thành công'),
(1362, 325000, 'MoMo', '2026-04-12 18:02:00', 'Thành công'),
(1363, 230000, 'Ví điện tử', '2026-04-12 17:54:00', 'Thành công'),
(1364, 302000, 'Thẻ ngân hàng', '2026-04-12 17:30:00', 'Thành công'),
(1365, 406000, 'Tiền mặt', '2026-04-12 16:00:00', 'Thành công'),
(1366, 659000, 'Tiền mặt', '2026-04-12 17:55:00', 'Thành công'),
(1367, 460000, 'MoMo', '2026-04-12 16:03:00', 'Thành công'),
(1368, 345000, 'Thẻ ngân hàng', '2026-04-12 17:58:00', 'Thành công'),
(1369, 115000, 'Ví điện tử', '2026-04-12 16:41:00', 'Thành công'),
(1370, 230000, 'Tiền mặt', '2026-04-12 17:53:00', 'Thành công'),
(1371, 230000, 'Thẻ ngân hàng', '2026-04-12 16:58:00', 'Thành công'),
(1372, 599000, 'Ví điện tử', '2026-04-12 19:51:00', 'Thành công'),
(1373, 210000, 'Tiền mặt', '2026-04-12 20:36:00', 'Thành công'),
(1374, 285000, 'MoMo', '2026-04-12 19:12:00', 'Thành công'),
(1375, 420000, 'Thẻ ngân hàng', '2026-04-12 20:26:00', 'Thành công'),
(1376, 539000, 'MoMo', '2026-04-12 19:52:00', 'Thành công'),
(1377, 315000, 'MoMo', '2026-04-12 20:09:00', 'Thành công'),
(1378, 90000, 'Ví điện tử', '2026-04-12 09:20:00', 'Thành công'),
(1379, 180000, 'MoMo', '2026-04-12 08:43:00', 'Thành công'),
(1380, 360000, 'MoMo', '2026-04-12 09:16:00', 'Thành công'),
(1381, 90000, 'MoMo', '2026-04-12 09:38:00', 'Thành công'),
(1382, 243000, 'Ví điện tử', '2026-04-12 08:48:00', 'Thành công'),
(1383, 200000, 'Chuyển khoản', '2026-04-12 12:01:00', 'Thành công'),
(1384, 270000, 'Chuyển khoản', '2026-04-12 10:27:00', 'Thành công'),
(1385, 599000, 'MoMo', '2026-04-12 11:04:00', 'Thành công'),
(1386, 300000, 'Chuyển khoản', '2026-04-12 10:53:00', 'Thành công'),
(1387, 469000, 'MoMo', '2026-04-12 13:31:00', 'Thành công'),
(1388, 390000, 'Chuyển khoản', '2026-04-12 14:30:00', 'Thành công'),
(1389, 396000, 'Ví điện tử', '2026-04-12 15:30:00', 'Thành công'),
(1390, 110000, 'MoMo', '2026-04-12 14:12:00', 'Thành công'),
(1391, 199000, 'Ví điện tử', '2026-04-12 14:50:00', 'Thành công'),
(1392, 360000, 'Ví điện tử', '2026-04-12 17:50:00', 'Thành công'),
(1393, 379000, 'Tiền mặt', '2026-04-12 17:41:00', 'Thành công'),
(1394, 409000, 'Tiền mặt', '2026-04-12 19:00:00', 'Thành công'),
(1395, 240000, 'Thẻ ngân hàng', '2026-04-12 18:49:00', 'Thành công'),
(1396, 360000, 'Chuyển khoản', '2026-04-12 17:09:00', 'Thành công'),
(1397, 629000, 'Chuyển khoản', '2026-04-12 18:15:00', 'Thành công'),
(1398, 220000, 'Ví điện tử', '2026-04-12 21:45:00', 'Thành công'),
(1399, 297000, 'Thẻ ngân hàng', '2026-04-12 20:24:00', 'Thành công'),
(1400, 330000, 'Ví điện tử', '2026-04-12 21:40:00', 'Thành công'),
(1401, 499000, 'Chuyển khoản', '2026-04-12 21:39:00', 'Thành công'),
(1402, 110000, 'Chuyển khoản', '2026-04-12 20:08:00', 'Thành công'),
(1403, 410000, 'Tiền mặt', '2026-04-12 22:03:00', 'Thành công'),
(1404, 315000, 'Thẻ ngân hàng', '2026-04-12 19:43:00', 'Thành công'),
(1405, 330000, 'MoMo', '2026-04-12 20:05:00', 'Thành công'),
(1406, 220000, 'Ví điện tử', '2026-04-12 21:05:00', 'Thành công'),
(1407, 110000, 'Ví điện tử', '2026-04-12 22:16:00', 'Thành công'),
(1408, 300000, 'Thẻ ngân hàng', '2026-04-12 09:33:00', 'Thành công'),
(1409, 200000, 'Chuyển khoản', '2026-04-12 09:34:00', 'Thành công'),
(1410, 195000, 'Thẻ ngân hàng', '2026-04-12 09:07:00', 'Thành công'),
(1411, 300000, 'MoMo', '2026-04-12 09:02:00', 'Thành công'),
(1412, 300000, 'Tiền mặt', '2026-04-12 09:48:00', 'Thành công'),
(1413, 289000, 'Chuyển khoản', '2026-04-12 09:39:00', 'Thành công'),
(1414, 300000, 'Thẻ ngân hàng', '2026-04-12 09:03:00', 'Thành công'),
(1415, 399000, 'MoMo', '2026-04-12 09:23:00', 'Thành công'),
(1416, 330000, 'Thẻ ngân hàng', '2026-04-12 13:04:00', 'Thành công'),
(1417, 300000, 'MoMo', '2026-04-12 13:03:00', 'Thành công'),
(1418, 550000, 'Thẻ ngân hàng', '2026-04-12 13:21:00', 'Thành công'),
(1419, 110000, 'MoMo', '2026-04-12 13:30:00', 'Thành công'),
(1420, 110000, 'Ví điện tử', '2026-04-12 12:53:00', 'Thành công'),
(1421, 450000, 'Ví điện tử', '2026-04-12 15:36:00', 'Thành công'),
(1422, 480000, 'Thẻ ngân hàng', '2026-04-12 14:33:00', 'Thành công'),
(1423, 240000, 'Thẻ ngân hàng', '2026-04-12 16:36:00', 'Thành công'),
(1424, 409000, 'Thẻ ngân hàng', '2026-04-12 15:52:00', 'Thành công'),
(1425, 240000, 'Ví điện tử', '2026-04-12 15:04:00', 'Thành công'),
(1426, 520000, 'Ví điện tử', '2026-04-12 18:03:00', 'Thành công'),
(1427, 390000, 'Ví điện tử', '2026-04-12 19:04:00', 'Thành công'),
(1428, 520000, 'Chuyển khoản', '2026-04-12 20:22:00', 'Thành công'),
(1429, 130000, 'Ví điện tử', '2026-04-12 20:30:00', 'Thành công'),
(1430, 719000, 'Chuyển khoản', '2026-04-12 19:21:00', 'Thành công'),
(1431, 360000, 'MoMo', '2026-04-12 20:11:00', 'Thành công'),
(1432, 405000, 'MoMo', '2026-04-12 09:52:00', 'Thành công'),
(1433, 405000, 'Chuyển khoản', '2026-04-12 10:28:00', 'Thành công'),
(1434, 405000, 'Ví điện tử', '2026-04-12 10:28:00', 'Thành công'),
(1435, 550000, 'Chuyển khoản', '2026-04-12 13:20:00', 'Thành công'),
(1436, 145000, 'Tiền mặt', '2026-04-12 13:03:00', 'Thành công'),
(1437, 580000, 'Thẻ ngân hàng', '2026-04-12 13:46:00', 'Thành công'),
(1438, 435000, 'Chuyển khoản', '2026-04-12 14:08:00', 'Thành công'),
(1439, 290000, 'Ví điện tử', '2026-04-12 12:32:00', 'Thành công'),
(1440, 590000, 'MoMo', '2026-04-12 17:41:00', 'Thành công'),
(1441, 590000, 'Ví điện tử', '2026-04-12 16:59:00', 'Thành công'),
(1442, 620000, 'MoMo', '2026-04-12 17:46:00', 'Thành công'),
(1443, 418500, 'Tiền mặt', '2026-04-12 16:51:00', 'Thành công'),
(1444, 155000, 'Tiền mặt', '2026-04-12 18:08:00', 'Thành công'),
(1445, 590000, 'Ví điện tử', '2026-04-12 18:15:00', 'Thành công'),
(1446, 405000, 'Thẻ ngân hàng', '2026-04-12 17:34:00', 'Thành công'),
(1447, 310000, 'Thẻ ngân hàng', '2026-04-12 15:35:00', 'Thành công'),
(1448, 155000, 'Ví điện tử', '2026-04-12 17:16:00', 'Thành công'),
(1449, 825000, 'Ví điện tử', '2026-04-12 19:31:00', 'Thành công'),
(1450, 859000, 'MoMo', '2026-04-12 21:16:00', 'Thành công'),
(1451, 330000, 'Ví điện tử', '2026-04-12 21:32:00', 'Thành công'),
(1452, 475000, 'MoMo', '2026-04-12 21:31:00', 'Thành công'),
(1453, 224000, 'Thẻ ngân hàng', '2026-04-12 19:50:00', 'Thành công'),
(1454, 329000, 'Thẻ ngân hàng', '2026-04-12 08:30:00', 'Thành công'),
(1455, 404000, 'Tiền mặt', '2026-04-12 08:17:00', 'Thành công'),
(1456, 160000, 'Tiền mặt', '2026-04-12 08:27:00', 'Thành công'),
(1457, 160000, 'Ví điện tử', '2026-04-12 08:15:00', 'Thành công'),
(1458, 519000, 'Ví điện tử', '2026-04-12 08:07:00', 'Thành công'),
(1459, 80000, 'MoMo', '2026-04-12 07:29:00', 'Thành công'),
(1460, 122000, 'Chuyển khoản', '2026-04-12 09:24:00', 'Thành công'),
(1461, 370000, 'Tiền mặt', '2026-04-12 11:41:00', 'Thành công'),
(1462, 90000, 'Thẻ ngân hàng', '2026-04-12 10:07:00', 'Thành công'),
(1463, 360000, 'MoMo', '2026-04-12 10:36:00', 'Thành công'),
(1464, 270000, 'Ví điện tử', '2026-04-12 11:10:00', 'Thành công'),
(1465, 400000, 'MoMo', '2026-04-12 14:45:00', 'Thành công'),
(1466, 270000, 'Ví điện tử', '2026-04-12 14:32:00', 'Thành công'),
(1467, 400000, 'Tiền mặt', '2026-04-12 12:49:00', 'Thành công'),
(1468, 100000, 'Thẻ ngân hàng', '2026-04-12 13:27:00', 'Thành công'),
(1469, 200000, 'MoMo', '2026-04-12 14:57:00', 'Thành công'),
(1470, 390000, 'Chuyển khoản', '2026-04-12 17:52:00', 'Thành công'),
(1471, 198000, 'Thẻ ngân hàng', '2026-04-12 16:48:00', 'Thành công'),
(1472, 500000, 'Tiền mặt', '2026-04-12 18:14:00', 'Thành công'),
(1473, 110000, 'Chuyển khoản', '2026-04-12 17:29:00', 'Thành công'),
(1474, 390000, 'Tiền mặt', '2026-04-12 16:04:00', 'Thành công'),
(1475, 330000, 'Ví điện tử', '2026-04-12 18:16:00', 'Thành công'),
(1476, 370000, 'Ví điện tử', '2026-04-12 20:21:00', 'Thành công'),
(1477, 649000, 'Thẻ ngân hàng', '2026-04-12 21:39:00', 'Thành công'),
(1478, 300000, 'Thẻ ngân hàng', '2026-04-12 20:39:00', 'Thành công'),
(1479, 380000, 'Ví điện tử', '2026-04-12 21:28:00', 'Thành công'),
(1480, 200000, 'Ví điện tử', '2026-04-12 21:04:00', 'Thành công');

-- Cộng điểm tích lũy từ các đơn thanh toán thành công
UPDATE KhachHang kh
JOIN (
    SELECT
        dh.MaKhachHang,
        SUM(FLOOR(tt.SoTien / 10000)) AS DiemCongThem
    FROM DonHang dh
    JOIN ThanhToan tt ON tt.MaDonHang = dh.MaDonHang
    WHERE dh.MaKhachHang IS NOT NULL
      AND tt.TrangThaiThanhToan = 'Thành công'
    GROUP BY dh.MaKhachHang
) x ON x.MaKhachHang = kh.MaKhachHang
SET kh.DiemTichLuy = kh.DiemTichLuy + x.DiemCongThem;

SET SQL_SAFE_UPDATES = 0;

UPDATE KhachHang
SET HangThanhVien = CASE
    WHEN DiemTichLuy >= 800 THEN 'Kim cương'
    WHEN DiemTichLuy >= 400 THEN 'Vàng'
    WHEN DiemTichLuy >= 150 THEN 'Bạc'
    ELSE 'Thường'
END;

SET SQL_SAFE_UPDATES = 1;

COMMIT;

SELECT 'Import done - realistic revenue pattern' AS message;
