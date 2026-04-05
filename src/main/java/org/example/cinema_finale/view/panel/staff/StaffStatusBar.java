package org.example.cinema_finale.view.panel.staff;

import java.awt.BorderLayout;
import java.awt.Font;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import org.example.cinema_finale.util.AppTheme;

public class StaffStatusBar extends JPanel {

    private final JLabel lblMessage;

    public StaffStatusBar() {
        setLayout(new BorderLayout());
        setBackground(AppTheme.BG_CARD);
        setBorder(new EmptyBorder(6, 10, 6, 10));

        lblMessage = new JLabel("Trạng thái: Đang online");
        lblMessage.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        lblMessage.setForeground(AppTheme.TEXT_MUTED);

        add(lblMessage, BorderLayout.WEST);
    }

    public void setMessage(String message) {
        lblMessage.setText(message);
    }
}