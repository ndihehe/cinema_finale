package org.example.cinema_finale.view.frame;

import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.util.AuthorizationUtil;
import org.example.cinema_finale.util.SessionManager;
import org.example.cinema_finale.view.panel.staff.StaffHomePanel;
import org.example.cinema_finale.view.panel.staff.StaffStatusBar;
import org.example.cinema_finale.view.panel.staff.StaffTopMenuPanel;

import javax.swing.*;
import java.awt.*;
import java.util.HashSet;
import java.util.Set;

public class StaffMainFrame extends JFrame {

    private final CardLayout cardLayout;
    private final JPanel contentPanel;
    private final StaffTopMenuPanel topMenuPanel;
    private final StaffStatusBar statusBar;
    private final Set<String> registeredScreenKeys;
    private final Runnable logoutCallback;

    public StaffMainFrame() {
        this(null);
    }

    public StaffMainFrame(Runnable logoutCallback) {
        this.logoutCallback = logoutCallback;
        this.registeredScreenKeys = new HashSet<>();

        ensureStaffAccess();

        setTitle("Giao diện nhân viên quản lý");
        setSize(1280, 720);
        setMinimumSize(new Dimension(1100, 650));
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        // GÁN FINAL TRỰC TIẾP TẠI ĐÂY
        topMenuPanel = new StaffTopMenuPanel();
        statusBar = new StaffStatusBar();
        cardLayout = new CardLayout();
        contentPanel = new JPanel(cardLayout);

        registerScreen(StaffTopMenuPanel.HOME, new StaffHomePanel());

        add(topMenuPanel, BorderLayout.NORTH);
        add(contentPanel, BorderLayout.CENTER);
        add(statusBar, BorderLayout.SOUTH);

        bindEvents();
        loadCurrentUserInfo();
        showScreen(StaffTopMenuPanel.HOME);
    }

    private void ensureStaffAccess() {
        try {
            AuthorizationUtil.requireStaff();
        } catch (SecurityException e) {
            JOptionPane.showMessageDialog(
                    null,
                    e.getMessage(),
                    "Không thể mở giao diện quản lý",
                    JOptionPane.ERROR_MESSAGE
            );
            throw e;
        }
    }

    private void bindEvents() {
        topMenuPanel.addMenuListener(e -> {
            String command = e.getActionCommand();

            if (StaffTopMenuPanel.LOGOUT.equals(command)) {
                handleLogout();
                return;
            }

            if (registeredScreenKeys.contains(command)) {
                showScreen(command);
            } else {
                statusBar.setMessage("Chức năng " + command + " chưa được tích hợp.");
                JOptionPane.showMessageDialog(
                        this,
                        "Chức năng này chưa được gắn panel vào MainFrame.",
                        "Thông báo",
                        JOptionPane.INFORMATION_MESSAGE
                );
                showScreen(StaffTopMenuPanel.HOME);
            }
        });
    }

    private void loadCurrentUserInfo() {
        TaiKhoan taiKhoan = SessionManager.getCurrentTaiKhoan();
        String displayName = "Nhân viên";

        if (taiKhoan != null) {
            if (taiKhoan.getNhanVien() != null
                    && taiKhoan.getNhanVien().getHoTen() != null
                    && !taiKhoan.getNhanVien().getHoTen().isBlank()) {
                displayName = taiKhoan.getNhanVien().getHoTen().trim();
            } else if (taiKhoan.getTenDangNhap() != null
                    && !taiKhoan.getTenDangNhap().isBlank()) {
                displayName = taiKhoan.getTenDangNhap().trim();
            }
        }

        topMenuPanel.setCurrentUserName(displayName);
        statusBar.setMessage("Đang online: " + displayName);
    }

    private void handleLogout() {
        int confirm = JOptionPane.showConfirmDialog(
                this,
                "Bạn có chắc muốn đăng xuất không?",
                "Xác nhận đăng xuất",
                JOptionPane.YES_NO_OPTION,
                JOptionPane.QUESTION_MESSAGE
        );

        if (confirm != JOptionPane.YES_OPTION) {
            return;
        }

        SessionManager.clearSession();
        dispose();

        if (logoutCallback != null) {
            SwingUtilities.invokeLater(logoutCallback);
        }
    }

    public void registerScreen(String key, JPanel panel) {
        if (key == null || key.isBlank() || panel == null) {
            throw new IllegalArgumentException("Screen key và panel không được null/rỗng.");
        }

        contentPanel.add(panel, key);
        registeredScreenKeys.add(key);
    }

    public void showScreen(String key) {
        if (!registeredScreenKeys.contains(key)) {
            statusBar.setMessage("Màn hình " + key + " chưa tồn tại.");
            return;
        }

        cardLayout.show(contentPanel, key);
        statusBar.setMessage("Đang mở: " + key);
    }

    public StaffTopMenuPanel getTopMenuPanel() {
        return topMenuPanel;
    }

    public StaffStatusBar getStatusBar() {
        return statusBar;
    }
}