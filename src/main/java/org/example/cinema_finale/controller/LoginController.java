package org.example.cinema_finale.controller;

import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;

import org.example.cinema_finale.controller.user.UserBookingController;
import org.example.cinema_finale.dto.LoginDTO;
import org.example.cinema_finale.dto.LoginResultDTO;
import org.example.cinema_finale.service.AuthService;
import org.example.cinema_finale.view.frame.LoginFrame;
import org.example.cinema_finale.view.frame.StaffMainFrame;
import org.example.cinema_finale.view.panel.login.LoginPanel;
import org.example.cinema_finale.view.user.UserFrame;

public class LoginController {

    private final LoginFrame frame;
    private final LoginPanel panel;
    private final AuthService authService;

    public LoginController(LoginFrame frame, LoginPanel panel) {
        this.frame = frame;
        this.panel = panel;
        this.authService = new AuthService();
        bindEvents();
    }

    private void bindEvents() {
        panel.addLoginListener(e -> handleLogin());
    }

    private void handleLogin() {
        LoginDTO dto = new LoginDTO();
        dto.setTenDangNhap(panel.getTenDangNhap());
        dto.setMatKhau(panel.getMatKhau());

        LoginResultDTO result = authService.login(dto);

        if (!result.isSuccess()) {
            panel.showMessage(result.getMessage(), "Đăng nhập thất bại", JOptionPane.ERROR_MESSAGE);
            panel.clearPassword();
            return;
        }

        String role = result.getRole() == null ? "" : result.getRole().trim();

        if ("NhanVien".equalsIgnoreCase(role)) {
            frame.dispose();
            SwingUtilities.invokeLater(() -> {
                StaffMainFrame staffMainFrame = new StaffMainFrame(
                        () -> SwingUtilities.invokeLater(() -> new LoginFrame().setVisible(true))
                );
                staffMainFrame.setVisible(true);
            });
            return;
        }

        if ("KhachHang".equalsIgnoreCase(role)
                || "Khach_Hang".equalsIgnoreCase(role)
                || "Customer".equalsIgnoreCase(role)
                || "User".equalsIgnoreCase(role)) {
            frame.dispose();
            SwingUtilities.invokeLater(() -> {
                UserFrame userFrame = new UserFrame();
                UserBookingController controller = new UserBookingController(userFrame);
                userFrame.getRootPane().putClientProperty(UserBookingController.class.getName(), controller);
                userFrame.setVisible(true);
            });
            return;
        }

        authService.logout();
        panel.showMessage("Vai trò tài khoản không được hỗ trợ: " + role,
                "Đăng nhập thất bại", JOptionPane.ERROR_MESSAGE);
    }
}