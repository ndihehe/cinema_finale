package org.example.cinema_finale.util;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class JpaUtil {
    private static EntityManagerFactory factory;

    public static EntityManager getEntityManager() {
        if (factory == null || !factory.isOpen()) {
            factory = Persistence.createEntityManagerFactory("CinemaPU");
        }
        return factory.createEntityManager();
    }

    public static void shutDown() {
        if (factory != null && factory.isOpen()) factory.close();
    }
}