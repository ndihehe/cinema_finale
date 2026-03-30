package org.example.cinema_finale.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public final class JpaUtil {

    private static final String PERSISTENCE_UNIT_NAME = "CinemaPU";

    private static final EntityManagerFactory emf = buildEntityManagerFactory();

    private JpaUtil() {
    }

    private static EntityManagerFactory buildEntityManagerFactory() {
        try {
            return Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError("Không thể khởi tạo EntityManagerFactory.");
        }
    }

    /**
     * Tạo và trả về một EntityManager mới để thao tác với database.
     *
     * @return EntityManager mới
     */
    public static EntityManager getEntityManager() {
        if (emf == null || !emf.isOpen()) {
            throw new IllegalStateException("EntityManagerFactory chưa sẵn sàng hoặc đã bị đóng.");
        }
        return emf.createEntityManager();
    }

    /**
     * Đóng EntityManagerFactory khi ứng dụng kết thúc.
     */
    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}