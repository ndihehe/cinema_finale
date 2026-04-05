package org.example.cinema_finale.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.example.cinema_finale.dao.ThongKeDoanhSoDao;
import org.example.cinema_finale.dto.ThongKeDoanhSoDTO;

public class ThongKeDoanhSoService {

    private static final LocalDateTime MYSQL_SAFE_MIN_DATETIME = LocalDateTime.of(1970, 1, 1, 0, 0, 0);

    private final ThongKeDoanhSoDao dao = new ThongKeDoanhSoDao();

    // ================= THEO NGÀY =================
    public List<ThongKeDoanhSoDTO> thongKeTheoNgay(LocalDate fromDate, LocalDate toDate){

        if (fromDate == null || toDate == null || fromDate.isAfter(toDate)) {
            return List.of();
        }

        LocalDateTime from = fromDate.atStartOfDay();
        LocalDateTime to = toDate.plusDays(1).atStartOfDay();

        List<Object[]> rows = dao.thongKeVeRaw(from, to);

        Map<String, ThongKeDoanhSoDTO> map = new LinkedHashMap<>();

        for (Object[] row : rows){
            LocalDateTime thoiGianThanhToan = toLocalDateTime(row[0]);
            if (thoiGianThanhToan == null) {
                continue;
            }
            BigDecimal doanhThu = toBigDecimal(row[1]);

            String ngay = thoiGianThanhToan.toLocalDate().toString();

            map.putIfAbsent(ngay,
                    new ThongKeDoanhSoDTO(ngay,0,
                            BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO));

            ThongKeDoanhSoDTO dto = map.get(ngay);

            dto.setSoLuongVeBan(dto.getSoLuongVeBan() + 1);
            dto.setTongDoanhThu(dto.getTongDoanhThu().add(doanhThu));
            dto.setDoanhThuThuan(dto.getTongDoanhThu());
        }

        return new ArrayList<>(map.values());
    }

    // ================= THEO THÁNG =================
    public List<ThongKeDoanhSoDTO> thongKeTheoThang(int year){

        if (year <= 0) {
            return List.of();
        }

        LocalDateTime from = LocalDate.of(year,1,1).atStartOfDay();
        LocalDateTime to = LocalDate.of(year+1,1,1).atStartOfDay();

        List<Object[]> rows = dao.thongKeVeRaw(from, to);

        Map<Integer, ThongKeDoanhSoDTO> map = new LinkedHashMap<>();

        for (Object[] row : rows){
            LocalDateTime thoiGianThanhToan = toLocalDateTime(row[0]);
            if (thoiGianThanhToan == null) {
                continue;
            }
            BigDecimal doanhThu = toBigDecimal(row[1]);

            int month = thoiGianThanhToan.getMonthValue();

            map.putIfAbsent(month,
                    new ThongKeDoanhSoDTO("Tháng "+month,0,
                            BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO));

            ThongKeDoanhSoDTO dto = map.get(month);

            dto.setSoLuongVeBan(dto.getSoLuongVeBan() + 1);
            dto.setTongDoanhThu(dto.getTongDoanhThu().add(doanhThu));
            dto.setDoanhThuThuan(dto.getTongDoanhThu());
        }

        return new ArrayList<>(map.values());
    }

    // ================= THEO PHIM =================
    public List<ThongKeDoanhSoDTO> thongKeTheoPhim(LocalDate from, LocalDate to){

        LocalDateTime fromDate = (from == null)
                ? MYSQL_SAFE_MIN_DATETIME
                : from.atStartOfDay();

        LocalDateTime toDate = (to == null)
                ? LocalDateTime.now()
                : to.atTime(23,59,59);

        if (!fromDate.isBefore(toDate)) {
            return List.of();
        }

        List<Object[]> rows = dao.thongKeTheoPhimRaw(fromDate, toDate);
        Map<String, ThongKeDoanhSoDTO> map = new LinkedHashMap<>();
        Map<Integer, BigDecimal> orderTicketRevenue = new LinkedHashMap<>();

        for (Object[] row : rows) {
            Integer maDonHang = toInteger(row[0]);
            BigDecimal ticketRevenueByMovie = toBigDecimal(row[3]);
            if (maDonHang == null) {
                continue;
            }
            orderTicketRevenue.put(maDonHang,
                    orderTicketRevenue.getOrDefault(maDonHang, BigDecimal.ZERO).add(ticketRevenueByMovie));
        }

        for (Object[] row : rows){
            Integer maDonHang = toInteger(row[0]);
            String phim = row[1] == null ? "Không rõ" : row[1].toString();
            Integer soVeObj = toInteger(row[2]);
            int soVe = soVeObj == null ? 0 : soVeObj;
            BigDecimal doanhThuVeTheoPhim = toBigDecimal(row[3]);
            BigDecimal tongTienSanPham = toBigDecimal(row[4]);
            BigDecimal soTienThanhToan = toBigDecimal(row[5]);

            BigDecimal tongTienVeDonHang = maDonHang == null
                    ? BigDecimal.ZERO
                    : orderTicketRevenue.getOrDefault(maDonHang, BigDecimal.ZERO);
            BigDecimal tongTienTruocGiam = tongTienVeDonHang.add(tongTienSanPham);
            BigDecimal giamGiaDonHang = tongTienTruocGiam.subtract(soTienThanhToan).max(BigDecimal.ZERO);

            BigDecimal giamGiaTheoPhim = BigDecimal.ZERO;
            if (giamGiaDonHang.compareTo(BigDecimal.ZERO) > 0 && tongTienVeDonHang.compareTo(BigDecimal.ZERO) > 0) {
                giamGiaTheoPhim = giamGiaDonHang
                        .multiply(doanhThuVeTheoPhim)
                        .divide(tongTienVeDonHang, 2, java.math.RoundingMode.HALF_UP);
            }

            map.putIfAbsent(phim,
                    new ThongKeDoanhSoDTO(phim,0,
                            BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO));

            ThongKeDoanhSoDTO dto = map.get(phim);

            dto.setSoLuongVeBan(dto.getSoLuongVeBan() + soVe);
            dto.setTongDoanhThu(dto.getTongDoanhThu().add(doanhThuVeTheoPhim));
            dto.setTongGiamGia(dto.getTongGiamGia().add(giamGiaTheoPhim));
            dto.setDoanhThuThuan(dto.getTongDoanhThu().subtract(dto.getTongGiamGia()).max(BigDecimal.ZERO));
        }

        return new ArrayList<>(map.values());
    }

