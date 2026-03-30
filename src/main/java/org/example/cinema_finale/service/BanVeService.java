package org.example.cinema_finale.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.dao.ChiTietDonHangVeDao;
import org.example.cinema_finale.dao.DonHangDao;
import org.example.cinema_finale.dao.ThanhToanDao;
import org.example.cinema_finale.dao.VeDao;
import org.example.cinema_finale.entity.ChiTietDonHangVe;
import org.example.cinema_finale.entity.DonHang;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.entity.ThanhToan;
import org.example.cinema_finale.entity.Ve;
import org.example.cinema_finale.enums.TrangThaiDonHang;
import org.example.cinema_finale.enums.TrangThaiThanhToan;
import org.example.cinema_finale.enums.TrangThaiVe;
import org.example.cinema_finale.util.AuthorizationUtil;
import org.example.cinema_finale.util.JpaUtil;
import org.example.cinema_finale.util.SessionManager;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class BanVeService {

    private final DonHangDao donHangDao;
    private final ChiTietDonHangVeDao chiTietDonHangVeDao;
    private final VeDao veDao;
    private final ThanhToanDao thanhToanDao;

    public BanVeService() {
        this.donHangDao = new DonHangDao();
        this.chiTietDonHangVeDao = new ChiTietDonHangVeDao();
        this.veDao = new VeDao();
        this.thanhToanDao = new ThanhToanDao();
    }

    public BanVeService(DonHangDao donHangDao,
                        ChiTietDonHangVeDao chiTietDonHangVeDao,
                        VeDao veDao,
                        ThanhToanDao thanhToanDao) {
        this.donHangDao = donHangDao;
        this.chiTietDonHangVeDao = chiTietDonHangVeDao;
        this.veDao = veDao;
        this.thanhToanDao = thanhToanDao;
    }

    /**
     * Flow checkout an toàn:
     * 1. Tạo đơn hàng
     * 2. Lock từng vé
     * 3. Gắn vé vào đơn
     * 4. Tính tổng tiền
     * 5. Tạo thanh toán
     * 6. Xác nhận thanh toán
     * 7. Đổi tất cả vé sang DA_BAN
     *
     * Toàn bộ chạy trong 1 transaction chung.
     */
    public String muaVeNhanhAnToan(String maDonHang,
                                   List<String> dsMaVe,
                                   String maThanhToan,
                                   String phuongThucThanhToan,
                                   String maKhuyenMai,
                                   String ghiChu,
                                   String maGiaoDich) {
        AuthorizationUtil.requireLogin();

        if (isBlank(maDonHang)) {
            return "Mã đơn hàng không được để trống.";
        }

        if (dsMaVe == null || dsMaVe.isEmpty()) {
            return "Danh sách vé không được để trống.";
        }

        if (isBlank(maThanhToan)) {
            return "Mã thanh toán không được để trống.";
        }

        if (isBlank(phuongThucThanhToan)) {
            return "Phương thức thanh toán không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            if (donHangDao.findById(em, maDonHang.trim()) != null) {
                return "Mã đơn hàng đã tồn tại.";
            }

            if (thanhToanDao.findById(em, maThanhToan.trim()) != null) {
                return "Mã thanh toán đã tồn tại.";
            }

            TaiKhoan taiKhoan = SessionManager.getCurrentTaiKhoan();
            if (taiKhoan == null) {
                return "Không xác định được tài khoản hiện tại.";
            }

            DonHang donHang = new DonHang();
            donHang.setMaDonHang(maDonHang.trim());
            donHang.setMaKhuyenMai(trimToNull(maKhuyenMai));
            donHang.setGhiChu(trimToNull(ghiChu));
            donHang.setThoiGianTao(LocalDateTime.now());
            donHang.setTongTienTruocGiam(BigDecimal.ZERO);
            donHang.setTienGiam(BigDecimal.ZERO);
            donHang.setTongTienSauGiam(BigDecimal.ZERO);
            donHang.setTrangThaiDonHang(TrangThaiDonHang.CHO_THANH_TOAN);

            if (taiKhoan.isCustomer()) {
                donHang.setKhachHang(taiKhoan.getKhachHang());
            }

            if (taiKhoan.isStaff()) {
                donHang.setNhanVien(taiKhoan.getNhanVien());
            }

            if (donHang.getKhachHang() == null && donHang.getNhanVien() == null) {
                return "Đơn hàng phải gắn ít nhất với khách hàng hoặc nhân viên.";
            }

            donHangDao.save(em, donHang);

            BigDecimal tongTien = BigDecimal.ZERO;

            for (String maVe : dsMaVe) {
                if (isBlank(maVe)) {
                    return "Danh sách vé có mã vé không hợp lệ.";
                }

                Ve ve = veDao.findByIdForUpdate(em, maVe.trim());
                if (ve == null) {
                    return "Vé " + maVe + " không tồn tại.";
                }

                if (ve.getTrangThaiVe() != TrangThaiVe.CHUA_BAN) {
                    return "Vé " + maVe + " không còn ở trạng thái chưa bán.";
                }

                if (chiTietDonHangVeDao.findByMaVe(em, maVe.trim()) != null) {
                    return "Vé " + maVe + " đã thuộc một đơn hàng khác.";
                }

                ChiTietDonHangVe chiTiet = new ChiTietDonHangVe();
                chiTiet.setMaChiTietVe(generateChiTietVeId());
                chiTiet.setDonHang(donHang);
                chiTiet.setVe(ve);
                chiTiet.setDonGiaBan(ve.getGiaVe());

                chiTietDonHangVeDao.save(em, chiTiet);

                if (ve.getGiaVe() != null) {
                    tongTien = tongTien.add(ve.getGiaVe());
                }
            }

            donHang.setTongTienTruocGiam(tongTien);
            donHang.setTienGiam(BigDecimal.ZERO);
            donHang.setTongTienSauGiam(tongTien);
            donHangDao.update(em, donHang);

            ThanhToan thanhToan = new ThanhToan();
            thanhToan.setMaThanhToan(maThanhToan.trim());
            thanhToan.setDonHang(donHang);
            thanhToan.setSoTien(donHang.getTongTienSauGiam());
            thanhToan.setPhuongThucThanhToan(phuongThucThanhToan.trim());
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
            thanhToan.setTrangThaiThanhToan(TrangThaiThanhToan.THANH_CONG);
            thanhToan.setMaGiaoDich(trimToNull(maGiaoDich));

            if (taiKhoan.isStaff()) {
                thanhToan.setNhanVien(taiKhoan.getNhanVien());
            }

            thanhToanDao.save(em, thanhToan);

            donHang.setTrangThaiDonHang(TrangThaiDonHang.DA_THANH_TOAN);
            donHangDao.update(em, donHang);

            for (String maVe : dsMaVe) {
                Ve ve = veDao.findByIdForUpdate(em, maVe.trim());
                if (ve == null) {
                    return "Vé " + maVe + " không tồn tại khi chốt thanh toán.";
                }

                if (ve.getTrangThaiVe() != TrangThaiVe.CHUA_BAN) {
                    return "Vé " + maVe + " đã bị thay đổi trạng thái trong lúc thanh toán.";
                }

                ve.setTrangThaiVe(TrangThaiVe.DA_BAN);
                veDao.update(em, ve);
            }

            tx.commit();
            return "Bán vé thành công.";
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return "Bán vé thất bại do lỗi giao dịch.";
        } finally {
            em.close();
        }
    }

    /**
     * Xác nhận thanh toán an toàn cho đơn đã tạo trước đó.
     * Chỉ khi bước này thành công thì vé mới chuyển sang DA_BAN.
     */
    public String xacNhanThanhToanAnToan(String maThanhToan) {
        AuthorizationUtil.requireLogin();

        if (isBlank(maThanhToan)) {
            return "Mã thanh toán không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            ThanhToan thanhToan = thanhToanDao.findById(em, maThanhToan.trim());
            if (thanhToan == null) {
                return "Thanh toán không tồn tại.";
            }

            DonHang donHang = donHangDao.findDetailById(em, thanhToan.getDonHang().getMaDonHang());
            if (donHang == null) {
                return "Đơn hàng của thanh toán không tồn tại.";
            }

            if (donHang.getTrangThaiDonHang() == TrangThaiDonHang.DA_HUY) {
                return "Không thể xác nhận thanh toán cho đơn hàng đã hủy.";
            }

            if (thanhToan.getTrangThaiThanhToan() == TrangThaiThanhToan.THANH_CONG) {
                return "Thanh toán này đã được xác nhận trước đó.";
            }

            List<ChiTietDonHangVe> chiTietVes = chiTietDonHangVeDao.findByMaDonHang(em, donHang.getMaDonHang());
            if (chiTietVes.isEmpty()) {
                return "Đơn hàng không có vé để xác nhận.";
            }

            for (ChiTietDonHangVe ct : chiTietVes) {
                if (ct.getVe() == null) {
                    return "Chi tiết đơn hàng có vé không hợp lệ.";
                }

                Ve ve = veDao.findByIdForUpdate(em, ct.getVe().getMaVe());
                if (ve == null) {
                    return "Vé " + ct.getVe().getMaVe() + " không tồn tại.";
                }

                if (ve.getTrangThaiVe() != TrangThaiVe.CHUA_BAN) {
                    return "Vé " + ve.getMaVe() + " không còn ở trạng thái chưa bán.";
                }
            }

            thanhToan.setTrangThaiThanhToan(TrangThaiThanhToan.THANH_CONG);
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
            thanhToanDao.update(em, thanhToan);

            donHang.setTrangThaiDonHang(TrangThaiDonHang.DA_THANH_TOAN);
            donHangDao.update(em, donHang);

            for (ChiTietDonHangVe ct : chiTietVes) {
                Ve ve = veDao.findByIdForUpdate(em, ct.getVe().getMaVe());
                ve.setTrangThaiVe(TrangThaiVe.DA_BAN);
                veDao.update(em, ve);
            }

            tx.commit();
            return "Xác nhận thanh toán thành công.";
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return "Xác nhận thanh toán thất bại do lỗi giao dịch.";
        } finally {
            em.close();
        }
    }

    private String generateChiTietVeId() {
        return "CTV" + System.currentTimeMillis() + Math.abs((int) (Math.random() * 1000));
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