package org.example.cinema_finale.view.panel.staff;

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

import org.example.cinema_finale.tablemodel.KhachHangTableModel;
import org.example.cinema_finale.util.AppTheme;

import com.toedter.calendar.JDateChooser;

public class KhachHangPanel extends JPanel {

    public JTextField txtMa = new JTextField();
    public JTextField txtTen = new JTextField();
    public JTextField txtSDT = new JTextField();
    public JTextField txtEmail = new JTextField();
    public JTextField txtDiem = new JTextField();

    public JComboBox<String> cboGioiTinh =
            new JComboBox<>(new String[]{"Nam", "Nữ", "Khác"});

    public JComboBox<String> cboHang =
            new JComboBox<>(new String[]{"Thường", "VIP", "Vàng"});

    public JDateChooser dateChooser = new JDateChooser();

    public JTextField txtSearch = new JTextField(15);

    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");

    public JTable table;
    public KhachHangTableModel tableModel;

    public KhachHangPanel() {

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
        AppTheme.styleTitledPanel(form, "Thông tin khách hàng");

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        int y = 0;
        addField(form, gbc, y++, "Mã", txtMa);
        addField(form, gbc, y++, "Họ tên", txtTen);
        addField(form, gbc, y++, "SĐT", txtSDT);
        addField(form, gbc, y++, "Email", txtEmail);
        addField(form, gbc, y++, "Giới tính", cboGioiTinh);
        addField(form, gbc, y++, "Ngày sinh", dateChooser);
        addField(form, gbc, y++, "Điểm", txtDiem);
        addField(form, gbc, y++, "Hạng", cboHang);

        add(form, BorderLayout.WEST);

        // ===== TABLE =====
        tableModel = new KhachHangTableModel();
        table = new JTable(tableModel);
        AppTheme.styleTable(table);

        add(new JScrollPane(table), BorderLayout.CENTER);

        // ===== BUTTON =====
        JPanel btn = new JPanel();

        AppTheme.styleSuccessButton(btnAdd);
        AppTheme.styleWarningButton(btnUpdate);

        btn.add(btnAdd);
        btn.add(btnUpdate);

        add(btn, BorderLayout.SOUTH);

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
                txtMa, txtTen, txtSDT, txtEmail, txtDiem,
                dateChooser, cboGioiTinh, cboHang
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