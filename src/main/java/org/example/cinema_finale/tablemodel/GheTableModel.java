package org.example.cinema_finale.tablemodel;

import org.example.cinema_finale.dto.GheDTO;

import javax.swing.table.AbstractTableModel;
import java.util.List;

public class GheTableModel extends AbstractTableModel {

    private List<GheDTO> list;

    private final String[] columns = {
            "Mã", "Vị trí", "Loại", "Phòng", "Trạng thái"
    };

    public void setData(List<GheDTO> list) {
        this.list = list;
        fireTableDataChanged();
    }

    public GheDTO getAt(int row){
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
    public Object getValueAt(int row, int col) {
        GheDTO g = list.get(row);

        switch (col) {
            case 0: return g.getMaGheNgoi();
            case 1: return g.getViTriGhe();
            case 2: return g.getTenLoaiGheNgoi();
            case 3: return g.getTenPhongChieu();
            case 4: return g.getTrangThaiGhe();
        }
        return null;
    }
}