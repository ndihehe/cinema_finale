package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class PhimDao {

    public List<Phim> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM Phim p ORDER BY p.ngayKhoiChieu DESC, p.tenPhim ASC",
                    Phim.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Phim> findAllForBooking() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Phim p " +
                                    "WHERE p.trangThaiPhim IN :trangThais " +
                                    "ORDER BY p.ngayKhoiChieu DESC, p.tenPhim ASC",
                            Phim.class
                    ).setParameter("trangThais", List.of("Sắp chiếu", "Đang chiếu"))
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Phim findById(Integer maPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Phim.class, maPhim);
        } finally {
            em.close();
        }
    }

    public List<Phim> findByTenPhim(String tuKhoa) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Phim p " +
                                    "WHERE LOWER(p.tenPhim) LIKE LOWER(:tuKhoa) " +
                                    "ORDER BY p.ngayKhoiChieu DESC, p.tenPhim ASC",
                            Phim.class
                    ).setParameter("tuKhoa", "%" + tuKhoa + "%")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Phim> findByTrangThai(String trangThaiPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Phim p " +
                                    "WHERE p.trangThaiPhim = :trangThai " +
                                    "ORDER BY p.ngayKhoiChieu DESC, p.tenPhim ASC",
                            Phim.class
                    ).setParameter("trangThai", trangThaiPhim)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean save(Phim phim) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.persist(phim);
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

    public boolean update(Phim phim) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.merge(phim);
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

    public boolean delete(Integer maPhim) {
        return updateTrangThai(maPhim, "Ngừng chiếu");
    }

    public boolean updateTrangThai(Integer maPhim, String trangThaiPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            Phim phim = em.find(Phim.class, maPhim);
            if (phim == null) {
                return false;
            }

            tx.begin();
            phim.setTrangThaiPhim(trangThaiPhim);
            em.merge(phim);
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

    public boolean existsById(Integer maPhim) {
        return findById(maPhim) != null;
    }
}
