
DROP  DATABASE QuanLyBanVeXemPhim;

-- EXECUTE LẦN 1 

CREATE DATABASE QuanLyBanVeXemPhim;
USE QuanLyBanVeXemPhim;
 
 -- EXECUTE LẦN 2 
 
 
CREATE TABLE ChucVu (
    MaChucVu INT AUTO_INCREMENT NOT NULL,
    TenChucVu VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    MoTa VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,

    PRIMARY KEY (MaChucVu),
    UNIQUE (TenChucVu)
) ENGINE=InnoDB;


CREATE TABLE NhanVien (
    MaNhanVien INT AUTO_INCREMENT NOT NULL,
    HoTen VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    NgaySinh DATE NULL,
    GioiTinh VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    SoDienThoai VARCHAR(15) NULL,
    Email VARCHAR(100) NULL,
    DiaChi VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    MaChucVu INT NOT NULL,
    TrangThaiLamViec VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Đang làm',

    PRIMARY KEY (MaNhanVien),
    KEY IDX_NhanVien_ChucVu (MaChucVu),

    CONSTRAINT FK_NhanVien_ChucVu FOREIGN KEY (MaChucVu)
        REFERENCES ChucVu(MaChucVu),

    CONSTRAINT CK_NhanVien_GioiTinh CHECK (
        GioiTinh IS NULL OR GioiTinh IN ('Nam', 'Nữ', 'Khác')
    ),

    CONSTRAINT CK_NhanVien_TrangThai CHECK (
        TrangThaiLamViec IN ('Đang làm', 'Tạm nghỉ', 'Nghỉ việc')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE NhanVien 
    MODIFY COLUMN SoDienThoai VARCHAR(15) NOT NULL,
    ADD UNIQUE INDEX UX_NhanVien_SDT (SoDienThoai);
CREATE UNIQUE INDEX UX_NhanVien_Email ON NhanVien(Email);


CREATE TABLE KhachHang (
    MaKhachHang INT AUTO_INCREMENT NOT NULL,
    HoTen VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    SoDienThoai VARCHAR(15) NULL,
    Email VARCHAR(100) NULL,
    GioiTinh VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    NgaySinh DATE NULL,
    DiemTichLuy INT NOT NULL DEFAULT 0,
    HangThanhVien VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Thường',

    PRIMARY KEY (MaKhachHang),
    CONSTRAINT CK_KhachHang_GioiTinh CHECK (
        GioiTinh IS NULL OR GioiTinh IN ('Nam', 'Nữ', 'Khác')
    ),
    CONSTRAINT CK_KhachHang_Diem CHECK (DiemTichLuy >= 0),
    CONSTRAINT CK_KhachHang_Hang CHECK (
        HangThanhVien IN ('Thường', 'Bạc', 'Vàng', 'Kim cương')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Index (chạy 1 lần)
CREATE UNIQUE INDEX UX_KhachHang_SDT  ON KhachHang(SoDienThoai);
CREATE UNIQUE INDEX UX_KhachHang_Email ON KhachHang(Email);


CREATE TABLE TaiKhoan (
    MaTaiKhoan INT AUTO_INCREMENT NOT NULL,
    TenDangNhap VARCHAR(50) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    LoaiTaiKhoan VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    MaNhanVien INT NULL,
    MaKhachHang INT NULL,
    TrangThaiTaiKhoan VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Hoạt động',
    NgayTao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (MaTaiKhoan),
    UNIQUE (TenDangNhap),

    CONSTRAINT FK_TaiKhoan_NhanVien FOREIGN KEY (MaNhanVien)
        REFERENCES NhanVien(MaNhanVien),

    CONSTRAINT FK_TaiKhoan_KhachHang FOREIGN KEY (MaKhachHang)
        REFERENCES KhachHang(MaKhachHang),

    CONSTRAINT CK_TaiKhoan_Loai CHECK (
        LoaiTaiKhoan IN ('NhanVien', 'KhachHang')
    ),

    CONSTRAINT CK_TaiKhoan_TrangThai CHECK (
        TrangThaiTaiKhoan IN ('Hoạt động', 'Khóa')
    ),

    CONSTRAINT CK_TaiKhoan_ChuSoHuu CHECK (
        (LoaiTaiKhoan = 'NhanVien' AND MaNhanVien IS NOT NULL AND MaKhachHang IS NULL)
        OR
        (LoaiTaiKhoan = 'KhachHang' AND MaKhachHang IS NOT NULL AND MaNhanVien IS NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chỉ chạy 1 lần cho mỗi index
CREATE UNIQUE INDEX UX_TaiKhoan_MaNhanVien   ON TaiKhoan(MaNhanVien);
CREATE UNIQUE INDEX UX_TaiKhoan_MaKhachHang  ON TaiKhoan(MaKhachHang);

CREATE TABLE LoaiKhuyenMai (
    MaLoaiKhuyenMai INT AUTO_INCREMENT NOT NULL,
    TenLoaiKhuyenMai VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    MoTa VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,

    PRIMARY KEY (MaLoaiKhuyenMai),
    UNIQUE (TenLoaiKhuyenMai)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE KhuyenMai (
    MaKhuyenMai INT AUTO_INCREMENT NOT NULL,
    TenKhuyenMai VARCHAR(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    MaLoaiKhuyenMai INT NOT NULL,
    KieuGiaTri VARCHAR(10) NOT NULL,
    GiaTri DECIMAL(18,2) NOT NULL,
    NgayBatDau DATETIME NOT NULL,
    NgayKetThuc DATETIME NOT NULL,
    DonHangToiThieu DECIMAL(18,2) NOT NULL DEFAULT 0,
    TrangThai VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Hoạt động',

    PRIMARY KEY (MaKhuyenMai),
    KEY IX_KhuyenMai_Loai (MaLoaiKhuyenMai),

    CONSTRAINT FK_KhuyenMai_LoaiKhuyenMai FOREIGN KEY (MaLoaiKhuyenMai)
        REFERENCES LoaiKhuyenMai(MaLoaiKhuyenMai),

    CONSTRAINT CK_KhuyenMai_Kieu CHECK (
        KieuGiaTri IN ('PERCENT', 'VND')
    ),

    CONSTRAINT CK_KhuyenMai_GiaTri CHECK (GiaTri >= 0),
    
    CONSTRAINT CK_KhuyenMai_Percent CHECK (
        KieuGiaTri <> 'PERCENT' OR (GiaTri > 0 AND GiaTri <= 100)
    ),

    CONSTRAINT CK_KhuyenMai_ThoiGian CHECK (NgayKetThuc >= NgayBatDau),

    CONSTRAINT CK_KhuyenMai_DonHangToiThieu CHECK (DonHangToiThieu >= 0),

    CONSTRAINT CK_KhuyenMai_TrangThai CHECK (
        TrangThai IN ('Hoạt động', 'Ngừng áp dụng', 'Hết hạn')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE DanhMucSanPham (
    MaDanhMucSanPham INT AUTO_INCREMENT NOT NULL,
    TenDanhMucSanPham VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    MoTa VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,

    PRIMARY KEY (MaDanhMucSanPham),
    UNIQUE (TenDanhMucSanPham)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE LoaiSanPham (
    MaLoaiSanPham INT AUTO_INCREMENT NOT NULL,
    TenLoaiSanPham VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    MaDanhMucSanPham INT NOT NULL,
    MoTa VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,

    PRIMARY KEY (MaLoaiSanPham),
    UNIQUE (TenLoaiSanPham),
    KEY IX_LoaiSanPham_DanhMuc (MaDanhMucSanPham),

    CONSTRAINT FK_LoaiSanPham_DanhMuc FOREIGN KEY (MaDanhMucSanPham)
        REFERENCES DanhMucSanPham(MaDanhMucSanPham)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE SanPham (
    MaSanPham INT AUTO_INCREMENT NOT NULL,
    TenSanPham VARCHAR(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    SoLuongTon INT NOT NULL DEFAULT 0,
    MaLoaiSanPham INT NOT NULL,
    TrangThai VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Đang bán',

    PRIMARY KEY (MaSanPham),
    KEY IX_SanPham_Loai (MaLoaiSanPham),

    CONSTRAINT FK_SanPham_LoaiSanPham FOREIGN KEY (MaLoaiSanPham)
        REFERENCES LoaiSanPham(MaLoaiSanPham),

    CONSTRAINT CK_SanPham_DonGia CHECK (DonGia >= 0),
    CONSTRAINT CK_SanPham_SoLuong CHECK (SoLuongTon >= 0),
    CONSTRAINT CK_SanPham_TrangThai CHECK (
        TrangThai IN ('Đang bán', 'Hết hàng', 'Ngừng bán')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE LoaiGheNgoi (
    MaLoaiGheNgoi INT AUTO_INCREMENT NOT NULL,
    TenLoaiGheNgoi VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    PhuThu DECIMAL(18,2) NOT NULL DEFAULT 0,

    PRIMARY KEY (MaLoaiGheNgoi),
    UNIQUE (TenLoaiGheNgoi),
    CONSTRAINT CK_LoaiGheNgoi_PhuThu CHECK (PhuThu >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE PhongChieu (
    MaPhongChieu INT AUTO_INCREMENT NOT NULL,
    TenPhongChieu VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    LoaiManHinh VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    HeThongAmThanh VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    TrangThaiPhong VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Hoạt động',

    PRIMARY KEY (MaPhongChieu),
    UNIQUE (TenPhongChieu),
    CONSTRAINT CK_PhongChieu_TrangThai CHECK (
        TrangThaiPhong IN ('Hoạt động', 'Bảo trì', 'Ngưng sử dụng')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE GheNgoi (
    MaGheNgoi INT AUTO_INCREMENT NOT NULL,
    MaPhongChieu INT NOT NULL,
    HangGhe VARCHAR(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    SoGhe INT NOT NULL,
    MaLoaiGheNgoi INT NOT NULL,
    TrangThaiGhe VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Hoạt động',

    PRIMARY KEY (MaGheNgoi),
    KEY IX_GheNgoi_Phong (MaPhongChieu),

    CONSTRAINT FK_GheNgoi_PhongChieu FOREIGN KEY (MaPhongChieu)
        REFERENCES PhongChieu(MaPhongChieu),

    CONSTRAINT FK_GheNgoi_LoaiGheNgoi FOREIGN KEY (MaLoaiGheNgoi)
        REFERENCES LoaiGheNgoi(MaLoaiGheNgoi),

    CONSTRAINT UQ_GheNgoi_ViTri UNIQUE (MaPhongChieu, HangGhe, SoGhe),

    CONSTRAINT CK_GheNgoi_SoGhe CHECK (SoGhe > 0),

    CONSTRAINT CK_GheNgoi_TrangThai CHECK (
        TrangThaiGhe IN ('Hoạt động', 'Hỏng', 'Bị khóa')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Phim (
    MaPhim INT AUTO_INCREMENT NOT NULL,
    TenPhim VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    TheLoai VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    DaoDien VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    ThoiLuong INT NOT NULL,
    GioiHanTuoi INT NULL,
    DinhDang VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    NgayKhoiChieu DATE NULL,
    TrangThaiPhim VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sắp chiếu',

    PRIMARY KEY (MaPhim),

    CONSTRAINT CK_Phim_ThoiLuong CHECK (ThoiLuong > 0),

    CONSTRAINT CK_Phim_Tuoi CHECK (
        GioiHanTuoi IS NULL OR GioiHanTuoi >= 0
    ),

    CONSTRAINT CK_Phim_TrangThai CHECK (
        TrangThaiPhim IN ('Sắp chiếu', 'Đang chiếu', 'Ngừng chiếu')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE SuatChieu (
    MaSuatChieu INT AUTO_INCREMENT NOT NULL,
    MaPhim INT NOT NULL,
    MaPhongChieu INT NOT NULL,
    NgayGioChieu DATETIME NOT NULL,
    GiaVeCoBan DECIMAL(18,2) NOT NULL,
    TrangThaiSuatChieu VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sắp chiếu',

    PRIMARY KEY (MaSuatChieu),
    KEY IX_SuatChieu_Phim (MaPhim),
    KEY IX_SuatChieu_Phong (MaPhongChieu),

    CONSTRAINT FK_SuatChieu_Phim FOREIGN KEY (MaPhim)
        REFERENCES Phim(MaPhim),

    CONSTRAINT FK_SuatChieu_PhongChieu FOREIGN KEY (MaPhongChieu)
        REFERENCES PhongChieu(MaPhongChieu),

    CONSTRAINT UQ_SuatChieu_Phong_ThoiGian UNIQUE (MaPhongChieu, NgayGioChieu),

    CONSTRAINT CK_SuatChieu_GiaVe CHECK (GiaVeCoBan >= 0),

    CONSTRAINT CK_SuatChieu_TrangThai CHECK (
        TrangThaiSuatChieu IN ('Sắp chiếu', 'Đang chiếu', 'Đã chiếu', 'Hủy')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE LoaiVe (
    MaLoaiVe INT AUTO_INCREMENT NOT NULL,
    TenLoaiVe VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    PhuThuGia DECIMAL(18,2) NOT NULL DEFAULT 0,
    MoTa VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,

    PRIMARY KEY (MaLoaiVe),
    UNIQUE (TenLoaiVe),
    CONSTRAINT CK_LoaiVe_PhuThu CHECK (PhuThuGia >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Ve (
    MaVe INT AUTO_INCREMENT NOT NULL,
    MaSuatChieu INT NOT NULL,
    MaGheNgoi INT NOT NULL,
    MaLoaiVe INT NOT NULL,
    GiaVe DECIMAL(18,2) NOT NULL,
    TrangThaiVe VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Chưa bán',

    PRIMARY KEY (MaVe),
    KEY IX_Ve_SuatChieu (MaSuatChieu),

    CONSTRAINT FK_Ve_SuatChieu FOREIGN KEY (MaSuatChieu)
        REFERENCES SuatChieu(MaSuatChieu),

    CONSTRAINT FK_Ve_GheNgoi FOREIGN KEY (MaGheNgoi)
        REFERENCES GheNgoi(MaGheNgoi),

    CONSTRAINT FK_Ve_LoaiVe FOREIGN KEY (MaLoaiVe)
        REFERENCES LoaiVe(MaLoaiVe),

    CONSTRAINT UQ_Ve_SuatChieu_Ghe UNIQUE (MaSuatChieu, MaGheNgoi),

    CONSTRAINT CK_Ve_Gia CHECK (GiaVe >= 0),

    CONSTRAINT CK_Ve_TrangThai CHECK (
        TrangThaiVe IN ('Chưa bán', 'Đã giữ chỗ', 'Đã bán', 'Đã hủy')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE DonHang (
    MaDonHang INT AUTO_INCREMENT NOT NULL,
    MaKhachHang INT NULL,
    MaNhanVien INT NOT NULL,
    MaKhuyenMai INT NULL,
    NgayLap DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TrangThaiDonHang VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Chưa thanh toán',
    GhiChu VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,

    PRIMARY KEY (MaDonHang),
    KEY IX_DonHang_KhachHang (MaKhachHang),
    KEY IX_DonHang_NhanVien (MaNhanVien),

    CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY (MaKhachHang)
        REFERENCES KhachHang(MaKhachHang),

    CONSTRAINT FK_DonHang_NhanVien FOREIGN KEY (MaNhanVien)
        REFERENCES NhanVien(MaNhanVien),

    CONSTRAINT FK_DonHang_KhuyenMai FOREIGN KEY (MaKhuyenMai)
        REFERENCES KhuyenMai(MaKhuyenMai),

    CONSTRAINT CK_DonHang_TrangThai CHECK (
        TrangThaiDonHang IN ('Chưa thanh toán', 'Đã thanh toán', 'Đã hủy')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ChiTietDonHangVe (
    MaChiTietVe INT AUTO_INCREMENT NOT NULL,
    MaDonHang INT NOT NULL,
    MaVe INT NOT NULL,
    DonGiaBan DECIMAL(18,2) NOT NULL,

    PRIMARY KEY (MaChiTietVe),
    KEY IX_CTDHVe_DonHang (MaDonHang),

    CONSTRAINT FK_CTDHVe_DonHang FOREIGN KEY (MaDonHang)
        REFERENCES DonHang(MaDonHang),

    CONSTRAINT FK_CTDHVe_Ve FOREIGN KEY (MaVe)
        REFERENCES Ve(MaVe),

    CONSTRAINT UQ_CTDHVe_Ve UNIQUE (MaVe),

    CONSTRAINT CK_CTDHVe_DonGia CHECK (DonGiaBan >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ChiTietDonHangSanPham (
    MaChiTietSP INT AUTO_INCREMENT NOT NULL,
    MaDonHang INT NOT NULL,
    MaSanPham INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGiaBan DECIMAL(18,2) NOT NULL,

    PRIMARY KEY (MaChiTietSP),
    KEY IX_CTDHSP_DonHang (MaDonHang),
    KEY IX_CTDHSP_SanPham (MaSanPham),

    CONSTRAINT FK_CTDHSP_DonHang FOREIGN KEY (MaDonHang)
        REFERENCES DonHang(MaDonHang),

    CONSTRAINT FK_CTDHSP_SanPham FOREIGN KEY (MaSanPham)
        REFERENCES SanPham(MaSanPham),

    CONSTRAINT CK_CTDHSP_SoLuong CHECK (SoLuong > 0),

    CONSTRAINT CK_CTDHSP_DonGia CHECK (DonGiaBan >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ThanhToan (
    MaThanhToan INT AUTO_INCREMENT NOT NULL,
    MaDonHang INT NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL,
    PhuongThucThanhToan VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    ThoiGianThanhToan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TrangThaiThanhToan VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Thành công',

    PRIMARY KEY (MaThanhToan),
    KEY IX_ThanhToan_DonHang (MaDonHang),

    CONSTRAINT FK_ThanhToan_DonHang FOREIGN KEY (MaDonHang)
        REFERENCES DonHang(MaDonHang),

    CONSTRAINT CK_ThanhToan_SoTien CHECK (SoTien >= 0),

    CONSTRAINT CK_ThanhToan_PhuongThuc CHECK (
        PhuongThucThanhToan IN ('Tiền mặt', 'Chuyển khoản', 'Thẻ', 'Ví điện tử')
    ),

    CONSTRAINT CK_ThanhToan_TrangThai CHECK (
        TrangThaiThanhToan IN ('Thành công', 'Thất bại', 'Hoàn tiền')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$

CREATE TRIGGER TRG_Ve_KiemTraGheThuocPhong
    BEFORE INSERT ON Ve
    FOR EACH ROW
BEGIN
    DECLARE v_phong_ve INT;
    DECLARE v_phong_ghe INT;

    SELECT sc.MaPhongChieu
    INTO v_phong_ve
    FROM SuatChieu sc
    WHERE sc.MaSuatChieu = NEW.MaSuatChieu;

    SELECT g.MaPhongChieu
    INTO v_phong_ghe
    FROM GheNgoi g
    WHERE g.MaGheNgoi = NEW.MaGheNgoi;

    IF v_phong_ve IS NULL OR v_phong_ghe IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suất chiếu hoặc ghế không tồn tại.';
    END IF;

    IF v_phong_ve <> v_phong_ghe THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ghế không thuộc đúng phòng chiếu của suất chiếu.';
    END IF;
END$$

DELIMITER ;

-- EXECUTE LẦN 3 

  INSERT INTO Phim
(TenPhim, TheLoai, DaoDien, ThoiLuong, GioiHanTuoi, DinhDang, NgayKhoiChieu, TrangThaiPhim)
VALUES
('Hẹn Em Ngày Nhất Thực', 'Gia đình, Tình cảm', NULL, 118, 16, NULL, '2026-03-30', 'Đang chiếu'),
('Thoát Khỏi Tận Thế', 'Khoa học viễn tưởng, Phiêu lưu', NULL, 157, 13, NULL, '2026-03-20', 'Đang chiếu'),
('Cú Nhảy Kỳ Diệu', 'Gia đình, Hài, Hoạt hình, Phiêu lưu', NULL, 105, 0, NULL, '2026-03-13', 'Đang chiếu'),
('Quỷ Nhập Tràng 2', 'Hồi hộp, Kinh dị', NULL, 126, 18, NULL, '2026-03-13', 'Đang chiếu'),
('Đêm Ngày Xa Mẹ', 'Gia đình', NULL, 109, 13, NULL, '2026-03-20', 'Đang chiếu'),
('Chúng Sẽ Đoạt Mạng', 'Hài, Hành động, Kinh dị', NULL, 95, 18, NULL, '2026-03-27', 'Đang chiếu'),
('Tứ Hổ Đại Náo', 'Hài, Hành động, Thần thoại', NULL, 122, 18, NULL, '2026-03-27', 'Đang chiếu'),
('Vùng Đất Luân Hồi', 'Hoạt hình, Thần thoại', NULL, 110, 13, NULL, '2026-03-27', 'Đang chiếu'),
('Kung Fu Quái Chưởng', 'Hài, Hành động, Thần thoại', NULL, 127, 18, NULL, '2026-03-27', 'Đang chiếu'),
('Project Y: Gái Ngoan Đổi Đời', 'Hồi hộp, Tâm lý', NULL, 109, 18, NULL, '2026-03-27', 'Đang chiếu'),
('Cô Bé Coraline', 'Gia đình, Hoạt hình, Thần thoại', NULL, 101, 13, NULL, '2026-03-27', 'Đang chiếu'),
('Mặt Nạ Da Người', 'Bí ẩn, Hồi hộp, Kinh dị', NULL, 86, 18, NULL, '2026-03-27', 'Đang chiếu'),
('Tái', 'Gia đình, Hành động, Tâm lý', NULL, 101, 16, NULL, '2026-03-06', 'Đang chiếu'),
('Tiếng Thét 7', 'Bí ẩn, Kinh dị', NULL, 114, 18, NULL, '2026-03-20', 'Đang chiếu'),
('Trận Chiến Sau Trận Chiến (Chiếu Lại)', 'Hành động, Hồi hộp, Tâm lý', NULL, 162, 18, NULL, '2026-03-20', 'Đang chiếu'),
('La Tiểu Hắc Chiến Ký 2', 'Hành động, Hoạt hình', NULL, 120, 13, NULL, '2026-03-20', 'Đang chiếu'),
('Cá Voi Nhỏ Chu Du Đại Dương', 'Gia đình, Hoạt hình, Thần thoại', NULL, 92, 0, NULL, '2026-03-20', 'Đang chiếu'),
('Cánh Đồng Mơ Xám', 'Lịch sử, Tâm lý', NULL, 123, 13, NULL, '2026-03-20', 'Đang chiếu'),
('Omukade: Con Rết Người', 'Kinh dị', NULL, 93, 18, NULL, '2026-03-20', 'Đang chiếu'),
('Bus – Chuyến Xe Một Chiều', 'Kinh dị, Tâm lý', NULL, 94, 16, NULL, '2026-03-20', 'Đang chiếu'),
('Cô Dâu!', 'Kinh dị, Nhạc kịch, Tình cảm', NULL, 126, 18, NULL, '2026-03-13', 'Đang chiếu'),
('Greenland 2: Đại Di Cư', 'Hành động, Hồi hộp', NULL, 97, 13, NULL, '2026-03-13', 'Đang chiếu'),
('Báu Vật Trời Cho', 'Gia đình, Hài, Tình cảm', NULL, 124, NULL, NULL, '2026-02-17', 'Đang chiếu'),
('Đồi Gió Hú', 'Tâm lý, Tình cảm', NULL, 136, 18, NULL, '2026-02-27', 'Đang chiếu'),
('Không Còn Chúng Ta', 'Tâm lý, Tình cảm', NULL, 114, 13, NULL, '2026-03-06', 'Đang chiếu'),
('Quốc Bảo', 'Tâm lý', NULL, 174, 16, NULL, '2026-03-06', 'Đang chiếu');


INSERT INTO PhongChieu
(TenPhongChieu, LoaiManHinh, HeThongAmThanh, TrangThaiPhong)
VALUES
('Phòng 1', '2D', 'Dolby 7.1', 'Hoạt động'),
('Phòng 2', '2D', 'Dolby 7.1', 'Hoạt động'),
('Phòng 3', '3D', 'Dolby Atmos', 'Hoạt động'),
('Phòng 4', 'VIP', 'Dolby Atmos', 'Hoạt động'),
('Phòng 5', 'IMAX', 'Dolby Atmos', 'Hoạt động'),
('Phòng 6', '4DX', 'Dolby Atmos', 'Hoạt động'),
('Phòng 7', '2D', 'Dolby 7.1', 'Bảo trì'),
('Phòng 8', 'VIP', 'Dolby Atmos', 'Hoạt động');

INSERT INTO LoaiVe
(TenLoaiVe, PhuThuGia, MoTa)
VALUES
('Vé thường', 0, 'Áp dụng cho ghế thường'),
('Vé VIP', 30000, 'Áp dụng cho ghế VIP hoặc phòng VIP'),
('Vé trẻ em', 20000, 'Áp dụng cho khách hàng trẻ em'),
('Vé sinh viên', 15000, 'Áp dụng cho học sinh, sinh viên có thẻ'),
('Vé người lớn', 25000, 'Áp dụng cho khách hàng người lớn'),
('Vé cuối tuần', 40000, 'Phụ thu cho suất chiếu cuối tuần'),
('Vé ngày lễ', 50000, 'Phụ thu cho suất chiếu ngày lễ');

INSERT INTO LoaiGheNgoi (TenLoaiGheNgoi, PhuThu)
VALUES
('Ghế thường', 0),
('Ghế VIP', 20000),
('Ghế đôi', 40000);

INSERT INTO GheNgoi (MaPhongChieu, HangGhe, SoGhe, MaLoaiGheNgoi, TrangThaiGhe)
WITH RECURSIVE SoGheCTE AS (
    SELECT 1 AS SoGhe
    UNION ALL
    SELECT SoGhe + 1
    FROM SoGheCTE
    WHERE SoGhe < 10
),
HangGheCTE AS (
    SELECT 'A' AS HangGhe
    UNION ALL SELECT 'B'
    UNION ALL SELECT 'C'
    UNION ALL SELECT 'D'
    UNION ALL SELECT 'E'
)
SELECT 
    pc.MaPhongChieu,
    h.HangGhe,
    s.SoGhe,
    CASE
        WHEN h.HangGhe = 'A' THEN (
            SELECT MaLoaiGheNgoi
            FROM LoaiGheNgoi
            WHERE TenLoaiGheNgoi = 'Ghế VIP'
            LIMIT 1
        )
        WHEN h.HangGhe = 'E' THEN (
            SELECT MaLoaiGheNgoi
            FROM LoaiGheNgoi
            WHERE TenLoaiGheNgoi = 'Ghế đôi'
            LIMIT 1
        )
        ELSE (
            SELECT MaLoaiGheNgoi
            FROM LoaiGheNgoi
            WHERE TenLoaiGheNgoi = 'Ghế thường'
            LIMIT 1
        )
    END AS MaLoaiGheNgoi,
    'Hoạt động' AS TrangThaiGhe
FROM PhongChieu pc
CROSS JOIN HangGheCTE h
CROSS JOIN SoGheCTE s
WHERE NOT EXISTS (
    SELECT 1
    FROM GheNgoi g
    WHERE g.MaPhongChieu = pc.MaPhongChieu
      AND g.HangGhe = h.HangGhe
      AND g.SoGhe = s.SoGhe
);

INSERT INTO LoaiVe (TenLoaiVe, PhuThuGia, MoTa)
SELECT 'Vé thường', 0, 'Vé tiêu chuẩn'
WHERE NOT EXISTS (
    SELECT 1 FROM LoaiVe WHERE TenLoaiVe = 'Vé thường'
);

INSERT INTO LoaiVe (TenLoaiVe, PhuThuGia, MoTa)
SELECT 'Vé VIP', 20000, 'Áp dụng cho ghế VIP'
WHERE NOT EXISTS (
    SELECT 1 FROM LoaiVe WHERE TenLoaiVe = 'Vé VIP'
);

INSERT INTO LoaiVe (TenLoaiVe, PhuThuGia, MoTa)
SELECT 'Vé đôi', 40000, 'Áp dụng cho ghế đôi'
WHERE NOT EXISTS (
    SELECT 1 FROM LoaiVe WHERE TenLoaiVe = 'Vé đôi'
);


INSERT INTO SuatChieu (MaPhim, MaPhongChieu, NgayGioChieu, GiaVeCoBan, TrangThaiSuatChieu)
SELECT p.MaPhim, pc.MaPhongChieu, '2026-03-30 09:00:00', 70000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Hẹn Em Ngày Nhất Thực'
  AND pc.TenPhongChieu = 'Phòng 1'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-03-30 14:00:00', 70000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Hẹn Em Ngày Nhất Thực'
  AND pc.TenPhongChieu = 'Phòng 2'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-03-30 19:00:00', 90000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Hẹn Em Ngày Nhất Thực'
  AND pc.TenPhongChieu = 'Phòng 3'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-03-31 10:00:00', 120000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Thoát Khỏi Tận Thế'
  AND pc.TenPhongChieu = 'Phòng 4'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-03-31 15:30:00', 150000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Thoát Khỏi Tận Thế'
  AND pc.TenPhongChieu = 'Phòng 5'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-03-31 20:30:00', 160000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Thoát Khỏi Tận Thế'
  AND pc.TenPhongChieu = 'Phòng 6'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-04-01 09:30:00', 65000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Cú Nhảy Kỳ Diệu'
  AND pc.TenPhongChieu = 'Phòng 1'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-04-01 13:30:00', 65000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Cú Nhảy Kỳ Diệu'
  AND pc.TenPhongChieu = 'Phòng 2'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-04-01 18:30:00', 95000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Cú Nhảy Kỳ Diệu'
  AND pc.TenPhongChieu = 'Phòng 8'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-04-02 10:30:00', 85000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Quỷ Nhập Tràng 2'
  AND pc.TenPhongChieu = 'Phòng 3'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-04-02 16:00:00', 110000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Quỷ Nhập Tràng 2'
  AND pc.TenPhongChieu = 'Phòng 4'

UNION ALL

SELECT p.MaPhim, pc.MaPhongChieu, '2026-04-02 21:00:00', 140000, 'Sắp chiếu'
FROM Phim p
JOIN PhongChieu pc
WHERE p.TenPhim = 'Quỷ Nhập Tràng 2'
  AND pc.TenPhongChieu = 'Phòng 5';


INSERT INTO Ve (MaSuatChieu, MaGheNgoi, MaLoaiVe, GiaVe, TrangThaiVe)
SELECT
    sc.MaSuatChieu,
    g.MaGheNgoi,
    lv.MaLoaiVe,
    sc.GiaVeCoBan + lv.PhuThuGia AS GiaVe,
    'Chưa bán' AS TrangThaiVe
FROM SuatChieu sc
JOIN GheNgoi g
    ON sc.MaPhongChieu = g.MaPhongChieu
JOIN LoaiGheNgoi lgn
    ON g.MaLoaiGheNgoi = lgn.MaLoaiGheNgoi
JOIN LoaiVe lv
    ON (
        (lgn.TenLoaiGheNgoi = 'Ghế VIP' AND lv.TenLoaiVe = 'Vé VIP')
        OR
        (lgn.TenLoaiGheNgoi = 'Ghế đôi' AND lv.TenLoaiVe = 'Vé đôi')
        OR
        (lgn.TenLoaiGheNgoi = 'Ghế thường' AND lv.TenLoaiVe = 'Vé thường')
    )
WHERE NOT EXISTS (
    SELECT 1
    FROM Ve v
    WHERE v.MaSuatChieu = sc.MaSuatChieu
      AND v.MaGheNgoi = g.MaGheNgoi
);


INSERT INTO ChucVu (TenChucVu, MoTa)
VALUES
('Quản lý', 'Quản lý hoạt động rạp chiếu phim'),
('Thu ngân', 'Bán vé và thanh toán'),
('Nhân viên quầy vé', 'Tư vấn, hỗ trợ khách mua vé'),
('Nhân viên soát vé', 'Kiểm tra vé trước khi vào phòng chiếu'),
('Nhân viên kỹ thuật', 'Phụ trách máy chiếu, âm thanh, kỹ thuật'),
('Nhân viên vệ sinh', 'Dọn dẹp và vệ sinh khu vực rạp'),
('Nhân viên quầy bắp nước', 'Bán bắp nước và sản phẩm ăn uống');

INSERT INTO NhanVien
(HoTen, NgaySinh, GioiTinh, SoDienThoai, Email, DiaChi, MaChucVu, TrangThaiLamViec)
VALUES
('Nguyễn Minh Anh', '1990-05-12', 'Nam', '0901000001', 'minhanh01@gmail.com', 'TP.HCM', 1, 'Đang làm'),
('Trần Thu Hà', '1995-08-21', 'Nữ', '0901000002', 'thuha02@gmail.com', 'TP.HCM', 2, 'Đang làm'),
('Lê Quốc Bảo', '1998-03-15', 'Nam', '0901000003', 'quocbao03@gmail.com', 'TP.HCM', 2, 'Đang làm'),
('Phạm Ngọc Lan', '1997-11-09', 'Nữ', '0901000004', 'ngoclan04@gmail.com', 'TP.HCM', 3, 'Đang làm'),
('Hoàng Gia Huy', '1999-01-25', 'Nam', '0901000005', 'giahuy05@gmail.com', 'TP.HCM', 3, 'Đang làm'),
('Vũ Khánh Linh', '1996-07-17', 'Nữ', '0901000006', 'khanhlinh06@gmail.com', 'TP.HCM', 4, 'Đang làm'),
('Đỗ Thành Đạt', '1994-10-30', 'Nam', '0901000007', 'thanhdat07@gmail.com', 'TP.HCM', 4, 'Đang làm'),
('Bùi Mỹ Duyên', '1993-12-05', 'Nữ', '0901000008', 'myduyen08@gmail.com', 'TP.HCM', 5, 'Đang làm'),
('Ngô Trung Kiên', '1991-06-11', 'Nam', '0901000009', 'trungkien09@gmail.com', 'TP.HCM', 5, 'Đang làm'),
('Phan Thảo My', '2000-09-19', 'Nữ', '0901000010', 'thaomy10@gmail.com', 'TP.HCM', 6, 'Đang làm'),
('Đặng Nhật Nam', '1998-04-08', 'Nam', '0901000011', 'nhatnam11@gmail.com', 'TP.HCM', 6, 'Đang làm'),
('Lý Hoài Thương', '1999-02-14', 'Nữ', '0901000012', 'hoaithuong12@gmail.com', 'TP.HCM', 7, 'Đang làm'),
('Tạ Công Phúc', '1997-05-27', 'Nam', '0901000013', 'congphuc13@gmail.com', 'TP.HCM', 7, 'Đang làm'),
('Mai Thanh Tùng', '1992-08-03', 'Nam', '0901000014', 'thanhtung14@gmail.com', 'TP.HCM', 2, 'Tạm nghỉ'),
('Nguyễn Bảo Trâm', '1996-01-18', 'Nữ', '0901000015', 'baotram15@gmail.com', 'TP.HCM', 3, 'Đang làm');

INSERT INTO KhachHang
(HoTen, SoDienThoai, Email, GioiTinh, NgaySinh, DiemTichLuy, HangThanhVien)
VALUES
('Nguyễn Thị Mai', '0912000001', 'nguyenmaikh01@gmail.com', 'Nữ', '1998-03-12', 120, 'Bạc'),
('Trần Văn Hùng', '0912000002', 'tranvanhung02@gmail.com', 'Nam', '1995-07-25', 350, 'Vàng'),
('Lê Ngọc Anh', '0912000003', 'lengocanh03@gmail.com', 'Nữ', '2000-11-08', 40, 'Thường'),
('Phạm Quốc Khánh', '0912000004', 'phamquockhanh04@gmail.com', 'Nam', '1993-05-19', 520, 'Kim cương'),
('Hoàng Minh Châu', '0912000005', 'hoangminhchau05@gmail.com', 'Nữ', '1999-09-30', 180, 'Bạc'),
('Đỗ Gia Bảo', '0912000006', 'dogiabao06@gmail.com', 'Nam', '2001-01-15', 60, 'Thường'),
('Bùi Thanh Trúc', '0912000007', 'buithanhtruc07@gmail.com', 'Nữ', '1997-06-21', 410, 'Vàng'),
('Võ Thành Nam', '0912000008', 'vothanhnam08@gmail.com', 'Nam', '1996-12-05', 90, 'Thường'),
('Ngô Khánh Ly', '0912000009', 'ngokhanhly09@gmail.com', 'Nữ', '2002-04-17', 25, 'Thường'),
('Phan Đức Tài', '0912000010', 'phanductai10@gmail.com', 'Nam', '1994-08-11', 240, 'Bạc'),
('Đặng Thảo Vy', '0912000011', 'dangthaovy11@gmail.com', 'Nữ', '2001-10-09', 75, 'Thường'),
('Lý Hoàng Long', '0912000012', 'lyhoanglong12@gmail.com', 'Nam', '1992-02-28', 610, 'Kim cương'),
('Tạ Minh Thư', '0912000013', 'taminhthu13@gmail.com', 'Nữ', '1998-01-06', 130, 'Bạc'),
('Nguyễn Nhật Quang', '0912000014', 'nguyennhatquang14@gmail.com', 'Nam', '1990-07-14', 455, 'Vàng'),
('Trương Bảo Ngân', '0912000015', 'truongbaongan15@gmail.com', 'Nữ', '2003-03-22', 15, 'Thường');

INSERT INTO LoaiKhuyenMai (TenLoaiKhuyenMai, MoTa)
VALUES
('Giảm theo phần trăm', 'Giảm giá theo % trên tổng hóa đơn'),
('Giảm tiền trực tiếp', 'Giảm trực tiếp số tiền trên hóa đơn'),
('Khuyến mãi theo ngày', 'Áp dụng theo ngày đặc biệt'),
('Khuyến mãi thành viên', 'Áp dụng cho khách hàng thân thiết'),
('Khuyến mãi combo', 'Áp dụng khi mua combo bắp nước');

INSERT INTO KhuyenMai
(TenKhuyenMai, MaLoaiKhuyenMai, KieuGiaTri, GiaTri, NgayBatDau, NgayKetThuc, DonHangToiThieu, TrangThai)
VALUES
('Giảm 10% toàn bộ vé', 1, 'PERCENT', 10, '2026-03-01 00:00:00', '2026-04-30 23:59:59', 0, 'Hoạt động'),

('Giảm 20% cuối tuần', 1, 'PERCENT', 20, '2026-03-01 00:00:00', '2026-05-31 23:59:59', 100000, 'Hoạt động'),

('Giảm 50k cho đơn từ 200k', 2, 'VND', 50000, '2026-03-01 00:00:00', '2026-06-30 23:59:59', 200000, 'Hoạt động'),

('Giảm 30k cho khách mới', 2, 'VND', 30000, '2026-03-01 00:00:00', '2026-12-31 23:59:59', 0, 'Hoạt động'),

('Ưu đãi sinh nhật giảm 25%', 3, 'PERCENT', 25, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 0, 'Hoạt động'),

('Thành viên bạc giảm 10%', 4, 'PERCENT', 10, '2026-03-01 00:00:00', '2026-12-31 23:59:59', 0, 'Hoạt động'),

('Thành viên vàng giảm 15%', 4, 'PERCENT', 15, '2026-03-01 00:00:00', '2026-12-31 23:59:59', 0, 'Hoạt động'),

('Combo bắp nước giảm 20k', 5, 'VND', 20000, '2026-03-01 00:00:00', '2026-06-30 23:59:59', 50000, 'Hoạt động'),

('Flash sale giảm 30%', 1, 'PERCENT', 30, '2026-04-01 00:00:00', '2026-04-05 23:59:59', 0, 'Hoạt động'),

('Khuyến mãi hết hạn mẫu', 2, 'VND', 10000, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 0, 'Hết hạn');

INSERT INTO DanhMucSanPham (TenDanhMucSanPham, MoTa)
VALUES
('Đồ ăn', 'Các sản phẩm ăn nhanh tại rạp'),
('Đồ uống', 'Các loại nước uống phục vụ tại rạp'),
('Combo', 'Các combo bắp nước và đồ ăn kèm');

INSERT INTO LoaiSanPham (TenLoaiSanPham, MaDanhMucSanPham, MoTa)
VALUES
('Bắp rang', 1, 'Các loại bắp rang bơ, phô mai, caramel'),
('Snack', 1, 'Các loại snack ăn kèm'),
('Nước ngọt', 2, 'Các loại nước ngọt có ga'),
('Trà sữa', 2, 'Các loại trà sữa'),
('Nước suối', 2, 'Nước uống đóng chai'),
('Combo cá nhân', 3, 'Combo dành cho 1 người'),
('Combo cặp đôi', 3, 'Combo dành cho 2 người'),
('Combo gia đình', 3, 'Combo dành cho nhóm hoặc gia đình');

INSERT INTO SanPham
(TenSanPham, DonGia, SoLuongTon, MaLoaiSanPham, TrangThai)
VALUES
('Bắp rang bơ size S', 45000, 120, 1, 'Đang bán'),
('Bắp rang bơ size M', 55000, 100, 1, 'Đang bán'),
('Bắp rang bơ size L', 65000, 80, 1, 'Đang bán'),
('Bắp rang phô mai size M', 60000, 70, 1, 'Đang bán'),
('Bắp rang caramel size M', 62000, 60, 1, 'Đang bán'),

('Snack khoai tây', 25000, 90, 2, 'Đang bán'),
('Snack rong biển', 20000, 75, 2, 'Đang bán'),
('Snack bắp', 18000, 50, 2, 'Đang bán'),

('Coca Cola', 30000, 150, 3, 'Đang bán'),
('Pepsi', 30000, 140, 3, 'Đang bán'),
('7 Up', 30000, 100, 3, 'Đang bán'),
('Mirinda cam', 30000, 95, 3, 'Đang bán'),

('Trà sữa truyền thống', 45000, 40, 4, 'Đang bán'),
('Trà sữa trân châu đường đen', 50000, 35, 4, 'Đang bán'),

('Nước suối Aquafina', 20000, 200, 5, 'Đang bán'),
('Nước suối Dasani', 20000, 160, 5, 'Đang bán'),

('Combo 1: Bắp M + Nước ngọt', 80000, 60, 6, 'Đang bán'),
('Combo 2: Bắp L + 2 Nước ngọt', 120000, 50, 7, 'Đang bán'),
('Combo 3: 2 Bắp L + 4 Nước ngọt', 220000, 25, 8, 'Đang bán'),
('Combo 4: Bắp M + Nước suối', 70000, 45, 6, 'Đang bán'),

('Snack khoai tây vị cay', 27000, 0, 2, 'Hết hàng'),
('Combo gia đình đặc biệt', 250000, 0, 8, 'Hết hàng'),
('Nước ngọt phiên bản cũ', 25000, 0, 3, 'Ngừng bán');


INSERT INTO DonHang
(MaKhachHang, MaNhanVien, MaKhuyenMai, NgayLap, TrangThaiDonHang, GhiChu)
VALUES
(1, 2, 1, '2026-03-30 09:15:00', 'Đã thanh toán', 'Khách mua 2 vé suất sáng'),
(2, 2, 3, '2026-03-30 10:20:00', 'Đã thanh toán', 'Áp dụng khuyến mãi giảm 50k'),
(3, 3, NULL, '2026-03-30 11:05:00', 'Chưa thanh toán', 'Đặt vé online chưa thanh toán'),
(4, 2, 2, '2026-03-30 13:40:00', 'Đã thanh toán', 'Mua vé cuối tuần'),
(5, 3, NULL, '2026-03-30 15:10:00', 'Đã thanh toán', 'Mua vé và bắp nước'),
(NULL, 2, NULL, '2026-03-30 16:00:00', 'Đã thanh toán', 'Khách lẻ không đăng nhập'),
(6, 2, 4, '2026-03-30 17:25:00', 'Đã thanh toán', 'Khách mới có ưu đãi'),
(7, 3, NULL, '2026-03-30 18:45:00', 'Đã hủy', 'Khách đổi ý không mua nữa'),
(8, 2, 1, '2026-03-30 19:30:00', 'Đã thanh toán', 'Mua 1 vé VIP'),
(9, 3, NULL, '2026-03-30 20:15:00', 'Chưa thanh toán', 'Giữ đơn chờ khách chuyển khoản');

INSERT INTO ChiTietDonHangSanPham (MaDonHang, MaSanPham, SoLuong, DonGiaBan)
SELECT dh.MaDonHang, sp.MaSanPham, 1, sp.DonGia
FROM DonHang dh
JOIN SanPham sp ON sp.TenSanPham = 'Combo 1: Bắp M + Nước ngọt'
WHERE dh.GhiChu = 'Khách mua 2 vé suất sáng'

UNION ALL

SELECT dh.MaDonHang, sp.MaSanPham, 2, sp.DonGia
FROM DonHang dh
JOIN SanPham sp ON sp.TenSanPham = 'Coca Cola'
WHERE dh.GhiChu = 'Áp dụng khuyến mãi giảm 50k'

UNION ALL

SELECT dh.MaDonHang, sp.MaSanPham, 1, sp.DonGia
FROM DonHang dh
JOIN SanPham sp ON sp.TenSanPham = 'Bắp rang bơ size S'
WHERE dh.GhiChu = 'Áp dụng khuyến mãi giảm 50k'

UNION ALL

SELECT dh.MaDonHang, sp.MaSanPham, 1, sp.DonGia
FROM DonHang dh
JOIN SanPham sp ON sp.TenSanPham = 'Combo 2: Bắp L + 2 Nước ngọt'
WHERE dh.GhiChu = 'Mua vé cuối tuần'

UNION ALL

SELECT dh.MaDonHang, sp.MaSanPham, 2, sp.DonGia
FROM DonHang dh
JOIN SanPham sp ON sp.TenSanPham = 'Nước suối Aquafina'
WHERE dh.GhiChu = 'Mua vé và bắp nước'

UNION ALL

SELECT dh.MaDonHang, sp.MaSanPham, 1, sp.DonGia
FROM DonHang dh
JOIN SanPham sp ON sp.TenSanPham = 'Snack khoai tây'
WHERE dh.GhiChu = 'Mua vé và bắp nước'

UNION ALL

SELECT dh.MaDonHang, sp.MaSanPham, 1, sp.DonGia
FROM DonHang dh
JOIN SanPham sp ON sp.TenSanPham = 'Combo 1: Bắp M + Nước ngọt'
WHERE dh.GhiChu = 'Khách lẻ không đăng nhập'

UNION ALL

SELECT dh.MaDonHang, sp.MaSanPham, 1, sp.DonGia
FROM DonHang dh
JOIN SanPham sp ON sp.TenSanPham = 'Combo 3: 2 Bắp L + 4 Nước ngọt'
WHERE dh.GhiChu = 'Mua 1 vé VIP'

UNION ALL

SELECT dh.MaDonHang, sp.MaSanPham, 2, sp.DonGia
FROM DonHang dh
JOIN SanPham sp ON sp.TenSanPham = 'Pepsi'
WHERE dh.GhiChu = 'Giữ đơn chờ khách chuyển khoản';

INSERT INTO ThanhToan
(MaDonHang, SoTien, PhuongThucThanhToan, ThoiGianThanhToan, TrangThaiThanhToan)
SELECT
    dh.MaDonHang,
    GREATEST(
        (
            IFNULL(tv.TongTienVe, 0) + IFNULL(sp.TongTienSP, 0)
        ) -
        CASE
            WHEN km.MaKhuyenMai IS NULL THEN 0
            WHEN km.KieuGiaTri = 'VND' THEN km.GiaTri
            WHEN km.KieuGiaTri = 'PERCENT' THEN
                (IFNULL(tv.TongTienVe, 0) + IFNULL(sp.TongTienSP, 0)) * km.GiaTri / 100
            ELSE 0
        END,
        0
    ) AS SoTien,
    CASE MOD(dh.MaDonHang, 4)
        WHEN 0 THEN 'Tiền mặt'
        WHEN 1 THEN 'Chuyển khoản'
        WHEN 2 THEN 'Thẻ'
        ELSE 'Ví điện tử'
    END AS PhuongThucThanhToan,
    DATE_ADD(dh.NgayLap, INTERVAL 5 MINUTE) AS ThoiGianThanhToan,
    'Thành công' AS TrangThaiThanhToan
FROM DonHang dh
LEFT JOIN (
    SELECT MaDonHang, SUM(DonGiaBan) AS TongTienVe
    FROM ChiTietDonHangVe
    GROUP BY MaDonHang
) tv ON dh.MaDonHang = tv.MaDonHang
LEFT JOIN (
    SELECT MaDonHang, SUM(SoLuong * DonGiaBan) AS TongTienSP
    FROM ChiTietDonHangSanPham
    GROUP BY MaDonHang
) sp ON dh.MaDonHang = sp.MaDonHang
LEFT JOIN KhuyenMai km ON dh.MaKhuyenMai = km.MaKhuyenMai
WHERE dh.TrangThaiDonHang = 'Đã thanh toán'
  AND NOT EXISTS (
      SELECT 1
      FROM ThanhToan tt
      WHERE tt.MaDonHang = dh.MaDonHang
  );
  

SELECT 
    sc.MaSuatChieu,
    p.TenPhim,
    pc.TenPhongChieu,
    sc.NgayGioChieu,
    sc.GiaVeCoBan,
    sc.TrangThaiSuatChieu
FROM SuatChieu sc
JOIN Phim p ON sc.MaPhim = p.MaPhim
JOIN PhongChieu pc ON sc.MaPhongChieu = pc.MaPhongChieu
ORDER BY sc.MaPhongChieu, sc.NgayGioChieu;

