package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.dao.SuatChieuDao;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.enums.TrangThaiPhim;
import org.example.cinema_finale.enums.TrangThaiSuatChieu;
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
        if (isBlank(maSuatChieu)) {
            return null;
        }
        return suatChieuDao.findById(maSuatChieu.trim());
    }

    public List<SuatChieu> getByMaPhim(String maPhim) {
        if (isBlank(maPhim)) {
            return List.of();
        }
        return suatChieuDao.findByMaPhim(maPhim.trim());
    }

    public List<SuatChieu> getByNgay(LocalDate ngay) {
        if (ngay == null) {
            return List.of();
        }
        return suatChieuDao.findByNgay(ngay);
    }

    public List<SuatChieu> getByPhongAndNgay(String maPhongChieu, LocalDate ngay) {
        if (isBlank(maPhongChieu) || ngay == null) {
            return List.of();
        }
        return suatChieuDao.findByPhongAndNgay(maPhongChieu.trim(), ngay);
    }

    public List<SuatChieu> getByTrangThai(TrangThaiSuatChieu trangThaiSuatChieu) {
        if (trangThaiSuatChieu == null) {
            return List.of();
        }
        return suatChieuDao.findByTrangThai(trangThaiSuatChieu);
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

    /**
     * Giữ tên hàm cũ để UI/controller cũ ít bị vỡ.
     * Thực tế là hủy suất chiếu chứ không xóa cứng.
     */
    public String deleteSuatChieu(String maSuatChieu) {
        return cancelSuatChieu(maSuatChieu);
    }

    public String cancelSuatChieu(String maSuatChieu) {
        AuthorizationUtil.requireStaff();

        if (isBlank(maSuatChieu)) {
            return "Mã suất chiếu không được để trống.";
        }

        SuatChieu suatChieu = suatChieuDao.findById(maSuatChieu.trim());
        if (suatChieu == null) {
            return "Suất chiếu không tồn tại.";
        }

        boolean result = suatChieuDao.updateTrangThai(maSuatChieu.trim(), TrangThaiSuatChieu.HUY);
        return result ? "Hủy suất chiếu thành công." : "Hủy suất chiếu thất bại.";
    }

    public String updateTrangThai(String maSuatChieu, TrangThaiSuatChieu trangThaiSuatChieu) {
        AuthorizationUtil.requireStaff();

        if (isBlank(maSuatChieu)) {
            return "Mã suất chiếu không được để trống.";
        }

        if (trangThaiSuatChieu == null) {
            return "Trạng thái suất chiếu không hợp lệ.";
        }

        SuatChieu suatChieu = suatChieuDao.findById(maSuatChieu.trim());
        if (suatChieu == null) {
            return "Suất chiếu không tồn tại.";
        }

        boolean result = suatChieuDao.updateTrangThai(maSuatChieu.trim(), trangThaiSuatChieu);
        return result ? "Cập nhật trạng thái suất chiếu thành công."
                : "Cập nhật trạng thái suất chiếu thất bại.";
    }

    private String validateSuatChieu(SuatChieu suatChieu, boolean isCreate) {
        if (suatChieu == null) {
            return "Dữ liệu suất chiếu không hợp lệ.";
        }

        if (isBlank(suatChieu.getMaSuatChieu())) {
            return "Mã suất chiếu không được để trống.";
        }

        if (suatChieu.getNgayGioChieu() == null) {
            return "Ngày giờ chiếu không được để trống.";
        }

        if (isCreate && suatChieu.getNgayGioChieu().isBefore(LocalDateTime.now())) {
            return "Không thể tạo suất chiếu trong quá khứ.";
        }

        if (isBlank(suatChieu.getMaPhongChieu())) {
            return "Mã phòng chiếu không được để trống.";
        }

        if (suatChieu.getGiaVeCoBan() == null) {
            return "Giá vé cơ bản không được để trống.";
        }

        if (suatChieu.getGiaVeCoBan().compareTo(BigDecimal.ZERO) <= 0) {
            return "Giá vé cơ bản phải lớn hơn 0.";
        }

        if (suatChieu.getTrangThaiSuatChieu() == null) {
            return "Trạng thái suất chiếu không được để trống.";
        }

        if (suatChieu.getPhim() == null || isBlank(suatChieu.getPhim().getMaPhim())) {
            return "Phim của suất chiếu không hợp lệ.";
        }

        Phim phim = phimDao.findById(suatChieu.getPhim().getMaPhim().trim());
        if (phim == null) {
            return "Phim không tồn tại.";
        }

        if (phim.getTrangThaiPhim() == TrangThaiPhim.NGUNG_CHIEU) {
            return "Không thể tạo suất chiếu cho phim đã ngừng chiếu.";
        }

        if (phim.getThoiLuong() == null || phim.getThoiLuong() <= 0) {
            return "Thời lượng phim không hợp lệ.";
        }

        suatChieu.setMaSuatChieu(suatChieu.getMaSuatChieu().trim());
        suatChieu.setMaPhongChieu(suatChieu.getMaPhongChieu().trim());
        suatChieu.setPhim(phim);

        if (isCreate && suatChieuDao.existsById(suatChieu.getMaSuatChieu())) {
            return "Mã suất chiếu đã tồn tại.";
        }

        if (!isCreate && suatChieuDao.findById(suatChieu.getMaSuatChieu()) == null) {
            return "Suất chiếu không tồn tại để cập nhật.";
        }

        if (isTrungLichPhong(suatChieu, phim.getThoiLuong())) {
            return "Suất chiếu bị trùng lịch với suất khác trong cùng phòng.";
        }

        return null;
    }

    private boolean isTrungLichPhong(SuatChieu suatChieuMoi, int thoiLuongPhut) {
        List<SuatChieu> cungPhongCungNgay = suatChieuDao.findByPhongAndNgay(
                suatChieuMoi.getMaPhongChieu(),
                suatChieuMoi.getNgayGioChieu().toLocalDate()
        );

        LocalDateTime batDauMoi = suatChieuMoi.getNgayGioChieu();
        LocalDateTime ketThucMoi = batDauMoi.plusMinutes(thoiLuongPhut);

        for (SuatChieu hienCo : cungPhongCungNgay) {
            if (hienCo.getTrangThaiSuatChieu() == TrangThaiSuatChieu.HUY) {
                continue;
            }

            if (hienCo.getMaSuatChieu().equals(suatChieuMoi.getMaSuatChieu())) {
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}