package org.example.cinema_finale.view.user;

import java.awt.BorderLayout;
import java.awt.CardLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingConstants;
import javax.swing.Timer;

import org.example.cinema_finale.util.AppTheme;
import org.example.cinema_finale.view.user.panel.MovieListPanel;
import org.example.cinema_finale.view.user.panel.PaymentPanel;
import org.example.cinema_finale.view.user.panel.ProductSelectionPanel;
import org.example.cinema_finale.view.user.panel.SeatSelectionPanel;
import org.example.cinema_finale.view.user.panel.ShowtimeSelectionPanel;

public class UserFrame extends JFrame {

    public static final String STEP_MOVIES = "STEP_MOVIES";
    public static final String STEP_SHOWTIMES = "STEP_SHOWTIMES";
    public static final String STEP_SEATS = "STEP_SEATS";
    public static final String STEP_PRODUCTS = "STEP_PRODUCTS";
    public static final String STEP_PAYMENT = "STEP_PAYMENT";

    private static final Color STEP_BG_ACTIVE = new Color(59, 130, 246);
    private static final Color STEP_BG_DONE = new Color(34, 197, 94);
    private static final Color STEP_BG_INACTIVE = new Color(70, 78, 91);
    private static final Font STEP_FONT = new Font("Segoe UI", Font.BOLD, 12);

    private final CardLayout cardLayout = new CardLayout();
    private final JPanel contentPanel = new JPanel(cardLayout);
    private final JLabel[] stepLabels;
        private final JLabel lblStepProgress = new JLabel("Bước 1/5: Chọn phim", SwingConstants.CENTER);
        private final FadeGlassPane fadeGlassPane = new FadeGlassPane();
    private final String[] stepKeys = {
            STEP_MOVIES,
            STEP_SHOWTIMES,
            STEP_SEATS,
            STEP_PRODUCTS,
            STEP_PAYMENT
    };
        private final String[] stepTitles = {
            "Chọn phim",
            "Chọn suất chiếu",
            "Chọn ghế",
            "Chọn sản phẩm",
            "Thanh toán"
        };

    private final MovieListPanel movieListPanel = new MovieListPanel();
    private final ShowtimeSelectionPanel showtimeSelectionPanel = new ShowtimeSelectionPanel();
    private final SeatSelectionPanel seatSelectionPanel = new SeatSelectionPanel();
    private final ProductSelectionPanel productSelectionPanel = new ProductSelectionPanel();
    private final PaymentPanel paymentPanel = new PaymentPanel();
    private final JButton btnLogout = new JButton("Đăng xuất");

    private Runnable logoutListener;

    public UserFrame() {
        setTitle("Cinema Finale - Đặt vé xem phim");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(1320, 780);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());

        JLabel header = new JLabel("ĐẶT VÉ XEM PHIM", SwingConstants.CENTER);
        header.setFont(header.getFont().deriveFont(22f));
        header.setForeground(AppTheme.TEXT_PRIMARY);

        AppTheme.styleWarningButton(btnLogout);
        btnLogout.addActionListener(e -> {
            if (logoutListener != null) {
                logoutListener.run();
            }
        });

        JPanel titleRow = new JPanel(new BorderLayout());
        titleRow.setBackground(AppTheme.BG_CARD);
        titleRow.setBorder(BorderFactory.createEmptyBorder(6, 8, 0, 8));
        titleRow.add(header, BorderLayout.CENTER);
        titleRow.add(btnLogout, BorderLayout.EAST);

        lblStepProgress.setForeground(AppTheme.TEXT_MUTED);
        lblStepProgress.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        lblStepProgress.setBorder(BorderFactory.createEmptyBorder(0, 0, 4, 0));

        stepLabels = new JLabel[]{
            buildStepLabel("1. Chọn phim"),
            buildStepLabel("2. Chọn suất"),
            buildStepLabel("3. Chọn ghế"),
            buildStepLabel("4. Sản phẩm"),
            buildStepLabel("5. Thanh toán")
        };

