package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.TaiKhoanDao;
import org.example.cinema_finale.dto.ChangePasswordDTO;
import org.example.cinema_finale.dto.TaiKhoanDTO;
import org.example.cinema_finale.dto.TaiKhoanFormDTO;
import org.example.cinema_finale.entity.KhachHang;
import org.example.cinema_finale.entity.NhanVien;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.util.AuthorizationUtil;
import org.example.cinema_finale.util.SessionManager;

import java.lang.reflect.Method;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class TaiKhoanService {

    private static final String ROLE_NHAN_VIEN = "NhanVien";
    private static final String ROLE_KHACH_HANG = "KhachHang";
    private static final String STATUS_HOAT_DONG = "Hoạt động";
    private static final String STATUS_KHOA = "Khóa";

    private final TaiKhoanDao taiKhoanDao;

    public TaiKhoanService() {
        this.taiKhoanDao = new TaiKhoanDao();
    }

    public TaiKhoanService(TaiKhoanDao taiKhoanDao) {
        this.taiKhoanDao = taiKhoanDao;
    }

    /* =========================
       READ FOR UI -> DTO
       ========================= */

    public List<TaiKhoanDTO> getAllTaiKhoanDTO() {
        AuthorizationUtil.requireStaff();
        return taiKhoanDao.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<TaiKhoanDTO> getAllActiveTaiKhoanDTO() {
        AuthorizationUtil.requireStaff();
        return taiKhoanDao.findAllActive().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public TaiKhoanDTO getTaiKhoanDTOById(String maTk) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maTk);
        if (id == null) {
            return null;
        }

        TaiKhoan taiKhoan = taiKhoanDao.findById(id);
        return taiKhoan == null ? null : toDTO(taiKhoan);
    }

    /* =========================
       BACKWARD COMPATIBILITY
       ========================= */

    public List<TaiKhoan> getAllTaiKhoan() {
        AuthorizationUtil.requireStaff();
        return taiKhoanDao.findAll();
    }

    public List<TaiKhoan> getAllActiveTaiKhoan() {
        AuthorizationUtil.requireStaff();
        return taiKhoanDao.findAllActive();
    }

    public TaiKhoan getTaiKhoanById(String maTk) {
        AuthorizationUtil.requireStaff();
        Integer id = parseId(maTk);
        return id == null ? null : taiKhoanDao.findById(id);
    }

    public TaiKhoan getByTenDangNhap(String tenDangNhap) {
        if (isBlank(tenDangNhap)) {
            return null;
        }
        return taiKhoanDao.findByTenDangNhap(tenDangNhap.trim());
    }

    /* =========================
       CREATE / UPDATE BY DTO
       ========================= */

    public String addTaiKhoan(TaiKhoanFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        TaiKhoan taiKhoan = buildEntityFromForm(formDTO, true);
        String validation = validateTaiKhoan(taiKhoan, true);
        if (validation != null) {
            return validation;
        }

        boolean result = taiKhoanDao.save(taiKhoan);
        return result ? "Thêm tài khoản thành công." : "Thêm tài khoản thất bại.";
    }

    public String updateTaiKhoan(TaiKhoanFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        if (formDTO == null || formDTO.getMaTaiKhoan() == null) {
            return "Mã tài khoản không hợp lệ.";
        }

        TaiKhoan existing = taiKhoanDao.findById(formDTO.getMaTaiKhoan());
        if (existing == null) {
            return "Tài khoản không tồn tại để cập nhật.";
        }

        TaiKhoan taiKhoan = buildEntityFromForm(formDTO, false);
        String validation = validateTaiKhoan(taiKhoan, false);
        if (validation != null) {
            return validation;
        }

        boolean result = taiKhoanDao.update(taiKhoan);
        return result ? "Cập nhật tài khoản thành công." : "Cập nhật tài khoản thất bại.";
    }

    /* =========================
       OLD CREATE / UPDATE
       ========================= */

    public String addTaiKhoan(TaiKhoan taiKhoan) {
        AuthorizationUtil.requireStaff();

        String validation = validateTaiKhoan(taiKhoan, true);
        if (validation != null) {
            return validation;
        }

        boolean result = taiKhoanDao.save(taiKhoan);
        return result ? "Thêm tài khoản thành công." : "Thêm tài khoản thất bại.";
    }

    public String updateTaiKhoan(TaiKhoan taiKhoan) {
        AuthorizationUtil.requireStaff();

        String validation = validateTaiKhoan(taiKhoan, false);
        if (validation != null) {
            return validation;
        }

        boolean result = taiKhoanDao.update(taiKhoan);
        return result ? "Cập nhật tài khoản thành công." : "Cập nhật tài khoản thất bại.";
    }

    /* =========================
       STATUS
       ========================= */

    public String updateTrangThai(String maTk, Object trangThaiTaiKhoan) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maTk);
        if (id == null) {
            return "Mã tài khoản không hợp lệ.";
        }

        String status = normalizeTaiKhoanStatus(trangThaiTaiKhoan);
        if (status == null) {
            return "Trạng thái tài khoản không hợp lệ.";
        }

        TaiKhoan taiKhoan = taiKhoanDao.findById(id);
        if (taiKhoan == null) {
            return "Tài khoản không tồn tại.";
        }

        TaiKhoan current = SessionManager.getCurrentTaiKhoan();
        if (current != null
                && current.getMaTaiKhoan() != null
                && current.getMaTaiKhoan().equals(taiKhoan.getMaTaiKhoan())
                && STATUS_KHOA.equalsIgnoreCase(status)) {
            return "Không thể tự khóa chính tài khoản đang đăng nhập.";
        }

        boolean result = taiKhoanDao.updateTrangThai(id, status);
        return result ? "Cập nhật trạng thái tài khoản thành công." : "Cập nhật trạng thái tài khoản thất bại.";
    }

    public String lockTaiKhoan(String maTk) {
        return updateTrangThai(maTk, STATUS_KHOA);
    }

    public String deactivateTaiKhoan(String maTk) {
        return updateTrangThai(maTk, STATUS_KHOA);
    }

    /* =========================
       AUTH
       ========================= */

    public TaiKhoan authenticate(String tenDangNhap, String matKhau) {
        if (isBlank(tenDangNhap) || isBlank(matKhau)) {
            return null;
        }

        TaiKhoan taiKhoan = taiKhoanDao.findByTenDangNhap(tenDangNhap.trim());
        if (taiKhoan == null) {
            return null;
        }

        if (!STATUS_HOAT_DONG.equalsIgnoreCase(taiKhoan.getTrangThaiTaiKhoan())) {
            return null;
        }

        // TODO: Khi nâng cấp bảo mật, thay bằng password hash.
        if (!matKhau.equals(taiKhoan.getMatKhau())) {
            return null;
        }

        return taiKhoan;
    }

    /* =========================
       CHANGE PASSWORD
       ========================= */

    public String changePassword(ChangePasswordDTO dto) {
        AuthorizationUtil.requireLogin();

        if (dto == null || dto.getMaTaiKhoan() == null) {
            return "Mã tài khoản không hợp lệ.";
        }

        if (isBlank(dto.getMatKhauMoi())) {
            return "Mật khẩu mới không được để trống.";
        }

        TaiKhoan taiKhoan = taiKhoanDao.findById(dto.getMaTaiKhoan());
        if (taiKhoan == null) {
            return "Tài khoản không tồn tại.";
        }

        TaiKhoan current = SessionManager.getCurrentTaiKhoan();
        if (current == null) {
            return "Bạn chưa đăng nhập.";
        }

        boolean isOwner = Objects.equals(current.getMaTaiKhoan(), taiKhoan.getMaTaiKhoan());
        boolean isStaff = ROLE_NHAN_VIEN.equalsIgnoreCase(current.getLoaiTaiKhoan());

        if (!isOwner && !isStaff) {
            return "Bạn không có quyền đổi mật khẩu của tài khoản này.";
        }

        if (isOwner && !isStaff) {
            if (isBlank(dto.getMatKhauHienTai())) {
                return "Mật khẩu hiện tại không được để trống.";
            }
            if (!dto.getMatKhauHienTai().trim().equals(taiKhoan.getMatKhau())) {
                return "Mật khẩu hiện tại không chính xác.";
            }
        }

        taiKhoan.setMatKhau(dto.getMatKhauMoi().trim());
        boolean result = taiKhoanDao.update(taiKhoan);
        return result ? "Đổi mật khẩu thành công." : "Đổi mật khẩu thất bại.";
    }

    // Giữ lại để hạn chế vỡ code cũ
    public String changePassword(String maTk, String matKhauMoi) {
        ChangePasswordDTO dto = new ChangePasswordDTO();
        dto.setMaTaiKhoan(parseId(maTk));
        dto.setMatKhauMoi(matKhauMoi);
        return changePassword(dto);
    }

    /* =========================
       VALIDATION
       ========================= */

    private String validateTaiKhoan(TaiKhoan taiKhoan, boolean isCreate) {
        if (taiKhoan == null) {
            return "Dữ liệu tài khoản không hợp lệ.";
        }

        if (!isCreate && taiKhoan.getMaTaiKhoan() == null) {
            return "Mã tài khoản không được để trống khi cập nhật.";
        }

        if (isBlank(taiKhoan.getTenDangNhap())) {
            return "Tên đăng nhập không được để trống.";
        }

        if (isCreate && isBlank(taiKhoan.getMatKhau())) {
            return "Mật khẩu không được để trống.";
        }

        boolean coNhanVien = taiKhoan.getNhanVien() != null
                && taiKhoan.getNhanVien().getMaNhanVien() != null;
        boolean coKhachHang = taiKhoan.getKhachHang() != null
                && taiKhoan.getKhachHang().getMaKhachHang() != null;

        if (coNhanVien == coKhachHang) {
            return "Tài khoản phải gắn đúng một đối tượng: nhân viên hoặc khách hàng.";
        }

        if (isBlank(taiKhoan.getLoaiTaiKhoan())) {
            taiKhoan.setLoaiTaiKhoan(coNhanVien ? ROLE_NHAN_VIEN : ROLE_KHACH_HANG);
        } else {
            taiKhoan.setLoaiTaiKhoan(normalizeLoaiTaiKhoan(taiKhoan.getLoaiTaiKhoan()));
        }

        if (isBlank(taiKhoan.getTrangThaiTaiKhoan())) {
            taiKhoan.setTrangThaiTaiKhoan(STATUS_HOAT_DONG);
        } else {
            taiKhoan.setTrangThaiTaiKhoan(normalizeTaiKhoanStatus(taiKhoan.getTrangThaiTaiKhoan()));
        }

        if (taiKhoan.getLoaiTaiKhoan() == null
                || (!ROLE_NHAN_VIEN.equalsIgnoreCase(taiKhoan.getLoaiTaiKhoan())
                && !ROLE_KHACH_HANG.equalsIgnoreCase(taiKhoan.getLoaiTaiKhoan()))) {
            return "Loại tài khoản không hợp lệ.";
        }

        if (taiKhoan.getTrangThaiTaiKhoan() == null
                || (!STATUS_HOAT_DONG.equalsIgnoreCase(taiKhoan.getTrangThaiTaiKhoan())
                && !STATUS_KHOA.equalsIgnoreCase(taiKhoan.getTrangThaiTaiKhoan()))) {
            return "Trạng thái tài khoản không hợp lệ.";
        }

        if (isCreate && taiKhoan.getNgayTao() == null) {
            taiKhoan.setNgayTao(LocalDateTime.now());
        }

        taiKhoan.setTenDangNhap(taiKhoan.getTenDangNhap().trim());

        if (!isCreate && taiKhoanDao.findById(taiKhoan.getMaTaiKhoan()) == null) {
            return "Tài khoản không tồn tại để cập nhật.";
        }

        TaiKhoan trungTenDangNhap = taiKhoanDao.findByTenDangNhap(taiKhoan.getTenDangNhap());
        if (trungTenDangNhap != null) {
            if (isCreate || !trungTenDangNhap.getMaTaiKhoan().equals(taiKhoan.getMaTaiKhoan())) {
                return "Tên đăng nhập đã tồn tại.";
            }
        }

        if (coNhanVien) {
            Integer maNhanVien = taiKhoan.getNhanVien().getMaNhanVien();
            TaiKhoan tkNhanVien = taiKhoanDao.findByMaNhanVien(maNhanVien);
            if (tkNhanVien != null) {
                if (isCreate || !tkNhanVien.getMaTaiKhoan().equals(taiKhoan.getMaTaiKhoan())) {
                    return "Nhân viên này đã có tài khoản.";
                }
            }
            taiKhoan.setKhachHang(null);
        }

        if (coKhachHang) {
            Integer maKhachHang = taiKhoan.getKhachHang().getMaKhachHang();
            TaiKhoan tkKhachHang = taiKhoanDao.findByMaKhachHang(maKhachHang);
            if (tkKhachHang != null) {
                if (isCreate || !tkKhachHang.getMaTaiKhoan().equals(taiKhoan.getMaTaiKhoan())) {
                    return "Khách hàng này đã có tài khoản.";
                }
            }
            taiKhoan.setNhanVien(null);
        }

        return null;
    }

    /* =========================
       DTO / FORM MAPPING
       ========================= */

    private TaiKhoan buildEntityFromForm(TaiKhoanFormDTO formDTO, boolean isCreate) {
        if (formDTO == null) {
            return null;
        }

        TaiKhoan taiKhoan;
        if (isCreate) {
            taiKhoan = new TaiKhoan();
        } else {
            taiKhoan = taiKhoanDao.findById(formDTO.getMaTaiKhoan());
            if (taiKhoan == null) {
                return null;
            }
        }

        if (formDTO.getMaTaiKhoan() != null) {
            taiKhoan.setMaTaiKhoan(formDTO.getMaTaiKhoan());
        }

        taiKhoan.setTenDangNhap(trimToNull(formDTO.getTenDangNhap()));
        taiKhoan.setLoaiTaiKhoan(trimToNull(formDTO.getLoaiTaiKhoan()));
        taiKhoan.setTrangThaiTaiKhoan(trimToNull(formDTO.getTrangThaiTaiKhoan()));

        if (isCreate || !isBlank(formDTO.getMatKhau())) {
            taiKhoan.setMatKhau(trimToNull(formDTO.getMatKhau()));
        }

        String normalizedRole = normalizeLoaiTaiKhoan(formDTO.getLoaiTaiKhoan());

        if (ROLE_NHAN_VIEN.equalsIgnoreCase(normalizedRole)) {
            if (formDTO.getMaNhanVien() != null) {
                NhanVien nhanVien = new NhanVien();
                nhanVien.setMaNhanVien(formDTO.getMaNhanVien());
                taiKhoan.setNhanVien(nhanVien);
            } else {
                taiKhoan.setNhanVien(null);
            }
            taiKhoan.setKhachHang(null);
        } else if (ROLE_KHACH_HANG.equalsIgnoreCase(normalizedRole)) {
            if (formDTO.getMaKhachHang() != null) {
                KhachHang khachHang = new KhachHang();
                khachHang.setMaKhachHang(formDTO.getMaKhachHang());
                taiKhoan.setKhachHang(khachHang);
            } else {
                taiKhoan.setKhachHang(null);
            }
            taiKhoan.setNhanVien(null);
        }

        return taiKhoan;
    }

    private TaiKhoanDTO toDTO(TaiKhoan taiKhoan) {
        TaiKhoanDTO dto = new TaiKhoanDTO();
        dto.setMaTaiKhoan(taiKhoan.getMaTaiKhoan());
        dto.setTenDangNhap(taiKhoan.getTenDangNhap());
        dto.setLoaiTaiKhoan(taiKhoan.getLoaiTaiKhoan());
        dto.setTrangThaiTaiKhoan(taiKhoan.getTrangThaiTaiKhoan());
        dto.setNgayTao(taiKhoan.getNgayTao());
        dto.setTenNguoiSohuu(extractOwnerName(taiKhoan));
        return dto;
    }

    private String extractOwnerName(TaiKhoan taiKhoan) {
        Object owner = null;

        if (taiKhoan.getNhanVien() != null) {
            owner = taiKhoan.getNhanVien();
        } else if (taiKhoan.getKhachHang() != null) {
            owner = taiKhoan.getKhachHang();
        }

        if (owner == null) {
            return null;
        }

        String[] candidateMethods = {
                "getHoTen",
                "getTen",
                "getTenNhanVien",
                "getTenKhachHang",
                "getHoVaTen"
        };

        for (String methodName : candidateMethods) {
            try {
                Method method = owner.getClass().getMethod(methodName);
                Object value = method.invoke(owner);
                if (value != null && !value.toString().trim().isEmpty()) {
                    return value.toString().trim();
                }
            } catch (Exception ignored) {
            }
        }

        return owner.toString();
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

    private String normalizeLoaiTaiKhoan(String value) {
        if (value == null) {
            return null;
        }
        if (value.equalsIgnoreCase("NhanVien") || value.equalsIgnoreCase("NHAN_VIEN")) {
            return ROLE_NHAN_VIEN;
        }
        if (value.equalsIgnoreCase("KhachHang") || value.equalsIgnoreCase("KHACH_HANG")) {
            return ROLE_KHACH_HANG;
        }
        return value.trim();
    }

    private String normalizeTaiKhoanStatus(Object raw) {
        if (raw == null) {
            return null;
        }
        String value = raw.toString().trim();
        if (value.equalsIgnoreCase("Hoạt động") || value.equalsIgnoreCase("HOAT_DONG")) {
            return STATUS_HOAT_DONG;
        }
        if (value.equalsIgnoreCase("Khóa")
                || value.equalsIgnoreCase("BI_KHOA")
                || value.equalsIgnoreCase("NGUNG_SU_DUNG")) {
            return STATUS_KHOA;
        }
        return value;
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