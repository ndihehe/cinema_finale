package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.entity.GheNgoi;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class GheDao {

    public List<GheNgoi> findByPhong(Integer maPhong) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT g FROM GheNgoi g " +
                                    "JOIN FETCH g.loaiGheNgoi " +
                                    "JOIN FETCH g.phongChieu " +
                                    "WHERE g.phongChieu.maPhongChieu = :ma",
                            GheNgoi.class
                    ).setParameter("ma", maPhong)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean save(GheNgoi g) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.persist(g);
            tx.commit();
            return true;
        } catch (Exception e) {
            tx.rollback();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean update(GheNgoi g) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.merge(g);
            tx.commit();
            return true;
        } catch (Exception e) {
            tx.rollback();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean delete(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            GheNgoi g = em.find(GheNgoi.class, id);
            if (g != null) em.remove(g);
            tx.commit();
            return true;
        } catch (Exception e) {
            tx.rollback();
            return false;
        } finally {
            em.close();
        }
    }
}