
CREATE DATABASE QuanLyBanVeXemPhim;
USE QuanLyBanVeXemPhim;

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

-- ChucVu
INSERT INTO ChucVu (TenChucVu, MoTa) VALUES
    ('Quản lý', 'Quản lý hệ thống, ticketing, báo cáo'),
    ('Thu ngân', 'Bán vé, bán combo'),
    ('Bán vé online', 'Xử lý vé qua web/app');

-- NhanVien
INSERT INTO NhanVien (HoTen, NgaySinh, GioiTinh, SoDienThoai, Email, DiaChi, MaChucVu) VALUES
    ('Nguyễn Văn Quản', '1990-01-15', 'Nam', '0901111111', 'quan@rap.com', '123 Đống Đa, Q.10', 1),
    ('Trần Thị Ngân', '1992-05-10', 'Nữ', '0902222222', 'ngan@rap.com', '456 Bà Huyện Thanh Quan, Q.3', 2),
    ('Lê Minh Ticket', '1994-08-20', 'Nam', '0903333333', 'ticket@rap.com', '789 Hai Bà Trưng, Q.1', 3);

-- KhachHang
INSERT INTO KhachHang (HoTen, SoDienThoai, Email, GioiTinh, NgaySinh, DiemTichLuy, HangThanhVien) VALUES
    ('Phan Hồng Gấm', '0989888777', 'gam@example.com', 'Nữ', '1998-04-15', 150, 'Bạc'),
    ('Trần Minh Khang', '0901234567', 'khang@example.com', 'Nam', '2000-10-05', 50, 'Thường'),
    ('Lê Thanh Hương', '0912345678', 'huong@example.com', 'Nữ', '1995-12-25', 500, 'Kim cương');
    
INSERT INTO Phim (TenPhim, TheLoai, DaoDien, ThoiLuong, GioiHanTuoi, DinhDang, NgayKhoiChieu, TrangThaiPhim) VALUES
    -- phim Việt
    ('TÀI', 'Hành động, Gia đình', 'Mai Tài Phến', 125, 13, '2D', '2026-03-06', 'Đang chiếu'),

    ('Quỷ Nhập Tràng 2', 'Kinh dị', 'Đinh Tuấn Vũ', 110, 16, '2D', '2026-03-13', 'Đang chiếu'),

    ('Cú Nhảy Kỳ Diệu', 'Hoạt hình', 'Aaron Horvath, Michael Jelenic', 105, 6, '2D / 3D', '2026-03-13', 'Đang chiếu'),

    ('Greenland 2: Đại Di Cư', 'Khoa học viễn tưởng, Hành động', 'Ric Roman Waugh', 130, 13, '2D / 3D', '2026-03-15', 'Đang chiếu'),

    -- 1 phim tâm lý
    ('Tội Phạm 101', 'Tâm lý, Li kỳ', 'Erik Matti', 115, 16, '2D', '2026-03-13', 'Đang chiếu');
    
    
INSERT INTO LoaiVe (TenLoaiVe, PhuThuGia, MoTa) VALUES
    ('Vé thường', 0.00, 'Vé cơ bản'),
    ('Vé học sinh/sinh viên', 0.00, 'Áp dụng cho học sinh/sinh viên'),
    ('Vé VIP (đệm hơi, ghế sofa)', 30000.00, 'Vé hạng cao cấp, ngồi ghế VIP'),
    ('Vé 3D', 20000.00, 'Vé dành cho phim 3D'),
    ('Vé 2D Deluxe', 15000.00, 'Vé phòng chiếu cao cấp (hệ thống âm thanh tốt hơn)');
    
INSERT INTO LoaiGheNgoi (TenLoaiGheNgoi, PhuThu) VALUES
    ('Ghế thường', 0.00),
    ('Ghế VIP', 30000.00);

INSERT INTO PhongChieu (TenPhongChieu, LoaiManHinh, HeThongAmThanh, TrangThaiPhong) VALUES
    -- phòng lớn, 2D thường
    ('Phòng 1', '2K Digital', 'Dolby 5.1', 'Hoạt động'),
    ('Phòng 2', '4K Laser', 'Dolby Atmos', 'Hoạt động'),
    ('Phòng VIP', '4K Laser', 'Dolby Atmos + VIP seats', 'Hoạt động');
    
-- Phòng 1: 40 ghế, MaPhongChieu = 1, MaLoaiGheNgoi = 1
INSERT INTO GheNgoi (MaPhongChieu, HangGhe, SoGhe, MaLoaiGheNgoi, TrangThaiGhe)
VALUES
(1, 'A', 1, 1, 'Hoạt động'), (1, 'A', 2, 1, 'Hoạt động'), (1, 'A', 3, 1, 'Hoạt động'),
(1, 'A', 4, 1, 'Hoạt động'), (1, 'A', 5, 1, 'Hoạt động'), (1, 'A', 6, 1, 'Hoạt động'),
(1, 'A', 7, 1, 'Hoạt động'), (1, 'A', 8, 1, 'Hoạt động'), (1, 'A', 9, 1, 'Hoạt động'),
(1, 'A', 10, 1, 'Hoạt động'),

