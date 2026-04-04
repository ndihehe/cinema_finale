package org.example.cinema_finale.controller;

import java.time.ZoneId;

import javax.swing.JOptionPane;

import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.service.PhimService;
import org.example.cinema_finale.util.DataSyncEventBus;
import org.example.cinema_finale.view.PhimPanel;

public class PhimController {

    private PhimPanel view;
    private PhimService service = new PhimService();

    private boolean isEditMode = false;

    public PhimController(PhimPanel view) {
        this.view = view;

        init();
        loadTable();
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
        view.txtSearch.getDocument().addDocumentListener(new javax.swing.event.DocumentListener() {
            public void insertUpdate(javax.swing.event.DocumentEvent e) { search(); }
            public void removeUpdate(javax.swing.event.DocumentEvent e) { search(); }
            public void changedUpdate(javax.swing.event.DocumentEvent e) { search(); }

            private void search() {
                String key = view.txtSearch.getText();

                if (key.isEmpty()) {
                    loadTable();
                } else {
                    view.tableModel.setData(service.searchByTenPhim(key));
                }
            }
        });
    }

    private void search() {
        String keyword = view.txtSearch.getText().trim();

        if (keyword.isEmpty()) {
            loadTable(); // 🔥 auto reset
        } else {
            view.tableModel.setData(
                    service.searchByTenPhim(keyword)
            );
        }
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
                    view.cboTrangThai.getSelectedItem().toString()
            );
        } catch (Exception e) {
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

        view.table.clearSelection();
        isEditMode = false;
    }
}