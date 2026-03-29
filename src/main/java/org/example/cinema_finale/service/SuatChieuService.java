package org.example.cinema_finale.service;

import org.example.cinema_finale.util.AuthorizationUtil;
import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.dao.SuatChieuDao;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.entity.SuatChieu;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class SuatChieuService {

    private final SuatChieuDao suatChieuDao;
    private final PhimDao phimDao;

    /**
     * Khởi tạo service với DAO mặc định.
     */
    public SuatChieuService() {
        this.suatChieuDao = new SuatChieuDao();
        this.phimDao = new PhimDao();
    }

    /**
     * Khởi tạo service với DAO truyền vào.
     *
     * @param suatChieuDao DAO suất chiếu
     * @param phimDao DAO phim
     */
    public SuatChieuService(SuatChieuDao suatChieuDao, PhimDao phimDao) {
        this.suatChieuDao = suatChieuDao;
        this.phimDao = phimDao;
    }

    /**
     * Lấy toàn bộ danh sách suất chiếu.
     *
     * @return danh sách suất chiếu
     */
    public List<SuatChieu> getAllSuatChieu() {
        return suatChieuDao.findAll();
    }

    /**
     * Tìm suất chiếu theo mã.
     *
     * @param maSuat mã suất chiếu
     * @return đối tượng suất chiếu nếu tìm thấy, ngược lại trả về null
     */
    public SuatChieu getSuatChieuById(String maSuat) {
        if (maSuat == null || maSuat.trim().isEmpty()) {
            return null;
        }
        return suatChieuDao.findById(maSuat.trim());
    }

    /**
     * Tìm danh sách suất chiếu theo mã phim.
     *
     * @param maPhim mã phim
     * @return danh sách suất chiếu
     */
    public List<SuatChieu> getByMaPhim(String maPhim) {
        if (maPhim == null || maPhim.trim().isEmpty()) {
            return List.of();
        }
        return suatChieuDao.findByMaPhim(maPhim.trim());
    }

    /**
     * Tìm danh sách suất chiếu theo ngày chiếu.
     *
     * @param ngayChieu ngày chiếu
     * @return danh sách suất chiếu
     */
    public List<SuatChieu> getByNgayChieu(LocalDate ngayChieu) {
        if (ngayChieu == null) {
            return List.of();
        }
        return suatChieuDao.findByNgayChieu(ngayChieu);
    }

    /**
     * Thêm mới suất chiếu sau khi kiểm tra dữ liệu hợp lệ.
     *
     * @param suatChieu đối tượng suất chiếu cần thêm
     * @return thông báo kết quả xử lý
     */
    public String addSuatChieu(SuatChieu suatChieu) {
        AuthorizationUtil.requireStaff();

        String validationMessage = validateSuatChieu(suatChieu, true);
        if (validationMessage != null) {
            return validationMessage;
        }

        boolean result = suatChieuDao.save(suatChieu);
        return result ? "Thêm suất chiếu thành công." : "Thêm suất chiếu thất bại.";
    }

    /**
     * Cập nhật suất chiếu sau khi kiểm tra dữ liệu hợp lệ.
     *
     * @param suatChieu đối tượng suất chiếu cần cập nhật
     * @return thông báo kết quả xử lý
     */
    public String updateSuatChieu(SuatChieu suatChieu) {
        AuthorizationUtil.requireStaff();

        String validationMessage = validateSuatChieu(suatChieu, false);
        if (validationMessage != null) {
            return validationMessage;
        }

        boolean result = suatChieuDao.update(suatChieu);
        return result ? "Cập nhật suất chiếu thành công." : "Cập nhật suất chiếu thất bại.";
    }

    /**
     * Xóa suất chiếu theo mã suất.
     *
     * @param maSuat mã suất chiếu cần xóa
     * @return thông báo kết quả xử lý
     */
    public String deleteSuatChieu(String maSuat) {
        AuthorizationUtil.requireStaff();

        if (maSuat == null || maSuat.trim().isEmpty()) {
            return "Mã suất chiếu không được để trống.";
        }

        SuatChieu suatChieu = suatChieuDao.findById(maSuat.trim());
        if (suatChieu == null) {
            return "Suất chiếu không tồn tại.";
        }

        boolean result = suatChieuDao.delete(maSuat.trim());
        return result ? "Xóa suất chiếu thành công." : "Xóa suất chiếu thất bại.";
    }

    /**
     * Kiểm tra dữ liệu suất chiếu có hợp lệ hay không.
     *
     * @param suatChieu đối tượng suất chiếu cần kiểm tra
     * @param isCreate true nếu là thêm mới, false nếu là cập nhật
     * @return null nếu hợp lệ, ngược lại trả về thông báo lỗi
     */
    private String validateSuatChieu(SuatChieu suatChieu, boolean isCreate) {
        if (suatChieu == null) {
            return "Dữ liệu suất chiếu không hợp lệ.";
        }

        if (suatChieu.getMaSuat() == null || suatChieu.getMaSuat().trim().isEmpty()) {
            return "Mã suất chiếu không được để trống.";
        }

        if (suatChieu.getNgayChieu() == null) {
            return "Ngày chiếu không được để trống.";
        }

        if (suatChieu.getGioBatDau() == null) {
            return "Giờ bắt đầu không được để trống.";
        }

        if (suatChieu.getGioKetThuc() == null) {
            return "Giờ kết thúc không được để trống.";
        }

        if (!suatChieu.getGioKetThuc().isAfter(suatChieu.getGioBatDau())) {
            return "Giờ kết thúc phải lớn hơn giờ bắt đầu.";
        }

        if (suatChieu.getGiaVe() == null) {
            return "Giá vé không được để trống.";
        }

        if (suatChieu.getGiaVe().compareTo(BigDecimal.ZERO) <= 0) {
            return "Giá vé phải lớn hơn 0.";
        }

        if (suatChieu.getPhim() == null || suatChieu.getPhim().getMaPhim() == null
                || suatChieu.getPhim().getMaPhim().trim().isEmpty()) {
            return "Phim của suất chiếu không hợp lệ.";
        }

        Phim phim = phimDao.findById(suatChieu.getPhim().getMaPhim().trim());
        if (phim == null) {
            return "Phim không tồn tại.";
        }

        suatChieu.setPhim(phim);
        suatChieu.setMaSuat(suatChieu.getMaSuat().trim());

        if (isCreate && suatChieuDao.existsById(suatChieu.getMaSuat())) {
            return "Mã suất chiếu đã tồn tại.";
        }

        if (!isCreate && suatChieuDao.findById(suatChieu.getMaSuat()) == null) {
            return "Suất chiếu không tồn tại để cập nhật.";
        }

        return null;
    }
}