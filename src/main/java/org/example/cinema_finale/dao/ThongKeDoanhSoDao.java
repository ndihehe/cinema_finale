package org.example.cinema_finale.dao;

import java.time.LocalDateTime;
import java.util.List;

import org.example.cinema_finale.util.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class ThongKeDoanhSoDao {

    private static final String SUCCESS_PAYMENT_STATUSES = "('Thành công','SUCCESS','Hoàn thành')";

    public List<Object[]> thongKeRaw(LocalDateTime from, LocalDateTime to){
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Object[]> query = em.createQuery(
                    "select dh, tt " +
                            "from DonHang dh " +
                            "join dh.thanhToans tt " +
                    "where tt.trangThaiThanhToan IN " + SUCCESS_PAYMENT_STATUSES + " " +
                            "and tt.thoiGianThanhToan >= :from " +
                            "and tt.thoiGianThanhToan < :to",
                    Object[].class
            );

            query.setParameter("from", from);
            query.setParameter("to", to);

            List<Object[]> result = query.getResultList();

            System.out.println("DEBUG ThongKe rows = " + result.size());

            return result;

        } finally {
            em.close();
        }
    }

    public List<Object[]> thongKeTheoPhimRaw(LocalDateTime from, LocalDateTime to) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Object[]> query = em.createQuery(
                    "select p.tenPhim, ct.donGiaBan " +
                            "from ChiTietDonHangVe ct " +
                            "join ct.donHang dh " +
                            "join dh.thanhToans tt " +
                            "join ct.ve v " +
                            "join v.suatChieu sc " +
                            "join sc.phim p " +
                    "where tt.trangThaiThanhToan IN " + SUCCESS_PAYMENT_STATUSES + " " +
                            "and tt.thoiGianThanhToan >= :from " +
                    "and tt.thoiGianThanhToan < :to " +
                    "and tt.maThanhToan = (" +
                    "   select max(t2.maThanhToan) " +
                    "   from ThanhToan t2 " +
                    "   where t2.donHang = dh " +
                    "   and t2.trangThaiThanhToan IN " + SUCCESS_PAYMENT_STATUSES + " " +
                    "   and t2.thoiGianThanhToan >= :from " +
                    "   and t2.thoiGianThanhToan < :to" +
                    ")",
                    Object[].class
            );

            query.setParameter("from", from);
            query.setParameter("to", to);

            List<Object[]> result = query.getResultList();
            System.out.println("DEBUG ThongKe phim rows = " + result.size());
            return result;
        } finally {
            em.close();
        }
    }

    public List<Object[]> thongKeDonHangRaw(LocalDateTime from, LocalDateTime to) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Object[]> query = em.createQuery(
                    "select dh.maDonHang, tt.thoiGianThanhToan, count(ct), coalesce(sum(ct.donGiaBan), 0) " +
                    "from DonHang dh " +
                    "join dh.thanhToans tt " +
                    "left join dh.chiTietDonHangVes ct " +
                    "where tt.trangThaiThanhToan IN " + SUCCESS_PAYMENT_STATUSES + " " +
                    "and tt.thoiGianThanhToan >= :from " +
                    "and tt.thoiGianThanhToan < :to " +
                    "and tt.maThanhToan = (" +
                    "   select max(t2.maThanhToan) " +
                    "   from ThanhToan t2 " +
                    "   where t2.donHang = dh " +
                    "   and t2.trangThaiThanhToan IN " + SUCCESS_PAYMENT_STATUSES + " " +
                    "   and t2.thoiGianThanhToan >= :from " +
                    "   and t2.thoiGianThanhToan < :to" +
                    ") " +
                    "group by dh.maDonHang, tt.thoiGianThanhToan",
                    Object[].class
            );

            query.setParameter("from", from);
            query.setParameter("to", to);

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> thongKeVeRaw(LocalDateTime from, LocalDateTime to) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Object[]> query = em.createQuery(
                    "select tt.thoiGianThanhToan, ct.donGiaBan " +
                    "from ChiTietDonHangVe ct " +
                    "join ct.donHang dh " +
                    "join dh.thanhToans tt " +
                    "where tt.trangThaiThanhToan IN " + SUCCESS_PAYMENT_STATUSES + " " +
                    "and tt.thoiGianThanhToan >= :from " +
                    "and tt.thoiGianThanhToan < :to " +
                    "and tt.maThanhToan = (" +
                    "   select max(t2.maThanhToan) " +
                    "   from ThanhToan t2 " +
                    "   where t2.donHang = dh " +
                    "   and t2.trangThaiThanhToan IN " + SUCCESS_PAYMENT_STATUSES + " " +
                    "   and t2.thoiGianThanhToan >= :from " +
                    "   and t2.thoiGianThanhToan < :to" +
                    ")",
                    Object[].class
            );

            query.setParameter("from", from);
            query.setParameter("to", to);

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> thongKeTheoPhimVaThoiGianRaw(String tenPhim, LocalDateTime from, LocalDateTime to) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Object[]> query = em.createQuery(
                    "select tt.thoiGianThanhToan, ct.donGiaBan " +
                    "from ChiTietDonHangVe ct " +
                    "join ct.donHang dh " +
                    "join dh.thanhToans tt " +
                    "join ct.ve v " +
                    "join v.suatChieu sc " +
                    "join sc.phim p " +
                    "where p.tenPhim = :tenPhim " +
                    "and tt.trangThaiThanhToan IN " + SUCCESS_PAYMENT_STATUSES + " " +
                    "and tt.thoiGianThanhToan >= :from " +
                    "and tt.thoiGianThanhToan < :to " +
                    "and tt.maThanhToan = (" +
                    "   select max(t2.maThanhToan) " +
                    "   from ThanhToan t2 " +
                    "   where t2.donHang = dh " +
                    "   and t2.trangThaiThanhToan IN " + SUCCESS_PAYMENT_STATUSES + " " +
                    "   and t2.thoiGianThanhToan >= :from " +
                    "   and t2.thoiGianThanhToan < :to" +
                    ")",
                    Object[].class
            );

            query.setParameter("tenPhim", tenPhim);
            query.setParameter("from", from);
            query.setParameter("to", to);

            return query.getResultList();
        } finally {
            em.close();
        }
    }
}