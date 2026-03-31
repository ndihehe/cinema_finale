package org.example.cinema_finale.controller;

import org.example.cinema_finale.entity.GheNgoi;
import org.example.cinema_finale.entity.PhongChieu;
import org.example.cinema_finale.service.GheService;
import org.example.cinema_finale.view.GhePanel;

import javax.swing.*;

public class GheController {

    private final GhePanel view;
    private final GheService service;

    public GheController(GhePanel view) {
        this.view = view;
        this.service = new GheService();

        init();
        loadByPhong();
    }

    private void init() {

        view.cboPhong.addActionListener(e -> loadByPhong());

        view.table.getSelectionModel().addListSelectionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                GheNgoi g = view.tableModel.getAt(row);

                view.txtMa.setText(String.valueOf(g.getMaGheNgoi()));

                view.txtTen.setText(
                        (g.getHangGhe() != null ? g.getHangGhe() : "") +
                                (g.getSoGhe() != null ? g.getSoGhe() : "")
                );

                view.txtLoai.setText(
                        g.getLoaiGheNgoi() != null
                                ? g.getLoaiGheNgoi().getTenLoaiGheNgoi()
                                : ""
                );

                view.chkTrangThai.setSelected(
                        "Hoạt động".equals(g.getTrangThaiGhe())
                );

                view.cboPhong.setSelectedItem(g.getPhongChieu());
            }
        });
    }

    private void loadByPhong() {
        PhongChieu p = (PhongChieu) view.cboPhong.getSelectedItem();

        if (p != null) {
            view.tableModel.setData(
                    service.getByPhong(p.getMaPhongChieu())
            );
        }
    }
}