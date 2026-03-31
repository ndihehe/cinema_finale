package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(
    name = "TaiKhoan",
    uniqueConstraints = {
        @UniqueConstraint(name = "UK_TaiKhoan_TenDangNhap", columnNames = {"TenDangNhap"}),
        @UniqueConstraint(name = "UK_TaiKhoan_MaNhanVien", columnNames = {"MaNhanVien"}),
        @UniqueConstraint(name = "UK_TaiKhoan_MaKhachHang", columnNames = {"MaKhachHang"})
    }
)
public class TaiKhoan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaTaiKhoan")
    private Integer maTaiKhoan;

    @Column(name = "TenDangNhap", nullable = false, unique = true, length = 50)
    private String tenDangNhap;

    @Column(name = "MatKhau", nullable = false, length = 255)
    private String matKhau;

    @Column(name = "LoaiTaiKhoan", nullable = false, length = 20)
    private String loaiTaiKhoan;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaNhanVien", unique = true)
    private NhanVien nhanVien;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaKhachHang", unique = true)
    private KhachHang khachHang;

    @Column(name = "TrangThaiTaiKhoan", nullable = false, length = 30)
    private String trangThaiTaiKhoan = "Hoạt động";

    @Column(name = "NgayTao", nullable = false)
    private LocalDateTime ngayTao;

    public TaiKhoan() {
    }

    public Integer getMaTaiKhoan() {
        return maTaiKhoan;
    }

    public void setMaTaiKhoan(Integer maTaiKhoan) {
        this.maTaiKhoan = maTaiKhoan;
    }

    public String getTenDangNhap() {
        return tenDangNhap;
    }

    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getLoaiTaiKhoan() {
        return loaiTaiKhoan;
    }

    public void setLoaiTaiKhoan(String loaiTaiKhoan) {
        this.loaiTaiKhoan = loaiTaiKhoan;
    }

    public NhanVien getNhanVien() {
        return nhanVien;
    }

    public void setNhanVien(NhanVien nhanVien) {
        this.nhanVien = nhanVien;
    }

    public KhachHang getKhachHang() {
        return khachHang;
    }

    public void setKhachHang(KhachHang khachHang) {
        this.khachHang = khachHang;
    }

    public String getTrangThaiTaiKhoan() {
        return trangThaiTaiKhoan;
    }

    public void setTrangThaiTaiKhoan(String trangThaiTaiKhoan) {
        this.trangThaiTaiKhoan = trangThaiTaiKhoan;
    }

    public LocalDateTime getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(LocalDateTime ngayTao) {
        this.ngayTao = ngayTao;
    }
}
