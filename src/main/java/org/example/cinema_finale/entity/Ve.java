package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(
    name = "Ve",
    uniqueConstraints = {
        @UniqueConstraint(name = "UK_Ve_SuatChieu_Ghe", columnNames = {"MaSuatChieu", "MaGheNgoi"})
    }
)
public class Ve {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaVe")
    private Integer maVe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaSuatChieu", nullable = false)
    private SuatChieu suatChieu;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaGheNgoi", nullable = false)
    private GheNgoi gheNgoi;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaLoaiVe", nullable = false)
    private LoaiVe loaiVe;

    @Column(name = "GiaVe", nullable = false, precision = 18, scale = 2)
    private BigDecimal giaVe;

    @Column(name = "TrangThaiVe", nullable = false, length = 30)
    private String trangThaiVe = "Chưa bán";

    @OneToOne(mappedBy = "ve")
    private ChiTietDonHangVe chiTietDonHangVe;

    public Ve() {
    }

    public Integer getMaVe() {
        return maVe;
    }

    public void setMaVe(Integer maVe) {
        this.maVe = maVe;
    }

    public SuatChieu getSuatChieu() {
        return suatChieu;
    }

    public void setSuatChieu(SuatChieu suatChieu) {
        this.suatChieu = suatChieu;
    }

    public GheNgoi getGheNgoi() {
        return gheNgoi;
    }

    public void setGheNgoi(GheNgoi gheNgoi) {
        this.gheNgoi = gheNgoi;
    }

    public LoaiVe getLoaiVe() {
        return loaiVe;
    }

    public void setLoaiVe(LoaiVe loaiVe) {
        this.loaiVe = loaiVe;
    }

    public BigDecimal getGiaVe() {
        return giaVe;
    }

    public void setGiaVe(BigDecimal giaVe) {
        this.giaVe = giaVe;
    }

    public String getTrangThaiVe() {
        return trangThaiVe;
    }

    public void setTrangThaiVe(String trangThaiVe) {
        this.trangThaiVe = trangThaiVe;
    }

    public ChiTietDonHangVe getChiTietDonHangVe() {
        return chiTietDonHangVe;
    }

    public void setChiTietDonHangVe(ChiTietDonHangVe chiTietDonHangVe) {
        this.chiTietDonHangVe = chiTietDonHangVe;
    }
}
