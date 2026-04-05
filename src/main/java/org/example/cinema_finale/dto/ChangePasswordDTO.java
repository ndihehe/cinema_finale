package org.example.cinema_finale.dto;

public class ChangePasswordDTO {
    private Integer maTaiKhoan;
    private String matKhauHienTai;
    private String matKhauMoi;

    public ChangePasswordDTO() {
    }

    public ChangePasswordDTO(Integer maTaiKhoan, String matKhauHienTai, String matKhauMoi) {
        this.maTaiKhoan = maTaiKhoan;
        this.matKhauHienTai = matKhauHienTai;
        this.matKhauMoi = matKhauMoi;
    }

    public Integer getMaTaiKhoan() {
        return maTaiKhoan;
    }

    public void setMaTaiKhoan(Integer maTaiKhoan) {
        this.maTaiKhoan = maTaiKhoan;
    }

    public String getMatKhauHienTai() {
        return matKhauHienTai;
    }

    public void setMatKhauHienTai(String matKhauHienTai) {
        this.matKhauHienTai = matKhauHienTai;
    }

    public String getMatKhauMoi() {
        return matKhauMoi;
    }

    public void setMatKhauMoi(String matKhauMoi) {
        this.matKhauMoi = matKhauMoi;
    }
}