package org.example.cinema_finale.view.user.panel;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.function.Consumer;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingConstants;

import org.example.cinema_finale.dto.SanPhamDTO;
import org.example.cinema_finale.dto.VeDTO;
import org.example.cinema_finale.util.AppTheme;

public class ProductSelectionPanel extends JPanel {

    private static final Locale VI_VN = Locale.forLanguageTag("vi-VN");

    public record ProductSelectionResult(BigDecimal extraAmount, String note, Map<String, Integer> productQuantities) {}

    private final JLabel lblTicketInfo = new JLabel("Đã chọn 0 ghế", SwingConstants.LEFT);
    private final JLabel lblTotal = new JLabel("Tạm tính đồ ăn: 0 đ", SwingConstants.RIGHT);

    private final JPanel productsContainer = new JPanel();
    private final List<ProductRow> productRows = new ArrayList<>();

    private final JButton btnBack = new JButton("Quay lại");
    private final JButton btnNext = new JButton("Tiếp tục");

    private Runnable backListener;
    private Consumer<ProductSelectionResult> nextListener;

    private static class ProductRow {
        private final SanPhamDTO sanPham;
        private final JCheckBox checkBox;
        private final JSpinner spinner;

        private ProductRow(SanPhamDTO sanPham, JCheckBox checkBox, JSpinner spinner) {
            this.sanPham = sanPham;
            this.checkBox = checkBox;
            this.spinner = spinner;
        }
    }

    public ProductSelectionPanel() {
        setLayout(new BorderLayout(10, 10));
        setBackground(AppTheme.BG_APP);
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        lblTicketInfo.setForeground(AppTheme.TEXT_PRIMARY);
        lblTicketInfo.setFont(lblTicketInfo.getFont().deriveFont(16f));
        lblTotal.setForeground(AppTheme.TEXT_MUTED);

        JPanel top = new JPanel(new BorderLayout());
        top.setBackground(AppTheme.BG_APP);
        top.add(lblTicketInfo, BorderLayout.WEST);
        top.add(lblTotal, BorderLayout.EAST);

        productsContainer.setLayout(new javax.swing.BoxLayout(productsContainer, javax.swing.BoxLayout.Y_AXIS));
        productsContainer.setBackground(AppTheme.BG_CARD);
        productsContainer.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        JScrollPane scroll = new JScrollPane(productsContainer);
        AppTheme.styleTitledPanel(scroll, "Chọn đồ ăn và thức uống");

        JPanel bottom = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        bottom.setBackground(AppTheme.BG_APP);
        AppTheme.styleWarningButton(btnBack);
        AppTheme.stylePrimaryButton(btnNext);
        bottom.add(btnBack);
        bottom.add(btnNext);

        add(top, BorderLayout.NORTH);
        add(scroll, BorderLayout.CENTER);
        add(bottom, BorderLayout.SOUTH);

        setProducts(List.of());

        btnBack.addActionListener(e -> {
            if (backListener != null) {
                backListener.run();
            }
        });

        btnNext.addActionListener(e -> {
            if (nextListener != null) {
                nextListener.accept(buildResult());
            }
        });
    }

    public void setBackListener(Runnable backListener) {
        this.backListener = backListener;
    }

    public void setNextListener(Consumer<ProductSelectionResult> nextListener) {
        this.nextListener = nextListener;
    }

    public void setTicketSelection(List<VeDTO> tickets) {
        lblTicketInfo.setText("Đã chọn " + (tickets == null ? 0 : tickets.size()) + " ghế");
        refreshTotal();
    }

    public void setProducts(List<SanPhamDTO> products) {
        productsContainer.removeAll();
        productRows.clear();

        if (products == null || products.isEmpty()) {
            JLabel empty = new JLabel("Hiện chưa có sản phẩm khả dụng", SwingConstants.LEFT);
            empty.setForeground(AppTheme.TEXT_MUTED);
            productsContainer.add(empty);
        } else {
            for (SanPhamDTO product : products) {
                if (product == null || product.getDonGia() == null || product.getTenSanPham() == null) {
                    continue;
                }

                int maxQty = Math.max(1, product.getSoLuongTon() == null ? 1 : product.getSoLuongTon());
                JCheckBox checkBox = new JCheckBox(product.getTenSanPham() + " - " + formatVnd(product.getDonGia()));
                JSpinner spinner = new JSpinner(new SpinnerNumberModel(1, 1, maxQty, 1));

                java.awt.event.ActionListener listener = e -> refreshTotal();
                checkBox.addActionListener(listener);
                ((JSpinner.DefaultEditor) spinner.getEditor()).getTextField().addCaretListener(e -> refreshTotal());

                productRows.add(new ProductRow(product, checkBox, spinner));
                productsContainer.add(buildRow(checkBox, spinner));
                productsContainer.add(javax.swing.Box.createVerticalStrut(8));
            }
        }

        productsContainer.revalidate();
        productsContainer.repaint();
        refreshTotal();
    }

    private JPanel buildRow(JCheckBox checkBox, JSpinner spinner) {
        JPanel row = new JPanel(new BorderLayout());
        row.setBackground(AppTheme.BG_CARD);

        checkBox.setBackground(AppTheme.BG_CARD);
        checkBox.setForeground(AppTheme.TEXT_PRIMARY);
        spinner.setPreferredSize(new java.awt.Dimension(80, 28));

        row.add(checkBox, BorderLayout.CENTER);
        row.add(spinner, BorderLayout.EAST);
        return row;
    }

    private ProductSelectionResult buildResult() {
        BigDecimal total = BigDecimal.ZERO;
        List<String> notes = new ArrayList<>();
        Map<String, Integer> productQuantities = new LinkedHashMap<>();

        for (ProductRow row : productRows) {
            total = total.add(addIfSelected(row, notes, productQuantities));
        }

        String note = notes.isEmpty() ? "Không chọn sản phẩm" : String.join(", ", notes);
        return new ProductSelectionResult(total, note, productQuantities);
    }

    private BigDecimal addIfSelected(ProductRow row, List<String> notes, Map<String, Integer> productQuantities) {
        if (!row.checkBox.isSelected()) {
            return BigDecimal.ZERO;
        }

        int qty = (int) row.spinner.getValue();
        String productName = row.sanPham.getTenSanPham();
        BigDecimal unitPrice = row.sanPham.getDonGia() == null ? BigDecimal.ZERO : row.sanPham.getDonGia();

        notes.add(productName + " x" + qty);
        productQuantities.put(productName, qty);
        return unitPrice.multiply(BigDecimal.valueOf(qty));
    }

    private void refreshTotal() {
        ProductSelectionResult result = buildResult();
        lblTotal.setText("Tạm tính đồ ăn: " + formatVnd(result.extraAmount));
    }

    private String formatVnd(BigDecimal amount) {
        NumberFormat format = NumberFormat.getCurrencyInstance(VI_VN);
        return format.format(amount == null ? BigDecimal.ZERO : amount);
    }
}
