package org.example.cinema_finale.view;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.GridLayout;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.Border;

import org.example.cinema_finale.util.AppTheme;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;

public class ThongKePanel extends JPanel {

    private static final Border CARD_BORDER = BorderFactory.createLineBorder(new Color(70, 78, 91), 1);
    private static final Border CARD_SELECTED_BORDER = BorderFactory.createLineBorder(new Color(59, 130, 246), 2);

    public JLabel lblDoanhThu = new JLabel("0");
    public JLabel lblVe = new JLabel("0");
    public JLabel lblGiamGia = new JLabel("0");
    public JTextField txtMovieSearch = new JTextField(16);
        public JComboBox<String> cboRevenueFilter = new JComboBox<>(new String[]{
            "Tất cả phim",
            "Phim có doanh thu",
            "Phim chưa có doanh thu"
        });

    private final JPanel movieListPanel = new JPanel();
    private final JPanel chartContainer = new JPanel(new BorderLayout());
    private final JLabel chartPlaceholder = new JLabel("Vui lòng chọn một phim bên trái để xem doanh thu", SwingConstants.CENTER);

    private final Map<JPanel, MovieCardData> cardMap = new LinkedHashMap<>();
    private JPanel selectedCard;
    private Consumer<MovieCardData> selectionListener;

