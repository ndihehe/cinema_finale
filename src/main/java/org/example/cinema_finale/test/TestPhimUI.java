package org.example.cinema_finale.test;

import org.example.cinema_finale.view.PhimPanel;
import org.example.cinema_finale.controller.PhimController;

import javax.swing.*;
import com.formdev.flatlaf.FlatDarkLaf;

public class TestPhimUI {

    public static void main(String[] args) {
        FlatDarkLaf.setup(); //  DARK MODE

        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("🎬 Cinema Manager");
            frame.setSize(1100, 650);
            frame.setLocationRelativeTo(null);

            PhimPanel panel = new PhimPanel();
            new PhimController(panel);

            frame.setContentPane(panel);
            frame.setVisible(true);
        });
    }
}