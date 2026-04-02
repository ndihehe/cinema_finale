package org.example.cinema_finale.view;

import org.example.cinema_finale.dto.GheDTO;
import org.example.cinema_finale.tablemodel.GheTableModel;

import javax.swing.*;
import java.awt.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GhePanel extends JPanel {

    public JTextField txtMa = new JTextField();
    public JTextField txtHangGhe = new JTextField();
    public JTextField txtSoGhe = new JTextField();

    public JComboBox<String> cboPhong = new JComboBox<>(new String[]{"Phòng 1"});
    public JComboBox<String> cboLoaiGhe = new JComboBox<>(new String[]{"Ghế thường", "VIP"});
    public JComboBox<String> cboTrangThai =
            new JComboBox<>(new String[]{"Hoạt động", "Hỏng"});

    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");
    public JButton btnDelete = new JButton("Xóa");

    public JTable table;
    public GheTableModel tableModel;

    public JPanel seatMapPanel = new JPanel();
    public Map<String, JButton> seatMap = new HashMap<>();

    public GhePanel() {

        setLayout(new BorderLayout(10,10));
        setBackground(new Color(40,40,40));

        // ===== FORM =====
        JPanel form = new JPanel(new GridLayout(6,2,5,5));
        form.setPreferredSize(new Dimension(250,300));
        form.setBorder(BorderFactory.createTitledBorder("Thông tin ghế"));

        addField(form, "Mã", txtMa);
        addField(form, "Hàng", txtHangGhe);
        addField(form, "Số", txtSoGhe);
        addField(form, "Phòng", cboPhong);
        addField(form, "Loại", cboLoaiGhe);
        addField(form, "Trạng thái", cboTrangThai);

        add(form, BorderLayout.WEST);

        // ===== RIGHT =====
        JPanel right = new JPanel(new BorderLayout());

        // Seat map
        seatMapPanel.setLayout(new GridLayout(0,10,5,5));
        seatMapPanel.setBorder(BorderFactory.createTitledBorder("Sơ đồ ghế"));
        right.add(seatMapPanel, BorderLayout.NORTH);

        // Table
        tableModel = new GheTableModel();
        table = new JTable(tableModel);
        table.setRowHeight(28);

        table.setBackground(new Color(45,45,45));
        table.setForeground(Color.WHITE);

        right.add(new JScrollPane(table), BorderLayout.CENTER);

        add(right, BorderLayout.CENTER);

        // ===== BUTTON =====
        JPanel btn = new JPanel();
        btn.add(btnAdd);
        btn.add(btnUpdate);
        btn.add(btnDelete);

        add(btn, BorderLayout.SOUTH);

        txtMa.setEditable(false);
    }

    private void addField(JPanel panel, String label, JComponent field) {
        JLabel lbl = new JLabel(label);
        lbl.setForeground(Color.WHITE);
        panel.add(lbl);
        panel.add(field);
    }

    // ===== SEAT MAP =====
    public void renderSeatMap(List<GheDTO> list) {
        seatMapPanel.removeAll();
        seatMap.clear();

        for (GheDTO g : list) {
            String key = g.getViTriGhe();

            JButton btn = new JButton(key);
            btn.setForeground(Color.WHITE);

            boolean active = "Hoạt động".equals(g.getTrangThaiGhe());

            if (g.getTenLoaiGheNgoi().equalsIgnoreCase("VIP")) {
                btn.setBackground(Color.ORANGE);
            } else {
                btn.setBackground(active ? Color.GREEN : Color.RED);
            }

            seatMap.put(key, btn);
            seatMapPanel.add(btn);
        }

        seatMapPanel.revalidate();
        seatMapPanel.repaint();
    }

    public void highlightSeat(String viTri) {
        seatMap.values().forEach(b -> b.setBorder(null));

        if (seatMap.containsKey(viTri)) {
            seatMap.get(viTri).setBorder(BorderFactory.createLineBorder(Color.YELLOW, 3));
        }
    }
}