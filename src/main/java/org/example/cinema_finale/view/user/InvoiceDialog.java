package org.example.cinema_finale.view.user;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.SwingConstants;
import javax.swing.filechooser.FileNameExtensionFilter;

import org.example.cinema_finale.util.AppTheme;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDType0Font;

public class InvoiceDialog extends JDialog {

    private static final DateTimeFormatter FILE_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");

    public InvoiceDialog(java.awt.Frame owner, String title, String content) {
        super(owner, title, true);
        setSize(540, 500);
        setLocationRelativeTo(owner);
        setLayout(new BorderLayout());

        JLabel header = new JLabel("Biên nhận thanh toán", SwingConstants.CENTER);
        header.setForeground(AppTheme.TEXT_PRIMARY);
        header.setFont(header.getFont().deriveFont(18f));
        header.setBorder(BorderFactory.createEmptyBorder(12, 12, 4, 12));

        JPanel top = new JPanel(new BorderLayout());
        top.setBackground(AppTheme.BG_APP);
        top.add(header, BorderLayout.CENTER);

        JTextArea txt = new JTextArea();
        txt.setEditable(false);
        txt.setLineWrap(true);
        txt.setWrapStyleWord(true);
        txt.setText(content == null ? "" : content);
        txt.setBackground(AppTheme.BG_CARD);
        txt.setForeground(AppTheme.TEXT_PRIMARY);
        txt.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        JScrollPane contentPane = new JScrollPane(txt);
        AppTheme.styleTitledPanel(contentPane, "Chi tiết giao dịch");

        JButton btnPrint = new JButton("Xuất PDF");
        AppTheme.styleWarningButton(btnPrint);
        btnPrint.addActionListener(e -> exportToPdf(txt.getText()));

        JButton btnOk = new JButton("OK");
        AppTheme.stylePrimaryButton(btnOk);
        btnOk.addActionListener(e -> dispose());
        getRootPane().setDefaultButton(btnOk);

        JPanel footer = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        footer.setBackground(AppTheme.BG_APP);
        footer.setBorder(BorderFactory.createEmptyBorder(4, 8, 8, 8));
        footer.add(btnPrint);
        footer.add(btnOk);

        add(top, BorderLayout.NORTH);
        add(contentPane, BorderLayout.CENTER);
        add(footer, BorderLayout.SOUTH);
    }

    private void exportToPdf(String content) {
        JFileChooser chooser = new JFileChooser();
        chooser.setDialogTitle("Chọn nơi lưu hóa đơn PDF");
        chooser.setFileFilter(new FileNameExtensionFilter("PDF files", "pdf"));
        chooser.setSelectedFile(new File("hoa_don_" + LocalDateTime.now().format(FILE_TIME_FORMAT) + ".pdf"));

        int result = chooser.showSaveDialog(this);
        if (result != JFileChooser.APPROVE_OPTION) {
            return;
        }

        File file = chooser.getSelectedFile();
        if (!file.getName().toLowerCase().endsWith(".pdf")) {
            file = new File(file.getParentFile(), file.getName() + ".pdf");
        }

        try {
            writeInvoicePdf(file, content == null ? "" : content);
            JOptionPane.showMessageDialog(this,
                "Đã xuất hóa đơn PDF thành công:\n" + file.getAbsolutePath(),
                "Xuất PDF thành công", JOptionPane.INFORMATION_MESSAGE);
        } catch (IOException | IllegalArgumentException ex) {
            JOptionPane.showMessageDialog(this,
                    "Không thể xuất PDF: " + ex.getMessage(),
                    "Lỗi", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void writeInvoicePdf(File outputFile, String content) throws IOException {
        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage(PDRectangle.A4);
            document.addPage(page);

            PDFont regularFont = loadUnicodeFont(document);
            PDFont boldFont = regularFont;

            try (PDPageContentStream stream = new PDPageContentStream(document, page)) {
                float margin = 50f;
                float y = page.getMediaBox().getHeight() - margin;

                y = writeLine(stream, boldFont, 20f, margin, y, "CINEMA FINALE", 28f);
                y = writeLine(stream, regularFont, 12f, margin, y, "Hóa đơn thanh toán", 20f);
                y -= 6f;
                y = writeLine(stream, regularFont, 10f, margin, y,
                    "Thời gian xuất: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")), 16f);

                y -= 6f;
                stream.setLineWidth(1f);
                stream.moveTo(margin, y);
                stream.lineTo(page.getMediaBox().getWidth() - margin, y);
                stream.stroke();
                y -= 20f;

                List<String> lines = new ArrayList<>();
                for (String line : content.split("\\R")) {
                    String trimmed = line == null ? "" : line.trim();
                    if (!trimmed.isEmpty()) {
                        lines.add(trimmed);
                    }
                }

                for (String line : lines) {
                    if (y < margin + 30f) {
                        break;
                    }

                    String display = line;
                    if (display.equalsIgnoreCase("THANH TOÁN THÀNH CÔNG")
                            || display.equalsIgnoreCase("THANH TOÁN THÀNH CÔNG!")) {
                        y = writeLine(stream, boldFont, 14f, margin, y, "THANH TOÁN THÀNH CÔNG", 24f);
                        continue;
                    }

                    if (display.contains(":")) {
                        String[] parts = display.split(":", 2);
                        y = writeLine(stream, boldFont, 11f, margin, y, parts[0].trim() + ":", 16f);
                        y = writeLine(stream, regularFont, 11f, margin + 120f, y + 16f, parts[1].trim(), 16f);
                    } else {
                        y = writeLine(stream, regularFont, 11f, margin, y, display, 16f);
                    }
                }

                y -= 8f;
                stream.moveTo(margin, y);
                stream.lineTo(page.getMediaBox().getWidth() - margin, y);
                stream.stroke();
                y -= 18f;
                writeLine(stream, regularFont, 10f, margin, y,
                    "Cảm ơn quý khách đã sử dụng dịch vụ tại Cinema Finale.", 0f);
            }

            document.save(outputFile);
        }
    }

    private PDFont loadUnicodeFont(PDDocument document) throws IOException {
        String[] fontCandidates = {
                "C:/Windows/Fonts/arial.ttf",
                "C:/Windows/Fonts/tahoma.ttf",
                "C:/Windows/Fonts/segoeui.ttf"
        };

        for (String path : fontCandidates) {
            File fontFile = new File(path);
            if (fontFile.exists()) {
                return PDType0Font.load(document, fontFile);
            }
        }

        throw new IOException("Không tìm thấy font hệ thống hỗ trợ tiếng Việt để xuất PDF.");
    }

    private float writeLine(PDPageContentStream stream, PDFont font, float fontSize,
                            float x, float y, String text, float nextLineOffset) throws IOException {
        stream.beginText();
        stream.setFont(font, fontSize);
        stream.newLineAtOffset(x, y);
        stream.showText(text == null ? "" : text);
        stream.endText();
        return y - nextLineOffset;
    }
}
