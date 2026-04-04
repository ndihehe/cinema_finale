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

INSERT INTO ChucVu (TenChucVu, MoTa) VALUES
('Quản lý', 'Quản lý vận hành rạp'),
('Thu ngân', 'Bán vé và thu tiền'),
('Nhân viên quầy vé', 'Hỗ trợ khách đặt vé'),
('Nhân viên kỹ thuật', 'Vận hành máy chiếu và âm thanh');

INSERT INTO NhanVien (HoTen, NgaySinh, GioiTinh, SoDienThoai, Email, DiaChi, MaChucVu, TrangThaiLamViec) VALUES
('Nguyễn Minh Anh', '1990-05-12', 'Nam', '0901000001', 'minhanh01@gmail.com', 'TP.HCM', 1, 'Đang làm'),
('Trần Thu Hà', '1995-08-21', 'Nữ', '0901000002', 'thuha02@gmail.com', 'TP.HCM', 2, 'Đang làm'),
('Lê Quốc Bảo', '1998-03-15', 'Nam', '0901000003', 'quocbao03@gmail.com', 'TP.HCM', 2, 'Đang làm'),
('Phạm Ngọc Lan', '1997-11-09', 'Nữ', '0901000004', 'ngoclan04@gmail.com', 'TP.HCM', 3, 'Nghỉ việc');

INSERT INTO KhachHang (HoTen, SoDienThoai, Email, GioiTinh, NgaySinh, DiemTichLuy, HangThanhVien) VALUES
('Nguyễn Thị Mai', '0912000001', 'nguyenmaikh01@gmail.com', 'Nữ', '1998-03-12', 120, 'Bạc'),
('Trần Văn Hùng', '0912000002', 'tranvanhung02@gmail.com', 'Nam', '1995-07-25', 350, 'Vàng'),
('Lê Ngọc Anh', '0912000003', 'lengocanh03@gmail.com', 'Nữ', '2000-11-08', 40, 'Thường');

INSERT INTO TaiKhoan (TenDangNhap, MatKhau, LoaiTaiKhoan, MaNhanVien, MaKhachHang, TrangThaiTaiKhoan, NgayTao) VALUES
('staff01', '123456', 'NhanVien', 1, NULL, 'Hoạt động', NOW()),
('staff02', '123456', 'NhanVien', 2, NULL, 'Hoạt động', NOW()),
('cust01', '123456', 'KhachHang', NULL, 1, 'Hoạt động', NOW());

INSERT INTO LoaiKhuyenMai (TenLoaiKhuyenMai, MoTa) VALUES
('Giảm theo phần trăm', 'Giảm theo % tổng đơn'),
('Giảm tiền trực tiếp', 'Trừ trực tiếp vào tổng tiền');

INSERT INTO KhuyenMai (TenKhuyenMai, MaLoaiKhuyenMai, KieuGiaTri, GiaTri, NgayBatDau, NgayKetThuc, DonHangToiThieu, TrangThai) VALUES
('Giảm 10% toàn bộ vé', 1, '%', 10, NOW() - INTERVAL 30 DAY, NOW() + INTERVAL 90 DAY, 0, 'Hoạt động'),
('Giảm 30K cho đơn từ 200K', 2, 'TIEN', 30000, NOW() - INTERVAL 30 DAY, NOW() + INTERVAL 90 DAY, 200000, 'Hoạt động'),
('KM cũ đã dừng', 2, 'TIEN', 15000, NOW() - INTERVAL 180 DAY, NOW() - INTERVAL 60 DAY, 0, 'Ngừng');

INSERT INTO DanhMucSanPham (TenDanhMucSanPham, MoTa) VALUES
('Đồ ăn', 'Sản phẩm ăn nhanh'),
('Đồ uống', 'Sản phẩm nước uống'),
('Combo', 'Combo đồ ăn và nước');

INSERT INTO LoaiSanPham (TenLoaiSanPham, MaDanhMucSanPham, MoTa) VALUES
('Bắp rang', 1, 'Các loại bắp rang'),
('Nước ngọt', 2, 'Nước có ga'),
('Combo cá nhân', 3, 'Combo cho 1 người');

INSERT INTO SanPham (TenSanPham, DonGia, SoLuongTon, MaLoaiSanPham, TrangThai) VALUES
('Bắp rang bơ size M', 55000, 100, 1, 'Đang bán'),
('Coca Cola', 30000, 120, 2, 'Đang bán'),
('Combo 1 bắp + 1 nước', 79000, 60, 3, 'Đang bán');

