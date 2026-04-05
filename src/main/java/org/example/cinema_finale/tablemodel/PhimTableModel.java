package org.example.cinema_finale.tablemodel;

import java.util.List;

import javax.swing.table.AbstractTableModel;

import org.example.cinema_finale.dto.PhimDTO;

public class PhimTableModel extends AbstractTableModel {

    private List<PhimDTO> list;

    private final String[] columns = {
            "Mã", "Tên", "Thể loại", "Đạo diễn",
            "Thời lượng", "Giới hạn tuổi",
            "Định dạng", "Ngày chiếu", "Trạng thái"
    };

    public PhimTableModel(List<PhimDTO> list) {
        this.list = list;
    }

    public void setData(List<PhimDTO> list) {
        this.list = list;
        fireTableDataChanged();
    }

    public PhimDTO getAt(int row) {
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
        PhimDTO p = list.get(row);

        return switch (col) {
            case 0 -> p.getMaPhim();
            case 1 -> p.getTenPhim();
            case 2 -> p.getTheLoai();
            case 3 -> p.getDaoDien();
            case 4 -> p.getThoiLuong();
            case 5 -> p.getGioiHanTuoi();
            case 6 -> p.getDinhDang();
            case 7 -> p.getNgayKhoiChieu();
            case 8 -> p.getTrangThaiPhim();
            default -> null;
        };
    }
}