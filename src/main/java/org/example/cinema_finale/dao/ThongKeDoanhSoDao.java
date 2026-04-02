package org.example.cinema_finale.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.example.cinema_finale.entity.DonHang;
import org.example.cinema_finale.util.JpaUtil;

import java.time.LocalDateTime;
import java.util.List;

public class ThongKeDoanhSoDao {

    public List<DonHang> findDonHangDaThanhToanTrongKhoang(LocalDateTime tuThoiGian,
                                                           LocalDateTime denThoiGian) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<DonHang> query = em.createQuery(
                    "select distinct dh " +
                            "from DonHang dh " +
                            "join fetch dh.thanhToans tt " +
                            "left join fetch dh.khuyenMai km " +
                            "left join fetch dh.chiTietDonHangVes ct " +
                            "left join fetch ct.ve v " +
                            "left join fetch v.suatChieu sc " +
                            "left join fetch sc.phim p " +
                            "left join fetch sc.phongChieu pc " +
                            "where tt.trangThaiThanhToan = :trangThai " +
                            "and tt.thoiGianThanhToan >= :tuThoiGian " +
                            "and tt.thoiGianThanhToan < :denThoiGian",
                    DonHang.class
            );

            query.setParameter("trangThai", "Thành công");
            query.setParameter("tuThoiGian", tuThoiGian);
            query.setParameter("denThoiGian", denThoiGian);

            return query.getResultList();
        } finally {
            em.close();
        }
    }
}