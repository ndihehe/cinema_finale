package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.KhachHangDao;
import org.example.cinema_finale.dto.KhachHangDTO;
import org.example.cinema_finale.dto.KhachHangFormDTO;
import org.example.cinema_finale.entity.KhachHang;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.util.List;
import java.util.stream.Collectors;

public class KhachHangService {

    private static final String GIOI_TINH_NAM = "Nam";
    private static final String GIOI_TINH_NU = "Nữ";
    private static final String GIOI_TINH_KHAC = "Khác";
    private static final String HANG_THUONG = "Thường";

    private final KhachHangDao khachHangDao;

    public KhachHangService() {
        this.khachHangDao = new KhachHangDao();
    }

    public KhachHangService(KhachHangDao khachHangDao) {
        this.khachHangDao = khachHangDao;
    }

    public List<KhachHangDTO> getAllKhachHang() {
        AuthorizationUtil.requireStaff();
        return khachHangDao.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public KhachHangDTO getKhachHangById(String maKhachHang) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maKhachHang);
        if (id == null) {
            return null;
        }

        KhachHang khachHang = khachHangDao.findById(id);
        return khachHang == null ? null : toDTO(khachHang);
    }

    public List<KhachHangDTO> getByHangThanhVien(String hangThanhVien) {
        AuthorizationUtil.requireStaff();

        if (isBlank(hangThanhVien)) {
            return List.of();
        }

        return khachHangDao.findByHangThanhVien(hangThanhVien.trim()).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public String addKhachHang(KhachHangFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        KhachHang khachHang = buildEntityFromForm(formDTO, true);
        String validation = validateKhachHang(khachHang, true);
        if (validation != null) {
            return validation;
        }

        boolean result = khachHangDao.save(khachHang);
        return result ? "Thêm khách hàng thành công." : "Thêm khách hàng thất bại.";
    }

    public String updateKhachHang(KhachHangFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        if (formDTO == null || formDTO.getMaKhachHang() == null) {
            return "Mã khách hàng không hợp lệ.";
        }

        KhachHang khachHang = buildEntityFromForm(formDTO, false);
        String validation = validateKhachHang(khachHang, false);
        if (validation != null) {
            return validation;
        }

        boolean result = khachHangDao.update(khachHang);
        return result ? "Cập nhật khách hàng thành công." : "Cập nhật khách hàng thất bại.";
    }

    private String validateKhachHang(KhachHang khachHang, boolean isCreate) {
        if (khachHang == null) {
            return "Dữ liệu khách hàng không hợp lệ.";
        }

        if (!isCreate && khachHang.getMaKhachHang() == null) {
            return "Mã khách hàng không được để trống khi cập nhật.";
        }

        if (isBlank(khachHang.getHoTen())) {
            return "Họ tên khách hàng không được để trống.";
        }

        khachHang.setHoTen(khachHang.getHoTen().trim());
        khachHang.setSoDienThoai(trimToNull(khachHang.getSoDienThoai()));
        khachHang.setEmail(trimToNull(khachHang.getEmail()));

        if (!isBlank(khachHang.getGioiTinh())) {
            String normalizedGender = normalizeGioiTinh(khachHang.getGioiTinh());
            if (normalizedGender == null) {
                return "Giới tính không hợp lệ.";
            }
            khachHang.setGioiTinh(normalizedGender);
        }

        if (khachHang.getDiemTichLuy() == null) {
            khachHang.setDiemTichLuy(0);
        }

        if (khachHang.getDiemTichLuy() < 0) {
            return "Điểm tích lũy không được âm.";
        }

        if (isBlank(khachHang.getHangThanhVien())) {
            khachHang.setHangThanhVien(HANG_THUONG);
        } else {
            khachHang.setHangThanhVien(khachHang.getHangThanhVien().trim());
        }

        if (!isCreate && khachHangDao.findById(khachHang.getMaKhachHang()) == null) {
            return "Khách hàng không tồn tại để cập nhật.";
        }

        if (!isBlank(khachHang.getSoDienThoai())) {
            KhachHang trungSoDienThoai = khachHangDao.findBySoDienThoai(khachHang.getSoDienThoai());
            if (trungSoDienThoai != null) {
                if (isCreate || !trungSoDienThoai.getMaKhachHang().equals(khachHang.getMaKhachHang())) {
                    return "Số điện thoại đã tồn tại.";
                }
            }
        }

        if (!isBlank(khachHang.getEmail())) {
            KhachHang trungEmail = khachHangDao.findByEmail(khachHang.getEmail());
            if (trungEmail != null) {
                if (isCreate || !trungEmail.getMaKhachHang().equals(khachHang.getMaKhachHang())) {
                    return "Email đã tồn tại.";
                }
            }
        }

        return null;
    }

    private KhachHang buildEntityFromForm(KhachHangFormDTO formDTO, boolean isCreate) {
        if (formDTO == null) {
            return null;
        }

        KhachHang khachHang;
        if (isCreate) {
            khachHang = new KhachHang();
        } else {
            khachHang = khachHangDao.findById(formDTO.getMaKhachHang());
            if (khachHang == null) {
                return null;
            }
        }

        if (formDTO.getMaKhachHang() != null) {
            khachHang.setMaKhachHang(formDTO.getMaKhachHang());
        }

        khachHang.setHoTen(trimToNull(formDTO.getHoTen()));
        khachHang.setSoDienThoai(trimToNull(formDTO.getSoDienThoai()));
        khachHang.setEmail(trimToNull(formDTO.getEmail()));
        khachHang.setGioiTinh(trimToNull(formDTO.getGioiTinh()));
        khachHang.setNgaySinh(formDTO.getNgaySinh());
        khachHang.setDiemTichLuy(formDTO.getDiemTichLuy());
        khachHang.setHangThanhVien(trimToNull(formDTO.getHangThanhVien()));

        return khachHang;
    }

    private KhachHangDTO toDTO(KhachHang khachHang) {
        KhachHangDTO dto = new KhachHangDTO();
        dto.setMaKhachHang(khachHang.getMaKhachHang());
        dto.setHoTen(khachHang.getHoTen());
        dto.setSoDienThoai(khachHang.getSoDienThoai());
        dto.setEmail(khachHang.getEmail());
        dto.setGioiTinh(khachHang.getGioiTinh());
        dto.setNgaySinh(khachHang.getNgaySinh());
        dto.setDiemTichLuy(khachHang.getDiemTichLuy());
        dto.setHangThanhVien(khachHang.getHangThanhVien());

        if (khachHang.getTaiKhoan() != null) {
            dto.setMaTaiKhoan(khachHang.getTaiKhoan().getMaTaiKhoan());
            dto.setTenDangNhap(khachHang.getTaiKhoan().getTenDangNhap());
        }

        return dto;
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

    private String normalizeGioiTinh(String value) {
        if (value == null) {
            return null;
        }

        String v = value.trim();

        if (v.equalsIgnoreCase("Nam")) return GIOI_TINH_NAM;
        if (v.equalsIgnoreCase("Nữ") || v.equalsIgnoreCase("Nu")) return GIOI_TINH_NU;
        if (v.equalsIgnoreCase("Khác") || v.equalsIgnoreCase("Khac")) return GIOI_TINH_KHAC;

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

    public List<KhachHangDTO> search(String keyword) {
        AuthorizationUtil.requireStaff();

        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllKhachHang();
        }

        String key = keyword.trim().toLowerCase();

        return khachHangDao.findAll().stream()
                .filter(k ->
                        (k.getHoTen() != null && k.getHoTen().toLowerCase().contains(key)) ||
                                (k.getSoDienThoai() != null && k.getSoDienThoai().contains(key))
                )
                .map(this::toDTO)
                .collect(Collectors.toList());
    }
}