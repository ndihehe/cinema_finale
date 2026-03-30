package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.ThanhToan;
import org.example.cinema_finale.enums.TrangThaiThanhToan;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class ThanhToanDao {

    public List<ThanhToan> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT tt FROM ThanhToan tt " +
                            "JOIN FETCH tt.donHang " +
                            "LEFT JOIN FETCH tt.nhanVien " +
                            "ORDER BY tt.thoiGianThanhToan DESC, tt.maThanhToan DESC",
                    ThanhToan.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public ThanhToan findById(String maThanhToan) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findById(em, maThanhToan);
        } finally {
            em.close();
        }
    }

    public ThanhToan findById(EntityManager em, String maThanhToan) {
        try {
            return em.createQuery(
                            "SELECT tt FROM ThanhToan tt " +
                                    "JOIN FETCH tt.donHang " +
                                    "LEFT JOIN FETCH tt.nhanVien " +
                                    "WHERE tt.maThanhToan = :maThanhToan",
                            ThanhToan.class
                    ).setParameter("maThanhToan", maThanhToan)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<ThanhToan> findByMaDonHang(String maDonHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tt FROM ThanhToan tt " +
                                    "JOIN FETCH tt.donHang " +
                                    "LEFT JOIN FETCH tt.nhanVien " +
                                    "WHERE tt.donHang.maDonHang = :maDonHang " +
                                    "ORDER BY tt.thoiGianThanhToan DESC, tt.maThanhToan DESC",
                            ThanhToan.class
                    ).setParameter("maDonHang", maDonHang)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<ThanhToan> findByTrangThai(TrangThaiThanhToan trangThaiThanhToan) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tt FROM ThanhToan tt " +
                                    "JOIN FETCH tt.donHang " +
                                    "LEFT JOIN FETCH tt.nhanVien " +
                                    "WHERE tt.trangThaiThanhToan = :trangThaiThanhToan " +
                                    "ORDER BY tt.thoiGianThanhToan DESC, tt.maThanhToan DESC",
                            ThanhToan.class
                    ).setParameter("trangThaiThanhToan", trangThaiThanhToan)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean save(ThanhToan thanhToan) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            save(em, thanhToan);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public void save(EntityManager em, ThanhToan thanhToan) {
        em.persist(thanhToan);
    }

    public boolean update(ThanhToan thanhToan) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            update(em, thanhToan);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public ThanhToan update(EntityManager em, ThanhToan thanhToan) {
        return em.merge(thanhToan);
    }

    public boolean delete(String maThanhToan) {
        return updateTrangThai(maThanhToan, TrangThaiThanhToan.THAT_BAI);
    }

    public boolean updateTrangThai(String maThanhToan, TrangThaiThanhToan trangThaiThanhToan) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            boolean result = updateTrangThai(em, maThanhToan, trangThaiThanhToan);
            tx.commit();
            return result;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean updateTrangThai(EntityManager em, String maThanhToan, TrangThaiThanhToan trangThaiThanhToan) {
        ThanhToan thanhToan = em.find(ThanhToan.class, maThanhToan);
        if (thanhToan == null) {
            return false;
        }
        thanhToan.setTrangThaiThanhToan(trangThaiThanhToan);
        em.merge(thanhToan);
        return true;
    }

    public boolean existsById(String maThanhToan) {
        return findById(maThanhToan) != null;
    }
}