package org.example.cinema_finale.view.panel.login;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Image;
import java.awt.RenderingHints;

import javax.imageio.ImageIO;
import javax.swing.JPanel;

/**
 * BackgroundPanel paints a cinematic background image loaded via getResource()
 * and centers the supplied child panel.
 */
public class BackgroundPanel extends JPanel {

    private Image bg;

    public BackgroundPanel(JPanel centerPanel, String resourcePath) {
        setLayout(new GridBagLayout());
        try {
            bg = ImageIO.read(getClass().getResourceAsStream(resourcePath));
        } catch (Exception e) {
            bg = null;
        }
        GridBagConstraints c = new GridBagConstraints();
        c.gridx = 0;
        c.gridy = 0;
        add(centerPanel, c);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2 = (Graphics2D) g.create();
        g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        int w = getWidth();
        int h = getHeight();
        if (bg != null) {
            double imgW = bg.getWidth(null);
            double imgH = bg.getHeight(null);
            double scale = Math.max(w / imgW, h / imgH);
            int nw = (int) (imgW * scale);
            int nh = (int) (imgH * scale);
            int x = (w - nw) / 2;
            int y = (h - nh) / 2;
            g2.drawImage(bg, x, y, nw, nh, null);
        } else {
            // fallback solid deep color
            g2.setColor(new java.awt.Color(10, 20, 34));
            g2.fillRect(0, 0, w, h);
        }

        g2.dispose();
    }
}
