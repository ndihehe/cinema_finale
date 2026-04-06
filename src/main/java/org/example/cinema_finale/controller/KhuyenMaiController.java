package org.example.cinema_finale.controller;

import java.math.BigDecimal;
import java.time.ZoneId;

import javax.swing.JOptionPane;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;

import org.example.cinema_finale.dao.LoaiKhuyenMaiDao;
import org.example.cinema_finale.dto.KhuyenMaiDTO;
import org.example.cinema_finale.dto.KhuyenMaiFormDTO;
import org.example.cinema_finale.entity.LoaiKhuyenMai;
import org.example.cinema_finale.service.KhuyenMaiService;
import org.example.cinema_finale.view.panel.staff.KhuyenMaiPanel;

public class KhuyenMaiController {

    private KhuyenMaiPanel view;
    private KhuyenMaiService service = new KhuyenMaiService();

    private boolean isEditMode = false;

    public KhuyenMaiController(KhuyenMaiPanel view) {
        this.view = view;

        init();
        loadLoaiKhuyenMai();
        loadTable();
    }

    private void init() {

        // CLICK TABLE
        view.table.getSelectionModel().addListSelectionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                KhuyenMaiDTO k = view.tableModel.getAt(row);

                view.txtMa.setText(String.valueOf(k.getMaKhuyenMai()));
                view.txtTen.setText(k.getTenKhuyenMai());
                view.cboKieu.setSelectedItem(k.getKieuGiaTri());
                view.txtGiaTri.setText(k.getGiaTri().toString());
                view.txtDonHangToiThieu.setText(k.getDonHangToiThieu().toString());
                view.cboTrangThai.setSelectedItem(k.getTrangThai());

                isEditMode = true;
            }
        });

        // ADD
        view.btnAdd.addActionListener(e -> {

            if (isEditMode) {
                clearForm();
                return;
            }

            KhuyenMaiFormDTO dto = getForm(true);
            if (dto == null) return;

            JOptionPane.showMessageDialog(view, service.addKhuyenMai(dto));
            loadTable();
            clearForm();
        });

        // UPDATE
        view.btnUpdate.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn khuyến mãi!");
                return;
            }

            KhuyenMaiFormDTO dto = getForm(false);
            if (dto == null) return;

            JOptionPane.showMessageDialog(view, service.updateKhuyenMai(dto));
            loadTable();
        });

        // DELETE
        view.btnDelete.addActionListener(e -> {

            if (!isEditMode) return;

            int row = view.table.getSelectedRow();
            if (row >= 0) {
                KhuyenMaiDTO dto = view.tableModel.getAt(row);
                JOptionPane.showMessageDialog(view,
                        service.deactivateKhuyenMai(dto.getMaKhuyenMai().toString()));
                loadTable();
                clearForm();
            }
        });

        // 🔥 SEARCH REALTIME
        view.txtSearch.getDocument().addDocumentListener(new DocumentListener() {

            private void search() {
                String key = view.txtSearch.getText().trim();

                if (key.isEmpty()) {
                    loadTable();
                } else {
                    view.tableModel.setData(
                            service.getAllKhuyenMai().stream()
                                    .filter(k -> k.getTenKhuyenMai().toLowerCase().contains(key.toLowerCase()))
                                    .toList()
                    );
                }
            }

            public void insertUpdate(DocumentEvent e) { search(); }
            public void removeUpdate(DocumentEvent e) { search(); }
            public void changedUpdate(DocumentEvent e) { search(); }
        });
    }

    private void loadLoaiKhuyenMai() {
        view.cboLoai.removeAllItems();

        LoaiKhuyenMaiDao dao = new LoaiKhuyenMaiDao();

        for (LoaiKhuyenMai l : dao.findAll()) { // :contentReference[oaicite:0]{index=0}
            view.cboLoai.addItem(l);
        }
    }

    private void loadTable() {
        view.tableModel.setData(service.getAllKhuyenMai()); // :contentReference[oaicite:1]{index=1}
    }

    private KhuyenMaiFormDTO getForm(boolean isCreate) {
        try {
            LoaiKhuyenMai selected = (LoaiKhuyenMai) view.cboLoai.getSelectedItem();

            return new KhuyenMaiFormDTO(
                    isCreate ? null : Integer.parseInt(view.txtMa.getText()),
                    view.txtTen.getText(),
                    selected != null ? selected.getMaLoaiKhuyenMai() : null,
                    view.cboKieu.getSelectedItem().toString(),
                    new BigDecimal(view.txtGiaTri.getText()),
                    view.dateStart.getDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime(),
                    view.dateEnd.getDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime(),
                    new BigDecimal(view.txtDonHangToiThieu.getText()),
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
        view.txtGiaTri.setText("");
        view.txtDonHangToiThieu.setText("");
        view.dateStart.setDate(null);
        view.dateEnd.setDate(null);
        view.cboTrangThai.setSelectedIndex(0);

        view.table.clearSelection();
        isEditMode = false;
    }
}