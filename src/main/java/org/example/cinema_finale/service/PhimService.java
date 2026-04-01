package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.PhimDao;
import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.entity.Phim;

import java.util.List;

public class PhimService {

    private final PhimDao dao = new PhimDao();

    // ===== MAPPER =====
    private PhimDTO toDTO(Phim p) {
        return new PhimDTO(
                p.getMaPhim(),
                p.getTenPhim(),
                p.getTheLoai(),
                p.getDaoDien(),
                p.getThoiLuong(),
                p.getGioiHanTuoi(),
                p.getDinhDang(),
                p.getNgayKhoiChieu(),
                p.getTrangThaiPhim()
        );
    }

    private Phim toEntity(PhimDTO dto) {
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
        return p;
    }

    // ===== CRUD =====
    public List<PhimDTO> getAll() {
        return dao.findAll().stream().map(this::toDTO).toList();
    }

    public List<PhimDTO> search(String key) {
        return dao.findByTenPhim(key).stream().map(this::toDTO).toList();
    }

    public String add(PhimDTO dto) {
        return dao.save(toEntity(dto)) ? "OK" : "FAIL";
    }

    public String update(PhimDTO dto) {
        return dao.update(toEntity(dto)) ? "OK" : "FAIL";
    }

    public boolean delete(Integer id) {
        return dao.delete(id);
    }
}