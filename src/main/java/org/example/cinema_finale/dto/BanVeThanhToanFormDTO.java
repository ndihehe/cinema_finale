package org.example.cinema_finale.dto;

public class BanVeThanhToanFormDTO {
    private Integer maDonHang;
    private String phuongThucThanhToan;

    public BanVeThanhToanFormDTO() {
    }

    public BanVeThanhToanFormDTO(Integer maDonHang, String phuongThucThanhToan) {
        this.maDonHang = maDonHang;
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public Integer getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(Integer maDonHang) {
        this.maDonHang = maDonHang;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }
}