package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "DanhMucSanPham")
public class DanhMucSanPham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDanhMucSanPham")
    private Integer maDanhMucSanPham;

    @Column(name = "TenDanhMucSanPham", nullable = false, unique = true, length = 100)
    private String tenDanhMucSanPham;

    @Column(name = "MoTa", length = 255)
    private String moTa;

    @OneToMany(mappedBy = "danhMucSanPham")
    private List<LoaiSanPham> danhSachLoaiSanPham = new ArrayList<>();

    public DanhMucSanPham() {
    }

    public Integer getMaDanhMucSanPham() {
        return maDanhMucSanPham;
    }

    public void setMaDanhMucSanPham(Integer maDanhMucSanPham) {
        this.maDanhMucSanPham = maDanhMucSanPham;
    }

    public String getTenDanhMucSanPham() {
        return tenDanhMucSanPham;
    }

    public void setTenDanhMucSanPham(String tenDanhMucSanPham) {
        this.tenDanhMucSanPham = tenDanhMucSanPham;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public List<LoaiSanPham> getDanhSachLoaiSanPham() {
        return danhSachLoaiSanPham;
    }

    public void setDanhSachLoaiSanPham(List<LoaiSanPham> danhSachLoaiSanPham) {
        this.danhSachLoaiSanPham = danhSachLoaiSanPham;
    }
}
