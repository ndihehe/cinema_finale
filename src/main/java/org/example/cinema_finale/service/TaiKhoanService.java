package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.TaiKhoanDao;
import org.example.cinema_finale.entity.KhachHang;
import org.example.cinema_finale.entity.NhanVien;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.entity.VaiTro;

import java.util.List;

public class TaiKhoanService {

    private final TaiKhoanDao taiKhoanDao;

    /**
     * Khởi tạo service với TaiKhoanDao mặc định.
     */
    public TaiKhoanService() {
        this.taiKhoanDao = new TaiKhoanDao();
    }

    /**
     * Khởi tạo service với TaiKhoanDao truyền vào.
     *
     * @param taiKhoanDao đối tượng TaiKhoanDao
     */
    public TaiKhoanService(TaiKhoanDao taiKhoanDao) {
        this.taiKhoanDao = taiKhoanDao;
    }

    /**
     * Lấy toàn bộ danh sách tài khoản.
     *
     * @return danh sách tài khoản
     */
    public List<TaiKhoan> getAllTaiKhoan() {
        return taiKhoanDao.findAll();
    }

    /**
     * Tìm tài khoản theo mã tài khoản.
     *
     * @param maTk mã tài khoản
     * @return tài khoản nếu tìm thấy, ngược lại trả về null
     */
    public TaiKhoan getTaiKhoanById(String maTk) {
        if (maTk == null || maTk.trim().isEmpty()) {
            return null;
        }
        return taiKhoanDao.findById(maTk.trim());
    }

    /**
     * Tìm tài khoản theo tên đăng nhập.
     *
     * @param tenDangNhap tên đăng nhập
     * @return tài khoản nếu tìm thấy, ngược lại trả về null
     */
    public TaiKhoan getTaiKhoanByUsername(String tenDangNhap) {
        if (tenDangNhap == null || tenDangNhap.trim().isEmpty()) {
            return null;
        }
        return taiKhoanDao.findByUsername(tenDangNhap.trim());
    }

    /**
     * Thêm mới tài khoản sau khi kiểm tra dữ liệu hợp lệ.
     *
     * @param taiKhoan đối tượng tài khoản cần thêm
     * @return thông báo kết quả xử lý
     */
    public String addTaiKhoan(TaiKhoan taiKhoan) {
        String validationMessage = validateTaiKhoan(taiKhoan, true);
        if (validationMessage != null) {
            return validationMessage;
        }

        boolean result = taiKhoanDao.save(taiKhoan);
        return result ? "Thêm tài khoản thành công." : "Thêm tài khoản thất bại.";
    }

    /**
     * Cập nhật tài khoản sau khi kiểm tra dữ liệu hợp lệ.
     *
     * @param taiKhoan đối tượng tài khoản cần cập nhật
     * @return thông báo kết quả xử lý
     */
    public String updateTaiKhoan(TaiKhoan taiKhoan) {
        String validationMessage = validateTaiKhoan(taiKhoan, false);
        if (validationMessage != null) {
            return validationMessage;
        }

        boolean result = taiKhoanDao.update(taiKhoan);
        return result ? "Cập nhật tài khoản thành công." : "Cập nhật tài khoản thất bại.";
    }

    /**
     * Xóa tài khoản theo mã tài khoản.
     *
     * @param maTk mã tài khoản cần xóa
     * @return thông báo kết quả xử lý
     */
    public String deleteTaiKhoan(String maTk) {
        if (maTk == null || maTk.trim().isEmpty()) {
            return "Mã tài khoản không được để trống.";
        }

        TaiKhoan taiKhoan = taiKhoanDao.findById(maTk.trim());
        if (taiKhoan == null) {
            return "Tài khoản không tồn tại.";
        }

        boolean result = taiKhoanDao.delete(maTk.trim());
        return result ? "Xóa tài khoản thành công." : "Xóa tài khoản thất bại.";
    }

    /**
     * Kiểm tra đăng nhập theo tên đăng nhập và mật khẩu.
     *
     * @param tenDangNhap tên đăng nhập
     * @param matKhau mật khẩu
     * @return tài khoản nếu đăng nhập thành công, ngược lại trả về null
     */
    public TaiKhoan login(String tenDangNhap, String matKhau) {
        if (tenDangNhap == null || tenDangNhap.trim().isEmpty()) {
            return null;
        }

        if (matKhau == null || matKhau.trim().isEmpty()) {
            return null;
        }

        TaiKhoan taiKhoan = taiKhoanDao.findByUsername(tenDangNhap.trim());
        if (taiKhoan == null) {
            return null;
        }

        if (Boolean.FALSE.equals(taiKhoan.getTrangThai())) {
            return null;
        }

        if (!taiKhoan.getMatKhau().equals(matKhau)) {
            return null;
        }

        return taiKhoan;
    }

