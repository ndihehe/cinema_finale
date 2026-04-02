package org.example.cinema_finale.dto;

import java.math.BigDecimal;

public class LoaiVeDTO {
    private Integer maLoaiVe;
    private String tenLoaiVe;
    private String moTa;
    private BigDecimal phuThuGia;

    public LoaiVeDTO() {
    }

    public LoaiVeDTO(Integer maLoaiVe, String tenLoaiVe, String moTa, BigDecimal phuThuGia) {
        this.maLoaiVe = maLoaiVe;
        this.tenLoaiVe = tenLoaiVe;
        this.moTa = moTa;
        this.phuThuGia = phuThuGia;
    }

    public Integer getMaLoaiVe() { return maLoaiVe; }
    public void setMaLoaiVe(Integer maLoaiVe) { this.maLoaiVe = maLoaiVe; }

    public String getTenLoaiVe() { return tenLoaiVe; }
    public void setTenLoaiVe(String tenLoaiVe) { this.tenLoaiVe = tenLoaiVe; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public BigDecimal getPhuThuGia() { return phuThuGia; }
    public void setPhuThuGia(BigDecimal phuThuGia) { this.phuThuGia = phuThuGia; }

    @Override
    public String toString() {
        return tenLoaiVe; // Rất quan trọng để hiển thị trực tiếp lên JComboBox
    }
}