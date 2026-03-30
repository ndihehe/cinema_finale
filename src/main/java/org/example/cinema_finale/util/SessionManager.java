package org.example.cinema_finale.util;

import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.entity.VaiTro;
import org.example.cinema_finale.enums.TrangThaiTaiKhoan;

public final class SessionManager {

    private static TaiKhoan currentTaiKhoan;

    private SessionManager() {
    }

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
     * Lấy vai trò hiện tại.
     *
     * @return vai trò hiện tại, null nếu chưa đăng nhập
     */
    public static VaiTro getCurrentVaiTro() {
        return currentTaiKhoan != null ? currentTaiKhoan.getVaiTro() : null;
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
     * Kiểm tra tài khoản hiện tại có đang hoạt động hay không.
     *
     * @return true nếu tài khoản đang hoạt động
     */
    public static boolean isActiveAccount() {
        return currentTaiKhoan != null
                && currentTaiKhoan.getTrangThaiTaiKhoan() == TrangThaiTaiKhoan.HOAT_DONG;
    }

    /**
     * Kiểm tra tài khoản hiện tại có vai trò STAFF hay không.
     *
     * @return true nếu là staff
     */
    public static boolean isStaff() {
        return currentTaiKhoan != null && currentTaiKhoan.isStaff();
    }

    /**
     * Kiểm tra tài khoản hiện tại có vai trò CUSTOMER hay không.
     *
     * @return true nếu là khách hàng
     */
    public static boolean isCustomer() {
        return currentTaiKhoan != null && currentTaiKhoan.isCustomer();
    }

    /**
     * Giữ lại để tương thích với code cũ.
     *
     * @return true nếu là khách hàng
     */
    public static boolean isUser() {
        return isCustomer();
    }
}