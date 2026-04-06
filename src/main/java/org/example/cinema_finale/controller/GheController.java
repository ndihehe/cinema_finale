package org.example.cinema_finale.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.swing.JButton;
import javax.swing.JOptionPane;

import org.example.cinema_finale.dto.GheDTO;
import org.example.cinema_finale.service.GheService;
import org.example.cinema_finale.view.panel.staff.GhePanel;

public class GheController {

    private GhePanel view;
    private GheService service = new GheService();
    private Integer maPhong;
    private final Map<String, Integer> loaiGheNameToId = new HashMap<>();

    private boolean isEditMode = false; // 🔥 MODE

    public GheController(GhePanel view, Integer maPhong) {
        this.view = view;
        this.maPhong = maPhong;

        init();
        loadTable();
    }

    private void init() {

        // CLICK TABLE
        view.table.getSelectionModel().addListSelectionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                GheDTO g = view.tableModel.getAt(row);

                view.txtMa.setText(String.valueOf(g.getMaGheNgoi()));
                view.txtHangGhe.setText(g.getHangGhe());
                view.txtSoGhe.setText(String.valueOf(g.getSoGhe()));
                view.cboLoaiGhe.setSelectedItem(normalizeLoaiGheDisplay(g.getTenLoaiGheNgoi()));
                view.cboTrangThai.setSelectedItem(g.getTrangThaiGhe());

                isEditMode = true;
            }
        });

        // ADD
        view.btnAdd.addActionListener(e -> {

            if (isEditMode) {
                clearForm();
                return;
            }

            GheDTO dto = getForm();
            if (dto == null) return;

            dto.setMaPhongChieu(maPhong);

            service.add(dto);
            loadTable();
            clearForm();
        });

        // UPDATE
        view.btnUpdate.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn ghế để sửa!");
                return;
            }

            GheDTO dto = getForm();
            if (dto == null) return;

            dto.setMaPhongChieu(maPhong);

            service.update(dto);
            loadTable();
        });

        // DELETE
        view.btnDelete.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn ghế để xóa!");
                return;
            }

            int row = view.table.getSelectedRow();
            if (row >= 0) {
                GheDTO dto = view.tableModel.getAt(row);
                service.delete(dto.getMaGheNgoi());
                loadTable();
                clearForm();
            }
        });
    }

    private void loadTable() {
        List<GheDTO> list = service.getByPhong(maPhong);
        loaiGheNameToId.clear();
        for (GheDTO gheDTO : list) {
            if (gheDTO.getTenLoaiGheNgoi() != null && gheDTO.getMaLoaiGheNgoi() != null) {
                loaiGheNameToId.put(normalizeLoaiGheDisplay(gheDTO.getTenLoaiGheNgoi()), gheDTO.getMaLoaiGheNgoi());
            }
        }
        view.tableModel.setData(list);
        view.renderSeatMap(list);
        bindSeatMapClicks(list);
    }

    private void bindSeatMapClicks(List<GheDTO> list) {
        for (int i = 0; i < list.size(); i++) {
            GheDTO gheDTO = list.get(i);
            JButton btn = view.seatMap.get(gheDTO.getViTriGhe());
            if (btn == null) {
                continue;
            }

            final int rowIndex = i;
            for (java.awt.event.ActionListener listener : btn.getActionListeners()) {
                btn.removeActionListener(listener);
            }

            btn.addActionListener(e -> {
                view.table.setRowSelectionInterval(rowIndex, rowIndex);
                view.table.scrollRectToVisible(view.table.getCellRect(rowIndex, 0, true));
            });
        }
    }

    private GheDTO getForm() {
        try {
            return new GheDTO(
                    view.txtMa.getText().isEmpty() ? null : Integer.parseInt(view.txtMa.getText()),
                    maPhong,
                    "",
                    view.txtHangGhe.getText(),
                    Integer.parseInt(view.txtSoGhe.getText()),
                    getLoaiGheIdBySelection(),
                    normalizeLoaiGheDisplay(view.cboLoaiGhe.getSelectedItem().toString()),
                    view.cboTrangThai.getSelectedItem().toString()
            );
        } catch (Exception e) {
            JOptionPane.showMessageDialog(view, "Dữ liệu không hợp lệ!");
            return null;
        }
    }

    private void clearForm() {
        view.txtMa.setText("");
        view.txtHangGhe.setText("");
        view.txtSoGhe.setText("");
        view.cboLoaiGhe.setSelectedIndex(0);
        view.cboTrangThai.setSelectedIndex(0);

        view.table.clearSelection();
        isEditMode = false;
    }

    private Integer getLoaiGheIdBySelection() {
        String loaiGheDisplay = normalizeLoaiGheDisplay(view.cboLoaiGhe.getSelectedItem().toString());

        if (loaiGheNameToId.containsKey(loaiGheDisplay)) {
            return loaiGheNameToId.get(loaiGheDisplay);
        }

        if ("Ghế VIP".equalsIgnoreCase(loaiGheDisplay)) {
            return 2;
        }
        if ("Ghế đôi".equalsIgnoreCase(loaiGheDisplay)) {
            return 3;
        }
        return 1;
    }

    private String normalizeLoaiGheDisplay(String raw) {
        if (raw == null) {
            return "Ghế thường";
        }

        String value = raw.trim();
        if ("VIP".equalsIgnoreCase(value) || "Ghế VIP".equalsIgnoreCase(value)) {
            return "Ghế VIP";
        }
        if ("Ghế đôi".equalsIgnoreCase(value)) {
            return "Ghế đôi";
        }
        return "Ghế thường";
    }
}