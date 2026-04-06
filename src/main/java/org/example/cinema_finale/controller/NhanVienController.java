package org.example.cinema_finale.controller;

import java.time.LocalDate;

import javax.swing.JOptionPane;

import org.example.cinema_finale.dto.NhanVienDTO;
import org.example.cinema_finale.dto.NhanVienFormDTO;
import org.example.cinema_finale.service.NhanVienService;
import org.example.cinema_finale.view.panel.staff.NhanVienPanel;

public class NhanVienController {

    private NhanVienPanel view;
    private NhanVienService service = new NhanVienService();

    private boolean isEditMode = false;

    public NhanVienController(NhanVienPanel view) {
        this.view = view;

        init();
        loadTable();
    }

    private void init() {

        view.table.getSelectionModel().addListSelectionListener(e -> {
            int row = view.table.getSelectedRow();

            if (row >= 0) {
                NhanVienDTO nv = view.tableModel.getAt(row);

                view.txtMa.setText(String.valueOf(nv.getMaNhanVien()));
                view.txtTen.setText(nv.getHoTen());
                view.txtNgaySinh.setText(String.valueOf(nv.getNgaySinh()));
                view.txtSDT.setText(nv.getSoDienThoai());
                view.txtEmail.setText(nv.getEmail());
                view.txtDiaChi.setText(nv.getDiaChi());

                view.cboGioiTinh.setSelectedItem(nv.getGioiTinh());
                view.cboTrangThai.setSelectedItem(nv.getTrangThaiLamViec());

                isEditMode = true;
            }
        });

        // ADD
        view.btnAdd.addActionListener(e -> {

            if (isEditMode) {
                clearForm(); // 🔥 FIX BUG
                return;
            }

            NhanVienFormDTO dto = getForm(true);
            if (dto == null) return;

            JOptionPane.showMessageDialog(view, service.addNhanVien(dto));

            loadTable();
            clearForm();
        });

        // UPDATE
        view.btnUpdate.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn nhân viên!");
                return;
            }

            NhanVienFormDTO dto = getForm(false);
            if (dto == null) return;

            JOptionPane.showMessageDialog(view, service.updateNhanVien(dto));
            loadTable();
        });

        // DELETE
        view.btnDelete.addActionListener(e -> {

            int row = view.table.getSelectedRow();

            if (row < 0) {
                JOptionPane.showMessageDialog(view, "Chọn nhân viên!");
                return;
            }

            NhanVienDTO nv = view.tableModel.getAt(row);

            JOptionPane.showMessageDialog(view,
                    service.deactivateNhanVien(String.valueOf(nv.getMaNhanVien()))
            );

            loadTable();
            clearForm();
        });

        view.txtSearch.getDocument().addDocumentListener(new javax.swing.event.DocumentListener() {

            private void search() {
                String key = view.txtSearch.getText();

                if (key.isEmpty()) {
                    loadTable();
                } else {
                    view.tableModel.setData(service.search(key));
                }
            }

            public void insertUpdate(javax.swing.event.DocumentEvent e) { search(); }
            public void removeUpdate(javax.swing.event.DocumentEvent e) { search(); }
            public void changedUpdate(javax.swing.event.DocumentEvent e) { search(); }
        });
    }

    private void loadTable() {
        view.tableModel.setData(service.getAllNhanVien());
    }

    private NhanVienFormDTO getForm(boolean isCreate) {
        try {
            NhanVienFormDTO dto = new NhanVienFormDTO();

            if (!isCreate) {
                dto.setMaNhanVien(Integer.parseInt(view.txtMa.getText()));
            }

            dto.setHoTen(view.txtTen.getText());
            dto.setNgaySinh(LocalDate.parse(view.txtNgaySinh.getText()));
            dto.setGioiTinh(view.cboGioiTinh.getSelectedItem().toString());
            dto.setSoDienThoai(view.txtSDT.getText());
            dto.setEmail(view.txtEmail.getText());
            dto.setDiaChi(view.txtDiaChi.getText());
            dto.setMaChucVu(Integer.parseInt(view.cboChucVu.getSelectedItem().toString()));
            dto.setTrangThaiLamViec(view.cboTrangThai.getSelectedItem().toString());

            return dto;

        } catch (Exception e) {
            JOptionPane.showMessageDialog(view, "Sai định dạng yyyy-MM-dd");
            return null;
        }
    }

    private void clearForm() {

        view.txtMa.setText("");
        view.txtTen.setText("");
        view.txtNgaySinh.setText("");
        view.txtSDT.setText("");
        view.txtEmail.setText("");
        view.txtDiaChi.setText("");

        view.cboGioiTinh.setSelectedIndex(0);
        view.cboTrangThai.setSelectedIndex(0);

        view.table.clearSelection();
        isEditMode = false;
    }
}