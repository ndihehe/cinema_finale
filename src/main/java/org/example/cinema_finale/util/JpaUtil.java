package org.example.cinema_finale.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public final class JpaUtil {

    private static final String PERSISTENCE_UNIT_NAME = "CinemaPU";
    private static volatile EntityManagerFactory emf;

    private JpaUtil() {
    }

    private static EntityManagerFactory buildEntityManagerFactory() {
        try {
            return Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError("Không thể khởi tạo EntityManagerFactory cho persistence unit: " + PERSISTENCE_UNIT_NAME);
        }
    }

    private static EntityManagerFactory getEntityManagerFactory() {
        if (emf == null || !emf.isOpen()) {
            synchronized (JpaUtil.class) {
                if (emf == null || !emf.isOpen()) {
                    emf = buildEntityManagerFactory();
                }
            }
        }
        return emf;
    }

    /**
     * Tạo và trả về một EntityManager mới để thao tác với database.
     */
    public static EntityManager getEntityManager() {
        return getEntityManagerFactory().createEntityManager();
    }

    /**
     * Đóng EntityManagerFactory khi ứng dụng kết thúc.
     */
    public static void close() {
        synchronized (JpaUtil.class) {
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
            emf = null;
        }
    }
}
