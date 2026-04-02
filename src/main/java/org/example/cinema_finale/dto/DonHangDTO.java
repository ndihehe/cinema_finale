package org.example.cinema_finale.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class DonHangDTO {
    private Integer maDonHang;
    private LocalDateTime ngayLap;
    private String trangThaiDonHang;
    private String ghiChu;
    private BigDecimal tongTien;
    private Integer soLuongVe;

    public DonHangDTO() {
    }

    public DonHangDTO(Integer maDonHang, LocalDateTime ngayLap, String trangThaiDonHang,
                      String ghiChu, BigDecimal tongTien, Integer soLuongVe) {
        this.maDonHang = maDonHang;
        this.ngayLap = ngayLap;
        this.trangThaiDonHang = trangThaiDonHang;
        this.ghiChu = ghiChu;
        this.tongTien = tongTien;
        this.soLuongVe = soLuongVe;
    }

    public Integer getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(Integer maDonHang) {
        this.maDonHang = maDonHang;
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

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(BigDecimal tongTien) {
        this.tongTien = tongTien;
    }

    public Integer getSoLuongVe() {
        return soLuongVe;
    }

    public void setSoLuongVe(Integer soLuongVe) {
        this.soLuongVe = soLuongVe;
    }
}