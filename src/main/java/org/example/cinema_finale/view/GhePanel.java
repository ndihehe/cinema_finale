package org.example.cinema_finale.view;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.Insets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;

import org.example.cinema_finale.dto.GheDTO;
import org.example.cinema_finale.tablemodel.GheTableModel;
import org.example.cinema_finale.util.AppTheme;

public class GhePanel extends JPanel {

    public Integer maPhong;

    public JTextField txtMa = new JTextField();
    public JTextField txtHangGhe = new JTextField();
    public JTextField txtSoGhe = new JTextField();

    public JComboBox<String> cboLoaiGhe =
            new JComboBox<>(new String[]{"Ghế thường", "Ghế VIP", "Ghế đôi"});
    public JComboBox<String> cboTrangThai =
            new JComboBox<>(new String[]{"Hoạt động", "Hỏng"});

    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");
    public JButton btnDelete = new JButton("Xóa");

    public JTable table;
    public GheTableModel tableModel;

    public JPanel seatMapPanel = new JPanel();
    public Map<String, JButton> seatMap = new HashMap<>();

    public GhePanel(Integer maPhong) {

        this.maPhong = maPhong;

        setLayout(new BorderLayout(10,10));

        // ===== FORM =====
        JPanel form = new JPanel(new GridBagLayout());
        AppTheme.styleTitledPanel(form, "Thông tin ghế");

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        int y = 0;
        addField(form, gbc, y++, "Mã", txtMa);
        addField(form, gbc, y++, "Hàng", txtHangGhe);
        addField(form, gbc, y++, "Số", txtSoGhe);
        addField(form, gbc, y++, "Loại", cboLoaiGhe);
        addField(form, gbc, y++, "Trạng thái", cboTrangThai);

        add(form, BorderLayout.WEST);

        // ===== RIGHT =====
        JPanel right = new JPanel(new BorderLayout());

        seatMapPanel.setLayout(new GridLayout(0,10,5,5));
        AppTheme.styleTitledPanel(seatMapPanel, "Sơ đồ ghế");
        right.add(seatMapPanel, BorderLayout.NORTH);

        tableModel = new GheTableModel();
        table = new JTable(tableModel);
        AppTheme.styleTable(table);

        right.add(new JScrollPane(table), BorderLayout.CENTER);

        add(right, BorderLayout.CENTER);

        // ===== BUTTON =====
        JPanel btn = new JPanel();

        AppTheme.styleSuccessButton(btnAdd);
        AppTheme.styleWarningButton(btnUpdate);
        AppTheme.styleDangerButton(btnDelete);

        btn.add(btnAdd);
        btn.add(btnUpdate);
        btn.add(btnDelete);

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
                txtMa, txtHangGhe, txtSoGhe,
                cboLoaiGhe, cboTrangThai
        }) {
            c.setFont(font);
            c.setPreferredSize(size);

            if (c instanceof JTextField) {
                c.setBackground(AppTheme.BG_INPUT);
                c.setForeground(AppTheme.TEXT_PRIMARY);
            }
        }
    }

    // ===== SEAT MAP =====
    public void renderSeatMap(List<GheDTO> list) {

        seatMapPanel.removeAll();
        seatMap.clear();
        seatMapPanel.setBackground(AppTheme.BG_CARD);

        for (GheDTO g : list) {

            String key = g.getViTriGhe();
            JButton btn = new JButton(key);

            boolean active = "Hoạt động".equals(g.getTrangThaiGhe());
            boolean vip = "Ghế VIP".equalsIgnoreCase(g.getTenLoaiGheNgoi()) || "VIP".equalsIgnoreCase(g.getTenLoaiGheNgoi());
            boolean doi = "Ghế đôi".equalsIgnoreCase(g.getTenLoaiGheNgoi());

            if (!active) {
                btn.setBackground(new Color(108, 117, 125));
            } else if (vip) {
                btn.setBackground(new Color(196, 145, 56));
            } else if (doi) {
                btn.setBackground(new Color(93, 111, 201));
            } else {
                btn.setBackground(new Color(52, 152, 107));
            }

            btn.setForeground(Color.WHITE);
            btn.setFocusPainted(false);
            btn.setBorder(BorderFactory.createLineBorder(new Color(70, 78, 88)));

            seatMap.put(key, btn);
            seatMapPanel.add(btn);
        }

        seatMapPanel.revalidate();
        seatMapPanel.repaint();
    }
}