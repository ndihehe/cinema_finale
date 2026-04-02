package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.ThongKeDoanhSoDao;
import org.example.cinema_finale.dto.ThongKeDoanhSoDTO;
import org.example.cinema_finale.entity.ChiTietDonHangVe;
import org.example.cinema_finale.entity.DonHang;
import org.example.cinema_finale.entity.KhuyenMai;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.entity.PhongChieu;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.entity.ThanhToan;
import org.example.cinema_finale.entity.Ve;
import org.example.cinema_finale.util.AuthorizationUtil;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class ThongKeDoanhSoService {

    private static final String PAYMENT_THANH_CONG = "Thành công";
    private static final BigDecimal ONE_HUNDRED = new BigDecimal("100");

    private final ThongKeDoanhSoDao thongKeDoanhSoDao;

    public ThongKeDoanhSoService() {
        this.thongKeDoanhSoDao = new ThongKeDoanhSoDao();
    }

    public ThongKeDoanhSoService(ThongKeDoanhSoDao thongKeDoanhSoDao) {
        this.thongKeDoanhSoDao = thongKeDoanhSoDao;
    }

    public List<ThongKeDoanhSoDTO> thongKeTheoNgay(LocalDate tuNgay, LocalDate denNgay) {
        AuthorizationUtil.requireStaff();

        if (tuNgay == null || denNgay == null || tuNgay.isAfter(denNgay)) {
            return List.of();
        }

        LocalDateTime tuThoiGian = tuNgay.atStartOfDay();
        LocalDateTime denThoiGian = denNgay.plusDays(1).atStartOfDay();

        List<DonHang> donHangs = thongKeDoanhSoDao.findDonHangDaThanhToanTrongKhoang(tuThoiGian, denThoiGian);
        Map<String, Bucket> buckets = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        for (DonHang donHang : donHangs) {
            ThanhToan thanhToan = timThanhToanThanhCongTrongKhoang(donHang, tuThoiGian, denThoiGian);
            if (thanhToan == null) {
                continue;
            }

            String nhan = thanhToan.getThoiGianThanhToan().toLocalDate().format(formatter);
            Bucket bucket = buckets.computeIfAbsent(nhan, k -> new Bucket());

            BigDecimal tongDoanhThuDonHang = tinhTongDoanhThuDonHang(donHang);
            BigDecimal tongGiamGiaDonHang = tinhTongGiamGiaDonHang(donHang, tongDoanhThuDonHang);
            int soLuongVe = layDanhSachChiTietHopLe(donHang).size();

            bucket.soLuongVeBan += soLuongVe;
            bucket.tongDoanhThu = bucket.tongDoanhThu.add(tongDoanhThuDonHang);
            bucket.tongGiamGia = bucket.tongGiamGia.add(tongGiamGiaDonHang);
        }

        return toDTOList(buckets);
    }

    public List<ThongKeDoanhSoDTO> thongKeTheoThang(int nam) {
        AuthorizationUtil.requireStaff();

        if (nam <= 0) {
            return List.of();
        }

        LocalDateTime tuThoiGian = LocalDate.of(nam, 1, 1).atStartOfDay();
        LocalDateTime denThoiGian = LocalDate.of(nam + 1, 1, 1).atStartOfDay();

        List<DonHang> donHangs = thongKeDoanhSoDao.findDonHangDaThanhToanTrongKhoang(tuThoiGian, denThoiGian);
        Map<String, Bucket> buckets = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/yyyy");

        for (DonHang donHang : donHangs) {
            ThanhToan thanhToan = timThanhToanThanhCongTrongKhoang(donHang, tuThoiGian, denThoiGian);
            if (thanhToan == null) {
                continue;
            }

            String nhan = YearMonth.from(thanhToan.getThoiGianThanhToan()).format(formatter);
            Bucket bucket = buckets.computeIfAbsent(nhan, k -> new Bucket());

            BigDecimal tongDoanhThuDonHang = tinhTongDoanhThuDonHang(donHang);
            BigDecimal tongGiamGiaDonHang = tinhTongGiamGiaDonHang(donHang, tongDoanhThuDonHang);
            int soLuongVe = layDanhSachChiTietHopLe(donHang).size();

            bucket.soLuongVeBan += soLuongVe;
            bucket.tongDoanhThu = bucket.tongDoanhThu.add(tongDoanhThuDonHang);
            bucket.tongGiamGia = bucket.tongGiamGia.add(tongGiamGiaDonHang);
        }

        return toDTOList(buckets);
    }

    public List<ThongKeDoanhSoDTO> thongKeTheoPhim(LocalDate tuNgay, LocalDate denNgay) {
        AuthorizationUtil.requireStaff();

        if (tuNgay == null || denNgay == null || tuNgay.isAfter(denNgay)) {
            return List.of();
        }

        LocalDateTime tuThoiGian = tuNgay.atStartOfDay();
        LocalDateTime denThoiGian = denNgay.plusDays(1).atStartOfDay();

        List<DonHang> donHangs = thongKeDoanhSoDao.findDonHangDaThanhToanTrongKhoang(tuThoiGian, denThoiGian);
        Map<String, Bucket> buckets = new LinkedHashMap<>();

        for (DonHang donHang : donHangs) {
            ThanhToan thanhToan = timThanhToanThanhCongTrongKhoang(donHang, tuThoiGian, denThoiGian);
            if (thanhToan == null) {
                continue;
            }

            List<ChiTietDonHangVe> chiTietList = layDanhSachChiTietHopLe(donHang);
            BigDecimal tongDoanhThuDonHang = tinhTongDoanhThuDonHang(donHang);
            BigDecimal tongGiamGiaDonHang = tinhTongGiamGiaDonHang(donHang, tongDoanhThuDonHang);

            for (ChiTietDonHangVe chiTiet : chiTietList) {
                Ve ve = chiTiet.getVe();
                SuatChieu suatChieu = ve.getSuatChieu();
                Phim phim = suatChieu == null ? null : suatChieu.getPhim();

                String nhan = (phim == null || phim.getTenPhim() == null || phim.getTenPhim().trim().isEmpty())
                        ? "Không xác định"
                        : phim.getTenPhim().trim();

                Bucket bucket = buckets.computeIfAbsent(nhan, k -> new Bucket());

                BigDecimal doanhThuVe = safeMoney(chiTiet.getDonGiaBan());
                BigDecimal giamGiaPhanBo = phanBoGiamGia(tongGiamGiaDonHang, tongDoanhThuDonHang, doanhThuVe);

                bucket.soLuongVeBan += 1;
                bucket.tongDoanhThu = bucket.tongDoanhThu.add(doanhThuVe);
                bucket.tongGiamGia = bucket.tongGiamGia.add(giamGiaPhanBo);
            }
        }

        return toDTOList(buckets);
    }

    public List<ThongKeDoanhSoDTO> thongKeTheoPhong(LocalDate tuNgay, LocalDate denNgay) {
        AuthorizationUtil.requireStaff();

        if (tuNgay == null || denNgay == null || tuNgay.isAfter(denNgay)) {
            return List.of();
        }

        LocalDateTime tuThoiGian = tuNgay.atStartOfDay();
        LocalDateTime denThoiGian = denNgay.plusDays(1).atStartOfDay();

        List<DonHang> donHangs = thongKeDoanhSoDao.findDonHangDaThanhToanTrongKhoang(tuThoiGian, denThoiGian);
        Map<String, Bucket> buckets = new LinkedHashMap<>();

        for (DonHang donHang : donHangs) {
            ThanhToan thanhToan = timThanhToanThanhCongTrongKhoang(donHang, tuThoiGian, denThoiGian);
            if (thanhToan == null) {
                continue;
            }

            List<ChiTietDonHangVe> chiTietList = layDanhSachChiTietHopLe(donHang);
            BigDecimal tongDoanhThuDonHang = tinhTongDoanhThuDonHang(donHang);
            BigDecimal tongGiamGiaDonHang = tinhTongGiamGiaDonHang(donHang, tongDoanhThuDonHang);

            for (ChiTietDonHangVe chiTiet : chiTietList) {
                Ve ve = chiTiet.getVe();
                SuatChieu suatChieu = ve.getSuatChieu();
                PhongChieu phongChieu = suatChieu == null ? null : suatChieu.getPhongChieu();

                String nhan = (phongChieu == null || phongChieu.getTenPhongChieu() == null || phongChieu.getTenPhongChieu().trim().isEmpty())
                        ? "Không xác định"
                        : phongChieu.getTenPhongChieu().trim();

                Bucket bucket = buckets.computeIfAbsent(nhan, k -> new Bucket());

                BigDecimal doanhThuVe = safeMoney(chiTiet.getDonGiaBan());
                BigDecimal giamGiaPhanBo = phanBoGiamGia(tongGiamGiaDonHang, tongDoanhThuDonHang, doanhThuVe);

                bucket.soLuongVeBan += 1;
                bucket.tongDoanhThu = bucket.tongDoanhThu.add(doanhThuVe);
                bucket.tongGiamGia = bucket.tongGiamGia.add(giamGiaPhanBo);
            }
        }

        return toDTOList(buckets);
    }

    private ThanhToan timThanhToanThanhCongTrongKhoang(DonHang donHang, LocalDateTime tu, LocalDateTime den) {
        if (donHang == null || donHang.getThanhToans() == null) {
            return null;
        }

        for (Object obj : donHang.getThanhToans()) {
            if (!(obj instanceof ThanhToan thanhToan)) {
                continue;
            }

            if (!PAYMENT_THANH_CONG.equalsIgnoreCase(thanhToan.getTrangThaiThanhToan())) {
                continue;
            }

            if (thanhToan.getThoiGianThanhToan() == null) {
                continue;
            }

            if (!thanhToan.getThoiGianThanhToan().isBefore(tu)
                    && thanhToan.getThoiGianThanhToan().isBefore(den)) {
                return thanhToan;
            }
        }

        return null;
    }

    private List<ChiTietDonHangVe> layDanhSachChiTietHopLe(DonHang donHang) {
        List<ChiTietDonHangVe> result = new ArrayList<>();
        if (donHang == null || donHang.getChiTietDonHangVes() == null) {
            return result;
        }

        Set<Integer> daCo = new HashSet<>();

        for (Object obj : donHang.getChiTietDonHangVes()) {
            if (!(obj instanceof ChiTietDonHangVe chiTiet)) {
                continue;
            }

            if (chiTiet.getMaChiTietVe() != null && !daCo.add(chiTiet.getMaChiTietVe())) {
                continue;
            }

            if (chiTiet.getVe() == null || chiTiet.getDonGiaBan() == null) {
                continue;
            }

            result.add(chiTiet);
        }

        return result;
    }

    private BigDecimal tinhTongDoanhThuDonHang(DonHang donHang) {
        BigDecimal tong = BigDecimal.ZERO;
        for (ChiTietDonHangVe chiTiet : layDanhSachChiTietHopLe(donHang)) {
            tong = tong.add(safeMoney(chiTiet.getDonGiaBan()));
        }
        return tong;
    }

    private BigDecimal tinhTongGiamGiaDonHang(DonHang donHang, BigDecimal tongDoanhThuDonHang) {
        if (donHang == null || donHang.getKhuyenMai() == null) {
            return BigDecimal.ZERO;
        }

        KhuyenMai khuyenMai = donHang.getKhuyenMai();

        if (khuyenMai.getGiaTri() == null || khuyenMai.getGiaTri().compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal donHangToiThieu = safeMoney(khuyenMai.getDonHangToiThieu());
        if (tongDoanhThuDonHang.compareTo(donHangToiThieu) < 0) {
            return BigDecimal.ZERO;
        }

        String kieuGiaTri = khuyenMai.getKieuGiaTri() == null ? "" : khuyenMai.getKieuGiaTri().trim();

        BigDecimal giamGia;
        if (kieuGiaTri.equalsIgnoreCase("%")
                || kieuGiaTri.equalsIgnoreCase("PHAN_TRAM")
                || kieuGiaTri.equalsIgnoreCase("PERCENT")) {
            giamGia = tongDoanhThuDonHang
                    .multiply(khuyenMai.getGiaTri())
                    .divide(ONE_HUNDRED, 2, RoundingMode.HALF_UP);
        } else {
            giamGia = khuyenMai.getGiaTri();
        }

        if (giamGia.compareTo(tongDoanhThuDonHang) > 0) {
            giamGia = tongDoanhThuDonHang;
        }

        return giamGia.max(BigDecimal.ZERO);
    }

    private BigDecimal phanBoGiamGia(BigDecimal tongGiamGiaDonHang, BigDecimal tongDoanhThuDonHang, BigDecimal doanhThuVe) {
        if (tongGiamGiaDonHang.compareTo(BigDecimal.ZERO) <= 0
                || tongDoanhThuDonHang.compareTo(BigDecimal.ZERO) <= 0
                || doanhThuVe.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }

        return tongGiamGiaDonHang
                .multiply(doanhThuVe)
                .divide(tongDoanhThuDonHang, 2, RoundingMode.HALF_UP);
    }

    private List<ThongKeDoanhSoDTO> toDTOList(Map<String, Bucket> buckets) {
        List<ThongKeDoanhSoDTO> result = new ArrayList<>();

        for (Map.Entry<String, Bucket> entry : buckets.entrySet()) {
            Bucket bucket = entry.getValue();

            BigDecimal doanhThuThuan = bucket.tongDoanhThu.subtract(bucket.tongGiamGia);
            if (doanhThuThuan.compareTo(BigDecimal.ZERO) < 0) {
                doanhThuThuan = BigDecimal.ZERO;
            }

            result.add(new ThongKeDoanhSoDTO(
                    entry.getKey(),
                    bucket.soLuongVeBan,
                    bucket.tongDoanhThu,
                    bucket.tongGiamGia,
                    doanhThuThuan
            ));
        }

        return result;
    }

    private BigDecimal safeMoney(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }

    private static class Bucket {
        private int soLuongVeBan = 0;
        private BigDecimal tongDoanhThu = BigDecimal.ZERO;
        private BigDecimal tongGiamGia = BigDecimal.ZERO;
    }
}