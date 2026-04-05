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

        add(new ShadowTitleLabel("CINEMA MANAGEMENT SYSTEM"), gbc);
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
            setPreferredSize(new Dimension(1200, 110));
            setOpaque(false);
        }

        @Override
        protected void paintComponent(Graphics g) {
            Graphics2D g2 = (Graphics2D) g.create();
            g2.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
            g2.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);

            Font font = pickFont(46f);
            g2.setFont(font);

            FontMetrics fm = g2.getFontMetrics();
            int x = (getWidth() - fm.stringWidth(text)) / 2;
            int y = (getHeight() - fm.getHeight()) / 2 + fm.getAscent();

            g2.setColor(new Color(0, 0, 0, 180));
            g2.drawString(text, x + 4, y + 4);

            GradientPaint silver = new GradientPaint(
                    0, y - fm.getAscent(), new Color(245, 245, 245),
                    0, y + fm.getDescent(), new Color(145, 145, 145)
            );
            g2.setPaint(silver);
            g2.drawString(text, x, y);

            g2.dispose();
        }

        private Font pickFont(float size) {
            String[] candidates = {
                    "Orbitron",
                    "Eurostile",
                    "BankGothic Md BT",
                    "Agency FB",
                    "Arial Black"
            };

            GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
            java.util.List<String> available =
                    java.util.Arrays.asList(ge.getAvailableFontFamilyNames());

            for (String name : candidates) {
                if (available.contains(name)) {
                    return new Font(name, Font.BOLD, (int) size);
                }
            }
            return new Font("Arial Black", Font.BOLD, (int) size);
        }
    }
}