package org.example.cinema_finale.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class BanVeDTO {
    private Integer maVe;

    private Integer maSuatChieu;
    private Integer maPhim;
    private String tenPhim;
    private Integer maPhongChieu;
    private String tenPhongChieu;
    private LocalDateTime ngayGioChieu;

    private Integer maGheNgoi;
    private String hangGhe;
    private Integer soGhe;
    private String tenLoaiGheNgoi;
    private String trangThaiGhe;

    private Integer maLoaiVe;
    private String tenLoaiVe;

    private BigDecimal giaVeCoBan;
    private BigDecimal phuThuGhe;
    private BigDecimal phuThuLoaiVe;
    private BigDecimal giaVe;
    private String trangThaiVe;

    public BanVeDTO() {
    }

    public BanVeDTO(Integer maVe, Integer maSuatChieu, Integer maPhim, String tenPhim,
                    Integer maPhongChieu, String tenPhongChieu, LocalDateTime ngayGioChieu,
                    Integer maGheNgoi, String hangGhe, Integer soGhe,
                    String tenLoaiGheNgoi, String trangThaiGhe,
                    Integer maLoaiVe, String tenLoaiVe,
                    BigDecimal giaVeCoBan, BigDecimal phuThuGhe,
                    BigDecimal phuThuLoaiVe, BigDecimal giaVe, String trangThaiVe) {
        this.maVe = maVe;
        this.maSuatChieu = maSuatChieu;
        this.maPhim = maPhim;
        this.tenPhim = tenPhim;
        this.maPhongChieu = maPhongChieu;
        this.tenPhongChieu = tenPhongChieu;
        this.ngayGioChieu = ngayGioChieu;
        this.maGheNgoi = maGheNgoi;
        this.hangGhe = hangGhe;
        this.soGhe = soGhe;
        this.tenLoaiGheNgoi = tenLoaiGheNgoi;
        this.trangThaiGhe = trangThaiGhe;
        this.maLoaiVe = maLoaiVe;
        this.tenLoaiVe = tenLoaiVe;
        this.giaVeCoBan = giaVeCoBan;
        this.phuThuGhe = phuThuGhe;
        this.phuThuLoaiVe = phuThuLoaiVe;
        this.giaVe = giaVe;
        this.trangThaiVe = trangThaiVe;
    }

    public Integer getMaVe() {
        return maVe;
    }

    public void setMaVe(Integer maVe) {
        this.maVe = maVe;
    }

    public Integer getMaSuatChieu() {
        return maSuatChieu;
    }

    public void setMaSuatChieu(Integer maSuatChieu) {
        this.maSuatChieu = maSuatChieu;
    }

    public Integer getMaPhim() {
        return maPhim;
    }

    public void setMaPhim(Integer maPhim) {
        this.maPhim = maPhim;
    }

    public String getTenPhim() {
        return tenPhim;
    }

    public void setTenPhim(String tenPhim) {
        this.tenPhim = tenPhim;
    }

    public Integer getMaPhongChieu() {
        return maPhongChieu;
    }

    public void setMaPhongChieu(Integer maPhongChieu) {
        this.maPhongChieu = maPhongChieu;
    }

    public String getTenPhongChieu() {
        return tenPhongChieu;
    }

    public void setTenPhongChieu(String tenPhongChieu) {
        this.tenPhongChieu = tenPhongChieu;
    }

    public LocalDateTime getNgayGioChieu() {
        return ngayGioChieu;
    }

    public void setNgayGioChieu(LocalDateTime ngayGioChieu) {
        this.ngayGioChieu = ngayGioChieu;
    }

    public Integer getMaGheNgoi() {
        return maGheNgoi;
    }

    public void setMaGheNgoi(Integer maGheNgoi) {
        this.maGheNgoi = maGheNgoi;
    }

    public String getHangGhe() {
        return hangGhe;
    }

    public void setHangGhe(String hangGhe) {
        this.hangGhe = hangGhe;
    }

    public Integer getSoGhe() {
        return soGhe;
    }

    public void setSoGhe(Integer soGhe) {
        this.soGhe = soGhe;
    }

    public String getTenLoaiGheNgoi() {
        return tenLoaiGheNgoi;
    }

    public void setTenLoaiGheNgoi(String tenLoaiGheNgoi) {
        this.tenLoaiGheNgoi = tenLoaiGheNgoi;
    }

    public String getTrangThaiGhe() {
        return trangThaiGhe;
    }

    public void setTrangThaiGhe(String trangThaiGhe) {
        this.trangThaiGhe = trangThaiGhe;
    }

    public Integer getMaLoaiVe() {
        return maLoaiVe;
    }

    public void setMaLoaiVe(Integer maLoaiVe) {
        this.maLoaiVe = maLoaiVe;
    }

    public String getTenLoaiVe() {
        return tenLoaiVe;
    }

    public void setTenLoaiVe(String tenLoaiVe) {
        this.tenLoaiVe = tenLoaiVe;
    }

    public BigDecimal getGiaVeCoBan() {
        return giaVeCoBan;
    }

    public void setGiaVeCoBan(BigDecimal giaVeCoBan) {
        this.giaVeCoBan = giaVeCoBan;
    }

    public BigDecimal getPhuThuGhe() {
        return phuThuGhe;
    }

    public void setPhuThuGhe(BigDecimal phuThuGhe) {
        this.phuThuGhe = phuThuGhe;
    }

    public BigDecimal getPhuThuLoaiVe() {
        return phuThuLoaiVe;
    }

    public void setPhuThuLoaiVe(BigDecimal phuThuLoaiVe) {
        this.phuThuLoaiVe = phuThuLoaiVe;
    }

    public BigDecimal getGiaVe() {
        return giaVe;
    }

    public void setGiaVe(BigDecimal giaVe) {
        this.giaVe = giaVe;
    }

    public String getTrangThaiVe() {
        return trangThaiVe;
    }

    public void setTrangThaiVe(String trangThaiVe) {
        this.trangThaiVe = trangThaiVe;
    }

    public String getViTriGhe() {
        return (hangGhe != null ? hangGhe : "") + (soGhe != null ? soGhe : "");
    }
}