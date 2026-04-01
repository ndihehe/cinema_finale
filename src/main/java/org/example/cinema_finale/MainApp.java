package org.example.cinema_finale;

import com.formdev.flatlaf.FlatDarkLaf;
import org.example.cinema_finale.view.frame.LoginFrame;

import javax.swing.*;

public class MainApp {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {

            try {
                FlatDarkLaf.setup(); // 🔥 DARK MODE
            } catch (Exception e) {
                e.printStackTrace();
            }
            LoginFrame loginFrame = new LoginFrame();

            loginFrame.setVisible(true);
        });
    }
}