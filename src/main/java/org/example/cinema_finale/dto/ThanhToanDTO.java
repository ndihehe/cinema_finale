package org.example.cinema_finale.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ThanhToanDTO {
    private Integer maThanhToan;
    private Integer maDonHang;
    private BigDecimal soTien;
    private String phuongThucThanhToan;
    private String trangThaiThanhToan;
    private LocalDateTime thoiGianThanhToan;

    public ThanhToanDTO() {
    }

    public ThanhToanDTO(Integer maThanhToan, Integer maDonHang, BigDecimal soTien,
                        String phuongThucThanhToan, String trangThaiThanhToan,
                        LocalDateTime thoiGianThanhToan) {
        this.maThanhToan = maThanhToan;
        this.maDonHang = maDonHang;
        this.soTien = soTien;
        this.phuongThucThanhToan = phuongThucThanhToan;
        this.trangThaiThanhToan = trangThaiThanhToan;
        this.thoiGianThanhToan = thoiGianThanhToan;
    }

    public Integer getMaThanhToan() {
        return maThanhToan;
    }

    public void setMaThanhToan(Integer maThanhToan) {
        this.maThanhToan = maThanhToan;
    }

    public Integer getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(Integer maDonHang) {
        this.maDonHang = maDonHang;
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

    public String getTrangThaiThanhToan() {
        return trangThaiThanhToan;
    }

    public void setTrangThaiThanhToan(String trangThaiThanhToan) {
        this.trangThaiThanhToan = trangThaiThanhToan;
    }

    public LocalDateTime getThoiGianThanhToan() {
        return thoiGianThanhToan;
    }

    public void setThoiGianThanhToan(LocalDateTime thoiGianThanhToan) {
        this.thoiGianThanhToan = thoiGianThanhToan;
    }
}