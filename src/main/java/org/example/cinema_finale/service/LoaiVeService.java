package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.LoaiVeDao;
import org.example.cinema_finale.entity.LoaiVe;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.math.BigDecimal;
import java.util.List;

public class LoaiVeService {

    private final LoaiVeDao loaiVeDao;

    public LoaiVeService() {
        this.loaiVeDao = new LoaiVeDao();
    }

    public LoaiVeService(LoaiVeDao loaiVeDao) {
        this.loaiVeDao = loaiVeDao;
    }

    public List<LoaiVe> getAllLoaiVe() {
        return loaiVeDao.findAll();
    }

    public LoaiVe getLoaiVeById(String maLoaiVe) {
        Integer id = parseId(maLoaiVe);
        return id == null ? null : loaiVeDao.findById(id);
    }

    public List<LoaiVe> searchByTenLoaiVe(String tuKhoa) {
        return loaiVeDao.findByTenLoaiVe(tuKhoa == null ? "" : tuKhoa.trim());
    }

    public String addLoaiVe(LoaiVe loaiVe) {
        AuthorizationUtil.requireStaff();

        String validation = validateLoaiVe(loaiVe, true);
        if (validation != null) {
            return validation;
        }

        boolean result = loaiVeDao.save(loaiVe);
        return result ? "Thêm loại vé thành công." : "Thêm loại vé thất bại.";
    }

    public String updateLoaiVe(LoaiVe loaiVe) {
        AuthorizationUtil.requireStaff();

        String validation = validateLoaiVe(loaiVe, false);
        if (validation != null) {
            return validation;
        }

        boolean result = loaiVeDao.update(loaiVe);
        return result ? "Cập nhật loại vé thành công." : "Cập nhật loại vé thất bại.";
    }

    public String deleteLoaiVe(String maLoaiVe) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maLoaiVe);
        if (id == null) {
            return "Mã loại vé không hợp lệ.";
        }

        LoaiVe loaiVe = loaiVeDao.findById(id);
        if (loaiVe == null) {
            return "Loại vé không tồn tại.";
        }

        boolean result = loaiVeDao.delete(id);
        return result ? "Xóa loại vé thành công." : "Xóa loại vé thất bại.";
    }

    private String validateLoaiVe(LoaiVe loaiVe, boolean isCreate) {
        if (loaiVe == null) {
            return "Dữ liệu loại vé không hợp lệ.";
        }

        if (!isCreate && loaiVe.getMaLoaiVe() == null) {
            return "Mã loại vé không được để trống khi cập nhật.";
        }

        if (isBlank(loaiVe.getTenLoaiVe())) {
            return "Tên loại vé không được để trống.";
        }

        if (loaiVe.getPhuThuGia() == null) {
            loaiVe.setPhuThuGia(BigDecimal.ZERO);
        }

        if (loaiVe.getPhuThuGia().compareTo(BigDecimal.ZERO) < 0) {
            return "Phụ thu giá không được âm.";
        }

        loaiVe.setTenLoaiVe(loaiVe.getTenLoaiVe().trim());
        loaiVe.setMoTa(trimToNull(loaiVe.getMoTa()));

        if (!isCreate && loaiVeDao.findById(loaiVe.getMaLoaiVe()) == null) {
            return "Loại vé không tồn tại để cập nhật.";
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
