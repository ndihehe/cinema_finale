package org.example.cinema_finale.dto;

import java.math.BigDecimal;

public class ThongKeDoanhSoDTO {

    private String nhanThongKe;
    private Integer soLuongVeBan;
    private BigDecimal tongDoanhThu;
    private BigDecimal tongGiamGia;
    private BigDecimal doanhThuThuan;

    public ThongKeDoanhSoDTO(String nhan, int soVe, BigDecimal doanhThu, BigDecimal giamGia, BigDecimal thuan){
        this.nhanThongKe = nhan;
        this.soLuongVeBan = soVe;
        this.tongDoanhThu = doanhThu;
        this.tongGiamGia = giamGia;
        this.doanhThuThuan = thuan;
    }

    public String getNhanThongKe() { return nhanThongKe; }
    public void setNhanThongKe(String nhanThongKe) { this.nhanThongKe = nhanThongKe; }

    public Integer getSoLuongVeBan() { return soLuongVeBan; }
    public void setSoLuongVeBan(Integer soLuongVeBan) { this.soLuongVeBan = soLuongVeBan; }

    public BigDecimal getTongDoanhThu() { return tongDoanhThu; }
    public void setTongDoanhThu(BigDecimal tongDoanhThu) { this.tongDoanhThu = tongDoanhThu; }

    public BigDecimal getTongGiamGia() { return tongGiamGia; }
    public void setTongGiamGia(BigDecimal tongGiamGia) { this.tongGiamGia = tongGiamGia; }

    public BigDecimal getDoanhThuThuan() { return doanhThuThuan; }
    public void setDoanhThuThuan(BigDecimal doanhThuThuan) { this.doanhThuThuan = doanhThuThuan; }
}