package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import org.example.cinema_finale.enums.TrangThaiPhim;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "phim")
public class Phim {

    @Id
    @Column(name = "ma_phim", length = 20, nullable = false)
    private String maPhim;

    @Column(name = "ten_phim", length = 255, nullable = false)
    private String tenPhim;

    @Column(name = "the_loai", length = 100, nullable = false)
    private String theLoai;

    @Column(name = "dao_dien", length = 100, nullable = false)
    private String daoDien;

    @Column(name = "thoi_luong", nullable = false)
    private Integer thoiLuong;

    @Column(name = "gioi_han_tuoi", length = 20)
    private String gioiHanTuoi;

    @Column(name = "dinh_dang", length = 50)
    private String dinhDang;

    @Column(name = "ngay_khoi_chieu")
    private LocalDate ngayKhoiChieu;

    @Column(name = "mo_ta", columnDefinition = "TEXT")
    private String moTa;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai_phim", length = 30, nullable = false)
    private TrangThaiPhim trangThaiPhim;

    @OneToMany(mappedBy = "phim")
    private List<SuatChieu> danhSachSuatChieu = new ArrayList<>();

    public Phim() {
    }

    public Phim(String maPhim, String tenPhim, String theLoai, String daoDien,
                Integer thoiLuong, String gioiHanTuoi, String dinhDang,
                LocalDate ngayKhoiChieu, String moTa, TrangThaiPhim trangThaiPhim) {
        this.maPhim = maPhim;
        this.tenPhim = tenPhim;
        this.theLoai = theLoai;
        this.daoDien = daoDien;
        this.thoiLuong = thoiLuong;
        this.gioiHanTuoi = gioiHanTuoi;
        this.dinhDang = dinhDang;
        this.ngayKhoiChieu = ngayKhoiChieu;
        this.moTa = moTa;
        this.trangThaiPhim = trangThaiPhim;
    }

    public String getMaPhim() { return maPhim; }
    public void setMaPhim(String maPhim) { this.maPhim = maPhim; }

    public String getTenPhim() { return tenPhim; }
    public void setTenPhim(String tenPhim) { this.tenPhim = tenPhim; }

    public String getTheLoai() { return theLoai; }
    public void setTheLoai(String theLoai) { this.theLoai = theLoai; }

    public String getDaoDien() { return daoDien; }
    public void setDaoDien(String daoDien) { this.daoDien = daoDien; }

    public Integer getThoiLuong() { return thoiLuong; }
    public void setThoiLuong(Integer thoiLuong) { this.thoiLuong = thoiLuong; }

    public String getGioiHanTuoi() { return gioiHanTuoi; }
    public void setGioiHanTuoi(String gioiHanTuoi) { this.gioiHanTuoi = gioiHanTuoi; }

    public String getDinhDang() { return dinhDang; }
    public void setDinhDang(String dinhDang) { this.dinhDang = dinhDang; }

    public LocalDate getNgayKhoiChieu() { return ngayKhoiChieu; }
    public void setNgayKhoiChieu(LocalDate ngayKhoiChieu) { this.ngayKhoiChieu = ngayKhoiChieu; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public TrangThaiPhim getTrangThaiPhim() { return trangThaiPhim; }
    public void setTrangThaiPhim(TrangThaiPhim trangThaiPhim) { this.trangThaiPhim = trangThaiPhim; }

    public List<SuatChieu> getDanhSachSuatChieu() { return danhSachSuatChieu; }
    public void setDanhSachSuatChieu(List<SuatChieu> danhSachSuatChieu) { this.danhSachSuatChieu = danhSachSuatChieu; }

    @Override
    public String toString() {
        return "Phim{" +
                "maPhim='" + maPhim + '\'' +
                ", tenPhim='" + tenPhim + '\'' +
                ", theLoai='" + theLoai + '\'' +
                ", daoDien='" + daoDien + '\'' +
                ", thoiLuong=" + thoiLuong +
                ", gioiHanTuoi='" + gioiHanTuoi + '\'' +
                ", dinhDang='" + dinhDang + '\'' +
                ", ngayKhoiChieu=" + ngayKhoiChieu +
                ", trangThaiPhim='" + trangThaiPhim + '\'' +
                '}';
    }
}