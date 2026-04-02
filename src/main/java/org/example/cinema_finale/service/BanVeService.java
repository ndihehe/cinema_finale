package org.example.cinema_finale.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.dao.ChiTietDonHangVeDao;
import org.example.cinema_finale.dao.DonHangDao;
import org.example.cinema_finale.dao.ThanhToanDao;
import org.example.cinema_finale.dao.VeDao;
import org.example.cinema_finale.dto.BanVeThanhToanFormDTO;
import org.example.cinema_finale.dto.CapNhatVeDonHangDTO;
import org.example.cinema_finale.dto.DonHangDTO;
import org.example.cinema_finale.dto.DonHangTamFormDTO;
import org.example.cinema_finale.dto.MuaVeNhanhFormDTO;
import org.example.cinema_finale.dto.VeDTO;
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

    private static final String ORDER_CHUA_THANH_TOAN = "Chưa thanh toán";
    private static final String ORDER_DA_THANH_TOAN = "Đã thanh toán";
    private static final String ORDER_DA_HUY = "Đã hủy";
    private static final String VE_CHUA_BAN = "Chưa bán";
    private static final String VE_DA_BAN = "Đã bán";
    private static final String PAYMENT_THANH_CONG = "Thành công";

    private final DonHangDao donHangDao;
    private final ChiTietDonHangVeDao chiTietDonHangVeDao;
    private final VeDao veDao;
    private final ThanhToanDao thanhToanDao;
    private final VeService veService;

    public BanVeService() {
        this.donHangDao = new DonHangDao();
        this.chiTietDonHangVeDao = new ChiTietDonHangVeDao();
        this.veDao = new VeDao();
        this.thanhToanDao = new ThanhToanDao();
        this.veService = new VeService();
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
        this.veService = new VeService();
    }

    /* =========================
       READ -> DTO
       ========================= */

    public List<VeDTO> getVeBySuatChieu(String maSuatChieu) {
        AuthorizationUtil.requireStaff();
        return veService.getByMaSuatChieu(maSuatChieu);
    }

    public List<VeDTO> getVeTrongBySuatChieu(String maSuatChieu) {
        AuthorizationUtil.requireStaff();
        return veService.getAvailableByMaSuatChieu(maSuatChieu);
    }

    public DonHangDTO getDonHangById(String maDonHang) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maDonHang);
        if (id == null) {
            return null;
        }

        DonHang donHang = donHangDao.findById(id);
        return donHang == null ? null : toDonHangDTO(donHang);
    }

    public List<VeDTO> getDanhSachVeTrongDonHang(String maDonHang) {
        AuthorizationUtil.requireStaff();

        Integer donHangId = parseId(maDonHang);
        if (donHangId == null) {
            return List.of();
        }

        List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(donHangId);
        List<VeDTO> result = new ArrayList<>();

        for (ChiTietDonHangVe ct : chiTietList) {
            if (ct.getVe() != null && ct.getVe().getMaVe() != null) {
                VeDTO dto = veService.getVeById(String.valueOf(ct.getVe().getMaVe()));
                if (dto != null) {
                    result.add(dto);
                }
            }
        }
        return result;
    }

    public BigDecimal tinhTongTienDonHang(String maDonHang) {
        AuthorizationUtil.requireStaff();

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

    /* =========================
       WRITE <- FORM DTO
       ========================= */

    public String taoDonHangTam(DonHangTamFormDTO dto) {
        AuthorizationUtil.requireStaff();

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            TaiKhoan taiKhoan = SessionManager.getCurrentTaiKhoan();
            if (taiKhoan == null || taiKhoan.getNhanVien() == null) {
                return rollbackAndReturn(tx, "Không xác định được nhân viên hiện tại.");
            }

            DonHang donHang = new DonHang();
            donHang.setNhanVien(taiKhoan.getNhanVien());
            donHang.setGhiChu(dto == null ? null : trimToNull(dto.getGhiChu()));
            donHang.setNgayLap(LocalDateTime.now());
            donHang.setTrangThaiDonHang(ORDER_CHUA_THANH_TOAN);

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

    public String themVeVaoDonHang(CapNhatVeDonHangDTO dto) {
        AuthorizationUtil.requireStaff();

        if (dto == null || dto.getMaDonHang() == null) {
            return "Mã đơn hàng không hợp lệ.";
        }
        if (dto.getMaVe() == null) {
            return "Mã vé không hợp lệ.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findById(em, dto.getMaDonHang());
            if (donHang == null) {
                return rollbackAndReturn(tx, "Đơn hàng không tồn tại.");
            }

            if (!ORDER_CHUA_THANH_TOAN.equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return rollbackAndReturn(tx, "Chỉ được thêm vé vào đơn hàng chưa thanh toán.");
            }

            Ve ve = veDao.findByIdForUpdate(em, dto.getMaVe());
            if (ve == null) {
                return rollbackAndReturn(tx, "Vé không tồn tại.");
            }

            if (!VE_CHUA_BAN.equalsIgnoreCase(ve.getTrangThaiVe())) {
                return rollbackAndReturn(tx, "Vé không còn ở trạng thái chưa bán.");
            }

            ChiTietDonHangVe existed = chiTietDonHangVeDao.findByMaVe(em, dto.getMaVe());
            if (existed != null) {
                return rollbackAndReturn(tx, "Vé đã thuộc một đơn hàng khác.");
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

    public String boVeKhoiDonHang(CapNhatVeDonHangDTO dto) {
        AuthorizationUtil.requireStaff();

        if (dto == null || dto.getMaDonHang() == null) {
            return "Mã đơn hàng không hợp lệ.";
        }
        if (dto.getMaVe() == null) {
            return "Mã vé không hợp lệ.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findById(em, dto.getMaDonHang());
            if (donHang == null) {
                return rollbackAndReturn(tx, "Đơn hàng không tồn tại.");
            }

            if (!ORDER_CHUA_THANH_TOAN.equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return rollbackAndReturn(tx, "Chỉ được bỏ vé khỏi đơn hàng chưa thanh toán.");
            }

            ChiTietDonHangVe chiTiet = chiTietDonHangVeDao.findByMaDonHangAndMaVe(
                    em, dto.getMaDonHang(), dto.getMaVe()
            );
            if (chiTiet == null) {
                return rollbackAndReturn(tx, "Vé không nằm trong đơn hàng.");
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
                return rollbackAndReturn(tx, "Đơn hàng không tồn tại.");
            }

            if (ORDER_DA_THANH_TOAN.equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return rollbackAndReturn(tx, "Không thể hủy đơn hàng đã thanh toán.");
            }

            donHang.setTrangThaiDonHang(ORDER_DA_HUY);
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

    public String xacNhanThanhToan(BanVeThanhToanFormDTO dto) {
        AuthorizationUtil.requireStaff();

        if (dto == null || dto.getMaDonHang() == null) {
            return "Mã đơn hàng không hợp lệ.";
        }
        if (isBlank(dto.getPhuongThucThanhToan())) {
            return "Phương thức thanh toán không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            DonHang donHang = donHangDao.findDetailById(em, dto.getMaDonHang());
            if (donHang == null) {
                return rollbackAndReturn(tx, "Đơn hàng không tồn tại.");
            }

            if (ORDER_DA_HUY.equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return rollbackAndReturn(tx, "Không thể thanh toán đơn hàng đã hủy.");
            }

            if (ORDER_DA_THANH_TOAN.equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return rollbackAndReturn(tx, "Đơn hàng đã được thanh toán.");
            }

            List<ChiTietDonHangVe> chiTietVes = chiTietDonHangVeDao.findByMaDonHang(em, dto.getMaDonHang());
            if (chiTietVes == null || chiTietVes.isEmpty()) {
                return rollbackAndReturn(tx, "Đơn hàng chưa có vé để thanh toán.");
            }

            BigDecimal tongTien = BigDecimal.ZERO;

            for (ChiTietDonHangVe ct : chiTietVes) {
                if (ct.getVe() == null) {
                    return rollbackAndReturn(tx, "Chi tiết đơn hàng có vé không hợp lệ.");
                }

                Ve ve = veDao.findByIdForUpdate(em, ct.getVe().getMaVe());
                if (ve == null) {
                    return rollbackAndReturn(tx, "Vé " + ct.getVe().getMaVe() + " không tồn tại.");
                }

                if (!VE_CHUA_BAN.equalsIgnoreCase(ve.getTrangThaiVe())) {
                    return rollbackAndReturn(tx, "Vé " + ve.getMaVe() + " không còn ở trạng thái chưa bán.");
                }

                if (ct.getDonGiaBan() != null) {
                    tongTien = tongTien.add(ct.getDonGiaBan());
                }
            }

            ThanhToan thanhToan = new ThanhToan();
            thanhToan.setDonHang(donHang);
            thanhToan.setSoTien(tongTien);
            thanhToan.setPhuongThucThanhToan(dto.getPhuongThucThanhToan().trim());
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
            thanhToan.setTrangThaiThanhToan(PAYMENT_THANH_CONG);
            thanhToanDao.save(em, thanhToan);

            donHang.setTrangThaiDonHang(ORDER_DA_THANH_TOAN);
            donHangDao.update(em, donHang);

            for (ChiTietDonHangVe ct : chiTietVes) {
                Ve ve = veDao.findByIdForUpdate(em, ct.getVe().getMaVe());
                ve.setTrangThaiVe(VE_DA_BAN);
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

    public String muaVeNhanhAnToan(MuaVeNhanhFormDTO dto) {
        AuthorizationUtil.requireStaff();

        if (dto == null || dto.getDsMaVe() == null || dto.getDsMaVe().isEmpty()) {
            return "Danh sách vé không được để trống.";
        }
        if (isBlank(dto.getPhuongThucThanhToan())) {
            return "Phương thức thanh toán không được để trống.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            TaiKhoan taiKhoan = SessionManager.getCurrentTaiKhoan();
            if (taiKhoan == null || taiKhoan.getNhanVien() == null) {
                return rollbackAndReturn(tx, "Không xác định được nhân viên hiện tại.");
            }

            DonHang donHang = new DonHang();
            donHang.setNhanVien(taiKhoan.getNhanVien());
            donHang.setGhiChu(trimToNull(dto.getGhiChu()));
            donHang.setNgayLap(LocalDateTime.now());
            donHang.setTrangThaiDonHang(ORDER_CHUA_THANH_TOAN);
            donHangDao.save(em, donHang);

            BigDecimal tongTien = BigDecimal.ZERO;

            for (Integer veId : dto.getDsMaVe()) {
                if (veId == null) {
                    return rollbackAndReturn(tx, "Danh sách vé có mã vé không hợp lệ.");
                }

                Ve ve = veDao.findByIdForUpdate(em, veId);
                if (ve == null) {
                    return rollbackAndReturn(tx, "Vé " + veId + " không tồn tại.");
                }

                if (!VE_CHUA_BAN.equalsIgnoreCase(ve.getTrangThaiVe())) {
                    return rollbackAndReturn(tx, "Vé " + veId + " không còn ở trạng thái chưa bán.");
                }

                if (chiTietDonHangVeDao.findByMaVe(em, veId) != null) {
                    return rollbackAndReturn(tx, "Vé " + veId + " đã thuộc một đơn hàng khác.");
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
            thanhToan.setPhuongThucThanhToan(dto.getPhuongThucThanhToan().trim());
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
            thanhToan.setTrangThaiThanhToan(PAYMENT_THANH_CONG);
            thanhToanDao.save(em, thanhToan);

            donHang.setTrangThaiDonHang(ORDER_DA_THANH_TOAN);
            donHangDao.update(em, donHang);

            for (Integer veId : dto.getDsMaVe()) {
                Ve ve = veDao.findByIdForUpdate(em, veId);
                if (ve == null) {
                    return rollbackAndReturn(tx, "Vé " + veId + " không tồn tại khi chốt thanh toán.");
                }

                if (!VE_CHUA_BAN.equalsIgnoreCase(ve.getTrangThaiVe())) {
                    return rollbackAndReturn(tx, "Vé " + veId + " đã bị thay đổi trạng thái trong lúc thanh toán.");
                }

                ve.setTrangThaiVe(VE_DA_BAN);
                veDao.update(em, ve);
            }

            tx.commit();
            return "Bán vé thành công. Mã đơn hàng: " + donHang.getMaDonHang()
                    + ", mã thanh toán: " + thanhToan.getMaThanhToan();
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

    /* =========================
       DTO MAPPING
       ========================= */

    private DonHangDTO toDonHangDTO(DonHang donHang) {
        DonHangDTO dto = new DonHangDTO();
        dto.setMaDonHang(donHang.getMaDonHang());
        dto.setNgayLap(donHang.getNgayLap());
        dto.setTrangThaiDonHang(donHang.getTrangThaiDonHang());
        dto.setGhiChu(donHang.getGhiChu());
        dto.setTongTien(tinhTongTienDonHang(String.valueOf(donHang.getMaDonHang())));

        List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(donHang.getMaDonHang());
        dto.setSoLuongVe(chiTietList == null ? 0 : chiTietList.size());

        return dto;
    }

    /* =========================
       HELPERS
       ========================= */

    private String rollbackAndReturn(EntityTransaction tx, String message) {
        if (tx != null && tx.isActive()) {
            tx.rollback();
        }
        return message;
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