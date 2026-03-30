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
import java.util.ArrayList;
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

    public BanVeService(
            DonHangDao donHangDao,
            ChiTietDonHangVeDao chiTietDonHangVeDao,
            VeDao veDao,
            ThanhToanDao thanhToanDao
    ) {
        this.donHangDao = donHangDao;
        this.chiTietDonHangVeDao = chiTietDonHangVeDao;
        this.veDao = veDao;
        this.thanhToanDao = thanhToanDao;
    }

    /**
     * =========================================
     * PHẦN MỚI: API thân thiện cho UI
     * =========================================
     */

    /**
     * Lấy tất cả vé của 1 suất chiếu.
     * Cần VeDao có method: findByMaSuatChieu(String maSuatChieu)
     */
    public List<Ve> getVeBySuatChieu(String maSuatChieu) {
        if (isBlank(maSuatChieu)) {
            return List.of();
        }
        return veDao.findByMaSuatChieu(maSuatChieu.trim());
    }

    /**
     * Lấy danh sách vé còn trống của 1 suất chiếu.
     * Cần VeDao có method: findByMaSuatChieuAndTrangThai(String maSuatChieu, TrangThaiVe trangThaiVe)
     */
    public List<Ve> getVeTrongBySuatChieu(String maSuatChieu) {
        if (isBlank(maSuatChieu)) {
            return List.of();
        }
        return veDao.findByMaSuatChieuAndTrangThai(maSuatChieu.trim(), TrangThaiVe.CHUA_BAN);
    }

    /**
     * Tạo đơn hàng tạm, chưa thanh toán.
     */
    public String taoDonHangTam(String maDonHang, String maKhuyenMai, String ghiChu) {
        AuthorizationUtil.requireLogin();

        if (isBlank(maDonHang)) {
            return "Mã đơn hàng không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            if (donHangDao.findById(em, maDonHang.trim()) != null) {
                return "Mã đơn hàng đã tồn tại.";
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
            tx.commit();
            return "Tạo đơn hàng tạm thành công.";
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return "Tạo đơn hàng tạm thất bại.";
        } finally {
            em.close();
        }
    }

    /**
     * Lấy đơn hàng theo mã.
     */
    public DonHang getDonHangById(String maDonHang) {
        if (isBlank(maDonHang)) {
            return null;
        }
        return donHangDao.findById(maDonHang.trim());
    }

    /**
     * Thêm 1 vé vào đơn hàng tạm.
     * Cần ChiTietDonHangVeDao có method:
     * - findByMaVe(String maVe)
     * - save(ChiTietDonHangVe chiTiet)
     */
    public String themVeVaoDonHang(String maDonHang, String maVe) {
        AuthorizationUtil.requireLogin();

        if (isBlank(maDonHang)) {
            return "Mã đơn hàng không được để trống.";
        }
        if (isBlank(maVe)) {
            return "Mã vé không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findById(em, maDonHang.trim());
            if (donHang == null) {
                return "Đơn hàng không tồn tại.";
            }

            if (donHang.getTrangThaiDonHang() != TrangThaiDonHang.CHO_THANH_TOAN) {
                return "Chỉ được thêm vé vào đơn hàng chưa thanh toán.";
            }

            Ve ve = veDao.findByIdForUpdate(em, maVe.trim());
            if (ve == null) {
                return "Vé không tồn tại.";
            }

            if (ve.getTrangThaiVe() != TrangThaiVe.CHUA_BAN) {
                return "Vé không còn ở trạng thái chưa bán.";
            }

            ChiTietDonHangVe existed = chiTietDonHangVeDao.findByMaVe(em, maVe.trim());
            if (existed != null) {
                return "Vé đã thuộc một đơn hàng khác.";
            }

            ChiTietDonHangVe chiTiet = new ChiTietDonHangVe();
            chiTiet.setMaChiTietVe(generateChiTietVeId());
            chiTiet.setDonHang(donHang);
            chiTiet.setVe(ve);
            chiTiet.setDonGiaBan(ve.getGiaVe());

            chiTietDonHangVeDao.save(em, chiTiet);

            recalculateDonHang(em, donHang);

            tx.commit();
            return "Thêm vé vào đơn hàng thành công.";
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return "Thêm vé vào đơn hàng thất bại.";
        } finally {
            em.close();
        }
    }

    /**
     * Bỏ 1 vé khỏi đơn hàng tạm.
     * Cần ChiTietDonHangVeDao có method:
     * - findByMaDonHangAndMaVe(EntityManager em, String maDonHang, String maVe)
     * - delete(EntityManager em, ChiTietDonHangVe chiTiet)
     */
    public String boVeKhoiDonHang(String maDonHang, String maVe) {
        AuthorizationUtil.requireLogin();

        if (isBlank(maDonHang)) {
            return "Mã đơn hàng không được để trống.";
        }
        if (isBlank(maVe)) {
            return "Mã vé không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findById(em, maDonHang.trim());
            if (donHang == null) {
                return "Đơn hàng không tồn tại.";
            }

            if (donHang.getTrangThaiDonHang() != TrangThaiDonHang.CHO_THANH_TOAN) {
                return "Chỉ được bỏ vé khỏi đơn hàng chưa thanh toán.";
            }

            ChiTietDonHangVe chiTiet = chiTietDonHangVeDao.findByMaDonHangAndMaVe(
                    em,
                    maDonHang.trim(),
                    maVe.trim()
            );
            if (chiTiet == null) {
                return "Vé không nằm trong đơn hàng.";
            }

            chiTietDonHangVeDao.delete(em, chiTiet);

            recalculateDonHang(em, donHang);

            tx.commit();
            return "Bỏ vé khỏi đơn hàng thành công.";
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return "Bỏ vé khỏi đơn hàng thất bại.";
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách vé trong đơn hàng.
     * Cần ChiTietDonHangVeDao có method: findByMaDonHang(String maDonHang)
     */
    public List<Ve> getDanhSachVeTrongDonHang(String maDonHang) {
        if (isBlank(maDonHang)) {
            return List.of();
        }

        List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(maDonHang.trim());
        List<Ve> result = new ArrayList<>();

        for (ChiTietDonHangVe ct : chiTietList) {
            if (ct.getVe() != null) {
                result.add(ct.getVe());
            }
        }
        return result;
    }

    /**
     * Tính tổng tiền hiện tại của đơn hàng.
     */
    public BigDecimal tinhTongTienDonHang(String maDonHang) {
        if (isBlank(maDonHang)) {
            return BigDecimal.ZERO;
        }

        List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(maDonHang.trim());
        BigDecimal tongTien = BigDecimal.ZERO;

        for (ChiTietDonHangVe ct : chiTietList) {
            if (ct.getDonGiaBan() != null) {
                tongTien = tongTien.add(ct.getDonGiaBan());
            }
        }

        return tongTien;
    }

    /**
     * Hủy đơn hàng tạm.
     * Không đổi trạng thái vé vì vé chỉ đổi sang DA_BAN khi thanh toán thành công.
     */
    public String huyDonHangTam(String maDonHang) {
        AuthorizationUtil.requireLogin();

        if (isBlank(maDonHang)) {
            return "Mã đơn hàng không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findDetailById(em, maDonHang.trim());
            if (donHang == null) {
                return "Đơn hàng không tồn tại.";
            }

            if (donHang.getTrangThaiDonHang() == TrangThaiDonHang.DA_THANH_TOAN) {
                return "Không thể hủy đơn hàng đã thanh toán.";
            }

            donHang.setTrangThaiDonHang(TrangThaiDonHang.DA_HUY);
            donHangDao.update(em, donHang);

            tx.commit();
            return "Hủy đơn hàng tạm thành công.";
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return "Hủy đơn hàng tạm thất bại.";
        } finally {
            em.close();
        }
    }

    /**
     * Xác nhận thanh toán cho đơn hàng tạm đã có sẵn.
     */
    public String xacNhanThanhToan(
            String maDonHang,
            String maThanhToan,
            String phuongThucThanhToan,
            String ghiChu,
            String maGiaoDich
    ) {
        AuthorizationUtil.requireLogin();

        if (isBlank(maDonHang)) {
            return "Mã đơn hàng không được để trống.";
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

            DonHang donHang = donHangDao.findDetailById(em, maDonHang.trim());
            if (donHang == null) {
                return "Đơn hàng không tồn tại.";
            }

            if (donHang.getTrangThaiDonHang() == TrangThaiDonHang.DA_HUY) {
                return "Không thể thanh toán đơn hàng đã hủy.";
            }

            if (donHang.getTrangThaiDonHang() == TrangThaiDonHang.DA_THANH_TOAN) {
                return "Đơn hàng đã được thanh toán.";
            }

            if (thanhToanDao.findById(em, maThanhToan.trim()) != null) {
                return "Mã thanh toán đã tồn tại.";
            }

            List<ChiTietDonHangVe> chiTietVes = chiTietDonHangVeDao.findByMaDonHang(em, maDonHang.trim());
            if (chiTietVes == null || chiTietVes.isEmpty()) {
                return "Đơn hàng chưa có vé để thanh toán.";
            }

            BigDecimal tongTien = BigDecimal.ZERO;
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

                if (ct.getDonGiaBan() != null) {
                    tongTien = tongTien.add(ct.getDonGiaBan());
                }
            }

            donHang.setTongTienTruocGiam(tongTien);
            donHang.setTienGiam(BigDecimal.ZERO);
            donHang.setTongTienSauGiam(tongTien);
            donHang.setGhiChu(trimToNull(ghiChu));
            donHangDao.update(em, donHang);

            TaiKhoan taiKhoan = SessionManager.getCurrentTaiKhoan();

            ThanhToan thanhToan = new ThanhToan();
            thanhToan.setMaThanhToan(maThanhToan.trim());
            thanhToan.setDonHang(donHang);
            thanhToan.setSoTien(donHang.getTongTienSauGiam());
            thanhToan.setPhuongThucThanhToan(phuongThucThanhToan.trim());
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
            thanhToan.setTrangThaiThanhToan(TrangThaiThanhToan.THANH_CONG);
            thanhToan.setMaGiaoDich(trimToNull(maGiaoDich));

            if (taiKhoan != null && taiKhoan.isStaff()) {
                thanhToan.setNhanVien(taiKhoan.getNhanVien());
            }

            thanhToanDao.save(em, thanhToan);

            donHang.setTrangThaiDonHang(TrangThaiDonHang.DA_THANH_TOAN);
            donHangDao.update(em, donHang);

            for (ChiTietDonHangVe ct : chiTietVes) {
                Ve ve = veDao.findByIdForUpdate(em, ct.getVe().getMaVe());
                ve.setTrangThaiVe(TrangThaiVe.DA_BAN);
                veDao.update(em, ve);
            }

            tx.commit();
            return "Thanh toán đơn hàng thành công.";
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return "Thanh toán đơn hàng thất bại do lỗi giao dịch.";
        } finally {
            em.close();
        }
    }

    /**
     * =========================================
     * GIỮ NGUYÊN FLOW CŨ ĐỂ KHÔNG VỠ MAIN
     * =========================================
     */

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
    public String muaVeNhanhAnToan(
            String maDonHang,
            List<String> dsMaVe,
            String maThanhToan,
            String phuongThucThanhToan,
            String maKhuyenMai,
            String ghiChu,
            String maGiaoDich
    ) {
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

    private void recalculateDonHang(EntityManager em, DonHang donHang) {
        List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(em, donHang.getMaDonHang());
        BigDecimal tongTien = BigDecimal.ZERO;

        for (ChiTietDonHangVe ct : chiTietList) {
            if (ct.getDonGiaBan() != null) {
                tongTien = tongTien.add(ct.getDonGiaBan());
            }
        }

        donHang.setTongTienTruocGiam(tongTien);
        donHang.setTienGiam(BigDecimal.ZERO);
        donHang.setTongTienSauGiam(tongTien);
        donHangDao.update(em, donHang);
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