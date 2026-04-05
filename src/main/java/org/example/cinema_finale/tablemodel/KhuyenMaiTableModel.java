package org.example.cinema_finale.tablemodel;

import java.util.List;

import javax.swing.table.AbstractTableModel;

import org.example.cinema_finale.dto.KhuyenMaiDTO;

public class KhuyenMaiTableModel extends AbstractTableModel {

    private List<KhuyenMaiDTO> list;

    private final String[] columns = {
            "Mã", "Tên", "Loại", "Kiểu", "Giá trị",
            "Bắt đầu", "Kết thúc", "ĐH tối thiểu", "Trạng thái"
    };

    public void setData(List<KhuyenMaiDTO> list) {
        this.list = list;
        fireTableDataChanged();
    }

    public KhuyenMaiDTO getAt(int row) {
        return list.get(row);
    }

    @Override
    public int getRowCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public int getColumnCount() {
        return columns.length;
    }

    @Override
    public String getColumnName(int column) {
        return columns[column];
    }

    @Override
    public Object getValueAt(int row, int col) {
        KhuyenMaiDTO k = list.get(row);

        return switch (col) {
            case 0 -> k.getMaKhuyenMai();
            case 1 -> k.getTenKhuyenMai();
            case 2 -> k.getTenLoaiKhuyenMai();
            case 3 -> k.getKieuGiaTri();
            case 4 -> k.getGiaTri();
            case 5 -> k.getNgayBatDau();
            case 6 -> k.getNgayKetThuc();
            case 7 -> k.getDonHangToiThieu();
            case 8 -> k.getTrangThai();
            default -> null;
        };
    }
}