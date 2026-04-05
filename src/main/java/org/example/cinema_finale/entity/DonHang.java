package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "DonHang")
public class DonHang {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDonHang")
    private Integer maDonHang;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaKhachHang")
    private KhachHang khachHang;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaNhanVien", nullable = false)
    private NhanVien nhanVien;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaKhuyenMai")
    private KhuyenMai khuyenMai;

    @Column(name = "NgayLap", nullable = false)
    private LocalDateTime ngayLap;

    @Column(name = "TrangThaiDonHang", nullable = false, length = 30)
    private String trangThaiDonHang = "Chưa thanh toán";

    @Column(name = "GhiChu", length = 255)
    private String ghiChu;

    @OneToMany(mappedBy = "donHang")
    private List<ChiTietDonHangVe> chiTietDonHangVes = new ArrayList<>();

    @OneToMany(mappedBy = "donHang")
    private List<ChiTietDonHangSanPham> chiTietDonHangSanPhams = new ArrayList<>();

    @OneToMany(mappedBy = "donHang")
    private List<ThanhToan> thanhToans = new ArrayList<>();

    public DonHang() {
    }

    public Integer getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(Integer maDonHang) {
        this.maDonHang = maDonHang;
    }

    public KhachHang getKhachHang() {
        return khachHang;
    }

    public void setKhachHang(KhachHang khachHang) {
        this.khachHang = khachHang;
    }

    public NhanVien getNhanVien() {
        return nhanVien;
    }

    public void setNhanVien(NhanVien nhanVien) {
        this.nhanVien = nhanVien;
    }

    public KhuyenMai getKhuyenMai() {
        return khuyenMai;
    }

    public void setKhuyenMai(KhuyenMai khuyenMai) {
        this.khuyenMai = khuyenMai;
    }

    public LocalDateTime getNgayLap() {
        return ngayLap;
    }

    public void setNgayLap(LocalDateTime ngayLap) {
        this.ngayLap = ngayLap;
    }

    public String getTrangThaiDonHang() {
        return trangThaiDonHang;
    }

    public void setTrangThaiDonHang(String trangThaiDonHang) {
        this.trangThaiDonHang = trangThaiDonHang;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public List<ChiTietDonHangVe> getChiTietDonHangVes() {
        return chiTietDonHangVes;
    }

    public void setChiTietDonHangVes(List<ChiTietDonHangVe> chiTietDonHangVes) {
        this.chiTietDonHangVes = chiTietDonHangVes;
    }

    public List<ChiTietDonHangSanPham> getChiTietDonHangSanPhams() {
        return chiTietDonHangSanPhams;
    }

    public void setChiTietDonHangSanPhams(List<ChiTietDonHangSanPham> chiTietDonHangSanPhams) {
        this.chiTietDonHangSanPhams = chiTietDonHangSanPhams;
    }

    public List<ThanhToan> getThanhToans() {
        return thanhToans;
    }

    public void setThanhToans(List<ThanhToan> thanhToans) {
        this.thanhToans = thanhToans;
    }
}
