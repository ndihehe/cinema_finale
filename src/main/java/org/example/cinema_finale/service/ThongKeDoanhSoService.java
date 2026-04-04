package org.example.cinema_finale.service;

import java.math.BigDecimal;
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

    private ThongKeDoanhSoDao dao = new ThongKeDoanhSoDao();

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
            LocalDateTime thoiGianThanhToan = (LocalDateTime) row[1];
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
            LocalDateTime thoiGianThanhToan = (LocalDateTime) row[1];
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

        for (Object[] row : rows){
            String phim = row[0] == null ? "Không rõ" : row[0].toString();
            BigDecimal donGiaBan = toBigDecimal(row[1]);

            map.putIfAbsent(phim,
                    new ThongKeDoanhSoDTO(phim,0,
                            BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO));

            ThongKeDoanhSoDTO dto = map.get(phim);

            dto.setSoLuongVeBan(dto.getSoLuongVeBan()+1);
            dto.setTongDoanhThu(dto.getTongDoanhThu().add(donGiaBan));
            dto.setDoanhThuThuan(dto.getTongDoanhThu());
        }

        return new ArrayList<>(map.values());
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }

        if (value instanceof BigDecimal bigDecimal) {
            return bigDecimal;
        }

        if (value instanceof Number number) {
            return BigDecimal.valueOf(number.doubleValue());
        }

        return BigDecimal.ZERO;
    }
}