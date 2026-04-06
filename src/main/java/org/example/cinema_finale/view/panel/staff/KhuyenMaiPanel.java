package org.example.cinema_finale.view.panel.staff;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
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

import org.example.cinema_finale.entity.LoaiKhuyenMai;
import org.example.cinema_finale.tablemodel.KhuyenMaiTableModel;
import org.example.cinema_finale.util.AppTheme;

import com.toedter.calendar.JDateChooser;

public class KhuyenMaiPanel extends JPanel {

    public JTextField txtMa = new JTextField();
    public JTextField txtTen = new JTextField();

    public JComboBox<LoaiKhuyenMai> cboLoai = new JComboBox<>();
    public JComboBox<String> cboKieu = new JComboBox<>(new String[]{"%", "TIEN"});

    public JTextField txtGiaTri = new JTextField();
    public JTextField txtDonHangToiThieu = new JTextField();

    public JDateChooser dateStart = new JDateChooser();
    public JDateChooser dateEnd = new JDateChooser();

    public JComboBox<String> cboTrangThai =
            new JComboBox<>(new String[]{"Hoạt động", "Ngừng"});

    public JTextField txtSearch = new JTextField(15);

    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");
    public JButton btnDelete = new JButton("Ngừng");

    public JTable table;
    public KhuyenMaiTableModel tableModel;

    public KhuyenMaiPanel() {

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
        AppTheme.styleTitledPanel(form, "Thông tin khuyến mãi");
        form.setPreferredSize(new Dimension(300, 0));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        int y = 0;
        addField(form, gbc, y++, "Mã", txtMa);
        addField(form, gbc, y++, "Tên", txtTen);
        addField(form, gbc, y++, "Loại", cboLoai);
        addField(form, gbc, y++, "Kiểu", cboKieu);
        addField(form, gbc, y++, "Giá trị", txtGiaTri);
        addField(form, gbc, y++, "ĐH tối thiểu", txtDonHangToiThieu);
        addField(form, gbc, y++, "Bắt đầu", dateStart);
        addField(form, gbc, y++, "Kết thúc", dateEnd);
        addField(form, gbc, y++, "Trạng thái", cboTrangThai);

        add(form, BorderLayout.WEST);

        // ===== TABLE =====
        tableModel = new KhuyenMaiTableModel();
        table = new JTable(tableModel);
        AppTheme.styleTable(table);

        add(new JScrollPane(table), BorderLayout.CENTER);

        // ===== BUTTON =====
        JPanel btn = new JPanel();
        btn.setLayout(new FlowLayout(FlowLayout.CENTER, 15, 10));

        AppTheme.styleSuccessButton(btnAdd);
        AppTheme.styleWarningButton(btnUpdate);
        AppTheme.styleDangerButton(btnDelete);

        btn.add(btnAdd);
        btn.add(btnUpdate);
        btn.add(btnDelete);

        add(btn, BorderLayout.SOUTH);

        // ===== STYLE =====
        setUIStyle();

        // ===== COMBO RENDER =====
        cboLoai.setRenderer((list, value, index, isSelected, cellHasFocus) -> {
            JLabel lbl = new JLabel();

            if (value != null) {
                lbl.setText(value.getTenLoaiKhuyenMai());
            }

            lbl.setOpaque(true);
            lbl.setBackground(isSelected ? new Color(60, 86, 122) : AppTheme.BG_INPUT);
            lbl.setForeground(AppTheme.TEXT_PRIMARY);

            return lbl;
        });

        // ===== DATE STYLE =====
        dateStart.setBackground(AppTheme.BG_INPUT);
        dateEnd.setBackground(AppTheme.BG_INPUT);

        txtMa.setEditable(false);
    }

    private void addField(JPanel panel, GridBagConstraints gbc,
                          int y, String label, JComponent field) {

        JLabel lbl = new JLabel(label);
        lbl.setForeground(AppTheme.TEXT_PRIMARY);
        lbl.setFont(new Font("Segoe UI", Font.PLAIN, 14));

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
                txtMa, txtTen, txtGiaTri, txtDonHangToiThieu,
                txtSearch, cboLoai, cboKieu, cboTrangThai,
                dateStart, dateEnd
        }) {
            c.setFont(font);
            c.setPreferredSize(size);

            if (c instanceof JTextField) {
                c.setBackground(AppTheme.BG_INPUT);
                c.setForeground(AppTheme.TEXT_PRIMARY);
            }

            if (c instanceof JComboBox) {
                c.setBackground(AppTheme.BG_INPUT);
                c.setForeground(AppTheme.TEXT_PRIMARY);
            }
        }
    }

}