package org.example.cinema_finale.view;

import org.example.cinema_finale.entity.GheNgoi;
import org.example.cinema_finale.entity.PhongChieu;
import org.example.cinema_finale.tablemodel.GheTableModel;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import java.awt.*;
import java.util.List;

public class GhePanel extends JPanel {

    public JTextField txtMa = new JTextField();
    public JTextField txtTen = new JTextField();
    public JTextField txtLoai = new JTextField();

    public JComboBox<PhongChieu> cboPhong;
    public JCheckBox chkTrangThai = new JCheckBox("Hoạt động");

    public JButton btnAdd = new JButton("Thêm");
    public JButton btnUpdate = new JButton("Sửa");
    public JButton btnDelete = new JButton("Xóa");
    // ❌ ĐÃ XÓA btnGenerate

    public JTable table;
    public GheTableModel tableModel;

    public GhePanel(List<PhongChieu> dsPhong) {

        setLayout(new BorderLayout(10,10));

        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createTitledBorder("Ghế"));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        cboPhong = new JComboBox<>(dsPhong.toArray(new PhongChieu[0]));

        int y=0;
        addField(form, gbc, y++, "Mã", txtMa);
        addField(form, gbc, y++, "Tên", txtTen);
        addField(form, gbc, y++, "Loại", txtLoai);
        addField(form, gbc, y++, "Phòng", cboPhong);
        addField(form, gbc, y++, "Trạng thái", chkTrangThai);

        add(form, BorderLayout.WEST);

        tableModel = new GheTableModel();
        table = new JTable(tableModel);

        table.setDefaultRenderer(Object.class, new DefaultTableCellRenderer(){
            @Override
            public Component getTableCellRendererComponent(
                    JTable t, Object v, boolean s, boolean f, int r, int c) {

                Component comp = super.getTableCellRendererComponent(t, v, s, f, r, c);

                if (comp instanceof JComponent) {
                    ((JComponent) comp).setOpaque(true);
                }

                Object val = t.getValueAt(r, 4);
                String status = val != null ? val.toString() : "";

                if (s) {
                    comp.setBackground(new Color(70,130,180));
                } else {
                    comp.setBackground(
                            "Hỏng".equals(status) ? Color.RED : new Color(45,45,45)
                    );
                }

                comp.setForeground(Color.WHITE);

                return comp;
            }
        });

        add(new JScrollPane(table), BorderLayout.CENTER);

        JPanel btn = new JPanel();
        btn.add(btnAdd);
        btn.add(btnUpdate);
        btn.add(btnDelete);
        // ❌ KHÔNG CÒN btnGenerate

        add(btn, BorderLayout.SOUTH);
    }

    private void addField(JPanel p, GridBagConstraints g,int y,String l,JComponent f){
        g.gridx=0; g.gridy=y; p.add(new JLabel(l),g);
        g.gridx=1; p.add(f,g);
    }

    public JPanel createSeatMap(List<GheNgoi> list){
        JPanel p = new JPanel(new GridLayout(0,10,5,5));

        for(GheNgoi g:list){
            String label = g.getHangGhe() + g.getSoGhe();

            JButton b = new JButton(label);

            boolean isActive = "Hoạt động".equals(g.getTrangThaiGhe());

            b.setBackground(isActive ? Color.GREEN : Color.RED);
            b.setForeground(Color.WHITE);

            p.add(b);
        }
        return p;
    }
}