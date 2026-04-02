package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.ChucVuDao;
import org.example.cinema_finale.dao.NhanVienDao;
import org.example.cinema_finale.dto.NhanVienDTO;
import org.example.cinema_finale.dto.NhanVienFormDTO;
import org.example.cinema_finale.entity.ChucVu;
import org.example.cinema_finale.entity.NhanVien;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.util.List;
import java.util.stream.Collectors;

public class NhanVienService {

    private static final String STATUS_DANG_LAM = "Đang làm";
    private static final String STATUS_NGHI_VIEC = "Nghỉ việc";
    private static final String GIOI_TINH_NAM = "Nam";
    private static final String GIOI_TINH_NU = "Nữ";
    private static final String GIOI_TINH_KHAC = "Khác";

    private final NhanVienDao nhanVienDao;
    private final ChucVuDao chucVuDao;

    public NhanVienService() {
        this.nhanVienDao = new NhanVienDao();
        this.chucVuDao = new ChucVuDao();
    }

    public NhanVienService(NhanVienDao nhanVienDao, ChucVuDao chucVuDao) {
        this.nhanVienDao = nhanVienDao;
        this.chucVuDao = chucVuDao;
    }

    public List<NhanVienDTO> getAllNhanVien() {
        AuthorizationUtil.requireStaff();
        return nhanVienDao.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public NhanVienDTO getNhanVienById(String maNhanVien) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maNhanVien);
        if (id == null) {
            return null;
        }

