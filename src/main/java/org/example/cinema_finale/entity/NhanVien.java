package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import org.example.cinema_finale.enums.TrangThaiLamViec;

import java.time.LocalDate;

@Entity
@Table(name = "nhan_vien")
public class NhanVien {

    @Id
    @Column(name = "ma_nv", length = 20, nullable = false)
    private String maNv;

    @Column(name = "ten_nv", length = 100, nullable = false)
    private String tenNv;

    @Column(name = "ngay_sinh")
    private LocalDate ngaySinh;

    @Column(name = "gioi_tinh", length = 10)
    private String gioiTinh;

    @Column(name = "so_dien_thoai", length = 15)
    private String soDienThoai;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "dia_chi", length = 255)
    private String diaChi;

    @Column(name = "ma_chuc_vu", length = 20)
    private String maChucVu;

    @Column(name = "ngay_vao_lam")
    private LocalDate ngayVaoLam;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai_lam_viec", length = 30, nullable = false)
    private TrangThaiLamViec trangThaiLamViec;

    @OneToOne(mappedBy = "nhanVien")
    private TaiKhoan taiKhoan;

    public NhanVien() {
    }

    public NhanVien(String maNv, String tenNv, LocalDate ngaySinh, String gioiTinh,
                    String soDienThoai, String email, String diaChi, String maChucVu,
                    LocalDate ngayVaoLam, TrangThaiLamViec trangThaiLamViec) {
        this.maNv = maNv;
        this.tenNv = tenNv;
        this.ngaySinh = ngaySinh;
        this.gioiTinh = gioiTinh;
        this.soDienThoai = soDienThoai;
        this.email = email;
        this.diaChi = diaChi;
        this.maChucVu = maChucVu;
        this.ngayVaoLam = ngayVaoLam;
        this.trangThaiLamViec = trangThaiLamViec;
    }

    public String getMaNv() {
        return maNv;
    }

    public void setMaNv(String maNv) {
        this.maNv = maNv;
    }

    public String getTenNv() {
        return tenNv;
    }

    public void setTenNv(String tenNv) {
        this.tenNv = tenNv;
    }

    public LocalDate getNgaySinh() {
        return ngaySinh;
    }

    public void setNgaySinh(LocalDate ngaySinh) {
        this.ngaySinh = ngaySinh;
    }

    public String getGioiTinh() {
        return gioiTinh;
    }

    public void setGioiTinh(String gioiTinh) {
        this.gioiTinh = gioiTinh;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public String getMaChucVu() {
        return maChucVu;
    }

    public void setMaChucVu(String maChucVu) {
        this.maChucVu = maChucVu;
    }

    public LocalDate getNgayVaoLam() {
        return ngayVaoLam;
    }

    public void setNgayVaoLam(LocalDate ngayVaoLam) {
        this.ngayVaoLam = ngayVaoLam;
    }

    public TrangThaiLamViec getTrangThaiLamViec() {
        return trangThaiLamViec;
    }

    public void setTrangThaiLamViec(TrangThaiLamViec trangThaiLamViec) {
        this.trangThaiLamViec = trangThaiLamViec;
    }

    public TaiKhoan getTaiKhoan() {
        return taiKhoan;
    }

    public void setTaiKhoan(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    @Override
    public String toString() {
        return "NhanVien{" +
                "maNv='" + maNv + '\'' +
                ", tenNv='" + tenNv + '\'' +
                ", ngaySinh=" + ngaySinh +
                ", gioiTinh='" + gioiTinh + '\'' +
                ", soDienThoai='" + soDienThoai + '\'' +
                ", email='" + email + '\'' +
                ", diaChi='" + diaChi + '\'' +
                ", maChucVu='" + maChucVu + '\'' +
                ", ngayVaoLam=" + ngayVaoLam +
                ", trangThaiLamViec=" + trangThaiLamViec +
                '}';
    }
}