        JPanel stepPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 8, 6));
        stepPanel.setBackground(AppTheme.BG_CARD);
        for (JLabel stepLabel : stepLabels) {
            stepPanel.add(stepLabel);
        }

        JPanel top = new JPanel();
        top.setLayout(new BoxLayout(top, BoxLayout.Y_AXIS));
        top.setBackground(AppTheme.BG_CARD);
        top.add(titleRow);
        top.add(lblStepProgress);
        top.add(stepPanel);

        contentPanel.add(movieListPanel, STEP_MOVIES);
        contentPanel.add(showtimeSelectionPanel, STEP_SHOWTIMES);
        contentPanel.add(seatSelectionPanel, STEP_SEATS);
        contentPanel.add(productSelectionPanel, STEP_PRODUCTS);
        contentPanel.add(paymentPanel, STEP_PAYMENT);

        add(top, BorderLayout.NORTH);
        add(contentPanel, BorderLayout.CENTER);

        setGlassPane(fadeGlassPane);
        updateStepIndicator(STEP_MOVIES);
    }

    public void showStep(String step) {
        cardLayout.show(contentPanel, step);
        updateStepIndicator(step);
        playStepTransition();
    }

    private JLabel buildStepLabel(String text) {
        JLabel label = new JLabel(text, SwingConstants.CENTER);
        label.setOpaque(true);
        label.setBackground(STEP_BG_INACTIVE);
        label.setForeground(Color.WHITE);
        label.setFont(STEP_FONT);
        label.setBorder(BorderFactory.createEmptyBorder(6, 12, 6, 12));
        return label;
    }

    private void updateStepIndicator(String step) {
        int currentIndex = indexOfStep(step);
        for (int i = 0; i < stepKeys.length; i++) {
            if (currentIndex < 0) {
                stepLabels[i].setBackground(STEP_BG_INACTIVE);
                stepLabels[i].setBorder(BorderFactory.createEmptyBorder(6, 12, 6, 12));
                stepLabels[i].setFont(STEP_FONT);
                continue;
            }

            if (i < currentIndex) {
                stepLabels[i].setBackground(STEP_BG_DONE);
                stepLabels[i].setBorder(BorderFactory.createEmptyBorder(6, 12, 6, 12));
                stepLabels[i].setFont(STEP_FONT);
            } else if (i == currentIndex) {
                stepLabels[i].setBackground(STEP_BG_ACTIVE);
                stepLabels[i].setBorder(BorderFactory.createCompoundBorder(
                        BorderFactory.createLineBorder(Color.WHITE, 1),
                        BorderFactory.createEmptyBorder(5, 11, 5, 11)
                ));
                stepLabels[i].setFont(STEP_FONT.deriveFont(Font.BOLD, 13f));
            } else {
                stepLabels[i].setBackground(STEP_BG_INACTIVE);
                stepLabels[i].setBorder(BorderFactory.createEmptyBorder(6, 12, 6, 12));
                stepLabels[i].setFont(STEP_FONT);
            }
            stepLabels[i].setForeground(Color.WHITE);
        }

        if (currentIndex >= 0) {
            lblStepProgress.setText("Bước " + (currentIndex + 1) + "/" + stepKeys.length + ": " + stepTitles[currentIndex]);
        } else {
            lblStepProgress.setText("Bước 1/" + stepKeys.length + ": " + stepTitles[0]);
        }
    }

    private int indexOfStep(String step) {
        if (step == null) {
            return -1;
        }
        for (int i = 0; i < stepKeys.length; i++) {
            if (stepKeys[i].equals(step)) {
                return i;
            }
        }
        return -1;
    }

    private void playStepTransition() {
        fadeGlassPane.setAlpha(0.16f);
        fadeGlassPane.setVisible(true);

        Timer timer = new Timer(16, null);
        timer.addActionListener(e -> {
            float next = fadeGlassPane.getAlpha() - 0.02f;
            if (next <= 0f) {
                fadeGlassPane.setAlpha(0f);
                fadeGlassPane.setVisible(false);
                timer.stop();
                return;
            }
            fadeGlassPane.setAlpha(next);
        });
        timer.start();
    }

    private static class FadeGlassPane extends JPanel {
        private float alpha;

        FadeGlassPane() {
            setOpaque(false);
            setVisible(false);
        }

        float getAlpha() {
            return alpha;
        }

        void setAlpha(float alpha) {
            this.alpha = Math.max(0f, Math.min(1f, alpha));
            repaint();
        }

        @Override
        protected void paintComponent(Graphics g) {
            super.paintComponent(g);
            if (alpha <= 0f) {
                return;
            }
            Graphics2D g2 = (Graphics2D) g.create();
            try {
                g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                g2.setColor(new Color(0f, 0f, 0f, alpha));
                g2.fillRect(0, 0, getWidth(), getHeight());
            } finally {
                g2.dispose();
            }
        }

        @Override
        public Dimension getPreferredSize() {
            return new Dimension(1, 1);
        }
    }

    public MovieListPanel getMovieListPanel() {
        return movieListPanel;
    }

    public ShowtimeSelectionPanel getShowtimeSelectionPanel() {
        return showtimeSelectionPanel;
    }

    public SeatSelectionPanel getSeatSelectionPanel() {
        return seatSelectionPanel;
    }

    public ProductSelectionPanel getProductSelectionPanel() {
        return productSelectionPanel;
    }

    public PaymentPanel getPaymentPanel() {
        return paymentPanel;
    }

    public void setLogoutListener(Runnable logoutListener) {
        this.logoutListener = logoutListener;
    }
}
