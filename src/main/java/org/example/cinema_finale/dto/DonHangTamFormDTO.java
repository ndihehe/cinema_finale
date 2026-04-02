package org.example.cinema_finale.dto;

public class DonHangTamFormDTO {
    private String ghiChu;

    public DonHangTamFormDTO() {
    }

    public DonHangTamFormDTO(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}