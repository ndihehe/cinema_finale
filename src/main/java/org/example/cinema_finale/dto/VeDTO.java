package org.example.cinema_finale.dto;

import java.math.BigDecimal;

public class VeDTO {
    private Integer maVe;
    private Integer maSuatChieu;
    private Integer maGheNgoi;
    private Integer maLoaiVe;
    private String tenPhim;
    private String tenPhongChieu;
    private String ngayGioChieu;
    private String viTriGhe;
    private String tenLoaiVe;
    private BigDecimal giaVe;
    private String trangThaiVe;

    public VeDTO() {
    }

    public VeDTO(Integer maVe, Integer maSuatChieu, Integer maGheNgoi, Integer maLoaiVe,
                 String tenPhim, String tenPhongChieu, String ngayGioChieu,
                 String viTriGhe, String tenLoaiVe, BigDecimal giaVe, String trangThaiVe) {
        this.maVe = maVe;
        this.maSuatChieu = maSuatChieu;
        this.maGheNgoi = maGheNgoi;
        this.maLoaiVe = maLoaiVe;
        this.tenPhim = tenPhim;
        this.tenPhongChieu = tenPhongChieu;
        this.ngayGioChieu = ngayGioChieu;
        this.viTriGhe = viTriGhe;
        this.tenLoaiVe = tenLoaiVe;
        this.giaVe = giaVe;
        this.trangThaiVe = trangThaiVe;
    }

    public Integer getMaVe() { return maVe; }
    public void setMaVe(Integer maVe) { this.maVe = maVe; }

    public Integer getMaSuatChieu() { return maSuatChieu; }
    public void setMaSuatChieu(Integer maSuatChieu) { this.maSuatChieu = maSuatChieu; }

    public Integer getMaGheNgoi() { return maGheNgoi; }
    public void setMaGheNgoi(Integer maGheNgoi) { this.maGheNgoi = maGheNgoi; }

    public Integer getMaLoaiVe() { return maLoaiVe; }
    public void setMaLoaiVe(Integer maLoaiVe) { this.maLoaiVe = maLoaiVe; }

    public String getTenPhim() { return tenPhim; }
    public void setTenPhim(String tenPhim) { this.tenPhim = tenPhim; }

    public String getTenPhongChieu() { return tenPhongChieu; }
    public void setTenPhongChieu(String tenPhongChieu) { this.tenPhongChieu = tenPhongChieu; }

    public String getNgayGioChieu() { return ngayGioChieu; }
    public void setNgayGioChieu(String ngayGioChieu) { this.ngayGioChieu = ngayGioChieu; }

    public String getViTriGhe() { return viTriGhe; }
    public void setViTriGhe(String viTriGhe) { this.viTriGhe = viTriGhe; }

    public String getTenLoaiVe() { return tenLoaiVe; }
    public void setTenLoaiVe(String tenLoaiVe) { this.tenLoaiVe = tenLoaiVe; }

    public BigDecimal getGiaVe() { return giaVe; }
    public void setGiaVe(BigDecimal giaVe) { this.giaVe = giaVe; }

    public String getTrangThaiVe() { return trangThaiVe; }
    public void setTrangThaiVe(String trangThaiVe) { this.trangThaiVe = trangThaiVe; }
}