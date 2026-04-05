package org.example.cinema_finale.util;

public final class AuthorizationUtil {

    private AuthorizationUtil() {
    }

    /**
     * Yêu cầu người dùng phải đăng nhập trước khi thực hiện chức năng.
     */
    public static void requireLogin() {
        if (!SessionManager.isLoggedIn()) {
            throw new SecurityException("Bạn chưa đăng nhập.");
        }

        if (!SessionManager.isActiveAccount()) {
            throw new SecurityException("Tài khoản hiện tại không còn hoạt động.");
        }
    }

    /**
     * Yêu cầu tài khoản hiện tại phải có quyền nhân viên.
     */
    public static void requireStaff() {
        requireLogin();

        if (!SessionManager.isStaff()) {
            throw new SecurityException("Bạn không có quyền thực hiện chức năng này.");
        }
    }

    /**
     * Yêu cầu tài khoản hiện tại phải là khách hàng.
     */
    public static void requireCustomer() {
        requireLogin();

        if (!SessionManager.isCustomer()) {
            throw new SecurityException("Chức năng này chỉ dành cho khách hàng.");
        }
    }

    /**
     * Yêu cầu tài khoản hiện tại là nhân viên hoặc khách hàng.
     */
    public static void requireStaffOrCustomer() {
        requireLogin();

        if (!SessionManager.isStaff() && !SessionManager.isCustomer()) {
            throw new SecurityException("Bạn không có quyền thực hiện chức năng này.");
        }
    }

    /**
     * Giữ lại để tương thích với code cũ.
     */
    public static void requireUser() {
        requireCustomer();
    }
}
