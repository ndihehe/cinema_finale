package org.example.cinema_finale.service;

import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.entity.VaiTro;
import org.example.cinema_finale.util.SessionManager;

public class AuthService {

    private final TaiKhoanService taiKhoanService;

    public AuthService() {
        this.taiKhoanService = new TaiKhoanService();
    }

    public AuthService(TaiKhoanService taiKhoanService) {
        this.taiKhoanService = taiKhoanService;
    }

    /**
     * Đăng nhập và lưu session hiện tại.
     *
     * @param tenDangNhap tên đăng nhập
     * @param matKhau mật khẩu
     * @return thông báo kết quả để UI hiển thị
     */
    public String login(String tenDangNhap, String matKhau) {
        if (isBlank(tenDangNhap) || isBlank(matKhau)) {
            return "Tên đăng nhập và mật khẩu không được để trống.";
        }

        TaiKhoan taiKhoan = taiKhoanService.authenticate(
                tenDangNhap.trim(),
                matKhau.trim()
        );

        if (taiKhoan == null) {
            SessionManager.clearSession();
            return "Tên đăng nhập, mật khẩu hoặc trạng thái tài khoản không hợp lệ.";
        }

        SessionManager.setCurrentTaiKhoan(taiKhoan);
        return "Đăng nhập thành công.";
    }

    /**
     * Đăng xuất khỏi phiên hiện tại.
     */
    public void logout() {
        SessionManager.clearSession();
    }

    /**
     * Lấy tài khoản đang đăng nhập.
     */
    public TaiKhoan getCurrentUser() {
        return SessionManager.getCurrentTaiKhoan();
    }

    /**
     * Lấy vai trò hiện tại.
     */
    public VaiTro getCurrentRole() {
        return SessionManager.getCurrentVaiTro();
    }

    /**
     * Kiểm tra đã đăng nhập chưa.
     */
    public boolean isLoggedIn() {
        return SessionManager.isLoggedIn();
    }

    /**
     * Kiểm tra tài khoản hiện tại có phải staff không.
     */
    public boolean isStaff() {
        return SessionManager.isStaff();
    }

    /**
     * Kiểm tra tài khoản hiện tại có phải customer không.
     */
    public boolean isCustomer() {
        return SessionManager.isCustomer();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}