    /**
     * Kiểm tra tài khoản có vai trò STAFF hay không.
     *
     * @param taiKhoan tài khoản cần kiểm tra
     * @return true nếu là STAFF, false nếu không phải
     */
    public boolean isStaff(TaiKhoan taiKhoan) {
        return taiKhoan != null && taiKhoan.getVaiTro() == VaiTro.STAFF;
    }

    /**
     * Kiểm tra tài khoản có vai trò USER hay không.
     *
     * @param taiKhoan tài khoản cần kiểm tra
     * @return true nếu là USER, false nếu không phải
     */
    public boolean isUser(TaiKhoan taiKhoan) {
        return taiKhoan != null && taiKhoan.getVaiTro() == VaiTro.USER;
    }

    /**
     * Kiểm tra dữ liệu tài khoản có hợp lệ hay không.
     *
     * @param taiKhoan đối tượng tài khoản cần kiểm tra
     * @param isCreate true nếu là thêm mới, false nếu là cập nhật
     * @return null nếu hợp lệ, ngược lại trả về thông báo lỗi
     */
    private String validateTaiKhoan(TaiKhoan taiKhoan, boolean isCreate) {
        if (taiKhoan == null) {
            return "Dữ liệu tài khoản không hợp lệ.";
        }

        if (taiKhoan.getMaTk() == null || taiKhoan.getMaTk().trim().isEmpty()) {
            return "Mã tài khoản không được để trống.";
        }

        if (taiKhoan.getTenDangNhap() == null || taiKhoan.getTenDangNhap().trim().isEmpty()) {
            return "Tên đăng nhập không được để trống.";
        }

        if (taiKhoan.getMatKhau() == null || taiKhoan.getMatKhau().trim().isEmpty()) {
            return "Mật khẩu không được để trống.";
        }

        if (taiKhoan.getVaiTro() == null) {
            return "Vai trò tài khoản không được để trống.";
        }

        if (taiKhoan.getTrangThai() == null) {
            return "Trạng thái tài khoản không được để trống.";
        }

        if (taiKhoan.getVaiTro() == VaiTro.STAFF) {
            NhanVien nhanVien = taiKhoan.getNhanVien();
            KhachHang khachHang = taiKhoan.getKhachHang();

            if (nhanVien == null) {
                return "Tài khoản STAFF phải gắn với nhân viên.";
            }

            if (khachHang != null) {
                return "Tài khoản STAFF không được gắn với khách hàng.";
            }
        }

        if (taiKhoan.getVaiTro() == VaiTro.USER) {
            KhachHang khachHang = taiKhoan.getKhachHang();
            NhanVien nhanVien = taiKhoan.getNhanVien();

            if (khachHang == null) {
                return "Tài khoản USER phải gắn với khách hàng.";
            }

            if (nhanVien != null) {
                return "Tài khoản USER không được gắn với nhân viên.";
            }
        }

        taiKhoan.setMaTk(taiKhoan.getMaTk().trim());
        taiKhoan.setTenDangNhap(taiKhoan.getTenDangNhap().trim());
        taiKhoan.setMatKhau(taiKhoan.getMatKhau().trim());

        if (isCreate) {
            if (taiKhoanDao.existsById(taiKhoan.getMaTk())) {
                return "Mã tài khoản đã tồn tại.";
            }

            if (taiKhoanDao.existsByUsername(taiKhoan.getTenDangNhap())) {
                return "Tên đăng nhập đã tồn tại.";
            }
        } else {
            TaiKhoan existing = taiKhoanDao.findById(taiKhoan.getMaTk());
            if (existing == null) {
                return "Tài khoản không tồn tại để cập nhật.";
            }

            TaiKhoan byUsername = taiKhoanDao.findByUsername(taiKhoan.getTenDangNhap());
            if (byUsername != null && !byUsername.getMaTk().equals(taiKhoan.getMaTk())) {
                return "Tên đăng nhập đã tồn tại.";
            }
        }

        return null;
    }
}