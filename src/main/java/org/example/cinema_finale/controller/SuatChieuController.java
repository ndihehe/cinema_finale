package org.example.cinema_finale.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

import javax.swing.JOptionPane;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;

import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.dto.PhongChieuDTO;
import org.example.cinema_finale.dto.SuatChieuDTO;
import org.example.cinema_finale.service.PhimService;
import org.example.cinema_finale.service.PhongChieuService;
import org.example.cinema_finale.service.SuatChieuService;
import org.example.cinema_finale.util.DataSyncEventBus;
import org.example.cinema_finale.view.panel.staff.SuatChieuPanel;

public class SuatChieuController {

    private final SuatChieuPanel view;

    private final SuatChieuService service = new SuatChieuService();
    private final PhimService phimService = new PhimService();
    private final PhongChieuService phongService = new PhongChieuService();

    private List<PhimDTO> listPhim;
    private List<PhongChieuDTO> listPhong;

    private boolean isEditMode = false;

    public SuatChieuController(SuatChieuPanel view) {
        this.view = view;

        init();
        loadData();
        DataSyncEventBus.onPhimChanged(this::reloadPhimCombo);
        DataSyncEventBus.onPhongChieuChanged(this::reloadPhongCombo);
    }

    // ================= INIT =================
    private void init() {

        // ===== CLICK TABLE =====
        view.table.getSelectionModel().addListSelectionListener(e -> {

            int row = view.table.getSelectedRow();
            if (row >= 0) {

                SuatChieuDTO s = view.tableModel.getAt(row);

                view.txtMa.setText(String.valueOf(s.getMaSuatChieu()));
                view.txtGia.setText(String.valueOf(s.getGiaVeCoBan()));

                // set phim
                for (int i = 0; i < listPhim.size(); i++) {
                    if (listPhim.get(i).getMaPhim().equals(s.getMaPhim())) {
                        view.cboPhim.setSelectedIndex(i);
                        break;
                    }
                }

                // set phòng
                for (int i = 0; i < listPhong.size(); i++) {
                    if (listPhong.get(i).getMaPhongChieu().equals(s.getMaPhongChieu())) {
                        view.cboPhong.setSelectedIndex(i);
                        break;
                    }
                }

                // set date + time
                if (s.getNgayGioChieu() != null) {

                    LocalDateTime ldt = s.getNgayGioChieu();

                    Date date = Date.from(ldt.atZone(ZoneId.systemDefault()).toInstant());

                    view.dateChooser.setDate(date);
                    view.timeSpinner.setValue(date);
                }

                view.cboTrangThai.setSelectedItem(s.getTrangThaiSuatChieu());

                isEditMode = true;
            }
        });

        // ===== ADD =====
        view.btnAdd.addActionListener(e -> {

            if (isEditMode) {
                clearForm();
                return;
            }

            SuatChieuDTO dto = getForm();
            if (dto == null) return;

            JOptionPane.showMessageDialog(view, service.addSuatChieu(dto));
            loadTable();
            clearForm();
        });

        // ===== UPDATE =====
        view.btnUpdate.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn suất chiếu để sửa!");
                return;
            }

            SuatChieuDTO dto = getForm();
            if (dto == null) return;

