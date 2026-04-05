package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "LoaiVe")
public class LoaiVe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaLoaiVe")
    private Integer maLoaiVe;

    @Column(name = "TenLoaiVe", nullable = false, unique = true, length = 100)
    private String tenLoaiVe;

    @Column(name = "PhuThuGia", nullable = false, precision = 18, scale = 2)
    private BigDecimal phuThuGia = BigDecimal.ZERO;

    @Column(name = "MoTa", length = 255)
    private String moTa;

    @OneToMany(mappedBy = "loaiVe")
    private List<Ve> danhSachVe = new ArrayList<>();

    public LoaiVe() {
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

    public BigDecimal getPhuThuGia() {
        return phuThuGia;
    }

    public void setPhuThuGia(BigDecimal phuThuGia) {
        this.phuThuGia = phuThuGia;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public List<Ve> getDanhSachVe() {
        return danhSachVe;
    }

    public void setDanhSachVe(List<Ve> danhSachVe) {
        this.danhSachVe = danhSachVe;
    }
}
