package org.example.cinema_finale.tablemodel;

import java.util.List;

import javax.swing.table.AbstractTableModel;

import org.example.cinema_finale.dto.PhongChieuDTO;

public class PhongChieuTableModel extends AbstractTableModel {

    private List<PhongChieuDTO> list;

    private final String[] cols = {
            "Mã", "Tên phòng", "Màn hình", "Âm thanh", "Trạng thái"
    };

    public void setData(List<PhongChieuDTO> list) {
        this.list = list;
        fireTableDataChanged();
    }

    public PhongChieuDTO getAt(int row){
        return list.get(row);
    }

    @Override
    public int getRowCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public int getColumnCount() {
        return cols.length;
    }

    @Override
    public String getColumnName(int column) {
        return cols[column];
    }

    @Override
    public Object getValueAt(int row, int col) {
        PhongChieuDTO p = list.get(row);

        return switch (col) {
            case 0 -> p.getMaPhongChieu();
            case 1 -> p.getTenPhongChieu();
            case 2 -> p.getLoaiManHinh();
            case 3 -> p.getHeThongAmThanh();
            case 4 -> p.getTrangThaiPhong();
            default -> null;
        };
    }
}