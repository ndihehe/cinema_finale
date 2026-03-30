package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "loai_ve")
public class LoaiVe {

    @Id
    @Column(name = "ma_loai_ve", length = 20, nullable = false)
    private String maLoaiVe;

    @Column(name = "ten_loai_ve", length = 100, nullable = false)
    private String tenLoaiVe;

    @Column(name = "mo_ta", length = 255)
    private String moTa;

    @Column(name = "phu_thu_gia", precision = 12, scale = 2, nullable = false)
    private BigDecimal phuThuGia = BigDecimal.ZERO;

    @OneToMany(mappedBy = "loaiVe")
    private List<Ve> danhSachVe = new ArrayList<>();

    public LoaiVe() {
    }

    public LoaiVe(String maLoaiVe, String tenLoaiVe, String moTa, BigDecimal phuThuGia) {
        this.maLoaiVe = maLoaiVe;
        this.tenLoaiVe = tenLoaiVe;
        this.moTa = moTa;
        this.phuThuGia = phuThuGia;
    }

    public String getMaLoaiVe() {
        return maLoaiVe;
    }

    public void setMaLoaiVe(String maLoaiVe) {
        this.maLoaiVe = maLoaiVe;
    }

    public String getTenLoaiVe() {
        return tenLoaiVe;
    }

    public void setTenLoaiVe(String tenLoaiVe) {
        this.tenLoaiVe = tenLoaiVe;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public BigDecimal getPhuThuGia() {
        return phuThuGia;
    }

    public void setPhuThuGia(BigDecimal phuThuGia) {
        this.phuThuGia = phuThuGia;
    }

    public List<Ve> getDanhSachVe() {
        return danhSachVe;
    }

    public void setDanhSachVe(List<Ve> danhSachVe) {
        this.danhSachVe = danhSachVe;
    }

    @Override
    public String toString() {
        return "LoaiVe{" +
                "maLoaiVe='" + maLoaiVe + '\'' +
                ", tenLoaiVe='" + tenLoaiVe + '\'' +
                ", moTa='" + moTa + '\'' +
                ", phuThuGia=" + phuThuGia +
                '}';
    }
}