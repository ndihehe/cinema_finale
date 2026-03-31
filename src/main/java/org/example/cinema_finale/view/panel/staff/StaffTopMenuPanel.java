package org.example.cinema_finale.view.panel.staff;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionListener;

public class StaffTopMenuPanel extends JPanel {

    public static final String HOME = "HOME";
    public static final String PHIM = "PHIM";
    public static final String PHONG_CHIEU = "PHONG_CHIEU";
    public static final String NHAN_VIEN = "NHAN_VIEN";
    public static final String SUAT_CHIEU = "SUAT_CHIEU";
    public static final String KHACH_HANG = "KHACH_HANG";
    public static final String KHUYEN_MAI = "KHUYEN_MAI";
    public static final String THONG_KE = "THONG_KE";
    public static final String LOGOUT = "LOGOUT";

    private final JButton btnQuanLyPhim = createMenuButton("Quản lý Phim", PHIM);
    private final JButton btnQuanLyPhongChieu = createMenuButton("Quản lý Phòng Chiếu", PHONG_CHIEU);
    private final JButton btnQuanLyNhanVien = createMenuButton("Quản lý Nhân Viên", NHAN_VIEN);
    private final JButton btnQuanLySuatChieu = createMenuButton("Quản lý Suất Chiếu", SUAT_CHIEU);
    private final JButton btnQuanLyKhachHang = createMenuButton("Quản lý Khách Hàng", KHACH_HANG);
    private final JButton btnQuanLyKhuyenMai = createMenuButton("Quản lý Khuyến Mãi", KHUYEN_MAI);
    private final JButton btnThongKe = createMenuButton("Thống Kê Doanh Số", THONG_KE);
    private final JButton btnLogout = createLogoutButton();

    private final JLabel lblUser = new JLabel("Nhân viên");

    public StaffTopMenuPanel() {
        setLayout(new BorderLayout());
        setBackground(Color.WHITE);
        setBorder(new EmptyBorder(8, 12, 8, 12));

        JPanel leftMenu = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 0));
        leftMenu.setOpaque(false);

        leftMenu.add(btnQuanLyPhim);
        leftMenu.add(btnQuanLyPhongChieu);
        leftMenu.add(btnQuanLyNhanVien);
        leftMenu.add(btnQuanLySuatChieu);
        leftMenu.add(btnQuanLyKhachHang);
        leftMenu.add(btnQuanLyKhuyenMai);
        leftMenu.add(btnThongKe);

        JPanel rightMenu = new JPanel(new FlowLayout(FlowLayout.RIGHT, 8, 0));
        rightMenu.setOpaque(false);

        lblUser.setFont(new Font("Segoe UI", Font.BOLD, 13));
        lblUser.setForeground(new Color(45, 45, 45));

        rightMenu.add(lblUser);
        rightMenu.add(btnLogout);

        add(leftMenu, BorderLayout.CENTER);
        add(rightMenu, BorderLayout.EAST);
    }

    private JButton createMenuButton(String text, String actionCommand) {
        JButton button = new JButton(text);
        button.setActionCommand(actionCommand);
        button.setFocusPainted(false);
        button.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        button.setForeground(Color.WHITE);
        button.setBackground(new Color(91, 155, 213));
        button.setBorder(BorderFactory.createEmptyBorder(8, 14, 8, 14));
        button.setCursor(new Cursor(Cursor.HAND_CURSOR));
        return button;
    }

    private JButton createLogoutButton() {
        JButton button = new JButton("Đăng xuất");
        button.setActionCommand(LOGOUT);
        button.setFocusPainted(false);
        button.setFont(new Font("Segoe UI", Font.BOLD, 13));
        button.setForeground(Color.WHITE);
        button.setBackground(new Color(231, 76, 60));
        button.setBorder(BorderFactory.createEmptyBorder(8, 14, 8, 14));
        button.setCursor(new Cursor(Cursor.HAND_CURSOR));
        return button;
    }

    public void setCurrentUserName(String fullName) {
        if (fullName == null || fullName.isBlank()) {
            lblUser.setText("Nhân viên");
        } else {
            lblUser.setText(fullName);
        }
    }

    public void addMenuListener(ActionListener listener) {
        btnQuanLyPhim.addActionListener(listener);
        btnQuanLyPhongChieu.addActionListener(listener);
        btnQuanLyNhanVien.addActionListener(listener);
        btnQuanLySuatChieu.addActionListener(listener);
        btnQuanLyKhachHang.addActionListener(listener);
        btnQuanLyKhuyenMai.addActionListener(listener);
        btnThongKe.addActionListener(listener);
        btnLogout.addActionListener(listener);
    }
}