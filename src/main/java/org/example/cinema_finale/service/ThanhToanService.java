package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.ChiTietDonHangVeDao;
import org.example.cinema_finale.dao.DonHangDao;
import org.example.cinema_finale.dao.ThanhToanDao;
import org.example.cinema_finale.dao.VeDao;
import org.example.cinema_finale.entity.ChiTietDonHangVe;
import org.example.cinema_finale.entity.DonHang;
import org.example.cinema_finale.entity.ThanhToan;
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
        Integer id = parseId(maThanhToan);
        return id == null ? null : thanhToanDao.findById(id);
    }

    public List<ThanhToan> getByMaDonHang(String maDonHang) {
        Integer id = parseId(maDonHang);
        return id == null ? List.of() : thanhToanDao.findByMaDonHang(id);
    }

    public List<ThanhToan> getByTrangThai(Object trangThaiThanhToan) {
        String status = normalizeThanhToanStatus(trangThaiThanhToan);
        if (status == null) {
            return List.of();
        }
        return thanhToanDao.findByTrangThai(status);
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
        if (donHang != null && "Chưa thanh toán".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
            donHangDao.updateTrangThai(donHang.getMaDonHang(), "Chưa thanh toán");
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

        Integer id = parseId(maThanhToan);
        if (id == null) {
            return "Mã thanh toán không hợp lệ.";
        }

        ThanhToan thanhToan = thanhToanDao.findById(id);
        if (thanhToan == null) {
            return "Thanh toán không tồn tại.";
        }

        DonHang donHang = donHangDao.findDetailById(thanhToan.getDonHang().getMaDonHang());
        if (donHang == null) {
            return "Đơn hàng của thanh toán không tồn tại.";
        }

        if ("Đã hủy".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
            return "Không thể xác nhận thanh toán cho đơn hàng đã hủy.";
        }

        if ("Thành công".equalsIgnoreCase(thanhToan.getTrangThaiThanhToan())) {
            return "Thanh toán này đã được xác nhận trước đó.";
        }

        thanhToan.setTrangThaiThanhToan("Thành công");
        if (thanhToan.getThoiGianThanhToan() == null) {
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
        }

        boolean updateThanhToan = thanhToanDao.update(thanhToan);
        if (!updateThanhToan) {
            return "Cập nhật trạng thái thanh toán thất bại.";
        }

        boolean updateDonHang = donHangDao.updateTrangThai(donHang.getMaDonHang(), "Đã thanh toán");
        if (!updateDonHang) {
            return "Cập nhật trạng thái đơn hàng thất bại.";
        }

        for (ChiTietDonHangVe chiTiet : chiTietDonHangVeDao.findByMaDonHang(donHang.getMaDonHang())) {
            if (chiTiet.getVe() != null) {
                veDao.updateTrangThai(chiTiet.getVe().getMaVe(), "Đã bán");
            }
        }

        return "Xác nhận thanh toán thành công.";
    }

    public String markThanhToanFailed(String maThanhToan) {
        AuthorizationUtil.requireLogin();

        Integer id = parseId(maThanhToan);
        if (id == null) {
            return "Mã thanh toán không hợp lệ.";
        }

        ThanhToan thanhToan = thanhToanDao.findById(id);
        if (thanhToan == null) {
            return "Thanh toán không tồn tại.";
        }

        boolean result = thanhToanDao.updateTrangThai(id, "Thất bại");
        return result ? "Đánh dấu thanh toán thất bại thành công." : "Cập nhật trạng thái thanh toán thất bại.";
    }

    public String refundThanhToan(String maThanhToan) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maThanhToan);
        if (id == null) {
            return "Mã thanh toán không hợp lệ.";
        }

        ThanhToan thanhToan = thanhToanDao.findById(id);
        if (thanhToan == null) {
            return "Thanh toán không tồn tại.";
        }

        if (!"Thành công".equalsIgnoreCase(thanhToan.getTrangThaiThanhToan())) {
            return "Chỉ thanh toán thành công mới có thể hoàn tiền.";
        }

        DonHang donHang = donHangDao.findDetailById(thanhToan.getDonHang().getMaDonHang());
        if (donHang == null) {
            return "Đơn hàng của thanh toán không tồn tại.";
        }

        boolean updateThanhToan = thanhToanDao.updateTrangThai(id, "Thất bại");
        if (!updateThanhToan) {
            return "Cập nhật trạng thái hoàn tiền thất bại.";
        }

        donHangDao.updateTrangThai(donHang.getMaDonHang(), "Đã hủy");

        for (ChiTietDonHangVe chiTiet : chiTietDonHangVeDao.findByMaDonHang(donHang.getMaDonHang())) {
            if (chiTiet.getVe() != null) {
                veDao.updateTrangThai(chiTiet.getVe().getMaVe(), "Đã hủy");
            }
        }

        return "Hoàn tiền thành công.";
    }

    private String validateThanhToan(ThanhToan thanhToan, boolean isCreate) {
        if (thanhToan == null) {
            return "Dữ liệu thanh toán không hợp lệ.";
        }

        if (!isCreate && thanhToan.getMaThanhToan() == null) {
            return "Mã thanh toán không được để trống khi cập nhật.";
        }

        if (thanhToan.getDonHang() == null || thanhToan.getDonHang().getMaDonHang() == null) {
            return "Đơn hàng của thanh toán không hợp lệ.";
        }

        if (isBlank(thanhToan.getPhuongThucThanhToan())) {
            return "Phương thức thanh toán không được để trống.";
        }

        DonHang donHang = donHangDao.findById(thanhToan.getDonHang().getMaDonHang());
        if (donHang == null) {
            return "Đơn hàng không tồn tại.";
        }

        if ("Đã hủy".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
            return "Không thể tạo thanh toán cho đơn hàng đã hủy.";
        }

        if ("Đã thanh toán".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
            return "Đơn hàng này đã thanh toán.";
        }

        thanhToan.setPhuongThucThanhToan(thanhToan.getPhuongThucThanhToan().trim());
        thanhToan.setDonHang(donHang);

        if (thanhToan.getThoiGianThanhToan() == null) {
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
        }

        if (thanhToan.getTrangThaiThanhToan() == null || thanhToan.getTrangThaiThanhToan().trim().isEmpty()) {
            thanhToan.setTrangThaiThanhToan("Thành công");
        } else {
            thanhToan.setTrangThaiThanhToan(normalizeThanhToanStatus(thanhToan.getTrangThaiThanhToan()));
        }

        if (thanhToan.getSoTien() == null || thanhToan.getSoTien().compareTo(BigDecimal.ZERO) <= 0) {
            thanhToan.setSoTien(tinhTongTienDonHang(donHang.getMaDonHang()));
        }

        if (thanhToan.getSoTien().compareTo(BigDecimal.ZERO) <= 0) {
            return "Số tiền thanh toán phải lớn hơn 0.";
        }

        if (!isCreate && thanhToanDao.findById(thanhToan.getMaThanhToan()) == null) {
            return "Thanh toán không tồn tại để cập nhật.";
        }

        return null;
    }

    private BigDecimal tinhTongTienDonHang(Integer maDonHang) {
        List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(maDonHang);
        BigDecimal tongTien = BigDecimal.ZERO;
        for (ChiTietDonHangVe ct : chiTietList) {
            if (ct.getDonGiaBan() != null) {
                tongTien = tongTien.add(ct.getDonGiaBan());
            }
        }
        return tongTien;
    }

    private Integer parseId(String value) {
        if (isBlank(value)) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String normalizeThanhToanStatus(Object raw) {
        if (raw == null) {
            return null;
        }
        String value = raw.toString().trim();
        if (value.equalsIgnoreCase("Thành công") || value.equalsIgnoreCase("THANH_CONG")) return "Thành công";
        if (value.equalsIgnoreCase("Thất bại") || value.equalsIgnoreCase("THAT_BAI")) return "Thất bại";
        if (value.equalsIgnoreCase("HOAN_TIEN")) return "Thất bại";
        return value;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
