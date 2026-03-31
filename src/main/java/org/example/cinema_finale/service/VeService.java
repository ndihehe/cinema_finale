package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.LoaiVeDao;
import org.example.cinema_finale.dao.SuatChieuDao;
import org.example.cinema_finale.dao.VeDao;
import org.example.cinema_finale.entity.LoaiVe;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.entity.Ve;
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
        Integer id = parseId(maVe);
        return id == null ? null : veDao.findById(id);
    }

    public List<Ve> getByMaSuatChieu(String maSuatChieu) {
        Integer id = parseId(maSuatChieu);
        return id == null ? List.of() : veDao.findByMaSuatChieu(id);
    }

    public List<Ve> getAvailableByMaSuatChieu(String maSuatChieu) {
        Integer id = parseId(maSuatChieu);
        return id == null ? List.of() : veDao.findAvailableByMaSuatChieu(id);
    }

    public List<Ve> getByMaSuatChieuAndTrangThai(String maSuatChieu, Object trangThaiVe) {
        Integer id = parseId(maSuatChieu);
        String status = normalizeVeStatus(trangThaiVe);
        if (id == null || status == null) {
            return List.of();
        }
        return veDao.findByMaSuatChieuAndTrangThai(id, status);
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

        Integer id = parseId(maVe);
        if (id == null) {
            return "Mã vé không hợp lệ.";
        }

        Ve ve = veDao.findById(id);
        if (ve == null) {
            return "Vé không tồn tại.";
        }

        boolean result = veDao.updateTrangThai(id, "Đã hủy");
        return result ? "Hủy vé thành công." : "Hủy vé thất bại.";
    }

    public String markAsSold(String maVe) {
        Integer id = parseId(maVe);
        if (id == null) {
            return "Mã vé không hợp lệ.";
        }

        Ve ve = veDao.findById(id);
        if (ve == null) {
            return "Vé không tồn tại.";
        }

        if (!"Chưa bán".equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Chỉ vé chưa bán mới có thể chuyển sang đã bán.";
        }

        boolean result = veDao.updateTrangThai(id, "Đã bán");
        return result ? "Cập nhật trạng thái vé thành công." : "Cập nhật trạng thái vé thất bại.";
    }

    public String markAsUsed(String maVe) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maVe);
        if (id == null) {
            return "Mã vé không hợp lệ.";
        }

        Ve ve = veDao.findById(id);
        if (ve == null) {
            return "Vé không tồn tại.";
        }

        if (!"Đã bán".equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Chỉ vé đã bán mới có thể đánh dấu đã sử dụng.";
        }

        boolean result = veDao.updateTrangThai(id, "Đã sử dụng");
        return result ? "Đánh dấu vé đã sử dụng thành công." : "Cập nhật trạng thái vé thất bại.";
    }

    public String resetToAvailable(String maVe) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maVe);
        if (id == null) {
            return "Mã vé không hợp lệ.";
        }

        Ve ve = veDao.findById(id);
        if (ve == null) {
            return "Vé không tồn tại.";
        }

        if ("Đã sử dụng".equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Vé đã sử dụng không thể chuyển về chưa bán.";
        }

        boolean result = veDao.updateTrangThai(id, "Chưa bán");
        return result ? "Khôi phục vé về trạng thái chưa bán thành công." : "Cập nhật trạng thái vé thất bại.";
    }

    private String validateVe(Ve ve, boolean isCreate) {
        if (ve == null) {
            return "Dữ liệu vé không hợp lệ.";
        }

        if (!isCreate && ve.getMaVe() == null) {
            return "Mã vé không được để trống khi cập nhật.";
        }

        if (ve.getSuatChieu() == null || ve.getSuatChieu().getMaSuatChieu() == null) {
            return "Suất chiếu của vé không hợp lệ.";
        }

        if (ve.getGheNgoi() == null || ve.getGheNgoi().getMaGheNgoi() == null) {
            return "Ghế ngồi của vé không hợp lệ.";
        }

        if (ve.getLoaiVe() == null || ve.getLoaiVe().getMaLoaiVe() == null) {
            return "Loại vé không hợp lệ.";
        }

        SuatChieu suatChieu = suatChieuDao.findById(ve.getSuatChieu().getMaSuatChieu());
        if (suatChieu == null) {
            return "Suất chiếu không tồn tại.";
        }

        String trangThaiSuatChieu = suatChieu.getTrangThaiSuatChieu();
        if ("Hủy".equalsIgnoreCase(trangThaiSuatChieu) || "Đã chiếu".equalsIgnoreCase(trangThaiSuatChieu)) {
            return "Không thể tạo hoặc cập nhật vé cho suất chiếu không còn hợp lệ.";
        }

        LoaiVe loaiVe = loaiVeDao.findById(ve.getLoaiVe().getMaLoaiVe());
        if (loaiVe == null) {
            return "Loại vé không tồn tại.";
        }

        if (ve.getTrangThaiVe() == null || ve.getTrangThaiVe().trim().isEmpty()) {
            ve.setTrangThaiVe("Chưa bán");
        } else {
            ve.setTrangThaiVe(normalizeVeStatus(ve.getTrangThaiVe()));
        }

        ve.setSuatChieu(suatChieu);
        ve.setLoaiVe(loaiVe);

        BigDecimal giaVeTinhToan = suatChieu.getGiaVeCoBan().add(loaiVe.getPhuThuGia());
        ve.setGiaVe(giaVeTinhToan);

        if (!isCreate && veDao.findById(ve.getMaVe()) == null) {
            return "Vé không tồn tại để cập nhật.";
        }

        Ve veTrungGhe = veDao.findByMaSuatChieuAndMaGheNgoi(suatChieu.getMaSuatChieu(), ve.getGheNgoi().getMaGheNgoi());
        if (veTrungGhe != null) {
            if (isCreate || !veTrungGhe.getMaVe().equals(ve.getMaVe())) {
                return "Ghế này trong suất chiếu đã có vé.";
            }
        }

        return null;
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

    private String normalizeVeStatus(Object raw) {
        if (raw == null) {
            return null;
        }
        String value = raw.toString().trim();
        if (value.equalsIgnoreCase("Chưa bán") || value.equalsIgnoreCase("CHUA_BAN")) return "Chưa bán";
        if (value.equalsIgnoreCase("Đã bán") || value.equalsIgnoreCase("DA_BAN")) return "Đã bán";
        if (value.equalsIgnoreCase("Đã sử dụng") || value.equalsIgnoreCase("DA_SU_DUNG")) return "Đã sử dụng";
        if (value.equalsIgnoreCase("Đã hủy") || value.equalsIgnoreCase("DA_HUY") || value.equalsIgnoreCase("HUY")) return "Đã hủy";
        return value;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
