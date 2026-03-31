package org.example.cinema_finale.service;

import org.example.cinema_finale.dao.GheDao;
import org.example.cinema_finale.entity.GheNgoi;

import java.util.List;

public class GheService {

    private GheDao dao = new GheDao();

    public List<GheNgoi> getByPhong(Integer maPhong) {
        return dao.findByPhong(maPhong);
    }

    public boolean add(GheNgoi g) {
        return dao.save(g);
    }

    public boolean update(GheNgoi g) {
        return dao.update(g);
    }

    public boolean delete(Integer id) {
        return dao.delete(id);
    }
}