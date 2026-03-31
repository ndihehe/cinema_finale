package org.example.cinema_finale.TableModel;

import org.example.cinema_finale.entity.GheNgoi;

import javax.swing.table.AbstractTableModel;
import java.util.List;

public class GheTableModel extends AbstractTableModel {

    private List<GheNgoi> list;

    private final String[] columns = {
            "Mã", "Tên", "Loại", "Phòng", "Trạng thái"
    };

    public void setData(List<GheNgoi> list) {
        this.list = list;
        fireTableDataChanged();
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
    public String getColumnName(int col) {
        return columns[col];
    }

    @Override
    public Object getValueAt(int row, int col) {
        GheNgoi g = list.get(row);

        switch (col) {
            case 0: return g.getMaGheNgoi();

            case 1:
                return (g.getHangGhe() != null ? g.getHangGhe() : "") +
                        (g.getSoGhe() != null ? g.getSoGhe() : "");

            case 2:
                return g.getLoaiGheNgoi() != null
                        ? g.getLoaiGheNgoi().getTenLoaiGheNgoi()
                        : "";

            case 3:
                return g.getPhongChieu() != null
                        ? g.getPhongChieu().toString()
                        : "";

            case 4:
                return g.getTrangThaiGhe() != null
                        ? g.getTrangThaiGhe()
                        : "";
        }
        return null;
    }

    public GheNgoi getAt(int row){
        return list.get(row);
    }
}