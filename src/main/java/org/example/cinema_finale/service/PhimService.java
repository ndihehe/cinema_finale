package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.entity.Phim;
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
        Integer id = parseId(maPhim);
        return id == null ? null : phimDao.findById(id);
    }

    public List<Phim> searchByTenPhim(String tuKhoa) {
        return phimDao.findByTenPhim(tuKhoa == null ? "" : tuKhoa.trim());
    }

    public List<Phim> getByTrangThai(Object trangThaiPhim) {
        String status = normalizePhimStatus(trangThaiPhim);
        if (status == null) {
            return List.of();
        }
        return phimDao.findByTrangThai(status);
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

    public String deletePhim(String maPhim) {
        return stopPhim(maPhim);
    }

    public String stopPhim(String maPhim) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maPhim);
        if (id == null) {
            return "Mã phim không hợp lệ.";
        }

        Phim phim = phimDao.findById(id);
        if (phim == null) {
            return "Phim không tồn tại.";
        }

        boolean result = phimDao.updateTrangThai(id, "Ngừng chiếu");
        return result ? "Ngừng chiếu phim thành công." : "Cập nhật trạng thái phim thất bại.";
    }

    public String updateTrangThai(String maPhim, Object trangThaiPhim) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maPhim);
        if (id == null) {
            return "Mã phim không hợp lệ.";
        }

        String status = normalizePhimStatus(trangThaiPhim);
        if (status == null) {
            return "Trạng thái phim không hợp lệ.";
        }

        Phim phim = phimDao.findById(id);
        if (phim == null) {
            return "Phim không tồn tại.";
        }

        boolean result = phimDao.updateTrangThai(id, status);
        return result ? "Cập nhật trạng thái phim thành công." : "Cập nhật trạng thái phim thất bại.";
    }

    private String validatePhim(Phim phim, boolean isCreate) {
        if (phim == null) {
            return "Dữ liệu phim không hợp lệ.";
        }

        if (!isCreate && phim.getMaPhim() == null) {
            return "Mã phim không được để trống khi cập nhật.";
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

        if (phim.getGioiHanTuoi() != null && phim.getGioiHanTuoi() < 0) {
            return "Giới hạn tuổi không hợp lệ.";
        }

        if (phim.getNgayKhoiChieu() != null && phim.getNgayKhoiChieu().isAfter(LocalDate.now().plusYears(2))) {
            return "Ngày khởi chiếu không hợp lệ.";
        }

        phim.setTenPhim(phim.getTenPhim().trim());
        phim.setTheLoai(phim.getTheLoai().trim());
        phim.setDaoDien(phim.getDaoDien().trim());
        phim.setDinhDang(trimToNull(phim.getDinhDang()));

        if (phim.getTrangThaiPhim() == null || phim.getTrangThaiPhim().trim().isEmpty()) {
            phim.setTrangThaiPhim("Sắp chiếu");
        } else {
            phim.setTrangThaiPhim(normalizePhimStatus(phim.getTrangThaiPhim()));
        }

        if (!isCreate && phimDao.findById(phim.getMaPhim()) == null) {
            return "Phim không tồn tại để cập nhật.";
        }

        return null;
    }

    private Integer parseId(String value) {
        if (isBlank(value)) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String normalizePhimStatus(Object raw) {
        if (raw == null) {
            return null;
        }
        String value = raw.toString().trim();
        if (value.equalsIgnoreCase("Sắp chiếu") || value.equalsIgnoreCase("SAP_CHIEU")) return "Sắp chiếu";
        if (value.equalsIgnoreCase("Đang chiếu") || value.equalsIgnoreCase("DANG_CHIEU")) return "Đang chiếu";
        if (value.equalsIgnoreCase("Ngừng chiếu") || value.equalsIgnoreCase("NGUNG_CHIEU")) return "Ngừng chiếu";
        if (value.equalsIgnoreCase("Đã chiếu") || value.equalsIgnoreCase("DA_CHIEU")) return "Đã chiếu";
        return value;
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
