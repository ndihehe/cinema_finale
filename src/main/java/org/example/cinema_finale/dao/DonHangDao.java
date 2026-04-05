package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.DonHang;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class DonHangDao {

    public List<DonHang> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT dh FROM DonHang dh " +
                            "LEFT JOIN FETCH dh.khachHang " +
                            "JOIN FETCH dh.nhanVien " +
                            "LEFT JOIN FETCH dh.khuyenMai " +
                            "ORDER BY dh.ngayLap DESC",
                    DonHang.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public DonHang findById(Integer maDonHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findById(em, maDonHang);
        } finally {
            em.close();
        }
    }

    public DonHang findById(EntityManager em, Integer maDonHang) {
        try {
            return em.createQuery(
                            "SELECT dh FROM DonHang dh " +
                                    "LEFT JOIN FETCH dh.khachHang " +
                                    "JOIN FETCH dh.nhanVien " +
                                    "LEFT JOIN FETCH dh.khuyenMai " +
                                    "WHERE dh.maDonHang = :maDonHang",
                            DonHang.class
                    ).setParameter("maDonHang", maDonHang)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public DonHang findDetailById(Integer maDonHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return findDetailById(em, maDonHang);
        } finally {
            em.close();
        }
    }

    public DonHang findDetailById(EntityManager em, Integer maDonHang) {
        try {
            return em.createQuery(
                            "SELECT DISTINCT dh FROM DonHang dh " +
                                    "LEFT JOIN FETCH dh.khachHang " +
                                    "JOIN FETCH dh.nhanVien " +
                                    "LEFT JOIN FETCH dh.khuyenMai " +
                                    "LEFT JOIN FETCH dh.chiTietDonHangVes ctv " +
                                    "LEFT JOIN FETCH ctv.ve vv " +
                                    "LEFT JOIN FETCH vv.loaiVe " +
                                    "LEFT JOIN FETCH vv.gheNgoi g " +
                                    "LEFT JOIN FETCH g.phongChieu " +
                                    "LEFT JOIN FETCH g.loaiGheNgoi " +
                                    "LEFT JOIN FETCH vv.suatChieu sc " +
                                    "LEFT JOIN FETCH sc.phim " +
                                    "LEFT JOIN FETCH sc.phongChieu " +
                                    "LEFT JOIN FETCH dh.chiTietDonHangSanPhams ctsp " +
                                    "LEFT JOIN FETCH ctsp.sanPham sp " +
                                    "LEFT JOIN FETCH sp.loaiSanPham lsp " +
                                    "LEFT JOIN FETCH lsp.danhMucSanPham " +
                                    "LEFT JOIN FETCH dh.thanhToans " +
                                    "WHERE dh.maDonHang = :maDonHang",
                            DonHang.class
                    ).setParameter("maDonHang", maDonHang)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<DonHang> findByMaKhachHang(Integer maKhachHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT dh FROM DonHang dh " +
                                    "LEFT JOIN FETCH dh.khachHang " +
                                    "JOIN FETCH dh.nhanVien " +
                                    "LEFT JOIN FETCH dh.khuyenMai " +
                                    "WHERE dh.khachHang.maKhachHang = :maKhachHang " +
                                    "ORDER BY dh.ngayLap DESC",
                            DonHang.class
                    ).setParameter("maKhachHang", maKhachHang)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<DonHang> findByTrangThai(String trangThaiDonHang) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT dh FROM DonHang dh " +
                                    "LEFT JOIN FETCH dh.khachHang " +
                                    "JOIN FETCH dh.nhanVien " +
                                    "LEFT JOIN FETCH dh.khuyenMai " +
                                    "WHERE dh.trangThaiDonHang = :trangThai " +
                                    "ORDER BY dh.ngayLap DESC",
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

    public boolean delete(Integer maDonHang) {
        return updateTrangThai(maDonHang, "Đã hủy");
    }

    public boolean updateTrangThai(Integer maDonHang, String trangThaiDonHang) {
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

    public boolean updateTrangThai(EntityManager em, Integer maDonHang, String trangThaiDonHang) {
        DonHang donHang = em.find(DonHang.class, maDonHang);
        if (donHang == null) {
            return false;
        }
        donHang.setTrangThaiDonHang(trangThaiDonHang);
        em.merge(donHang);
        return true;
    }

    public boolean existsById(Integer maDonHang) {
        return findById(maDonHang) != null;
    }
}
