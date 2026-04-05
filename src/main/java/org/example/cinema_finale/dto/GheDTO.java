package org.example.cinema_finale.dto;

public class GheDTO {
    private Integer maGheNgoi;
    private Integer maPhongChieu;
    private String tenPhongChieu;
    private String hangGhe;
    private Integer soGhe;
    private Integer maLoaiGheNgoi;
    private String tenLoaiGheNgoi;
    private String trangThaiGhe;

    public GheDTO() {
    }

    public GheDTO(Integer maGheNgoi, Integer maPhongChieu, String tenPhongChieu,
                  String hangGhe, Integer soGhe,
                  Integer maLoaiGheNgoi, String tenLoaiGheNgoi,
                  String trangThaiGhe) {
        this.maGheNgoi = maGheNgoi;
        this.maPhongChieu = maPhongChieu;
        this.tenPhongChieu = tenPhongChieu;
        this.hangGhe = hangGhe;
        this.soGhe = soGhe;
        this.maLoaiGheNgoi = maLoaiGheNgoi;
        this.tenLoaiGheNgoi = tenLoaiGheNgoi;
        this.trangThaiGhe = trangThaiGhe;
    }

    public Integer getMaGheNgoi() { return maGheNgoi; }
    public void setMaGheNgoi(Integer maGheNgoi) { this.maGheNgoi = maGheNgoi; }

    public Integer getMaPhongChieu() { return maPhongChieu; }
    public void setMaPhongChieu(Integer maPhongChieu) { this.maPhongChieu = maPhongChieu; }

    public String getTenPhongChieu() { return tenPhongChieu; }
    public void setTenPhongChieu(String tenPhongChieu) { this.tenPhongChieu = tenPhongChieu; }

    public String getHangGhe() { return hangGhe; }
    public void setHangGhe(String hangGhe) { this.hangGhe = hangGhe; }

    public Integer getSoGhe() { return soGhe; }
    public void setSoGhe(Integer soGhe) { this.soGhe = soGhe; }

    public Integer getMaLoaiGheNgoi() { return maLoaiGheNgoi; }
    public void setMaLoaiGheNgoi(Integer maLoaiGheNgoi) { this.maLoaiGheNgoi = maLoaiGheNgoi; }

    public String getTenLoaiGheNgoi() { return tenLoaiGheNgoi; }
    public void setTenLoaiGheNgoi(String tenLoaiGheNgoi) { this.tenLoaiGheNgoi = tenLoaiGheNgoi; }

    public String getTrangThaiGhe() { return trangThaiGhe; }
    public void setTrangThaiGhe(String trangThaiGhe) { this.trangThaiGhe = trangThaiGhe; }

    public String getViTriGhe() {
        return (hangGhe != null ? hangGhe : "") + (soGhe != null ? soGhe : "");
    }
}