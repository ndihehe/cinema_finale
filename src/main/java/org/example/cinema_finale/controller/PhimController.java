package org.example.cinema_finale.controller;

import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.enums.TrangThaiPhim;
import org.example.cinema_finale.view.PhimPanel;

import javax.swing.*;
import java.awt.*;
import java.time.LocalDate;
import java.util.List;
import java.time.ZoneId;

public class PhimController {

    private PhimPanel view;
    private PhimDao dao;

    public PhimController(PhimPanel view) {
        this.view = view;
        this.dao = new PhimDao();

        init();
        loadTable();
    }

    private void init() {

        // ADD
        view.btnAdd.addActionListener(e -> {
            Phim p = getForm();
            if (p == null) return;

            if (dao.existsById(p.getMaPhim())) {
                JOptionPane.showMessageDialog(view, "Mã đã tồn tại!");
                return;
            }

            dao.save(p);
            loadTable();
        });

        // DELETE = NGỪNG CHIẾU
        view.btnDelete.addActionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                Phim p = view.tableModel.getPhimAt(row);

                int confirm = JOptionPane.showConfirmDialog(view,
                        "Ngừng chiếu phim này?",
                        "Xác nhận",
                        JOptionPane.YES_NO_OPTION);

                if (confirm == JOptionPane.YES_OPTION) {
                    dao.delete(p.getMaPhim());
                    loadTable();
                }
            }
        });

        // UPDATE
        view.btnUpdate.addActionListener(e -> {
            Phim p = getForm();
            if (p == null) return;

            dao.update(p);
            loadTable();
        });

        // CLICK TABLE
        view.table.getSelectionModel().addListSelectionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                Phim p = view.tableModel.getPhimAt(row);

                view.txtMa.setText(p.getMaPhim());
                view.txtTen.setText(p.getTenPhim());
                view.txtTheLoai.setText(p.getTheLoai());
                view.txtDaoDien.setText(p.getDaoDien());
                view.txtThoiLuong.setText(p.getThoiLuong().toString());
                view.cboGioiHanTuoi.setSelectedItem(p.getGioiHanTuoi());
                view.cboDinhDang.setSelectedItem(p.getDinhDang());

                view.dateChooser.setDate(
                        java.sql.Date.valueOf(p.getNgayKhoiChieu())
                );
                view.cboTrangThai.setSelectedItem(p.getTrangThaiPhim());

                view.txtMa.setEnabled(false);
            }
        });

        // SEARCH
        view.btnSearch.addActionListener(e -> {
            String key = view.txtSearch.getText();
            List<Phim> list = dao.findByTenPhim(key);
            view.tableModel.setData(list);
        });
    }

    private void loadTable() {
        List<Phim> list = dao.findAll();
        view.tableModel.setData(list);
        view.txtMa.setEnabled(true);
    }

    private Phim getForm() {

        String ma = view.txtMa.getText().trim();
        String ten = view.txtTen.getText().trim();
        String theLoai = view.txtTheLoai.getText().trim();
        String daoDien = view.txtDaoDien.getText().trim();
        String thoiLuongStr = view.txtThoiLuong.getText().trim();
        String gioiHanTuoi = (String) view.cboGioiHanTuoi.getSelectedItem();
        String dinhDang = (String) view.cboDinhDang.getSelectedItem();

        // ===== 1. RỖNG =====
        if (ma.isEmpty() || ten.isEmpty() || theLoai.isEmpty()
                || daoDien.isEmpty() || thoiLuongStr.isEmpty()) {

            JOptionPane.showMessageDialog(view, "Không được để trống!");
            return null;
        }

        // ===== 2. MÃ PHIM =====
        if (!ma.matches("^P\\d{3,}$")) {
            JOptionPane.showMessageDialog(view, "Mã phim phải dạng Pxxx (vd: P001)");
            return null;
        }

        // ===== 3. THỜI LƯỢNG =====
        int thoiLuong;
        try {
            thoiLuong = Integer.parseInt(thoiLuongStr);
            if (thoiLuong <= 0 || thoiLuong > 500) {
                JOptionPane.showMessageDialog(view, "Thời lượng phải từ 1 - 500 phút");
                return null;
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(view, "Thời lượng phải là số!");
            return null;
        }

        //===== 7. NGAY CHIEU =====
        if (view.dateChooser.getDate() == null) {
            JOptionPane.showMessageDialog(view, "Chọn ngày chiếu!");
            return null;
        }

        LocalDate ngayChieu = view.dateChooser.getDate()
                .toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
        TrangThaiPhim trangThai = (TrangThaiPhim) view.cboTrangThai.getSelectedItem();

        // ===== 5. TÊN PHIM =====
        if (ten.length() < 2) {
            JOptionPane.showMessageDialog(view, "Tên phim quá ngắn!");
            return null;
        }

        // ===== 6. GIỚI HẠN TUỔI =====
        if (!gioiHanTuoi.isEmpty() &&
                !gioiHanTuoi.matches("P|K|T13|T16|T18")) {
            JOptionPane.showMessageDialog(view,
                    "Giới hạn tuổi: P, K, T13, T16, T18");
            return null;
        }

        // ===== 7. ĐỊNH DẠNG =====
        if (!dinhDang.isEmpty() &&
                !dinhDang.matches("2D|3D|IMAX")) {
            JOptionPane.showMessageDialog(view,
                    "Định dạng: 2D, 3D, IMAX");
            return null;
        }

        // ===== OK =====
        return new Phim(
                ma, ten, theLoai, daoDien,
                thoiLuong, gioiHanTuoi, dinhDang,
                ngayChieu,
                "",
                trangThai
        );
    }
    //Highlight lỗi
    private void markError(JTextField field) {
        field.setBorder(BorderFactory.createLineBorder(Color.RED));
    }

    private void clearError(JTextField field) {
        field.setBorder(UIManager.getBorder("TextField.border"));
    }
}