package org.example.cinema_finale.controller;

import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.enums.TrangThaiPhim;
import org.example.cinema_finale.service.PhimService;
import org.example.cinema_finale.view.PhimPanel;

import javax.swing.*;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

public class PhimController {

    private final PhimPanel view;
    private final PhimService service;

    public PhimController(PhimPanel view) {
        this.view = view;
        this.service = new PhimService();

        init();
        loadTable();
    }

    private void init() {

        // ===== ADD =====
        view.btnAdd.addActionListener(e -> {
            Phim p = getForm(false);
            if (p == null) return;

            String message = service.addPhim(p);
            JOptionPane.showMessageDialog(view, message);
            loadTable();
        });

        // ===== UPDATE =====
        view.btnUpdate.addActionListener(e -> {
            Phim p = getForm(true);
            if (p == null) return;

            String message = service.updatePhim(p);
            JOptionPane.showMessageDialog(view, message);
            loadTable();
        });

        // ===== DELETE (NGỪNG CHIẾU) =====
        view.btnDelete.addActionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                Phim p = view.tableModel.getPhimAt(row);

                int confirm = JOptionPane.showConfirmDialog(
                        view,
                        "Ngừng chiếu phim này?",
                        "Xác nhận",
                        JOptionPane.YES_NO_OPTION
                );

                if (confirm == JOptionPane.YES_OPTION) {
                    String message = service.deletePhim(
                            String.valueOf(p.getMaPhim()) // ✅ fix
                    );
                    JOptionPane.showMessageDialog(view, message);
                    loadTable();
                }
            }
        });

        // ===== CLICK TABLE =====
        view.table.getSelectionModel().addListSelectionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                Phim p = view.tableModel.getPhimAt(row);

                view.txtMa.setText(String.valueOf(p.getMaPhim()));
                view.txtTen.setText(p.getTenPhim());
                view.txtTheLoai.setText(p.getTheLoai());
                view.txtDaoDien.setText(p.getDaoDien());
                view.txtThoiLuong.setText(String.valueOf(p.getThoiLuong()));

                view.cboGioiHanTuoi.setSelectedItem(
                        mapDoTuoi(p.getGioiHanTuoi())
                );

                view.cboDinhDang.setSelectedItem(p.getDinhDang());

                if (p.getNgayKhoiChieu() != null) {
                    view.dateChooser.setDate(
                            java.sql.Date.valueOf(p.getNgayKhoiChieu())
                    );
                }

                view.cboTrangThai.setSelectedItem(
                        mapTrangThaiToEnum(p.getTrangThaiPhim())
                );

                view.txtMa.setEnabled(false);
            }
        });

        // ===== SEARCH =====
        view.btnSearch.addActionListener(e -> {
            String key = view.txtSearch.getText();
            List<Phim> list = service.searchByTenPhim(key);
            view.tableModel.setData(list);
        });
    }

    private void loadTable() {
        List<Phim> list = service.getAllPhim();
        view.tableModel.setData(list);
        view.txtMa.setEnabled(true);
    }

    // ================= FORM =================
    private Phim getForm(boolean isUpdate) {

        String maStr = view.txtMa.getText().trim();
        String ten = view.txtTen.getText().trim();
        String theLoai = view.txtTheLoai.getText().trim();
        String daoDien = view.txtDaoDien.getText().trim();
        String thoiLuongStr = view.txtThoiLuong.getText().trim();

        if (ten.isEmpty() || theLoai.isEmpty()
                || daoDien.isEmpty() || thoiLuongStr.isEmpty()) {

            JOptionPane.showMessageDialog(view, "Không được để trống!");
            return null;
        }

        int thoiLuong;
        try {
            thoiLuong = Integer.parseInt(thoiLuongStr);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(view, "Thời lượng phải là số!");
            return null;
        }

        LocalDate ngayChieu = null;
        if (view.dateChooser.getDate() != null) {
            ngayChieu = view.dateChooser.getDate()
                    .toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();
        }

        // ===== TẠO ENTITY ĐÚNG =====
        Phim p = new Phim();

        if (isUpdate) {
            try {
                p.setMaPhim(Integer.parseInt(maStr));
            } catch (Exception e) {
                JOptionPane.showMessageDialog(view, "Mã phim không hợp lệ!");
                return null;
            }
        }

        p.setTenPhim(ten);
        p.setTheLoai(theLoai);
        p.setDaoDien(daoDien);
        p.setThoiLuong(thoiLuong);
        p.setNgayKhoiChieu(ngayChieu);

        // map độ tuổi
        p.setGioiHanTuoi(mapTuoi(view.cboGioiHanTuoi.getSelectedItem()));

        p.setDinhDang((String) view.cboDinhDang.getSelectedItem());

        // map trạng thái
        p.setTrangThaiPhim(
                mapEnumToTrangThai(view.cboTrangThai.getSelectedItem())
        );

        return p;
    }

    // ================= MAPPING =================

    private Integer mapTuoi(Object value) {
        if (value == null) return null;

        return switch (value.toString()) {
            case "P" -> 0;
            case "K" -> 0;
            case "T13" -> 13;
            case "T16" -> 16;
            case "T18" -> 18;
            default -> null;
        };
    }

    private String mapDoTuoi(Integer tuoi) {
        if (tuoi == null) return "";

        if (tuoi >= 18) return "T18";
        if (tuoi >= 16) return "T16";
        if (tuoi >= 13) return "T13";
        return "P";
    }

    private String mapEnumToTrangThai(Object e) {
        if (e == null) return "Sắp chiếu";

        TrangThaiPhim t = (TrangThaiPhim) e;

        return switch (t) {
            case SAP_CHIEU -> "Sắp chiếu";
            case DANG_CHIEU -> "Đang chiếu";
            case NGUNG_CHIEU -> "Ngừng chiếu";
        };
    }

    private TrangThaiPhim mapTrangThaiToEnum(String s) {
        if (s == null) return TrangThaiPhim.SAP_CHIEU;

        return switch (s) {
            case "Đang chiếu" -> TrangThaiPhim.DANG_CHIEU;
            case "Ngừng chiếu" -> TrangThaiPhim.NGUNG_CHIEU;
            default -> TrangThaiPhim.SAP_CHIEU;
        };
    }
}