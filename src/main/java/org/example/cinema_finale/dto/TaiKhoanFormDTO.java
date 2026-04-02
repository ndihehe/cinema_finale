package org.example.cinema_finale.dto;

public class TaiKhoanFormDTO {
    private Integer maTaiKhoan;
    private String tenDangNhap;
    private String matKhau;
    private String loaiTaiKhoan;
    private String trangThaiTaiKhoan;
    private Integer maNhanVien;
    private Integer maKhachHang;

    public TaiKhoanFormDTO() {
    }

    public TaiKhoanFormDTO(Integer maTaiKhoan, String tenDangNhap, String matKhau,
                           String loaiTaiKhoan, String trangThaiTaiKhoan,
                           Integer maNhanVien, Integer maKhachHang) {
        this.maTaiKhoan = maTaiKhoan;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.loaiTaiKhoan = loaiTaiKhoan;
        this.trangThaiTaiKhoan = trangThaiTaiKhoan;
        this.maNhanVien = maNhanVien;
        this.maKhachHang = maKhachHang;
    }

    public Integer getMaTaiKhoan() {
        return maTaiKhoan;
    }

    public void setMaTaiKhoan(Integer maTaiKhoan) {
        this.maTaiKhoan = maTaiKhoan;
    }

    public String getTenDangNhap() {
        return tenDangNhap;
    }

    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getLoaiTaiKhoan() {
        return loaiTaiKhoan;
    }

    public void setLoaiTaiKhoan(String loaiTaiKhoan) {
        this.loaiTaiKhoan = loaiTaiKhoan;
    }

    public String getTrangThaiTaiKhoan() {
        return trangThaiTaiKhoan;
    }

    public void setTrangThaiTaiKhoan(String trangThaiTaiKhoan) {
        this.trangThaiTaiKhoan = trangThaiTaiKhoan;
    }

    public Integer getMaNhanVien() {
        return maNhanVien;
    }

    public void setMaNhanVien(Integer maNhanVien) {
        this.maNhanVien = maNhanVien;
    }

    public Integer getMaKhachHang() {
        return maKhachHang;
    }

    public void setMaKhachHang(Integer maKhachHang) {
        this.maKhachHang = maKhachHang;
    }
}