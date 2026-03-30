package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import org.example.cinema_finale.entity.Phim;
import org.example.cinema_finale.enums.TrangThaiPhim;
import org.example.cinema_finale.util.JpaUtil;

import java.util.List;

public class PhimDao {

    /**
     * Lấy toàn bộ danh sách phim.
     */
    public List<Phim> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM Phim p ORDER BY p.ngayKhoiChieu DESC, p.tenPhim ASC",
                    Phim.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách phim đang còn ý nghĩa cho nghiệp vụ bán vé.
     */
    public List<Phim> findAllForBooking() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Phim p " +
                                    "WHERE p.trangThaiPhim IN :trangThais " +
                                    "ORDER BY p.ngayKhoiChieu DESC, p.tenPhim ASC",
                            Phim.class
                    ).setParameter("trangThais",
                            List.of(TrangThaiPhim.SAP_CHIEU, TrangThaiPhim.DANG_CHIEU))
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm phim theo mã phim.
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
     * Tìm phim theo tên gần đúng.
     */
    public List<Phim> findByTenPhim(String tuKhoa) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Phim p " +
                                    "WHERE LOWER(p.tenPhim) LIKE LOWER(:tuKhoa) " +
                                    "ORDER BY p.ngayKhoiChieu DESC, p.tenPhim ASC",
                            Phim.class
                    ).setParameter("tuKhoa", "%" + tuKhoa + "%")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm phim theo trạng thái.
     */
    public List<Phim> findByTrangThai(TrangThaiPhim trangThaiPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Phim p " +
                                    "WHERE p.trangThaiPhim = :trangThai " +
                                    "ORDER BY p.ngayKhoiChieu DESC, p.tenPhim ASC",
                            Phim.class
                    ).setParameter("trangThai", trangThaiPhim)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Thêm phim mới.
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
     * Cập nhật phim.
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
     * Không xóa cứng phim.
     * Giữ tên hàm delete để service cũ ít bị vỡ, nhưng thực tế là chuyển sang NGUNG_CHIEU.
     */
    public boolean delete(String maPhim) {
        return updateTrangThai(maPhim, TrangThaiPhim.NGUNG_CHIEU);
    }

    /**
     * Cập nhật trạng thái phim.
     */
    public boolean updateTrangThai(String maPhim, TrangThaiPhim trangThaiPhim) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            Phim phim = em.find(Phim.class, maPhim);
            if (phim == null) {
                return false;
            }

            tx.begin();
            phim.setTrangThaiPhim(trangThaiPhim);
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
     * Kiểm tra mã phim tồn tại chưa.
     */
    public boolean existsById(String maPhim) {
        return findById(maPhim) != null;
    }
}