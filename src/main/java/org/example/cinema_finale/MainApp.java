package org.example.cinema_finale;

import javax.swing.SwingUtilities;

import org.example.cinema_finale.controller.user.UserBookingController;
import org.example.cinema_finale.util.AppTheme;
import org.example.cinema_finale.view.frame.LoginFrame;
import org.example.cinema_finale.view.user.UserFrame;

public class MainApp {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            AppTheme.installGlobal();

            if (Boolean.getBoolean("user.booking.demo")) {
                UserFrame userFrame = new UserFrame();
                UserBookingController controller = new UserBookingController(userFrame);
                controller.toString();
                userFrame.setVisible(true);
                return;
            }

            LoginFrame loginFrame = new LoginFrame();

            loginFrame.setVisible(true);
        });
    }
}