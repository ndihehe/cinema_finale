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

import org.example.cinema_finale.dto.VeDTO;
import org.example.cinema_finale.util.AppTheme;

public class ProductSelectionPanel extends JPanel {

    private static final Locale VI_VN = Locale.forLanguageTag("vi-VN");

    public record ProductSelectionResult(BigDecimal extraAmount, String note, Map<String, Integer> productQuantities) {}

    private final JLabel lblTicketInfo = new JLabel("Đã chọn 0 ghế", SwingConstants.LEFT);
    private final JLabel lblTotal = new JLabel("Tạm tính đồ ăn: 0 đ", SwingConstants.RIGHT);

    private final JCheckBox cbComboCouple = new JCheckBox("Combo 1 bắp + 1 nước - 79,000 đ");
    private final JSpinner spComboCouple = new JSpinner(new SpinnerNumberModel(1, 1, 10, 1));

    private final JCheckBox cbComboFamily = new JCheckBox("Bắp rang bơ size M - 55,000 đ");
    private final JSpinner spComboFamily = new JSpinner(new SpinnerNumberModel(1, 1, 10, 1));

    private final JCheckBox cbWater = new JCheckBox("Coca Cola - 30,000 đ");
    private final JSpinner spWater = new JSpinner(new SpinnerNumberModel(1, 1, 20, 1));

    private final JButton btnBack = new JButton("Quay lại");
    private final JButton btnNext = new JButton("Tiếp tục");

    private Runnable backListener;
    private Consumer<ProductSelectionResult> nextListener;

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

        JPanel products = new JPanel();
        products.setLayout(new javax.swing.BoxLayout(products, javax.swing.BoxLayout.Y_AXIS));
        products.setBackground(AppTheme.BG_CARD);
        products.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        products.add(buildRow(cbComboCouple, spComboCouple));
        products.add(javax.swing.Box.createVerticalStrut(8));
        products.add(buildRow(cbComboFamily, spComboFamily));
        products.add(javax.swing.Box.createVerticalStrut(8));
        products.add(buildRow(cbWater, spWater));

        JScrollPane scroll = new JScrollPane(products);
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

        java.awt.event.ActionListener listener = e -> refreshTotal();
        cbComboCouple.addActionListener(listener);
        cbComboFamily.addActionListener(listener);
        cbWater.addActionListener(listener);

        ((JSpinner.DefaultEditor) spComboCouple.getEditor()).getTextField().addCaretListener(e -> refreshTotal());
        ((JSpinner.DefaultEditor) spComboFamily.getEditor()).getTextField().addCaretListener(e -> refreshTotal());
        ((JSpinner.DefaultEditor) spWater.getEditor()).getTextField().addCaretListener(e -> refreshTotal());

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

        total = total.add(addIfSelected(cbComboCouple, spComboCouple, 79_000,
                "Combo 1 bắp + 1 nước", notes, productQuantities));
        total = total.add(addIfSelected(cbComboFamily, spComboFamily, 55_000,
                "Bắp rang bơ size M", notes, productQuantities));
        total = total.add(addIfSelected(cbWater, spWater, 30_000,
                "Coca Cola", notes, productQuantities));

        String note = notes.isEmpty() ? "Không chọn sản phẩm" : String.join(", ", notes);
        return new ProductSelectionResult(total, note, productQuantities);
    }

    private BigDecimal addIfSelected(JCheckBox cb, JSpinner sp, int unitPrice, String label,
                                     List<String> notes, Map<String, Integer> productQuantities) {
        if (!cb.isSelected()) {
            return BigDecimal.ZERO;
        }
        int qty = (int) sp.getValue();
        notes.add(label + " x" + qty);
        productQuantities.put(label, qty);
        return BigDecimal.valueOf((long) unitPrice * qty);
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
