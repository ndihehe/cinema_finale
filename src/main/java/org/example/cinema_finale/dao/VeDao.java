package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.LockModeType;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.Ve;
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
                            "JOIN FETCH sc.phongChieu " +
                            "JOIN FETCH v.loaiVe " +
                            "JOIN FETCH v.gheNgoi g " +
                            "JOIN FETCH g.phongChieu " +
                            "JOIN FETCH g.loaiGheNgoi " +
                            "ORDER BY sc.ngayGioChieu ASC, g.hangGhe ASC, g.soGhe ASC",
                    Ve.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public Ve findById(Integer maVe) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findById(em, maVe);
        } finally {
            em.close();
        }
    }

    public Ve findById(EntityManager em, Integer maVe) {
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "JOIN FETCH v.loaiVe " +
                                    "JOIN FETCH v.gheNgoi g " +
                                    "JOIN FETCH g.phongChieu " +
                                    "JOIN FETCH g.loaiGheNgoi " +
                                    "WHERE v.maVe = :maVe",
                            Ve.class
                    ).setParameter("maVe", maVe)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public Ve findByIdForUpdate(EntityManager em, Integer maVe) {
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "JOIN FETCH v.loaiVe " +
                                    "JOIN FETCH v.gheNgoi g " +
                                    "JOIN FETCH g.phongChieu " +
                                    "JOIN FETCH g.loaiGheNgoi " +
                                    "WHERE v.maVe = :maVe",
                            Ve.class
                    ).setParameter("maVe", maVe)
                    .setLockMode(LockModeType.PESSIMISTIC_WRITE)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<Ve> findByMaSuatChieu(Integer maSuatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "JOIN FETCH v.loaiVe " +
                                    "JOIN FETCH v.gheNgoi g " +
                                    "JOIN FETCH g.phongChieu " +
                                    "JOIN FETCH g.loaiGheNgoi " +
                                    "WHERE v.suatChieu.maSuatChieu = :maSuatChieu " +
                                    "ORDER BY g.hangGhe ASC, g.soGhe ASC",
                            Ve.class
                    ).setParameter("maSuatChieu", maSuatChieu)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Ve> findByMaSuatChieuAndTrangThai(Integer maSuatChieu, String trangThaiVe) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "JOIN FETCH v.loaiVe " +
                                    "JOIN FETCH v.gheNgoi g " +
                                    "JOIN FETCH g.phongChieu " +
                                    "JOIN FETCH g.loaiGheNgoi " +
                                    "WHERE v.suatChieu.maSuatChieu = :maSuatChieu " +
                                    "AND v.trangThaiVe = :trangThaiVe " +
                                    "ORDER BY g.hangGhe ASC, g.soGhe ASC",
                            Ve.class
                    ).setParameter("maSuatChieu", maSuatChieu)
                    .setParameter("trangThaiVe", trangThaiVe)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Ve findByMaSuatChieuAndMaGheNgoi(Integer maSuatChieu, Integer maGheNgoi) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findByMaSuatChieuAndMaGheNgoi(em, maSuatChieu, maGheNgoi);
        } finally {
            em.close();
        }
    }

    public Ve findByMaSuatChieuAndMaGheNgoi(EntityManager em, Integer maSuatChieu, Integer maGheNgoi) {
        try {
            return em.createQuery(
                            "SELECT v FROM Ve v " +
                                    "JOIN FETCH v.suatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "JOIN FETCH v.loaiVe " +
                                    "JOIN FETCH v.gheNgoi g " +
                                    "JOIN FETCH g.phongChieu " +
                                    "JOIN FETCH g.loaiGheNgoi " +
                                    "WHERE v.suatChieu.maSuatChieu = :maSuatChieu " +
                                    "AND v.gheNgoi.maGheNgoi = :maGheNgoi",
                            Ve.class
                    ).setParameter("maSuatChieu", maSuatChieu)
                    .setParameter("maGheNgoi", maGheNgoi)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<Ve> findAvailableByMaSuatChieu(Integer maSuatChieu) {
        return findByMaSuatChieuAndTrangThai(maSuatChieu, "Chưa bán");
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

    public boolean delete(Integer maVe) {
        return updateTrangThai(maVe, "Đã hủy");
    }

    public boolean updateTrangThai(Integer maVe, String trangThaiVe) {
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

    public boolean updateTrangThai(EntityManager em, Integer maVe, String trangThaiVe) {
        Ve ve = findByIdForUpdate(em, maVe);
        if (ve == null) {
            return false;
        }
        ve.setTrangThaiVe(trangThaiVe);
        em.merge(ve);
        return true;
    }

    public boolean existsById(Integer maVe) {
        return findById(maVe) != null;
    }

    public boolean existsBySuatChieuAndMaGheNgoi(Integer maSuatChieu, Integer maGheNgoi) {
        return findByMaSuatChieuAndMaGheNgoi(maSuatChieu, maGheNgoi) != null;
    }
}
