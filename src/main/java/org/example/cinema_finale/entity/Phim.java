package org.example.cinema_finale.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "phim")
public class Phim {

    @Id
    @Column(name = "ma_phim", length = 20, nullable = false)
    private String maPhim;

    @Column(name = "ten_phim", length = 255, nullable = false)
    private String tenPhim;

    @Column(name = "thoi_luong", nullable = false)
    private Integer thoiLuong;

    @Column(name = "nam_san_xuat", nullable = false)
    private Integer namSanXuat;

    @Column(name = "dao_dien", length = 100, nullable = false)
    private String daoDien;

    @OneToMany(mappedBy = "phim")
    private List<SuatChieu> danhSachSuatChieu = new ArrayList<>();

    /**
     * Constructor mặc định bắt buộc cho JPA.
     */
    public Phim() {
    }

    /**
     * Constructor khởi tạo phim không bao gồm danh sách suất chiếu.
     *
     * @param maPhim mã phim
     * @param tenPhim tên phim
     * @param thoiLuong thời lượng phim
     * @param namSanXuat năm sản xuất
     * @param daoDien đạo diễn
     */
    public Phim(String maPhim, String tenPhim, Integer thoiLuong, Integer namSanXuat, String daoDien) {
        this.maPhim = maPhim;
        this.tenPhim = tenPhim;
        this.thoiLuong = thoiLuong;
        this.namSanXuat = namSanXuat;
        this.daoDien = daoDien;
    }

    /**
     * Lấy mã phim.
     *
     * @return mã phim
     */
    public String getMaPhim() {
        return maPhim;
    }

    /**
     * Gán mã phim.
     *
     * @param maPhim mã phim
     */
    public void setMaPhim(String maPhim) {
        this.maPhim = maPhim;
    }

    /**
     * Lấy tên phim.
     *
     * @return tên phim
     */
    public String getTenPhim() {
        return tenPhim;
    }

    /**
     * Gán tên phim.
     *
     * @param tenPhim tên phim
     */
    public void setTenPhim(String tenPhim) {
        this.tenPhim = tenPhim;
    }

    /**
     * Lấy thời lượng phim.
     *
     * @return thời lượng phim
     */
    public Integer getThoiLuong() {
        return thoiLuong;
    }

    /**
     * Gán thời lượng phim.
     *
     * @param thoiLuong thời lượng phim
     */
    public void setThoiLuong(Integer thoiLuong) {
        this.thoiLuong = thoiLuong;
    }

    /**
     * Lấy năm sản xuất của phim.
     *
     * @return năm sản xuất
     */
    public Integer getNamSanXuat() {
        return namSanXuat;
    }

    /**
     * Gán năm sản xuất của phim.
     *
     * @param namSanXuat năm sản xuất
     */
    public void setNamSanXuat(Integer namSanXuat) {
        this.namSanXuat = namSanXuat;
    }

    /**
     * Lấy tên đạo diễn.
     *
     * @return đạo diễn
     */
    public String getDaoDien() {
        return daoDien;
    }

    /**
     * Gán tên đạo diễn.
     *
     * @param daoDien đạo diễn
     */
    public void setDaoDien(String daoDien) {
        this.daoDien = daoDien;
    }

    /**
     * Lấy danh sách suất chiếu của phim.
     *
     * @return danh sách suất chiếu
     */
    public List<SuatChieu> getDanhSachSuatChieu() {
        return danhSachSuatChieu;
    }

    /**
     * Gán danh sách suất chiếu của phim.
     *
     * @param danhSachSuatChieu danh sách suất chiếu
     */
    public void setDanhSachSuatChieu(List<SuatChieu> danhSachSuatChieu) {
        this.danhSachSuatChieu = danhSachSuatChieu;
    }

    /**
     * Trả về chuỗi mô tả thông tin phim.
     *
     * @return thông tin phim dưới dạng chuỗi
     */
    @Override
    public String toString() {
        return "Phim{" +
                "maPhim='" + maPhim + '\'' +
                ", tenPhim='" + tenPhim + '\'' +
                ", thoiLuong=" + thoiLuong +
                ", namSanXuat=" + namSanXuat +
                ", daoDien='" + daoDien + '\'' +
                '}';
    }
}