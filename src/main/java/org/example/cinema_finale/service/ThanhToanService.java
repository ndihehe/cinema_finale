package org.example.cinema_finale.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.dao.ChiTietDonHangVeDao;
import org.example.cinema_finale.dao.DonHangDao;
import org.example.cinema_finale.dao.ThanhToanDao;
import org.example.cinema_finale.dao.VeDao;
import org.example.cinema_finale.dto.ThanhToanDTO;
import org.example.cinema_finale.dto.ThanhToanFormDTO;
import org.example.cinema_finale.entity.ChiTietDonHangVe;
import org.example.cinema_finale.entity.DonHang;
import org.example.cinema_finale.entity.ThanhToan;
import org.example.cinema_finale.util.AuthorizationUtil;
import org.example.cinema_finale.util.JpaUtil;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public class ThanhToanService {

    private static final String STATUS_THANH_CONG = "Thành công";
    private static final String STATUS_THAT_BAI = "Thất bại";
    private static final String ORDER_CHUA_THANH_TOAN = "Chưa thanh toán";
    private static final String ORDER_DA_THANH_TOAN = "Đã thanh toán";
    private static final String ORDER_DA_HUY = "Đã hủy";
    private static final String VE_DA_BAN = "Đã bán";
    private static final String VE_DA_HUY = "Đã hủy";

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

    /* =========================
       READ -> DTO
       ========================= */

    public List<ThanhToanDTO> getAllThanhToan() {
        AuthorizationUtil.requireStaff();
        return thanhToanDao.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public ThanhToanDTO getThanhToanById(String maThanhToan) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maThanhToan);
        if (id == null) {
            return null;
        }

        ThanhToan thanhToan = thanhToanDao.findById(id);
        return thanhToan == null ? null : toDTO(thanhToan);
    }

    public List<ThanhToanDTO> getByMaDonHang(String maDonHang) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maDonHang);
        if (id == null) {
            return List.of();
        }

        return thanhToanDao.findByMaDonHang(id).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<ThanhToanDTO> getByTrangThai(Object trangThaiThanhToan) {
        AuthorizationUtil.requireStaff();

        String status = normalizeThanhToanStatus(trangThaiThanhToan);
        if (status == null) {
            return List.of();
        }

        return thanhToanDao.findByTrangThai(status).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    /* =========================
       WRITE <- FORM DTO
       ========================= */

    public String addThanhToan(ThanhToanFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        ThanhToan thanhToan = buildEntityFromForm(formDTO, true);
        String validation = validateThanhToan(thanhToan, true);
        if (validation != null) {
            return validation;
        }

        boolean result = thanhToanDao.save(thanhToan);
        return result ? "Tạo thanh toán thành công." : "Tạo thanh toán thất bại.";
    }

    public String updateThanhToan(ThanhToanFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        if (formDTO == null || formDTO.getMaThanhToan() == null) {
            return "Mã thanh toán không hợp lệ.";
        }

        ThanhToan thanhToan = buildEntityFromForm(formDTO, false);
        String validation = validateThanhToan(thanhToan, false);
        if (validation != null) {
            return validation;
        }

        boolean result = thanhToanDao.update(thanhToan);
        return result ? "Cập nhật thanh toán thành công." : "Cập nhật thanh toán thất bại.";
    }

    /* =========================
       STATUS ACTIONS
       ========================= */

    public String confirmThanhToan(String maThanhToan) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maThanhToan);
        if (id == null) {
            return "Mã thanh toán không hợp lệ.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            ThanhToan thanhToan = thanhToanDao.findById(em, id);
            if (thanhToan == null) {
                return "Thanh toán không tồn tại.";
            }

            if (thanhToan.getDonHang() == null || thanhToan.getDonHang().getMaDonHang() == null) {
                return "Đơn hàng của thanh toán không hợp lệ.";
            }

            DonHang donHang = donHangDao.findDetailById(em, thanhToan.getDonHang().getMaDonHang());
            if (donHang == null) {
                return "Đơn hàng của thanh toán không tồn tại.";
            }

            if (ORDER_DA_HUY.equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
                return "Không thể xác nhận thanh toán cho đơn hàng đã hủy.";
            }

            if (STATUS_THANH_CONG.equalsIgnoreCase(thanhToan.getTrangThaiThanhToan())) {
                return "Thanh toán này đã được xác nhận trước đó.";
            }

            List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(em, donHang.getMaDonHang());
            if (chiTietList == null || chiTietList.isEmpty()) {
                return "Đơn hàng không có vé để xác nhận thanh toán.";
            }

            thanhToan.setTrangThaiThanhToan(STATUS_THANH_CONG);
            if (thanhToan.getThoiGianThanhToan() == null) {
                thanhToan.setThoiGianThanhToan(LocalDateTime.now());
            }
            thanhToanDao.update(em, thanhToan);

            donHang.setTrangThaiDonHang(ORDER_DA_THANH_TOAN);
            donHangDao.update(em, donHang);

            for (ChiTietDonHangVe chiTiet : chiTietList) {
                if (chiTiet.getVe() != null) {
                    chiTiet.getVe().setTrangThaiVe(VE_DA_BAN);
                    veDao.update(em, chiTiet.getVe());
                }
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

    public String markThanhToanFailed(String maThanhToan) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maThanhToan);
        if (id == null) {
            return "Mã thanh toán không hợp lệ.";
        }

        ThanhToan thanhToan = thanhToanDao.findById(id);
        if (thanhToan == null) {
            return "Thanh toán không tồn tại.";
        }

        if (STATUS_THANH_CONG.equalsIgnoreCase(thanhToan.getTrangThaiThanhToan())) {
            return "Không thể đánh dấu thất bại cho thanh toán đã thành công.";
        }

        boolean result = thanhToanDao.updateTrangThai(id, STATUS_THAT_BAI);
        return result ? "Đánh dấu thanh toán thất bại thành công." : "Cập nhật trạng thái thanh toán thất bại.";
    }

    public String refundThanhToan(String maThanhToan) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maThanhToan);
        if (id == null) {
            return "Mã thanh toán không hợp lệ.";
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            ThanhToan thanhToan = thanhToanDao.findById(em, id);
            if (thanhToan == null) {
                return "Thanh toán không tồn tại.";
            }

            if (!STATUS_THANH_CONG.equalsIgnoreCase(thanhToan.getTrangThaiThanhToan())) {
                return "Chỉ thanh toán thành công mới có thể hoàn tiền.";
            }

            if (thanhToan.getDonHang() == null || thanhToan.getDonHang().getMaDonHang() == null) {
                return "Đơn hàng của thanh toán không hợp lệ.";
            }

            DonHang donHang = donHangDao.findDetailById(em, thanhToan.getDonHang().getMaDonHang());
            if (donHang == null) {
                return "Đơn hàng của thanh toán không tồn tại.";
            }

            List<ChiTietDonHangVe> chiTietList = chiTietDonHangVeDao.findByMaDonHang(em, donHang.getMaDonHang());

            thanhToan.setTrangThaiThanhToan(STATUS_THAT_BAI);
            thanhToanDao.update(em, thanhToan);

            donHang.setTrangThaiDonHang(ORDER_DA_HUY);
            donHangDao.update(em, donHang);

            for (ChiTietDonHangVe chiTiet : chiTietList) {
                if (chiTiet.getVe() != null) {
                    chiTiet.getVe().setTrangThaiVe(VE_DA_HUY);
                    veDao.update(em, chiTiet.getVe());
                }
            }

            tx.commit();
            return "Hoàn tiền thành công.";
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return "Hoàn tiền thất bại do lỗi giao dịch.";
        } finally {
            em.close();
        }
    }

    /* =========================
       VALIDATION
       ========================= */

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

        if (ORDER_DA_HUY.equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
            return "Không thể tạo thanh toán cho đơn hàng đã hủy.";
        }

        if (ORDER_DA_THANH_TOAN.equalsIgnoreCase(donHang.getTrangThaiDonHang())) {
            return "Đơn hàng này đã thanh toán.";
        }

        thanhToan.setPhuongThucThanhToan(thanhToan.getPhuongThucThanhToan().trim());
        thanhToan.setDonHang(donHang);

        if (thanhToan.getThoiGianThanhToan() == null) {
            thanhToan.setThoiGianThanhToan(LocalDateTime.now());
        }

        if (isBlank(thanhToan.getTrangThaiThanhToan())) {
            thanhToan.setTrangThaiThanhToan(STATUS_THANH_CONG);
        } else {
            String normalizedStatus = normalizeThanhToanStatus(thanhToan.getTrangThaiThanhToan());
            if (normalizedStatus == null) {
                return "Trạng thái thanh toán không hợp lệ.";
            }
            thanhToan.setTrangThaiThanhToan(normalizedStatus);
        }

        if (thanhToan.getSoTien() == null || thanhToan.getSoTien().compareTo(BigDecimal.ZERO) <= 0) {
            thanhToan.setSoTien(tinhTongTienDonHang(donHang.getMaDonHang()));
        }

        if (thanhToan.getSoTien() == null || thanhToan.getSoTien().compareTo(BigDecimal.ZERO) <= 0) {
            return "Số tiền thanh toán phải lớn hơn 0.";
        }

        if (!isCreate && thanhToanDao.findById(thanhToan.getMaThanhToan()) == null) {
            return "Thanh toán không tồn tại để cập nhật.";
        }

        return null;
    }

    /* =========================
       DTO / FORM MAPPING
       ========================= */

    private ThanhToan buildEntityFromForm(ThanhToanFormDTO formDTO, boolean isCreate) {
        if (formDTO == null) {
            return null;
        }

        ThanhToan thanhToan;
        if (isCreate) {
            thanhToan = new ThanhToan();
        } else {
            thanhToan = thanhToanDao.findById(formDTO.getMaThanhToan());
            if (thanhToan == null) {
                return null;
            }
        }

        if (formDTO.getMaThanhToan() != null) {
            thanhToan.setMaThanhToan(formDTO.getMaThanhToan());
        }

        if (formDTO.getMaDonHang() != null) {
            DonHang donHang = new DonHang();
            donHang.setMaDonHang(formDTO.getMaDonHang());
            thanhToan.setDonHang(donHang);
        }

        thanhToan.setSoTien(formDTO.getSoTien());
        thanhToan.setPhuongThucThanhToan(trimToNull(formDTO.getPhuongThucThanhToan()));
        thanhToan.setTrangThaiThanhToan(trimToNull(formDTO.getTrangThaiThanhToan()));

        return thanhToan;
    }

    private ThanhToanDTO toDTO(ThanhToan thanhToan) {
        ThanhToanDTO dto = new ThanhToanDTO();
        dto.setMaThanhToan(thanhToan.getMaThanhToan());
        dto.setSoTien(thanhToan.getSoTien());
        dto.setPhuongThucThanhToan(thanhToan.getPhuongThucThanhToan());
        dto.setTrangThaiThanhToan(thanhToan.getTrangThaiThanhToan());
        dto.setThoiGianThanhToan(thanhToan.getThoiGianThanhToan());

        if (thanhToan.getDonHang() != null) {
            dto.setMaDonHang(thanhToan.getDonHang().getMaDonHang());
        }

        return dto;
    }

    /* =========================
       HELPERS
       ========================= */

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

        if (value.equalsIgnoreCase("Thành công") || value.equalsIgnoreCase("THANH_CONG")) {
            return STATUS_THANH_CONG;
        }
        if (value.equalsIgnoreCase("Thất bại") || value.equalsIgnoreCase("THAT_BAI")) {
            return STATUS_THAT_BAI;
        }
        if (value.equalsIgnoreCase("HOAN_TIEN")) {
            return STATUS_THAT_BAI;
        }

        return null;
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}