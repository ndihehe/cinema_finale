package org.example.cinema_finale.util;

import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.entity.VaiTro;

public class SessionManager {

    private static TaiKhoan currentTaiKhoan;

    /**
     * Lưu tài khoản đang đăng nhập vào phiên làm việc hiện tại.
     *
     * @param taiKhoan tài khoản đang đăng nhập
     */
    public static void setCurrentTaiKhoan(TaiKhoan taiKhoan) {
        currentTaiKhoan = taiKhoan;
    }

    /**
     * Lấy tài khoản đang đăng nhập.
     *
     * @return tài khoản hiện tại
     */
    public static TaiKhoan getCurrentTaiKhoan() {
        return currentTaiKhoan;
    }

    /**
     * Xóa thông tin phiên đăng nhập hiện tại.
     */
    public static void clearSession() {
        currentTaiKhoan = null;
    }

    /**
     * Kiểm tra hiện tại đã có người đăng nhập hay chưa.
     *
     * @return true nếu đã đăng nhập, false nếu chưa đăng nhập
     */
    public static boolean isLoggedIn() {
        return currentTaiKhoan != null;
    }

    /**
     * Kiểm tra tài khoản hiện tại có vai trò STAFF hay không.
     *
     * @return true nếu là staff, false nếu không phải
     */
    public static boolean isStaff() {
        return currentTaiKhoan != null && currentTaiKhoan.getVaiTro() == VaiTro.STAFF;
    }

    /**
     * Kiểm tra tài khoản hiện tại có vai trò USER hay không.
     *
     * @return true nếu là user, false nếu không phải
     */
    public static boolean isUser() {
        return currentTaiKhoan != null && currentTaiKhoan.getVaiTro() == VaiTro.USER;
    }
}