    public ThongKePanel() {

        setLayout(new BorderLayout(10, 10));
        setBackground(AppTheme.BG_APP);

        JLabel title = new JLabel("THỐNG KÊ DOANH THU");
        title.setForeground(AppTheme.TEXT_PRIMARY);
        title.setFont(new Font("Segoe UI", Font.BOLD, 22));
        add(title, BorderLayout.NORTH);

        JPanel kpi = new JPanel(new GridLayout(1, 3, 10, 10));
        kpi.setBackground(AppTheme.BG_APP);

        kpi.add(card("Doanh thu", lblDoanhThu));
        kpi.add(card("Vé bán", lblVe));
        kpi.add(card("Giảm giá", lblGiamGia));

        add(kpi, BorderLayout.SOUTH);

        movieListPanel.setLayout(new BoxLayout(movieListPanel, BoxLayout.Y_AXIS));
        movieListPanel.setBackground(AppTheme.BG_APP);

        JPanel leftContainer = new JPanel(new BorderLayout(8, 8));
        leftContainer.setPreferredSize(new Dimension(300, 0));
        AppTheme.styleTitledPanel(leftContainer, "Danh sách phim");

        JPanel searchPanel = new JPanel(new GridLayout(2, 2, 6, 6));
        searchPanel.setBackground(AppTheme.BG_APP);

        JLabel lblSearch = new JLabel("Tìm phim:");
        JLabel lblRevenueFilter = new JLabel("Lọc doanh thu:");
        lblSearch.setForeground(AppTheme.TEXT_MUTED);
        lblRevenueFilter.setForeground(AppTheme.TEXT_MUTED);

        AppTheme.styleSearchField(txtMovieSearch);
        cboRevenueFilter.setBackground(AppTheme.BG_CARD);
        cboRevenueFilter.setForeground(AppTheme.TEXT_PRIMARY);

        searchPanel.add(lblSearch);
        searchPanel.add(txtMovieSearch);
        searchPanel.add(lblRevenueFilter);
        searchPanel.add(cboRevenueFilter);

        JScrollPane movieScroll = new JScrollPane(movieListPanel);
        movieScroll.getViewport().setBackground(AppTheme.BG_APP);

        leftContainer.add(searchPanel, BorderLayout.NORTH);
        leftContainer.add(movieScroll, BorderLayout.CENTER);
        add(leftContainer, BorderLayout.WEST);

        chartContainer.setBackground(AppTheme.BG_APP);
        chartContainer.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(70, 78, 91), 1),
                BorderFactory.createEmptyBorder(8, 8, 8, 8)
        ));

        chartPlaceholder.setForeground(AppTheme.TEXT_MUTED);
        chartPlaceholder.setFont(new Font("Segoe UI", Font.BOLD, 17));
        chartContainer.add(chartPlaceholder, BorderLayout.CENTER);
        add(chartContainer, BorderLayout.CENTER);
    }

    private JPanel card(String title, JLabel value) {
        JPanel p = new JPanel(new BorderLayout());
        p.setBackground(AppTheme.BG_CARD);

        JLabel t = new JLabel(title);
        t.setForeground(AppTheme.TEXT_MUTED);

        value.setForeground(new Color(74, 222, 128));
        value.setFont(new Font("Segoe UI", Font.BOLD, 20));
        value.setHorizontalAlignment(SwingConstants.CENTER);

        p.add(t, BorderLayout.NORTH);
        p.add(value, BorderLayout.CENTER);

        return p;
    }

    public void setMovieSelectionListener(Consumer<MovieCardData> listener) {
        this.selectionListener = listener;
    }

    public void showPlaceholder() {
        chartContainer.removeAll();
        chartContainer.add(chartPlaceholder, BorderLayout.CENTER);
        chartContainer.revalidate();
        chartContainer.repaint();
    }

    public void updateSummary(int soVe, BigDecimal doanhThu, BigDecimal giamGia) {
        lblVe.setText(String.valueOf(soVe));
        lblDoanhThu.setText(String.format("%,d đ", doanhThu.longValue()));
        lblGiamGia.setText(String.format("%,d đ", giamGia.longValue()));
    }

    public void setMovieCards(List<MovieCardData> movies) {
        movieListPanel.removeAll();
        cardMap.clear();
        selectedCard = null;

        for (MovieCardData movie : movies) {
            JPanel card = createMovieCard(movie);
            cardMap.put(card, movie);
            movieListPanel.add(card);
            movieListPanel.add(Box.createVerticalStrut(8));
        }

        movieListPanel.revalidate();
        movieListPanel.repaint();
    }

    private JPanel createMovieCard(MovieCardData movie) {
        JPanel card = new JPanel(new BorderLayout(8, 8));
        card.setBackground(AppTheme.BG_CARD);
        card.setBorder(CARD_BORDER);
        card.setMaximumSize(new Dimension(Integer.MAX_VALUE, 190));

        JLabel thumbnail = new JLabel();
        thumbnail.setHorizontalAlignment(SwingConstants.CENTER);
        thumbnail.setPreferredSize(new Dimension(240, 130));
        thumbnail.setIcon(loadScaledPoster(movie.posterPath(), 240, 130));

        JLabel movieName = new JLabel(movie.movieName(), SwingConstants.CENTER);
        movieName.setForeground(AppTheme.TEXT_PRIMARY);
        movieName.setFont(new Font("Segoe UI", Font.BOLD, 14));
        movieName.setBorder(BorderFactory.createEmptyBorder(0, 6, 8, 6));

        card.add(thumbnail, BorderLayout.CENTER);
        card.add(movieName, BorderLayout.SOUTH);

        attachCardEvents(card, movie);
        for (Component child : card.getComponents()) {
            attachCardEvents(child, movie);
        }

        return card;
    }

    private void attachCardEvents(Component component, MovieCardData movie) {
        component.addMouseListener(new java.awt.event.MouseAdapter() {
            @Override
            public void mouseEntered(java.awt.event.MouseEvent e) {
                JPanel card = getCardContainer(component);
                if (card != selectedCard) {
                    card.setBackground(new Color(52, 60, 74));
                }
            }

            @Override
            public void mouseExited(java.awt.event.MouseEvent e) {
                JPanel card = getCardContainer(component);
                if (card != selectedCard) {
                    card.setBackground(AppTheme.BG_CARD);
                }
            }

            @Override
            public void mouseClicked(java.awt.event.MouseEvent e) {
                JPanel card = getCardContainer(component);
                selectCard(card);
                if (selectionListener != null) {
                    selectionListener.accept(movie);
                }
            }
        });
    }

    private JPanel getCardContainer(Component component) {
        if (component instanceof JPanel panel && cardMap.containsKey(panel)) {
            return panel;
        }
        return (JPanel) component.getParent();
    }

    private void selectCard(JPanel card) {
        if (selectedCard != null) {
            selectedCard.setBorder(CARD_BORDER);
            selectedCard.setBackground(AppTheme.BG_CARD);
        }

        selectedCard = card;
        selectedCard.setBorder(CARD_SELECTED_BORDER);
        selectedCard.setBackground(new Color(52, 60, 74));
    }

    public void renderRevenueChart(String movieName, Map<String, BigDecimal> revenueByWeekday) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for (Map.Entry<String, BigDecimal> entry : revenueByWeekday.entrySet()) {
            dataset.addValue(entry.getValue(), "Doanh thu", entry.getKey());
        }

        JFreeChart chart = ChartFactory.createBarChart(
                "Doanh thu phim: " + movieName,
                "Ngày trong tuần",
                "Doanh thu (VNĐ)",
                dataset,
                PlotOrientation.VERTICAL,
                false,
                true,
                false
        );

        styleChart(chart);

        ChartPanel chartPanel = new ChartPanel(chart);
        chartPanel.setMouseWheelEnabled(true);
        chartPanel.setBackground(AppTheme.BG_APP);

        chartContainer.removeAll();
        chartContainer.add(chartPanel, BorderLayout.CENTER);
        chartContainer.revalidate();
        chartContainer.repaint();
    }

    private void styleChart(JFreeChart chart) {
        chart.setBackgroundPaint(AppTheme.BG_APP);
        chart.getTitle().setPaint(AppTheme.TEXT_PRIMARY);
        chart.getTitle().setFont(new Font("Segoe UI", Font.BOLD, 18));

        CategoryPlot plot = chart.getCategoryPlot();
        plot.setBackgroundPaint(new Color(34, 40, 50));
        plot.setOutlinePaint(new Color(76, 86, 104));
        plot.getRangeAxis().setLabelPaint(AppTheme.TEXT_PRIMARY);
        plot.getRangeAxis().setTickLabelPaint(AppTheme.TEXT_MUTED);
        plot.getDomainAxis().setLabelPaint(AppTheme.TEXT_PRIMARY);
        plot.getDomainAxis().setTickLabelPaint(AppTheme.TEXT_MUTED);
        plot.getRenderer().setSeriesPaint(0, new Color(59, 130, 246));
        plot.setRangeGridlinePaint(new Color(74, 85, 104));
    }

    private ImageIcon loadScaledPoster(String posterPath, int width, int height) {
        if (posterPath == null || posterPath.isBlank()) {
            return new ImageIcon(createPosterPlaceholder(width, height));
        }

        ImageIcon source = new ImageIcon(posterPath);
        if (source.getIconWidth() <= 0 || source.getIconHeight() <= 0) {
            return new ImageIcon(createPosterPlaceholder(width, height));
        }

        double scale = Math.min((double) width / source.getIconWidth(), (double) height / source.getIconHeight());
        int drawW = Math.max(1, (int) Math.round(source.getIconWidth() * scale));
        int drawH = Math.max(1, (int) Math.round(source.getIconHeight() * scale));

        BufferedImage output = new BufferedImage(drawW, drawH, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2 = output.createGraphics();
        try {
            g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g2.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2.drawImage(source.getImage(), 0, 0, drawW, drawH, null);
        } finally {
            g2.dispose();
        }

        return new ImageIcon(output);
    }

    private BufferedImage createPosterPlaceholder(int width, int height) {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2 = image.createGraphics();
        try {
            g2.setColor(new Color(59, 130, 246));
            g2.fillRect(0, 0, width, height);

            g2.setFont(new Font("Segoe UI", Font.BOLD, 16));
            g2.setColor(Color.WHITE);
            g2.drawString("NO POSTER", 20, height / 2);
        } finally {
            g2.dispose();
        }
        return image;
    }

    public record MovieCardData(String movieName, String posterPath) {
    }
}
