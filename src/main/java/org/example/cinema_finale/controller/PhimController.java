package org.example.cinema_finale.controller;

import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.time.DateTimeException;
import java.time.ZoneId;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.filechooser.FileNameExtensionFilter;

import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.service.PhimService;
import org.example.cinema_finale.util.DataSyncEventBus;
import org.example.cinema_finale.util.PosterStorageUtil;
import org.example.cinema_finale.view.PhimPanel;

public class PhimController {

    private final PhimPanel view;
    private final PhimService service = new PhimService();

    private boolean isEditMode = false;
    private String currentPosterUrl;

    public PhimController(PhimPanel view) {
        this.view = view;

        init();
        loadTable();
        bindPosterResizeRefresh();
        bindPosterClickPreview();
    }

    private void init() {

        // ===== CLICK TABLE =====
        view.table.getSelectionModel().addListSelectionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                PhimDTO p = view.tableModel.getAt(row);

                view.txtMa.setText(String.valueOf(p.getMaPhim()));
                view.txtTen.setText(p.getTenPhim());
                view.txtTheLoai.setText(p.getTheLoai());
                view.txtDaoDien.setText(p.getDaoDien());
                view.txtThoiLuong.setText(String.valueOf(p.getThoiLuong()));
                view.txtGioiHanTuoi.setText(String.valueOf(p.getGioiHanTuoi()));
                view.txtDinhDang.setText(p.getDinhDang());
                view.cboTrangThai.setSelectedItem(p.getTrangThaiPhim());
                currentPosterUrl = p.getPosterUrl();
                refreshPosterPreview(currentPosterUrl);

                if (p.getNgayKhoiChieu() != null) {
                    view.dateChooser.setDate(
                            java.sql.Date.valueOf(p.getNgayKhoiChieu())
                    );
                }

                isEditMode = true;
            }
        });

        // ===== ADD =====
        view.btnAdd.addActionListener(e -> {

            if (isEditMode) {
                clearForm();
                return;
            }

            PhimDTO dto = getForm();
            if (dto == null) return;

            String message = service.add(dto);
            JOptionPane.showMessageDialog(view, message);
            loadTable();
            clearForm();

            if (message.toLowerCase().contains("thành công")) {
                DataSyncEventBus.publishPhimChanged();
            }
        });

        // ===== UPDATE =====
        view.btnUpdate.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn phim để sửa!");
                return;
            }

            PhimDTO dto = getForm();
            if (dto == null) return;

            String message = service.update(dto);
            JOptionPane.showMessageDialog(view, message);
            loadTable();

            if (message.toLowerCase().contains("thành công")) {
                DataSyncEventBus.publishPhimChanged();
            }
        });

        // ===== DELETE =====
        view.btnDelete.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn phim để xóa!");
                return;
            }

            int row = view.table.getSelectedRow();
            if (row >= 0) {
                PhimDTO dto = view.tableModel.getAt(row);
                String message = service.delete(dto.getMaPhim());
                JOptionPane.showMessageDialog(view, message);
                loadTable();
                clearForm();

                if (message.toLowerCase().contains("thành công")) {
                    DataSyncEventBus.publishPhimChanged();
                }
            }
        });

        // ===== 🔥 REALTIME SEARCH =====
        view.txtSearch.getDocument().addDocumentListener(new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) { searchInline(); }
            @Override
            public void removeUpdate(DocumentEvent e) { searchInline(); }
            @Override
            public void changedUpdate(DocumentEvent e) { searchInline(); }

            private void searchInline() {
                String key = view.txtSearch.getText();

                if (key.isEmpty()) {
                    loadTable();
                } else {
                    view.tableModel.setData(service.searchByTenPhim(key));
                }
            }
        });

        view.btnUploadPoster.addActionListener(e -> handleUploadPoster());
        view.btnClearPoster.addActionListener(e -> handleClearPoster());
    }

    private void loadTable() {
        view.tableModel.setData(service.getAllPhim());
    }

    private PhimDTO getForm() {
        try {
            return new PhimDTO(
                    view.txtMa.getText().isEmpty() ? null : Integer.parseInt(view.txtMa.getText()),
                    view.txtTen.getText(),
                    view.txtTheLoai.getText(),
                    view.txtDaoDien.getText(),
                    Integer.parseInt(view.txtThoiLuong.getText()),
                    Integer.parseInt(view.txtGioiHanTuoi.getText()),
                    view.txtDinhDang.getText(),
                    view.dateChooser.getDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate(),
                    view.cboTrangThai.getSelectedItem().toString(),
                    currentPosterUrl
            );
        } catch (NumberFormatException | NullPointerException | DateTimeException e) {
            JOptionPane.showMessageDialog(view, "Dữ liệu không hợp lệ!");
            return null;
        }
    }

    private void clearForm() {
        view.txtMa.setText("");
        view.txtTen.setText("");
        view.txtTheLoai.setText("");
        view.txtDaoDien.setText("");
        view.txtThoiLuong.setText("");
        view.txtGioiHanTuoi.setText("");
        view.txtDinhDang.setText("");
        view.cboTrangThai.setSelectedIndex(0);
        view.dateChooser.setDate(null);
        currentPosterUrl = null;
        refreshPosterPreview(null);

        view.table.clearSelection();
        isEditMode = false;
    }

    private void handleUploadPoster() {
        JFileChooser chooser = new JFileChooser();
        chooser.setDialogTitle("Chọn poster phim");
        chooser.setAcceptAllFileFilterUsed(false);
        chooser.addChoosableFileFilter(new FileNameExtensionFilter("Image files", "jpg", "jpeg", "png", "webp"));

        int result = chooser.showOpenDialog(view);
        if (result != JFileChooser.APPROVE_OPTION) {
            return;
        }

        File selectedFile = chooser.getSelectedFile();

        try {
            String newPosterPath = PosterStorageUtil.storePoster(selectedFile);
            PosterStorageUtil.deletePosterQuietly(currentPosterUrl);
            currentPosterUrl = newPosterPath;
            refreshPosterPreview(currentPosterUrl);
        } catch (IOException ex) {
            JOptionPane.showMessageDialog(view, "Không thể upload poster: " + ex.getMessage());
        }
    }

    private void handleClearPoster() {
        PosterStorageUtil.deletePosterQuietly(currentPosterUrl);
        currentPosterUrl = null;
        refreshPosterPreview(null);
    }

    private void refreshPosterPreview(String posterPath) {
        if (posterPath == null || posterPath.isBlank()) {
            view.lblPosterPreview.setIcon(null);
            view.lblPosterPreview.setText("Chưa có poster");
            return;
        }

        File file = new File(posterPath);
        if (!file.exists()) {
            view.lblPosterPreview.setIcon(null);
            view.lblPosterPreview.setText("Poster không tồn tại");
            return;
        }

        int targetWidth = Math.max(1, view.lblPosterPreview.getWidth() - 12);
        int targetHeight = Math.max(1, view.lblPosterPreview.getHeight() - 12);

        if (targetWidth <= 1 || targetHeight <= 1) {
            targetWidth = 260;
            targetHeight = 160;
        }

        try {
            BufferedImage source = ImageIO.read(file);
            if (source == null || source.getWidth() <= 0 || source.getHeight() <= 0) {
                view.lblPosterPreview.setIcon(null);
                view.lblPosterPreview.setText("Không đọc được poster");
                return;
            }

            Image scaled = scaleImageHighQuality(source, targetWidth, targetHeight);

            view.lblPosterPreview.setText("");
            view.lblPosterPreview.setIcon(new ImageIcon(scaled));
            view.lblPosterPreview.setToolTipText("Click để xem ảnh lớn");
        } catch (IOException ex) {
            view.lblPosterPreview.setIcon(null);
            view.lblPosterPreview.setText("Không đọc được poster");
            view.lblPosterPreview.setToolTipText(null);
        }
    }

    private Image scaleImageHighQuality(BufferedImage source, int targetWidth, int targetHeight) {
        double scale = Math.min((double) targetWidth / source.getWidth(), (double) targetHeight / source.getHeight());
        int drawWidth = Math.max(1, (int) Math.round(source.getWidth() * scale));
        int drawHeight = Math.max(1, (int) Math.round(source.getHeight() * scale));

        BufferedImage output = new BufferedImage(drawWidth, drawHeight, BufferedImage.TYPE_INT_ARGB);
        var g2 = output.createGraphics();
        try {
            g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g2.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2.drawImage(source, 0, 0, drawWidth, drawHeight, null);
        } finally {
            g2.dispose();
        }

        return output;
    }

    private void bindPosterResizeRefresh() {
        view.lblPosterPreview.addComponentListener(new ComponentAdapter() {
            @Override
            public void componentResized(ComponentEvent e) {
                if (currentPosterUrl != null && !currentPosterUrl.isBlank()) {
                    refreshPosterPreview(currentPosterUrl);
                }
            }
        });
    }

    private void bindPosterClickPreview() {
        view.lblPosterPreview.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                if (currentPosterUrl == null || currentPosterUrl.isBlank()) {
                    return;
                }

                File file = new File(currentPosterUrl);
                if (!file.exists()) {
                    return;
                }

                ImageIcon icon = new ImageIcon(currentPosterUrl);
                if (icon.getIconWidth() <= 0 || icon.getIconHeight() <= 0) {
                    return;
                }

                int maxW = 1100;
                int maxH = 700;
                double scale = Math.min(1.0, Math.min((double) maxW / icon.getIconWidth(), (double) maxH / icon.getIconHeight()));

                int w = Math.max(1, (int) Math.round(icon.getIconWidth() * scale));
                int h = Math.max(1, (int) Math.round(icon.getIconHeight() * scale));
                Image scaled = icon.getImage().getScaledInstance(w, h, Image.SCALE_SMOOTH);

                JLabel label = new JLabel(new ImageIcon(scaled));
                JScrollPane pane = new JScrollPane(label);
                pane.setPreferredSize(new java.awt.Dimension(Math.min(w + 20, 1140), Math.min(h + 20, 740)));

                JOptionPane.showMessageDialog(
                        view,
                        pane,
                        "Poster preview",
                        JOptionPane.PLAIN_MESSAGE
                );
            }
        });
    }
}