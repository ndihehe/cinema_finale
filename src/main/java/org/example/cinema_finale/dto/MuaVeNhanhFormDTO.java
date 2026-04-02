package org.example.cinema_finale.dto;

import java.util.List;

public class MuaVeNhanhFormDTO {
    private List<Integer> dsMaVe;
    private String phuongThucThanhToan;
    private String ghiChu;

    public MuaVeNhanhFormDTO() {
    }

    public MuaVeNhanhFormDTO(List<Integer> dsMaVe, String phuongThucThanhToan, String ghiChu) {
        this.dsMaVe = dsMaVe;
        this.phuongThucThanhToan = phuongThucThanhToan;
        this.ghiChu = ghiChu;
    }

    public List<Integer> getDsMaVe() {
        return dsMaVe;
    }

    public void setDsMaVe(List<Integer> dsMaVe) {
        this.dsMaVe = dsMaVe;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}