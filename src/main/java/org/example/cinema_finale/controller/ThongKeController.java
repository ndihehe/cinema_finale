package org.example.cinema_finale.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

import javax.swing.JOptionPane;

import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.dto.ThongKeDoanhSoDTO;
import org.example.cinema_finale.service.PhimService;
import org.example.cinema_finale.service.ThongKeDoanhSoService;
import org.example.cinema_finale.util.DataSyncEventBus;
import org.example.cinema_finale.view.ThongKePanel;

public class ThongKeController {

    private ThongKePanel view;
    private ThongKeDoanhSoService service = new ThongKeDoanhSoService();
    private List<ThongKeDoanhSoDTO> cachedMovieStats = List.of();

    public ThongKeController(ThongKePanel view) {
        this.view = view;

        init();
        loadPhim();
        autoLoad();
        DataSyncEventBus.onPhimChanged(this::loadPhim);
    }

    private void init(){

        // ===== THEO NGÀY =====
        view.btnNgay.addActionListener(e -> {
            if(view.dateFromNgay.getDate()==null || view.dateToNgay.getDate()==null){
                JOptionPane.showMessageDialog(view,"Chọn ngày!");
                return;
            }

            update(service.thongKeTheoNgay(
                    get(view.dateFromNgay),
                    get(view.dateToNgay)
            ));
        });

        view.cboPhim.addActionListener(e -> applyMovieFilter());
    }

    private LocalDate get(com.toedter.calendar.JDateChooser d){
        return d.getDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }

    private void loadPhim(){
        List<PhimDTO> list = new PhimService().getAllPhim();
        Object selected = view.cboPhim.getSelectedItem();

        view.cboPhim.removeAllItems();

        for(PhimDTO p: list){
            view.cboPhim.addItem(p.getTenPhim());
        }

        if (selected != null) {
            view.cboPhim.setSelectedItem(selected.toString());
        }

        cachedMovieStats = service.thongKeTheoPhim(null, null);
        applyMovieFilter();
    }

    private void autoLoad(){
        update(service.thongKeTheoNgay(LocalDate.now(), LocalDate.now()));
    }

    private void update(List<ThongKeDoanhSoDTO> list){

        view.tableModel.setData(list);

        int ve = 0;
        BigDecimal doanh = BigDecimal.ZERO;
        BigDecimal giam = BigDecimal.ZERO;

        for(var t:list){
            ve += t.getSoLuongVeBan();
            doanh = doanh.add(t.getTongDoanhThu());
            giam = giam.add(t.getTongGiamGia());
        }

        view.lblVe.setText(String.valueOf(ve));
        view.lblDoanhThu.setText(String.format("%,d đ", doanh.longValue()));
        view.lblGiamGia.setText(String.format("%,d đ", giam.longValue()));
    }

    private void applyMovieFilter() {
        if (view.cboPhim.getSelectedItem() == null) {
            update(cachedMovieStats);
            return;
        }

        String phim = view.cboPhim.getSelectedItem().toString();
        List<ThongKeDoanhSoDTO> filtered = cachedMovieStats.stream()
                .filter(t -> t.getNhanThongKe().equals(phim))
                .toList();

        update(filtered);
    }
}