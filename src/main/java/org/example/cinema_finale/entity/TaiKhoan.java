package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "tai_khoan")
public class TaiKhoan {

    @Id
    @Column(name = "ma_tk", length = 20, nullable = false)
    private String maTk;

    @Column(name = "ten_dang_nhap", length = 50, nullable = false, unique = true)
    private String tenDangNhap;

    @Column(name = "mat_khau", length = 100, nullable = false)
    private String matKhau;

    @Enumerated(EnumType.STRING)
    @Column(name = "vai_tro", length = 20, nullable = false)
    private VaiTro vaiTro;

    @Column(name = "trang_thai", nullable = false)
    private Boolean trangThai;

    @OneToOne
    @JoinColumn(name = "ma_nv", unique = true)
    private NhanVien nhanVien;

    @OneToOne
    @JoinColumn(name = "ma_kh", unique = true)
    private KhachHang khachHang;

    /**
     * Constructor mặc định bắt buộc cho JPA.
     */
    public TaiKhoan() {
    }

    /**
     * Constructor khởi tạo thông tin tài khoản.
     *
     * @param maTk mã tài khoản
     * @param tenDangNhap tên đăng nhập
     * @param matKhau mật khẩu
     * @param vaiTro vai trò tài khoản
     * @param trangThai trạng thái tài khoản
     * @param nhanVien nhân viên liên kết nếu là staff
     * @param khachHang khách hàng liên kết nếu là user
     */
    public TaiKhoan(String maTk, String tenDangNhap, String matKhau, VaiTro vaiTro,
                    Boolean trangThai, NhanVien nhanVien, KhachHang khachHang) {
        this.maTk = maTk;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.vaiTro = vaiTro;
        this.trangThai = trangThai;
        this.nhanVien = nhanVien;
        this.khachHang = khachHang;
    }

    /**
     * Lấy mã tài khoản.
     *
     * @return mã tài khoản
     */
    public String getMaTk() {
        return maTk;
    }

    /**
     * Gán mã tài khoản.
     *
     * @param maTk mã tài khoản
     */
    public void setMaTk(String maTk) {
        this.maTk = maTk;
    }

    /**
     * Lấy tên đăng nhập.
     *
     * @return tên đăng nhập
     */
    public String getTenDangNhap() {
        return tenDangNhap;
    }

    /**
     * Gán tên đăng nhập.
     *
     * @param tenDangNhap tên đăng nhập
     */
    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    /**
     * Lấy mật khẩu.
     *
     * @return mật khẩu
     */
    public String getMatKhau() {
        return matKhau;
    }

    /**
     * Gán mật khẩu.
     *
     * @param matKhau mật khẩu
     */
    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    /**
     * Lấy vai trò tài khoản.
     *
     * @return vai trò tài khoản
     */
    public VaiTro getVaiTro() {
        return vaiTro;
    }

    /**
     * Gán vai trò tài khoản.
     *
     * @param vaiTro vai trò tài khoản
     */
    public void setVaiTro(VaiTro vaiTro) {
        this.vaiTro = vaiTro;
    }

    /**
     * Lấy trạng thái tài khoản.
     *
     * @return true nếu hoạt động, false nếu bị khóa
     */
    public Boolean getTrangThai() {
        return trangThai;
    }

    /**
     * Gán trạng thái tài khoản.
     *
     * @param trangThai trạng thái tài khoản
     */
    public void setTrangThai(Boolean trangThai) {
        this.trangThai = trangThai;
    }

    /**
     * Lấy nhân viên liên kết với tài khoản.
     *
     * @return nhân viên
     */
    public NhanVien getNhanVien() {
        return nhanVien;
    }

    /**
     * Gán nhân viên cho tài khoản.
     *
     * @param nhanVien nhân viên
     */
    public void setNhanVien(NhanVien nhanVien) {
        this.nhanVien = nhanVien;
    }

    /**
     * Lấy khách hàng liên kết với tài khoản.
     *
     * @return khách hàng
     */
    public KhachHang getKhachHang() {
        return khachHang;
    }

    /**
     * Gán khách hàng cho tài khoản.
     *
     * @param khachHang khách hàng
     */
    public void setKhachHang(KhachHang khachHang) {
        this.khachHang = khachHang;
    }

    /**
     * Trả về chuỗi mô tả thông tin tài khoản.
     *
     * @return thông tin tài khoản dưới dạng chuỗi
     */
    @Override
    public String toString() {
        return "TaiKhoan{" +
                "maTk='" + maTk + '\'' +
                ", tenDangNhap='" + tenDangNhap + '\'' +
                ", vaiTro=" + vaiTro +
                ", trangThai=" + trangThai +
                ", maNv='" + (nhanVien != null ? nhanVien.getMaNv() : null) + '\'' +
                ", maKh='" + (khachHang != null ? khachHang.getMaKh() : null) + '\'' +
                '}';
    }
}