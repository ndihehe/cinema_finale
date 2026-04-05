package org.example.cinema_finale.view;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.border.Border;

import org.example.cinema_finale.service.PhimService;
import org.example.cinema_finale.service.ThongKeDoanhSoService;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;

public class ThongKeDoanhThuDashboardPanel extends JPanel {

    private static final Color BG_MAIN = new Color(27, 32, 40);
    private static final Color BG_CARD = new Color(37, 44, 56);
    private static final Color BG_CARD_HOVER = new Color(50, 59, 74);
    private static final Color TEXT_PRIMARY = new Color(236, 241, 247);
    private static final Color TEXT_MUTED = new Color(171, 183, 201);
    private static final Border CARD_BORDER = BorderFactory.createLineBorder(new Color(66, 76, 93), 1);
    private static final Border CARD_SELECTED_BORDER = BorderFactory.createLineBorder(new Color(59, 130, 246), 2);

    private final JPanel movieListPanel;
    private final JPanel chartContainer;
        private final JComboBox<String> cboRevenueFilter = new JComboBox<>(new String[]{
            "Tất cả phim",
            "Phim có doanh thu",
            "Phim chưa có doanh thu"
        });
    private JPanel selectedCard;
    private final PhimService phimService = new PhimService();
    private final ThongKeDoanhSoService thongKeDoanhSoService = new ThongKeDoanhSoService();
        private List<MovieRevenue> allMovies = new ArrayList<>();

