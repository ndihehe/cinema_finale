package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.LockModeType;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.Ve;
import org.example.cinema_finale.enums.TrangThaiVe;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class VeDao {

    public List<Ve> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT v FROM Ve v " +
                            "JOIN FETCH v.suatChieu sc " +
                            "JOIN FETCH sc.phim " +
                            "JOIN FETCH v.loaiVe " +
                            "ORDER BY sc.ngayGioChieu ASC, v.maGheNgoi ASC",
                    Ve.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public Ve findById(String maVe) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findById(em, maVe);
        } finally {
            em.close();
        }
    }

    public Ve findById(EntityManager em, String maVe) {
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH v.loaiVe " +
                                    "WHERE v.maVe = :maVe",
                            Ve.class
                    ).setParameter("maVe", maVe)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Khóa bản ghi vé để chống double booking.
     */
    public Ve findByIdForUpdate(EntityManager em, String maVe) {
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH v.loaiVe " +
                                    "WHERE v.maVe = :maVe",
                            Ve.class
                    ).setParameter("maVe", maVe)
                    .setLockMode(LockModeType.PESSIMISTIC_WRITE)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<Ve> findByMaSuatChieu(String maSuatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH v.loaiVe " +
                                    "WHERE v.suatChieu.maSuatChieu = :maSuatChieu " +
                                    "ORDER BY v.maGheNgoi ASC",
                            Ve.class
                    ).setParameter("maSuatChieu", maSuatChieu)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Ve> findByMaSuatChieuAndTrangThai(String maSuatChieu, TrangThaiVe trangThaiVe) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH v.loaiVe " +
                                    "WHERE v.suatChieu.maSuatChieu = :maSuatChieu " +
                                    "AND v.trangThaiVe = :trangThaiVe " +
                                    "ORDER BY v.maGheNgoi ASC",
                            Ve.class
                    ).setParameter("maSuatChieu", maSuatChieu)
                    .setParameter("trangThaiVe", trangThaiVe)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Ve findByMaSuatChieuAndMaGheNgoi(String maSuatChieu, String maGheNgoi) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findByMaSuatChieuAndMaGheNgoi(em, maSuatChieu, maGheNgoi);
        } finally {
            em.close();
        }
    }

    public Ve findByMaSuatChieuAndMaGheNgoi(EntityManager em, String maSuatChieu, String maGheNgoi) {
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH v.loaiVe " +
                                    "WHERE v.suatChieu.maSuatChieu = :maSuatChieu " +
                                    "AND v.maGheNgoi = :maGheNgoi",
                            Ve.class
                    ).setParameter("maSuatChieu", maSuatChieu)
                    .setParameter("maGheNgoi", maGheNgoi)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<Ve> findAvailableByMaSuatChieu(String maSuatChieu) {
        return findByMaSuatChieuAndTrangThai(maSuatChieu, TrangThaiVe.CHUA_BAN);
    }

    public boolean save(Ve ve) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            save(em, ve);
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

    public void save(EntityManager em, Ve ve) {
        em.persist(ve);
    }

    public boolean update(Ve ve) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            update(em, ve);
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

    public Ve update(EntityManager em, Ve ve) {
        return em.merge(ve);
    }

    public boolean delete(String maVe) {
        return updateTrangThai(maVe, TrangThaiVe.DA_HUY);
    }

    public boolean updateTrangThai(String maVe, TrangThaiVe trangThaiVe) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            boolean result = updateTrangThai(em, maVe, trangThaiVe);
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

    public boolean updateTrangThai(EntityManager em, String maVe, TrangThaiVe trangThaiVe) {
        Ve ve = findByIdForUpdate(em, maVe);
        if (ve == null) {
            return false;
        }
        ve.setTrangThaiVe(trangThaiVe);
        em.merge(ve);
        return true;
    }

    public boolean existsById(String maVe) {
        return findById(maVe) != null;
    }

    public boolean existsBySuatChieuAndMaGheNgoi(String maSuatChieu, String maGheNgoi) {
        return findByMaSuatChieuAndMaGheNgoi(maSuatChieu, maGheNgoi) != null;
    }
}