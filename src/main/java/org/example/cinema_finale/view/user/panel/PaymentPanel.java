package org.example.cinema_finale.view.user.panel;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

import javax.swing.BorderFactory;
import javax.swing.DefaultListCellRenderer;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

import org.example.cinema_finale.dto.KhuyenMaiDTO;
import org.example.cinema_finale.util.AppTheme;

public class PaymentPanel extends JPanel {

    private final JTextArea txtSummary = new JTextArea();
    private final JComboBox<String> cboPaymentMethod = new JComboBox<>(new String[]{
            "TIEN_MAT", "THE_NGAN_HANG", "MOMO", "ZALOPAY"
    });
    private final JComboBox<KhuyenMaiDTO> cboPromotion = new JComboBox<>();
    private final JButton btnBack = new JButton("Quay lại");
    private final JButton btnPay = new JButton("Xác nhận thanh toán");

    private Runnable backListener;
    private Runnable promotionChangeListener;
    private Consumer<String> payListener;
    private boolean suppressPromotionEvent;

    public PaymentPanel() {
        setLayout(new BorderLayout(14, 14));
        setBackground(AppTheme.BG_APP);
        setBorder(BorderFactory.createEmptyBorder(14, 14, 14, 14));

        txtSummary.setEditable(false);
        txtSummary.setRows(20);
        txtSummary.setLineWrap(true);
        txtSummary.setWrapStyleWord(true);
        txtSummary.setBackground(AppTheme.BG_CARD);
        txtSummary.setForeground(AppTheme.TEXT_PRIMARY);
        txtSummary.setFont(new Font("Segoe UI", Font.PLAIN, 22));
        txtSummary.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));

        cboPaymentMethod.setRenderer(new DefaultListCellRenderer() {
            @Override
            public Component getListCellRendererComponent(JList<?> list, Object value, int index,
                                                          boolean isSelected, boolean cellHasFocus) {
                super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
                String method = value == null ? "" : value.toString();
                setText(toPaymentMethodLabel(method));
                return this;
            }
        });
        cboPaymentMethod.setPreferredSize(new Dimension(240, 38));
        cboPaymentMethod.setFont(new Font("Segoe UI", Font.PLAIN, 14));

        cboPromotion.setPreferredSize(new Dimension(240, 38));
        cboPromotion.setFont(new Font("Segoe UI", Font.PLAIN, 14));
        cboPromotion.setBackground(AppTheme.BG_INPUT);
        cboPromotion.setForeground(AppTheme.TEXT_PRIMARY);
        cboPromotion.setRenderer(new DefaultListCellRenderer() {
            @Override
            public Component getListCellRendererComponent(JList<?> list, Object value, int index,
                                                          boolean isSelected, boolean cellHasFocus) {
                super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
                if (value == null) {
                    setText("Không áp dụng khuyến mãi");
                } else if (value instanceof KhuyenMaiDTO km) {
                    setText(km.getTenKhuyenMai());
                }
                return this;
            }
        });

        JPanel top = new JPanel(new BorderLayout());
        top.setBackground(AppTheme.BG_APP);
        JLabel lblTitle = new JLabel("Thanh toán đơn hàng");
        lblTitle.setForeground(AppTheme.TEXT_PRIMARY);
        lblTitle.setFont(new Font("Segoe UI", Font.BOLD, 26));

        JLabel lblSubtitle = new JLabel("Kiểm tra lại thông tin trước khi xác nhận thanh toán");
        lblSubtitle.setForeground(AppTheme.TEXT_MUTED);
        lblSubtitle.setFont(new Font("Segoe UI", Font.PLAIN, 14));

        JPanel titleWrap = new JPanel(new BorderLayout());
        titleWrap.setBackground(AppTheme.BG_APP);
        titleWrap.add(lblTitle, BorderLayout.NORTH);
        titleWrap.add(lblSubtitle, BorderLayout.SOUTH);
        top.add(titleWrap, BorderLayout.WEST);

        JPanel bottom = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        bottom.setBackground(AppTheme.BG_APP);
        AppTheme.styleWarningButton(btnBack);
        AppTheme.stylePrimaryButton(btnPay);
        btnBack.setPreferredSize(new Dimension(120, 38));
        btnPay.setPreferredSize(new Dimension(200, 40));
        bottom.add(btnBack);
        bottom.add(btnPay);

        JScrollPane summaryScroll = new JScrollPane(txtSummary);
        AppTheme.styleTitledPanel(summaryScroll, "Thông tin đơn hàng");

        JPanel paymentCard = new JPanel(new GridBagLayout());
        paymentCard.setBackground(AppTheme.BG_CARD);
        paymentCard.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new java.awt.Color(70, 78, 91)),
                BorderFactory.createEmptyBorder(14, 14, 14, 14)
        ));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.weightx = 1;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.anchor = GridBagConstraints.NORTHWEST;
        gbc.insets = new Insets(0, 0, 8, 0);

        JLabel lblPaymentMethod = new JLabel("Phương thức thanh toán");
        lblPaymentMethod.setForeground(AppTheme.TEXT_PRIMARY);
        lblPaymentMethod.setFont(new Font("Segoe UI", Font.BOLD, 15));
        paymentCard.add(lblPaymentMethod, gbc);

        gbc.gridy++;
        gbc.insets = new Insets(0, 0, 12, 0);
        paymentCard.add(cboPaymentMethod, gbc);

        gbc.gridy++;
        gbc.insets = new Insets(0, 0, 8, 0);
        JLabel lblPromotion = new JLabel("Khuyến mãi");
        lblPromotion.setForeground(AppTheme.TEXT_PRIMARY);
        lblPromotion.setFont(new Font("Segoe UI", Font.BOLD, 15));
        paymentCard.add(lblPromotion, gbc);

        gbc.gridy++;
        gbc.insets = new Insets(0, 0, 12, 0);
        paymentCard.add(cboPromotion, gbc);

        gbc.gridy++;
        gbc.insets = new Insets(0, 0, 6, 0);
        JLabel lblHintTitle = new JLabel("Lưu ý");
        lblHintTitle.setForeground(AppTheme.TEXT_PRIMARY);
        lblHintTitle.setFont(new Font("Segoe UI", Font.BOLD, 14));
        paymentCard.add(lblHintTitle, gbc);

        gbc.gridy++;
        gbc.insets = new Insets(0, 0, 0, 0);
        JLabel lblHint = new JLabel("<html><div style='width:240px'>Sau khi xác nhận, hệ thống sẽ tạo hóa đơn và cho phép xuất file PDF.</div></html>");
        lblHint.setForeground(AppTheme.TEXT_MUTED);
        lblHint.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        paymentCard.add(lblHint, gbc);

        JPanel center = new JPanel(new BorderLayout(14, 0));
        center.setBackground(AppTheme.BG_APP);
        center.add(summaryScroll, BorderLayout.CENTER);
        center.add(paymentCard, BorderLayout.EAST);

        add(top, BorderLayout.NORTH);
            add(center, BorderLayout.CENTER);
        add(bottom, BorderLayout.SOUTH);

        btnBack.addActionListener(e -> {
            if (backListener != null) {
                backListener.run();
            }
        });

        btnPay.addActionListener(e -> {
            if (payListener != null) {
                payListener.accept((String) cboPaymentMethod.getSelectedItem());
            }
        });

        cboPromotion.addActionListener(e -> {
            if (!suppressPromotionEvent && promotionChangeListener != null) {
                promotionChangeListener.run();
            }
        });
    }

    public void setBackListener(Runnable backListener) {
        this.backListener = backListener;
    }

    public void setPayListener(Consumer<String> payListener) {
        this.payListener = payListener;
    }

    public void setPromotionChangeListener(Runnable promotionChangeListener) {
        this.promotionChangeListener = promotionChangeListener;
    }

    public void setPromotions(List<KhuyenMaiDTO> promotions) {
        List<KhuyenMaiDTO> model = new ArrayList<>();
        model.add(null);
        if (promotions != null) {
            model.addAll(promotions);
        }
        suppressPromotionEvent = true;
        cboPromotion.removeAllItems();
        for (KhuyenMaiDTO km : model) {
            cboPromotion.addItem(km);
        }
        cboPromotion.setSelectedIndex(0);
        suppressPromotionEvent = false;
    }

    public void clearPromotionSelection() {
        suppressPromotionEvent = true;
        if (cboPromotion.getItemCount() > 0) {
            cboPromotion.setSelectedIndex(0);
        }
        suppressPromotionEvent = false;
    }

    public KhuyenMaiDTO getSelectedPromotion() {
        Object item = cboPromotion.getSelectedItem();
        return item instanceof KhuyenMaiDTO km ? km : null;
    }

    public void setSummaryText(String summary) {
        txtSummary.setText(summary == null ? "" : summary);
        txtSummary.setCaretPosition(0);
    }

    private String toPaymentMethodLabel(String paymentMethod) {
        return switch (paymentMethod) {
            case "TIEN_MAT" -> "Tiền mặt";
            case "THE_NGAN_HANG" -> "Thẻ ngân hàng";
            case "MOMO" -> "Ví MoMo";
            case "ZALOPAY" -> "ZaloPay";
            default -> paymentMethod;
        };
    }
}
