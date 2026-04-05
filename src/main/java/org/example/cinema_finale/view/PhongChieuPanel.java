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

import org.example.cinema_finale.tablemodel.PhongChieuTableModel;
import org.example.cinema_finale.util.AppTheme;

public class PhongChieuPanel extends JPanel {

    public JTextField txtMa = new JTextField();
    public JTextField txtTen = new JTextField();
    public JTextField txtManHinh = new JTextField();
    public JTextField txtAmThanh = new JTextField();
    public JTextField txtSoHang = new JTextField();
    public JTextField txtSoCot = new JTextField();

    public JComboBox<String> cboTrangThai =
            new JComboBox<>(new String[]{"Hoạt động", "Bảo trì"});

    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");
    public JButton btnDelete = new JButton("Xóa");
    public JButton btnSeatMap = new JButton("Sơ đồ ghế");

    public JTable table;
    public PhongChieuTableModel tableModel;

    public PhongChieuPanel() {

        setLayout(new BorderLayout(10,10));

        // ===== FORM =====
        JPanel form = new JPanel(new GridBagLayout());
        AppTheme.styleTitledPanel(form, "Thông tin phòng");

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        int y = 0;
        addField(form, gbc, y++, "Mã", txtMa);
        addField(form, gbc, y++, "Tên", txtTen);
        addField(form, gbc, y++, "Số hàng", txtSoHang);
        addField(form, gbc, y++, "Số cột", txtSoCot);
        addField(form, gbc, y++, "Màn hình", txtManHinh);
        addField(form, gbc, y++, "Âm thanh", txtAmThanh);
        addField(form, gbc, y++, "Trạng thái", cboTrangThai);

        add(form, BorderLayout.WEST);

        // ===== TABLE =====
        tableModel = new PhongChieuTableModel();
        table = new JTable(tableModel);
        AppTheme.styleTable(table);

        add(new JScrollPane(table), BorderLayout.CENTER);

        // ===== BUTTON =====
        JPanel btn = new JPanel();

        AppTheme.styleSuccessButton(btnAdd);
        AppTheme.styleWarningButton(btnUpdate);
        AppTheme.styleDangerButton(btnDelete);
        AppTheme.stylePrimaryButton(btnSeatMap);

        btn.add(btnAdd);
        btn.add(btnUpdate);
        btn.add(btnDelete);
        btn.add(btnSeatMap);

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
                txtMa, txtTen, txtSoHang, txtSoCot,
                txtManHinh, txtAmThanh, cboTrangThai
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