package org.example.cinema_finale.view.frame;

import javax.swing.JFrame;

import org.example.cinema_finale.controller.LoginController;
import org.example.cinema_finale.util.AppTheme;
import org.example.cinema_finale.view.panel.login.LoginPanel;

public class LoginFrame extends JFrame {

    public LoginFrame() {
        setTitle("Cinema Finale - Đăng nhập");
        setSize(640, 360);
        setMinimumSize(new java.awt.Dimension(620, 340));
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);
        getContentPane().setBackground(AppTheme.BG_APP);

        LoginPanel loginPanel = new LoginPanel();
        setContentPane(loginPanel);
        getContentPane().setBackground(AppTheme.BG_APP);

        new LoginController(this, loginPanel);
    }
}