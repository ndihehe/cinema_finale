package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import org.example.cinema_finale.entity.KhachHang;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class KhachHangDao {

    public List<KhachHang> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhachHang> query = em.createQuery(
                    "select kh from KhachHang kh " +
                            "left join fetch kh.taiKhoan tk " +
                            "order by kh.hoTen",
                    KhachHang.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public KhachHang findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhachHang> query = em.createQuery(
                    "select kh from KhachHang kh " +
                            "left join fetch kh.taiKhoan tk " +
                            "where kh.maKhachHang = :id",
                    KhachHang.class
            );
            query.setParameter("id", id);
            List<KhachHang> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public List<KhachHang> findByHangThanhVien(String hangThanhVien) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhachHang> query = em.createQuery(
                    "select kh from KhachHang kh " +
                            "left join fetch kh.taiKhoan tk " +
                            "where kh.hangThanhVien = :hangThanhVien " +
                            "order by kh.hoTen",
                    KhachHang.class
            );
            query.setParameter("hangThanhVien", hangThanhVien);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public KhachHang findBySoDienThoai(String soDienThoai) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhachHang> query = em.createQuery(
                    "select kh from KhachHang kh where kh.soDienThoai = :soDienThoai",
                    KhachHang.class
            );
            query.setParameter("soDienThoai", soDienThoai);
            List<KhachHang> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public KhachHang findByEmail(String email) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<KhachHang> query = em.createQuery(
                    "select kh from KhachHang kh where kh.email = :email",
                    KhachHang.class
            );
            query.setParameter("email", email);
            List<KhachHang> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public boolean save(KhachHang khachHang) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(khachHang);
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

    public boolean update(KhachHang khachHang) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(khachHang);
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