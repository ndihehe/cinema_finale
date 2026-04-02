package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.KhuyenMaiDao;
import org.example.cinema_finale.dao.LoaiKhuyenMaiDao;
import org.example.cinema_finale.dto.KhuyenMaiDTO;
import org.example.cinema_finale.dto.KhuyenMaiFormDTO;
import org.example.cinema_finale.entity.KhuyenMai;
import org.example.cinema_finale.entity.LoaiKhuyenMai;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public class KhuyenMaiService {

    private static final String STATUS_HOAT_DONG = "Hoạt động";
    private static final String STATUS_NGUNG = "Ngừng";
    private static final String KIEU_PHAN_TRAM = "%";
    private static final String KIEU_TIEN = "TIEN";

    private final KhuyenMaiDao khuyenMaiDao;
    private final LoaiKhuyenMaiDao loaiKhuyenMaiDao;

    public KhuyenMaiService() {
        this.khuyenMaiDao = new KhuyenMaiDao();
        this.loaiKhuyenMaiDao = new LoaiKhuyenMaiDao();
    }

    public KhuyenMaiService(KhuyenMaiDao khuyenMaiDao, LoaiKhuyenMaiDao loaiKhuyenMaiDao) {
        this.khuyenMaiDao = khuyenMaiDao;
        this.loaiKhuyenMaiDao = loaiKhuyenMaiDao;
    }

    /* =========================
       READ -> DTO
       ========================= */

    public List<KhuyenMaiDTO> getAllKhuyenMai() {
        AuthorizationUtil.requireStaff();
        return khuyenMaiDao.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public KhuyenMaiDTO getKhuyenMaiById(String maKhuyenMai) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maKhuyenMai);
        if (id == null) {
            return null;
        }

        KhuyenMai khuyenMai = khuyenMaiDao.findById(id);
        return khuyenMai == null ? null : toDTO(khuyenMai);
    }

    public List<KhuyenMaiDTO> getKhuyenMaiByTrangThai(Object trangThai) {
        AuthorizationUtil.requireStaff();

        String normalizedStatus = normalizeTrangThai(trangThai);
        if (normalizedStatus == null) {
            return List.of();
        }

        return khuyenMaiDao.findByTrangThai(normalizedStatus).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<KhuyenMaiDTO> getKhuyenMaiDangHieuLuc() {
        AuthorizationUtil.requireStaff();
        return khuyenMaiDao.findHieuLucTrongKhoang(LocalDateTime.now()).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    /* =========================
       WRITE <- FORM DTO
       ========================= */

    public String addKhuyenMai(KhuyenMaiFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        KhuyenMai khuyenMai = buildEntityFromForm(formDTO, true);
        String validation = validateKhuyenMai(khuyenMai, true);
        if (validation != null) {
            return validation;
        }

        boolean result = khuyenMaiDao.save(khuyenMai);
        return result ? "Thêm khuyến mãi thành công." : "Thêm khuyến mãi thất bại.";
    }

    public String updateKhuyenMai(KhuyenMaiFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        if (formDTO == null || formDTO.getMaKhuyenMai() == null) {
            return "Mã khuyến mãi không hợp lệ.";
        }

        KhuyenMai khuyenMai = buildEntityFromForm(formDTO, false);
        String validation = validateKhuyenMai(khuyenMai, false);
        if (validation != null) {
            return validation;
        }

        boolean result = khuyenMaiDao.update(khuyenMai);
        return result ? "Cập nhật khuyến mãi thành công." : "Cập nhật khuyến mãi thất bại.";
    }

    public String updateTrangThai(String maKhuyenMai, Object trangThai) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maKhuyenMai);
        if (id == null) {
            return "Mã khuyến mãi không hợp lệ.";
        }

        String normalizedStatus = normalizeTrangThai(trangThai);
        if (normalizedStatus == null) {
            return "Trạng thái khuyến mãi không hợp lệ.";
        }

        KhuyenMai khuyenMai = khuyenMaiDao.findById(id);
        if (khuyenMai == null) {
            return "Khuyến mãi không tồn tại.";
        }

        boolean result = khuyenMaiDao.updateTrangThai(id, normalizedStatus);
        return result ? "Cập nhật trạng thái khuyến mãi thành công."
                : "Cập nhật trạng thái khuyến mãi thất bại.";
    }

    public String deactivateKhuyenMai(String maKhuyenMai) {
        return updateTrangThai(maKhuyenMai, STATUS_NGUNG);
    }

    /* =========================
       VALIDATION
       ========================= */

    private String validateKhuyenMai(KhuyenMai khuyenMai, boolean isCreate) {
        if (khuyenMai == null) {
            return "Dữ liệu khuyến mãi không hợp lệ.";
        }

        if (!isCreate && khuyenMai.getMaKhuyenMai() == null) {
            return "Mã khuyến mãi không được để trống khi cập nhật.";
        }

        if (isBlank(khuyenMai.getTenKhuyenMai())) {
            return "Tên khuyến mãi không được để trống.";
        }

        if (khuyenMai.getLoaiKhuyenMai() == null || khuyenMai.getLoaiKhuyenMai().getMaLoaiKhuyenMai() == null) {
            return "Loại khuyến mãi không hợp lệ.";
        }

        LoaiKhuyenMai loaiKhuyenMai = loaiKhuyenMaiDao.findById(khuyenMai.getLoaiKhuyenMai().getMaLoaiKhuyenMai());
        if (loaiKhuyenMai == null) {
            return "Loại khuyến mãi không tồn tại.";
        }

        String normalizedKieuGiaTri = normalizeKieuGiaTri(khuyenMai.getKieuGiaTri());
        if (normalizedKieuGiaTri == null) {
            return "Kiểu giá trị khuyến mãi không hợp lệ.";
        }
        khuyenMai.setKieuGiaTri(normalizedKieuGiaTri);

        if (khuyenMai.getGiaTri() == null || khuyenMai.getGiaTri().compareTo(BigDecimal.ZERO) <= 0) {
            return "Giá trị khuyến mãi phải lớn hơn 0.";
        }

        if (KIEU_PHAN_TRAM.equals(khuyenMai.getKieuGiaTri())
                && khuyenMai.getGiaTri().compareTo(new BigDecimal("100")) > 0) {
            return "Khuyến mãi phần trăm không được lớn hơn 100.";
        }

        if (khuyenMai.getNgayBatDau() == null || khuyenMai.getNgayKetThuc() == null) {
            return "Ngày bắt đầu và ngày kết thúc không được để trống.";
        }

        if (khuyenMai.getNgayKetThuc().isBefore(khuyenMai.getNgayBatDau())) {
            return "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.";
        }

        if (khuyenMai.getDonHangToiThieu() == null) {
            khuyenMai.setDonHangToiThieu(BigDecimal.ZERO);
        }

        if (khuyenMai.getDonHangToiThieu().compareTo(BigDecimal.ZERO) < 0) {
            return "Đơn hàng tối thiểu không được âm.";
        }

        if (isBlank(khuyenMai.getTrangThai())) {
            khuyenMai.setTrangThai(STATUS_HOAT_DONG);
        } else {
            String normalizedTrangThai = normalizeTrangThai(khuyenMai.getTrangThai());
            if (normalizedTrangThai == null) {
                return "Trạng thái khuyến mãi không hợp lệ.";
            }
            khuyenMai.setTrangThai(normalizedTrangThai);
        }

        khuyenMai.setTenKhuyenMai(khuyenMai.getTenKhuyenMai().trim());
        khuyenMai.setLoaiKhuyenMai(loaiKhuyenMai);

        if (!isCreate && khuyenMaiDao.findById(khuyenMai.getMaKhuyenMai()) == null) {
            return "Khuyến mãi không tồn tại để cập nhật.";
        }

        KhuyenMai trungTen = khuyenMaiDao.findByTenKhuyenMai(khuyenMai.getTenKhuyenMai());
        if (trungTen != null) {
            if (isCreate || !trungTen.getMaKhuyenMai().equals(khuyenMai.getMaKhuyenMai())) {
                return "Tên khuyến mãi đã tồn tại.";
            }
        }

        return null;
    }

    /* =========================
       DTO / FORM MAPPING
       ========================= */

    private KhuyenMai buildEntityFromForm(KhuyenMaiFormDTO formDTO, boolean isCreate) {
        if (formDTO == null) {
            return null;
        }

        KhuyenMai khuyenMai;
        if (isCreate) {
            khuyenMai = new KhuyenMai();
        } else {
            khuyenMai = khuyenMaiDao.findById(formDTO.getMaKhuyenMai());
            if (khuyenMai == null) {
                return null;
            }
        }

        if (formDTO.getMaKhuyenMai() != null) {
            khuyenMai.setMaKhuyenMai(formDTO.getMaKhuyenMai());
        }

        khuyenMai.setTenKhuyenMai(trimToNull(formDTO.getTenKhuyenMai()));
        khuyenMai.setKieuGiaTri(trimToNull(formDTO.getKieuGiaTri()));
        khuyenMai.setGiaTri(formDTO.getGiaTri());
        khuyenMai.setNgayBatDau(formDTO.getNgayBatDau());
        khuyenMai.setNgayKetThuc(formDTO.getNgayKetThuc());
        khuyenMai.setDonHangToiThieu(formDTO.getDonHangToiThieu());
        khuyenMai.setTrangThai(trimToNull(formDTO.getTrangThai()));

        if (formDTO.getMaLoaiKhuyenMai() != null) {
            LoaiKhuyenMai loaiKhuyenMai = new LoaiKhuyenMai();
            loaiKhuyenMai.setMaLoaiKhuyenMai(formDTO.getMaLoaiKhuyenMai());
            khuyenMai.setLoaiKhuyenMai(loaiKhuyenMai);
        } else {
            khuyenMai.setLoaiKhuyenMai(null);
        }

        return khuyenMai;
    }

    private KhuyenMaiDTO toDTO(KhuyenMai khuyenMai) {
        KhuyenMaiDTO dto = new KhuyenMaiDTO();
        dto.setMaKhuyenMai(khuyenMai.getMaKhuyenMai());
        dto.setTenKhuyenMai(khuyenMai.getTenKhuyenMai());
        dto.setKieuGiaTri(khuyenMai.getKieuGiaTri());
        dto.setGiaTri(khuyenMai.getGiaTri());
        dto.setNgayBatDau(khuyenMai.getNgayBatDau());
        dto.setNgayKetThuc(khuyenMai.getNgayKetThuc());
        dto.setDonHangToiThieu(khuyenMai.getDonHangToiThieu());
        dto.setTrangThai(khuyenMai.getTrangThai());

        if (khuyenMai.getLoaiKhuyenMai() != null) {
            dto.setMaLoaiKhuyenMai(khuyenMai.getLoaiKhuyenMai().getMaLoaiKhuyenMai());
            dto.setTenLoaiKhuyenMai(khuyenMai.getLoaiKhuyenMai().getTenLoaiKhuyenMai());
        }

        return dto;
    }

    /* =========================
       HELPERS
       ========================= */

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

    private String normalizeKieuGiaTri(String value) {
        if (value == null) {
            return null;
        }

        String v = value.trim();

        if (v.equals("%") || v.equalsIgnoreCase("PHAN_TRAM") || v.equalsIgnoreCase("PERCENT")) {
            return KIEU_PHAN_TRAM;
        }
        if (v.equalsIgnoreCase("TIEN") || v.equalsIgnoreCase("SO_TIEN") || v.equalsIgnoreCase("MONEY")) {
            return KIEU_TIEN;
        }

        return null;
    }

    private String normalizeTrangThai(Object raw) {
        if (raw == null) {
            return null;
        }

        String value = raw.toString().trim();

        if (value.equalsIgnoreCase("Hoạt động") || value.equalsIgnoreCase("HOAT_DONG")) {
            return STATUS_HOAT_DONG;
        }
        if (value.equalsIgnoreCase("Ngừng")
                || value.equalsIgnoreCase("NGUNG")
                || value.equalsIgnoreCase("KHOA")
                || value.equalsIgnoreCase("TAT")) {
            return STATUS_NGUNG;
        }

        return null;
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}