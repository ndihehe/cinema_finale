package org.example.cinema_finale.view.frame;

import java.awt.BorderLayout;
import java.awt.CardLayout;
import java.awt.Dimension;
import java.util.HashSet;
import java.util.Set;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;

import org.example.cinema_finale.controller.KhachHangController;
import org.example.cinema_finale.controller.KhuyenMaiController;
import org.example.cinema_finale.controller.NhanVienController;
import org.example.cinema_finale.controller.PhimController;
import org.example.cinema_finale.controller.PhongChieuController;
import org.example.cinema_finale.controller.SuatChieuController;
import org.example.cinema_finale.controller.ThongKeController;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.util.AppTheme;
import org.example.cinema_finale.util.AuthorizationUtil;
import org.example.cinema_finale.util.SessionManager;
import org.example.cinema_finale.view.panel.staff.KhachHangPanel;
import org.example.cinema_finale.view.panel.staff.KhuyenMaiPanel;
import org.example.cinema_finale.view.panel.staff.NhanVienPanel;
import org.example.cinema_finale.view.panel.staff.PhimPanel;
import org.example.cinema_finale.view.panel.staff.PhongChieuPanel;
import org.example.cinema_finale.view.panel.staff.StaffHomePanel;
import org.example.cinema_finale.view.panel.staff.StaffStatusBar;
import org.example.cinema_finale.view.panel.staff.StaffTopMenuPanel;
import org.example.cinema_finale.view.panel.staff.SuatChieuPanel;
import org.example.cinema_finale.view.panel.staff.ThongKePanel;

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

        setTitle("Cinema Finale - Quản lý rạp");
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


        PhimPanel phimPanel = new PhimPanel();
        new PhimController(phimPanel);
        registerScreen(StaffTopMenuPanel.PHIM, phimPanel);

        PhongChieuPanel phongChieuPanel = new PhongChieuPanel();
        new PhongChieuController(phongChieuPanel);
        registerScreen(StaffTopMenuPanel.PHONG_CHIEU, phongChieuPanel);

        NhanVienPanel nhanVienPanel = new NhanVienPanel();
        new NhanVienController(nhanVienPanel);
        registerScreen(StaffTopMenuPanel.NHAN_VIEN, nhanVienPanel);

        SuatChieuPanel suatChieuPanel = new SuatChieuPanel();
        new SuatChieuController(suatChieuPanel);
        registerScreen(StaffTopMenuPanel.SUAT_CHIEU, suatChieuPanel);

        KhachHangPanel khachHangPanel = new KhachHangPanel();
        new KhachHangController(khachHangPanel);
        registerScreen(StaffTopMenuPanel.KHACH_HANG, khachHangPanel);

        KhuyenMaiPanel khuyenMaiPanel = new KhuyenMaiPanel();
        new KhuyenMaiController(khuyenMaiPanel);
        registerScreen(StaffTopMenuPanel.KHUYEN_MAI, khuyenMaiPanel);

        ThongKePanel thongKePanel = new ThongKePanel();
        new ThongKeController(thongKePanel);
        registerScreen(StaffTopMenuPanel.THONG_KE, thongKePanel);
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

            if (StaffTopMenuPanel.TOGGLE_THEME.equals(command)) {
                AppTheme.toggleTheme();
                dispose();
                StaffMainFrame refreshed = new StaffMainFrame(logoutCallback);
                refreshed.setVisible(true);
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