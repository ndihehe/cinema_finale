package org.example.cinema_finale.dto;

import java.util.List;

public class DatVeRequestDTO {
    private Integer maSuatChieu;
    private List<Integer> danhSachMaGhe; // Danh sách các ID ghế mà khách chọn
    private Integer maKhuyenMai;         // Có thể null nếu khách không có mã
    private String phuongThucThanhToan;  // VD: "Tiền mặt", "Chuyển khoản", "MoMo"

    public DatVeRequestDTO() {
    }

    public DatVeRequestDTO(Integer maSuatChieu, List<Integer> danhSachMaGhe, Integer maKhuyenMai, String phuongThucThanhToan) {
        this.maSuatChieu = maSuatChieu;
        this.danhSachMaGhe = danhSachMaGhe;
        this.maKhuyenMai = maKhuyenMai;
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public Integer getMaSuatChieu() {
        return maSuatChieu;
    }

    public void setMaSuatChieu(Integer maSuatChieu) {
        this.maSuatChieu = maSuatChieu;
    }

    public List<Integer> getDanhSachMaGhe() {
        return danhSachMaGhe;
    }

    public void setDanhSachMaGhe(List<Integer> danhSachMaGhe) {
        this.danhSachMaGhe = danhSachMaGhe;
    }

    public Integer getMaKhuyenMai() {
        return maKhuyenMai;
    }

    public void setMaKhuyenMai(Integer maKhuyenMai) {
        this.maKhuyenMai = maKhuyenMai;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }
}