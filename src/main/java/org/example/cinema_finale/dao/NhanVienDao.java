package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import org.example.cinema_finale.entity.NhanVien;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class NhanVienDao {

    public List<NhanVien> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<NhanVien> query = em.createQuery(
                    "select nv from NhanVien nv " +
                            "left join fetch nv.chucVu cv " +
                            "left join fetch nv.taiKhoan tk " +
                            "order by nv.hoTen",
                    NhanVien.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public NhanVien findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<NhanVien> query = em.createQuery(
                    "select nv from NhanVien nv " +
                            "left join fetch nv.chucVu cv " +
                            "left join fetch nv.taiKhoan tk " +
                            "where nv.maNhanVien = :id",
                    NhanVien.class
            );
            query.setParameter("id", id);
            List<NhanVien> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public List<NhanVien> findByTrangThaiLamViec(String trangThaiLamViec) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<NhanVien> query = em.createQuery(
                    "select nv from NhanVien nv " +
                            "left join fetch nv.chucVu cv " +
                            "left join fetch nv.taiKhoan tk " +
                            "where nv.trangThaiLamViec = :trangThai " +
                            "order by nv.hoTen",
                    NhanVien.class
            );
            query.setParameter("trangThai", trangThaiLamViec);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public NhanVien findBySoDienThoai(String soDienThoai) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<NhanVien> query = em.createQuery(
                    "select nv from NhanVien nv where nv.soDienThoai = :soDienThoai",
                    NhanVien.class
            );
            query.setParameter("soDienThoai", soDienThoai);
            List<NhanVien> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public NhanVien findByEmail(String email) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<NhanVien> query = em.createQuery(
                    "select nv from NhanVien nv where nv.email = :email",
                    NhanVien.class
            );
            query.setParameter("email", email);
            List<NhanVien> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public boolean save(NhanVien nhanVien) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(nhanVien);
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

    public boolean update(NhanVien nhanVien) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(nhanVien);
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

    public boolean updateTrangThaiLamViec(Integer maNhanVien, String trangThaiLamViec) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            NhanVien nhanVien = em.find(NhanVien.class, maNhanVien);
            if (nhanVien == null) {
                tx.rollback();
                return false;
            }
            nhanVien.setTrangThaiLamViec(trangThaiLamViec);
            em.merge(nhanVien);
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