package org.example.cinema_finale.controller;

import org.example.cinema_finale.dto.GheDTO;
import org.example.cinema_finale.service.GheService;
import org.example.cinema_finale.view.GhePanel;

import javax.swing.*;
import java.util.List;

public class GheController {

    private GhePanel view;
    private GheService service = new GheService();

    public GheController(GhePanel view) {
        this.view = view;

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

                view.cboPhong.setSelectedItem(g.getTenPhongChieu());
                view.cboLoaiGhe.setSelectedItem(g.getTenLoaiGheNgoi());
                view.cboTrangThai.setSelectedItem(g.getTrangThaiGhe());

                view.highlightSeat(g.getViTriGhe());
            }
        });

        // CLICK SEAT
        view.seatMapPanel.addMouseListener(new java.awt.event.MouseAdapter() {});

        // BUTTON
        view.btnAdd.addActionListener(e -> {
            GheDTO dto = getForm();
            if (dto == null) return;

            service.add(dto);
            loadTable();
        });

        view.btnUpdate.addActionListener(e -> {
            GheDTO dto = getForm();
            if (dto == null) return;

            service.update(dto);
            loadTable();
        });

        view.btnDelete.addActionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                GheDTO dto = view.tableModel.getAt(row);
                service.delete(dto.getMaGheNgoi());
                loadTable();
            }
        });
    }

    private void loadTable() {
        Integer maPhong = 1;

        List<GheDTO> list = service.getByPhong(maPhong);

        view.tableModel.setData(list);
        view.renderSeatMap(list);
    }

    private GheDTO getForm() {
        try {
            return new GheDTO(
                    view.txtMa.getText().isEmpty() ? null : Integer.parseInt(view.txtMa.getText()),
                    1,
                    "Phòng 1",
                    view.txtHangGhe.getText(),
                    Integer.parseInt(view.txtSoGhe.getText()),
                    1,
                    view.cboLoaiGhe.getSelectedItem().toString(),
                    view.cboTrangThai.getSelectedItem().toString()
            );
        } catch (Exception e) {
            JOptionPane.showMessageDialog(view, "Dữ liệu không hợp lệ!");
            return null;
        }
    }
}