package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "PhongChieu")
public class PhongChieu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaPhongChieu")
    private Integer maPhongChieu;

    @Column(name = "TenPhongChieu", nullable = false, unique = true, length = 50)
    private String tenPhongChieu;

    @Column(name = "LoaiManHinh", length = 50)
    private String loaiManHinh;

    @Column(name = "HeThongAmThanh", length = 100)
    private String heThongAmThanh;

    @Column(name = "TrangThaiPhong", nullable = false, length = 30)
    private String trangThaiPhong = "Hoạt động";

    @OneToMany(mappedBy = "phongChieu")
    private List<GheNgoi> danhSachGheNgoi = new ArrayList<>();

    @OneToMany(mappedBy = "phongChieu")
    private List<SuatChieu> danhSachSuatChieu = new ArrayList<>();

    public PhongChieu() {
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

    public String getLoaiManHinh() {
        return loaiManHinh;
    }

    public void setLoaiManHinh(String loaiManHinh) {
        this.loaiManHinh = loaiManHinh;
    }

    public String getHeThongAmThanh() {
        return heThongAmThanh;
    }

    public void setHeThongAmThanh(String heThongAmThanh) {
        this.heThongAmThanh = heThongAmThanh;
    }

    public String getTrangThaiPhong() {
        return trangThaiPhong;
    }

    public void setTrangThaiPhong(String trangThaiPhong) {
        this.trangThaiPhong = trangThaiPhong;
    }

    public List<GheNgoi> getDanhSachGheNgoi() {
        return danhSachGheNgoi;
    }

    public void setDanhSachGheNgoi(List<GheNgoi> danhSachGheNgoi) {
        this.danhSachGheNgoi = danhSachGheNgoi;
    }

    public List<SuatChieu> getDanhSachSuatChieu() {
        return danhSachSuatChieu;
    }

    public void setDanhSachSuatChieu(List<SuatChieu> danhSachSuatChieu) {
        this.danhSachSuatChieu = danhSachSuatChieu;
    }

    @Override
    public String toString() {
        return tenPhongChieu != null ? tenPhongChieu : "Phòng " + maPhongChieu;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PhongChieu)) return false;
        PhongChieu p = (PhongChieu) o;
        return maPhongChieu != null && maPhongChieu.equals(p.maPhongChieu);
    }

    @Override
    public int hashCode() {
        return maPhongChieu != null ? maPhongChieu.hashCode() : 0;
    }
}
