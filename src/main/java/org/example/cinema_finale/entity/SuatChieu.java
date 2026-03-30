package org.example.cinema_finale.entity;

import jakarta.persistence.*;
import org.example.cinema_finale.enums.TrangThaiSuatChieu;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "suat_chieu")
public class SuatChieu {

    @Id
    @Column(name = "ma_suat_chieu", length = 20, nullable = false)
    private String maSuatChieu;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_phim", nullable = false)
    private Phim phim;

    @Column(name = "ma_phong_chieu", length = 20, nullable = false)
    private String maPhongChieu;

    @Column(name = "ngay_gio_chieu", nullable = false)
    private LocalDateTime ngayGioChieu;

    @Column(name = "gia_ve_co_ban", precision = 12, scale = 2, nullable = false)
    private BigDecimal giaVeCoBan;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai_suat_chieu", length = 30, nullable = false)
    private TrangThaiSuatChieu trangThaiSuatChieu;

    public SuatChieu() {
    }

    public SuatChieu(String maSuatChieu, Phim phim, String maPhongChieu,
                     LocalDateTime ngayGioChieu, BigDecimal giaVeCoBan,
                     TrangThaiSuatChieu trangThaiSuatChieu) {
        this.maSuatChieu = maSuatChieu;
        this.phim = phim;
        this.maPhongChieu = maPhongChieu;
        this.ngayGioChieu = ngayGioChieu;
        this.giaVeCoBan = giaVeCoBan;
        this.trangThaiSuatChieu = trangThaiSuatChieu;
    }

    public String getMaSuatChieu() { return maSuatChieu; }
    public void setMaSuatChieu(String maSuatChieu) { this.maSuatChieu = maSuatChieu; }

    public Phim getPhim() { return phim; }
    public void setPhim(Phim phim) { this.phim = phim; }

    public String getMaPhongChieu() { return maPhongChieu; }
    public void setMaPhongChieu(String maPhongChieu) { this.maPhongChieu = maPhongChieu; }

    public LocalDateTime getNgayGioChieu() { return ngayGioChieu; }
    public void setNgayGioChieu(LocalDateTime ngayGioChieu) { this.ngayGioChieu = ngayGioChieu; }

    public BigDecimal getGiaVeCoBan() { return giaVeCoBan; }
    public void setGiaVeCoBan(BigDecimal giaVeCoBan) { this.giaVeCoBan = giaVeCoBan; }

    public TrangThaiSuatChieu getTrangThaiSuatChieu() { return trangThaiSuatChieu; }
    public void setTrangThaiSuatChieu(TrangThaiSuatChieu trangThaiSuatChieu) { this.trangThaiSuatChieu = trangThaiSuatChieu; }
}