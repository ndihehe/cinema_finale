package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;

@Entity
@Table(name = "chi_tiet_don_hang_ve")
public class ChiTietDonHangVe {

    @Id
    @Column(name = "ma_chi_tiet_ve", length = 20, nullable = false)
    private String maChiTietVe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_don_hang", nullable = false)
    private DonHang donHang;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_ve", nullable = false, unique = true)
    private Ve ve;

    @Column(name = "don_gia_ban", precision = 12, scale = 2, nullable = false)
    private BigDecimal donGiaBan;

    public ChiTietDonHangVe() {
    }

    public ChiTietDonHangVe(String maChiTietVe, DonHang donHang, Ve ve, BigDecimal donGiaBan) {
        this.maChiTietVe = maChiTietVe;
        this.donHang = donHang;
        this.ve = ve;
        this.donGiaBan = donGiaBan;
    }

    public String getMaChiTietVe() {
        return maChiTietVe;
    }

    public void setMaChiTietVe(String maChiTietVe) {
        this.maChiTietVe = maChiTietVe;
    }

    public DonHang getDonHang() {
        return donHang;
    }

    public void setDonHang(DonHang donHang) {
        this.donHang = donHang;
    }

    public Ve getVe() {
        return ve;
    }

    public void setVe(Ve ve) {
        this.ve = ve;
    }

    public BigDecimal getDonGiaBan() {
        return donGiaBan;
    }

    public void setDonGiaBan(BigDecimal donGiaBan) {
        this.donGiaBan = donGiaBan;
    }

    @Override
    public String toString() {
        return "ChiTietDonHangVe{" +
                "maChiTietVe='" + maChiTietVe + '\'' +
                ", maDonHang='" + (donHang != null ? donHang.getMaDonHang() : null) + '\'' +
                ", maVe='" + (ve != null ? ve.getMaVe() : null) + '\'' +
                ", donGiaBan=" + donGiaBan +
                '}';
    }
}