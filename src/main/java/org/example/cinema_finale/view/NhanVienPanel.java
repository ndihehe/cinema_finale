package org.example.cinema_finale.view;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;

import org.example.cinema_finale.tablemodel.NhanVienTableModel;
import org.example.cinema_finale.util.AppTheme;

public class NhanVienPanel extends JPanel {

    // ===== SEARCH =====
    public JTextField txtSearch = new JTextField(15);

    // ===== FORM =====
    public JTextField txtMa = new JTextField();
    public JTextField txtTen = new JTextField();
    public JTextField txtNgaySinh = new JTextField();
    public JTextField txtSDT = new JTextField();
    public JTextField txtEmail = new JTextField();
    public JTextField txtDiaChi = new JTextField();

    public JComboBox<String> cboGioiTinh =
            new JComboBox<>(new String[]{"Nam", "Nữ", "Khác"});

    public JComboBox<String> cboTrangThai =
            new JComboBox<>(new String[]{"Đang làm", "Nghỉ việc"});

    public JComboBox<String> cboChucVu =
            new JComboBox<>(new String[]{"1", "2", "3"});

    // ===== BUTTON =====
    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");
    public JButton btnDelete = new JButton("Nghỉ việc");

    // ===== TABLE =====
    public JTable table;
    public NhanVienTableModel tableModel;

    public NhanVienPanel() {

        setLayout(new BorderLayout(10,10));

        // ===== SEARCH =====
        JPanel top = new JPanel();

        JLabel lblSearch = new JLabel("Tìm:");

        AppTheme.styleSearchField(txtSearch);

        top.add(lblSearch);
        top.add(txtSearch);

        add(top, BorderLayout.NORTH);

        // ===== FORM =====
        JPanel form = new JPanel(new GridBagLayout());
        AppTheme.styleTitledPanel(form, "Thông tin nhân viên");

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        int y = 0;
        addField(form, gbc, y++, "Mã", txtMa);
        addField(form, gbc, y++, "Họ tên", txtTen);
        addField(form, gbc, y++, "Ngày sinh", txtNgaySinh);
        addField(form, gbc, y++, "Giới tính", cboGioiTinh);
        addField(form, gbc, y++, "SĐT", txtSDT);
        addField(form, gbc, y++, "Email", txtEmail);
        addField(form, gbc, y++, "Địa chỉ", txtDiaChi);
        addField(form, gbc, y++, "Chức vụ", cboChucVu);
        addField(form, gbc, y++, "Trạng thái", cboTrangThai);

        add(form, BorderLayout.WEST);

        // ===== TABLE =====
        tableModel = new NhanVienTableModel();
        table = new JTable(tableModel);
        AppTheme.styleTable(table);

        add(new JScrollPane(table), BorderLayout.CENTER);

        // ===== BUTTON =====
        JPanel btn = new JPanel();

        AppTheme.styleSuccessButton(btnAdd);
        AppTheme.styleWarningButton(btnUpdate);
        AppTheme.styleDangerButton(btnDelete);

        btn.add(btnAdd);
        btn.add(btnUpdate);
        btn.add(btnDelete);

        add(btn, BorderLayout.SOUTH);

        // ===== STYLE =====
        setUIStyle();

        txtMa.setEditable(false);
    }

    private void addField(JPanel panel, GridBagConstraints gbc,
                          int y, String label, JComponent field) {

        JLabel lbl = new JLabel(label);
        lbl.setForeground(AppTheme.TEXT_PRIMARY);

        gbc.gridx = 0;
        gbc.gridy = y;
        panel.add(lbl, gbc);

        gbc.gridx = 1;
        panel.add(field, gbc);
    }

    private void setUIStyle() {

        Font font = new Font("Segoe UI", Font.PLAIN, 14);
        Dimension size = new Dimension(200, 28);

        for (Component c : new Component[]{
                txtMa, txtTen, txtNgaySinh,
                txtSDT, txtEmail, txtDiaChi,
                cboGioiTinh, cboTrangThai, cboChucVu
        }) {
            c.setFont(font);
            c.setPreferredSize(size);

            if (c instanceof JTextField) {
                c.setBackground(AppTheme.BG_INPUT);
                c.setForeground(AppTheme.TEXT_PRIMARY);
            }
        }
    }
}