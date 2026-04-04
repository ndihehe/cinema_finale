package org.example.cinema_finale.view.user.panel;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.function.Consumer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JToggleButton;

import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.dto.SuatChieuDTO;
import org.example.cinema_finale.dto.VeDTO;
import org.example.cinema_finale.util.AppTheme;

public class SeatSelectionPanel extends JPanel {

    private static final Locale VI_VN = Locale.forLanguageTag("vi-VN");
    private static final Pattern SEAT_PATTERN = Pattern.compile("^([A-Za-z]+)(\\d+)$");
    private static final Pattern SEAT_FLEX_PATTERN = Pattern.compile("^([A-Za-z]+)\\D*(\\d+)$");
    private static final Pattern SEAT_NUMERIC_PATTERN = Pattern.compile("^(\\d+)$");
    private static final Color SEAT_AVAILABLE_BG = new Color(56, 65, 79);
    private static final Color SEAT_SELECTED_BG = new Color(34, 197, 94);
    private static final int SEAT_CELL_W = 44;
    private static final int SEAT_CELL_H = 30;
    private static final int ROW_LABEL_W = 34;
    private static final int AISLE_W = 56;

    private final JLabel lblContext = new JLabel("Suất chiếu: -");
    private final JLabel lblSummary = new JLabel("Đã chọn: 0 vé");

    private final JPanel seatMapPanel = new JPanel();
    private final JLabel lblSelectedSeatList = new JLabel("Ghế đã chọn: -");
    private final Map<String, VeDTO> seatByLabel = new LinkedHashMap<>();
    private final Map<String, JToggleButton> seatButtonByLabel = new LinkedHashMap<>();

    private final JButton btnBack = new JButton("Quay lại");
    private final JButton btnNext = new JButton("Tiếp tục");

    private Runnable backListener;
    private Consumer<List<VeDTO>> nextListener;

    public SeatSelectionPanel() {
        setLayout(new BorderLayout(10, 10));
        setBackground(AppTheme.BG_APP);
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        lblContext.setForeground(AppTheme.TEXT_PRIMARY);
        lblContext.setFont(lblContext.getFont().deriveFont(17f));
        lblSummary.setForeground(AppTheme.TEXT_MUTED);

        JPanel header = new JPanel(new BorderLayout());
        header.setBackground(AppTheme.BG_APP);
        header.add(lblContext, BorderLayout.NORTH);
        header.add(lblSummary, BorderLayout.SOUTH);

        JPanel seatContainer = new JPanel(new BorderLayout(8, 8));
        seatContainer.setBackground(AppTheme.BG_APP);

        JPanel screenPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        screenPanel.setBackground(AppTheme.BG_APP);
        JLabel lblScreen = new JLabel("MÀN HÌNH");
        lblScreen.setOpaque(true);
        lblScreen.setBackground(new Color(30, 41, 59));
        lblScreen.setForeground(Color.WHITE);
        lblScreen.setFont(new Font("Segoe UI", Font.BOLD, 13));
        lblScreen.setBorder(BorderFactory.createEmptyBorder(8, 26, 8, 26));
        screenPanel.add(lblScreen);

        seatMapPanel.setBackground(AppTheme.BG_CARD);
        seatMapPanel.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        JScrollPane seatMapScroll = new JScrollPane(seatMapPanel);
        AppTheme.styleTitledPanel(seatMapScroll, "Sơ đồ ghế");

        JPanel legend = new JPanel(new FlowLayout(FlowLayout.LEFT, 12, 0));
        legend.setBackground(AppTheme.BG_APP);
        legend.add(createLegendBox(SEAT_AVAILABLE_BG, "Còn trống"));
        legend.add(createLegendBox(SEAT_SELECTED_BG, "Đang chọn"));
        legend.add(createLegendBox(new Color(30, 41, 59), "Không khả dụng"));

        lblSelectedSeatList.setForeground(AppTheme.TEXT_MUTED);

        JPanel seatBottom = new JPanel(new BorderLayout());
        seatBottom.setBackground(AppTheme.BG_APP);
        seatBottom.add(legend, BorderLayout.NORTH);
        seatBottom.add(Box.createVerticalStrut(6), BorderLayout.CENTER);
        seatBottom.add(lblSelectedSeatList, BorderLayout.SOUTH);

        seatContainer.add(screenPanel, BorderLayout.NORTH);
        seatContainer.add(seatMapScroll, BorderLayout.CENTER);
        seatContainer.add(seatBottom, BorderLayout.SOUTH);

        JPanel bottom = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        bottom.setBackground(AppTheme.BG_APP);
        AppTheme.styleWarningButton(btnBack);
        AppTheme.stylePrimaryButton(btnNext);
        bottom.add(btnBack);
        bottom.add(btnNext);

        add(header, BorderLayout.NORTH);
        add(seatContainer, BorderLayout.CENTER);
        add(bottom, BorderLayout.SOUTH);

        btnBack.addActionListener(e -> {
            if (backListener != null) {
                backListener.run();
            }
        });

        btnNext.addActionListener(e -> {
            List<VeDTO> selected = getSelectedTickets();
            if (selected.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Vui lòng chọn ít nhất 1 ghế.");
                return;
            }
            if (nextListener != null) {
                nextListener.accept(new ArrayList<>(selected));
            }
        });
    }

