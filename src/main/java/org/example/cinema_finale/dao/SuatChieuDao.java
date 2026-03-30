package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.SuatChieu;
import org.example.cinema_finale.enums.TrangThaiSuatChieu;
import org.example.cinema_finale.util.JpaUtil;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class SuatChieuDao {

    /**
     * Lấy toàn bộ danh sách suất chiếu.
     * JOIN FETCH phim để tránh lỗi lazy khi UI hiển thị tên phim.
     */
    public List<SuatChieu> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT sc FROM SuatChieu sc " +
                            "JOIN FETCH sc.phim " +
                            "ORDER BY sc.ngayGioChieu ASC",
                    SuatChieu.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm suất chiếu theo mã.
     */
    public SuatChieu findById(String maSuatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "WHERE sc.maSuatChieu = :maSuatChieu",
                            SuatChieu.class
                    ).setParameter("maSuatChieu", maSuatChieu)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Tìm suất chiếu theo mã phim.
     */
    public List<SuatChieu> findByMaPhim(String maPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "WHERE sc.phim.maPhim = :maPhim " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("maPhim", maPhim)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm suất chiếu theo ngày.
     */
    public List<SuatChieu> findByNgay(LocalDate ngay) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            LocalDateTime from = ngay.atStartOfDay();
            LocalDateTime to = ngay.plusDays(1).atStartOfDay();

            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "WHERE sc.ngayGioChieu >= :from AND sc.ngayGioChieu < :to " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("from", from)
                    .setParameter("to", to)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm suất chiếu theo phòng và ngày.
     * Dùng cho check trùng lịch ở service.
     */
    public List<SuatChieu> findByPhongAndNgay(String maPhongChieu, LocalDate ngay) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            LocalDateTime from = ngay.atStartOfDay();
            LocalDateTime to = ngay.plusDays(1).atStartOfDay();

            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "WHERE sc.maPhongChieu = :maPhongChieu " +
                                    "AND sc.ngayGioChieu >= :from AND sc.ngayGioChieu < :to " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("maPhongChieu", maPhongChieu)
                    .setParameter("from", from)
                    .setParameter("to", to)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm suất chiếu theo trạng thái.
     */
    public List<SuatChieu> findByTrangThai(TrangThaiSuatChieu trangThaiSuatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "WHERE sc.trangThaiSuatChieu = :trangThai " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("trangThai", trangThaiSuatChieu)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Lấy các suất còn có ý nghĩa cho đặt vé.
     */
    public List<SuatChieu> findAllForBooking() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT sc FROM SuatChieu sc " +
                                    "JOIN FETCH sc.phim " +
                                    "WHERE sc.trangThaiSuatChieu = :trangThai " +
                                    "ORDER BY sc.ngayGioChieu ASC",
                            SuatChieu.class
                    ).setParameter("trangThai", TrangThaiSuatChieu.DANG_MO_BAN)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Thêm suất chiếu mới.
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
     * Cập nhật suất chiếu.
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
     * Không xóa cứng suất chiếu.
     * Giữ tên hàm delete để code cũ ít bị vỡ, nhưng thực tế là chuyển trạng thái sang HUY.
     */
    public boolean delete(String maSuatChieu) {
        return updateTrangThai(maSuatChieu, TrangThaiSuatChieu.HUY);
    }

    /**
     * Cập nhật trạng thái suất chiếu.
     */
    public boolean updateTrangThai(String maSuatChieu, TrangThaiSuatChieu trangThaiSuatChieu) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            SuatChieu suatChieu = em.find(SuatChieu.class, maSuatChieu);
            if (suatChieu == null) {
                return false;
            }

            tx.begin();
            suatChieu.setTrangThaiSuatChieu(trangThaiSuatChieu);
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
     * Kiểm tra mã suất chiếu tồn tại chưa.
     */
    public boolean existsById(String maSuatChieu) {
        return findById(maSuatChieu) != null;
    }
}