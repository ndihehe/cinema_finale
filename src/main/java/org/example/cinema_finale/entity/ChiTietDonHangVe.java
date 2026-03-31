package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(
    name = "ChiTietDonHangVe",
    uniqueConstraints = {
        @UniqueConstraint(name = "UK_ChiTietDonHangVe_MaVe", columnNames = {"MaVe"})
    }
)
public class ChiTietDonHangVe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaChiTietVe")
    private Integer maChiTietVe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaDonHang", nullable = false)
    private DonHang donHang;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaVe", nullable = false, unique = true)
    private Ve ve;

    @Column(name = "DonGiaBan", nullable = false, precision = 18, scale = 2)
    private BigDecimal donGiaBan;

    public ChiTietDonHangVe() {
    }

    public Integer getMaChiTietVe() {
        return maChiTietVe;
    }

    public void setMaChiTietVe(Integer maChiTietVe) {
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
}