    public Map<String, BigDecimal> thongKeDoanhThuTheoThuTrongTuan(String tenPhim, LocalDate from, LocalDate to) {
        Map<String, BigDecimal> result = initWeekdayMap();
        if (tenPhim == null || tenPhim.isBlank()) {
            return result;
        }

        LocalDateTime fromDate = (from == null)
                ? MYSQL_SAFE_MIN_DATETIME
                : from.atStartOfDay();

        LocalDateTime toDate = (to == null)
            ? LocalDateTime.now()
                : to.plusDays(1).atStartOfDay();

        if (!fromDate.isBefore(toDate)) {
            return result;
        }

        List<Object[]> rows = dao.thongKeTheoPhimVaThoiGianRaw(tenPhim, fromDate, toDate);
        for (Object[] row : rows) {
            LocalDateTime paidAt = toLocalDateTime(row[0]);
            if (paidAt == null) {
                continue;
            }

            String weekday = toVnWeekday(paidAt.getDayOfWeek());
            BigDecimal value = toBigDecimal(row[1]);
            result.put(weekday, result.get(weekday).add(value));
        }

        return result;
    }

    private Map<String, BigDecimal> initWeekdayMap() {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        map.put("Thứ 2", BigDecimal.ZERO);
        map.put("Thứ 3", BigDecimal.ZERO);
        map.put("Thứ 4", BigDecimal.ZERO);
        map.put("Thứ 5", BigDecimal.ZERO);
        map.put("Thứ 6", BigDecimal.ZERO);
        map.put("Thứ 7", BigDecimal.ZERO);
        map.put("CN", BigDecimal.ZERO);
        return map;
    }

    private String toVnWeekday(DayOfWeek dayOfWeek) {
        return switch (dayOfWeek) {
            case MONDAY -> "Thứ 2";
            case TUESDAY -> "Thứ 3";
            case WEDNESDAY -> "Thứ 4";
            case THURSDAY -> "Thứ 5";
            case FRIDAY -> "Thứ 6";
            case SATURDAY -> "Thứ 7";
            case SUNDAY -> "CN";
        };
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }

        if (value instanceof BigDecimal bigDecimal) {
            return normalizeMoney(bigDecimal);
        }

        if (value instanceof Number number) {
            return normalizeMoney(new BigDecimal(number.toString()));
        }

        return BigDecimal.ZERO;
    }

    private BigDecimal normalizeMoney(BigDecimal value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal normalized = value.setScale(2, RoundingMode.HALF_UP);
        if (normalized.abs().compareTo(new BigDecimal("0.005")) < 0) {
            return BigDecimal.ZERO;
        }
        return normalized;
    }

    private Integer toInteger(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof Integer integer) {
            return integer;
        }
        if (value instanceof Number number) {
            return number.intValue();
        }
        try {
            return Integer.valueOf(value.toString());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private LocalDateTime toLocalDateTime(Object value) {
        if (value == null) {
            return null;
        }

        if (value instanceof LocalDateTime localDateTime) {
            return localDateTime;
        }

        if (value instanceof Timestamp timestamp) {
            return timestamp.toLocalDateTime();
        }

        if (value instanceof java.util.Date date) {
            return LocalDateTime.ofInstant(date.toInstant(), java.time.ZoneId.systemDefault());
        }

        return null;
    }
}