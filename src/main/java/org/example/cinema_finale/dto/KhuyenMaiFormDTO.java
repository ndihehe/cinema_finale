package org.example.cinema_finale.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class KhuyenMaiFormDTO {
    private Integer maKhuyenMai;
    private String tenKhuyenMai;
    private Integer maLoaiKhuyenMai;
    private String kieuGiaTri;
    private BigDecimal giaTri;
    private LocalDateTime ngayBatDau;
    private LocalDateTime ngayKetThuc;
    private BigDecimal donHangToiThieu;
    private String trangThai;

    public KhuyenMaiFormDTO() {
    }

    public KhuyenMaiFormDTO(Integer maKhuyenMai, String tenKhuyenMai, Integer maLoaiKhuyenMai,
                            String kieuGiaTri, BigDecimal giaTri,
                            LocalDateTime ngayBatDau, LocalDateTime ngayKetThuc,
                            BigDecimal donHangToiThieu, String trangThai) {
        this.maKhuyenMai = maKhuyenMai;
        this.tenKhuyenMai = tenKhuyenMai;
        this.maLoaiKhuyenMai = maLoaiKhuyenMai;
        this.kieuGiaTri = kieuGiaTri;
        this.giaTri = giaTri;
        this.ngayBatDau = ngayBatDau;
        this.ngayKetThuc = ngayKetThuc;
        this.donHangToiThieu = donHangToiThieu;
        this.trangThai = trangThai;
    }

    public Integer getMaKhuyenMai() {
        return maKhuyenMai;
    }

    public void setMaKhuyenMai(Integer maKhuyenMai) {
        this.maKhuyenMai = maKhuyenMai;
    }

    public String getTenKhuyenMai() {
        return tenKhuyenMai;
    }

    public void setTenKhuyenMai(String tenKhuyenMai) {
        this.tenKhuyenMai = tenKhuyenMai;
    }

    public Integer getMaLoaiKhuyenMai() {
        return maLoaiKhuyenMai;
    }

    public void setMaLoaiKhuyenMai(Integer maLoaiKhuyenMai) {
        this.maLoaiKhuyenMai = maLoaiKhuyenMai;
    }

    public String getKieuGiaTri() {
        return kieuGiaTri;
    }

    public void setKieuGiaTri(String kieuGiaTri) {
        this.kieuGiaTri = kieuGiaTri;
    }

    public BigDecimal getGiaTri() {
        return giaTri;
    }

    public void setGiaTri(BigDecimal giaTri) {
        this.giaTri = giaTri;
    }

    public LocalDateTime getNgayBatDau() {
        return ngayBatDau;
    }

    public void setNgayBatDau(LocalDateTime ngayBatDau) {
        this.ngayBatDau = ngayBatDau;
    }

    public LocalDateTime getNgayKetThuc() {
        return ngayKetThuc;
    }

    public void setNgayKetThuc(LocalDateTime ngayKetThuc) {
        this.ngayKetThuc = ngayKetThuc;
    }

    public BigDecimal getDonHangToiThieu() {
        return donHangToiThieu;
    }

    public void setDonHangToiThieu(BigDecimal donHangToiThieu) {
        this.donHangToiThieu = donHangToiThieu;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}