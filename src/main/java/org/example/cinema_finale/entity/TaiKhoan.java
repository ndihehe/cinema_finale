package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import org.example.cinema_finale.enums.TrangThaiTaiKhoan;

import java.time.LocalDateTime;

@Entity
@Table(name = "tai_khoan")
public class TaiKhoan {

    @Id
    @Column(name = "ma_tk", length = 20, nullable = false)
    private String maTk;

    @Column(name = "ten_dang_nhap", length = 50, nullable = false, unique = true)
    private String tenDangNhap;

    @Column(name = "mat_khau", length = 255, nullable = false)
    private String matKhau;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai_tai_khoan", length = 30, nullable = false)
    private TrangThaiTaiKhoan trangThaiTaiKhoan;

    @Column(name = "lan_dang_nhap_cuoi")
    private LocalDateTime lanDangNhapCuoi;

    @OneToOne
    @JoinColumn(name = "ma_nv", unique = true)
    private NhanVien nhanVien;

    @OneToOne
    @JoinColumn(name = "ma_kh", unique = true)
    private KhachHang khachHang;

    @Transient
    private VaiTro vaiTro;

    public TaiKhoan() {
    }

    public TaiKhoan(String maTk, String tenDangNhap, String matKhau,
                    TrangThaiTaiKhoan trangThaiTaiKhoan, LocalDateTime lanDangNhapCuoi,
                    NhanVien nhanVien, KhachHang khachHang) {
        this.maTk = maTk;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.trangThaiTaiKhoan = trangThaiTaiKhoan;
        this.lanDangNhapCuoi = lanDangNhapCuoi;
        this.nhanVien = nhanVien;
        this.khachHang = khachHang;
    }

    public String getMaTk() {
        return maTk;
    }

    public void setMaTk(String maTk) {
        this.maTk = maTk;
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

    public TrangThaiTaiKhoan getTrangThaiTaiKhoan() {
        return trangThaiTaiKhoan;
    }

    public void setTrangThaiTaiKhoan(TrangThaiTaiKhoan trangThaiTaiKhoan) {
        this.trangThaiTaiKhoan = trangThaiTaiKhoan;
    }

    public LocalDateTime getLanDangNhapCuoi() {
        return lanDangNhapCuoi;
    }

    public void setLanDangNhapCuoi(LocalDateTime lanDangNhapCuoi) {
        this.lanDangNhapCuoi = lanDangNhapCuoi;
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

    public void setVaiTro(VaiTro vaiTro) {
        this.vaiTro = vaiTro;
    }

    public VaiTro getVaiTro() {
        if (nhanVien != null) {
            return VaiTro.STAFF;
        }
        if (khachHang != null) {
            return VaiTro.USER;
        }
        return vaiTro;
    }

    public boolean isStaff() {
        return nhanVien != null;
    }

    public boolean isCustomer() {
        return khachHang != null;
    }

    @Override
    public String toString() {
        return "TaiKhoan{" +
                "maTk='" + maTk + '\'' +
                ", tenDangNhap='" + tenDangNhap + '\'' +
                ", vaiTro=" + getVaiTro() +
                ", trangThaiTaiKhoan=" + trangThaiTaiKhoan +
                ", lanDangNhapCuoi=" + lanDangNhapCuoi +
                ", maNv='" + (nhanVien != null ? nhanVien.getMaNv() : null) + '\'' +
                ", maKh='" + (khachHang != null ? khachHang.getMaKh() : null) + '\'' +
                '}';
    }
}