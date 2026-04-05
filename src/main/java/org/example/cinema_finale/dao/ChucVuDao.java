package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.example.cinema_finale.entity.ChucVu;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class ChucVuDao {

    public List<ChucVu> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<ChucVu> query = em.createQuery(
                    "select cv from ChucVu cv order by cv.tenChucVu",
                    ChucVu.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public ChucVu findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(ChucVu.class, id);
        } finally {
            em.close();
        }
    }
}