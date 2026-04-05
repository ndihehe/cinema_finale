package org.example.cinema_finale.view.frame;

import javax.swing.JFrame;

import org.example.cinema_finale.controller.LoginController;

public class LoginFrame extends JFrame {

    public LoginFrame() {
        setTitle("Cinema Finale - Đăng nhập");
        setSize(1000, 620);
        setMinimumSize(new java.awt.Dimension(900, 560));
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);

        // Build background panel that paints cinematic image and centers the login form
        org.example.cinema_finale.view.panel.login.LoginPanel loginPanel = new org.example.cinema_finale.view.panel.login.LoginPanel();
        org.example.cinema_finale.view.panel.login.BackgroundPanel background = new org.example.cinema_finale.view.panel.login.BackgroundPanel(loginPanel, "/images/login/login_background.jpg");
        setContentPane(background);

        // keep existing login flow wiring
        new LoginController(this, loginPanel);
    }
}