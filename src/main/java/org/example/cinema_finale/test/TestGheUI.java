package org.example.cinema_finale.test;

import org.example.cinema_finale.controller.GheController;
import org.example.cinema_finale.entity.PhongChieu;
import org.example.cinema_finale.view.GhePanel;

import javax.swing.*;
import java.util.ArrayList;
import java.util.List;

public class TestGheUI {

    public static void main(String[] args) {

        SwingUtilities.invokeLater(() -> {

            // ===== FLATLAF (nếu bạn đang dùng) =====
            try {
                UIManager.setLookAndFeel(
                        "com.formdev.flatlaf.FlatDarkLaf"
                );
            } catch (Exception e) {
                e.printStackTrace();
            }

            UIManager.put("Table.showHorizontalLines", true);
            UIManager.put("Table.showVerticalLines", true);

            // ===== DATA PHÒNG (demo) =====
            List<PhongChieu> dsPhong = new ArrayList<>();

            PhongChieu p1 = new PhongChieu();
            p1.setMaPhongChieu(1);
            p1.setTenPhongChieu("Phòng 1");

            PhongChieu p2 = new PhongChieu();
            p2.setMaPhongChieu(2);
            p2.setTenPhongChieu("Phòng 2");

            PhongChieu p3 = new PhongChieu();
            p3.setMaPhongChieu(3);
            p3.setTenPhongChieu("Phòng 3");

            dsPhong.add(p1);
            dsPhong.add(p2);
            dsPhong.add(p3);

            // ===== VIEW =====
            GhePanel panel = new GhePanel(dsPhong);

            // ===== CONTROLLER =====
            new GheController(panel);

            // ===== FRAME =====
            JFrame frame = new JFrame("🎬 Quản lý Ghế");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(1000, 600);
            frame.setLocationRelativeTo(null);

            frame.setContentPane(panel);
            frame.setVisible(true);
        });
    }
}