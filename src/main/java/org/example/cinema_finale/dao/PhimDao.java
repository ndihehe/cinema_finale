package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class PhimDao {

    /**
     * Lấy toàn bộ danh sách phim trong database.
     *
     * @return danh sách phim
     */
    public List<Phim> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Phim p", Phim.class).getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm phim theo mã phim.
     *
     * @param maPhim mã phim cần tìm
     * @return đối tượng phim nếu tìm thấy, ngược lại trả về null
     */
    public Phim findById(String maPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Phim.class, maPhim);
        } finally {
            em.close();
        }
    }

    /**
     * Thêm mới một phim vào database.
     *
     * @param phim đối tượng phim cần thêm
     * @return true nếu thêm thành công, false nếu thêm thất bại
     */
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

    /**
     * Cập nhật thông tin phim trong database.
     *
     * @param phim đối tượng phim cần cập nhật
     * @return true nếu cập nhật thành công, false nếu cập nhật thất bại
     */
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

    /**
     * Xóa phim theo mã phim.
     *
     * @param maPhim mã phim cần xóa
     * @return true nếu xóa thành công, false nếu xóa thất bại
     */
    public boolean delete(String maPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            Phim phim = em.find(Phim.class, maPhim);
            if (phim == null) {
                return false;
            }

            tx.begin();
            em.remove(phim);
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
     * Tìm danh sách phim theo tên phim gần đúng.
     *
     * @param tuKhoa từ khóa cần tìm trong tên phim
     * @return danh sách phim phù hợp
     */
    public List<Phim> findByTenPhim(String tuKhoa) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Phim p WHERE LOWER(p.tenPhim) LIKE LOWER(:tuKhoa)",
                            Phim.class
                    )
                    .setParameter("tuKhoa", "%" + tuKhoa + "%")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Kiểm tra mã phim đã tồn tại trong database hay chưa.
     *
     * @param maPhim mã phim cần kiểm tra
     * @return true nếu đã tồn tại, false nếu chưa tồn tại
     */
    public boolean existsById(String maPhim) {
        return findById(maPhim) != null;
    }
}