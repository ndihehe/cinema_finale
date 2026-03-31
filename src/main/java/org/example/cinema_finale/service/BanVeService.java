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

    public List<Ve> getVeBySuatChieu(String maSuatChieu) {
        Integer id = parseId(maSuatChieu);
        return id == null ? List.of() : veDao.findByMaSuatChieu(id);
    }

    public List<Ve> getVeTrongBySuatChieu(String maSuatChieu) {
        Integer id = parseId(maSuatChieu);
        return id == null ? List.of() : veDao.findByMaSuatChieuAndTrangThai(id, "Chưa bán");
    }

    public String taoDonHangTam(String maDonHangIgnored, String maKhuyenMaiIgnored, String ghiChu) {
        AuthorizationUtil.requireStaff();

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            TaiKhoan taiKhoan = SessionManager.getCurrentTaiKhoan();
            if (taiKhoan == null || taiKhoan.getNhanVien() == null) {
                return "Không xác định được nhân viên hiện tại.";
            }

            DonHang donHang = new DonHang();
            donHang.setNhanVien(taiKhoan.getNhanVien());
            donHang.setGhiChu(trimToNull(ghiChu));
            donHang.setNgayLap(LocalDateTime.now());
            donHang.setTrangThaiDonHang("Chưa thanh toán");

            donHangDao.save(em, donHang);
            tx.commit();
            return "Tạo đơn hàng tạm thành công. Mã đơn hàng: " + donHang.getMaDonHang();
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

    public DonHang getDonHangById(String maDonHang) {
        Integer id = parseId(maDonHang);
        return id == null ? null : donHangDao.findById(id);
    }

    public String themVeVaoDonHang(String maDonHang, String maVe) {
        AuthorizationUtil.requireStaff();

        Integer donHangId = parseId(maDonHang);
        Integer veId = parseId(maVe);
        if (donHangId == null) {
            return "Mã đơn hàng không hợp lệ.";
        }
        if (veId == null) {
            return "Mã vé không hợp lệ.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findById(em, donHangId);
            if (donHang == null) {
                return "Đơn hàng không tồn tại.";
            }

            if (!"Chưa thanh toán".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return "Chỉ được thêm vé vào đơn hàng chưa thanh toán.";
            }

            Ve ve = veDao.findByIdForUpdate(em, veId);
            if (ve == null) {
                return "Vé không tồn tại.";
            }

            if (!"Chưa bán".equalsIgnoreCase(ve.getTrangThaiVe())) {
                return "Vé không còn ở trạng thái chưa bán.";
            }

            ChiTietDonHangVe existed = chiTietDonHangVeDao.findByMaVe(em, veId);
            if (existed != null) {
                return "Vé đã thuộc một đơn hàng khác.";
            }

            ChiTietDonHangVe chiTiet = new ChiTietDonHangVe();
            chiTiet.setDonHang(donHang);
            chiTiet.setVe(ve);
            chiTiet.setDonGiaBan(ve.getGiaVe());
            chiTietDonHangVeDao.save(em, chiTiet);

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

    public String boVeKhoiDonHang(String maDonHang, String maVe) {
        AuthorizationUtil.requireStaff();

        Integer donHangId = parseId(maDonHang);
        Integer veId = parseId(maVe);
        if (donHangId == null) {
            return "Mã đơn hàng không hợp lệ.";
        }
        if (veId == null) {
            return "Mã vé không hợp lệ.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findById(em, donHangId);
            if (donHang == null) {
                return "Đơn hàng không tồn tại.";
            }

            if (!"Chưa thanh toán".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return "Chỉ được bỏ vé khỏi đơn hàng chưa thanh toán.";
            }

            ChiTietDonHangVe chiTiet = chiTietDonHangVeDao.findByMaDonHangAndMaVe(em, donHangId, veId);
            if (chiTiet == null) {
                return "Vé không nằm trong đơn hàng.";
            }

            chiTietDonHangVeDao.delete(em, chiTiet);
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

    public List<Ve> getDanhSachVeTrongDonHang(String maDonHang) {
        Integer donHangId = parseId(maDonHang);
        if (donHangId == null) {
            return List.of();
        }

        List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(donHangId);
        List<Ve> result = new ArrayList<>();

        for (ChiTietDonHangVe ct : chiTietList) {
            if (ct.getVe() != null) {
                result.add(ct.getVe());
            }
        }
        return result;
    }

    public BigDecimal tinhTongTienDonHang(String maDonHang) {
        Integer donHangId = parseId(maDonHang);
        if (donHangId == null) {
            return BigDecimal.ZERO;
        }

        List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(donHangId);
        BigDecimal tongTien = BigDecimal.ZERO;

        for (ChiTietDonHangVe ct : chiTietList) {
            if (ct.getDonGiaBan() != null) {
                tongTien = tongTien.add(ct.getDonGiaBan());
            }
        }

        return tongTien;
    }

    public String huyDonHangTam(String maDonHang) {
        AuthorizationUtil.requireStaff();

        Integer donHangId = parseId(maDonHang);
        if (donHangId == null) {
            return "Mã đơn hàng không hợp lệ.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findDetailById(em, donHangId);
            if (donHang == null) {
                return "Đơn hàng không tồn tại.";
            }

            if ("Đã thanh toán".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return "Không thể hủy đơn hàng đã thanh toán.";
            }

            donHang.setTrangThaiDonHang("Đã hủy");
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

    public String xacNhanThanhToan(
            String maDonHang,
            String maThanhToanIgnored,
            String phuongThucThanhToan,
            String ghiChuIgnored,
            String maGiaoDichIgnored
    ) {
        AuthorizationUtil.requireStaff();

        Integer donHangId = parseId(maDonHang);
        if (donHangId == null) {
            return "Mã đơn hàng không hợp lệ.";
        }
        if (isBlank(phuongThucThanhToan)) {
            return "Phương thức thanh toán không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findDetailById(em, donHangId);
            if (donHang == null) {
                return "Đơn hàng không tồn tại.";
            }

            if ("Đã hủy".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return "Không thể thanh toán đơn hàng đã hủy.";
            }

            if ("Đã thanh toán".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return "Đơn hàng đã được thanh toán.";
            }

            List<ChiTietDonHangVe> chiTietVes = chiTietDonHangVeDao.findByMaDonHang(em, donHangId);
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
                if (!"Chưa bán".equalsIgnoreCase(ve.getTrangThaiVe())) {
                    return "Vé " + ve.getMaVe() + " không còn ở trạng thái chưa bán.";
                }

                if (ct.getDonGiaBan() != null) {
                    tongTien = tongTien.add(ct.getDonGiaBan());
                }
            }

            ThanhToan thanhToan = new ThanhToan();
            thanhToan.setDonHang(donHang);
            thanhToan.setSoTien(tongTien);
            thanhToan.setPhuongThucThanhToan(phuongThucThanhToan.trim());
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
            thanhToan.setTrangThaiThanhToan("Thành công");
            thanhToanDao.save(em, thanhToan);

            donHang.setTrangThaiDonHang("Đã thanh toán");
            donHangDao.update(em, donHang);

            for (ChiTietDonHangVe ct : chiTietVes) {
                Ve ve = veDao.findByIdForUpdate(em, ct.getVe().getMaVe());
                ve.setTrangThaiVe("Đã bán");
                veDao.update(em, ve);
            }

            tx.commit();
            return "Thanh toán đơn hàng thành công. Mã thanh toán: " + thanhToan.getMaThanhToan();
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

    public String muaVeNhanhAnToan(
            String maDonHangIgnored,
            List<String> dsMaVe,
            String maThanhToanIgnored,
            String phuongThucThanhToan,
            String maKhuyenMaiIgnored,
            String ghiChu,
            String maGiaoDichIgnored
    ) {
        AuthorizationUtil.requireStaff();

        if (dsMaVe == null || dsMaVe.isEmpty()) {
            return "Danh sách vé không được để trống.";
        }
        if (isBlank(phuongThucThanhToan)) {
            return "Phương thức thanh toán không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            TaiKhoan taiKhoan = SessionManager.getCurrentTaiKhoan();
            if (taiKhoan == null || taiKhoan.getNhanVien() == null) {
                return "Không xác định được nhân viên hiện tại.";
            }

            DonHang donHang = new DonHang();
            donHang.setNhanVien(taiKhoan.getNhanVien());
            donHang.setGhiChu(trimToNull(ghiChu));
            donHang.setNgayLap(LocalDateTime.now());
            donHang.setTrangThaiDonHang("Chưa thanh toán");
            donHangDao.save(em, donHang);

            BigDecimal tongTien = BigDecimal.ZERO;

            for (String maVe : dsMaVe) {
                Integer veId = parseId(maVe);
                if (veId == null) {
                    return "Danh sách vé có mã vé không hợp lệ.";
                }

                Ve ve = veDao.findByIdForUpdate(em, veId);
                if (ve == null) {
                    return "Vé " + maVe + " không tồn tại.";
                }

                if (!"Chưa bán".equalsIgnoreCase(ve.getTrangThaiVe())) {
                    return "Vé " + maVe + " không còn ở trạng thái chưa bán.";
                }

                if (chiTietDonHangVeDao.findByMaVe(em, veId) != null) {
                    return "Vé " + maVe + " đã thuộc một đơn hàng khác.";
                }

                ChiTietDonHangVe chiTiet = new ChiTietDonHangVe();
                chiTiet.setDonHang(donHang);
                chiTiet.setVe(ve);
                chiTiet.setDonGiaBan(ve.getGiaVe());
                chiTietDonHangVeDao.save(em, chiTiet);

                if (ve.getGiaVe() != null) {
                    tongTien = tongTien.add(ve.getGiaVe());
                }
            }

            ThanhToan thanhToan = new ThanhToan();
            thanhToan.setDonHang(donHang);
            thanhToan.setSoTien(tongTien);
            thanhToan.setPhuongThucThanhToan(phuongThucThanhToan.trim());
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
            thanhToan.setTrangThaiThanhToan("Thành công");
            thanhToanDao.save(em, thanhToan);

            donHang.setTrangThaiDonHang("Đã thanh toán");
            donHangDao.update(em, donHang);

            for (String maVe : dsMaVe) {
                Integer veId = parseId(maVe);
                Ve ve = veDao.findByIdForUpdate(em, veId);
                if (ve == null) {
                    return "Vé " + maVe + " không tồn tại khi chốt thanh toán.";
                }
                if (!"Chưa bán".equalsIgnoreCase(ve.getTrangThaiVe())) {
                    return "Vé " + maVe + " đã bị thay đổi trạng thái trong lúc thanh toán.";
                }

                ve.setTrangThaiVe("Đã bán");
                veDao.update(em, ve);
            }

            tx.commit();
            return "Bán vé thành công. Mã đơn hàng: " + donHang.getMaDonHang() + ", mã thanh toán: " + thanhToan.getMaThanhToan();
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

    public String xacNhanThanhToanAnToan(String maThanhToan) {
        AuthorizationUtil.requireStaff();

        Integer thanhToanId = parseId(maThanhToan);
        if (thanhToanId == null) {
            return "Mã thanh toán không hợp lệ.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            ThanhToan thanhToan = thanhToanDao.findById(em, thanhToanId);
            if (thanhToan == null) {
                return "Thanh toán không tồn tại.";
            }

            DonHang donHang = donHangDao.findDetailById(em, thanhToan.getDonHang().getMaDonHang());
            if (donHang == null) {
                return "Đơn hàng của thanh toán không tồn tại.";
            }

            if ("Đã hủy".equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return "Không thể xác nhận thanh toán cho đơn hàng đã hủy.";
            }

            if ("Thành công".equalsIgnoreCase(thanhToan.getTrangThaiThanhToan())) {
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
                if (!"Chưa bán".equalsIgnoreCase(ve.getTrangThaiVe())) {
                    return "Vé " + ve.getMaVe() + " không còn ở trạng thái chưa bán.";
                }
            }

            thanhToan.setTrangThaiThanhToan("Thành công");
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
            thanhToanDao.update(em, thanhToan);

            donHang.setTrangThaiDonHang("Đã thanh toán");
            donHangDao.update(em, donHang);

            for (ChiTietDonHangVe ct : chiTietVes) {
                Ve ve = veDao.findByIdForUpdate(em, ct.getVe().getMaVe());
                ve.setTrangThaiVe("Đã bán");
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
