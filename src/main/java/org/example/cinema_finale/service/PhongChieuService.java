package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.GheDao;
import org.example.cinema_finale.dao.PhongChieuDao;
import org.example.cinema_finale.dto.PhongChieuDTO;
import org.example.cinema_finale.entity.GheNgoi;
import org.example.cinema_finale.entity.LoaiGheNgoi;
import org.example.cinema_finale.entity.PhongChieu;

import java.util.List;

public class PhongChieuService {

    private PhongChieuDao dao = new PhongChieuDao();

    private PhongChieuDTO toDTO(PhongChieu p) {
        return new PhongChieuDTO(
                p.getMaPhongChieu(),
                p.getTenPhongChieu(),
                p.getLoaiManHinh(),
                p.getHeThongAmThanh(),
                p.getTrangThaiPhong()
        );
    }

    private PhongChieu toEntity(PhongChieuDTO dto) {
        PhongChieu p = new PhongChieu();

        p.setMaPhongChieu(dto.getMaPhongChieu());
        p.setTenPhongChieu(dto.getTenPhongChieu());
        p.setLoaiManHinh(dto.getLoaiManHinh());
        p.setHeThongAmThanh(dto.getHeThongAmThanh());
        p.setTrangThaiPhong(dto.getTrangThaiPhong());

        return p;
    }

    public List<PhongChieuDTO> getAll() {
        return dao.findAll().stream().map(this::toDTO).toList();
    }

    // 🔥 ADD + GENERATE GHẾ
    public boolean add(PhongChieuDTO dto) {

        PhongChieu p = dao.saveAndReturn(toEntity(dto));
        if (p == null) return false;

        generateSeats(p, dto.getSoHang(), dto.getSoCot());

        return true;
    }

    public boolean update(PhongChieuDTO dto) {
        return dao.update(toEntity(dto));
    }

    public boolean delete(Integer id) {
        return dao.delete(id);
    }

    // 🔥 GENERATE GHẾ (THƯỜNG + VIP + ĐÔI)
    private void generateSeats(PhongChieu phong, int soHang, int soCot) {

        GheDao gheDao = new GheDao();

        for (int i = 0; i < soHang; i++) {

            char hang = (char) ('A' + i);

            for (int j = 1; j <= soCot; j++) {

                GheNgoi g = new GheNgoi();

                g.setPhongChieu(phong);
                g.setHangGhe(String.valueOf(hang));
                g.setSoGhe(j);
                g.setTrangThaiGhe("Hoạt động");

                LoaiGheNgoi loai = new LoaiGheNgoi();

                // 🔥 LOGIC LOẠI GHẾ
                if (i == soHang - 1) {
                    loai.setMaLoaiGheNgoi(3); // Đôi
                } else if (i >= soHang - 3) {
                    loai.setMaLoaiGheNgoi(2); // VIP
                } else {
                    loai.setMaLoaiGheNgoi(1); // Thường
                }

                g.setLoaiGheNgoi(loai);

                gheDao.save(g);
            }
        }
    }
}