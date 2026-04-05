package org.example.cinema_finale.enums;

public enum VaiTro {
    NHAN_VIEN("NhanVien"),
    KHACH_HANG("KhachHang");

    private final String dbValue;

    VaiTro(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static VaiTro fromDbValue(String dbValue) {
        if (dbValue == null) {
            return null;
        }
        for (VaiTro vaiTro : values()) {
            if (vaiTro.dbValue.equalsIgnoreCase(dbValue.trim())) {
                return vaiTro;
            }
        }
        return null;
    }
}
