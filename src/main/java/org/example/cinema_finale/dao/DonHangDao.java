package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.DonHang;
import org.example.cinema_finale.enums.TrangThaiDonHang;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class DonHangDao {

    public List<DonHang> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT dh FROM DonHang dh " +
                            "LEFT JOIN FETCH dh.khachHang " +
                            "LEFT JOIN FETCH dh.nhanVien " +
                            "ORDER BY dh.thoiGianTao DESC",
                    DonHang.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public DonHang findById(String maDonHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findById(em, maDonHang);
        } finally {
            em.close();
        }
    }

    public DonHang findById(EntityManager em, String maDonHang) {
        try {
            return em.createQuery(
                            "SELECT dh FROM DonHang dh " +
                                    "LEFT JOIN FETCH dh.khachHang " +
                                    "LEFT JOIN FETCH dh.nhanVien " +
                                    "WHERE dh.maDonHang = :maDonHang",
                            DonHang.class
                    ).setParameter("maDonHang", maDonHang)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public DonHang findDetailById(String maDonHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findDetailById(em, maDonHang);
        } finally {
            em.close();
        }
    }

    public DonHang findDetailById(EntityManager em, String maDonHang) {
        try {
            return em.createQuery(
                            "SELECT DISTINCT dh FROM DonHang dh " +
                                    "LEFT JOIN FETCH dh.khachHang " +
                                    "LEFT JOIN FETCH dh.nhanVien " +
                                    "LEFT JOIN FETCH dh.chiTietDonHangVes ct " +
                                    "LEFT JOIN FETCH ct.ve v " +
                                    "LEFT JOIN FETCH v.loaiVe " +
                                    "LEFT JOIN FETCH v.suatChieu sc " +
                                    "LEFT JOIN FETCH sc.phim " +
                                    "LEFT JOIN FETCH dh.thanhToans " +
                                    "WHERE dh.maDonHang = :maDonHang",
                            DonHang.class
                    ).setParameter("maDonHang", maDonHang)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<DonHang> findByMaKhachHang(String maKh) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT dh FROM DonHang dh " +
                                    "LEFT JOIN FETCH dh.khachHang " +
                                    "LEFT JOIN FETCH dh.nhanVien " +
                                    "WHERE dh.khachHang.maKh = :maKh " +
                                    "ORDER BY dh.thoiGianTao DESC",
                            DonHang.class
                    ).setParameter("maKh", maKh)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<DonHang> findByTrangThai(TrangThaiDonHang trangThaiDonHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT dh FROM DonHang dh " +
                                    "LEFT JOIN FETCH dh.khachHang " +
                                    "LEFT JOIN FETCH dh.nhanVien " +
                                    "WHERE dh.trangThaiDonHang = :trangThai " +
                                    "ORDER BY dh.thoiGianTao DESC",
                            DonHang.class
                    ).setParameter("trangThai", trangThaiDonHang)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean save(DonHang donHang) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            save(em, donHang);
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

    public void save(EntityManager em, DonHang donHang) {
        em.persist(donHang);
    }

    public boolean update(DonHang donHang) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            update(em, donHang);
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

    public DonHang update(EntityManager em, DonHang donHang) {
        return em.merge(donHang);
    }

    public boolean delete(String maDonHang) {
        return updateTrangThai(maDonHang, TrangThaiDonHang.DA_HUY);
    }

    public boolean updateTrangThai(String maDonHang, TrangThaiDonHang trangThaiDonHang) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            boolean result = updateTrangThai(em, maDonHang, trangThaiDonHang);
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

    public boolean updateTrangThai(EntityManager em, String maDonHang, TrangThaiDonHang trangThaiDonHang) {
        DonHang donHang = em.find(DonHang.class, maDonHang);
        if (donHang == null) {
            return false;
        }
        donHang.setTrangThaiDonHang(trangThaiDonHang);
        em.merge(donHang);
        return true;
    }

    public boolean existsById(String maDonHang) {
        return findById(maDonHang) != null;
    }
}