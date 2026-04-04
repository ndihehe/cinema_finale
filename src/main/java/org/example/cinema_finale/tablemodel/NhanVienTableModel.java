package org.example.cinema_finale.tablemodel;

import java.util.List;

import javax.swing.table.AbstractTableModel;

import org.example.cinema_finale.dto.NhanVienDTO;

public class NhanVienTableModel extends AbstractTableModel {

    private List<NhanVienDTO> list;

    private final String[] columns = {
            "Mã", "Họ tên", "Ngày sinh", "Giới tính",
            "SĐT", "Email", "Địa chỉ",
            "Chức vụ", "Trạng thái"
    };

    public void setData(List<NhanVienDTO> list) {
        this.list = list;
        fireTableDataChanged();
    }

    public NhanVienDTO getAt(int row) {
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
        NhanVienDTO nv = list.get(row);

        return switch (col) {
            case 0 -> nv.getMaNhanVien();
            case 1 -> nv.getHoTen();
            case 2 -> nv.getNgaySinh();
            case 3 -> nv.getGioiTinh();
            case 4 -> nv.getSoDienThoai();
            case 5 -> nv.getEmail();
            case 6 -> nv.getDiaChi();
            case 7 -> nv.getTenChucVu();
            case 8 -> nv.getTrangThaiLamViec();
            default -> null;
        };
    }
}