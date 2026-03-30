package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.ChiTietDonHangVe;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class ChiTietDonHangVeDao {

    public List<ChiTietDonHangVe> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT ct FROM ChiTietDonHangVe ct " +
                            "JOIN FETCH ct.donHang " +
                            "JOIN FETCH ct.ve v " +
                            "JOIN FETCH v.loaiVe " +
                            "JOIN FETCH v.suatChieu sc " +
                            "JOIN FETCH sc.phim " +
                            "ORDER BY ct.maChiTietVe ASC",
                    ChiTietDonHangVe.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public ChiTietDonHangVe findById(String maChiTietVe) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findById(em, maChiTietVe);
        } finally {
            em.close();
        }
    }

    public ChiTietDonHangVe findById(EntityManager em, String maChiTietVe) {
        try {
            return em.createQuery(
                            "SELECT ct FROM ChiTietDonHangVe ct " +
                                    "JOIN FETCH ct.donHang " +
                                    "JOIN FETCH ct.ve v " +
                                    "JOIN FETCH v.loaiVe " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "WHERE ct.maChiTietVe = :maChiTietVe",
                            ChiTietDonHangVe.class
                    ).setParameter("maChiTietVe", maChiTietVe)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<ChiTietDonHangVe> findByMaDonHang(String maDonHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findByMaDonHang(em, maDonHang);
        } finally {
            em.close();
        }
    }

    public List<ChiTietDonHangVe> findByMaDonHang(EntityManager em, String maDonHang) {
        return em.createQuery(
                        "SELECT ct FROM ChiTietDonHangVe ct " +
                                "JOIN FETCH ct.donHang " +
                                "JOIN FETCH ct.ve v " +
                                "JOIN FETCH v.loaiVe " +
                                "JOIN FETCH v.suatChieu sc " +
                                "JOIN FETCH sc.phim " +
                                "WHERE ct.donHang.maDonHang = :maDonHang " +
                                "ORDER BY ct.maChiTietVe ASC",
                        ChiTietDonHangVe.class
                ).setParameter("maDonHang", maDonHang)
                .getResultList();
    }

    public ChiTietDonHangVe findByMaVe(String maVe) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findByMaVe(em, maVe);
        } finally {
            em.close();
        }
    }

    public ChiTietDonHangVe findByMaVe(EntityManager em, String maVe) {
        try {
            return em.createQuery(
                            "SELECT ct FROM ChiTietDonHangVe ct " +
                                    "JOIN FETCH ct.donHang " +
                                    "JOIN FETCH ct.ve v " +
                                    "JOIN FETCH v.loaiVe " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "WHERE ct.ve.maVe = :maVe",
                            ChiTietDonHangVe.class
                    ).setParameter("maVe", maVe)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public boolean save(ChiTietDonHangVe chiTietDonHangVe) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            save(em, chiTietDonHangVe);
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

    public void save(EntityManager em, ChiTietDonHangVe chiTietDonHangVe) {
        em.persist(chiTietDonHangVe);
    }

    public boolean update(ChiTietDonHangVe chiTietDonHangVe) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(chiTietDonHangVe);
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

    public boolean delete(String maChiTietVe) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            boolean result = delete(em, maChiTietVe);
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

    public boolean delete(EntityManager em, String maChiTietVe) {
        ChiTietDonHangVe chiTiet = em.find(ChiTietDonHangVe.class, maChiTietVe);
        if (chiTiet == null) {
            return false;
        }
        em.remove(chiTiet);
        return true;
    }

    public boolean existsById(String maChiTietVe) {
        return findById(maChiTietVe) != null;
    }

    public boolean existsByMaVe(String maVe) {
        return findByMaVe(maVe) != null;
    }

    public ChiTietDonHangVe findByMaDonHangAndMaVe(EntityManager em, String maDonHang, String maVe) {
        try {
            return em.createQuery(
                            "SELECT ct FROM ChiTietDonHangVe ct " +
                                    "JOIN FETCH ct.donHang " +
                                    "JOIN FETCH ct.ve v " +
                                    "JOIN FETCH v.loaiVe " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "WHERE ct.donHang.maDonHang = :maDonHang " +
                                    "AND ct.ve.maVe = :maVe",
                            ChiTietDonHangVe.class
                    ).setParameter("maDonHang", maDonHang)
                    .setParameter("maVe", maVe)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public boolean delete(EntityManager em, ChiTietDonHangVe chiTiet) {
        if (chiTiet == null) {
            return false;
        }
        ChiTietDonHangVe managed = em.contains(chiTiet) ? chiTiet : em.merge(chiTiet);
        em.remove(managed);
        return true;
    }
}