    public ThongKeDoanhThuDashboardPanel() {
        setLayout(new BorderLayout(12, 12));
        setBackground(BG_MAIN);
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        movieListPanel = new JPanel();
        movieListPanel.setLayout(new BoxLayout(movieListPanel, BoxLayout.Y_AXIS));
        movieListPanel.setBackground(BG_MAIN);

        JScrollPane leftScroll = new JScrollPane(movieListPanel);
        leftScroll.setPreferredSize(new Dimension(280, 0));
        leftScroll.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(new Color(66, 76, 93)),
                "Danh sách phim"
        ));
        leftScroll.getViewport().setBackground(BG_MAIN);

        JPanel leftPanel = new JPanel(new BorderLayout(8, 8));
        leftPanel.setBackground(BG_MAIN);
        leftPanel.setPreferredSize(new Dimension(300, 0));

        JPanel filterPanel = new JPanel(new BorderLayout(6, 0));
        filterPanel.setBackground(BG_MAIN);
        JLabel lblFilter = new JLabel("Lọc doanh thu:");
        lblFilter.setForeground(TEXT_MUTED);
        cboRevenueFilter.setBackground(BG_CARD);
        cboRevenueFilter.setForeground(TEXT_PRIMARY);
        filterPanel.add(lblFilter, BorderLayout.WEST);
        filterPanel.add(cboRevenueFilter, BorderLayout.CENTER);

        leftPanel.add(filterPanel, BorderLayout.NORTH);
        leftPanel.add(leftScroll, BorderLayout.CENTER);
        add(leftPanel, BorderLayout.WEST);

        chartContainer = new JPanel(new BorderLayout());
        chartContainer.setBackground(BG_MAIN);
        chartContainer.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(66, 76, 93)),
                BorderFactory.createEmptyBorder(10, 10, 10, 10)
        ));
        add(chartContainer, BorderLayout.CENTER);

        cboRevenueFilter.addActionListener(e -> applyMovieFilter());

        showPlaceholder();
        allMovies = loadMoviesFromDatabase();
        applyMovieFilter();
    }

    private void applyMovieFilter() {
        String selected = (String) cboRevenueFilter.getSelectedItem();
        if (selected == null || selected.isBlank() || "Tất cả phim".equals(selected)) {
            loadMovieGallery(allMovies);
            return;
        }

        List<MovieRevenue> filtered = allMovies.stream()
                .filter(movie -> {
                    long revenue = totalRevenue(movie.revenueByWeekday());
                    if ("Phim có doanh thu".equals(selected)) {
                        return revenue > 0;
                    }
                    if ("Phim chưa có doanh thu".equals(selected)) {
                        return revenue <= 0;
                    }
                    return true;
                })
                .toList();

        loadMovieGallery(filtered);
    }

    private void loadMovieGallery(List<MovieRevenue> movies) {
        movieListPanel.removeAll();

        if (movies == null || movies.isEmpty()) {
            JLabel empty = new JLabel("Chưa có dữ liệu doanh thu để hiển thị", SwingConstants.CENTER);
            empty.setForeground(TEXT_MUTED);
            empty.setFont(new Font("Segoe UI", Font.PLAIN, 14));
            movieListPanel.add(empty);

            movieListPanel.revalidate();
            movieListPanel.repaint();
            return;
        }

        for (MovieRevenue movie : movies) {
            JPanel card = createMovieCard(movie);
            movieListPanel.add(card);
            movieListPanel.add(Box.createVerticalStrut(8));
        }

        movieListPanel.revalidate();
        movieListPanel.repaint();
    }

    private JPanel createMovieCard(MovieRevenue movie) {
        JPanel card = new JPanel(new BorderLayout(8, 8));
        card.setBackground(BG_CARD);
        card.setBorder(CARD_BORDER);
        card.setMaximumSize(new Dimension(Integer.MAX_VALUE, 200));

        JLabel thumbnail = new JLabel();
        thumbnail.setHorizontalAlignment(SwingConstants.CENTER);
        thumbnail.setPreferredSize(new Dimension(240, 130));
        thumbnail.setIcon(loadScaledThumbnail(movie.thumbnailPath(), 240, 130));

        JLabel title = new JLabel(movie.title());
        title.setFont(new Font("Segoe UI", Font.BOLD, 14));
        title.setForeground(TEXT_PRIMARY);
        title.setHorizontalAlignment(SwingConstants.CENTER);
        title.setBorder(BorderFactory.createEmptyBorder(0, 8, 8, 8));

        card.add(thumbnail, BorderLayout.CENTER);
        card.add(title, BorderLayout.SOUTH);

        card.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseEntered(MouseEvent e) {
                if (card != selectedCard) {
                    card.setBackground(BG_CARD_HOVER);
                }
            }

            @Override
            public void mouseExited(MouseEvent e) {
                if (card != selectedCard) {
                    card.setBackground(BG_CARD);
                }
            }

            @Override
            public void mouseClicked(MouseEvent e) {
                selectMovieCard(card);
                renderRevenueChart(movie);
            }
        });

        for (Component child : card.getComponents()) {
            child.addMouseListener(new MouseAdapter() {
                @Override
                public void mouseEntered(MouseEvent e) {
                    if (card != selectedCard) {
                        card.setBackground(BG_CARD_HOVER);
                    }
                }

                @Override
                public void mouseExited(MouseEvent e) {
                    if (card != selectedCard) {
                        card.setBackground(BG_CARD);
                    }
                }

                @Override
                public void mouseClicked(MouseEvent e) {
                    selectMovieCard(card);
                    renderRevenueChart(movie);
                }
            });
        }

        return card;
    }

    private void selectMovieCard(JPanel card) {
        if (selectedCard != null) {
            selectedCard.setBorder(CARD_BORDER);
            selectedCard.setBackground(BG_CARD);
        }

        selectedCard = card;
        selectedCard.setBorder(CARD_SELECTED_BORDER);
        selectedCard.setBackground(BG_CARD_HOVER);
    }

    private void showPlaceholder() {
        chartContainer.removeAll();

        JLabel placeholder = new JLabel("Vui lòng chọn một phim bên trái để xem doanh thu", SwingConstants.CENTER);
        placeholder.setForeground(TEXT_MUTED);
        placeholder.setFont(new Font("Segoe UI", Font.BOLD, 18));

        chartContainer.add(placeholder, BorderLayout.CENTER);
        chartContainer.revalidate();
        chartContainer.repaint();
    }

    private void renderRevenueChart(MovieRevenue movie) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        for (Map.Entry<String, Long> entry : movie.revenueByWeekday().entrySet()) {
            dataset.addValue(entry.getValue(), "Doanh thu", entry.getKey());
        }

        JFreeChart chart = ChartFactory.createBarChart(
                "Doanh thu phim: " + movie.title(),
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
        chartPanel.setBackground(BG_MAIN);

        chartContainer.removeAll();
        chartContainer.add(chartPanel, BorderLayout.CENTER);
        chartContainer.revalidate();
        chartContainer.repaint();
    }

    private void styleChart(JFreeChart chart) {
        chart.setBackgroundPaint(BG_MAIN);
        chart.getTitle().setPaint(TEXT_PRIMARY);
        chart.getTitle().setFont(new Font("Segoe UI", Font.BOLD, 18));

        CategoryPlot plot = chart.getCategoryPlot();
        plot.setBackgroundPaint(new Color(34, 40, 50));
        plot.setOutlinePaint(new Color(76, 86, 104));
        plot.getRangeAxis().setLabelPaint(TEXT_PRIMARY);
        plot.getRangeAxis().setTickLabelPaint(TEXT_MUTED);
        plot.getDomainAxis().setLabelPaint(TEXT_PRIMARY);
        plot.getDomainAxis().setTickLabelPaint(TEXT_MUTED);
        plot.getRenderer().setSeriesPaint(0, new Color(59, 130, 246));
        plot.setRangeGridlinePaint(new Color(74, 85, 104));
    }

    private ImageIcon loadScaledThumbnail(String path, int width, int height) {
        ImageIcon origin = new ImageIcon(path);
        if (origin.getIconWidth() <= 0 || origin.getIconHeight() <= 0) {
            return new ImageIcon(createPlaceholderImage(width, height));
        }

        double scale = Math.min((double) width / origin.getIconWidth(), (double) height / origin.getIconHeight());
        int drawW = Math.max(1, (int) Math.round(origin.getIconWidth() * scale));
        int drawH = Math.max(1, (int) Math.round(origin.getIconHeight() * scale));

        BufferedImage buffer = new BufferedImage(drawW, drawH, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2 = buffer.createGraphics();
        try {
            g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g2.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2.drawImage(origin.getImage(), 0, 0, drawW, drawH, null);
        } finally {
            g2.dispose();
        }

        return new ImageIcon(buffer);
    }

    private BufferedImage createPlaceholderImage(int width, int height) {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2 = image.createGraphics();
        try {
            g2.setPaint(new Color(59, 130, 246));
            g2.fillRect(0, 0, width, height);
            g2.setPaint(Color.WHITE);
            g2.setFont(new Font("Segoe UI", Font.BOLD, 18));
            g2.drawString("NO POSTER", 20, height / 2);
        } finally {
            g2.dispose();
        }
        return image;
    }

    private List<MovieRevenue> loadMoviesFromDatabase() {
        List<MovieRevenue> list = new ArrayList<>();

        try {
            phimService.getAllPhim().stream()
                    .filter(p -> p.getTenPhim() != null && !p.getTenPhim().isBlank())
                    .forEach(p -> {
                        Map<String, BigDecimal> realRevenue = thongKeDoanhSoService
                                .thongKeDoanhThuTheoThuTrongTuan(p.getTenPhim(), null, null);

                        Map<String, Long> chartRevenue = new LinkedHashMap<>();
                        for (Map.Entry<String, BigDecimal> entry : realRevenue.entrySet()) {
                            BigDecimal value = entry.getValue() == null ? BigDecimal.ZERO : entry.getValue();
                            chartRevenue.put(entry.getKey(), value.longValue());
                        }

                        list.add(new MovieRevenue(
                                p.getTenPhim(),
                                p.getPosterUrl(),
                                chartRevenue
                        ));
                    });
        } catch (RuntimeException ex) {
            return List.of();
        }

        return list;
    }

    private long totalRevenue(Map<String, Long> revenueByWeekday) {
        if (revenueByWeekday == null || revenueByWeekday.isEmpty()) {
            return 0L;
        }
        long total = 0L;
        for (Long value : revenueByWeekday.values()) {
            if (value != null) {
                total += value;
            }
        }
        return total;
    }

    private record MovieRevenue(String title, String thumbnailPath, Map<String, Long> revenueByWeekday) {
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("Demo - Thống kê doanh thu theo phim");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(1280, 760);
            frame.setLocationRelativeTo(null);
            frame.setContentPane(new ThongKeDoanhThuDashboardPanel());
            frame.setVisible(true);
        });
    }
}