        NhanVien nhanVien = nhanVienDao.findById(id);
        return nhanVien == null ? null : toDTO(nhanVien);
    }

    public List<NhanVienDTO> getByTrangThaiLamViec(Object trangThaiLamViec) {
        AuthorizationUtil.requireStaff();

        String normalizedStatus = normalizeTrangThaiLamViec(trangThaiLamViec);
        if (normalizedStatus == null) {
            return List.of();
        }

        return nhanVienDao.findByTrangThaiLamViec(normalizedStatus).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public String addNhanVien(NhanVienFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        NhanVien nhanVien = buildEntityFromForm(formDTO, true);
        String validation = validateNhanVien(nhanVien, true);
        if (validation != null) {
            return validation;
        }

        boolean result = nhanVienDao.save(nhanVien);
        return result ? "Thêm nhân viên thành công." : "Thêm nhân viên thất bại.";
    }

    public String updateNhanVien(NhanVienFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        if (formDTO == null || formDTO.getMaNhanVien() == null) {
            return "Mã nhân viên không hợp lệ.";
        }

        NhanVien nhanVien = buildEntityFromForm(formDTO, false);
        String validation = validateNhanVien(nhanVien, false);
        if (validation != null) {
            return validation;
        }

        boolean result = nhanVienDao.update(nhanVien);
        return result ? "Cập nhật nhân viên thành công." : "Cập nhật nhân viên thất bại.";
    }

    public String updateTrangThaiLamViec(String maNhanVien, Object trangThaiLamViec) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maNhanVien);
        if (id == null) {
            return "Mã nhân viên không hợp lệ.";
        }

        String normalizedStatus = normalizeTrangThaiLamViec(trangThaiLamViec);
        if (normalizedStatus == null) {
            return "Trạng thái làm việc không hợp lệ.";
        }

        NhanVien nhanVien = nhanVienDao.findById(id);
        if (nhanVien == null) {
            return "Nhân viên không tồn tại.";
        }

        boolean result = nhanVienDao.updateTrangThaiLamViec(id, normalizedStatus);
        return result ? "Cập nhật trạng thái làm việc thành công."
                : "Cập nhật trạng thái làm việc thất bại.";
    }

    public String deactivateNhanVien(String maNhanVien) {
        return updateTrangThaiLamViec(maNhanVien, STATUS_NGHI_VIEC);
    }

    private String validateNhanVien(NhanVien nhanVien, boolean isCreate) {
        if (nhanVien == null) {
            return "Dữ liệu nhân viên không hợp lệ.";
        }

        if (!isCreate && nhanVien.getMaNhanVien() == null) {
            return "Mã nhân viên không được để trống khi cập nhật.";
        }

        if (isBlank(nhanVien.getHoTen())) {
            return "Họ tên nhân viên không được để trống.";
        }

        if (isBlank(nhanVien.getSoDienThoai())) {
            return "Số điện thoại không được để trống.";
        }

        if (nhanVien.getChucVu() == null || nhanVien.getChucVu().getMaChucVu() == null) {
            return "Chức vụ không hợp lệ.";
        }

        ChucVu chucVu = chucVuDao.findById(nhanVien.getChucVu().getMaChucVu());
        if (chucVu == null) {
            return "Chức vụ không tồn tại.";
        }

        if (isBlank(nhanVien.getTrangThaiLamViec())) {
            nhanVien.setTrangThaiLamViec(STATUS_DANG_LAM);
        } else {
            String normalizedStatus = normalizeTrangThaiLamViec(nhanVien.getTrangThaiLamViec());
            if (normalizedStatus == null) {
                return "Trạng thái làm việc không hợp lệ.";
            }
            nhanVien.setTrangThaiLamViec(normalizedStatus);
        }

        if (!isBlank(nhanVien.getGioiTinh())) {
            String normalizedGender = normalizeGioiTinh(nhanVien.getGioiTinh());
            if (normalizedGender == null) {
                return "Giới tính không hợp lệ.";
            }
            nhanVien.setGioiTinh(normalizedGender);
        }

        nhanVien.setHoTen(nhanVien.getHoTen().trim());
        nhanVien.setSoDienThoai(nhanVien.getSoDienThoai().trim());
        nhanVien.setEmail(trimToNull(nhanVien.getEmail()));
        nhanVien.setDiaChi(trimToNull(nhanVien.getDiaChi()));
        nhanVien.setChucVu(chucVu);

        if (!isCreate && nhanVienDao.findById(nhanVien.getMaNhanVien()) == null) {
            return "Nhân viên không tồn tại để cập nhật.";
        }

        NhanVien trungSoDienThoai = nhanVienDao.findBySoDienThoai(nhanVien.getSoDienThoai());
        if (trungSoDienThoai != null) {
            if (isCreate || !trungSoDienThoai.getMaNhanVien().equals(nhanVien.getMaNhanVien())) {
                return "Số điện thoại đã tồn tại.";
            }
        }

        if (!isBlank(nhanVien.getEmail())) {
            NhanVien trungEmail = nhanVienDao.findByEmail(nhanVien.getEmail());
            if (trungEmail != null) {
                if (isCreate || !trungEmail.getMaNhanVien().equals(nhanVien.getMaNhanVien())) {
                    return "Email đã tồn tại.";
                }
            }
        }

        return null;
    }

    private NhanVien buildEntityFromForm(NhanVienFormDTO formDTO, boolean isCreate) {
        if (formDTO == null) {
            return null;
        }

        NhanVien nhanVien;
        if (isCreate) {
            nhanVien = new NhanVien();
        } else {
            nhanVien = nhanVienDao.findById(formDTO.getMaNhanVien());
            if (nhanVien == null) {
                return null;
            }
        }

        if (formDTO.getMaNhanVien() != null) {
            nhanVien.setMaNhanVien(formDTO.getMaNhanVien());
        }

        nhanVien.setHoTen(trimToNull(formDTO.getHoTen()));
        nhanVien.setNgaySinh(formDTO.getNgaySinh());
        nhanVien.setGioiTinh(trimToNull(formDTO.getGioiTinh()));
        nhanVien.setSoDienThoai(trimToNull(formDTO.getSoDienThoai()));
        nhanVien.setEmail(trimToNull(formDTO.getEmail()));
        nhanVien.setDiaChi(trimToNull(formDTO.getDiaChi()));
        nhanVien.setTrangThaiLamViec(trimToNull(formDTO.getTrangThaiLamViec()));

        if (formDTO.getMaChucVu() != null) {
            ChucVu chucVu = new ChucVu();
            chucVu.setMaChucVu(formDTO.getMaChucVu());
            nhanVien.setChucVu(chucVu);
        } else {
            nhanVien.setChucVu(null);
        }

        return nhanVien;
    }

    private NhanVienDTO toDTO(NhanVien nhanVien) {
        NhanVienDTO dto = new NhanVienDTO();
        dto.setMaNhanVien(nhanVien.getMaNhanVien());
        dto.setHoTen(nhanVien.getHoTen());
        dto.setNgaySinh(nhanVien.getNgaySinh());
        dto.setGioiTinh(nhanVien.getGioiTinh());
        dto.setSoDienThoai(nhanVien.getSoDienThoai());
        dto.setEmail(nhanVien.getEmail());
        dto.setDiaChi(nhanVien.getDiaChi());
        dto.setTrangThaiLamViec(nhanVien.getTrangThaiLamViec());

        if (nhanVien.getChucVu() != null) {
            dto.setMaChucVu(nhanVien.getChucVu().getMaChucVu());
            dto.setTenChucVu(nhanVien.getChucVu().getTenChucVu());
        }

        if (nhanVien.getTaiKhoan() != null) {
            dto.setMaTaiKhoan(nhanVien.getTaiKhoan().getMaTaiKhoan());
            dto.setTenDangNhap(nhanVien.getTaiKhoan().getTenDangNhap());
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

    private String normalizeTrangThaiLamViec(Object raw) {
        if (raw == null) {
            return null;
        }

        String value = raw.toString().trim();

        if (value.equalsIgnoreCase("Đang làm") || value.equalsIgnoreCase("DANG_LAM")) {
            return STATUS_DANG_LAM;
        }
        if (value.equalsIgnoreCase("Nghỉ việc")
                || value.equalsIgnoreCase("NGHI_VIEC")
                || value.equalsIgnoreCase("NGUNG")) {
            return STATUS_NGHI_VIEC;
        }

        return null;
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
}