package org.example.cinema_finale.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class SuatChieuDTO {
    private Integer maSuatChieu;

    private Integer maPhim;
    private String tenPhim;

    private Integer maPhongChieu;
    private String tenPhongChieu;

    private LocalDateTime ngayGioChieu;
    private BigDecimal giaVeCoBan;
    private String trangThaiSuatChieu;

    public SuatChieuDTO() {
    }

    public SuatChieuDTO(Integer maSuatChieu, Integer maPhim, String tenPhim,
                        Integer maPhongChieu, String tenPhongChieu,
                        LocalDateTime ngayGioChieu, BigDecimal giaVeCoBan,
                        String trangThaiSuatChieu) {
        this.maSuatChieu = maSuatChieu;
        this.maPhim = maPhim;
        this.tenPhim = tenPhim;
        this.maPhongChieu = maPhongChieu;
        this.tenPhongChieu = tenPhongChieu;
        this.ngayGioChieu = ngayGioChieu;
        this.giaVeCoBan = giaVeCoBan;
        this.trangThaiSuatChieu = trangThaiSuatChieu;
    }

    public Integer getMaSuatChieu() { return maSuatChieu; }
    public void setMaSuatChieu(Integer maSuatChieu) { this.maSuatChieu = maSuatChieu; }

    public Integer getMaPhim() { return maPhim; }
    public void setMaPhim(Integer maPhim) { this.maPhim = maPhim; }

    public String getTenPhim() { return tenPhim; }
    public void setTenPhim(String tenPhim) { this.tenPhim = tenPhim; }

    public Integer getMaPhongChieu() { return maPhongChieu; }
    public void setMaPhongChieu(Integer maPhongChieu) { this.maPhongChieu = maPhongChieu; }

    public String getTenPhongChieu() { return tenPhongChieu; }
    public void setTenPhongChieu(String tenPhongChieu) { this.tenPhongChieu = tenPhongChieu; }

    public LocalDateTime getNgayGioChieu() { return ngayGioChieu; }
    public void setNgayGioChieu(LocalDateTime ngayGioChieu) { this.ngayGioChieu = ngayGioChieu; }

    public BigDecimal getGiaVeCoBan() { return giaVeCoBan; }
    public void setGiaVeCoBan(BigDecimal giaVeCoBan) { this.giaVeCoBan = giaVeCoBan; }

    public String getTrangThaiSuatChieu() { return trangThaiSuatChieu; }
    public void setTrangThaiSuatChieu(String trangThaiSuatChieu) { this.trangThaiSuatChieu = trangThaiSuatChieu; }
}