package org.example.cinema_finale.view;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Dimension;
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
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SwingConstants;

import org.example.cinema_finale.tablemodel.PhimTableModel;
import org.example.cinema_finale.util.AppTheme;

import com.toedter.calendar.JDateChooser;

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


    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");
    public JButton btnDelete = new JButton("Ngừng chiếu");
    public JButton btnUploadPoster = new JButton("Upload poster");
    public JButton btnClearPoster = new JButton("Xóa poster");

    public JTable table;
    public PhimTableModel tableModel;
    public JLabel lblPosterPreview = new JLabel("Chưa có poster", SwingConstants.CENTER);

    public PhimPanel() {

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
        AppTheme.styleTitledPanel(form, "Thông tin phim");

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

        JPanel posterBox = createPosterBox();

        JPanel leftColumn = new JPanel(new BorderLayout(0, 10));
        leftColumn.setBackground(AppTheme.BG_APP);
        leftColumn.setPreferredSize(new Dimension(320, 0));

        JScrollPane formScroll = new JScrollPane(form);
        formScroll.setBorder(null);
        formScroll.getViewport().setBackground(AppTheme.BG_APP);
        formScroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);

        leftColumn.add(formScroll, BorderLayout.CENTER);
        leftColumn.add(posterBox, BorderLayout.SOUTH);

        add(leftColumn, BorderLayout.WEST);

        // ===== TABLE =====
        tableModel = new PhimTableModel(new ArrayList<>());
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
                txtMa, txtTen, txtTheLoai, txtDaoDien,
                txtThoiLuong, txtGioiHanTuoi, txtDinhDang,
                dateChooser, cboTrangThai
        }) {
            c.setFont(font);
            c.setPreferredSize(size);

            if (c instanceof JTextField) {
                c.setBackground(AppTheme.BG_INPUT);
                c.setForeground(AppTheme.TEXT_PRIMARY);
            }
        }

        AppTheme.stylePrimaryButton(btnUploadPoster);
        AppTheme.styleWarningButton(btnClearPoster);
    }

    private JPanel createPosterBox() {
        JPanel posterPanel = new JPanel(new BorderLayout(8, 8));
        AppTheme.styleTitledPanel(posterPanel, "Poster phim (khu upload)");
        posterPanel.setPreferredSize(new Dimension(0, 240));

        lblPosterPreview.setOpaque(true);
        lblPosterPreview.setBackground(AppTheme.BG_INPUT);
        lblPosterPreview.setForeground(AppTheme.TEXT_MUTED);
        lblPosterPreview.setPreferredSize(new Dimension(280, 160));

        JPanel actions = new JPanel();
        actions.setBackground(AppTheme.BG_APP);
        actions.add(btnUploadPoster);
        actions.add(btnClearPoster);

        posterPanel.add(lblPosterPreview, BorderLayout.CENTER);
        posterPanel.add(actions, BorderLayout.SOUTH);

        return posterPanel;
    }
}