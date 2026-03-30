package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import org.example.cinema_finale.enums.TrangThaiThanhToan;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "thanh_toan")
public class ThanhToan {

    @Id
    @Column(name = "ma_thanh_toan", length = 20, nullable = false)
    private String maThanhToan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_don_hang", nullable = false)
    private DonHang donHang;

    @Column(name = "so_tien", precision = 12, scale = 2, nullable = false)
    private BigDecimal soTien;

    @Column(name = "phuong_thuc_thanh_toan", length = 50, nullable = false)
    private String phuongThucThanhToan;

    @Column(name = "thoi_gian_thanh_toan")
    private LocalDateTime thoiGianThanhToan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_nv")
    private NhanVien nhanVien;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai_thanh_toan", length = 30, nullable = false)
    private TrangThaiThanhToan trangThaiThanhToan;

    @Column(name = "ma_giao_dich", length = 50)
    private String maGiaoDich;

    public ThanhToan() {
    }

    public ThanhToan(String maThanhToan, DonHang donHang, BigDecimal soTien,
                     String phuongThucThanhToan, LocalDateTime thoiGianThanhToan,
                     NhanVien nhanVien, TrangThaiThanhToan trangThaiThanhToan,
                     String maGiaoDich) {
        this.maThanhToan = maThanhToan;
        this.donHang = donHang;
        this.soTien = soTien;
        this.phuongThucThanhToan = phuongThucThanhToan;
        this.thoiGianThanhToan = thoiGianThanhToan;
        this.nhanVien = nhanVien;
        this.trangThaiThanhToan = trangThaiThanhToan;
        this.maGiaoDich = maGiaoDich;
    }

    public String getMaThanhToan() {
        return maThanhToan;
    }

    public void setMaThanhToan(String maThanhToan) {
        this.maThanhToan = maThanhToan;
    }

    public DonHang getDonHang() {
        return donHang;
    }

    public void setDonHang(DonHang donHang) {
        this.donHang = donHang;
    }

    public BigDecimal getSoTien() {
        return soTien;
    }

    public void setSoTien(BigDecimal soTien) {
        this.soTien = soTien;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public LocalDateTime getThoiGianThanhToan() {
        return thoiGianThanhToan;
    }

    public void setThoiGianThanhToan(LocalDateTime thoiGianThanhToan) {
        this.thoiGianThanhToan = thoiGianThanhToan;
    }

    public NhanVien getNhanVien() {
        return nhanVien;
    }

    public void setNhanVien(NhanVien nhanVien) {
        this.nhanVien = nhanVien;
    }

    public TrangThaiThanhToan getTrangThaiThanhToan() {
        return trangThaiThanhToan;
    }

    public void setTrangThaiThanhToan(TrangThaiThanhToan trangThaiThanhToan) {
        this.trangThaiThanhToan = trangThaiThanhToan;
    }

    public String getMaGiaoDich() {
        return maGiaoDich;
    }

    public void setMaGiaoDich(String maGiaoDich) {
        this.maGiaoDich = maGiaoDich;
    }

    @Override
    public String toString() {
        return "ThanhToan{" +
                "maThanhToan='" + maThanhToan + '\'' +
                ", maDonHang='" + (donHang != null ? donHang.getMaDonHang() : null) + '\'' +
                ", soTien=" + soTien +
                ", phuongThucThanhToan='" + phuongThucThanhToan + '\'' +
                ", thoiGianThanhToan=" + thoiGianThanhToan +
                ", maNv='" + (nhanVien != null ? nhanVien.getMaNv() : null) + '\'' +
                ", trangThaiThanhToan=" + trangThaiThanhToan +
                ", maGiaoDich='" + maGiaoDich + '\'' +
                '}';
    }
}