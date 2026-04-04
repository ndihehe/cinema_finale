package org.example.cinema_finale.dto;

import java.time.LocalDate;

public class PhimDTO {
    private Integer maPhim;
    private String tenPhim;
    private String theLoai;
    private String daoDien;
    private Integer thoiLuong;
    private Integer gioiHanTuoi;
    private String dinhDang;
    private LocalDate ngayKhoiChieu;
    private String trangThaiPhim;
    private String posterUrl;

    public PhimDTO() {
    }

    public PhimDTO(Integer maPhim, String tenPhim, String theLoai, String daoDien,
                   Integer thoiLuong, Integer gioiHanTuoi, String dinhDang,
                   LocalDate ngayKhoiChieu, String trangThaiPhim) {
        this(maPhim, tenPhim, theLoai, daoDien, thoiLuong, gioiHanTuoi, dinhDang, ngayKhoiChieu, trangThaiPhim, null);
    }

    public PhimDTO(Integer maPhim, String tenPhim, String theLoai, String daoDien,
                   Integer thoiLuong, Integer gioiHanTuoi, String dinhDang,
                   LocalDate ngayKhoiChieu, String trangThaiPhim, String posterUrl) {
        this.maPhim = maPhim;
        this.tenPhim = tenPhim;
        this.theLoai = theLoai;
        this.daoDien = daoDien;
        this.thoiLuong = thoiLuong;
        this.gioiHanTuoi = gioiHanTuoi;
        this.dinhDang = dinhDang;
        this.ngayKhoiChieu = ngayKhoiChieu;
        this.trangThaiPhim = trangThaiPhim;
        this.posterUrl = posterUrl;
    }

    public Integer getMaPhim() { return maPhim; }
    public void setMaPhim(Integer maPhim) { this.maPhim = maPhim; }

    public String getTenPhim() { return tenPhim; }
    public void setTenPhim(String tenPhim) { this.tenPhim = tenPhim; }

    public String getTheLoai() { return theLoai; }
    public void setTheLoai(String theLoai) { this.theLoai = theLoai; }

    public String getDaoDien() { return daoDien; }
    public void setDaoDien(String daoDien) { this.daoDien = daoDien; }

    public Integer getThoiLuong() { return thoiLuong; }
    public void setThoiLuong(Integer thoiLuong) { this.thoiLuong = thoiLuong; }

    public Integer getGioiHanTuoi() { return gioiHanTuoi; }
    public void setGioiHanTuoi(Integer gioiHanTuoi) { this.gioiHanTuoi = gioiHanTuoi; }

    public String getDinhDang() { return dinhDang; }
    public void setDinhDang(String dinhDang) { this.dinhDang = dinhDang; }

    public LocalDate getNgayKhoiChieu() { return ngayKhoiChieu; }
    public void setNgayKhoiChieu(LocalDate ngayKhoiChieu) { this.ngayKhoiChieu = ngayKhoiChieu; }

    public String getTrangThaiPhim() { return trangThaiPhim; }
    public void setTrangThaiPhim(String trangThaiPhim) { this.trangThaiPhim = trangThaiPhim; }

    public String getPosterUrl() { return posterUrl; }
    public void setPosterUrl(String posterUrl) { this.posterUrl = posterUrl; }
}