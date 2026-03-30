package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.LoaiVeDao;
import org.example.cinema_finale.dao.SuatChieuDao;
import org.example.cinema_finale.dao.VeDao;
import org.example.cinema_finale.entity.LoaiVe;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.entity.Ve;
import org.example.cinema_finale.enums.TrangThaiSuatChieu;
import org.example.cinema_finale.enums.TrangThaiVe;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.math.BigDecimal;
import java.util.List;

public class VeService {

    private final VeDao veDao;
    private final SuatChieuDao suatChieuDao;
    private final LoaiVeDao loaiVeDao;

    public VeService() {
        this.veDao = new VeDao();
        this.suatChieuDao = new SuatChieuDao();
        this.loaiVeDao = new LoaiVeDao();
    }

    public VeService(VeDao veDao, SuatChieuDao suatChieuDao, LoaiVeDao loaiVeDao) {
        this.veDao = veDao;
        this.suatChieuDao = suatChieuDao;
        this.loaiVeDao = loaiVeDao;
    }

    public List<Ve> getAllVe() {
        return veDao.findAll();
    }

    public Ve getVeById(String maVe) {
        if (isBlank(maVe)) {
            return null;
        }
        return veDao.findById(maVe.trim());
    }

    public List<Ve> getByMaSuatChieu(String maSuatChieu) {
        if (isBlank(maSuatChieu)) {
            return List.of();
        }
        return veDao.findByMaSuatChieu(maSuatChieu.trim());
    }

    public List<Ve> getAvailableByMaSuatChieu(String maSuatChieu) {
        if (isBlank(maSuatChieu)) {
            return List.of();
        }
        return veDao.findAvailableByMaSuatChieu(maSuatChieu.trim());
    }

    public List<Ve> getByMaSuatChieuAndTrangThai(String maSuatChieu, TrangThaiVe trangThaiVe) {
        if (isBlank(maSuatChieu) || trangThaiVe == null) {
            return List.of();
        }
        return veDao.findByMaSuatChieuAndTrangThai(maSuatChieu.trim(), trangThaiVe);
    }

    public String addVe(Ve ve) {
        AuthorizationUtil.requireStaff();

        String validation = validateVe(ve, true);
        if (validation != null) {
            return validation;
        }

        boolean result = veDao.save(ve);
        return result ? "Thêm vé thành công." : "Thêm vé thất bại.";
    }

    public String updateVe(Ve ve) {
        AuthorizationUtil.requireStaff();

        String validation = validateVe(ve, false);
        if (validation != null) {
            return validation;
        }

        boolean result = veDao.update(ve);
        return result ? "Cập nhật vé thành công." : "Cập nhật vé thất bại.";
    }

    public String cancelVe(String maVe) {
        AuthorizationUtil.requireStaff();

        if (isBlank(maVe)) {
            return "Mã vé không được để trống.";
        }

        Ve ve = veDao.findById(maVe.trim());
        if (ve == null) {
            return "Vé không tồn tại.";
        }

        boolean result = veDao.updateTrangThai(maVe.trim(), TrangThaiVe.DA_HUY);
        return result ? "Hủy vé thành công." : "Hủy vé thất bại.";
    }

    public String markAsSold(String maVe) {
        if (isBlank(maVe)) {
            return "Mã vé không được để trống.";
        }

        Ve ve = veDao.findById(maVe.trim());
        if (ve == null) {
            return "Vé không tồn tại.";
        }

        if (ve.getTrangThaiVe() != TrangThaiVe.CHUA_BAN) {
            return "Chỉ vé chưa bán mới có thể chuyển sang đã bán.";
        }

        boolean result = veDao.updateTrangThai(maVe.trim(), TrangThaiVe.DA_BAN);
        return result ? "Cập nhật trạng thái vé thành công." : "Cập nhật trạng thái vé thất bại.";
    }

