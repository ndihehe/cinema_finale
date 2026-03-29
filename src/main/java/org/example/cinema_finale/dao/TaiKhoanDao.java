package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.entity.TaiKhoan;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class TaiKhoanDao {

    /**
     * Lấy toàn bộ danh sách tài khoản trong database.
     *
     * @return danh sách tài khoản
     */
    public List<TaiKhoan> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT tk FROM TaiKhoan tk", TaiKhoan.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm tài khoản theo mã tài khoản.
     *
     * @param maTk mã tài khoản cần tìm
     * @return tài khoản nếu tồn tại, ngược lại trả về null
     */
    public TaiKhoan findById(String maTk) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(TaiKhoan.class, maTk);
        } finally {
            em.close();
        }
    }

    /**
     * Tìm tài khoản theo tên đăng nhập.
     *
     * @param tenDangNhap tên đăng nhập cần tìm
     * @return tài khoản nếu tồn tại, ngược lại trả về null
     */
    public TaiKhoan findByUsername(String tenDangNhap) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            List<TaiKhoan> result = em.createQuery(
                            "SELECT tk FROM TaiKhoan tk WHERE tk.tenDangNhap = :tenDangNhap",
                            TaiKhoan.class
                    )
                    .setParameter("tenDangNhap", tenDangNhap)
                    .getResultList();

            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    /**
     * Thêm mới một tài khoản vào database.
     *
     * @param taiKhoan tài khoản cần thêm
     * @return true nếu thêm thành công, false nếu thêm thất bại
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
     * Cập nhật thông tin tài khoản trong database.
     *
     * @param taiKhoan tài khoản cần cập nhật
     * @return true nếu cập nhật thành công, false nếu cập nhật thất bại
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
     * Xóa tài khoản theo mã tài khoản.
     *
     * @param maTk mã tài khoản cần xóa
     * @return true nếu xóa thành công, false nếu xóa thất bại
     */
    public boolean delete(String maTk) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            TaiKhoan taiKhoan = em.find(TaiKhoan.class, maTk);
            if (taiKhoan == null) {
                return false;
            }

            tx.begin();
            em.remove(taiKhoan);
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
     * Kiểm tra mã tài khoản đã tồn tại hay chưa.
     *
     * @param maTk mã tài khoản cần kiểm tra
     * @return true nếu đã tồn tại, false nếu chưa tồn tại
     */
    public boolean existsById(String maTk) {
        return findById(maTk) != null;
    }

    /**
     * Kiểm tra tên đăng nhập đã tồn tại hay chưa.
     *
     * @param tenDangNhap tên đăng nhập cần kiểm tra
     * @return true nếu đã tồn tại, false nếu chưa tồn tại
     */
    public boolean existsByUsername(String tenDangNhap) {
        return findByUsername(tenDangNhap) != null;
    }
}