package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(
    name = "SuatChieu",
    uniqueConstraints = {
        @UniqueConstraint(name = "UK_SuatChieu_Phong_ThoiGian", columnNames = {"MaPhongChieu", "NgayGioChieu"})
    }
)
public class SuatChieu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaSuatChieu")
    private Integer maSuatChieu;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaPhim", nullable = false)
    private Phim phim;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaPhongChieu", nullable = false)
    private PhongChieu phongChieu;

    @Column(name = "NgayGioChieu", nullable = false)
    private LocalDateTime ngayGioChieu;

    @Column(name = "GiaVeCoBan", nullable = false, precision = 18, scale = 2)
    private BigDecimal giaVeCoBan;

    @Column(name = "TrangThaiSuatChieu", nullable = false, length = 30)
    private String trangThaiSuatChieu = "Sắp chiếu";

    @OneToMany(mappedBy = "suatChieu")
    private List<Ve> danhSachVe = new ArrayList<>();

    public SuatChieu() {
    }

    public Integer getMaSuatChieu() {
        return maSuatChieu;
    }

    public void setMaSuatChieu(Integer maSuatChieu) {
        this.maSuatChieu = maSuatChieu;
    }

    public Phim getPhim() {
        return phim;
    }

    public void setPhim(Phim phim) {
        this.phim = phim;
    }

    public PhongChieu getPhongChieu() {
        return phongChieu;
    }

    public void setPhongChieu(PhongChieu phongChieu) {
        this.phongChieu = phongChieu;
    }

    public LocalDateTime getNgayGioChieu() {
        return ngayGioChieu;
    }

    public void setNgayGioChieu(LocalDateTime ngayGioChieu) {
        this.ngayGioChieu = ngayGioChieu;
    }

    public BigDecimal getGiaVeCoBan() {
        return giaVeCoBan;
    }

    public void setGiaVeCoBan(BigDecimal giaVeCoBan) {
        this.giaVeCoBan = giaVeCoBan;
    }

    public String getTrangThaiSuatChieu() {
        return trangThaiSuatChieu;
    }

    public void setTrangThaiSuatChieu(String trangThaiSuatChieu) {
        this.trangThaiSuatChieu = trangThaiSuatChieu;
    }

    public List<Ve> getDanhSachVe() {
        return danhSachVe;
    }

    public void setDanhSachVe(List<Ve> danhSachVe) {
        this.danhSachVe = danhSachVe;
    }
}
