package org.example.cinema_finale.service;

import org.example.cinema_finale.dto.LoginDTO;
import org.example.cinema_finale.dto.LoginResultDTO;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.enums.VaiTro;
import org.example.cinema_finale.util.SessionManager;

public class AuthService {

    private final TaiKhoanService taiKhoanService;

    public AuthService() {
        this.taiKhoanService = new TaiKhoanService();
    }

    public AuthService(TaiKhoanService taiKhoanService) {
        this.taiKhoanService = taiKhoanService;
    }

    public LoginResultDTO login(LoginDTO dto) {
        if (dto == null) {
            SessionManager.clearSession();
            return LoginResultDTO.fail("Dữ liệu đăng nhập không hợp lệ.");
        }

        String tenDangNhap = dto.getTenDangNhap();
        String matKhau = dto.getMatKhau();

        if (isBlank(tenDangNhap) || isBlank(matKhau)) {
            SessionManager.clearSession();
            return LoginResultDTO.fail("Tên đăng nhập và mật khẩu không được để trống.");
        }

        TaiKhoan taiKhoan = taiKhoanService.authenticate(tenDangNhap.trim(), matKhau.trim());

        if (taiKhoan == null) {
            SessionManager.clearSession();
            return LoginResultDTO.fail("Tên đăng nhập, mật khẩu hoặc trạng thái tài khoản không hợp lệ.");
        }

        SessionManager.setCurrentTaiKhoan(taiKhoan);

        String role = taiKhoan.getLoaiTaiKhoan();
        String displayName = taiKhoan.getTenDangNhap();

        return LoginResultDTO.success("Đăng nhập thành công.", role, displayName);
    }

    public void logout() {
        SessionManager.clearSession();
    }

    public TaiKhoan getCurrentUser() {
        return SessionManager.getCurrentTaiKhoan();
    }

    public VaiTro getCurrentRole() {
        TaiKhoan current = getCurrentUser();
        return current == null ? null : VaiTro.fromDbValue(current.getLoaiTaiKhoan());
    }

    public boolean isLoggedIn() {
        return SessionManager.getCurrentTaiKhoan() != null;
    }

    public boolean isStaff() {
        TaiKhoan current = getCurrentUser();
        return current != null && "NhanVien".equalsIgnoreCase(current.getLoaiTaiKhoan());
    }

    public boolean isCustomer() {
        TaiKhoan current = getCurrentUser();
        return current != null && "KhachHang".equalsIgnoreCase(current.getLoaiTaiKhoan());
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}