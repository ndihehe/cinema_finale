package org.example.cinema_finale.dto;

public class PhongChieuDTO {
    private Integer maPhongChieu;
    private String tenPhongChieu;
    private String loaiManHinh;
    private String heThongAmThanh;
    private String trangThaiPhong;

    private int soHang;
    private int soCot;

    public int getSoHang() { return soHang; }
    public void setSoHang(int soHang) { this.soHang = soHang; }

    public int getSoCot() { return soCot; }
    public void setSoCot(int soCot) { this.soCot = soCot; }

    public PhongChieuDTO() {
    }

    public PhongChieuDTO(Integer maPhongChieu, String tenPhongChieu,
                         String loaiManHinh, String heThongAmThanh,
                         String trangThaiPhong) {
        this.maPhongChieu = maPhongChieu;
        this.tenPhongChieu = tenPhongChieu;
        this.loaiManHinh = loaiManHinh;
        this.heThongAmThanh = heThongAmThanh;
        this.trangThaiPhong = trangThaiPhong;
    }

    public Integer getMaPhongChieu() {
        return maPhongChieu;
    }

    public void setMaPhongChieu(Integer maPhongChieu) {
        this.maPhongChieu = maPhongChieu;
    }

    public String getTenPhongChieu() {
        return tenPhongChieu;
    }

    public void setTenPhongChieu(String tenPhongChieu) {
        this.tenPhongChieu = tenPhongChieu;
    }

    public String getLoaiManHinh() {
        return loaiManHinh;
    }

    public void setLoaiManHinh(String loaiManHinh) {
        this.loaiManHinh = loaiManHinh;
    }

    public String getHeThongAmThanh() {
        return heThongAmThanh;
    }

    public void setHeThongAmThanh(String heThongAmThanh) {
        this.heThongAmThanh = heThongAmThanh;
    }

    public String getTrangThaiPhong() {
        return trangThaiPhong;
    }

    public void setTrangThaiPhong(String trangThaiPhong) {
        this.trangThaiPhong = trangThaiPhong;
    }

    @Override
    public String toString() {
        return tenPhongChieu;
    }
}