(1, 'B', 1, 1, 'Hoạt động'), (1, 'B', 2, 1, 'Hoạt động'), (1, 'B', 3, 1, 'Hoạt động'),
(1, 'B', 4, 1, 'Hoạt động'), (1, 'B', 5, 1, 'Hoạt động'), (1, 'B', 6, 1, 'Hoạt động'),
(1, 'B', 7, 1, 'Hoạt động'), (1, 'B', 8, 1, 'Hoạt động'), (1, 'B', 9, 1, 'Hoạt động'),
(1, 'B', 10, 1, 'Hoạt động'),

(1, 'C', 1, 1, 'Hoạt động'), (1, 'C', 2, 1, 'Hoạt động'), (1, 'C', 3, 1, 'Hoạt động'),
(1, 'C', 4, 1, 'Hoạt động'), (1, 'C', 5, 1, 'Hoạt động'), (1, 'C', 6, 1, 'Hoạt động'),
(1, 'C', 7, 1, 'Hoạt động'), (1, 'C', 8, 1, 'Hoạt động'), (1, 'C', 9, 1, 'Hoạt động'),
(1, 'C', 10, 1, 'Hoạt động'),

(1, 'D', 1, 1, 'Hoạt động'), (1, 'D', 2, 1, 'Hoạt động'), (1, 'D', 3, 1, 'Hoạt động'),
(1, 'D', 4, 1, 'Hoạt động'), (1, 'D', 5, 1, 'Hoạt động'), (1, 'D', 6, 1, 'Hoạt động'),
(1, 'D', 7, 1, 'Hoạt động'), (1, 'D', 8, 1, 'Hoạt động'), (1, 'D', 9, 1, 'Hoạt động'),
(1, 'D', 10, 1, 'Hoạt động');

-- Phòng 2: 40 ghế, MaPhongChieu = 2, MaLoaiGheNgoi = 1
INSERT INTO GheNgoi (MaPhongChieu, HangGhe, SoGhe, MaLoaiGheNgoi, TrangThaiGhe)
VALUES
(2, 'A', 1, 1, 'Hoạt động'), (2, 'A', 2, 1, 'Hoạt động'), (2, 'A', 3, 1, 'Hoạt động'),
(2, 'A', 4, 1, 'Hoạt động'), (2, 'A', 5, 1, 'Hoạt động'), (2, 'A', 6, 1, 'Hoạt động'),
(2, 'A', 7, 1, 'Hoạt động'), (2, 'A', 8, 1, 'Hoạt động'), (2, 'A', 9, 1, 'Hoạt động'),
(2, 'A', 10, 1, 'Hoạt động'),

(2, 'B', 1, 1, 'Hoạt động'), (2, 'B', 2, 1, 'Hoạt động'), (2, 'B', 3, 1, 'Hoạt động'),
(2, 'B', 4, 1, 'Hoạt động'), (2, 'B', 5, 1, 'Hoạt động'), (2, 'B', 6, 1, 'Hoạt động'),
(2, 'B', 7, 1, 'Hoạt động'), (2, 'B', 8, 1, 'Hoạt động'), (2, 'B', 9, 1, 'Hoạt động'),
(2, 'B', 10, 1, 'Hoạt động'),

(2, 'C', 1, 1, 'Hoạt động'), (2, 'C', 2, 1, 'Hoạt động'), (2, 'C', 3, 1, 'Hoạt động'),
(2, 'C', 4, 1, 'Hoạt động'), (2, 'C', 5, 1, 'Hoạt động'), (2, 'C', 6, 1, 'Hoạt động'),
(2, 'C', 7, 1, 'Hoạt động'), (2, 'C', 8, 1, 'Hoạt động'), (2, 'C', 9, 1, 'Hoạt động'),
(2, 'C', 10, 1, 'Hoạt động'),

(2, 'D', 1, 1, 'Hoạt động'), (2, 'D', 2, 1, 'Hoạt động'), (2, 'D', 3, 1, 'Hoạt động'),
(2, 'D', 4, 1, 'Hoạt động'), (2, 'D', 5, 1, 'Hoạt động'), (2, 'D', 6, 1, 'Hoạt động'),
(2, 'D', 7, 1, 'Hoạt động'), (2, 'D', 8, 1, 'Hoạt động'), (2, 'D', 9, 1, 'Hoạt động'),
(2, 'D', 10, 1, 'Hoạt động');

