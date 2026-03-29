
package org.example.cinema_finale.service;

import org.example.cinema_finale.util.AuthorizationUtil;
import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.entity.Phim;

import java.time.Year;
import java.util.List;

public class PhimService {

    private final PhimDao phimDao;

    /**
     * Khởi tạo service với PhimDao mặc định.
     */
    public PhimService() {
        this.phimDao = new PhimDao();
    }

    /**
     * Khởi tạo service với PhimDao truyền vào.
     *
     * @param phimDao đối tượng PhimDao
     */
    public PhimService(PhimDao phimDao) {
        this.phimDao = phimDao;
    }

    /**
     * Lấy toàn bộ danh sách phim.
     *
     * @return danh sách phim
     */
    public List<Phim> getAllPhim() {
        return phimDao.findAll();
    }

    /**
     * Tìm phim theo mã.
     *
     * @param maPhim mã phim
     * @return đối tượng phim nếu tìm thấy, ngược lại trả về null
     */
    public Phim getPhimById(String maPhim) {
        if (maPhim == null || maPhim.trim().isEmpty()) {
            return null;
        }
        return phimDao.findById(maPhim.trim());
    }

    /**
     * Tìm danh sách phim theo tên gần đúng.
     *
     * @param tuKhoa từ khóa tìm kiếm
     * @return danh sách phim phù hợp
     */
    public List<Phim> searchByTenPhim(String tuKhoa) {
        if (tuKhoa == null) {
            tuKhoa = "";
        }
        return phimDao.findByTenPhim(tuKhoa.trim());
    }

    /**
     * Thêm mới phim sau khi kiểm tra dữ liệu hợp lệ.
     *
     * @param phim đối tượng phim cần thêm
     * @return thông báo kết quả xử lý
     */
    public String addPhim(Phim phim) {
        AuthorizationUtil.requireStaff();

        String validationMessage = validatePhim(phim, true);
        if (validationMessage != null) {
            return validationMessage;
        }

        boolean result = phimDao.save(phim);
        return result ? "Thêm phim thành công." : "Thêm phim thất bại.";
    }

    /**
     * Cập nhật phim sau khi kiểm tra dữ liệu hợp lệ.
     *
     * @param phim đối tượng phim cần cập nhật
     * @return thông báo kết quả xử lý
     */
    public String updatePhim(Phim phim) {
        AuthorizationUtil.requireStaff();

        String validationMessage = validatePhim(phim, false);
        if (validationMessage != null) {
            return validationMessage;
        }

        boolean result = phimDao.update(phim);
        return result ? "Cập nhật phim thành công." : "Cập nhật phim thất bại.";
    }

    /**
     * Xóa phim theo mã phim.
     *
     * @param maPhim mã phim cần xóa
     * @return thông báo kết quả xử lý
     */
    public String deletePhim(String maPhim) {
        AuthorizationUtil.requireStaff();

        if (maPhim == null || maPhim.trim().isEmpty()) {
            return "Mã phim không được để trống.";
        }

        Phim phim = phimDao.findById(maPhim.trim());
        if (phim == null) {
            return "Phim không tồn tại.";
        }

        boolean result = phimDao.delete(maPhim.trim());
        return result ? "Xóa phim thành công." : "Xóa phim thất bại.";
    }

    /**
     * Kiểm tra dữ liệu phim có hợp lệ hay không.
     *
     * @param phim đối tượng phim cần kiểm tra
     * @param isCreate true nếu là thêm mới, false nếu là cập nhật
     * @return null nếu hợp lệ, ngược lại trả về thông báo lỗi
     */
    private String validatePhim(Phim phim, boolean isCreate) {
        if (phim == null) {
            return "Dữ liệu phim không hợp lệ.";
        }

        if (phim.getMaPhim() == null || phim.getMaPhim().trim().isEmpty()) {
            return "Mã phim không được để trống.";
        }

        if (phim.getTenPhim() == null || phim.getTenPhim().trim().isEmpty()) {
            return "Tên phim không được để trống.";
        }

        if (phim.getThoiLuong() == null || phim.getThoiLuong() <= 0) {
            return "Thời lượng phim phải lớn hơn 0.";
        }

        int currentYear = Year.now().getValue();
        if (phim.getNamSanXuat() == null || phim.getNamSanXuat() < 1900 || phim.getNamSanXuat() > currentYear + 1) {
            return "Năm sản xuất không hợp lệ.";
        }

        if (phim.getDaoDien() == null || phim.getDaoDien().trim().isEmpty()) {
            return "Đạo diễn không được để trống.";
        }

        if (isCreate && phimDao.existsById(phim.getMaPhim().trim())) {
            return "Mã phim đã tồn tại.";
        }

        if (!isCreate && phimDao.findById(phim.getMaPhim().trim()) == null) {
            return "Phim không tồn tại để cập nhật.";
        }

        phim.setMaPhim(phim.getMaPhim().trim());
        phim.setTenPhim(phim.getTenPhim().trim());
        phim.setDaoDien(phim.getDaoDien().trim());

        return null;
    }
}