INSERT INTO LoaiGheNgoi (TenLoaiGheNgoi, PhuThu) VALUES
('Ghế thường', 0),
('Ghế VIP', 20000),
('Ghế đôi', 40000);

INSERT INTO PhongChieu (TenPhongChieu, LoaiManHinh, HeThongAmThanh, TrangThaiPhong) VALUES
('Phòng 1', '2D', 'Dolby 7.1', 'Hoạt động'),
('Phòng 2', '3D', 'Dolby Atmos', 'Hoạt động'),
('Phòng 3', 'IMAX', 'Dolby Atmos', 'Bảo trì');

INSERT INTO GheNgoi (MaPhongChieu, HangGhe, SoGhe, MaLoaiGheNgoi, TrangThaiGhe)
SELECT
    pc.MaPhongChieu,
    h.HangGhe,
    s.SoGhe,
    CASE
        WHEN h.HangGhe = 'A' THEN (SELECT MaLoaiGheNgoi FROM LoaiGheNgoi WHERE TenLoaiGheNgoi = 'Ghế VIP' LIMIT 1)
        WHEN h.HangGhe = 'E' THEN (SELECT MaLoaiGheNgoi FROM LoaiGheNgoi WHERE TenLoaiGheNgoi = 'Ghế đôi' LIMIT 1)
        ELSE (SELECT MaLoaiGheNgoi FROM LoaiGheNgoi WHERE TenLoaiGheNgoi = 'Ghế thường' LIMIT 1)
    END,
    'Hoạt động'
FROM PhongChieu pc
CROSS JOIN (
    SELECT 'A' AS HangGhe
    UNION ALL SELECT 'B'
    UNION ALL SELECT 'C'
    UNION ALL SELECT 'D'
    UNION ALL SELECT 'E'
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
) s
WHERE pc.TrangThaiPhong IN ('Hoạt động', 'Bảo trì');

INSERT INTO Phim (TenPhim, TheLoai, DaoDien, ThoiLuong, GioiHanTuoi, DinhDang, NgayKhoiChieu, TrangThaiPhim) VALUES
('Hẹn Em Ngày Nhất Thực', 'Gia đình, Tình cảm', 'A. Director', 118, 16, '2D', CURDATE() - INTERVAL 10 DAY, 'Đang chiếu'),
('Thoát Khỏi Tận Thế', 'Khoa học viễn tưởng', 'B. Director', 157, 13, 'IMAX', CURDATE() - INTERVAL 5 DAY, 'Đang chiếu'),
('Cú Nhảy Kỳ Diệu', 'Hoạt hình, Phiêu lưu', 'C. Director', 105, 0, '2D', CURDATE() + INTERVAL 5 DAY, 'Sắp chiếu');

INSERT INTO SuatChieu (MaPhim, MaPhongChieu, NgayGioChieu, GiaVeCoBan, TrangThaiSuatChieu) VALUES
(1, 1, NOW() - INTERVAL 2 DAY, 85000, 'Đã chiếu'),
(1, 2, NOW() + INTERVAL 2 HOUR, 90000, 'Đang chiếu'),
(2, 1, NOW() + INTERVAL 1 DAY, 95000, 'Sắp chiếu'),
(2, 2, NOW() + INTERVAL 2 DAY, 110000, 'Sắp chiếu'),
(3, 1, NOW() + INTERVAL 5 DAY, 80000, 'Sắp chiếu');

INSERT INTO LoaiVe (TenLoaiVe, PhuThuGia, MoTa) VALUES
('Vé thường', 0, 'Áp dụng cho ghế thường'),
('Vé VIP', 30000, 'Áp dụng cho ghế VIP'),
('Vé đôi', 50000, 'Áp dụng cho ghế đôi');

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
    (lgn.TenLoaiGheNgoi = 'Ghế đôi' AND lv.TenLoaiVe = 'Vé đôi')
);

INSERT INTO DonHang (MaKhachHang, MaNhanVien, MaKhuyenMai, NgayLap, TrangThaiDonHang, GhiChu) VALUES
(1, 1, 1, NOW() - INTERVAL 3 DAY, 'Đã thanh toán', 'Đơn test thống kê 1'),
(2, 2, 2, NOW() - INTERVAL 1 DAY, 'Đã thanh toán', 'Đơn test thống kê 2'),
(3, 2, NULL, NOW() - INTERVAL 4 HOUR, 'Chưa thanh toán', 'Đơn chờ thanh toán');

INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 1, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 1 AND g.HangGhe = 'B' AND g.SoGhe IN (1, 2, 3);

INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT 2, v.MaVe, v.GiaVe
FROM Ve v
JOIN GheNgoi g ON g.MaGheNgoi = v.MaGheNgoi
WHERE v.MaSuatChieu = 2 AND g.HangGhe = 'C' AND g.SoGhe IN (1, 2);

UPDATE Ve v
JOIN ChiTietDonHangVe ct ON ct.MaVe = v.MaVe
SET v.TrangThaiVe = 'Đã bán';

INSERT INTO ChiTietDonHangSanPham (MaDonHang, MaSanPham, SoLuong, DonGiaBan) VALUES
(1, 1, 1, 55000),
(1, 2, 2, 30000),
(2, 3, 1, 79000);

INSERT INTO ThanhToan (MaDonHang, SoTien, PhuongThucThanhToan, ThoiGianThanhToan, TrangThaiThanhToan) VALUES
(1, 370000, 'Tiền mặt', NOW() - INTERVAL 3 DAY + INTERVAL 15 MINUTE, 'Thành công'),
(2, 299000, 'Chuyển khoản', NOW() - INTERVAL 1 DAY + INTERVAL 10 MINUTE, 'Thành công'),
(3, 120000, 'Ví điện tử', NOW() - INTERVAL 2 HOUR, 'Thất bại');

-- =========================================================
-- BULK SEED DATA (REALISTIC SCALE)
-- =========================================================

-- 1) Khách hàng lớn (1,200 records)
INSERT INTO KhachHang (HoTen, SoDienThoai, Email, GioiTinh, NgaySinh, DiemTichLuy, HangThanhVien)
SELECT
    CONCAT('Khách hàng ', LPAD(seq.n, 4, '0')),
    CONCAT('098', LPAD(seq.n, 7, '0')),
    CONCAT('khach', LPAD(seq.n, 4, '0'), '@mail.com'),
    CASE
        WHEN seq.n % 3 = 0 THEN 'Nam'
        WHEN seq.n % 3 = 1 THEN 'Nữ'
        ELSE 'Khác'
    END,
    DATE_ADD('1980-01-01', INTERVAL (seq.n % 9000) DAY),
    (seq.n * 13) % 2500,
    CASE
        WHEN (seq.n * 13) % 2500 >= 1200 THEN 'Vàng'
        WHEN (seq.n * 13) % 2500 >= 500 THEN 'Bạc'
        ELSE 'Thường'
    END
FROM (
    SELECT ones.n + tens.n * 10 + hundreds.n * 100 + 1 AS n
    FROM
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) ones
        CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) tens
        CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) hundreds
) seq
WHERE seq.n <= 1200
  AND NOT EXISTS (
      SELECT 1 FROM KhachHang k WHERE k.SoDienThoai = CONCAT('098', LPAD(seq.n, 7, '0'))
  );

-- 2) Thêm tài khoản khách hàng (500 records)
INSERT INTO TaiKhoan (TenDangNhap, MatKhau, LoaiTaiKhoan, MaNhanVien, MaKhachHang, TrangThaiTaiKhoan, NgayTao)
SELECT
    CONCAT('kh_user_', LPAD(k.MaKhachHang, 5, '0')),
    '123456',
    'KhachHang',
    NULL,
    k.MaKhachHang,
    'Hoạt động',
    DATE_SUB(NOW(), INTERVAL (k.MaKhachHang % 365) DAY)
FROM KhachHang k
LEFT JOIN TaiKhoan tk ON tk.MaKhachHang = k.MaKhachHang
WHERE tk.MaTaiKhoan IS NULL
ORDER BY k.MaKhachHang
LIMIT 500;

-- 3) Phim lớn (120 records)
INSERT INTO Phim (TenPhim, TheLoai, DaoDien, ThoiLuong, GioiHanTuoi, DinhDang, NgayKhoiChieu, TrangThaiPhim)
SELECT
    CONCAT('Phim bom tấn ', LPAD(seq.n, 3, '0')),
    ELT((seq.n % 6) + 1, 'Hành động', 'Tình cảm', 'Hài', 'Kinh dị', 'Hoạt hình', 'Khoa học viễn tưởng'),
    CONCAT('Đạo diễn ', CHAR(65 + (seq.n % 26))),
    90 + (seq.n % 70),
    ELT((seq.n % 4) + 1, 0, 13, 16, 18),
    ELT((seq.n % 3) + 1, '2D', '3D', 'IMAX'),
    DATE_ADD(CURDATE(), INTERVAL (seq.n - 60) DAY),
    CASE
        WHEN seq.n < 35 THEN 'Ngừng chiếu'
        WHEN seq.n < 85 THEN 'Đang chiếu'
        ELSE 'Sắp chiếu'
    END
