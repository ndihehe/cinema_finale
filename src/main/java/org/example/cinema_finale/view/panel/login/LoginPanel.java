package org.example.cinema_finale.view.panel.login;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionListener;

public class LoginPanel extends JPanel {

    private final JTextField txtTenDangNhap = new JTextField(20);
    private final JPasswordField txtMatKhau = new JPasswordField(20);
    private final JButton btnDangNhap = new JButton("Đăng nhập");

    public LoginPanel() {
        setLayout(new BorderLayout());
        setBorder(new EmptyBorder(20, 20, 20, 20));

        JLabel lblTitle = new JLabel("ĐĂNG NHẬP HỆ THỐNG", SwingConstants.CENTER);
        lblTitle.setFont(new Font("Segoe UI", Font.BOLD, 20));
        add(lblTitle, BorderLayout.NORTH);

        JPanel formPanel = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(8, 8, 8, 8);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        gbc.gridx = 0;  
        gbc.gridy = 0;
        formPanel.add(new JLabel("Tên đăng nhập:"), gbc);

        gbc.gridx = 1;
        formPanel.add(txtTenDangNhap, gbc);

        gbc.gridx = 0;
        gbc.gridy = 1;
        formPanel.add(new JLabel("Mật khẩu:"), gbc);

        gbc.gridx = 1;
        formPanel.add(txtMatKhau, gbc);

        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        formPanel.add(btnDangNhap, gbc);

        add(formPanel, BorderLayout.CENTER);
    }

    public String getTenDangNhap() {
        return txtTenDangNhap.getText().trim();
    }

    public String getMatKhau() {
        return new String(txtMatKhau.getPassword()).trim();
    }

    public void addLoginListener(ActionListener listener) {
        btnDangNhap.addActionListener(listener);
        txtTenDangNhap.addActionListener(listener);
        txtMatKhau.addActionListener(listener);
    }

    public void showMessage(String message, String title, int messageType) {
        JOptionPane.showMessageDialog(this, message, title, messageType);
    }

    public void focusUsername() {
        txtTenDangNhap.requestFocusInWindow();
    }

    public void clearPassword() {
        txtMatKhau.setText("");
    }
}