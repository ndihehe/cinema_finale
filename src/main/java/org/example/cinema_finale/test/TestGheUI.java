package org.example.cinema_finale.test;

import org.example.cinema_finale.controller.GheController;
import org.example.cinema_finale.view.GhePanel;

import javax.swing.*;

public class TestGheUI {

    public static void main(String[] args) {

        SwingUtilities.invokeLater(() -> {

            try {
                UIManager.setLookAndFeel(
                        "com.formdev.flatlaf.FlatDarkLaf"
                );
            } catch (Exception e) {
                e.printStackTrace();
            }

            UIManager.put("Table.showHorizontalLines", true);
            UIManager.put("Table.showVerticalLines", true);

            // ✅ KHÔNG TRUYỀN dsPhong NỮA
            GhePanel panel = new GhePanel();

            new GheController(panel);

            JFrame frame = new JFrame("🎬 Quản lý Ghế");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(1000, 600);
            frame.setLocationRelativeTo(null);

            frame.setContentPane(panel);
            frame.setVisible(true);
        });
    }
}