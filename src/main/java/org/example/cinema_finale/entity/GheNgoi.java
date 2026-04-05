package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(
    name = "GheNgoi",
    uniqueConstraints = {
        @UniqueConstraint(name = "UK_GheNgoi_ViTri", columnNames = {"MaPhongChieu", "HangGhe", "SoGhe"})
    }
)
public class GheNgoi {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaGheNgoi")
    private Integer maGheNgoi;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaPhongChieu", nullable = false)
    private PhongChieu phongChieu;

    @Column(name = "HangGhe", nullable = false, length = 5)
    private String hangGhe;

    @Column(name = "SoGhe", nullable = false)
    private Integer soGhe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaLoaiGheNgoi", nullable = false)
    private LoaiGheNgoi loaiGheNgoi;

    @Column(name = "TrangThaiGhe", nullable = false, length = 30)
    private String trangThaiGhe = "Hoạt động";

    @OneToMany(mappedBy = "gheNgoi")
    private List<Ve> danhSachVe = new ArrayList<>();

    public GheNgoi() {
    }

    public Integer getMaGheNgoi() {
        return maGheNgoi;
    }

    public void setMaGheNgoi(Integer maGheNgoi) {
        this.maGheNgoi = maGheNgoi;
    }

    public PhongChieu getPhongChieu() {
        return phongChieu;
    }

    public void setPhongChieu(PhongChieu phongChieu) {
        this.phongChieu = phongChieu;
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

    public LoaiGheNgoi getLoaiGheNgoi() {
        return loaiGheNgoi;
    }

    public void setLoaiGheNgoi(LoaiGheNgoi loaiGheNgoi) {
        this.loaiGheNgoi = loaiGheNgoi;
    }

    public String getTrangThaiGhe() {
        return trangThaiGhe;
    }

    public void setTrangThaiGhe(String trangThaiGhe) {
        this.trangThaiGhe = trangThaiGhe;
    }

    public List<Ve> getDanhSachVe() {
        return danhSachVe;
    }

    public void setDanhSachVe(List<Ve> danhSachVe) {
        this.danhSachVe = danhSachVe;
    }
}
