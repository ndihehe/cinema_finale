package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.LoaiVeDao;
import org.example.cinema_finale.dto.LoaiVeDTO;
import org.example.cinema_finale.entity.LoaiVe;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

public class LoaiVeService {

    private final LoaiVeDao loaiVeDao;

    public LoaiVeService() {
        this.loaiVeDao = new LoaiVeDao();
    }

    public LoaiVeService(LoaiVeDao loaiVeDao) {
        this.loaiVeDao = loaiVeDao;
    }

    // ==========================================
    // 1. MAPPER: Chuyển đổi giữa Entity và DTO
    // ==========================================
    private LoaiVeDTO toDTO(LoaiVe lv) {
        if (lv == null) return null;
        return new LoaiVeDTO(
                lv.getMaLoaiVe(),
                lv.getTenLoaiVe(),
                lv.getMoTa(),
                lv.getPhuThuGia()
        );
    }

    private LoaiVe toEntity(LoaiVeDTO dto) {
        if (dto == null) return null;
        LoaiVe lv = new LoaiVe();
        lv.setMaLoaiVe(dto.getMaLoaiVe());
        lv.setTenLoaiVe(dto.getTenLoaiVe());
        lv.setMoTa(dto.getMoTa());
        lv.setPhuThuGia(dto.getPhuThuGia() != null ? dto.getPhuThuGia() : BigDecimal.ZERO);
        return lv;
    }

    // ==========================================
    // 2. PUBLIC API DÀNH CHO VIEW / CONTROLLER
    // ==========================================
    public List<LoaiVeDTO> getAllLoaiVe() {
        return loaiVeDao.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public LoaiVeDTO getLoaiVeById(String maLoaiVe) {
        Integer id = parseId(maLoaiVe);
        return id == null ? null : toDTO(loaiVeDao.findById(id));
    }

    public List<LoaiVeDTO> searchByTenLoaiVe(String tuKhoa) {
        String keyword = tuKhoa == null ? "" : tuKhoa.trim();
        return loaiVeDao.findByTenLoaiVe(keyword).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public String addLoaiVe(LoaiVeDTO loaiVeDTO) {
        AuthorizationUtil.requireStaff();
        LoaiVe entity = toEntity(loaiVeDTO);

        String validation = validateLoaiVe(entity, true);
        if (validation != null) return validation;

        return loaiVeDao.save(entity) ? "Thêm loại vé thành công." : "Thêm loại vé thất bại do lỗi DB.";
    }

    public String updateLoaiVe(LoaiVeDTO loaiVeDTO) {
        AuthorizationUtil.requireStaff();
        LoaiVe entity = toEntity(loaiVeDTO);

        String validation = validateLoaiVe(entity, false);
        if (validation != null) return validation;

        return loaiVeDao.update(entity) ? "Cập nhật loại vé thành công." : "Cập nhật loại vé thất bại.";
    }

    public String deleteLoaiVe(String maLoaiVe) {
        AuthorizationUtil.requireStaff();
        Integer id = parseId(maLoaiVe);
        if (id == null) return "Mã loại vé không hợp lệ.";

        return loaiVeDao.delete(id) ? "Xóa loại vé thành công." : "Xóa loại vé thất bại (Có thể loại vé này đang được sử dụng cho các vé đã bán).";
    }

    // ==========================================
    // 3. LOGIC NGHIỆP VỤ NỘI BỘ (PRIVATE)
    // ==========================================
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
        if (isBlank(value)) {
            return null;
        }
        return value.trim();
    }
}