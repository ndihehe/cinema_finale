package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.util.JpaUtil;

import java.time.LocalDate;
import java.util.List;

public class SuatChieuDao {

    /**
     * Lấy toàn bộ danh sách suất chiếu.
     *
     * @return danh sách suất chiếu
     */
    public List<SuatChieu> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT sc FROM SuatChieu sc ORDER BY sc.ngayChieu, sc.gioBatDau",
                    SuatChieu.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm suất chiếu theo mã suất.
     *
     * @param maSuat mã suất chiếu
     * @return đối tượng suất chiếu nếu tìm thấy, ngược lại trả về null
     */
    public SuatChieu findById(String maSuat) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(SuatChieu.class, maSuat);
        } finally {
            em.close();
        }
    }

    /**
     * Thêm mới một suất chiếu.
     *
     * @param suatChieu đối tượng suất chiếu cần thêm
     * @return true nếu thêm thành công, ngược lại false
     */
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

    /**
     * Cập nhật thông tin suất chiếu.
     *
     * @param suatChieu đối tượng suất chiếu cần cập nhật
     * @return true nếu cập nhật thành công, ngược lại false
     */
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

    /**
     * Xóa suất chiếu theo mã suất.
     *
     * @param maSuat mã suất chiếu cần xóa
     * @return true nếu xóa thành công, ngược lại false
     */
    public boolean delete(String maSuat) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            SuatChieu suatChieu = em.find(SuatChieu.class, maSuat);
            if (suatChieu == null) {
                return false;
            }

            tx.begin();
            em.remove(suatChieu);
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
     * Tìm danh sách suất chiếu theo mã phim.
     *
     * @param maPhim mã phim
     * @return danh sách suất chiếu thuộc phim đó
     */
    public List<SuatChieu> findByMaPhim(String maPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc WHERE sc.phim.maPhim = :maPhim ORDER BY sc.ngayChieu, sc.gioBatDau",
                            SuatChieu.class
                    ).setParameter("maPhim", maPhim)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm danh sách suất chiếu theo ngày chiếu.
     *
     * @param ngayChieu ngày chiếu
     * @return danh sách suất chiếu trong ngày đó
     */
    public List<SuatChieu> findByNgayChieu(LocalDate ngayChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc WHERE sc.ngayChieu = :ngayChieu ORDER BY sc.gioBatDau",
                            SuatChieu.class
                    ).setParameter("ngayChieu", ngayChieu)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Kiểm tra mã suất chiếu đã tồn tại hay chưa.
     *
     * @param maSuat mã suất chiếu
     * @return true nếu đã tồn tại, ngược lại false
     */
    public boolean existsById(String maSuat) {
        return findById(maSuat) != null;
    }
}