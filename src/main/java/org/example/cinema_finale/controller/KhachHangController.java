package org.example.cinema_finale.controller;

import org.example.cinema_finale.dto.KhachHangDTO;
import org.example.cinema_finale.dto.KhachHangFormDTO;
import org.example.cinema_finale.service.KhachHangService;
import org.example.cinema_finale.view.KhachHangPanel;

import javax.swing.*;
import java.time.ZoneId;

public class KhachHangController {

    private KhachHangPanel view;
    private KhachHangService service = new KhachHangService();

    private boolean isEditMode = false;

    public KhachHangController(KhachHangPanel view){
        this.view = view;

        init();
        loadTable();
    }

    private void init(){

        // CLICK TABLE
        view.table.getSelectionModel().addListSelectionListener(e -> {
            int row = view.table.getSelectedRow();
            if(row >= 0){
                KhachHangDTO k = view.tableModel.getAt(row);

                view.txtMa.setText(String.valueOf(k.getMaKhachHang()));
                view.txtTen.setText(k.getHoTen());
                view.txtSDT.setText(k.getSoDienThoai());
                view.txtEmail.setText(k.getEmail());
                view.cboGioiTinh.setSelectedItem(k.getGioiTinh());
                view.cboHang.setSelectedItem(k.getHangThanhVien());
                view.txtDiem.setText(String.valueOf(k.getDiemTichLuy()));

                if(k.getNgaySinh() != null){
                    view.dateChooser.setDate(
                            java.sql.Date.valueOf(k.getNgaySinh())
                    );
                }

                isEditMode = true;
            }
        });

        // ADD
        view.btnAdd.addActionListener(e -> {

            if(isEditMode){
                clearForm();
                return;
            }

            KhachHangFormDTO dto = getForm();
            if(dto == null) return;

            JOptionPane.showMessageDialog(view,
                    service.addKhachHang(dto));

            loadTable();
            clearForm();
        });

        // UPDATE
        view.btnUpdate.addActionListener(e -> {

            if(!isEditMode){
                JOptionPane.showMessageDialog(view,"Chọn khách hàng!");
                return;
            }

            KhachHangFormDTO dto = getForm();
            if(dto == null) return;

            JOptionPane.showMessageDialog(view,
                    service.updateKhachHang(dto));

            loadTable();
        });

        // SEARCH
        view.txtSearch.getDocument().addDocumentListener(new javax.swing.event.DocumentListener() {

            public void insertUpdate(javax.swing.event.DocumentEvent e) { search(); }
            public void removeUpdate(javax.swing.event.DocumentEvent e) { search(); }
            public void changedUpdate(javax.swing.event.DocumentEvent e) { search(); }

            private void search() {
                String key = view.txtSearch.getText().trim();

                if (key.isEmpty()) {
                    loadTable(); // 🔥 QUAN TRỌNG (fix bug reset)
                } else {
                    view.tableModel.setData(service.search(key));
                }
            }
        });
        
    }

    private void loadTable(){
        view.tableModel.setData(service.getAllKhachHang());
    }

    private KhachHangFormDTO getForm(){
        try{
            KhachHangFormDTO dto = new KhachHangFormDTO();

            if(!view.txtMa.getText().isEmpty()){
                dto.setMaKhachHang(Integer.parseInt(view.txtMa.getText()));
            }

            dto.setHoTen(view.txtTen.getText());
            dto.setSoDienThoai(view.txtSDT.getText());
            dto.setEmail(view.txtEmail.getText());
            dto.setGioiTinh(view.cboGioiTinh.getSelectedItem().toString());
            dto.setHangThanhVien(view.cboHang.getSelectedItem().toString());
            dto.setDiemTichLuy(Integer.parseInt(view.txtDiem.getText()));

            if(view.dateChooser.getDate() != null){
                dto.setNgaySinh(
                        view.dateChooser.getDate()
                                .toInstant()
                                .atZone(ZoneId.systemDefault())
                                .toLocalDate()
                );
            }

            return dto;

        }catch (Exception e){
            JOptionPane.showMessageDialog(view,"Dữ liệu không hợp lệ!");
            return null;
        }
    }

    private void clearForm(){
        view.txtMa.setText("");
        view.txtTen.setText("");
        view.txtSDT.setText("");
        view.txtEmail.setText("");
        view.txtDiem.setText("");

        view.cboGioiTinh.setSelectedIndex(0);
        view.cboHang.setSelectedIndex(0);
        view.dateChooser.setDate(null);

        view.table.clearSelection();
        isEditMode = false;
    }
}