-- Phòng VIP: 12 ghế, MaPhongChieu = 3, MaLoaiGheNgoi = 2
INSERT INTO GheNgoi (MaPhongChieu, HangGhe, SoGhe, MaLoaiGheNgoi, TrangThaiGhe)
VALUES
(3, 'A', 1, 2, 'Hoạt động'), (3, 'A', 2, 2, 'Hoạt động'), (3, 'A', 3, 2, 'Hoạt động'),
(3, 'A', 4, 2, 'Hoạt động'), (3, 'A', 5, 2, 'Hoạt động'), (3, 'A', 6, 2, 'Hoạt động'),
(3, 'B', 1, 2, 'Hoạt động'), (3, 'B', 2, 2, 'Hoạt động'), (3, 'B', 3, 2, 'Hoạt động'),
(3, 'B', 4, 2, 'Hoạt động'), (3, 'B', 5, 2, 'Hoạt động'), (3, 'B', 6, 2, 'Hoạt động');

-- Ngày hôm nay trong DB (giả sử 2026-03-30)
-- 1. Phim TÀI – 2D, phòng 1, 16:00
INSERT INTO SuatChieu (MaPhim, MaPhongChieu, NgayGioChieu, GiaVeCoBan, TrangThaiSuatChieu)
VALUES
    -- MaPhim = 1 (TÀI), MaPhong = 1
    (1, 1, '2026-03-30 16:00:00', 95000.00, 'Đang chiếu'),

    -- 2. GreenLand 2: Đại Di Cư – 3D, phòng 2
    (4, 2, '2026-03-30 18:00:00', 110000.00, 'Đang chiếu'),

    -- 3. Cú Nhảy Kỳ Diệu – 2D, phòng 1
    (3, 1, '2026-03-30 10:00:00', 85000.00, 'Đang chiếu'),

    -- 4. Quỷ Nhập Tràng 2 – 2D, phòng 2
    (2, 2, '2026-03-30 21:00:00', 100000.00, 'Đang chiếu'),

    -- 5. Tội Phạm 101 – 2D Deluxe, phòng VIP
    (5, 3, '2026-03-30 19:00:00', 130000.00, 'Đang chiếu');
    
-- Tạo vé cho suất 1 (TÀI, phòng 1, 16:00) – chỉ lấy 1 vài ghế mẫu
INSERT INTO Ve (MaSuatChieu, MaGheNgoi, MaLoaiVe, GiaVe, TrangThaiVe)
SELECT
    1,
    g.MaGheNgoi,
    -- 20% ghế VIP, 80% ghế thường
    CASE WHEN g.MaLoaiGheNgoi = 2 THEN 3 ELSE 1 END AS MaLoaiVe,
    -- 2D thường hoặc 2D Deluxe
    CASE
        WHEN g.MaLoaiGheNgoi = 2 THEN 130000 + (
            SELECT PhuThuGia FROM LoaiVe WHERE MaLoaiVe = 5
        )
        ELSE 95000.00
    END AS GiaVe,
    'Chưa bán' AS TrangThaiVe
FROM GheNgoi g
WHERE g.MaPhongChieu = 1;

-- Suất 2: GreenLand 2 – 3D (phòng 2)
INSERT INTO Ve (MaSuatChieu, MaGheNgoi, MaLoaiVe, GiaVe, TrangThaiVe)
SELECT
    2,
    g.MaGheNgoi,
    -- 3D vé
    4,
    110000 + (SELECT PhuThuGia FROM LoaiVe WHERE MaLoaiVe = 4),
    'Chưa bán'
FROM GheNgoi g
WHERE g.MaPhongChieu = 2
LIMIT 10;  -- chỉ 10 vé 3D để minh hoạ

-- Suất 3: Cú Nhảy Kỳ Diệu – 2D thường (phòng 1)
INSERT INTO Ve (MaSuatChieu, MaGheNgoi, MaLoaiVe, GiaVe, TrangThaiVe)
SELECT 3, g.MaGheNgoi, 1, 85000.00, 'Chưa bán'
FROM GheNgoi g
WHERE g.MaPhongChieu = 1
LIMIT 8;

-- Suất 4: Quỷ Nhập Tràng 2 – 2D thường (phòng 2)
INSERT INTO Ve (MaSuatChieu, MaGheNgoi, MaLoaiVe, GiaVe, TrangThaiVe)
SELECT 4, g.MaGheNgoi, 1, 100000.00, 'Chưa bán'
FROM GheNgoi g
WHERE g.MaPhongChieu = 2
LIMIT 5;

-- Suất 5: Tội Phạm 101 – 2D Deluxe VIP (phòng VIP)
INSERT INTO Ve (MaSuatChieu, MaGheNgoi, MaLoaiVe, GiaVe, TrangThaiVe)
SELECT 5, g.MaGheNgoi, 5, 130000.00, 'Chưa bán'
FROM GheNgoi g
WHERE g.MaPhongChieu = 3
LIMIT 12;
