package org.example.cinema_finale.entity;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "Phim")
public class Phim {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaPhim")
    private Integer maPhim;

    @Column(name = "TenPhim", nullable = false, length = 200)
    private String tenPhim;

    @Column(name = "TheLoai", length = 100)
    private String theLoai;

    @Column(name = "DaoDien", length = 100)
    private String daoDien;

    @Column(name = "ThoiLuong", nullable = false)
    private Integer thoiLuong;

    @Column(name = "GioiHanTuoi")
    private Integer gioiHanTuoi;

    @Column(name = "DinhDang", length = 30)
    private String dinhDang;

    @Column(name = "NgayKhoiChieu")
    private LocalDate ngayKhoiChieu;

    @Column(name = "TrangThaiPhim", nullable = false, length = 30)
    private String trangThaiPhim = "Sắp chiếu";

    @Column(name = "PosterUrl", length = 500)
    private String posterUrl;

    @OneToMany(mappedBy = "phim")
    private List<SuatChieu> danhSachSuatChieu = new ArrayList<>();

    public Phim() {
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

    public String getTheLoai() {
        return theLoai;
    }

    public void setTheLoai(String theLoai) {
        this.theLoai = theLoai;
    }

    public String getDaoDien() {
        return daoDien;
    }

    public void setDaoDien(String daoDien) {
        this.daoDien = daoDien;
    }

    public Integer getThoiLuong() {
        return thoiLuong;
    }

    public void setThoiLuong(Integer thoiLuong) {
        this.thoiLuong = thoiLuong;
    }

    public Integer getGioiHanTuoi() {
        return gioiHanTuoi;
    }

    public void setGioiHanTuoi(Integer gioiHanTuoi) {
        this.gioiHanTuoi = gioiHanTuoi;
    }

    public String getDinhDang() {
        return dinhDang;
    }

    public void setDinhDang(String dinhDang) {
        this.dinhDang = dinhDang;
    }

    public LocalDate getNgayKhoiChieu() {
        return ngayKhoiChieu;
    }

    public void setNgayKhoiChieu(LocalDate ngayKhoiChieu) {
        this.ngayKhoiChieu = ngayKhoiChieu;
    }

    public String getTrangThaiPhim() {
        return trangThaiPhim;
    }

    public void setTrangThaiPhim(String trangThaiPhim) {
        this.trangThaiPhim = trangThaiPhim;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }

    public List<SuatChieu> getDanhSachSuatChieu() {
        return danhSachSuatChieu;
    }

    public void setDanhSachSuatChieu(List<SuatChieu> danhSachSuatChieu) {
        this.danhSachSuatChieu = danhSachSuatChieu;
    }
}
