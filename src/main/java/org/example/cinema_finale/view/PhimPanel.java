package org.example.cinema_finale.view;

import com.toedter.calendar.JDateChooser;
import org.example.cinema_finale.tablemodel.PhimTableModel;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;

public class PhimPanel extends JPanel {

    public JTextField txtMa = new JTextField();
    public JTextField txtTen = new JTextField();
    public JTextField txtTheLoai = new JTextField();
    public JTextField txtDaoDien = new JTextField();
    public JTextField txtThoiLuong = new JTextField();

    public JTextField txtGioiHanTuoi = new JTextField(); // DTO
    public JTextField txtDinhDang = new JTextField();    // DTO

    public JDateChooser dateChooser = new JDateChooser();

    public JComboBox<String> cboTrangThai =
            new JComboBox<>(new String[]{
                    "Sắp chiếu", "Đang chiếu", "Ngừng chiếu", "Đã chiếu"
            });

    public JTextField txtSearch = new JTextField(15);

    public JButton btnSearch = new JButton("Tìm");
    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");
    public JButton btnDelete = new JButton("Ngừng chiếu");

    public JTable table;
    public PhimTableModel tableModel;

    public PhimPanel() {

        setLayout(new BorderLayout(10,10));

        // ===== SEARCH =====
        JPanel top = new JPanel();

        JLabel lblSearch = new JLabel("🔍 Tìm:");
        lblSearch.setForeground(Color.WHITE);

        txtSearch.setForeground(Color.WHITE);
        txtSearch.setBackground(new Color(45,45,45));

        btnSearch.setBackground(new Color(1,216,255));
        btnSearch.setForeground(Color.WHITE);

        top.add(lblSearch);
        top.add(txtSearch);
        top.add(btnSearch);

        add(top, BorderLayout.NORTH);

        // ===== FORM =====
        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createTitledBorder("🎬 Thông tin phim"));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        int y = 0;
        addField(form, gbc, y++, "Mã", txtMa);
        addField(form, gbc, y++, "Tên", txtTen);
        addField(form, gbc, y++, "Thể loại", txtTheLoai);
        addField(form, gbc, y++, "Đạo diễn", txtDaoDien);
        addField(form, gbc, y++, "Thời lượng", txtThoiLuong);
        addField(form, gbc, y++, "Giới hạn tuổi", txtGioiHanTuoi);
        addField(form, gbc, y++, "Định dạng", txtDinhDang);
        addField(form, gbc, y++, "Ngày chiếu", dateChooser);
        addField(form, gbc, y++, "Trạng thái", cboTrangThai);

        add(form, BorderLayout.WEST);

        // ===== TABLE =====
        tableModel = new PhimTableModel(new ArrayList<>());
        table = new JTable(tableModel);

        table.setRowHeight(28);
        table.setForeground(Color.WHITE);
        table.setBackground(new Color(45,45,45));
        table.setSelectionBackground(new Color(70,130,180));
        table.setSelectionForeground(Color.WHITE);

        table.getTableHeader().setForeground(Color.WHITE);
        table.getTableHeader().setBackground(new Color(60,60,60));

        add(new JScrollPane(table), BorderLayout.CENTER);

        // ===== BUTTON =====
        JPanel btn = new JPanel();

        btnAdd.setBackground(new Color(46,204,113));
        btnUpdate.setBackground(new Color(241,196,15));
        btnDelete.setBackground(new Color(231,76,60));

        btnAdd.setForeground(Color.WHITE);
        btnUpdate.setForeground(Color.WHITE);
        btnDelete.setForeground(Color.WHITE);

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
        lbl.setForeground(Color.WHITE);

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
                txtMa, txtTen, txtTheLoai, txtDaoDien,
                txtThoiLuong, txtGioiHanTuoi, txtDinhDang,
                dateChooser, cboTrangThai
        }) {
            c.setFont(font);
            c.setPreferredSize(size);

            if (c instanceof JTextField) {
                c.setBackground(new Color(45,45,45));
                c.setForeground(Color.WHITE);
            }
        }
    }
}