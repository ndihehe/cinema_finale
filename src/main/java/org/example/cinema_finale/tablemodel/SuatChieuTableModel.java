package org.example.cinema_finale.tablemodel;

import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.swing.table.AbstractTableModel;

import org.example.cinema_finale.dto.SuatChieuDTO;

public class SuatChieuTableModel extends AbstractTableModel {

    private List<SuatChieuDTO> list;

    private final String[] cols = {
            "Mã", "Phim", "Phòng", "Thời gian", "Giá", "Trạng thái"
    };

    public SuatChieuTableModel(List<SuatChieuDTO> list) {
        this.list = list;
    }

    public void setData(List<SuatChieuDTO> list) {
        this.list = list;
        fireTableDataChanged();
    }

    public SuatChieuDTO getAt(int row){
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

        SuatChieuDTO s = list.get(row);

        return switch (col) {
            case 0 -> s.getMaSuatChieu();
            case 1 -> s.getTenPhim();
            case 2 -> s.getTenPhongChieu();
            case 3 -> s.getNgayGioChieu() == null ? "" :
                    s.getNgayGioChieu().format(
                            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                    );
            case 4 -> s.getGiaVeCoBan();
            case 5 -> s.getTrangThaiSuatChieu();
            default -> null;
        };
    }
}