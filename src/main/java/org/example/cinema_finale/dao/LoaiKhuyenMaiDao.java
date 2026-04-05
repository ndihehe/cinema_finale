package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.example.cinema_finale.entity.LoaiKhuyenMai;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class LoaiKhuyenMaiDao {

    public List<LoaiKhuyenMai> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<LoaiKhuyenMai> query = em.createQuery(
                    "select lkm from LoaiKhuyenMai lkm order by lkm.tenLoaiKhuyenMai",
                    LoaiKhuyenMai.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public LoaiKhuyenMai findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(LoaiKhuyenMai.class, id);
        } finally {
            em.close();
        }
    }
}