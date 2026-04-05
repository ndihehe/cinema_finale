package org.example.cinema_finale.dto;

import java.math.BigDecimal;

public class ThanhToanFormDTO {
    private Integer maThanhToan;
    private Integer maDonHang;
    private BigDecimal soTien;
    private String phuongThucThanhToan;
    private String trangThaiThanhToan;

    public ThanhToanFormDTO() {
    }

    public ThanhToanFormDTO(Integer maThanhToan, Integer maDonHang, BigDecimal soTien,
                            String phuongThucThanhToan, String trangThaiThanhToan) {
        this.maThanhToan = maThanhToan;
        this.maDonHang = maDonHang;
        this.soTien = soTien;
        this.phuongThucThanhToan = phuongThucThanhToan;
        this.trangThaiThanhToan = trangThaiThanhToan;
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
}