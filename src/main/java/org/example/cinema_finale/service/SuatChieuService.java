package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.dao.SuatChieuDao;
import org.example.cinema_finale.dto.SuatChieuDTO;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.entity.PhongChieu;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public class SuatChieuService {

    private final SuatChieuDao suatChieuDao;
    private final PhimDao phimDao;

    public SuatChieuService() {
        this.suatChieuDao = new SuatChieuDao();
        this.phimDao = new PhimDao();
    }

    public SuatChieuService(SuatChieuDao suatChieuDao, PhimDao phimDao) {
        this.suatChieuDao = suatChieuDao;
        this.phimDao = phimDao;
    }

    // ==========================================
    // 1. MAPPER: Chuyển đổi giữa Entity và DTO
    // ==========================================
    private SuatChieuDTO toDTO(SuatChieu sc) {
        if (sc == null) return null;
        return new SuatChieuDTO(
                sc.getMaSuatChieu(),
                sc.getPhim() != null ? sc.getPhim().getMaPhim() : null,
                sc.getPhim() != null ? sc.getPhim().getTenPhim() : "",
                sc.getPhongChieu() != null ? sc.getPhongChieu().getMaPhongChieu() : null,
                sc.getPhongChieu() != null ? sc.getPhongChieu().getTenPhongChieu() : "",
                sc.getNgayGioChieu(),
                sc.getGiaVeCoBan(),
                sc.getTrangThaiSuatChieu()
        );
    }

    private SuatChieu toEntity(SuatChieuDTO dto) {
        if (dto == null) return null;
        SuatChieu sc = new SuatChieu();
        sc.setMaSuatChieu(dto.getMaSuatChieu());
        sc.setNgayGioChieu(dto.getNgayGioChieu());
        sc.setGiaVeCoBan(dto.getGiaVeCoBan() != null ? dto.getGiaVeCoBan() : BigDecimal.ZERO);
        sc.setTrangThaiSuatChieu(normalizeSuatChieuStatus(dto.getTrangThaiSuatChieu()));

        // Gắn quan hệ Phim
        if (dto.getMaPhim() != null) {
            Phim phim = new Phim();
            phim.setMaPhim(dto.getMaPhim());
            sc.setPhim(phim);
        }

        // Gắn quan hệ Phòng chiếu
        if (dto.getMaPhongChieu() != null) {
            PhongChieu phongChieu = new PhongChieu();
            phongChieu.setMaPhongChieu(dto.getMaPhongChieu());
            sc.setPhongChieu(phongChieu);
        }

        return sc;
    }

    // ==========================================
    // 2. PUBLIC API DÀNH CHO VIEW / CONTROLLER
    // ==========================================
    public List<SuatChieuDTO> getAllSuatChieu() {
        return suatChieuDao.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public List<SuatChieuDTO> getAllForBooking() {
        return suatChieuDao.findAllForBooking().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public SuatChieuDTO getSuatChieuById(String maSuatChieu) {
        Integer id = parseId(maSuatChieu);
        return id == null ? null : toDTO(suatChieuDao.findById(id));
    }

    public String addSuatChieu(SuatChieuDTO suatChieuDTO) {
        AuthorizationUtil.requireStaff();
        SuatChieu entity = toEntity(suatChieuDTO);

        String validation = validateSuatChieu(entity, true);
        if (validation != null) return validation;

        return suatChieuDao.save(entity) ? "Thêm suất chiếu thành công." : "Thêm suất chiếu thất bại do lỗi DB.";
    }

    public String updateSuatChieu(SuatChieuDTO suatChieuDTO) {
        AuthorizationUtil.requireStaff();
        SuatChieu entity = toEntity(suatChieuDTO);

        String validation = validateSuatChieu(entity, false);
        if (validation != null) return validation;

        return suatChieuDao.update(entity) ? "Cập nhật suất chiếu thành công." : "Cập nhật suất chiếu thất bại.";
    }

    public String deleteSuatChieu(String maSuatChieu) {
        AuthorizationUtil.requireStaff();
        Integer id = parseId(maSuatChieu);
        if (id == null) return "Mã suất chiếu không hợp lệ.";

        return suatChieuDao.delete(id) ? "Hủy suất chiếu thành công." : "Hủy suất chiếu thất bại.";
    }

    // ==========================================
    // 3. LOGIC NGHIỆP VỤ NỘI BỘ (PRIVATE)
    // ==========================================
    private String validateSuatChieu(SuatChieu sc, boolean isCreate) {
        if (sc == null) return "Dữ liệu suất chiếu không hợp lệ.";
        if (!isCreate && sc.getMaSuatChieu() == null) return "Mã suất chiếu không được trống khi cập nhật.";
        if (sc.getPhim() == null || sc.getPhim().getMaPhim() == null) return "Vui lòng chọn phim.";
        if (sc.getPhongChieu() == null || sc.getPhongChieu().getMaPhongChieu() == null) return "Vui lòng chọn phòng chiếu.";
        if (sc.getNgayGioChieu() == null) return "Vui lòng chọn ngày giờ chiếu.";
        if (sc.getGiaVeCoBan() == null || sc.getGiaVeCoBan().compareTo(BigDecimal.ZERO) < 0) return "Giá vé cơ bản không được âm.";

        // Lấy thông tin phim từ DB để có "Thời lượng" phục vụ tính toán trùng lịch
        Phim phimDb = phimDao.findById(sc.getPhim().getMaPhim());
        if (phimDb == null) return "Bộ phim không tồn tại trong hệ thống.";
        sc.setPhim(phimDb); // Gắn lại phim đầy đủ dữ liệu vào suất chiếu

        if (!isCreate && suatChieuDao.findById(sc.getMaSuatChieu()) == null) {
            return "Suất chiếu không tồn tại để cập nhật.";
        }

        if (isChongLich(sc, isCreate)) {
            return "Trùng lịch! Suất chiếu này bị đụng giờ với một suất chiếu khác trong cùng phòng.";
        }

        return null;
    }

    private boolean isChongLich(SuatChieu scMoi, boolean isCreate) {
        if (scMoi.getPhim() == null || scMoi.getPhim().getThoiLuong() == null) return false;

        LocalDateTime batDauMoi = scMoi.getNgayGioChieu();
        LocalDateTime ketThucMoi = batDauMoi.plusMinutes(scMoi.getPhim().getThoiLuong());

        List<SuatChieu> danhSachSuatChieu = suatChieuDao.findAll();
        for (SuatChieu hienCo : danhSachSuatChieu) {
            // Bỏ qua chính nó nếu đang update
            if (!isCreate && hienCo.getMaSuatChieu().equals(scMoi.getMaSuatChieu())) continue;
            // Bỏ qua khác phòng chiếu
            if (hienCo.getPhongChieu() == null || !hienCo.getPhongChieu().getMaPhongChieu().equals(scMoi.getPhongChieu().getMaPhongChieu())) continue;
            // Bỏ qua các suất đã hủy
            if ("Hủy".equalsIgnoreCase(hienCo.getTrangThaiSuatChieu())) continue;
            // Bỏ qua nếu data phim bị lỗi (không có thời lượng)
            if (hienCo.getPhim() == null || hienCo.getPhim().getThoiLuong() == null) continue;

            LocalDateTime batDauCu = hienCo.getNgayGioChieu();
            LocalDateTime ketThucCu = batDauCu.plusMinutes(hienCo.getPhim().getThoiLuong());

            // Công thức kiểm tra trùng lịch (Overlap logic)
            boolean biChongLich = batDauMoi.isBefore(ketThucCu) && ketThucMoi.isAfter(batDauCu);
            if (biChongLich) {
                return true;
            }
        }
        return false;
    }

    private Integer parseId(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String normalizeSuatChieuStatus(Object raw) {
        if (raw == null) return "Sắp chiếu"; // Default value
        String value = raw.toString().trim();
        if (value.equalsIgnoreCase("Sắp chiếu") || value.equalsIgnoreCase("SAP_CHIEU")) return "Sắp chiếu";
        if (value.equalsIgnoreCase("Đang chiếu") || value.equalsIgnoreCase("DANG_CHIEU") || value.equalsIgnoreCase("DANG_MO_BAN")) return "Đang chiếu";
        if (value.equalsIgnoreCase("Đã chiếu") || value.equalsIgnoreCase("DA_CHIEU")) return "Đã chiếu";
        if (value.equalsIgnoreCase("Hủy") || value.equalsIgnoreCase("HUY")) return "Hủy";
        return "Sắp chiếu";
    }
}