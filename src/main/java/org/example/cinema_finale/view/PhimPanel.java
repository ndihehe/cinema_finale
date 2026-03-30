package org.example.cinema_finale.view;

import com.toedter.calendar.JDateChooser;
import org.example.cinema_finale.TableModel.PhimTableModel;
import org.example.cinema_finale.enums.TrangThaiPhim;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import java.awt.*;

public class PhimPanel extends JPanel {

    // ===== FIELD =====
    public JTextField txtMa = new JTextField();
    public JTextField txtTen = new JTextField();
    public JTextField txtTheLoai = new JTextField();
    public JTextField txtDaoDien = new JTextField();
    public JTextField txtThoiLuong = new JTextField();

    public JComboBox<String> cboGioiHanTuoi =
            new JComboBox<>(new String[]{"", "P", "K", "T13", "T16", "T18"});

    public JComboBox<String> cboDinhDang =
            new JComboBox<>(new String[]{"", "2D", "3D", "IMAX"});

    public JDateChooser dateChooser = new JDateChooser();

    public JComboBox<TrangThaiPhim> cboTrangThai =
            new JComboBox<>(TrangThaiPhim.values());

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
        top.add(new JLabel("🔍 Tìm:"));
        txtSearch.setForeground(Color.WHITE);
        top.add(txtSearch);
        btnSearch.setBackground(new Color(1, 216, 255));
        btnSearch.setForeground(Color.WHITE);
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
        addField(form, gbc, y++, "Giới hạn tuổi", cboGioiHanTuoi);
        addField(form, gbc, y++, "Định dạng", cboDinhDang);
        addField(form, gbc, y++, "Ngày chiếu", dateChooser);
        addField(form, gbc, y++, "Trạng thái", cboTrangThai);

        add(form, BorderLayout.WEST);

        // ===== TABLE =====
        tableModel = new PhimTableModel(null);
        table = new JTable(tableModel);

        table.setRowHeight(28);
        table.setForeground(Color.WHITE);
        table.setBackground(new Color(45,45,45));
        table.setSelectionForeground(Color.WHITE);add(new JScrollPane(table), BorderLayout.CENTER);
        table.setSelectionBackground(new Color(70,130,180));
        table.getTableHeader().setForeground(Color.WHITE);
        table.getTableHeader().setBackground(new Color(60,60,60));// ===== BUTTON =====
        JPanel btn = new JPanel();

        btnAdd.setBackground(new Color(46, 204, 113));
        btnUpdate.setBackground(new Color(241, 196, 15));
        btnDelete.setBackground(new Color(231, 76, 60));

        btnAdd.setForeground(Color.WHITE);
        btnDelete.setForeground(Color.WHITE);
        btnUpdate.setForeground(Color.WHITE);

        btn.add(btnAdd);
        btn.add(btnUpdate);
        btn.add(btnDelete);

        add(btn, BorderLayout.SOUTH);

        // ===== STYLE =====
        setUIStyle();

        for (Component c : form.getComponents()){
            if(c instanceof JLabel){
                c.setForeground(Color.WHITE);
            }
        }
                
    }

    private void addField(JPanel panel, GridBagConstraints gbc,
                          int y, String label, JComponent field) {

        gbc.gridx = 0;
        gbc.gridy = y;
        gbc.weightx = 0.3;
        panel.add(new JLabel(label), gbc);

        gbc.gridx = 1;
        gbc.gridy = y;
        gbc.weightx = 0.7;
        panel.add(field, gbc);
    }

    private void setUIStyle() {

        Font font = new Font("Segoe UI", Font.PLAIN, 14);
        Dimension size = new Dimension(200, 28);

        for (Component c : new Component[]{
                txtMa, txtTen, txtTheLoai, txtDaoDien, txtThoiLuong,
                cboGioiHanTuoi, cboDinhDang, dateChooser, cboTrangThai
        }) {
            c.setFont(font);
            c.setPreferredSize(size);
            c.setForeground(Color.WHITE);
        }
    }
}