            JOptionPane.showMessageDialog(view, service.updateSuatChieu(dto));
            loadTable();
        });

        // ===== DELETE =====
        view.btnDelete.addActionListener(e -> {

            if (!isEditMode) {
                JOptionPane.showMessageDialog(view, "Chọn suất chiếu để hủy!");
                return;
            }

            JOptionPane.showMessageDialog(
                    view,
                    service.deleteSuatChieu(view.txtMa.getText())
            );

            loadTable();
            clearForm();
        });

        // ===== 🔥 REALTIME SEARCH =====
        view.txtSearch.getDocument().addDocumentListener(new DocumentListener() {
            public void insertUpdate(DocumentEvent e) { search(); }
            public void removeUpdate(DocumentEvent e) { search(); }
            public void changedUpdate(DocumentEvent e) { search(); }
        });
    }

    // ================= LOAD DATA =================
    private void loadData() {
        reloadPhimCombo();
        reloadPhongCombo();

        loadTable();
    }

    private void loadTable() {
        view.tableModel.setData(service.getAllSuatChieu());
    }

    // ================= SEARCH =================
    private void search() {

        String keyword = view.txtSearch.getText().trim().toLowerCase();

        if (keyword.isEmpty()) {
            loadTable(); // 🔥 reset
            return;
        }

        view.tableModel.setData(
                service.getAllSuatChieu().stream()
                        .filter(s ->
                                s.getTenPhim().toLowerCase().contains(keyword) ||
                                        s.getTenPhongChieu().toLowerCase().contains(keyword)
                        )
                        .toList()
        );
    }

    // ================= GET FORM =================
    private SuatChieuDTO getForm() {

        try {

            Integer ma = view.txtMa.getText().isEmpty()
                    ? null
                    : Integer.parseInt(view.txtMa.getText());

            PhimDTO phim = listPhim.get(view.cboPhim.getSelectedIndex());
            PhongChieuDTO phong = listPhong.get(view.cboPhong.getSelectedIndex());

            Date date = view.dateChooser.getDate();
            Date time = (Date) view.timeSpinner.getValue();

            if (date == null || time == null) {
                JOptionPane.showMessageDialog(view, "Chọn ngày giờ!");
                return null;
            }

            LocalDate localDate = date.toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();

            LocalTime localTime = time.toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalTime();

            LocalDateTime dateTime = LocalDateTime.of(localDate, localTime);

            return new SuatChieuDTO(
                    ma,
                    phim.getMaPhim(),
                    phim.getTenPhim(),
                    phong.getMaPhongChieu(),
                    phong.getTenPhongChieu(),
                    dateTime,
                    new BigDecimal(view.txtGia.getText()),
                    view.cboTrangThai.getSelectedItem().toString()
            );

        } catch (Exception e) {
            JOptionPane.showMessageDialog(view, "Dữ liệu không hợp lệ!");
            return null;
        }
    }

    // ================= CLEAR FORM =================
    private void clearForm() {

        view.txtMa.setText("");
        view.txtGia.setText("");

        if (view.cboPhim.getItemCount() > 0) {
            view.cboPhim.setSelectedIndex(0);
        }
        if (view.cboPhong.getItemCount() > 0) {
            view.cboPhong.setSelectedIndex(0);
        }

        view.dateChooser.setDate(null);
        view.timeSpinner.setValue(new Date());

        view.cboTrangThai.setSelectedIndex(0);

        view.table.clearSelection();
        isEditMode = false;
    }

    private void reloadPhimCombo() {
        Integer selectedMaPhim = null;

        int selectedIndex = view.cboPhim.getSelectedIndex();
        if (selectedIndex >= 0 && listPhim != null && selectedIndex < listPhim.size()) {
            selectedMaPhim = listPhim.get(selectedIndex).getMaPhim();
        }

        listPhim = phimService.getAllPhim();
        view.cboPhim.removeAllItems();
        for (PhimDTO p : listPhim) {
            view.cboPhim.addItem(p.getTenPhim());
        }

        if (listPhim.isEmpty()) {
            return;
        }

        int restoredIndex = 0;
        if (selectedMaPhim != null) {
            for (int i = 0; i < listPhim.size(); i++) {
                if (selectedMaPhim.equals(listPhim.get(i).getMaPhim())) {
                    restoredIndex = i;
                    break;
                }
            }
        }

        view.cboPhim.setSelectedIndex(restoredIndex);
    }

    private void reloadPhongCombo() {
        Integer selectedMaPhong = null;

        int selectedIndex = view.cboPhong.getSelectedIndex();
        if (selectedIndex >= 0 && listPhong != null && selectedIndex < listPhong.size()) {
            selectedMaPhong = listPhong.get(selectedIndex).getMaPhongChieu();
        }

        listPhong = phongService.getAll();
        view.cboPhong.removeAllItems();
        for (PhongChieuDTO p : listPhong) {
            view.cboPhong.addItem(p.getTenPhongChieu());
        }

        if (listPhong.isEmpty()) {
            return;
        }

        int restoredIndex = 0;
        if (selectedMaPhong != null) {
            for (int i = 0; i < listPhong.size(); i++) {
                if (selectedMaPhong.equals(listPhong.get(i).getMaPhongChieu())) {
                    restoredIndex = i;
                    break;
                }
            }
        }

        view.cboPhong.setSelectedIndex(restoredIndex);
    }
}