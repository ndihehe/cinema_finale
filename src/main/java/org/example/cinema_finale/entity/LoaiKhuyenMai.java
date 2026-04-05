package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "LoaiKhuyenMai")
public class LoaiKhuyenMai {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaLoaiKhuyenMai")
    private Integer maLoaiKhuyenMai;

    @Column(name = "TenLoaiKhuyenMai", nullable = false, unique = true, length = 100)
    private String tenLoaiKhuyenMai;

    @Column(name = "MoTa", length = 255)
    private String moTa;

    @OneToMany(mappedBy = "loaiKhuyenMai")
    private List<KhuyenMai> danhSachKhuyenMai = new ArrayList<>();

    public LoaiKhuyenMai() {
    }

    public Integer getMaLoaiKhuyenMai() {
        return maLoaiKhuyenMai;
    }

    public void setMaLoaiKhuyenMai(Integer maLoaiKhuyenMai) {
        this.maLoaiKhuyenMai = maLoaiKhuyenMai;
    }

    public String getTenLoaiKhuyenMai() {
        return tenLoaiKhuyenMai;
    }

    public void setTenLoaiKhuyenMai(String tenLoaiKhuyenMai) {
        this.tenLoaiKhuyenMai = tenLoaiKhuyenMai;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public List<KhuyenMai> getDanhSachKhuyenMai() {
        return danhSachKhuyenMai;
    }

    public void setDanhSachKhuyenMai(List<KhuyenMai> danhSachKhuyenMai) {
        this.danhSachKhuyenMai = danhSachKhuyenMai;
    }
}
