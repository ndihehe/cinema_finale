package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import org.example.cinema_finale.enums.TrangThaiVe;

import java.math.BigDecimal;

@Entity
@Table(name = "ve")
public class Ve {

    @Id
    @Column(name = "ma_ve", length = 20, nullable = false)
    private String maVe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_suat_chieu", nullable = false)
    private SuatChieu suatChieu;

    @Column(name = "ma_ghe_ngoi", length = 20, nullable = false)
    private String maGheNgoi;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_loai_ve", nullable = false)
    private LoaiVe loaiVe;

    @Column(name = "gia_ve", precision = 12, scale = 2, nullable = false)
    private BigDecimal giaVe;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai_ve", length = 30, nullable = false)
    private TrangThaiVe trangThaiVe;

    public Ve() {
    }

    public Ve(String maVe, SuatChieu suatChieu, String maGheNgoi,
              LoaiVe loaiVe, BigDecimal giaVe, TrangThaiVe trangThaiVe) {
        this.maVe = maVe;
        this.suatChieu = suatChieu;
        this.maGheNgoi = maGheNgoi;
        this.loaiVe = loaiVe;
        this.giaVe = giaVe;
        this.trangThaiVe = trangThaiVe;
    }

    public String getMaVe() {
        return maVe;
    }

    public void setMaVe(String maVe) {
        this.maVe = maVe;
    }

    public SuatChieu getSuatChieu() {
        return suatChieu;
    }

    public void setSuatChieu(SuatChieu suatChieu) {
        this.suatChieu = suatChieu;
    }

    public String getMaGheNgoi() {
        return maGheNgoi;
    }

    public void setMaGheNgoi(String maGheNgoi) {
        this.maGheNgoi = maGheNgoi;
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

    public TrangThaiVe getTrangThaiVe() {
        return trangThaiVe;
    }

    public void setTrangThaiVe(TrangThaiVe trangThaiVe) {
        this.trangThaiVe = trangThaiVe;
    }

    @Override
    public String toString() {
        return "Ve{" +
                "maVe='" + maVe + '\'' +
                ", maSuatChieu='" + (suatChieu != null ? suatChieu.getMaSuatChieu() : null) + '\'' +
                ", maGheNgoi='" + maGheNgoi + '\'' +
                ", maLoaiVe='" + (loaiVe != null ? loaiVe.getMaLoaiVe() : null) + '\'' +
                ", giaVe=" + giaVe +
                ", trangThaiVe=" + trangThaiVe +
                '}';
    }
}