package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.entity.LoaiVe;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class LoaiVeDao {

    public List<LoaiVe> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT lv FROM LoaiVe lv ORDER BY lv.tenLoaiVe ASC",
                    LoaiVe.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public LoaiVe findById(String maLoaiVe) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(LoaiVe.class, maLoaiVe);
        } finally {
            em.close();
        }
    }

    public List<LoaiVe> findByTenLoaiVe(String tuKhoa) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT lv FROM LoaiVe lv " +
                                    "WHERE LOWER(lv.tenLoaiVe) LIKE LOWER(:tuKhoa) " +
                                    "ORDER BY lv.tenLoaiVe ASC",
                            LoaiVe.class
                    ).setParameter("tuKhoa", "%" + tuKhoa + "%")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean save(LoaiVe loaiVe) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.persist(loaiVe);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean update(LoaiVe loaiVe) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.merge(loaiVe);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Với LoaiVe không có trạng thái riêng nên vẫn hard delete.
     * Nếu đã phát sinh Ve thì DB sẽ tự chặn bởi FK.
     */
    public boolean delete(String maLoaiVe) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            LoaiVe loaiVe = em.find(LoaiVe.class, maLoaiVe);
            if (loaiVe == null) {
                return false;
            }

            tx.begin();
            em.remove(loaiVe);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean existsById(String maLoaiVe) {
        return findById(maLoaiVe) != null;
    }
}