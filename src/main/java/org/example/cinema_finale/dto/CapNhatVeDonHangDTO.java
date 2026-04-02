package org.example.cinema_finale.dto;

public class CapNhatVeDonHangDTO {
    private Integer maDonHang;
    private Integer maVe;

    public CapNhatVeDonHangDTO() {
    }

    public CapNhatVeDonHangDTO(Integer maDonHang, Integer maVe) {
        this.maDonHang = maDonHang;
        this.maVe = maVe;
    }

    public Integer getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(Integer maDonHang) {
        this.maDonHang = maDonHang;
    }

    public Integer getMaVe() {
        return maVe;
    }

    public void setMaVe(Integer maVe) {
        this.maVe = maVe;
    }
}