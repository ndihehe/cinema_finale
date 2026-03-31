package org.example.cinema_finale.view.frame;

import org.example.cinema_finale.dao.TaiKhoanDao;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.util.SessionManager;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;

public class LoginFrame extends JFrame {

    private final JTextField txtTenDangNhap;
    private final JPasswordField txtMatKhau;
    private final JButton btnDangNhap;

    public LoginFrame() {
        setTitle("Đăng nhập hệ thống");
        setSize(420, 250);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);

        JPanel root = new JPanel(new BorderLayout());
        root.setBorder(new EmptyBorder(20, 20, 20, 20));
        setContentPane(root);

        JLabel lblTitle = new JLabel("ĐĂNG NHẬP HỆ THỐNG", SwingConstants.CENTER);
        lblTitle.setFont(new Font("Segoe UI", Font.BOLD, 20));
        root.add(lblTitle, BorderLayout.NORTH);

        JPanel formPanel = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(8, 8, 8, 8);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        JLabel lblUser = new JLabel("Tên đăng nhập:");
        JLabel lblPass = new JLabel("Mật khẩu:");

        txtTenDangNhap = new JTextField(20);
        txtMatKhau = new JPasswordField(20);
        btnDangNhap = new JButton("Đăng nhập");

        gbc.gridx = 0;
        gbc.gridy = 0;
        formPanel.add(lblUser, gbc);

        gbc.gridx = 1;
        formPanel.add(txtTenDangNhap, gbc);

        gbc.gridx = 0;
        gbc.gridy = 1;
        formPanel.add(lblPass, gbc);

        gbc.gridx = 1;
        formPanel.add(txtMatKhau, gbc);

        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        formPanel.add(btnDangNhap, gbc);

        root.add(formPanel, BorderLayout.CENTER);

        bindEvents();
    }

    private void bindEvents() {
        btnDangNhap.addActionListener(e -> handleLogin());
        txtMatKhau.addActionListener(e -> handleLogin());
        txtTenDangNhap.addActionListener(e -> handleLogin());
    }

    private void handleLogin() {
        String tenDangNhap = txtTenDangNhap.getText().trim();
        String matKhau = new String(txtMatKhau.getPassword()).trim();

        if (tenDangNhap.isBlank() || matKhau.isBlank()) {
            JOptionPane.showMessageDialog(
                    this,
                    "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.",
                    "Thiếu thông tin",
                    JOptionPane.WARNING_MESSAGE
            );
            return;
        }

        TaiKhoanDao taiKhoanDao = new TaiKhoanDao();
        TaiKhoan taiKhoan = taiKhoanDao.findByTenDangNhap(tenDangNhap);

        if (taiKhoan == null) {
            JOptionPane.showMessageDialog(
                    this,
                    "Tài khoản không tồn tại.",
                    "Đăng nhập thất bại",
                    JOptionPane.ERROR_MESSAGE
            );
            return;
        }

        // Tạm so sánh plain text.
        // Nếu sau này DB lưu mật khẩu hash thì thay chỗ này bằng hàm verify password.
        if (taiKhoan.getMatKhau() == null || !taiKhoan.getMatKhau().equals(matKhau)) {
            JOptionPane.showMessageDialog(
                    this,
                    "Sai mật khẩu.",
                    "Đăng nhập thất bại",
                    JOptionPane.ERROR_MESSAGE
            );
            return;
        }

        SessionManager.setCurrentTaiKhoan(taiKhoan);

        if (!SessionManager.isActiveAccount()) {
            SessionManager.clearSession();
            JOptionPane.showMessageDialog(
                    this,
                    "Tài khoản hiện tại không còn hoạt động.",
                    "Không thể đăng nhập",
                    JOptionPane.ERROR_MESSAGE
            );
            return;
        }

        if (SessionManager.isStaff()) {
            dispose();
            SwingUtilities.invokeLater(() -> {
                StaffMainFrame staffMainFrame = new StaffMainFrame(() ->
                        SwingUtilities.invokeLater(() -> new LoginFrame().setVisible(true))
                );
                staffMainFrame.setVisible(true);
            });
            return;
        }

        // Sau này có thể đổi sang mở UserMainFrame / UserBookingFrame
        SessionManager.clearSession();
        JOptionPane.showMessageDialog(
                this,
                "Tài khoản này không phải nhân viên nên chưa được chuyển vào Staff MainFrame.",
                "Không đúng quyền truy cập",
                JOptionPane.INFORMATION_MESSAGE
        );
    }
}