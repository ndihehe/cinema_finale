package org.example.cinema_finale.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.example.cinema_finale.dto.ThongKeDoanhSoDTO;
import org.example.cinema_finale.service.PhimService;
import org.example.cinema_finale.service.ThongKeDoanhSoService;
import org.example.cinema_finale.util.DataSyncEventBus;
import org.example.cinema_finale.view.panel.staff.ThongKePanel;
import org.example.cinema_finale.view.panel.staff.ThongKePanel.MovieCardData;

public class ThongKeController {

    private final ThongKePanel view;
    private final ThongKeDoanhSoService service = new ThongKeDoanhSoService();
    private final PhimService phimService = new PhimService();
    private final List<MovieCardData> allMovieCards = new ArrayList<>();
    private final Map<String, BigDecimal> revenueByMovie = new LinkedHashMap<>();

    public ThongKeController(ThongKePanel view) {
        this.view = view;

        init();
        loadPhim();
        view.showPlaceholder();

        DataSyncEventBus.onPhimChanged(this::loadPhim);
    }

    private void init() {
        view.setMovieSelectionListener(this::handleMovieSelected);

        view.txtMovieSearch.getDocument().addDocumentListener(new javax.swing.event.DocumentListener() {
            @Override
            public void insertUpdate(javax.swing.event.DocumentEvent e) {
                applyMovieFilter();
            }

            @Override
            public void removeUpdate(javax.swing.event.DocumentEvent e) {
                applyMovieFilter();
            }

            @Override
            public void changedUpdate(javax.swing.event.DocumentEvent e) {
                applyMovieFilter();
            }
        });

        view.cboRevenueFilter.addActionListener(e -> applyMovieFilter());
    }

    private void loadPhim() {
        revenueByMovie.clear();
        for (ThongKeDoanhSoDTO stat : service.thongKeTheoPhim(null, null)) {
            String key = normalizeMovieKey(stat.getNhanThongKe());
            revenueByMovie.put(key, revenueByMovie.getOrDefault(key, BigDecimal.ZERO).add(stat.getTongDoanhThu()));
        }

        List<MovieCardData> cards = phimService.getAllPhim().stream()
                .map(p -> new MovieCardData(p.getTenPhim(), p.getPosterUrl()))
                .toList();

        allMovieCards.clear();
        allMovieCards.addAll(cards);

        applyMovieFilter();

        if (allMovieCards.isEmpty()) {
            view.updateSummary(0, BigDecimal.ZERO, BigDecimal.ZERO);
            view.showPlaceholder();
        }
    }

    private void applyMovieFilter() {
        String keyword = view.txtMovieSearch.getText() == null ? "" : view.txtMovieSearch.getText().trim().toLowerCase();
        String filterType = view.cboRevenueFilter.getSelectedItem() == null
                ? "Tất cả phim"
                : view.cboRevenueFilter.getSelectedItem().toString();

        List<MovieCardData> filtered = allMovieCards.stream()
                .filter(c -> keyword.isEmpty() || c.movieName().toLowerCase().contains(keyword))
                .filter(c -> {
                    BigDecimal revenue = revenueByMovie.getOrDefault(normalizeMovieKey(c.movieName()), BigDecimal.ZERO);
                    if ("Phim có doanh thu".equals(filterType)) {
                        return revenue.compareTo(BigDecimal.ZERO) > 0;
                    }
                    if ("Phim chưa có doanh thu".equals(filterType)) {
                        return revenue.compareTo(BigDecimal.ZERO) <= 0;
                    }
                    return true;
                })
                .toList();

        view.setMovieCards(filtered);
        view.showPlaceholder();
        view.updateSummary(0, BigDecimal.ZERO, BigDecimal.ZERO);
    }

    private void handleMovieSelected(MovieCardData movie) {
        String selectedMovieKey = normalizeMovieKey(movie.movieName());
        List<ThongKeDoanhSoDTO> movieStats = service.thongKeTheoPhim(null, null).stream()
            .filter(t -> normalizeMovieKey(t.getNhanThongKe()).equals(selectedMovieKey))
                .toList();

        int soVe = 0;
        BigDecimal doanhThu = BigDecimal.ZERO;
        BigDecimal giamGia = BigDecimal.ZERO;

        for (ThongKeDoanhSoDTO stat : movieStats) {
            soVe += stat.getSoLuongVeBan();
            doanhThu = doanhThu.add(stat.getTongDoanhThu());
            giamGia = giamGia.add(stat.getTongGiamGia());
        }

        view.updateSummary(soVe, doanhThu, giamGia);

        Map<String, BigDecimal> revenueByWeekday = service.thongKeDoanhThuTheoThuTrongTuan(movie.movieName(), null, null);
        view.renderRevenueChart(movie.movieName(), revenueByWeekday);
    }

    private String normalizeMovieKey(String name) {
        if (name == null) {
            return "";
        }
        return name.trim().replaceAll("\\s+", " ").toLowerCase();
    }
}
