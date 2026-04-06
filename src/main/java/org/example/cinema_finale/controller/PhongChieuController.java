package org.example.cinema_finale.controller;

import java.util.List;

import javax.swing.JDialog;
import javax.swing.JOptionPane;

import org.example.cinema_finale.dto.PhongChieuDTO;
import org.example.cinema_finale.service.PhongChieuService;
import org.example.cinema_finale.util.DataSyncEventBus;
import org.example.cinema_finale.view.panel.staff.GhePanel;
import org.example.cinema_finale.view.panel.staff.PhongChieuPanel;

public class PhongChieuController {

    private PhongChieuPanel view;
    private PhongChieuService service = new PhongChieuService();

    private boolean isEditMode = false;

    public PhongChieuController(PhongChieuPanel view) {
        this.view = view;

        init();
        loadTable();
    }

    private void init() {

        view.table.getSelectionModel().addListSelectionListener(e -> {
            int row = view.table.getSelectedRow();
            if (row >= 0) {
                PhongChieuDTO p = view.tableModel.getAt(row);

                view.txtMa.setText(String.valueOf(p.getMaPhongChieu()));
                view.txtTen.setText(p.getTenPhongChieu());
                view.txtManHinh.setText(p.getLoaiManHinh());
                view.txtAmThanh.setText(p.getHeThongAmThanh());
                view.cboTrangThai.setSelectedItem(p.getTrangThaiPhong());

                isEditMode = true;
            }
        });

        // ADD
        view.btnAdd.addActionListener(e -> {

            if (isEditMode) {
                clearForm();
                return;
            }

            PhongChieuDTO dto = getForm();
            if (dto == null) return;

            boolean ok = service.add(dto);
            loadTable();
            clearForm();

            if (ok) {
                DataSyncEventBus.publishPhongChieuChanged();
            }
        });

        // UPDATE
        view.btnUpdate.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn phòng để sửa!");
                return;
            }

            PhongChieuDTO dto = getForm();
            if (dto == null) return;

            boolean ok = service.update(dto);
            loadTable();

            if (ok) {
                DataSyncEventBus.publishPhongChieuChanged();
            }
        });

        // DELETE
        view.btnDelete.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn phòng để xóa!");
                return;
            }

            int row = view.table.getSelectedRow();
            if (row >= 0) {
                PhongChieuDTO p = view.tableModel.getAt(row);
                boolean ok = service.delete(p.getMaPhongChieu());
                loadTable();
                clearForm();

                if (ok) {
                    DataSyncEventBus.publishPhongChieuChanged();
                }
            }
        });

        // OPEN GHẾ
        view.btnSeatMap.addActionListener(e -> {

            int row = view.table.getSelectedRow();

            if (row < 0) {
                JOptionPane.showMessageDialog(view, "Chọn phòng trước!");
                return;
            }

            PhongChieuDTO p = view.tableModel.getAt(row);

            GhePanel ghePanel = new GhePanel(p.getMaPhongChieu());
            new GheController(ghePanel, p.getMaPhongChieu());

            JDialog dialog = new JDialog();
            dialog.setTitle("Ghế - " + p.getTenPhongChieu());
            dialog.setSize(900, 600);
            dialog.setLocationRelativeTo(null);
            dialog.add(ghePanel);

            dialog.setVisible(true);
        });
    }

    private void loadTable() {
        List<PhongChieuDTO> list = service.getAll();
        view.tableModel.setData(list);
    }

    private PhongChieuDTO getForm() {

        try {
            int soHang = Integer.parseInt(view.txtSoHang.getText());
            int soCot = Integer.parseInt(view.txtSoCot.getText());

            return new PhongChieuDTO(
                    view.txtMa.getText().isEmpty()
                            ? null
                            : Integer.parseInt(view.txtMa.getText()),
                    view.txtTen.getText(),
                    view.txtManHinh.getText(),
                    view.txtAmThanh.getText(),
                    view.cboTrangThai.getSelectedItem().toString()
            ){{
                setSoHang(soHang);
                setSoCot(soCot);
            }};

        } catch (Exception e) {
            JOptionPane.showMessageDialog(view, "Dữ liệu không hợp lệ!");
            return null;
        }
    }

    private void clearForm() {
        view.txtMa.setText("");
        view.txtTen.setText("");
        view.txtManHinh.setText("");
        view.txtAmThanh.setText("");
        view.cboTrangThai.setSelectedIndex(0);

        view.txtSoHang.setText("");
        view.txtSoCot.setText("");

        view.table.clearSelection();
        isEditMode = false;
    }
}