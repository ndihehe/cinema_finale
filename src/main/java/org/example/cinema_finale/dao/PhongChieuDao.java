package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.entity.PhongChieu;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class PhongChieuDao {

    public List<PhongChieu> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM PhongChieu p", PhongChieu.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // 🔥 SAVE + RETURN ENTITY (QUAN TRỌNG)
    public PhongChieu saveAndReturn(PhongChieu p) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.persist(p);
            tx.commit();
            return p; // có ID luôn
        } catch (Exception e) {
            tx.rollback();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean update(PhongChieu p) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.merge(p);
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
            PhongChieu p = em.find(PhongChieu.class, id);
            if (p != null) em.remove(p);
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