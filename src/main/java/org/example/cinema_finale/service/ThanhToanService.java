package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.ChiTietDonHangVeDao;
import org.example.cinema_finale.dao.DonHangDao;
import org.example.cinema_finale.dao.ThanhToanDao;
import org.example.cinema_finale.dao.VeDao;
import org.example.cinema_finale.entity.ChiTietDonHangVe;
import org.example.cinema_finale.entity.DonHang;
import org.example.cinema_finale.entity.ThanhToan;
import org.example.cinema_finale.enums.TrangThaiDonHang;
import org.example.cinema_finale.enums.TrangThaiThanhToan;
import org.example.cinema_finale.enums.TrangThaiVe;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class ThanhToanService {

    private final ThanhToanDao thanhToanDao;
    private final DonHangDao donHangDao;
    private final ChiTietDonHangVeDao chiTietDonHangVeDao;
    private final VeDao veDao;

    public ThanhToanService() {
        this.thanhToanDao = new ThanhToanDao();
        this.donHangDao = new DonHangDao();
        this.chiTietDonHangVeDao = new ChiTietDonHangVeDao();
        this.veDao = new VeDao();
    }

    public ThanhToanService(ThanhToanDao thanhToanDao,
                            DonHangDao donHangDao,
                            ChiTietDonHangVeDao chiTietDonHangVeDao,
                            VeDao veDao) {
        this.thanhToanDao = thanhToanDao;
        this.donHangDao = donHangDao;
        this.chiTietDonHangVeDao = chiTietDonHangVeDao;
        this.veDao = veDao;
    }

    public List<ThanhToan> getAllThanhToan() {
        return thanhToanDao.findAll();
    }

    public ThanhToan getThanhToanById(String maThanhToan) {
        if (isBlank(maThanhToan)) {
            return null;
        }
        return thanhToanDao.findById(maThanhToan.trim());
    }

    public List<ThanhToan> getByMaDonHang(String maDonHang) {
        if (isBlank(maDonHang)) {
            return List.of();
        }
        return thanhToanDao.findByMaDonHang(maDonHang.trim());
    }

    public List<ThanhToan> getByTrangThai(TrangThaiThanhToan trangThaiThanhToan) {
        if (trangThaiThanhToan == null) {
            return List.of();
        }
        return thanhToanDao.findByTrangThai(trangThaiThanhToan);
    }

    public String addThanhToan(ThanhToan thanhToan) {
        AuthorizationUtil.requireLogin();

        String validation = validateThanhToan(thanhToan, true);
        if (validation != null) {
            return validation;
        }

        boolean result = thanhToanDao.save(thanhToan);
        if (!result) {
            return "Tạo thanh toán thất bại.";
        }

        DonHang donHang = donHangDao.findById(thanhToan.getDonHang().getMaDonHang());
        if (donHang != null && donHang.getTrangThaiDonHang() == TrangThaiDonHang.KHOI_TAO) {
            donHangDao.updateTrangThai(donHang.getMaDonHang(), TrangThaiDonHang.CHO_THANH_TOAN);
        }

        return "Tạo thanh toán thành công.";
    }

    public String updateThanhToan(ThanhToan thanhToan) {
        AuthorizationUtil.requireLogin();

        String validation = validateThanhToan(thanhToan, false);
        if (validation != null) {
            return validation;
        }

        boolean result = thanhToanDao.update(thanhToan);
        return result ? "Cập nhật thanh toán thành công." : "Cập nhật thanh toán thất bại.";
    }

    public String confirmThanhToan(String maThanhToan) {
        AuthorizationUtil.requireLogin();

        if (isBlank(maThanhToan)) {
            return "Mã thanh toán không được để trống.";
        }

        ThanhToan thanhToan = thanhToanDao.findById(maThanhToan.trim());
        if (thanhToan == null) {
            return "Thanh toán không tồn tại.";
        }

        DonHang donHang = donHangDao.findDetailById(thanhToan.getDonHang().getMaDonHang());
        if (donHang == null) {
            return "Đơn hàng của thanh toán không tồn tại.";
        }

        if (donHang.getTrangThaiDonHang() == TrangThaiDonHang.DA_HUY) {
            return "Không thể xác nhận thanh toán cho đơn hàng đã hủy.";
        }

        if (thanhToan.getTrangThaiThanhToan() == TrangThaiThanhToan.THANH_CONG) {
            return "Thanh toán này đã được xác nhận trước đó.";
        }

        thanhToan.setTrangThaiThanhToan(TrangThaiThanhToan.THANH_CONG);
        if (thanhToan.getThoiGianThanhToan() == null) {
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
        }

        boolean updateThanhToan = thanhToanDao.update(thanhToan);
        if (!updateThanhToan) {
            return "Cập nhật trạng thái thanh toán thất bại.";
        }

        boolean updateDonHang = donHangDao.updateTrangThai(donHang.getMaDonHang(), TrangThaiDonHang.DA_THANH_TOAN);
        if (!updateDonHang) {
            return "Cập nhật trạng thái đơn hàng thất bại.";
        }

        for (ChiTietDonHangVe chiTiet : chiTietDonHangVeDao.findByMaDonHang(donHang.getMaDonHang())) {
            if (chiTiet.getVe() != null) {
                veDao.updateTrangThai(chiTiet.getVe().getMaVe(), TrangThaiVe.DA_BAN);
            }
        }

        return "Xác nhận thanh toán thành công.";
    }

    public String markThanhToanFailed(String maThanhToan) {
        AuthorizationUtil.requireLogin();

        if (isBlank(maThanhToan)) {
            return "Mã thanh toán không được để trống.";
        }

        ThanhToan thanhToan = thanhToanDao.findById(maThanhToan.trim());
        if (thanhToan == null) {
            return "Thanh toán không tồn tại.";
        }

        boolean result = thanhToanDao.updateTrangThai(maThanhToan.trim(), TrangThaiThanhToan.THAT_BAI);
        return result ? "Đánh dấu thanh toán thất bại thành công."
                : "Cập nhật trạng thái thanh toán thất bại.";
    }

    public String refundThanhToan(String maThanhToan) {
        AuthorizationUtil.requireStaff();

        if (isBlank(maThanhToan)) {
            return "Mã thanh toán không được để trống.";
        }

        ThanhToan thanhToan = thanhToanDao.findById(maThanhToan.trim());
        if (thanhToan == null) {
            return "Thanh toán không tồn tại.";
        }

        if (thanhToan.getTrangThaiThanhToan() != TrangThaiThanhToan.THANH_CONG) {
            return "Chỉ thanh toán thành công mới có thể hoàn tiền.";
        }

        DonHang donHang = donHangDao.findDetailById(thanhToan.getDonHang().getMaDonHang());
        if (donHang == null) {
            return "Đơn hàng của thanh toán không tồn tại.";
        }

        boolean updateThanhToan = thanhToanDao.updateTrangThai(maThanhToan.trim(), TrangThaiThanhToan.HOAN_TIEN);
        if (!updateThanhToan) {
            return "Cập nhật trạng thái hoàn tiền thất bại.";
        }

        donHangDao.updateTrangThai(donHang.getMaDonHang(), TrangThaiDonHang.DA_HUY);

        for (ChiTietDonHangVe chiTiet : chiTietDonHangVeDao.findByMaDonHang(donHang.getMaDonHang())) {
            if (chiTiet.getVe() != null) {
                veDao.updateTrangThai(chiTiet.getVe().getMaVe(), TrangThaiVe.DA_HUY);
            }
        }

        return "Hoàn tiền thành công.";
    }

    private String validateThanhToan(ThanhToan thanhToan, boolean isCreate) {
        if (thanhToan == null) {
            return "Dữ liệu thanh toán không hợp lệ.";
        }

        if (isBlank(thanhToan.getMaThanhToan())) {
            return "Mã thanh toán không được để trống.";
        }

        if (thanhToan.getDonHang() == null || isBlank(thanhToan.getDonHang().getMaDonHang())) {
            return "Đơn hàng của thanh toán không hợp lệ.";
        }

        if (isBlank(thanhToan.getPhuongThucThanhToan())) {
            return "Phương thức thanh toán không được để trống.";
        }

        if (thanhToan.getTrangThaiThanhToan() == null) {
            thanhToan.setTrangThaiThanhToan(TrangThaiThanhToan.CHO_THANH_TOAN);
        }

        DonHang donHang = donHangDao.findById(thanhToan.getDonHang().getMaDonHang().trim());
        if (donHang == null) {
            return "Đơn hàng không tồn tại.";
        }

        if (donHang.getTrangThaiDonHang() == TrangThaiDonHang.DA_HUY) {
            return "Không thể tạo thanh toán cho đơn hàng đã hủy.";
        }

        if (donHang.getTrangThaiDonHang() == TrangThaiDonHang.DA_THANH_TOAN) {
            return "Đơn hàng này đã thanh toán.";
        }

        thanhToan.setMaThanhToan(thanhToan.getMaThanhToan().trim());
        thanhToan.setPhuongThucThanhToan(thanhToan.getPhuongThucThanhToan().trim());
        thanhToan.setMaGiaoDich(trimToNull(thanhToan.getMaGiaoDich()));
        thanhToan.setDonHang(donHang);

        if (thanhToan.getSoTien() == null || thanhToan.getSoTien().compareTo(BigDecimal.ZERO) <= 0) {
            BigDecimal tongTienDonHang = donHang.getTongTienSauGiam() == null
                    ? BigDecimal.ZERO
                    : donHang.getTongTienSauGiam();
            thanhToan.setSoTien(tongTienDonHang);
        }

        if (thanhToan.getSoTien().compareTo(BigDecimal.ZERO) <= 0) {
            return "Số tiền thanh toán phải lớn hơn 0.";
        }

        if (isCreate && thanhToanDao.existsById(thanhToan.getMaThanhToan())) {
            return "Mã thanh toán đã tồn tại.";
        }

        if (!isCreate && thanhToanDao.findById(thanhToan.getMaThanhToan()) == null) {
            return "Thanh toán không tồn tại để cập nhật.";
        }

        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}