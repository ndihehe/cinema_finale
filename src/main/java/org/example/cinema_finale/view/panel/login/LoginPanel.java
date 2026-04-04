package org.example.cinema_finale.view.panel.login;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;

import org.example.cinema_finale.util.AppTheme;

public class LoginPanel extends JPanel {

    private final JTextField txtTenDangNhap = new JTextField(20);
    private final JPasswordField txtMatKhau = new JPasswordField(20);
    private final JButton btnDangNhap = new JButton("Đăng nhập");

    public LoginPanel() {
        setLayout(new GridBagLayout());
        setBorder(new EmptyBorder(24, 24, 24, 24));
        setBackground(AppTheme.BG_APP);

        JPanel card = new JPanel(new BorderLayout(10, 12));
        card.setBorder(new EmptyBorder(18, 18, 18, 18));
        card.setBackground(AppTheme.BG_CARD);
        card.setPreferredSize(new Dimension(520, 220));

        JLabel lblTitle = new JLabel("ĐĂNG NHẬP HỆ THỐNG", SwingConstants.CENTER);
        lblTitle.setFont(new Font("Segoe UI", Font.BOLD, 20));
        lblTitle.setForeground(AppTheme.TEXT_PRIMARY);
        card.add(lblTitle, BorderLayout.NORTH);

        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setOpaque(false);
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(8, 8, 8, 8);
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.weightx = 1;

        gbc.gridx = 0;
        gbc.gridy = 0;
        JLabel lblUser = new JLabel("Tên đăng nhập:");
        lblUser.setForeground(AppTheme.TEXT_PRIMARY);
        formPanel.add(lblUser, gbc);

        gbc.gridx = 1;
        AppTheme.styleSearchField(txtTenDangNhap);
        txtTenDangNhap.setPreferredSize(new Dimension(260, 36));
        txtTenDangNhap.putClientProperty("JTextField.placeholderText", "Nhập tên đăng nhập");
        formPanel.add(txtTenDangNhap, gbc);

        gbc.gridx = 0;
        gbc.gridy = 1;
        JLabel lblPass = new JLabel("Mật khẩu:");
        lblPass.setForeground(AppTheme.TEXT_PRIMARY);
        formPanel.add(lblPass, gbc);

        gbc.gridx = 1;
        AppTheme.stylePasswordField(txtMatKhau);
        txtMatKhau.setPreferredSize(new Dimension(260, 36));
        txtMatKhau.putClientProperty("JTextField.placeholderText", "Nhập mật khẩu");
        formPanel.add(txtMatKhau, gbc);

        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        AppTheme.stylePrimaryButton(btnDangNhap);
        formPanel.add(btnDangNhap, gbc);

        card.add(formPanel, BorderLayout.CENTER);
        add(card);
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