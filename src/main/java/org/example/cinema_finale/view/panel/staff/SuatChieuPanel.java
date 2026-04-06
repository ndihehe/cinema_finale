package org.example.cinema_finale.view.panel.staff;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.util.ArrayList;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSpinner;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SpinnerDateModel;

import org.example.cinema_finale.tablemodel.SuatChieuTableModel;
import org.example.cinema_finale.util.AppTheme;

import com.toedter.calendar.JDateChooser;

public class SuatChieuPanel extends JPanel {

    public JTextField txtMa = new JTextField();

    public JComboBox<String> cboPhim = new JComboBox<>();
    public JComboBox<String> cboPhong = new JComboBox<>();

    public JDateChooser dateChooser = new JDateChooser();
    public JSpinner timeSpinner = new JSpinner(new SpinnerDateModel());

    public JTextField txtGia = new JTextField();

    public JComboBox<String> cboTrangThai =
            new JComboBox<>(new String[]{
                    "Sắp chiếu", "Đang chiếu", "Đã chiếu", "Hủy"
            });

    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");
    public JButton btnDelete = new JButton("Hủy");

    public JTable table;
    public SuatChieuTableModel tableModel;

    public JTextField txtSearch = new JTextField(15);

    public SuatChieuPanel() {

        setLayout(new BorderLayout(10,10));

        // ================= TOP =================
        JPanel top = new JPanel(new FlowLayout(FlowLayout.LEFT));

        JLabel lblSearch = new JLabel("Tìm:");

        AppTheme.styleSearchField(txtSearch);

        top.add(lblSearch);
        top.add(txtSearch);

        add(top, BorderLayout.NORTH);

        // ================= TABLE =================
        tableModel = new SuatChieuTableModel(new ArrayList<>());
        table = new JTable(tableModel);
        AppTheme.styleTable(table);

        add(new JScrollPane(table), BorderLayout.CENTER);

        // ================= BOTTOM =================
        JPanel bottom = new JPanel(new BorderLayout());

        JPanel form = new JPanel(new GridBagLayout());
        AppTheme.styleTitledPanel(form, "Thông tin suất chiếu");

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,10,5,10);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        int y = 0;

        addField(form, gbc, 0, y, "Mã", txtMa);
        addField(form, gbc, 0, ++y, "Phim", cboPhim);
        addField(form, gbc, 0, ++y, "Phòng", cboPhong);
        addField(form, gbc, 0, ++y, "Ngày", dateChooser);

        y = 0;
        addField(form, gbc, 2, y, "Giờ", timeSpinner);
        addField(form, gbc, 2, ++y, "Giá vé", txtGia);
        addField(form, gbc, 2, ++y, "Trạng thái", cboTrangThai);

        bottom.add(form, BorderLayout.CENTER);

        // BUTTON
        JPanel btnPanel = new JPanel();

        AppTheme.styleSuccessButton(btnAdd);
        AppTheme.styleWarningButton(btnUpdate);
        AppTheme.styleDangerButton(btnDelete);

        btnPanel.add(btnAdd);
        btnPanel.add(btnUpdate);
        btnPanel.add(btnDelete);

        bottom.add(btnPanel, BorderLayout.SOUTH);

        add(bottom, BorderLayout.SOUTH);

        txtMa.setEditable(false);

        JSpinner.DateEditor editor = new JSpinner.DateEditor(timeSpinner, "HH:mm");
        timeSpinner.setEditor(editor);

        setUIStyle();
    }

    private void addField(JPanel panel, GridBagConstraints gbc,
                          int x, int y, String label, JComponent field) {

        JLabel lbl = new JLabel(label);
        lbl.setForeground(AppTheme.TEXT_PRIMARY);

        gbc.gridx = x;
        gbc.gridy = y;
        panel.add(lbl, gbc);

        gbc.gridx = x + 1;
        panel.add(field, gbc);
    }

    private void setUIStyle() {

        Font font = new Font("Segoe UI", Font.PLAIN, 14);
        Dimension size = new Dimension(200, 28);

        for (Component c : new Component[]{
                txtMa, txtGia, cboPhim, cboPhong,
                cboTrangThai, dateChooser, timeSpinner
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