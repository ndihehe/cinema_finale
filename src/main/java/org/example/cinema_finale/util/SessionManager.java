package org.example.cinema_finale.util;

import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.enums.VaiTro;

public final class SessionManager {

    private static TaiKhoan currentTaiKhoan;

    private SessionManager() {
    }

    /**
     * Lưu tài khoản đang đăng nhập vào phiên làm việc hiện tại.
     */
    public static void setCurrentTaiKhoan(TaiKhoan taiKhoan) {
        currentTaiKhoan = taiKhoan;
    }

    /**
     * Lấy tài khoản đang đăng nhập.
     */
    public static TaiKhoan getCurrentTaiKhoan() {
        return currentTaiKhoan;
    }

    /**
     * Lấy vai trò hiện tại từ cột loaiTaiKhoan trong entity TaiKhoan.
     * DB hiện dùng giá trị: "NhanVien" hoặc "KhachHang".
     */
    public static VaiTro getCurrentVaiTro() {
        if (currentTaiKhoan == null) {
            return null;
        }

        String loaiTaiKhoan = currentTaiKhoan.getLoaiTaiKhoan();
        if (loaiTaiKhoan == null) {
            return null;
        }

        String normalized = loaiTaiKhoan.trim().toLowerCase();
        return switch (normalized) {
            case "nhanvien", "nhânviên", "nhan_vien", "staff" -> VaiTro.NHAN_VIEN;
            case "khachhang", "kháchhàng", "khach_hang", "customer", "user" -> VaiTro.KHACH_HANG;
            default -> null;
        };
    }

    /**
     * Xóa thông tin phiên đăng nhập hiện tại.
     */
    public static void clearSession() {
        currentTaiKhoan = null;
    }

    /**
     * Kiểm tra hiện tại đã có người đăng nhập hay chưa.
     */
    public static boolean isLoggedIn() {
        return currentTaiKhoan != null;
    }

    /**
     * Kiểm tra tài khoản hiện tại có đang hoạt động hay không.
     * Với schema mới, trạng thái hoạt động được lưu bằng String trong TaiKhoan.trangThaiTaiKhoan.
     */
    public static boolean isActiveAccount() {
        return currentTaiKhoan != null
                && currentTaiKhoan.getTrangThaiTaiKhoan() != null
                && "Hoạt động".equalsIgnoreCase(currentTaiKhoan.getTrangThaiTaiKhoan().trim());
    }

    /**
     * Kiểm tra tài khoản hiện tại có vai trò nhân viên hay không.
     */
    public static boolean isStaff() {
        return getCurrentVaiTro() == VaiTro.NHAN_VIEN;
    }

    /**
     * Kiểm tra tài khoản hiện tại có vai trò khách hàng hay không.
     */
    public static boolean isCustomer() {
        return getCurrentVaiTro() == VaiTro.KHACH_HANG;
    }

    /**
     * Giữ lại để tương thích với code cũ.
     */
    public static boolean isUser() {
        return isCustomer();
    }
}
