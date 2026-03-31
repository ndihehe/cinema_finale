package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.TaiKhoanDao;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.time.LocalDateTime;
import java.util.List;

public class TaiKhoanService {

    private final TaiKhoanDao taiKhoanDao;

    public TaiKhoanService() {
        this.taiKhoanDao = new TaiKhoanDao();
    }

    public TaiKhoanService(TaiKhoanDao taiKhoanDao) {
        this.taiKhoanDao = taiKhoanDao;
    }

    public List<TaiKhoan> getAllTaiKhoan() {
        return taiKhoanDao.findAll();
    }

    public List<TaiKhoan> getAllActiveTaiKhoan() {
        return taiKhoanDao.findAllActive();
    }

    public TaiKhoan getTaiKhoanById(String maTk) {
        Integer id = parseId(maTk);
        return id == null ? null : taiKhoanDao.findById(id);
    }

    public TaiKhoan getByTenDangNhap(String tenDangNhap) {
        if (isBlank(tenDangNhap)) {
            return null;
        }
        return taiKhoanDao.findByTenDangNhap(tenDangNhap.trim());
    }

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

        boolean result = taiKhoanDao.updateTrangThai(id, status);
        return result ? "Cập nhật trạng thái tài khoản thành công." : "Cập nhật trạng thái tài khoản thất bại.";
    }

    public String lockTaiKhoan(String maTk) {
        return updateTrangThai(maTk, "Khóa");
    }

    public String deactivateTaiKhoan(String maTk) {
        return updateTrangThai(maTk, "Khóa");
    }

    public TaiKhoan authenticate(String tenDangNhap, String matKhau) {
        if (isBlank(tenDangNhap) || isBlank(matKhau)) {
            return null;
        }

        TaiKhoan taiKhoan = taiKhoanDao.findByTenDangNhap(tenDangNhap.trim());
        if (taiKhoan == null) {
            return null;
        }

        if (!"Hoạt động".equalsIgnoreCase(taiKhoan.getTrangThaiTaiKhoan())) {
            return null;
        }

        if (!matKhau.equals(taiKhoan.getMatKhau())) {
            return null;
        }

        return taiKhoan;
    }

    public String changePassword(String maTk, String matKhauMoi) {
        Integer id = parseId(maTk);
        if (id == null) {
            return "Mã tài khoản không hợp lệ.";
        }

        if (isBlank(matKhauMoi)) {
            return "Mật khẩu mới không được để trống.";
        }

        TaiKhoan taiKhoan = taiKhoanDao.findById(id);
        if (taiKhoan == null) {
            return "Tài khoản không tồn tại.";
        }

        taiKhoan.setMatKhau(matKhauMoi.trim());
        boolean result = taiKhoanDao.update(taiKhoan);
        return result ? "Đổi mật khẩu thành công." : "Đổi mật khẩu thất bại.";
    }

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

        boolean coNhanVien = taiKhoan.getNhanVien() != null && taiKhoan.getNhanVien().getMaNhanVien() != null;
        boolean coKhachHang = taiKhoan.getKhachHang() != null && taiKhoan.getKhachHang().getMaKhachHang() != null;

        if (coNhanVien == coKhachHang) {
            return "Tài khoản phải gắn đúng một đối tượng: nhân viên hoặc khách hàng.";
        }

        if (isBlank(taiKhoan.getLoaiTaiKhoan())) {
            taiKhoan.setLoaiTaiKhoan(coNhanVien ? "NhanVien" : "KhachHang");
        } else {
            taiKhoan.setLoaiTaiKhoan(normalizeLoaiTaiKhoan(taiKhoan.getLoaiTaiKhoan()));
        }

        if (isBlank(taiKhoan.getTrangThaiTaiKhoan())) {
            taiKhoan.setTrangThaiTaiKhoan("Hoạt động");
        } else {
            taiKhoan.setTrangThaiTaiKhoan(normalizeTaiKhoanStatus(taiKhoan.getTrangThaiTaiKhoan()));
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
        if (value.equalsIgnoreCase("NhanVien") || value.equalsIgnoreCase("NHAN_VIEN")) return "NhanVien";
        if (value.equalsIgnoreCase("KhachHang") || value.equalsIgnoreCase("KHACH_HANG")) return "KhachHang";
        return value.trim();
    }

    private String normalizeTaiKhoanStatus(Object raw) {
        if (raw == null) {
            return null;
        }
        String value = raw.toString().trim();
        if (value.equalsIgnoreCase("Hoạt động") || value.equalsIgnoreCase("HOAT_DONG")) return "Hoạt động";
        if (value.equalsIgnoreCase("Khóa") || value.equalsIgnoreCase("BI_KHOA") || value.equalsIgnoreCase("NGUNG_SU_DUNG")) return "Khóa";
        return value;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
