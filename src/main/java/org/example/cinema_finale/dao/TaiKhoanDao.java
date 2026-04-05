package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class TaiKhoanDao {

    public List<TaiKhoan> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT tk FROM TaiKhoan tk " +
                            "LEFT JOIN FETCH tk.nhanVien " +
                            "LEFT JOIN FETCH tk.khachHang " +
                            "ORDER BY tk.tenDangNhap ASC",
                    TaiKhoan.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public TaiKhoan findById(Integer maTaiKhoan) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tk FROM TaiKhoan tk " +
                                    "LEFT JOIN FETCH tk.nhanVien " +
                                    "LEFT JOIN FETCH tk.khachHang " +
                                    "WHERE tk.maTaiKhoan = :maTaiKhoan",
                            TaiKhoan.class
                    ).setParameter("maTaiKhoan", maTaiKhoan)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public TaiKhoan findByTenDangNhap(String tenDangNhap) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tk FROM TaiKhoan tk " +
                                    "LEFT JOIN FETCH tk.nhanVien " +
                                    "LEFT JOIN FETCH tk.khachHang " +
                                    "WHERE LOWER(tk.tenDangNhap) = LOWER(:tenDangNhap)",
                            TaiKhoan.class
                    ).setParameter("tenDangNhap", tenDangNhap)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public TaiKhoan findByMaNhanVien(Integer maNhanVien) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tk FROM TaiKhoan tk " +
                                    "LEFT JOIN FETCH tk.nhanVien " +
                                    "LEFT JOIN FETCH tk.khachHang " +
                                    "WHERE tk.nhanVien.maNhanVien = :maNhanVien",
                            TaiKhoan.class
                    ).setParameter("maNhanVien", maNhanVien)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public TaiKhoan findByMaKhachHang(Integer maKhachHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tk FROM TaiKhoan tk " +
                                    "LEFT JOIN FETCH tk.nhanVien " +
                                    "LEFT JOIN FETCH tk.khachHang " +
                                    "WHERE tk.khachHang.maKhachHang = :maKhachHang",
                            TaiKhoan.class
                    ).setParameter("maKhachHang", maKhachHang)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<TaiKhoan> findAllActive() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tk FROM TaiKhoan tk " +
                                    "LEFT JOIN FETCH tk.nhanVien " +
                                    "LEFT JOIN FETCH tk.khachHang " +
                                    "WHERE tk.trangThaiTaiKhoan = :trangThai " +
                                    "ORDER BY tk.tenDangNhap ASC",
                            TaiKhoan.class
                    ).setParameter("trangThai", "Hoạt động")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean save(TaiKhoan taiKhoan) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.persist(taiKhoan);
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

    public boolean update(TaiKhoan taiKhoan) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            em.merge(taiKhoan);
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

    public boolean updateTrangThai(Integer maTaiKhoan, String trangThaiTaiKhoan) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            TaiKhoan taiKhoan = em.find(TaiKhoan.class, maTaiKhoan);
            if (taiKhoan == null) {
                return false;
            }

            tx.begin();
            taiKhoan.setTrangThaiTaiKhoan(trangThaiTaiKhoan);
            em.merge(taiKhoan);
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

    public boolean delete(Integer maTaiKhoan) {
        return updateTrangThai(maTaiKhoan, "Khóa");
    }

    public boolean existsById(Integer maTaiKhoan) {
        return findById(maTaiKhoan) != null;
    }

    public boolean existsByTenDangNhap(String tenDangNhap) {
        return findByTenDangNhap(tenDangNhap) != null;
    }
}
