package org.example.cinema_finale.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaUtil {

    private static final String PERSISTENCE_UNIT_NAME = "cinemaPU";

    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);

    /**
     * Tạo và trả về một EntityManager mới để thao tác với database.
     * @return EntityManager mới
     */
    public static EntityManager getEntityManager() {
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