package org.example.cinema_finale.view.user.panel;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.GridLayout;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

import javax.imageio.ImageIO;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.Border;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;

import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.util.AppTheme;

public class MovieListPanel extends JPanel {

    private static final Border CARD_BORDER = BorderFactory.createLineBorder(new Color(75, 86, 104), 1);
    private static final Border CARD_SELECTED_BORDER = BorderFactory.createLineBorder(new Color(59, 130, 246), 2);
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final JPanel listPanel = new JPanel();
    private final JTextField txtSearch = new JTextField(24);
    private final JLabel lblCount = new JLabel("0 phim", SwingConstants.RIGHT);

    private final List<PhimDTO> allMovies = new ArrayList<>();
    private Consumer<PhimDTO> movieSelectListener;
    private JPanel selectedCard;

    public MovieListPanel() {
        setLayout(new BorderLayout(10, 10));
        setBackground(AppTheme.BG_APP);
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        JPanel top = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 0));
        top.setBackground(AppTheme.BG_APP);

        JLabel lbl = new JLabel("Tìm phim:");
        lbl.setForeground(AppTheme.TEXT_MUTED);
        AppTheme.styleSearchField(txtSearch);
        lblCount.setForeground(AppTheme.TEXT_MUTED);

        top.add(lbl);
        top.add(txtSearch);
        top.add(lblCount);

        listPanel.setLayout(new GridLayout(0, 5, 12, 12));
        listPanel.setBackground(AppTheme.BG_APP);

        JScrollPane scrollPane = new JScrollPane(listPanel);
        scrollPane.getViewport().setBackground(AppTheme.BG_APP);
        AppTheme.styleTitledPanel(scrollPane, "Danh sách phim đang mở bán");

        add(top, BorderLayout.NORTH);
        add(scrollPane, BorderLayout.CENTER);

        txtSearch.getDocument().addDocumentListener(new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) {
                renderList();
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                renderList();
            }

            @Override
            public void changedUpdate(DocumentEvent e) {
                renderList();
            }
        });
    }

    public void setMovieSelectListener(Consumer<PhimDTO> movieSelectListener) {
        this.movieSelectListener = movieSelectListener;
    }

    public void setMovies(List<PhimDTO> movies) {
        allMovies.clear();
        if (movies != null) {
            allMovies.addAll(movies);
        }
        selectedCard = null;
        renderList();
    }

    private void renderList() {
        String keyword = txtSearch.getText() == null ? "" : txtSearch.getText().trim().toLowerCase();

        listPanel.removeAll();
        int shown = 0;
        for (PhimDTO movie : allMovies) {
            String name = movie.getTenPhim() == null ? "" : movie.getTenPhim().toLowerCase();
            if (!keyword.isEmpty() && !name.contains(keyword)) {
                continue;
            }

            JPanel card = createMovieCard(movie);
            listPanel.add(card);
            shown++;
        }

        if (shown == 0) {
            JPanel empty = new JPanel(new BorderLayout());
            empty.setBackground(AppTheme.BG_CARD);
            empty.setBorder(CARD_BORDER);
            JLabel msg = new JLabel("Không tìm thấy phim phù hợp", SwingConstants.CENTER);
            msg.setForeground(AppTheme.TEXT_MUTED);
            msg.setFont(new Font("Segoe UI", Font.PLAIN, 15));
            empty.add(msg, BorderLayout.CENTER);
            empty.setPreferredSize(new Dimension(220, 250));
            listPanel.add(empty);
        }

        lblCount.setText(shown + " phim");

        listPanel.revalidate();
        listPanel.repaint();
    }

    private JPanel createMovieCard(PhimDTO movie) {
        JPanel card = new JPanel(new BorderLayout(8, 8));
        card.setBackground(AppTheme.BG_CARD);
        card.setBorder(CARD_BORDER);
        card.setPreferredSize(new Dimension(220, 290));

        JLabel poster = new JLabel();
        poster.setHorizontalAlignment(SwingConstants.CENTER);
        poster.setPreferredSize(new Dimension(180, 220));
        poster.setIcon(loadPoster(movie.getPosterUrl(), 180, 220));

        JLabel name = new JLabel(movie.getTenPhim(), SwingConstants.CENTER);
        name.setForeground(AppTheme.TEXT_PRIMARY);
        name.setFont(new Font("Segoe UI", Font.BOLD, 15));

        String detailText = (movie.getTheLoai() == null ? "Chưa rõ thể loại" : movie.getTheLoai())
                + " | " + (movie.getThoiLuong() == null ? "-" : movie.getThoiLuong() + " phút")
                + "\nKhởi chiếu: " + (movie.getNgayKhoiChieu() == null ? "-" : movie.getNgayKhoiChieu().format(DATE_FORMAT));
        JLabel detail = new JLabel("<html><div style='text-align:center; font-size:11px;'>" + detailText.replace("\n", "<br>") + "</div></html>", SwingConstants.CENTER);
        detail.setForeground(AppTheme.TEXT_MUTED);

        JPanel info = new JPanel(new BorderLayout());
        info.setBackground(AppTheme.BG_CARD);
        info.add(name, BorderLayout.NORTH);
        info.add(detail, BorderLayout.SOUTH);

        card.add(poster, BorderLayout.CENTER);
        card.add(info, BorderLayout.SOUTH);

        java.awt.event.MouseAdapter mouseAdapter = new java.awt.event.MouseAdapter() {
            @Override
            public void mouseEntered(java.awt.event.MouseEvent e) {
                if (card != selectedCard) {
                    card.setBackground(new Color(54, 63, 78));
                }
            }

            @Override
            public void mouseExited(java.awt.event.MouseEvent e) {
                if (card != selectedCard) {
                    card.setBackground(AppTheme.BG_CARD);
                }
            }

            @Override
            public void mouseClicked(java.awt.event.MouseEvent e) {
                selectCard(card);
                if (movieSelectListener != null) {
                    movieSelectListener.accept(movie);
                }
            }
        };

        card.addMouseListener(mouseAdapter);
        poster.addMouseListener(mouseAdapter);
        name.addMouseListener(mouseAdapter);
        return card;
    }

    private void selectCard(JPanel card) {
        if (selectedCard != null) {
            selectedCard.setBorder(CARD_BORDER);
            selectedCard.setBackground(AppTheme.BG_CARD);
        }

        selectedCard = card;
        selectedCard.setBorder(CARD_SELECTED_BORDER);
        selectedCard.setBackground(new Color(54, 63, 78));
    }

    private ImageIcon loadPoster(String path, int width, int height) {
        try {
            if (path == null || path.isBlank()) {
                return new ImageIcon(createPlaceholder(width, height));
            }
            File file = new File(path);
            if (!file.exists()) {
                return new ImageIcon(createPlaceholder(width, height));
            }

            BufferedImage src = ImageIO.read(file);
            if (src == null) {
                return new ImageIcon(createPlaceholder(width, height));
            }

            double scale = Math.min((double) width / src.getWidth(), (double) height / src.getHeight());
            int drawW = Math.max(1, (int) Math.round(src.getWidth() * scale));
            int drawH = Math.max(1, (int) Math.round(src.getHeight() * scale));

            BufferedImage output = new BufferedImage(drawW, drawH, BufferedImage.TYPE_INT_ARGB);
            Graphics2D g2 = output.createGraphics();
            try {
                g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
                g2.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
                g2.drawImage(src, 0, 0, drawW, drawH, null);
            } finally {
                g2.dispose();
            }

            return new ImageIcon(output);
        } catch (IOException | RuntimeException ex) {
            return new ImageIcon(createPlaceholder(width, height));
        }
    }

    private BufferedImage createPlaceholder(int width, int height) {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2 = image.createGraphics();
        try {
            g2.setColor(new Color(59, 130, 246));
            g2.fillRect(0, 0, width, height);
            g2.setColor(Color.WHITE);
            g2.setFont(new Font("Segoe UI", Font.BOLD, 16));
            g2.drawString("NO POSTER", 20, height / 2);
        } finally {
            g2.dispose();
        }
        return image;
    }
}
