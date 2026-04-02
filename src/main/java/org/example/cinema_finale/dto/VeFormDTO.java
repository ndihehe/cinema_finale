package org.example.cinema_finale.dto;

public class VeFormDTO {
    private Integer maVe;
    private Integer maSuatChieu;
    private Integer maGheNgoi;
    private Integer maLoaiVe;
    private String trangThaiVe;

    public VeFormDTO() {
    }

    public VeFormDTO(Integer maVe, Integer maSuatChieu, Integer maGheNgoi,
                     Integer maLoaiVe, String trangThaiVe) {
        this.maVe = maVe;
        this.maSuatChieu = maSuatChieu;
        this.maGheNgoi = maGheNgoi;
        this.maLoaiVe = maLoaiVe;
        this.trangThaiVe = trangThaiVe;
    }

    public Integer getMaVe() {
        return maVe;
    }

    public void setMaVe(Integer maVe) {
        this.maVe = maVe;
    }

    public Integer getMaSuatChieu() {
        return maSuatChieu;
    }

    public void setMaSuatChieu(Integer maSuatChieu) {
        this.maSuatChieu = maSuatChieu;
    }

    public Integer getMaGheNgoi() {
        return maGheNgoi;
    }

    public void setMaGheNgoi(Integer maGheNgoi) {
        this.maGheNgoi = maGheNgoi;
    }

    public Integer getMaLoaiVe() {
        return maLoaiVe;
    }

    public void setMaLoaiVe(Integer maLoaiVe) {
        this.maLoaiVe = maLoaiVe;
    }

    public String getTrangThaiVe() {
        return trangThaiVe;
    }

    public void setTrangThaiVe(String trangThaiVe) {
        this.trangThaiVe = trangThaiVe;
    }
}