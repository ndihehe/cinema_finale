package org.example.cinema_finale.tablemodel;

import org.example.cinema_finale.dto.ThongKeDoanhSoDTO;

import javax.swing.table.AbstractTableModel;
import java.util.List;

public class ThongKeTableModel extends AbstractTableModel {

    private List<ThongKeDoanhSoDTO> list;

    private final String[] cols = {
            "Nhãn", "Số vé", "Tổng doanh thu", "Giảm giá", "Doanh thu thuần"
    };

    public void setData(List<ThongKeDoanhSoDTO> list) {
        this.list = list;
        fireTableDataChanged();
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
    public Object getValueAt(int row, int col) {
        ThongKeDoanhSoDTO t = list.get(row);

        return switch (col) {
            case 0 -> t.getNhanThongKe();
            case 1 -> t.getSoLuongVeBan();
            case 2 -> String.format("%,d đ", t.getTongDoanhThu().longValue());
            case 3 -> String.format("%,d đ", t.getTongGiamGia().longValue());
            case 4 -> String.format("%,d đ", t.getDoanhThuThuan().longValue());
            default -> null;
        };
    }

    @Override
    public String getColumnName(int col) {
        return cols[col];
    }
}