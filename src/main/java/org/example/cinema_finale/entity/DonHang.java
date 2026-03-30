package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import org.example.cinema_finale.enums.TrangThaiDonHang;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "don_hang")
public class DonHang {

    @Id
    @Column(name = "ma_don_hang", length = 20, nullable = false)
    private String maDonHang;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_kh")
    private KhachHang khachHang;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_nv")
    private NhanVien nhanVien;

    @Column(name = "ma_khuyen_mai", length = 20)
    private String maKhuyenMai;

    @Column(name = "thoi_gian_tao", nullable = false)
    private LocalDateTime thoiGianTao;

    @Column(name = "tong_tien_truoc_giam", precision = 12, scale = 2, nullable = false)
    private BigDecimal tongTienTruocGiam = BigDecimal.ZERO;

    @Column(name = "tien_giam", precision = 12, scale = 2, nullable = false)
    private BigDecimal tienGiam = BigDecimal.ZERO;

    @Column(name = "tong_tien_sau_giam", precision = 12, scale = 2, nullable = false)
    private BigDecimal tongTienSauGiam = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(name = "trang_thai_don_hang", length = 30, nullable = false)
    private TrangThaiDonHang trangThaiDonHang;

    @Column(name = "ghi_chu", length = 255)
    private String ghiChu;

    @OneToMany(mappedBy = "donHang")
    private List<ChiTietDonHangVe> chiTietDonHangVes = new ArrayList<>();

    @OneToMany(mappedBy = "donHang")
    private List<ThanhToan> thanhToans = new ArrayList<>();

    public DonHang() {
    }

    public DonHang(String maDonHang, KhachHang khachHang, NhanVien nhanVien,
                   String maKhuyenMai, LocalDateTime thoiGianTao,
                   BigDecimal tongTienTruocGiam, BigDecimal tienGiam,
                   BigDecimal tongTienSauGiam, TrangThaiDonHang trangThaiDonHang,
                   String ghiChu) {
        this.maDonHang = maDonHang;
        this.khachHang = khachHang;
        this.nhanVien = nhanVien;
        this.maKhuyenMai = maKhuyenMai;
        this.thoiGianTao = thoiGianTao;
        this.tongTienTruocGiam = tongTienTruocGiam;
        this.tienGiam = tienGiam;
        this.tongTienSauGiam = tongTienSauGiam;
        this.trangThaiDonHang = trangThaiDonHang;
        this.ghiChu = ghiChu;
    }

    public String getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(String maDonHang) {
        this.maDonHang = maDonHang;
    }

    public KhachHang getKhachHang() {
        return khachHang;
    }

    public void setKhachHang(KhachHang khachHang) {
        this.khachHang = khachHang;
    }

    public NhanVien getNhanVien() {
        return nhanVien;
    }

    public void setNhanVien(NhanVien nhanVien) {
        this.nhanVien = nhanVien;
    }

    public String getMaKhuyenMai() {
        return maKhuyenMai;
    }

    public void setMaKhuyenMai(String maKhuyenMai) {
        this.maKhuyenMai = maKhuyenMai;
    }

    public LocalDateTime getThoiGianTao() {
        return thoiGianTao;
    }

    public void setThoiGianTao(LocalDateTime thoiGianTao) {
        this.thoiGianTao = thoiGianTao;
    }

    public BigDecimal getTongTienTruocGiam() {
        return tongTienTruocGiam;
    }

    public void setTongTienTruocGiam(BigDecimal tongTienTruocGiam) {
        this.tongTienTruocGiam = tongTienTruocGiam;
    }

    public BigDecimal getTienGiam() {
        return tienGiam;
    }

    public void setTienGiam(BigDecimal tienGiam) {
        this.tienGiam = tienGiam;
    }

    public BigDecimal getTongTienSauGiam() {
        return tongTienSauGiam;
    }

    public void setTongTienSauGiam(BigDecimal tongTienSauGiam) {
        this.tongTienSauGiam = tongTienSauGiam;
    }

    public TrangThaiDonHang getTrangThaiDonHang() {
        return trangThaiDonHang;
    }

    public void setTrangThaiDonHang(TrangThaiDonHang trangThaiDonHang) {
        this.trangThaiDonHang = trangThaiDonHang;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public List<ChiTietDonHangVe> getChiTietDonHangVes() {
        return chiTietDonHangVes;
    }

    public void setChiTietDonHangVes(List<ChiTietDonHangVe> chiTietDonHangVes) {
        this.chiTietDonHangVes = chiTietDonHangVes;
    }

    public List<ThanhToan> getThanhToans() {
        return thanhToans;
    }

    public void setThanhToans(List<ThanhToan> thanhToans) {
        this.thanhToans = thanhToans;
    }

    @Override
    public String toString() {
        return "DonHang{" +
                "maDonHang='" + maDonHang + '\'' +
                ", maKh='" + (khachHang != null ? khachHang.getMaKh() : null) + '\'' +
                ", maNv='" + (nhanVien != null ? nhanVien.getMaNv() : null) + '\'' +
                ", maKhuyenMai='" + maKhuyenMai + '\'' +
                ", thoiGianTao=" + thoiGianTao +
                ", tongTienTruocGiam=" + tongTienTruocGiam +
                ", tienGiam=" + tienGiam +
                ", tongTienSauGiam=" + tongTienSauGiam +
                ", trangThaiDonHang=" + trangThaiDonHang +
                '}';
    }
}