package org.example.cinema_finale;

import javax.swing.SwingUtilities;

import org.example.cinema_finale.util.AppTheme;
import org.example.cinema_finale.view.frame.LoginFrame;

public class MainApp {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            AppTheme.installGlobal();
            LoginFrame loginFrame = new LoginFrame();

            loginFrame.setVisible(true);
        });
    }
}