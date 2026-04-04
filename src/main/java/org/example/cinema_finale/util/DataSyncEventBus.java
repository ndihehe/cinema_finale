package org.example.cinema_finale.util;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public final class DataSyncEventBus {

    private static final List<Runnable> PHIM_CHANGE_LISTENERS = new CopyOnWriteArrayList<>();
    private static final List<Runnable> PHONG_CHIEU_CHANGE_LISTENERS = new CopyOnWriteArrayList<>();

    private DataSyncEventBus() {
    }

    public static void onPhimChanged(Runnable listener) {
        if (listener != null) {
            PHIM_CHANGE_LISTENERS.add(listener);
        }
    }

    public static void publishPhimChanged() {
        for (Runnable listener : PHIM_CHANGE_LISTENERS) {
            try {
                listener.run();
            } catch (Exception ignored) {
                // Keep UI updates resilient even if one listener fails.
            }
        }
    }

    public static void onPhongChieuChanged(Runnable listener) {
        if (listener != null) {
            PHONG_CHIEU_CHANGE_LISTENERS.add(listener);
        }
    }

    public static void publishPhongChieuChanged() {
        for (Runnable listener : PHONG_CHIEU_CHANGE_LISTENERS) {
            try {
                listener.run();
            } catch (Exception ignored) {
                // Keep UI updates resilient even if one listener fails.
            }
        }
    }
}