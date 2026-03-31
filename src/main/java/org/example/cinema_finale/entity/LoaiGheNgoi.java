package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "LoaiGheNgoi")
public class LoaiGheNgoi {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaLoaiGheNgoi")
    private Integer maLoaiGheNgoi;

    @Column(name = "TenLoaiGheNgoi", nullable = false, unique = true, length = 50)
    private String tenLoaiGheNgoi;

    @Column(name = "PhuThu", nullable = false, precision = 18, scale = 2)
    private BigDecimal phuThu = BigDecimal.ZERO;

    @OneToMany(mappedBy = "loaiGheNgoi")
    private List<GheNgoi> danhSachGheNgoi = new ArrayList<>();

    public LoaiGheNgoi() {
    }

    public Integer getMaLoaiGheNgoi() {
        return maLoaiGheNgoi;
    }

    public void setMaLoaiGheNgoi(Integer maLoaiGheNgoi) {
        this.maLoaiGheNgoi = maLoaiGheNgoi;
    }

    public String getTenLoaiGheNgoi() {
        return tenLoaiGheNgoi;
    }

    public void setTenLoaiGheNgoi(String tenLoaiGheNgoi) {
        this.tenLoaiGheNgoi = tenLoaiGheNgoi;
    }

    public BigDecimal getPhuThu() {
        return phuThu;
    }

    public void setPhuThu(BigDecimal phuThu) {
        this.phuThu = phuThu;
    }

    public List<GheNgoi> getDanhSachGheNgoi() {
        return danhSachGheNgoi;
    }

    public void setDanhSachGheNgoi(List<GheNgoi> danhSachGheNgoi) {
        this.danhSachGheNgoi = danhSachGheNgoi;
    }
}