FROM (
    SELECT ones.n + tens.n * 10 + hundreds.n * 100 + 1 AS n
    FROM
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) ones
        CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) tens
        CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) hundreds
) seq
WHERE seq.n <= 120
  AND NOT EXISTS (
      SELECT 1 FROM Phim p WHERE p.TenPhim = CONCAT('Phim bom tấn ', LPAD(seq.n, 3, '0'))
  );

-- 4) Suất chiếu dày dữ liệu (khoảng 480 suất)
INSERT INTO SuatChieu (MaPhim, MaPhongChieu, NgayGioChieu, GiaVeCoBan, TrangThaiSuatChieu)
SELECT
    ((d.day_index + s.slot_index + pc.MaPhongChieu) % (SELECT MAX(MaPhim) FROM Phim)) + 1 AS MaPhim,
    pc.MaPhongChieu,
    TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL d.day_offset DAY), s.gio_chieu),
    70000 + ((d.day_index * 7000 + s.slot_index * 5000 + pc.MaPhongChieu * 3000) % 70000),
    CASE
        WHEN d.day_offset < 0 THEN 'Đã chiếu'
        WHEN d.day_offset = 0 THEN 'Đang chiếu'
        ELSE 'Sắp chiếu'
    END
FROM (
    SELECT n AS day_index, n - 30 AS day_offset
    FROM (
        SELECT ones.n + tens.n * 10 AS n
        FROM
            (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) ones
            CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) tens
    ) dd
    WHERE n BETWEEN 0 AND 60
) d
CROSS JOIN (
    SELECT 1 AS slot_index, '09:00:00' AS gio_chieu
    UNION ALL SELECT 2, '12:30:00'
    UNION ALL SELECT 3, '16:00:00'
    UNION ALL SELECT 4, '19:30:00'
) s
JOIN PhongChieu pc ON pc.TrangThaiPhong = 'Hoạt động'
WHERE NOT EXISTS (
    SELECT 1
    FROM SuatChieu sc
    WHERE sc.MaPhongChieu = pc.MaPhongChieu
      AND sc.NgayGioChieu = TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL d.day_offset DAY), s.gio_chieu)
);

-- 5) Vé cho các suất mới
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
    (lgn.TenLoaiGheNgoi = 'Ghế đôi' AND lv.TenLoaiVe = 'Vé đôi')
)
LEFT JOIN Ve v_exist ON v_exist.MaSuatChieu = sc.MaSuatChieu AND v_exist.MaGheNgoi = g.MaGheNgoi
WHERE v_exist.MaVe IS NULL;

-- 6) Đơn hàng lớn dựa trên vé chưa bán
DROP TEMPORARY TABLE IF EXISTS tmp_ticket_seed;
CREATE TEMPORARY TABLE tmp_ticket_seed (
    rn INT PRIMARY KEY,
    MaVe INT NOT NULL,
    GiaVe DECIMAL(18,2) NOT NULL
) ENGINE=Memory;

SET @rn := 0;
INSERT INTO tmp_ticket_seed (rn, MaVe, GiaVe)
SELECT
    (@rn := @rn + 1) AS rn,
    v.MaVe,
    v.GiaVe
FROM Ve v
JOIN SuatChieu sc ON sc.MaSuatChieu = v.MaSuatChieu
WHERE v.TrangThaiVe = 'Chưa bán'
  AND sc.NgayGioChieu <= NOW() + INTERVAL 1 DAY
ORDER BY sc.NgayGioChieu, v.MaVe
LIMIT 2500;

DROP TEMPORARY TABLE IF EXISTS tmp_order_seed;
CREATE TEMPORARY TABLE tmp_order_seed (
    seed_idx INT PRIMARY KEY,
    seed_code VARCHAR(30) NOT NULL,
    MaKhachHang INT NOT NULL,
    MaNhanVien INT NOT NULL,
    MaKhuyenMai INT NULL,
    NgayLap DATETIME NOT NULL,
    TrangThaiDonHang VARCHAR(30) NOT NULL
) ENGINE=Memory;

