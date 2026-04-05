package org.example.cinema_finale.dao;

import java.util.List;
import java.util.Locale;

import org.example.cinema_finale.entity.SanPham;
import org.example.cinema_finale.util.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.LockModeType;

public class SanPhamDao {

    public List<SanPham> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sp FROM SanPham sp JOIN FETCH sp.loaiSanPham ORDER BY sp.tenSanPham",
                            SanPham.class
                    )
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<SanPham> findByTrangThaiAndSoLuongTonGreaterThan(String trangThai, int minSoLuongTon) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sp FROM SanPham sp " +
                                    "JOIN FETCH sp.loaiSanPham " +
                                    "WHERE sp.trangThai = :trangThai " +
                                    "AND sp.soLuongTon > :minSoLuongTon " +
                                    "ORDER BY sp.tenSanPham",
                            SanPham.class
                    )
                    .setParameter("trangThai", trangThai)
                    .setParameter("minSoLuongTon", minSoLuongTon)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public SanPham findById(Integer maSanPham) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findById(em, maSanPham);
        } finally {
            em.close();
        }
    }

    public SanPham findById(EntityManager em, Integer maSanPham) {
        return em.find(SanPham.class, maSanPham);
    }

    public SanPham findByTenSanPhamForUpdate(EntityManager em, String tenSanPham) {
        if (tenSanPham == null || tenSanPham.trim().isEmpty()) {
            return null;
        }
        String normalized = normalizeName(tenSanPham);

        return em.createQuery(
                        "SELECT sp FROM SanPham sp " +
                                "WHERE LOWER(REPLACE(sp.tenSanPham, ' ', '')) = :tenSanPham " +
                                "ORDER BY sp.maSanPham",
                        SanPham.class
                )
                .setParameter("tenSanPham", normalized)
                .setLockMode(LockModeType.PESSIMISTIC_WRITE)
                .getResultStream()
                .findFirst()
                .orElse(null);
    }

    public boolean save(SanPham sanPham) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            save(em, sanPham);
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

    public void save(EntityManager em, SanPham sanPham) {
        em.persist(sanPham);
    }

    public boolean update(SanPham sanPham) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            update(em, sanPham);
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

    public SanPham update(EntityManager em, SanPham sanPham) {
        return em.merge(sanPham);
    }

    private String normalizeName(String tenSanPham) {
        return tenSanPham.replace(" ", "").trim().toLowerCase(Locale.ROOT);
    }
}
