package org.example.cinema_finale.dto;

import java.time.LocalDateTime;

public class TaiKhoanDTO {
    private Integer maTaiKhoan;
    private String tenDangNhap;
    private String loaiTaiKhoan;
    private String trangThaiTaiKhoan;
    private LocalDateTime ngayTao;
    private String tenNguoiSohuu; // Chứa tên Nhân Viên hoặc Khách Hàng

    public TaiKhoanDTO() {
    }

    public TaiKhoanDTO(Integer maTaiKhoan, String tenDangNhap, String loaiTaiKhoan,
                       String trangThaiTaiKhoan, LocalDateTime ngayTao, String tenNguoiSohuu) {
        this.maTaiKhoan = maTaiKhoan;
        this.tenDangNhap = tenDangNhap;
        this.loaiTaiKhoan = loaiTaiKhoan;
        this.trangThaiTaiKhoan = trangThaiTaiKhoan;
        this.ngayTao = ngayTao;
        this.tenNguoiSohuu = tenNguoiSohuu;
    }

    public Integer getMaTaiKhoan() { return maTaiKhoan; }
    public void setMaTaiKhoan(Integer maTaiKhoan) { this.maTaiKhoan = maTaiKhoan; }

    public String getTenDangNhap() { return tenDangNhap; }
    public void setTenDangNhap(String tenDangNhap) { this.tenDangNhap = tenDangNhap; }

    public String getLoaiTaiKhoan() { return loaiTaiKhoan; }
    public void setLoaiTaiKhoan(String loaiTaiKhoan) { this.loaiTaiKhoan = loaiTaiKhoan; }

    public String getTrangThaiTaiKhoan() { return trangThaiTaiKhoan; }
    public void setTrangThaiTaiKhoan(String trangThaiTaiKhoan) { this.trangThaiTaiKhoan = trangThaiTaiKhoan; }

    public LocalDateTime getNgayTao() { return ngayTao; }
    public void setNgayTao(LocalDateTime ngayTao) { this.ngayTao = ngayTao; }

    public String getTenNguoiSohuu() { return tenNguoiSohuu; }
    public void setTenNguoiSohuu(String tenNguoiSohuu) { this.tenNguoiSohuu = tenNguoiSohuu; }
}