package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "SanPham")
public class SanPham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaSanPham")
    private Integer maSanPham;

    @Column(name = "TenSanPham", nullable = false, length = 150)
    private String tenSanPham;

    @Column(name = "DonGia", nullable = false, precision = 18, scale = 2)
    private BigDecimal donGia;

    @Column(name = "SoLuongTon", nullable = false)
    private Integer soLuongTon = 0;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaLoaiSanPham", nullable = false)
    private LoaiSanPham loaiSanPham;

    @Column(name = "TrangThai", nullable = false, length = 30)
    private String trangThai = "Đang bán";

    @OneToMany(mappedBy = "sanPham")
    private List<ChiTietDonHangSanPham> chiTietDonHangSanPhams = new ArrayList<>();

    public SanPham() {
    }

    public Integer getMaSanPham() {
        return maSanPham;
    }

    public void setMaSanPham(Integer maSanPham) {
        this.maSanPham = maSanPham;
    }

    public String getTenSanPham() {
        return tenSanPham;
    }

    public void setTenSanPham(String tenSanPham) {
        this.tenSanPham = tenSanPham;
    }

    public BigDecimal getDonGia() {
        return donGia;
    }

    public void setDonGia(BigDecimal donGia) {
        this.donGia = donGia;
    }

    public Integer getSoLuongTon() {
        return soLuongTon;
    }

    public void setSoLuongTon(Integer soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public LoaiSanPham getLoaiSanPham() {
        return loaiSanPham;
    }

    public void setLoaiSanPham(LoaiSanPham loaiSanPham) {
        this.loaiSanPham = loaiSanPham;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public List<ChiTietDonHangSanPham> getChiTietDonHangSanPhams() {
        return chiTietDonHangSanPhams;
    }

    public void setChiTietDonHangSanPhams(List<ChiTietDonHangSanPham> chiTietDonHangSanPhams) {
        this.chiTietDonHangSanPhams = chiTietDonHangSanPhams;
    }
}
