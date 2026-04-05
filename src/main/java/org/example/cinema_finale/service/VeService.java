package org.example.cinema_finale.service;

import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import org.example.cinema_finale.dao.LoaiVeDao;
import org.example.cinema_finale.dao.SuatChieuDao;
import org.example.cinema_finale.dao.VeDao;
import org.example.cinema_finale.dto.VeDTO;
import org.example.cinema_finale.dto.VeFormDTO;
import org.example.cinema_finale.entity.GheNgoi;
import org.example.cinema_finale.entity.LoaiVe;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.entity.PhongChieu;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.entity.Ve;
import org.example.cinema_finale.util.AuthorizationUtil;

public class VeService {

    private static final String STATUS_CHUA_BAN = "Chưa bán";
    private static final String STATUS_DA_BAN = "Đã bán";
    private static final String STATUS_DA_SU_DUNG = "Đã sử dụng";
    private static final String STATUS_DA_HUY = "Đã hủy";

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

    /* =========================
       READ -> DTO
       ========================= */

    public List<VeDTO> getAllVe() {
        AuthorizationUtil.requireStaff();
        return veDao.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public VeDTO getVeById(String maVe) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maVe);
        if (id == null) {
            return null;
        }

        Ve ve = veDao.findById(id);
        return ve == null ? null : toDTO(ve);
    }

    public List<VeDTO> getByMaSuatChieu(String maSuatChieu) {
        AuthorizationUtil.requireStaffOrCustomer();

        Integer id = parseId(maSuatChieu);
        if (id == null) {
            return List.of();
        }

        return veDao.findByMaSuatChieu(id).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<VeDTO> getAvailableByMaSuatChieu(String maSuatChieu) {
        AuthorizationUtil.requireStaffOrCustomer();

        Integer id = parseId(maSuatChieu);
        if (id == null) {
            return List.of();
        }

        return veDao.findAvailableByMaSuatChieu(id).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<VeDTO> getByMaSuatChieuAndTrangThai(String maSuatChieu, Object trangThaiVe) {
        AuthorizationUtil.requireStaffOrCustomer();

        Integer id = parseId(maSuatChieu);
        String status = normalizeVeStatus(trangThaiVe);

        if (id == null || status == null) {
            return List.of();
        }

        return veDao.findByMaSuatChieuAndTrangThai(id, status).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    /* =========================
       WRITE <- FORM DTO
       ========================= */

    public String addVe(VeFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        Ve ve = buildEntityFromForm(formDTO, true);
        String validation = validateVe(ve, true);
        if (validation != null) {
            return validation;
        }

        boolean result = veDao.save(ve);
        return result ? "Thêm vé thành công." : "Thêm vé thất bại.";
    }

    public String updateVe(VeFormDTO formDTO) {
        AuthorizationUtil.requireStaff();

        if (formDTO == null || formDTO.getMaVe() == null) {
            return "Mã vé không hợp lệ.";
        }

        Ve ve = buildEntityFromForm(formDTO, false);
        String validation = validateVe(ve, false);
        if (validation != null) {
            return validation;
        }

        boolean result = veDao.update(ve);
        return result ? "Cập nhật vé thành công." : "Cập nhật vé thất bại.";
    }

    /* =========================
       STATUS ACTIONS
       ========================= */

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

        if (STATUS_DA_HUY.equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Vé này đã ở trạng thái hủy.";
        }

        if (STATUS_DA_SU_DUNG.equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Không thể hủy vé đã sử dụng.";
        }

        if (STATUS_DA_BAN.equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Vé đã bán không được hủy trực tiếp. Hãy xử lý qua luồng hoàn tiền hoặc hủy đơn.";
        }

        boolean result = veDao.updateTrangThai(id, STATUS_DA_HUY);
        return result ? "Hủy vé thành công." : "Hủy vé thất bại.";
    }

    public String markAsSold(String maVe) {
        AuthorizationUtil.requireStaff();

        Integer id = parseId(maVe);
        if (id == null) {
            return "Mã vé không hợp lệ.";
        }

        Ve ve = veDao.findById(id);
        if (ve == null) {
            return "Vé không tồn tại.";
        }

        if (!STATUS_CHUA_BAN.equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Chỉ vé chưa bán mới có thể chuyển sang đã bán.";
        }

        boolean result = veDao.updateTrangThai(id, STATUS_DA_BAN);
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

        if (!STATUS_DA_BAN.equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Chỉ vé đã bán mới có thể đánh dấu đã sử dụng.";
        }

        boolean result = veDao.updateTrangThai(id, STATUS_DA_SU_DUNG);
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

        if (STATUS_DA_SU_DUNG.equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Vé đã sử dụng không thể chuyển về chưa bán.";
        }

        if (STATUS_DA_BAN.equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Vé đã bán không thể chuyển trực tiếp về chưa bán.";
        }

        if (!STATUS_DA_HUY.equalsIgnoreCase(ve.getTrangThaiVe())) {
            return "Chỉ vé đã hủy mới có thể khôi phục về chưa bán.";
        }

        boolean result = veDao.updateTrangThai(id, STATUS_CHUA_BAN);
        return result ? "Khôi phục vé về trạng thái chưa bán thành công." : "Cập nhật trạng thái vé thất bại.";
    }

    /* =========================
       VALIDATION
       ========================= */

    private String validateVe(Ve ve, boolean isCreate) {
        if (ve == null) {
            return "Dữ liệu vé không hợp lệ.";
        }

        Ve existing = null;
        if (!isCreate) {
            if (ve.getMaVe() == null) {
                return "Mã vé không được để trống khi cập nhật.";
            }

            existing = veDao.findById(ve.getMaVe());
            if (existing == null) {
                return "Vé không tồn tại để cập nhật.";
            }

            if (STATUS_DA_BAN.equalsIgnoreCase(existing.getTrangThaiVe())
                    || STATUS_DA_SU_DUNG.equalsIgnoreCase(existing.getTrangThaiVe())) {
                return "Không thể cập nhật vé đã bán hoặc đã sử dụng.";
            }
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

        if (isBlank(ve.getTrangThaiVe())) {
            if (isCreate) {
                ve.setTrangThaiVe(STATUS_CHUA_BAN);
            } else {
                ve.setTrangThaiVe(existing != null ? existing.getTrangThaiVe() : STATUS_CHUA_BAN);
            }
        } else {
            String normalizedStatus = normalizeVeStatus(ve.getTrangThaiVe());
            if (normalizedStatus == null) {
                return "Trạng thái vé không hợp lệ.";
            }
            ve.setTrangThaiVe(normalizedStatus);
        }

        ve.setSuatChieu(suatChieu);
        ve.setLoaiVe(loaiVe);

        BigDecimal giaVeCoBan = suatChieu.getGiaVeCoBan() == null ? BigDecimal.ZERO : suatChieu.getGiaVeCoBan();
        BigDecimal phuThuGia = loaiVe.getPhuThuGia() == null ? BigDecimal.ZERO : loaiVe.getPhuThuGia();
        ve.setGiaVe(giaVeCoBan.add(phuThuGia));

        Ve veTrungGhe = veDao.findByMaSuatChieuAndMaGheNgoi(
                suatChieu.getMaSuatChieu(),
                ve.getGheNgoi().getMaGheNgoi()
        );

        if (veTrungGhe != null) {
            if (isCreate || !veTrungGhe.getMaVe().equals(ve.getMaVe())) {
                return "Ghế này trong suất chiếu đã có vé.";
            }
        }

        return null;
    }

    /* =========================
       DTO MAPPING
       ========================= */

    private Ve buildEntityFromForm(VeFormDTO formDTO, boolean isCreate) {
        if (formDTO == null) {
            return null;
        }

        Ve ve;
        if (isCreate) {
            ve = new Ve();
        } else {
            ve = veDao.findById(formDTO.getMaVe());
            if (ve == null) {
                return null;
            }
        }

        if (formDTO.getMaVe() != null) {
            ve.setMaVe(formDTO.getMaVe());
        }

        if (formDTO.getMaSuatChieu() != null) {
            SuatChieu suatChieu = new SuatChieu();
            suatChieu.setMaSuatChieu(formDTO.getMaSuatChieu());
            ve.setSuatChieu(suatChieu);
        }

        if (formDTO.getMaGheNgoi() != null) {
            GheNgoi gheNgoi = new GheNgoi();
            gheNgoi.setMaGheNgoi(formDTO.getMaGheNgoi());
            ve.setGheNgoi(gheNgoi);
        }

        if (formDTO.getMaLoaiVe() != null) {
            LoaiVe loaiVe = new LoaiVe();
            loaiVe.setMaLoaiVe(formDTO.getMaLoaiVe());
            ve.setLoaiVe(loaiVe);
        }

        ve.setTrangThaiVe(trimToNull(formDTO.getTrangThaiVe()));
        return ve;
    }

    private VeDTO toDTO(Ve ve) {
        VeDTO dto = new VeDTO();

        dto.setMaVe(ve.getMaVe());
        dto.setGiaVe(ve.getGiaVe());
        dto.setTrangThaiVe(ve.getTrangThaiVe());

        if (ve.getSuatChieu() != null) {
            dto.setMaSuatChieu(ve.getSuatChieu().getMaSuatChieu());

            SuatChieu suatChieu = ve.getSuatChieu();

            if (suatChieu.getPhongChieu() != null) {
                PhongChieu phongChieu = suatChieu.getPhongChieu();
                dto.setTenPhongChieu(readString(
                        tryGet(phongChieu, "getTenPhongChieu"),
                        tryGet(phongChieu, "getTenPhong"),
                        tryGet(phongChieu, "getMaPhongChieu")
                ));
            }

            if (suatChieu.getPhim() != null) {
                Phim phim = suatChieu.getPhim();
                dto.setTenPhim(readString(
                        tryGet(phim, "getTenPhim"),
                        tryGet(phim, "getTieuDe"),
                        tryGet(phim, "getMaPhim")
                ));
            }

            if (suatChieu.getNgayGioChieu() != null) {
                dto.setNgayGioChieu(
                        suatChieu.getNgayGioChieu().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                );
            }
        }

        if (ve.getGheNgoi() != null) {
            dto.setMaGheNgoi(ve.getGheNgoi().getMaGheNgoi());
            String hang = readString(tryGet(ve.getGheNgoi(), "getHangGhe"));
            String so = readString(tryGet(ve.getGheNgoi(), "getSoGhe"));
            if (hang != null && so != null) {
                dto.setViTriGhe(hang.trim().toUpperCase() + so.trim());
            } else {
                dto.setViTriGhe(readString(
                        tryGet(ve.getGheNgoi(), "getSoGhe"),
                        tryGet(ve.getGheNgoi(), "getTenGhe"),
                        tryGet(ve.getGheNgoi(), "getViTriGhe"),
                        tryGet(ve.getGheNgoi(), "getMaGheNgoi")
                ));
            }
        }

        if (ve.getLoaiVe() != null) {
            dto.setMaLoaiVe(ve.getLoaiVe().getMaLoaiVe());
            dto.setTenLoaiVe(readString(
                    tryGet(ve.getLoaiVe(), "getTenLoaiVe"),
                    tryGet(ve.getLoaiVe(), "getLoaiVe"),
                    tryGet(ve.getLoaiVe(), "getMaLoaiVe")
            ));
        }

        return dto;
    }

    private Object tryGet(Object target, String methodName) {
        try {
            return target.getClass().getMethod(methodName).invoke(target);
        } catch (ReflectiveOperationException | RuntimeException e) {
            return null;
        }
    }

    private String readString(Object... candidates) {
        for (Object candidate : candidates) {
            if (candidate != null) {
                String value = candidate.toString().trim();
                if (!value.isEmpty()) {
                    return value;
                }
            }
        }
        return null;
    }

    /* =========================
       HELPERS
       ========================= */

    private Integer parseId(String value) {
        if (isBlank(value)) {
            return null;
        }
        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String normalizeVeStatus(Object raw) {
        if (raw == null) {
            return null;
        }

        String value = raw.toString().trim();

        if (value.equalsIgnoreCase("Chưa bán") || value.equalsIgnoreCase("CHUA_BAN")) {
            return STATUS_CHUA_BAN;
        }
        if (value.equalsIgnoreCase("Đã bán") || value.equalsIgnoreCase("DA_BAN")) {
            return STATUS_DA_BAN;
        }
        if (value.equalsIgnoreCase("Đã sử dụng") || value.equalsIgnoreCase("DA_SU_DUNG")) {
            return STATUS_DA_SU_DUNG;
        }
        if (value.equalsIgnoreCase("Đã hủy") || value.equalsIgnoreCase("DA_HUY") || value.equalsIgnoreCase("HUY")) {
            return STATUS_DA_HUY;
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