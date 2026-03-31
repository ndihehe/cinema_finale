package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.dao.SuatChieuDao;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class SuatChieuService {

    private final SuatChieuDao suatChieuDao;
    private final PhimDao phimDao;

    public SuatChieuService() {
        this.suatChieuDao = new SuatChieuDao();
        this.phimDao = new PhimDao();
    }

    public SuatChieuService(SuatChieuDao suatChieuDao, PhimDao phimDao) {
        this.suatChieuDao = suatChieuDao;
        this.phimDao = phimDao;
    }

    public List<SuatChieu> getAllSuatChieu() {
        return suatChieuDao.findAll();
    }

    public List<SuatChieu> getAllForBooking() {
        return suatChieuDao.findAllForBooking();
    }

    public SuatChieu getSuatChieuById(String maSuatChieu) {
        Integer id = parseId(maSuatChieu);
        return id == null ? null : suatChieuDao.findById(id);
    }

    public List<SuatChieu> getByMaPhim(String maPhim) {
        Integer id = parseId(maPhim);
        return id == null ? List.of() : suatChieuDao.findByMaPhim(id);
    }

    public List<SuatChieu> getByNgay(LocalDate ngay) {
        if (ngay == null) {
            return List.of();
        }
        return suatChieuDao.findByNgay(ngay);
    }

    public List<SuatChieu> getByPhongAndNgay(String maPhongChieu, LocalDate ngay) {
        Integer id = parseId(maPhongChieu);
        if (id == null || ngay == null) {
            return List.of();
        }
        return suatChieuDao.findByPhongAndNgay(id, ngay);
    }

    public List<SuatChieu> getByTrangThai(Object trangThaiSuatChieu) {
        String status = normalizeSuatChieuStatus(trangThaiSuatChieu);
        if (status == null) {
            return List.of();
        }
        return suatChieuDao.findByTrangThai(status);
    }

    public String addSuatChieu(SuatChieu suatChieu) {
        AuthorizationUtil.requireStaff();

        String validation = validateSuatChieu(suatChieu, true);
        if (validation != null) {
            return validation;
        }

        boolean result = suatChieuDao.save(suatChieu);
        return result ? "Thêm suất chiếu thành công." : "Thêm suất chiếu thất bại.";
    }

    public String updateSuatChieu(SuatChieu suatChieu) {
        AuthorizationUtil.requireStaff();

        String validation = validateSuatChieu(suatChieu, false);
        if (validation != null) {
            return validation;
        }

        boolean result = suatChieuDao.update(suatChieu);
        return result ? "Cập nhật suất chiếu thành công." : "Cập nhật suất chiếu thất bại.";
    }

    public String deleteSuatChieu(String maSuatChieu) {
        return cancelSuatChieu(maSuatChieu);
    }

    public String cancelSuatChieu(String maSuatChieu) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maSuatChieu);
        if (id == null) {
            return "Mã suất chiếu không hợp lệ.";
        }

        SuatChieu suatChieu = suatChieuDao.findById(id);
        if (suatChieu == null) {
            return "Suất chiếu không tồn tại.";
        }

        boolean result = suatChieuDao.updateTrangThai(id, "Hủy");
        return result ? "Hủy suất chiếu thành công." : "Hủy suất chiếu thất bại.";
    }

    public String updateTrangThai(String maSuatChieu, Object trangThaiSuatChieu) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maSuatChieu);
        if (id == null) {
            return "Mã suất chiếu không hợp lệ.";
        }

        String status = normalizeSuatChieuStatus(trangThaiSuatChieu);
        if (status == null) {
            return "Trạng thái suất chiếu không hợp lệ.";
        }

        SuatChieu suatChieu = suatChieuDao.findById(id);
        if (suatChieu == null) {
            return "Suất chiếu không tồn tại.";
        }

        boolean result = suatChieuDao.updateTrangThai(id, status);
        return result ? "Cập nhật trạng thái suất chiếu thành công." : "Cập nhật trạng thái suất chiếu thất bại.";
    }

    private String validateSuatChieu(SuatChieu suatChieu, boolean isCreate) {
        if (suatChieu == null) {
            return "Dữ liệu suất chiếu không hợp lệ.";
        }

        if (!isCreate && suatChieu.getMaSuatChieu() == null) {
            return "Mã suất chiếu không được để trống khi cập nhật.";
        }

        if (suatChieu.getNgayGioChieu() == null) {
            return "Ngày giờ chiếu không được để trống.";
        }

        if (isCreate && suatChieu.getNgayGioChieu().isBefore(LocalDateTime.now())) {
            return "Không thể tạo suất chiếu trong quá khứ.";
        }

        if (suatChieu.getPhongChieu() == null || suatChieu.getPhongChieu().getMaPhongChieu() == null) {
            return "Phòng chiếu của suất chiếu không hợp lệ.";
        }

        if (suatChieu.getGiaVeCoBan() == null) {
            return "Giá vé cơ bản không được để trống.";
        }

        if (suatChieu.getGiaVeCoBan().compareTo(BigDecimal.ZERO) <= 0) {
            return "Giá vé cơ bản phải lớn hơn 0.";
        }

        if (suatChieu.getPhim() == null || suatChieu.getPhim().getMaPhim() == null) {
            return "Phim của suất chiếu không hợp lệ.";
        }

        Phim phim = phimDao.findById(suatChieu.getPhim().getMaPhim());
        if (phim == null) {
            return "Phim không tồn tại.";
        }

        if ("Ngừng chiếu".equalsIgnoreCase(phim.getTrangThaiPhim())) {
            return "Không thể tạo suất chiếu cho phim đã ngừng chiếu.";
        }

        if (phim.getThoiLuong() == null || phim.getThoiLuong() <= 0) {
            return "Thời lượng phim không hợp lệ.";
        }

        suatChieu.setPhim(phim);
        suatChieu.setTrangThaiSuatChieu(
                normalizeSuatChieuStatus(suatChieu.getTrangThaiSuatChieu()) == null
                        ? "Sắp chiếu"
                        : normalizeSuatChieuStatus(suatChieu.getTrangThaiSuatChieu())
        );

        if (!isCreate && suatChieuDao.findById(suatChieu.getMaSuatChieu()) == null) {
            return "Suất chiếu không tồn tại để cập nhật.";
        }

        if (isTrungLichPhong(suatChieu, phim.getThoiLuong())) {
            return "Suất chiếu bị trùng lịch với suất khác trong cùng phòng.";
        }

        return null;
    }

    private boolean isTrungLichPhong(SuatChieu suatChieuMoi, int thoiLuongPhut) {
        Integer maPhongChieu = suatChieuMoi.getPhongChieu() == null ? null : suatChieuMoi.getPhongChieu().getMaPhongChieu();
        if (maPhongChieu == null || suatChieuMoi.getNgayGioChieu() == null) {
            return false;
        }

        List<SuatChieu> cungPhongCungNgay = suatChieuDao.findByPhongAndNgay(maPhongChieu, suatChieuMoi.getNgayGioChieu().toLocalDate());

        LocalDateTime batDauMoi = suatChieuMoi.getNgayGioChieu();
        LocalDateTime ketThucMoi = batDauMoi.plusMinutes(thoiLuongPhut);

        for (SuatChieu hienCo : cungPhongCungNgay) {
            if ("Hủy".equalsIgnoreCase(hienCo.getTrangThaiSuatChieu())) {
                continue;
            }

            if (suatChieuMoi.getMaSuatChieu() != null && suatChieuMoi.getMaSuatChieu().equals(hienCo.getMaSuatChieu())) {
                continue;
            }

            if (hienCo.getPhim() == null || hienCo.getPhim().getThoiLuong() == null) {
                continue;
            }

            LocalDateTime batDauCu = hienCo.getNgayGioChieu();
            LocalDateTime ketThucCu = batDauCu.plusMinutes(hienCo.getPhim().getThoiLuong());

            boolean biChongLich = batDauMoi.isBefore(ketThucCu) && ketThucMoi.isAfter(batDauCu);
            if (biChongLich) {
                return true;
            }
        }

        return false;
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

    private String normalizeSuatChieuStatus(Object raw) {
        if (raw == null) {
            return null;
        }
        String value = raw.toString().trim();
        if (value.equalsIgnoreCase("Sắp chiếu") || value.equalsIgnoreCase("SAP_CHIEU")) return "Sắp chiếu";
        if (value.equalsIgnoreCase("Đang chiếu") || value.equalsIgnoreCase("DANG_CHIEU") || value.equalsIgnoreCase("DANG_MO_BAN")) return "Đang chiếu";
        if (value.equalsIgnoreCase("Đã chiếu") || value.equalsIgnoreCase("DA_CHIEU")) return "Đã chiếu";
        if (value.equalsIgnoreCase("Hủy") || value.equalsIgnoreCase("HUY")) return "Hủy";
        return value;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
