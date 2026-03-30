package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.enums.TrangThaiPhim;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.time.LocalDate;
import java.util.List;

public class PhimService {

    private final PhimDao phimDao;

    public PhimService() {
        this.phimDao = new PhimDao();
    }

    public PhimService(PhimDao phimDao) {
        this.phimDao = phimDao;
    }

    public List<Phim> getAllPhim() {
        return phimDao.findAll();
    }

    public List<Phim> getAllPhimForBooking() {
        return phimDao.findAllForBooking();
    }

    public Phim getPhimById(String maPhim) {
        if (isBlank(maPhim)) {
            return null;
        }
        return phimDao.findById(maPhim.trim());
    }

    public List<Phim> searchByTenPhim(String tuKhoa) {
        return phimDao.findByTenPhim(tuKhoa == null ? "" : tuKhoa.trim());
    }

    public List<Phim> getByTrangThai(TrangThaiPhim trangThaiPhim) {
        if (trangThaiPhim == null) {
            return List.of();
        }
        return phimDao.findByTrangThai(trangThaiPhim);
    }

    public String addPhim(Phim phim) {
        AuthorizationUtil.requireStaff();

        String validation = validatePhim(phim, true);
        if (validation != null) {
            return validation;
        }

        boolean result = phimDao.save(phim);
        return result ? "Thêm phim thành công." : "Thêm phim thất bại.";
    }

    public String updatePhim(Phim phim) {
        AuthorizationUtil.requireStaff();

        String validation = validatePhim(phim, false);
        if (validation != null) {
            return validation;
        }

        boolean result = phimDao.update(phim);
        return result ? "Cập nhật phim thành công." : "Cập nhật phim thất bại.";
    }

    /**
     * Giữ tên hàm cũ để UI/controller cũ ít bị vỡ.
     * Nhưng thực tế không xóa cứng, chỉ chuyển trạng thái NGUNG_CHIEU.
     */
    public String deletePhim(String maPhim) {
        return stopPhim(maPhim);
    }

    public String stopPhim(String maPhim) {
        AuthorizationUtil.requireStaff();

        if (isBlank(maPhim)) {
            return "Mã phim không được để trống.";
        }

        Phim phim = phimDao.findById(maPhim.trim());
        if (phim == null) {
            return "Phim không tồn tại.";
        }

        boolean result = phimDao.updateTrangThai(maPhim.trim(), TrangThaiPhim.NGUNG_CHIEU);
        return result ? "Ngừng chiếu phim thành công." : "Cập nhật trạng thái phim thất bại.";
    }

    public String updateTrangThai(String maPhim, TrangThaiPhim trangThaiPhim) {
        AuthorizationUtil.requireStaff();

        if (isBlank(maPhim)) {
            return "Mã phim không được để trống.";
        }

        if (trangThaiPhim == null) {
            return "Trạng thái phim không hợp lệ.";
        }

        Phim phim = phimDao.findById(maPhim.trim());
        if (phim == null) {
            return "Phim không tồn tại.";
        }

        boolean result = phimDao.updateTrangThai(maPhim.trim(), trangThaiPhim);
        return result ? "Cập nhật trạng thái phim thành công." : "Cập nhật trạng thái phim thất bại.";
    }

    private String validatePhim(Phim phim, boolean isCreate) {
        if (phim == null) {
            return "Dữ liệu phim không hợp lệ.";
        }

        if (isBlank(phim.getMaPhim())) {
            return "Mã phim không được để trống.";
        }

        if (isBlank(phim.getTenPhim())) {
            return "Tên phim không được để trống.";
        }

        if (isBlank(phim.getTheLoai())) {
            return "Thể loại không được để trống.";
        }

        if (isBlank(phim.getDaoDien())) {
            return "Đạo diễn không được để trống.";
        }

        if (phim.getThoiLuong() == null || phim.getThoiLuong() <= 0) {
            return "Thời lượng phim phải lớn hơn 0.";
        }

        if (phim.getTrangThaiPhim() == null) {
            return "Trạng thái phim không được để trống.";
        }

        if (phim.getNgayKhoiChieu() != null
                && phim.getNgayKhoiChieu().isAfter(LocalDate.now().plusYears(2))) {
            return "Ngày khởi chiếu không hợp lệ.";
        }

        phim.setMaPhim(phim.getMaPhim().trim());
        phim.setTenPhim(phim.getTenPhim().trim());
        phim.setTheLoai(phim.getTheLoai().trim());
        phim.setDaoDien(phim.getDaoDien().trim());
        phim.setGioiHanTuoi(trimToNull(phim.getGioiHanTuoi()));
        phim.setDinhDang(trimToNull(phim.getDinhDang()));
        phim.setMoTa(trimToNull(phim.getMoTa()));

        if (isCreate && phimDao.existsById(phim.getMaPhim())) {
            return "Mã phim đã tồn tại.";
        }

        if (!isCreate && phimDao.findById(phim.getMaPhim()) == null) {
            return "Phim không tồn tại để cập nhật.";
        }

        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}