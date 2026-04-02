package org.example.cinema_finale.view.frame;

import org.example.cinema_finale.controller.LoginController;
import org.example.cinema_finale.view.panel.login.LoginPanel;

import javax.swing.*;

public class LoginFrame extends JFrame {

    public LoginFrame() {
        setTitle("Đăng nhập hệ thống");
        setSize(420, 250);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);

        LoginPanel loginPanel = new LoginPanel();
        setContentPane(loginPanel);

        new LoginController(this, loginPanel);
    }
}