package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.util.JpaUtil;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class SuatChieuDao {

    public List<SuatChieu> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT sc FROM SuatChieu sc " +
                            "JOIN FETCH sc.phim " +
                            "JOIN FETCH sc.phongChieu " +
                            "ORDER BY sc.ngayGioChieu ASC",
                    SuatChieu.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public SuatChieu findById(Integer maSuatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "WHERE sc.maSuatChieu = :maSuatChieu",
                            SuatChieu.class
                    ).setParameter("maSuatChieu", maSuatChieu)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<SuatChieu> findByMaPhim(Integer maPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "WHERE sc.phim.maPhim = :maPhim " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("maPhim", maPhim)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<SuatChieu> findByNgay(LocalDate ngay) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            LocalDateTime from = ngay.atStartOfDay();
            LocalDateTime to = ngay.plusDays(1).atStartOfDay();

            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "WHERE sc.ngayGioChieu >= :from AND sc.ngayGioChieu < :to " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("from", from)
                    .setParameter("to", to)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<SuatChieu> findByPhongAndNgay(Integer maPhongChieu, LocalDate ngay) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            LocalDateTime from = ngay.atStartOfDay();
            LocalDateTime to = ngay.plusDays(1).atStartOfDay();

            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "WHERE sc.phongChieu.maPhongChieu = :maPhongChieu " +
                                    "AND sc.ngayGioChieu >= :from AND sc.ngayGioChieu < :to " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("maPhongChieu", maPhongChieu)
                    .setParameter("from", from)
                    .setParameter("to", to)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<SuatChieu> findByTrangThai(String trangThaiSuatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "WHERE sc.trangThaiSuatChieu = :trangThai " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("trangThai", trangThaiSuatChieu)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<SuatChieu> findAllForBooking() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "JOIN FETCH sc.phongChieu " +
                                    "WHERE sc.trangThaiSuatChieu IN :trangThais " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("trangThais", List.of("Sắp chiếu", "Đang chiếu"))
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean save(SuatChieu suatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.persist(suatChieu);
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

    public boolean update(SuatChieu suatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.merge(suatChieu);
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

    public boolean delete(Integer maSuatChieu) {
        return updateTrangThai(maSuatChieu, "Hủy");
    }

    public boolean updateTrangThai(Integer maSuatChieu, String trangThaiSuatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            SuatChieu suatChieu = em.find(SuatChieu.class, maSuatChieu);
            if (suatChieu == null) {
                return false;
            }

            tx.begin();
            suatChieu.setTrangThaiSuatChieu(trangThaiSuatChieu);
            em.merge(suatChieu);
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

    public boolean existsById(Integer maSuatChieu) {
        return findById(maSuatChieu) != null;
    }
}
