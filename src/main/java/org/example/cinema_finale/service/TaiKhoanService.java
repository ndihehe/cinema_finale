package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.TaiKhoanDao;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.enums.TrangThaiTaiKhoan;
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
        if (isBlank(maTk)) {
            return null;
        }
        return taiKhoanDao.findById(maTk.trim());
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

    public String updateTrangThai(String maTk, TrangThaiTaiKhoan trangThaiTaiKhoan) {
        AuthorizationUtil.requireStaff();

        if (isBlank(maTk)) {
            return "Mã tài khoản không được để trống.";
        }

        if (trangThaiTaiKhoan == null) {
            return "Trạng thái tài khoản không hợp lệ.";
        }

        TaiKhoan taiKhoan = taiKhoanDao.findById(maTk.trim());
        if (taiKhoan == null) {
            return "Tài khoản không tồn tại.";
        }

        boolean result = taiKhoanDao.updateTrangThai(maTk.trim(), trangThaiTaiKhoan);
        return result ? "Cập nhật trạng thái tài khoản thành công."
                : "Cập nhật trạng thái tài khoản thất bại.";
    }

    public String lockTaiKhoan(String maTk) {
        return updateTrangThai(maTk, TrangThaiTaiKhoan.BI_KHOA);
    }

    public String deactivateTaiKhoan(String maTk) {
        return updateTrangThai(maTk, TrangThaiTaiKhoan.NGUNG_SU_DUNG);
    }

    /**
     * Login lõi.
     * Nếu dự án của bạn băm mật khẩu thì thay đoạn equals bằng check hash.
     */
    public TaiKhoan authenticate(String tenDangNhap, String matKhau) {
        if (isBlank(tenDangNhap) || isBlank(matKhau)) {
            return null;
        }

        TaiKhoan taiKhoan = taiKhoanDao.findByTenDangNhap(tenDangNhap.trim());
        if (taiKhoan == null) {
            return null;
        }

        if (taiKhoan.getTrangThaiTaiKhoan() != TrangThaiTaiKhoan.HOAT_DONG) {
            return null;
        }

        if (!matKhau.equals(taiKhoan.getMatKhau())) {
            return null;
        }

        LocalDateTime now = LocalDateTime.now();
        taiKhoan.setLanDangNhapCuoi(now);
        taiKhoanDao.updateLastLogin(taiKhoan.getMaTk(), now);

        return taiKhoan;
    }

    public String changePassword(String maTk, String matKhauMoi) {
        if (isBlank(maTk)) {
            return "Mã tài khoản không được để trống.";
        }

        if (isBlank(matKhauMoi)) {
            return "Mật khẩu mới không được để trống.";
        }

        TaiKhoan taiKhoan = taiKhoanDao.findById(maTk.trim());
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

        if (isBlank(taiKhoan.getMaTk())) {
            return "Mã tài khoản không được để trống.";
        }

        if (isBlank(taiKhoan.getTenDangNhap())) {
            return "Tên đăng nhập không được để trống.";
        }

        if (isCreate && isBlank(taiKhoan.getMatKhau())) {
            return "Mật khẩu không được để trống.";
        }

        if (taiKhoan.getTrangThaiTaiKhoan() == null) {
            return "Trạng thái tài khoản không được để trống.";
        }

        taiKhoan.setMaTk(taiKhoan.getMaTk().trim());
        taiKhoan.setTenDangNhap(taiKhoan.getTenDangNhap().trim());

        boolean coNhanVien = taiKhoan.getNhanVien() != null
                && !isBlank(taiKhoan.getNhanVien().getMaNv());

        boolean coKhachHang = taiKhoan.getKhachHang() != null
                && !isBlank(taiKhoan.getKhachHang().getMaKh());

        if (coNhanVien == coKhachHang) {
            return "Tài khoản phải gắn đúng một đối tượng: nhân viên hoặc khách hàng.";
        }

        if (isCreate && taiKhoanDao.existsById(taiKhoan.getMaTk())) {
            return "Mã tài khoản đã tồn tại.";
        }

        if (!isCreate && taiKhoanDao.findById(taiKhoan.getMaTk()) == null) {
            return "Tài khoản không tồn tại để cập nhật.";
        }

        TaiKhoan trungTenDangNhap = taiKhoanDao.findByTenDangNhap(taiKhoan.getTenDangNhap());
        if (trungTenDangNhap != null && !trungTenDangNhap.getMaTk().equals(taiKhoan.getMaTk())) {
            return "Tên đăng nhập đã tồn tại.";
        }

        if (coNhanVien) {
            String maNv = taiKhoan.getNhanVien().getMaNv().trim();
            TaiKhoan tkNhanVien = taiKhoanDao.findByMaNhanVien(maNv);
            if (tkNhanVien != null && !tkNhanVien.getMaTk().equals(taiKhoan.getMaTk())) {
                return "Nhân viên này đã có tài khoản.";
            }
            taiKhoan.setKhachHang(null);
        }

        if (coKhachHang) {
            String maKh = taiKhoan.getKhachHang().getMaKh().trim();
            TaiKhoan tkKhachHang = taiKhoanDao.findByMaKhachHang(maKh);
            if (tkKhachHang != null && !tkKhachHang.getMaTk().equals(taiKhoan.getMaTk())) {
                return "Khách hàng này đã có tài khoản.";
            }
            taiKhoan.setNhanVien(null);
        }

        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}