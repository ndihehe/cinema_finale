package org.example.cinema_finale.view;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;

import org.example.cinema_finale.tablemodel.ThongKeTableModel;
import org.example.cinema_finale.util.AppTheme;

import com.toedter.calendar.JDateChooser;

public class ThongKePanel extends JPanel {

    public JLabel lblDoanhThu = new JLabel("0");
    public JLabel lblVe = new JLabel("0");
    public JLabel lblGiamGia = new JLabel("0");

    // ===== THEO NGÀY =====
    public JDateChooser dateFromNgay = new JDateChooser();
    public JDateChooser dateToNgay = new JDateChooser();

    // ===== THEO PHIM =====
    public JComboBox<String> cboPhim = new JComboBox<>();

    public JButton btnNgay = new JButton("Thống kê");

    public JTable table;
    public ThongKeTableModel tableModel = new ThongKeTableModel();

    public ThongKePanel() {

        setLayout(new BorderLayout(10,10));
        setBackground(AppTheme.BG_APP);

        JLabel title = new JLabel("THỐNG KÊ DOANH THU");
        title.setForeground(AppTheme.TEXT_PRIMARY);
        title.setFont(new Font("Segoe UI", Font.BOLD, 22));
        add(title, BorderLayout.NORTH);

        // ===== KPI =====
        JPanel kpi = new JPanel(new GridLayout(1,3,10,10));
        kpi.setBackground(AppTheme.BG_APP);

        kpi.add(card("Doanh thu", lblDoanhThu));
        kpi.add(card("Vé bán", lblVe));
        kpi.add(card("Giảm giá", lblGiamGia));

        add(kpi, BorderLayout.WEST);

        // ===== TABLE =====
        table = new JTable(tableModel);
        AppTheme.styleTable(table);

        add(new JScrollPane(table), BorderLayout.CENTER);

        // ===== TABS =====
        JTabbedPane tabs = new JTabbedPane();
        tabs.add("Theo ngày", panelNgay());
        tabs.add("Theo phim", panelPhim());

        add(tabs, BorderLayout.SOUTH);
    }

    private JPanel card(String title, JLabel value){
        JPanel p = new JPanel(new BorderLayout());
        p.setBackground(AppTheme.BG_CARD);

        JLabel t = new JLabel(title);
        t.setForeground(AppTheme.TEXT_MUTED);

        value.setForeground(new Color(74, 222, 128));
        value.setFont(new Font("Segoe UI", Font.BOLD, 20));

        p.add(t, BorderLayout.NORTH);
        p.add(value, BorderLayout.CENTER);

        return p;
    }

    private JPanel panelNgay(){
        JPanel p = panel();
        p.add(new JLabel("Từ:")); p.add(dateFromNgay);
        p.add(new JLabel("Đến:")); p.add(dateToNgay);
        p.add(btnNgay);
        return p;
    }

    private JPanel panelPhim(){
        JPanel p = panel();
        p.add(new JLabel("Phim:")); p.add(cboPhim);
        return p;
    }

    private JPanel panel(){
        JPanel p = new JPanel();
        p.setBackground(AppTheme.BG_APP);
        p.setForeground(AppTheme.TEXT_PRIMARY);
        return p;
    }
}