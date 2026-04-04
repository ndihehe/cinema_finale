package org.example.cinema_finale.tablemodel;

import java.util.List;

import javax.swing.table.AbstractTableModel;

import org.example.cinema_finale.dto.KhachHangDTO;

public class KhachHangTableModel extends AbstractTableModel {

    private List<KhachHangDTO> list;

    private final String[] cols = {
            "Mã", "Họ tên", "SĐT", "Email",
            "Giới tính", "Ngày sinh", "Điểm", "Hạng"
    };

    public void setData(List<KhachHangDTO> list){
        this.list = list;
        fireTableDataChanged();
    }

    public KhachHangDTO getAt(int row){
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

        KhachHangDTO k = list.get(row);

        return switch (col){
            case 0 -> k.getMaKhachHang();
            case 1 -> k.getHoTen();
            case 2 -> k.getSoDienThoai();
            case 3 -> k.getEmail();
            case 4 -> k.getGioiTinh();
            case 5 -> k.getNgaySinh();
            case 6 -> k.getDiemTichLuy();
            case 7 -> k.getHangThanhVien();
            default -> null;
        };
    }
}