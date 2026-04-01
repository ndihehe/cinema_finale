package org.example.cinema_finale.controller;

import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.service.PhimService;
import org.example.cinema_finale.view.PhimPanel;

import javax.swing.*;
import java.time.ZoneId;

public class PhimController {

    private PhimPanel view;
    private PhimService service = new PhimService();

    public PhimController(PhimPanel view) {
        this.view = view;

        init();
        loadTable();
    }

    private void init() {

        view.btnAdd.addActionListener(e -> {
            PhimDTO dto = getForm();
            if (dto == null) return;

            service.add(dto);
            loadTable();
        });

        view.btnUpdate.addActionListener(e -> {
            PhimDTO dto = getForm();
            if (dto == null) return;

            service.update(dto);
            loadTable();
        });

        view.btnDelete.addActionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                PhimDTO dto = view.tableModel.getAt(row);
                service.delete(dto.getMaPhim());
                loadTable();
            }
        });

        view.btnSearch.addActionListener(e -> {
            view.tableModel.setData(
                    service.search(view.txtSearch.getText())
            );
        });

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
            }
        });
    }

    private void loadTable() {
        view.tableModel.setData(service.getAll());
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
}