INSERT INTO tmp_order_seed (seed_idx, seed_code, MaKhachHang, MaNhanVien, MaKhuyenMai, NgayLap, TrangThaiDonHang)
SELECT
    t.rn,
    CONCAT('BULK_ORDER_', LPAD(t.rn, 6, '0')),
    ((t.rn - 1) % (SELECT MAX(MaKhachHang) FROM KhachHang)) + 1,
    ((t.rn - 1) % (SELECT MAX(MaNhanVien) FROM NhanVien)) + 1,
    CASE WHEN t.rn % 4 = 0 THEN ((t.rn - 1) % (SELECT MAX(MaKhuyenMai) FROM KhuyenMai)) + 1 ELSE NULL END,
    DATE_SUB(NOW(), INTERVAL (t.rn % 45) DAY) + INTERVAL (t.rn % 1440) MINUTE,
    CASE
        WHEN t.rn % 20 = 0 THEN 'Đã hủy'
        WHEN t.rn % 8 = 0 THEN 'Chưa thanh toán'
        ELSE 'Đã thanh toán'
    END
FROM tmp_ticket_seed t;

INSERT INTO DonHang (MaKhachHang, MaNhanVien, MaKhuyenMai, NgayLap, TrangThaiDonHang, GhiChu)
SELECT
    os.MaKhachHang,
    os.MaNhanVien,
    os.MaKhuyenMai,
    os.NgayLap,
    os.TrangThaiDonHang,
    os.seed_code
FROM tmp_order_seed os;

INSERT INTO ChiTietDonHangVe (MaDonHang, MaVe, DonGiaBan)
SELECT
    d.MaDonHang,
    t.MaVe,
    t.GiaVe
FROM tmp_order_seed os
JOIN DonHang d ON d.GhiChu = os.seed_code
JOIN tmp_ticket_seed t ON t.rn = os.seed_idx;

UPDATE Ve v
JOIN ChiTietDonHangVe ct ON ct.MaVe = v.MaVe
SET v.TrangThaiVe = 'Đã bán'
WHERE v.TrangThaiVe = 'Chưa bán';

-- 7) Chi tiết sản phẩm cho khoảng 60% đơn
INSERT INTO ChiTietDonHangSanPham (MaDonHang, MaSanPham, SoLuong, DonGiaBan)
SELECT
    d.MaDonHang,
    ((d.MaDonHang - 1) % (SELECT MAX(MaSanPham) FROM SanPham)) + 1,
    ((d.MaDonHang - 1) % 3) + 1,
    sp.DonGia
FROM DonHang d
JOIN SanPham sp ON sp.MaSanPham = ((d.MaDonHang - 1) % (SELECT MAX(MaSanPham) FROM SanPham)) + 1
WHERE d.GhiChu LIKE 'BULK_ORDER_%'
  AND (d.MaDonHang % 10) < 6;

-- 8) Thanh toán cho đơn đã thanh toán
INSERT INTO ThanhToan (MaDonHang, SoTien, PhuongThucThanhToan, ThoiGianThanhToan, TrangThaiThanhToan)
SELECT
    d.MaDonHang,
    COALESCE(vt.tong_ve, 0) + COALESCE(st.tong_sp, 0),
    ELT((d.MaDonHang % 3) + 1, 'Tiền mặt', 'Chuyển khoản', 'Ví điện tử'),
    DATE_ADD(d.NgayLap, INTERVAL 8 MINUTE),
    'Thành công'
FROM DonHang d
LEFT JOIN (
    SELECT MaDonHang, SUM(DonGiaBan) AS tong_ve
    FROM ChiTietDonHangVe
    GROUP BY MaDonHang
) vt ON vt.MaDonHang = d.MaDonHang
LEFT JOIN (
    SELECT MaDonHang, SUM(SoLuong * DonGiaBan) AS tong_sp
    FROM ChiTietDonHangSanPham
    GROUP BY MaDonHang
) st ON st.MaDonHang = d.MaDonHang
LEFT JOIN ThanhToan tt ON tt.MaDonHang = d.MaDonHang
WHERE d.TrangThaiDonHang = 'Đã thanh toán'
  AND tt.MaThanhToan IS NULL;

DROP TEMPORARY TABLE IF EXISTS tmp_order_seed;
DROP TEMPORARY TABLE IF EXISTS tmp_ticket_seed;

SELECT 'Schema + LARGE realistic seed completed' AS message;
