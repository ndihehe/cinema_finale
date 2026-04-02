package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import org.example.cinema_finale.entity.KhuyenMai;
import org.example.cinema_finale.util.JpaUtil;

import java.time.LocalDateTime;
import java.util.List;

public class KhuyenMaiDao {

    public List<KhuyenMai> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhuyenMai> query = em.createQuery(
                    "select km from KhuyenMai km " +
                            "join fetch km.loaiKhuyenMai lkm " +
                            "order by km.ngayBatDau desc, km.maKhuyenMai desc",
                    KhuyenMai.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public KhuyenMai findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhuyenMai> query = em.createQuery(
                    "select km from KhuyenMai km " +
                            "join fetch km.loaiKhuyenMai lkm " +
                            "where km.maKhuyenMai = :id",
                    KhuyenMai.class
            );
            query.setParameter("id", id);
            List<KhuyenMai> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public List<KhuyenMai> findByTrangThai(String trangThai) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhuyenMai> query = em.createQuery(
                    "select km from KhuyenMai km " +
                            "join fetch km.loaiKhuyenMai lkm " +
                            "where km.trangThai = :trangThai " +
                            "order by km.ngayBatDau desc, km.maKhuyenMai desc",
                    KhuyenMai.class
            );
            query.setParameter("trangThai", trangThai);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<KhuyenMai> findHieuLucTrongKhoang(LocalDateTime thoiDiem) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhuyenMai> query = em.createQuery(
                    "select km from KhuyenMai km " +
                            "join fetch km.loaiKhuyenMai lkm " +
                            "where km.trangThai = :trangThai " +
                            "and km.ngayBatDau <= :thoiDiem " +
                            "and km.ngayKetThuc >= :thoiDiem " +
                            "order by km.ngayKetThuc asc, km.maKhuyenMai desc",
                    KhuyenMai.class
            );
            query.setParameter("trangThai", "Hoạt động");
            query.setParameter("thoiDiem", thoiDiem);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public KhuyenMai findByTenKhuyenMai(String tenKhuyenMai) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhuyenMai> query = em.createQuery(
                    "select km from KhuyenMai km " +
                            "join fetch km.loaiKhuyenMai lkm " +
                            "where lower(km.tenKhuyenMai) = lower(:tenKhuyenMai)",
                    KhuyenMai.class
            );
            query.setParameter("tenKhuyenMai", tenKhuyenMai);
            List<KhuyenMai> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public boolean save(KhuyenMai khuyenMai) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(khuyenMai);
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

    public boolean update(KhuyenMai khuyenMai) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(khuyenMai);
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

    public boolean updateTrangThai(Integer maKhuyenMai, String trangThai) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            KhuyenMai khuyenMai = em.find(KhuyenMai.class, maKhuyenMai);
            if (khuyenMai == null) {
                tx.rollback();
                return false;
            }
            khuyenMai.setTrangThai(trangThai);
            em.merge(khuyenMai);
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
}