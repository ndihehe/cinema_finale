package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.enums.TrangThaiTaiKhoan;
import org.example.cinema_finale.util.JpaUtil;

import java.time.LocalDateTime;
import java.util.List;

public class TaiKhoanDao {

    /**
     * Lấy toàn bộ tài khoản.
     * JOIN FETCH để UI / auth không bị lazy khi cần biết chủ tài khoản là ai.
     */
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

    /**
     * Tìm tài khoản theo mã.
     */
    public TaiKhoan findById(String maTk) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tk FROM TaiKhoan tk " +
                                    "LEFT JOIN FETCH tk.nhanVien " +
                                    "LEFT JOIN FETCH tk.khachHang " +
                                    "WHERE tk.maTk = :maTk",
                            TaiKhoan.class
                    ).setParameter("maTk", maTk)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Tìm tài khoản theo tên đăng nhập.
     */
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

    /**
     * Tìm tài khoản theo mã nhân viên.
     */
    public TaiKhoan findByMaNhanVien(String maNv) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tk FROM TaiKhoan tk " +
                                    "LEFT JOIN FETCH tk.nhanVien " +
                                    "LEFT JOIN FETCH tk.khachHang " +
                                    "WHERE tk.nhanVien.maNv = :maNv",
                            TaiKhoan.class
                    ).setParameter("maNv", maNv)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Tìm tài khoản theo mã khách hàng.
     */
    public TaiKhoan findByMaKhachHang(String maKh) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT tk FROM TaiKhoan tk " +
                                    "LEFT JOIN FETCH tk.nhanVien " +
                                    "LEFT JOIN FETCH tk.khachHang " +
                                    "WHERE tk.khachHang.maKh = :maKh",
                            TaiKhoan.class
                    ).setParameter("maKh", maKh)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy các tài khoản đang hoạt động.
     */
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
                    ).setParameter("trangThai", TrangThaiTaiKhoan.HOAT_DONG)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Thêm tài khoản mới.
     */
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

    /**
     * Cập nhật tài khoản.
     */
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

    /**
     * Khóa / mở khóa tài khoản bằng trạng thái.
     */
    public boolean updateTrangThai(String maTk, TrangThaiTaiKhoan trangThaiTaiKhoan) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            TaiKhoan taiKhoan = em.find(TaiKhoan.class, maTk);
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

    /**
     * Cập nhật lần đăng nhập cuối.
     */
    public boolean updateLastLogin(String maTk, LocalDateTime lanDangNhapCuoi) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            TaiKhoan taiKhoan = em.find(TaiKhoan.class, maTk);
            if (taiKhoan == null) {
                return false;
            }

            tx.begin();
            taiKhoan.setLanDangNhapCuoi(lanDangNhapCuoi);
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

    /**
     * Không xóa cứng tài khoản.
     * Để an toàn nghiệp vụ, chuyển sang NGUNG_SU_DUNG.
     */
    public boolean delete(String maTk) {
        return updateTrangThai(maTk, TrangThaiTaiKhoan.NGUNG_SU_DUNG);
    }

    public boolean existsById(String maTk) {
        return findById(maTk) != null;
    }

    public boolean existsByTenDangNhap(String tenDangNhap) {
        return findByTenDangNhap(tenDangNhap) != null;
    }
}