    public String markAsUsed(String maVe) {
        AuthorizationUtil.requireStaff();

        if (isBlank(maVe)) {
            return "Mã vé không được để trống.";
        }

        Ve ve = veDao.findById(maVe.trim());
        if (ve == null) {
            return "Vé không tồn tại.";
        }

        if (ve.getTrangThaiVe() != TrangThaiVe.DA_BAN) {
            return "Chỉ vé đã bán mới có thể đánh dấu đã sử dụng.";
        }

        boolean result = veDao.updateTrangThai(maVe.trim(), TrangThaiVe.DA_SU_DUNG);
        return result ? "Đánh dấu vé đã sử dụng thành công." : "Cập nhật trạng thái vé thất bại.";
    }

    public String resetToAvailable(String maVe) {
        AuthorizationUtil.requireStaff();

        if (isBlank(maVe)) {
            return "Mã vé không được để trống.";
        }

        Ve ve = veDao.findById(maVe.trim());
        if (ve == null) {
            return "Vé không tồn tại.";
        }

        if (ve.getTrangThaiVe() == TrangThaiVe.DA_SU_DUNG) {
            return "Vé đã sử dụng không thể chuyển về chưa bán.";
        }

        boolean result = veDao.updateTrangThai(maVe.trim(), TrangThaiVe.CHUA_BAN);
        return result ? "Khôi phục vé về trạng thái chưa bán thành công."
                : "Cập nhật trạng thái vé thất bại.";
    }

    private String validateVe(Ve ve, boolean isCreate) {
        if (ve == null) {
            return "Dữ liệu vé không hợp lệ.";
        }

        if (isBlank(ve.getMaVe())) {
            return "Mã vé không được để trống.";
        }

        if (ve.getSuatChieu() == null || isBlank(ve.getSuatChieu().getMaSuatChieu())) {
            return "Suất chiếu của vé không hợp lệ.";
        }

        if (isBlank(ve.getMaGheNgoi())) {
            return "Mã ghế ngồi không được để trống.";
        }

        if (ve.getLoaiVe() == null || isBlank(ve.getLoaiVe().getMaLoaiVe())) {
            return "Loại vé không hợp lệ.";
        }

        if (ve.getTrangThaiVe() == null) {
            return "Trạng thái vé không được để trống.";
        }

        SuatChieu suatChieu = suatChieuDao.findById(ve.getSuatChieu().getMaSuatChieu().trim());
        if (suatChieu == null) {
            return "Suất chiếu không tồn tại.";
        }

        if (suatChieu.getTrangThaiSuatChieu() == TrangThaiSuatChieu.HUY
                || suatChieu.getTrangThaiSuatChieu() == TrangThaiSuatChieu.DA_CHIEU) {
            return "Không thể tạo hoặc cập nhật vé cho suất chiếu không còn hợp lệ.";
        }

        LoaiVe loaiVe = loaiVeDao.findById(ve.getLoaiVe().getMaLoaiVe().trim());
        if (loaiVe == null) {
            return "Loại vé không tồn tại.";
        }

        ve.setMaVe(ve.getMaVe().trim());
        ve.setMaGheNgoi(ve.getMaGheNgoi().trim());
        ve.setSuatChieu(suatChieu);
        ve.setLoaiVe(loaiVe);

        BigDecimal giaVeTinhToan = suatChieu.getGiaVeCoBan().add(loaiVe.getPhuThuGia());
        ve.setGiaVe(giaVeTinhToan);

        if (isCreate && veDao.existsById(ve.getMaVe())) {
            return "Mã vé đã tồn tại.";
        }

        if (!isCreate && veDao.findById(ve.getMaVe()) == null) {
            return "Vé không tồn tại để cập nhật.";
        }

        Ve veTrungGhe = veDao.findByMaSuatChieuAndMaGheNgoi(
                suatChieu.getMaSuatChieu(),
                ve.getMaGheNgoi()
        );

        if (veTrungGhe != null && !veTrungGhe.getMaVe().equals(ve.getMaVe())) {
            return "Ghế này trong suất chiếu đã có vé.";
        }

        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}