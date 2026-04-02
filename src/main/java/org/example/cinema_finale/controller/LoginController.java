package org.example.cinema_finale.controller;

import org.example.cinema_finale.dto.LoginDTO;
import org.example.cinema_finale.dto.LoginResultDTO;
import org.example.cinema_finale.service.AuthService;
import org.example.cinema_finale.view.frame.LoginFrame;
import org.example.cinema_finale.view.frame.StaffMainFrame;
import org.example.cinema_finale.view.panel.login.LoginPanel;

import javax.swing.*;

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

        if ("NhanVien".equalsIgnoreCase(result.getRole())) {
            frame.dispose();
            SwingUtilities.invokeLater(() -> {
                StaffMainFrame staffMainFrame = new StaffMainFrame(
                        () -> SwingUtilities.invokeLater(() -> new LoginFrame().setVisible(true))
                );
                staffMainFrame.setVisible(true);
            });
            return;
        }

        authService.logout();
        panel.showMessage(
                "Tài khoản này chưa được chuyển vào màn hình khách hàng.",
                "Chưa hỗ trợ",
                JOptionPane.INFORMATION_MESSAGE
        );
    }
}