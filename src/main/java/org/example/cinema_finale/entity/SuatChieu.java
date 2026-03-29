package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "suat_chieu")
public class SuatChieu {

    @Id
    @Column(name = "ma_suat", length = 20, nullable = false)
    private String maSuat;

    @Column(name = "ngay_chieu", nullable = false)
    private LocalDate ngayChieu;

    @Column(name = "gio_bat_dau", nullable = false)
    private LocalTime gioBatDau;

    @Column(name = "gio_ket_thuc", nullable = false)
    private LocalTime gioKetThuc;

    @Column(name = "gia_ve", precision = 12, scale = 2, nullable = false)
    private BigDecimal giaVe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_phim", nullable = false)
    private Phim phim;

    /**
     * Constructor mặc định bắt buộc cho JPA.
     */
    public SuatChieu() {
    }

    /**
     * Constructor khởi tạo suất chiếu.
     *
     * @param maSuat mã suất chiếu
     * @param ngayChieu ngày chiếu
     * @param gioBatDau giờ bắt đầu
     * @param gioKetThuc giờ kết thúc
     * @param giaVe giá vé
     * @param phim phim của suất chiếu
     */
    public SuatChieu(String maSuat, LocalDate ngayChieu, LocalTime gioBatDau,
                     LocalTime gioKetThuc, BigDecimal giaVe, Phim phim) {
        this.maSuat = maSuat;
        this.ngayChieu = ngayChieu;
        this.gioBatDau = gioBatDau;
        this.gioKetThuc = gioKetThuc;
        this.giaVe = giaVe;
        this.phim = phim;
    }

    /**
     * Lấy mã suất chiếu.
     *
     * @return mã suất chiếu
     */
    public String getMaSuat() {
        return maSuat;
    }

    /**
     * Gán mã suất chiếu.
     *
     * @param maSuat mã suất chiếu
     */
    public void setMaSuat(String maSuat) {
        this.maSuat = maSuat;
    }

    /**
     * Lấy ngày chiếu.
     *
     * @return ngày chiếu
     */
    public LocalDate getNgayChieu() {
        return ngayChieu;
    }

    /**
     * Gán ngày chiếu.
     *
     * @param ngayChieu ngày chiếu
     */
    public void setNgayChieu(LocalDate ngayChieu) {
        this.ngayChieu = ngayChieu;
    }

    /**
     * Lấy giờ bắt đầu suất chiếu.
     *
     * @return giờ bắt đầu
     */
    public LocalTime getGioBatDau() {
        return gioBatDau;
    }

    /**
     * Gán giờ bắt đầu suất chiếu.
     *
     * @param gioBatDau giờ bắt đầu
     */
    public void setGioBatDau(LocalTime gioBatDau) {
        this.gioBatDau = gioBatDau;
    }

    /**
     * Lấy giờ kết thúc suất chiếu.
     *
     * @return giờ kết thúc
     */
    public LocalTime getGioKetThuc() {
        return gioKetThuc;
    }

    /**
     * Gán giờ kết thúc suất chiếu.
     *
     * @param gioKetThuc giờ kết thúc
     */
    public void setGioKetThuc(LocalTime gioKetThuc) {
        this.gioKetThuc = gioKetThuc;
    }

    /**
     * Lấy giá vé của suất chiếu.
     *
     * @return giá vé
     */
    public BigDecimal getGiaVe() {
        return giaVe;
    }

    /**
     * Gán giá vé của suất chiếu.
     *
     * @param giaVe giá vé
     */
    public void setGiaVe(BigDecimal giaVe) {
        this.giaVe = giaVe;
    }

    /**
     * Lấy phim của suất chiếu.
     *
     * @return phim
     */
    public Phim getPhim() {
        return phim;
    }

    /**
     * Gán phim cho suất chiếu.
     *
     * @param phim phim
     */
    public void setPhim(Phim phim) {
        this.phim = phim;
    }

    /**
     * Trả về chuỗi mô tả thông tin suất chiếu.
     *
     * @return thông tin suất chiếu dưới dạng chuỗi
     */
    @Override
    public String toString() {
        return "SuatChieu{" +
                "maSuat='" + maSuat + '\'' +
                ", ngayChieu=" + ngayChieu +
                ", gioBatDau=" + gioBatDau +
                ", gioKetThuc=" + gioKetThuc +
                ", giaVe=" + giaVe +
                ", maPhim='" + (phim != null ? phim.getMaPhim() : null) + '\'' +
                '}';
    }
}