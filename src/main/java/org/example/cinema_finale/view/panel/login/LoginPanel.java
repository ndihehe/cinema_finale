package org.example.cinema_finale.view.panel.login;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.RenderingHints;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;

/**
 * Minimal, cinematic login panel: translucent rounded form centered over background.
 * Contains only title, subtitle, username, password and a single "Đăng nhập" button.
 */
public class LoginPanel extends JPanel {

    private final JTextField txtTenDangNhap = new JTextField(20);
    private final JPasswordField txtMatKhau = new JPasswordField(20);
    private final javax.swing.JButton btnDangNhap = new javax.swing.JButton("Đăng nhập");

    // preferred size of center card
    private final Dimension cardSize = new Dimension(520, 360);

    public LoginPanel() {
        setLayout(new GridBagLayout());
        setOpaque(false);

        // The card panel is drawn with translucent dark rounded background
        JPanel card = new JPanel(new GridBagLayout()) {
            @Override
            protected void paintComponent(Graphics g) {
                Graphics2D g2 = (Graphics2D) g.create();
                g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

                int w = getWidth();
                int h = getHeight();

                // translucent dark panel (cinematic glass)
                g2.setColor(new Color(12, 18, 26, 200));
                g2.fillRoundRect(0, 0, w, h, 22, 22);

                // subtle border
                g2.setColor(new Color(255, 255, 255, 30));
                g2.drawRoundRect(0, 0, w - 1, h - 1, 22, 22);

                g2.dispose();
                super.paintComponent(g);
            }
        };

        card.setOpaque(false);
        card.setBorder(new EmptyBorder(28, 36, 28, 36));
        card.setPreferredSize(cardSize);

        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(8, 8, 8, 8);
        c.fill = GridBagConstraints.HORIZONTAL;
        c.gridx = 0;

        // Title
        JLabel title = new JLabel("Cinema Finale", SwingConstants.CENTER);
        title.setFont(new Font("SansSerif", Font.BOLD, 26));
        title.setForeground(new Color(240, 242, 245));
        title.setBorder(new EmptyBorder(6, 6, 4, 6));
        c.gridy = 0;
        c.weightx = 1;
        card.add(title, c);

        // Subtitle
        JLabel subtitle = new JLabel("Sign in to continue", SwingConstants.CENTER);
        subtitle.setFont(new Font("SansSerif", Font.PLAIN, 12));
        subtitle.setForeground(new Color(200, 206, 214));
        subtitle.setBorder(new EmptyBorder(2, 6, 12, 6));
        c.gridy = 1;
        card.add(subtitle, c);

        // form labels + fields area
        GridBagConstraints f = new GridBagConstraints();
        f.gridx = 0;
        f.fill = GridBagConstraints.HORIZONTAL;
        f.insets = new Insets(10, 0, 4, 0);

        JLabel lblUser = new JLabel("Tên đăng nhập");
        lblUser.setFont(new Font("SansSerif", Font.PLAIN, 13));
        lblUser.setForeground(new Color(200, 206, 214));
        f.gridy = 2;
        card.add(lblUser, f);

        txtTenDangNhap.setPreferredSize(new Dimension(420, 40));
        txtTenDangNhap.setFont(new Font("SansSerif", Font.PLAIN, 14));
        txtTenDangNhap.setBackground(new Color(255, 255, 255, 20));
        txtTenDangNhap.setForeground(new Color(230, 230, 230));
        txtTenDangNhap.setBorder(BorderFactory.createEmptyBorder(8, 10, 8, 10));
        f.gridy = 3;
        card.add(txtTenDangNhap, f);

        JLabel lblPass = new JLabel("Mật khẩu");
        lblPass.setFont(new Font("SansSerif", Font.PLAIN, 13));
        lblPass.setForeground(new Color(200, 206, 214));
        f.gridy = 4;
        card.add(lblPass, f);

        txtMatKhau.setPreferredSize(new Dimension(420, 40));
        txtMatKhau.setFont(new Font("SansSerif", Font.PLAIN, 14));
        txtMatKhau.setBackground(new Color(255, 255, 255, 20));
        txtMatKhau.setForeground(new Color(230, 230, 230));
        txtMatKhau.setBorder(BorderFactory.createEmptyBorder(8, 10, 8, 10));
        f.gridy = 5;
        card.add(txtMatKhau, f);

        // Button
        btnDangNhap.setFont(new Font("SansSerif", Font.BOLD, 14));
        btnDangNhap.setBackground(new Color(20, 90, 150));
        btnDangNhap.setForeground(new Color(255, 255, 255));
        btnDangNhap.setFocusPainted(false);
        btnDangNhap.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        btnDangNhap.setPreferredSize(new Dimension(420, 44));
        f.gridy = 6;
        f.insets = new Insets(16, 0, 0, 0);
        card.add(btnDangNhap, f);

        card.setOpaque(false);

        // center the card in this panel
        GridBagConstraints cc = new GridBagConstraints();
        cc.gridx = 0;
        cc.gridy = 0;
        add(card, cc);
    }

    @Override
    protected void paintComponent(Graphics g) {
        // background rendered by BackgroundPanel; keep transparency
        super.paintComponent(g);
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
        javax.swing.JOptionPane.showMessageDialog(this, message, title, messageType);
    }

    public void focusUsername() {
        txtTenDangNhap.requestFocusInWindow();
    }

    public void clearPassword() {
        txtMatKhau.setText("");
    }
}