    public void setBackListener(Runnable backListener) {
        this.backListener = backListener;
    }

    public void setNextListener(Consumer<List<VeDTO>> nextListener) {
        this.nextListener = nextListener;
    }

    public void setData(PhimDTO movie, SuatChieuDTO showtime, List<VeDTO> availableTickets) {
        String movieName = movie == null ? "-" : movie.getTenPhim();
        String room = showtime == null ? "-" : showtime.getTenPhongChieu();
        lblContext.setText("Phim: " + movieName + " | Phòng: " + room);

        rebuildSeatMap(availableTickets == null ? List.of() : availableTickets);
        updateSummary();
    }

    private void updateSummary() {
        List<VeDTO> selected = getSelectedTickets();
        BigDecimal total = selected.stream()
                .map(VeDTO::getGiaVe)
                .filter(v -> v != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        lblSummary.setText("Đã chọn: " + selected.size() + " vé | Tạm tính vé: " + formatVnd(total));
        if (selected.isEmpty()) {
            lblSelectedSeatList.setText("Ghế đã chọn: -");
        } else {
            String seatText = selected.stream()
                    .map(VeDTO::getViTriGhe)
                    .filter(v -> v != null && !v.isBlank())
                    .sorted(this::compareSeat)
                    .reduce((a, b) -> a + ", " + b)
                    .orElse("-");
            lblSelectedSeatList.setText("Ghế đã chọn: " + seatText);
        }
    }

    private String formatVnd(BigDecimal amount) {
        NumberFormat format = NumberFormat.getCurrencyInstance(VI_VN);
        return format.format(amount == null ? BigDecimal.ZERO : amount);
    }

    private void rebuildSeatMap(List<VeDTO> availableTickets) {
        seatByLabel.clear();
        seatButtonByLabel.clear();

        for (VeDTO ve : availableTickets) {
            if (ve == null || ve.getViTriGhe() == null || ve.getViTriGhe().isBlank()) {
                continue;
            }
            String normalized = normalizeSeatLabel(ve.getViTriGhe());
            if (normalized != null) {
                seatByLabel.put(normalized, ve);
            }
        }

        List<String> labels = new ArrayList<>(seatByLabel.keySet());
        labels.sort(this::compareSeat);

        int maxCol = labels.stream().mapToInt(this::extractSeatNumber).max().orElse(0);
        maxCol = Math.max(maxCol, 10);
        int leftMaxCol = maxCol / 2;
        int rightStartCol = leftMaxCol + 1;

        Map<String, Integer> rowOrder = buildRowOrder(labels);
        if (rowOrder.isEmpty()) {
            rowOrder.put("A", 0);
        }

        seatMapPanel.removeAll();
        seatMapPanel.setLayout(new BoxLayout(seatMapPanel, BoxLayout.Y_AXIS));

        JPanel axisRow = new JPanel();
        axisRow.setLayout(new BoxLayout(axisRow, BoxLayout.X_AXIS));
        axisRow.setBackground(AppTheme.BG_CARD);
        axisRow.setAlignmentX(Component.LEFT_ALIGNMENT);
        axisRow.add(buildAxisSlot(" ", ROW_LABEL_W));
        for (int c = 1; c <= leftMaxCol; c++) {
            axisRow.add(buildAxisSlot(String.valueOf(c), SEAT_CELL_W));
        }
        axisRow.add(buildAisleCell("LỐI ĐI"));
        for (int c = rightStartCol; c <= maxCol; c++) {
            axisRow.add(buildAxisSlot(String.valueOf(c), SEAT_CELL_W));
        }
        seatMapPanel.add(wrapCentered(axisRow));
        seatMapPanel.add(Box.createVerticalStrut(8));

        for (String rowKey : rowOrder.keySet()) {
            JPanel rowPanel = new JPanel();
            rowPanel.setLayout(new BoxLayout(rowPanel, BoxLayout.X_AXIS));
            rowPanel.setBackground(AppTheme.BG_CARD);
            rowPanel.setAlignmentX(Component.LEFT_ALIGNMENT);

            rowPanel.add(buildAxisSlot(rowKey, ROW_LABEL_W));

            for (int c = 1; c <= leftMaxCol; c++) {
                rowPanel.add(buildSeatCell(rowKey + c));
            }

            rowPanel.add(buildAisleCell(""));

            for (int c = rightStartCol; c <= maxCol; c++) {
                rowPanel.add(buildSeatCell(rowKey + c));
            }

            seatMapPanel.add(wrapCentered(rowPanel));
            seatMapPanel.add(Box.createVerticalStrut(6));
        }

        seatMapPanel.revalidate();
        seatMapPanel.repaint();
    }

    private Component buildSeatCell(String seatLabel) {
        VeDTO ve = seatByLabel.get(seatLabel);
        if (ve == null) {
            return buildBlockedSeatCell();
        }

        JToggleButton seatButton = buildSeatButton(seatLabel);
        seatButtonByLabel.put(seatLabel, seatButton);
        return seatButton;
    }

    private Map<String, Integer> buildRowOrder(List<String> labels) {
        Map<String, Integer> rowOrder = new LinkedHashMap<>();
        int idx = 0;
        for (String label : labels) {
            Matcher matcher = SEAT_PATTERN.matcher(label);
            String row = matcher.matches() ? matcher.group(1).toUpperCase() : "?";
            if (!rowOrder.containsKey(row)) {
                rowOrder.put(row, idx++);
            }
        }
        return rowOrder;
    }

    private JLabel buildAxisSlot(String text, int width) {
        JLabel label = new JLabel(text, JLabel.CENTER);
        label.setForeground(AppTheme.TEXT_MUTED);
        label.setFont(new Font("Segoe UI", Font.BOLD, 12));
        label.setPreferredSize(new Dimension(width, SEAT_CELL_H));
        label.setMinimumSize(new Dimension(width, SEAT_CELL_H));
        label.setMaximumSize(new Dimension(width, SEAT_CELL_H));
        return label;
    }

    private JPanel buildBlockedSeatCell() {
        JPanel blocked = new JPanel();
        blocked.setBackground(new Color(30, 41, 59));
        blocked.setBorder(BorderFactory.createLineBorder(new Color(70, 78, 91)));
        blocked.setPreferredSize(new Dimension(SEAT_CELL_W, SEAT_CELL_H));
        blocked.setMinimumSize(new Dimension(SEAT_CELL_W, SEAT_CELL_H));
        blocked.setMaximumSize(new Dimension(SEAT_CELL_W, SEAT_CELL_H));
        return blocked;
    }

    private JLabel buildAisleCell(String text) {
        JLabel aisle = new JLabel(text, JLabel.CENTER);
        aisle.setForeground(new Color(147, 197, 253));
        aisle.setFont(new Font("Segoe UI", Font.BOLD, 11));
        aisle.setOpaque(true);
        aisle.setBackground(new Color(22, 31, 47));
        aisle.setBorder(BorderFactory.createLineBorder(new Color(56, 82, 120)));
        aisle.setPreferredSize(new Dimension(AISLE_W, SEAT_CELL_H));
        aisle.setMinimumSize(new Dimension(AISLE_W, SEAT_CELL_H));
        aisle.setMaximumSize(new Dimension(AISLE_W, SEAT_CELL_H));
        return aisle;
    }

    private JToggleButton buildSeatButton(String seatLabel) {
        JToggleButton button = new JToggleButton(seatLabel);
        button.setFocusPainted(false);
        button.setFont(new Font("Segoe UI", Font.BOLD, 11));
        button.setBackground(SEAT_AVAILABLE_BG);
        button.setForeground(Color.WHITE);
        button.setBorder(BorderFactory.createLineBorder(new Color(92, 106, 128)));
        button.setPreferredSize(new Dimension(SEAT_CELL_W, SEAT_CELL_H));
        button.setMinimumSize(new Dimension(SEAT_CELL_W, SEAT_CELL_H));
        button.setMaximumSize(new Dimension(SEAT_CELL_W, SEAT_CELL_H));
        button.addActionListener(e -> {
            button.setBackground(button.isSelected() ? SEAT_SELECTED_BG : SEAT_AVAILABLE_BG);
            updateSummary();
        });
        return button;
    }

    private JPanel createLegendBox(Color color, String text) {
        JPanel wrap = new JPanel(new FlowLayout(FlowLayout.LEFT, 6, 0));
        wrap.setBackground(AppTheme.BG_APP);

        JLabel box = new JLabel("  ");
        box.setOpaque(true);
        box.setBackground(color);
        box.setBorder(BorderFactory.createLineBorder(new Color(90, 99, 112)));
        box.setPreferredSize(new Dimension(16, 16));

        JLabel lbl = new JLabel(text);
        lbl.setForeground(AppTheme.TEXT_MUTED);

        wrap.add(box);
        wrap.add(lbl);
        return wrap;
    }

    private List<VeDTO> getSelectedTickets() {
        List<VeDTO> selected = new ArrayList<>();
        for (Map.Entry<String, JToggleButton> entry : seatButtonByLabel.entrySet()) {
            if (entry.getValue().isSelected()) {
                VeDTO ve = seatByLabel.get(entry.getKey());
                if (ve != null) {
                    selected.add(ve);
                }
            }
        }
        selected.sort(Comparator.comparing(VeDTO::getViTriGhe, this::compareSeat));
        return selected;
    }

    private int compareSeat(String a, String b) {
        SeatPos pa = parseSeatPos(a);
        SeatPos pb = parseSeatPos(b);
        if (pa != null && pb != null) {
            int row = pa.row().compareTo(pb.row());
            if (row != 0) {
                return row;
            }
            return Integer.compare(pa.col(), pb.col());
        }
        String sa = a == null ? "" : a.trim().toUpperCase();
        String sb = b == null ? "" : b.trim().toUpperCase();
        return sa.compareTo(sb);
    }

    private int extractSeatNumber(String seatLabel) {
        SeatPos pos = parseSeatPos(seatLabel);
        return pos == null ? 0 : pos.col();
    }

    private JPanel wrapCentered(JPanel rowPanel) {
        JPanel wrap = new JPanel(new FlowLayout(FlowLayout.CENTER, 0, 0));
        wrap.setBackground(AppTheme.BG_CARD);
        wrap.setAlignmentX(Component.CENTER_ALIGNMENT);
        wrap.add(rowPanel);
        return wrap;
    }

    private String normalizeSeatLabel(String raw) {
        SeatPos pos = parseSeatPos(raw);
        if (pos == null) {
            return null;
        }
        return pos.row() + pos.col();
    }

    private SeatPos parseSeatPos(String raw) {
        if (raw == null) {
            return null;
        }
        String value = raw.trim().toUpperCase();
        if (value.isEmpty()) {
            return null;
        }

        Matcher strict = SEAT_PATTERN.matcher(value);
        if (strict.matches()) {
            return new SeatPos(strict.group(1), parseInt(strict.group(2)));
        }

        Matcher flex = SEAT_FLEX_PATTERN.matcher(value);
        if (flex.matches()) {
            return new SeatPos(flex.group(1), parseInt(flex.group(2)));
        }

        Matcher numeric = SEAT_NUMERIC_PATTERN.matcher(value);
        if (numeric.matches()) {
            return new SeatPos("A", parseInt(numeric.group(1)));
        }
        return null;
    }

    private record SeatPos(String row, int col) {}

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }
}
