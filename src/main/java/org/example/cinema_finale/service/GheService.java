package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.GheDao;
import org.example.cinema_finale.dto.GheDTO;
import org.example.cinema_finale.entity.GheNgoi;
import org.example.cinema_finale.entity.LoaiGheNgoi;
import org.example.cinema_finale.entity.PhongChieu;

import java.util.List;

public class GheService {

    private GheDao dao = new GheDao();

    private GheDTO toDTO(GheNgoi g) {
        return new GheDTO(
                g.getMaGheNgoi(),
                g.getPhongChieu() != null ? g.getPhongChieu().getMaPhongChieu() : null,
                g.getPhongChieu() != null ? g.getPhongChieu().toString() : "",
                g.getHangGhe(),
                g.getSoGhe(),
                g.getLoaiGheNgoi() != null ? g.getLoaiGheNgoi().getMaLoaiGheNgoi() : null,
                g.getLoaiGheNgoi() != null ? g.getLoaiGheNgoi().getTenLoaiGheNgoi() : "",
                g.getTrangThaiGhe()
        );
    }

    public List<GheDTO> getByPhong(Integer maPhong) {
        return dao.findByPhong(maPhong).stream().map(this::toDTO).toList();
    }

    public boolean add(GheDTO dto) {
        return dao.save(toEntity(dto));
    }

    public boolean update(GheDTO dto) {
        return dao.update(toEntity(dto));
    }

    public boolean delete(Integer id) {
        return dao.delete(id);
    }

    private GheNgoi toEntity(GheDTO dto) {
        GheNgoi g = new GheNgoi();

        g.setMaGheNgoi(dto.getMaGheNgoi());
        g.setHangGhe(dto.getHangGhe());
        g.setSoGhe(dto.getSoGhe());
        g.setTrangThaiGhe(dto.getTrangThaiGhe());

        PhongChieu pc = new PhongChieu();
        pc.setMaPhongChieu(dto.getMaPhongChieu());
        g.setPhongChieu(pc);

        LoaiGheNgoi lg = new LoaiGheNgoi();
        lg.setMaLoaiGheNgoi(dto.getMaLoaiGheNgoi());
        g.setLoaiGheNgoi(lg);

        return g;
    }
}