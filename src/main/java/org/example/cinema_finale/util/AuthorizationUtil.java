package org.example.cinema_finale.util;

public class AuthorizationUtil {

    /**
     * Yêu cầu người dùng phải đăng nhập trước khi thực hiện chức năng.
     */
    public static void requireLogin() {
        if (!SessionManager.isLoggedIn()) {
            throw new SecurityException("Bạn chưa đăng nhập.");
        }
    }

    /**
     * Yêu cầu tài khoản hiện tại phải có quyền STAFF.
     */
    public static void requireStaff() {
        if (!SessionManager.isStaff()) {
            throw new SecurityException("Bạn không có quyền thực hiện chức năng này.");
        }
    }

    /**
     * Yêu cầu tài khoản hiện tại phải có quyền USER.
     */
    public static void requireUser() {
        if (!SessionManager.isUser()) {
            throw new SecurityException("Chức năng này chỉ dành cho khách hàng.");
        }
    }
}