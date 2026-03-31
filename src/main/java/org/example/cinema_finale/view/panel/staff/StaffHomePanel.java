package org.example.cinema_finale.view.panel.staff;

import javax.swing.*;
import java.awt.*;
import java.net.URL;

public class StaffHomePanel extends JPanel {

    private Image backgroundImage;

    public StaffHomePanel() {
        setLayout(new GridBagLayout());

        URL imageUrl = getClass().getResource("/images/staff-home-cinema.jpg");
        if (imageUrl != null) {
            backgroundImage = new ImageIcon(imageUrl).getImage();
        }

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.weightx = 1;
        gbc.weighty = 1;
        gbc.anchor = GridBagConstraints.CENTER;

        add(new ShadowTitleLabel("HỆ THỐNG QUẢN LÝ RẠP CHIẾU PHIM"), gbc);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);

        if (backgroundImage != null) {
            g.drawImage(backgroundImage, 0, 0, getWidth(), getHeight(), this);
        } else {
            Graphics2D g2d = (Graphics2D) g.create();
            g2d.setPaint(new GradientPaint(
                    0, 0, new Color(25, 35, 55),
                    getWidth(), getHeight(), new Color(70, 20, 20)
            ));
            g2d.fillRect(0, 0, getWidth(), getHeight());
            g2d.dispose();
        }

        Graphics2D overlay = (Graphics2D) g.create();
        overlay.setColor(new Color(0, 0, 0, 70));
        overlay.fillRect(0, 0, getWidth(), getHeight());
        overlay.dispose();
    }

    private static class ShadowTitleLabel extends JComponent {

        private final String text;

        public ShadowTitleLabel(String text) {
            this.text = text;
            setPreferredSize(new Dimension(1100, 100));
            setOpaque(false);
        }

        @Override
        protected void paintComponent(Graphics g) {
            Graphics2D g2 = (Graphics2D) g.create();
            g2.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

            Font font = new Font("Segoe UI Black", Font.BOLD, 42);
            g2.setFont(font);

            FontMetrics fm = g2.getFontMetrics();
            int x = (getWidth() - fm.stringWidth(text)) / 2;
            int y = (getHeight() - fm.getHeight()) / 2 + fm.getAscent();

            g2.setColor(new Color(0, 0, 0, 150));
            g2.drawString(text, x + 3, y + 3);

            g2.setColor(Color.WHITE);
            g2.drawString(text, x, y);

            g2.dispose();
        }
    }
}