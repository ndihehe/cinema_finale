package org.example.cinema_finale.view.panel.staff;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;

public class StaffStatusBar extends JPanel {

    private final JLabel lblMessage;

    public StaffStatusBar() {
        setLayout(new BorderLayout());
        setBackground(Color.WHITE);
        setBorder(new EmptyBorder(6, 10, 6, 10));

        lblMessage = new JLabel("Trạng thái: Đang online");
        lblMessage.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        lblMessage.setForeground(new Color(40, 40, 40));

        add(lblMessage, BorderLayout.WEST);
    }

    public void setMessage(String message) {
        lblMessage.setText(message);
    }
}