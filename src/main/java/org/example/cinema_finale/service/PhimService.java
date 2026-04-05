package org.example.cinema_finale.service;

import java.util.List;
import java.util.stream.Collectors;

import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.entity.Phim;

public class PhimService {

    private final PhimDao phimDao = new PhimDao();

    // ===== CONVERT =====
    private PhimDTO toDTO(Phim p) {
        if (p == null) return null;

        return new PhimDTO(
                p.getMaPhim(),
                p.getTenPhim(),
                p.getTheLoai(),
                p.getDaoDien(),
                p.getThoiLuong(),
                p.getGioiHanTuoi(),
                p.getDinhDang(),
                p.getNgayKhoiChieu(),
            p.getTrangThaiPhim(),
            p.getPosterUrl()
        );
    }

    private Phim toEntity(PhimDTO dto) {
        if (dto == null) return null;

        Phim p = new Phim();
        p.setMaPhim(dto.getMaPhim());
        p.setTenPhim(dto.getTenPhim());
        p.setTheLoai(dto.getTheLoai());
        p.setDaoDien(dto.getDaoDien());
        p.setThoiLuong(dto.getThoiLuong());
        p.setGioiHanTuoi(dto.getGioiHanTuoi());
        p.setDinhDang(dto.getDinhDang());
        p.setNgayKhoiChieu(dto.getNgayKhoiChieu());
        p.setTrangThaiPhim(dto.getTrangThaiPhim());
        p.setPosterUrl(dto.getPosterUrl());
        return p;
    }

    // ===== GET ALL =====
    public List<PhimDTO> getAllPhim() {
        return phimDao.findAll()
                .stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    // ===== SEARCH =====
    public List<PhimDTO> searchByTenPhim(String key) {
        return phimDao.findByTenPhim(key)
                .stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    // ===== ADD =====
    public String add(PhimDTO dto) {
        boolean ok = phimDao.save(toEntity(dto));
        return ok ? "Thêm thành công" : "Thêm thất bại";
    }

    // ===== UPDATE =====
    public String update(PhimDTO dto) {
        boolean ok = phimDao.update(toEntity(dto));
        return ok ? "Cập nhật thành công" : "Cập nhật thất bại";
    }

    // ===== DELETE =====
    public String delete(Integer id) {
        boolean ok = phimDao.delete(id);
        return ok ? "Ngừng chiếu thành công" : "Thất bại";
    }
}