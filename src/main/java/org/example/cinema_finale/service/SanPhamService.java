package org.example.cinema_finale.service;

import java.util.List;
import java.util.stream.Collectors;

import org.example.cinema_finale.dao.SanPhamDao;
import org.example.cinema_finale.dto.SanPhamDTO;
import org.example.cinema_finale.entity.SanPham;
import org.example.cinema_finale.util.AuthorizationUtil;

public class SanPhamService {

    private static final String STATUS_DANG_BAN = "Đang bán";

    private final SanPhamDao sanPhamDao;

    public SanPhamService() {
        this.sanPhamDao = new SanPhamDao();
    }

    public SanPhamService(SanPhamDao sanPhamDao) {
        this.sanPhamDao = sanPhamDao;
    }

    public List<SanPhamDTO> getAllSanPham() {
        AuthorizationUtil.requireStaff();
        return sanPhamDao.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public SanPhamDTO getSanPhamById(String maSanPham) {
        AuthorizationUtil.requireStaffOrCustomer();

        Integer id = parseId(maSanPham);
        if (id == null) {
            return null;
        }

        SanPham sanPham = sanPhamDao.findById(id);
        return sanPham == null ? null : toDTO(sanPham);
    }

    public List<SanPhamDTO> getSanPhamDangBan() {
        AuthorizationUtil.requireStaffOrCustomer();
        return sanPhamDao.findByTrangThaiAndSoLuongTonGreaterThan(STATUS_DANG_BAN, 0).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    private SanPhamDTO toDTO(SanPham sanPham) {
        SanPhamDTO dto = new SanPhamDTO();
        dto.setMaSanPham(sanPham.getMaSanPham());
        dto.setTenSanPham(sanPham.getTenSanPham());
        dto.setDonGia(sanPham.getDonGia());
        dto.setSoLuongTon(sanPham.getSoLuongTon());
        dto.setTrangThai(sanPham.getTrangThai());

        if (sanPham.getLoaiSanPham() != null) {
            dto.setMaLoaiSanPham(sanPham.getLoaiSanPham().getMaLoaiSanPham());
            dto.setTenLoaiSanPham(sanPham.getLoaiSanPham().getTenLoaiSanPham());
        }

        return dto;
    }

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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
