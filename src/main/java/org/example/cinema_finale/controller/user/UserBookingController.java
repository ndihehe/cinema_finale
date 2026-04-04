package org.example.cinema_finale.controller.user;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;

import org.example.cinema_finale.dto.BanVeThanhToanFormDTO;
import org.example.cinema_finale.dto.CapNhatVeDonHangDTO;
import org.example.cinema_finale.dto.DonHangDTO;
import org.example.cinema_finale.dto.DonHangTamFormDTO;
import org.example.cinema_finale.dto.KhuyenMaiDTO;
import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.dto.SuatChieuDTO;
import org.example.cinema_finale.dto.VeDTO;
import org.example.cinema_finale.service.BanVeService;
import org.example.cinema_finale.service.KhuyenMaiService;
import org.example.cinema_finale.service.PhimService;
import org.example.cinema_finale.service.SuatChieuService;
import org.example.cinema_finale.util.SessionManager;
import org.example.cinema_finale.view.frame.LoginFrame;
import org.example.cinema_finale.view.user.InvoiceDialog;
import org.example.cinema_finale.view.user.UserFrame;
import org.example.cinema_finale.view.user.panel.ProductSelectionPanel.ProductSelectionResult;

public class UserBookingController {

    private static final Locale VI_VN = Locale.forLanguageTag("vi-VN");

    private final UserFrame view;

    private final PhimService phimService = new PhimService();
    private final SuatChieuService suatChieuService = new SuatChieuService();
    private final BanVeService banVeService = new BanVeService();
    private final KhuyenMaiService khuyenMaiService = new KhuyenMaiService();

    private List<PhimDTO> allMovies = new ArrayList<>();
    private List<SuatChieuDTO> currentShowtimes = new ArrayList<>();

    private PhimDTO selectedMovie;
    private SuatChieuDTO selectedShowtime;
    private List<VeDTO> selectedTickets = new ArrayList<>();
    private ProductSelectionResult selectedProducts = new ProductSelectionResult(BigDecimal.ZERO, "Không chọn sản phẩm", new LinkedHashMap<>());
    private KhuyenMaiDTO selectedPromotion;

    public UserBookingController(UserFrame view) {
        this.view = view;
        wireActions();
        loadMovies();
        this.view.showStep(UserFrame.STEP_MOVIES);
    }

    private void wireActions() {
        view.setLogoutListener(this::onLogout);

        view.getMovieListPanel().setMovieSelectListener(this::onMovieSelected);

        view.getShowtimeSelectionPanel().setBackListener(() -> view.showStep(UserFrame.STEP_MOVIES));
        view.getShowtimeSelectionPanel().setNextListener(this::onShowtimeSelected);

        view.getSeatSelectionPanel().setBackListener(() -> view.showStep(UserFrame.STEP_SHOWTIMES));
        view.getSeatSelectionPanel().setNextListener(this::onTicketsSelected);

        view.getProductSelectionPanel().setBackListener(() -> view.showStep(UserFrame.STEP_SEATS));
        view.getProductSelectionPanel().setNextListener(this::onProductsSelected);

        view.getPaymentPanel().setBackListener(() -> view.showStep(UserFrame.STEP_PRODUCTS));
        view.getPaymentPanel().setPayListener(this::onPay);
        view.getPaymentPanel().setPromotionChangeListener(this::onPromotionChanged);
    }

    private void onLogout() {
        int confirm = JOptionPane.showConfirmDialog(
                view,
                "Bạn có chắc muốn đăng xuất không?",
                "Xác nhận đăng xuất",
                JOptionPane.YES_NO_OPTION,
                JOptionPane.QUESTION_MESSAGE
        );

        if (confirm != JOptionPane.YES_OPTION) {
            return;
        }

        SessionManager.clearSession();
        view.dispose();
        SwingUtilities.invokeLater(() -> new LoginFrame().setVisible(true));
    }

    private void loadMovies() {
        try {
            allMovies = phimService.getAllPhim().stream()
                    .filter(m -> m.getTrangThaiPhim() == null || !"NGUNG_CHIEU".equalsIgnoreCase(m.getTrangThaiPhim()))
                    .collect(Collectors.toList());
            view.getMovieListPanel().setMovies(allMovies);
        } catch (RuntimeException ex) {
            showError("Không tải được danh sách phim", ex);
        }
    }

    private void onMovieSelected(PhimDTO movie) {
        this.selectedMovie = movie;
        try {
            currentShowtimes = suatChieuService.getAllForBooking().stream()
                    .filter(s -> s.getMaPhim() != null && movie != null && s.getMaPhim().equals(movie.getMaPhim()))
                    .collect(Collectors.toList());

            view.getShowtimeSelectionPanel().setData(movie, currentShowtimes);
            view.showStep(UserFrame.STEP_SHOWTIMES);
        } catch (RuntimeException ex) {
            showError("Không tải được danh sách suất chiếu", ex);
        }
    }

    private void onShowtimeSelected(SuatChieuDTO showtime) {
        this.selectedShowtime = showtime;
        try {
            List<VeDTO> availableTickets = banVeService.getVeTrongBySuatChieu(String.valueOf(showtime.getMaSuatChieu()));
            view.getSeatSelectionPanel().setData(selectedMovie, selectedShowtime, availableTickets);
            view.showStep(UserFrame.STEP_SEATS);
        } catch (RuntimeException ex) {
            showErrorWithAuthHint("Không tải được sơ đồ ghế/vé trống", ex);
        }
    }

    private void onTicketsSelected(List<VeDTO> tickets) {
        this.selectedTickets = new ArrayList<>(tickets);
        view.getProductSelectionPanel().setTicketSelection(selectedTickets);
        view.showStep(UserFrame.STEP_PRODUCTS);
    }

    private void onProductsSelected(ProductSelectionResult result) {
        this.selectedProducts = result;
        loadPromotionsForPayment();
        String summary = buildPaymentSummary();
        view.getPaymentPanel().setSummaryText(summary);
        view.showStep(UserFrame.STEP_PAYMENT);
    }

    private void onPromotionChanged() {
        selectedPromotion = view.getPaymentPanel().getSelectedPromotion();
        if (!isPromotionEligibleForCurrentOrder(selectedPromotion)) {
            BigDecimal minOrder = selectedPromotion != null && selectedPromotion.getDonHangToiThieu() != null
                    ? selectedPromotion.getDonHangToiThieu()
                    : BigDecimal.ZERO;
            selectedPromotion = null;
            view.getPaymentPanel().clearPromotionSelection();
            JOptionPane.showMessageDialog(
                    view,
                    "Đơn hàng hiện tại chưa đạt tối thiểu " + formatVnd(minOrder) + " để áp dụng khuyến mãi này.",
                    "Không đủ điều kiện khuyến mãi",
                    JOptionPane.WARNING_MESSAGE
            );
        }
        view.getPaymentPanel().setSummaryText(buildPaymentSummary());
    }

    private void loadPromotionsForPayment() {
        List<KhuyenMaiDTO> promotions;
        try {
            promotions = khuyenMaiService.getKhuyenMaiDangHieuLuc();
        } catch (RuntimeException ex) {
            promotions = List.of();
        }
        view.getPaymentPanel().setPromotions(promotions);
        selectedPromotion = view.getPaymentPanel().getSelectedPromotion();
    }

    private void onPay(String paymentMethod) {
        try {
            if (selectedTickets == null || selectedTickets.isEmpty()) {
                JOptionPane.showMessageDialog(view, "Không có vé nào để thanh toán.");
                return;
            }

            if (paymentMethod == null || paymentMethod.isBlank()) {
                JOptionPane.showMessageDialog(view, "Vui lòng chọn phương thức thanh toán.");
                return;
            }

            if (!isPromotionEligibleForCurrentOrder(selectedPromotion)) {
                BigDecimal minOrder = selectedPromotion != null && selectedPromotion.getDonHangToiThieu() != null
                        ? selectedPromotion.getDonHangToiThieu()
                        : BigDecimal.ZERO;
                selectedPromotion = null;
                view.getPaymentPanel().clearPromotionSelection();
                view.getPaymentPanel().setSummaryText(buildPaymentSummary());
                JOptionPane.showMessageDialog(
                        view,
                        "Đơn hàng hiện tại chưa đạt tối thiểu " + formatVnd(minOrder) + " để áp dụng khuyến mãi đã chọn.",
                        "Không đủ điều kiện khuyến mãi",
                        JOptionPane.WARNING_MESSAGE
                );
                return;
            }

            if (SessionManager.isCustomer()) {
                List<Integer> ticketIds = selectedTickets.stream()
                        .map(VeDTO::getMaVe)
                        .filter(id -> id != null)
                        .toList();

                Map<String, Integer> productMap = selectedProducts == null || selectedProducts.productQuantities() == null
                        ? new LinkedHashMap<>()
                        : selectedProducts.productQuantities();

                List<BanVeService.DatSanPhamItem> sanPhamItems = productMap.entrySet().stream()
                        .map(e -> new BanVeService.DatSanPhamItem(e.getKey(), e.getValue()))
                        .toList();

                String payRes = banVeService.datVeVaThanhToanKhachHang(
                        ticketIds,
                        sanPhamItems,
                        paymentMethod,
                    selectedPromotion == null ? null : selectedPromotion.getMaKhuyenMai(),
                        selectedProducts == null ? null : selectedProducts.note()
                );

                if (!isSuccessMessage(payRes)) {
                    JOptionPane.showMessageDialog(view, "Thanh toán thất bại: " + payRes);
                    return;
                }

                Integer paidOrderId = parseOrderId(payRes);
                DonHangDTO paidOrder = null;
                if (paidOrderId != null) {
                    try {
                        paidOrder = banVeService.getDonHangById(String.valueOf(paidOrderId));
                    } catch (SecurityException ignored) {
                        // Fallback to UI summary invoice when role metadata is inconsistent.
                    }
                }
                showInvoice(paidOrder, paymentMethod, paidOrderId);
                resetFlow();
                return;
            }

            Integer orderId = null;
            try {
                String orderRes = banVeService.taoDonHangTam(new DonHangTamFormDTO("User flow UI"));
                orderId = parseOrderId(orderRes);
                if (orderId == null) {
                    JOptionPane.showMessageDialog(view, "Tạo đơn hàng tạm thất bại: " + orderRes);
                    return;
                }

                for (VeDTO ve : selectedTickets) {
                    String addRes = banVeService.themVeVaoDonHang(new CapNhatVeDonHangDTO(orderId, ve.getMaVe()));
                    if (!isSuccessMessage(addRes)) {
                        JOptionPane.showMessageDialog(view, "Không thể thêm vé " + ve.getViTriGhe() + ": " + addRes);
                        safeCancelOrder(orderId);
                        return;
                    }
                }

                String payRes = banVeService.xacNhanThanhToan(new BanVeThanhToanFormDTO(orderId, paymentMethod));
                if (!isSuccessMessage(payRes)) {
                    JOptionPane.showMessageDialog(view, "Thanh toán thất bại: " + payRes);
                    safeCancelOrder(orderId);
                    return;
                }

                DonHangDTO paidOrder = banVeService.getDonHangById(String.valueOf(orderId));
                showInvoice(paidOrder, paymentMethod, orderId);
                resetFlow();
            } catch (RuntimeException ex) {
                safeCancelOrder(orderId);
                showErrorWithAuthHint("Lỗi khi thanh toán", ex);
            }
        } catch (RuntimeException ex) {
            showErrorWithAuthHint("Không thể xử lý thanh toán", ex);
        }
    }

    private String buildPaymentSummary() {
        BigDecimal ticketTotal = selectedTickets.stream()
                .map(VeDTO::getGiaVe)
                .filter(v -> v != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal productTotal = selectedProducts == null ? BigDecimal.ZERO : selectedProducts.extraAmount();
        BigDecimal grossTotal = ticketTotal.add(productTotal);
        BigDecimal discount = calculatePromotionDiscount(grossTotal, selectedPromotion);
        BigDecimal uiTotal = grossTotal.subtract(discount).max(BigDecimal.ZERO);

        String showtimeText = selectedShowtime == null || selectedShowtime.getNgayGioChieu() == null
                ? "-"
                : selectedShowtime.getNgayGioChieu().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));

        String seatText = selectedTickets.stream()
                .map(VeDTO::getViTriGhe)
                .collect(Collectors.joining(", "));

        return "Phim: " + (selectedMovie == null ? "-" : selectedMovie.getTenPhim()) + "\n"
                + "Suất chiếu: " + showtimeText + "\n"
                + "Phòng: " + (selectedShowtime == null ? "-" : selectedShowtime.getTenPhongChieu()) + "\n\n"
            + "Ghế đã chọn: " + seatText + "\n"
            + "Số lượng vé: " + selectedTickets.size() + "\n"
                + "Tiền vé: " + formatVnd(ticketTotal) + "\n"
            + "Đồ ăn và thức uống: " + formatVnd(productTotal) + "\n"
            + "Chi tiết sản phẩm: " + (selectedProducts == null ? "Không chọn sản phẩm" : selectedProducts.note()) + "\n"
            + "Khuyến mãi: " + formatPromotionLabel(selectedPromotion) + "\n"
            + "Giảm giá: -" + formatVnd(discount) + "\n"
            + "Tổng thanh toán dự kiến: " + formatVnd(uiTotal);
    }

    private void showInvoice(DonHangDTO order, String paymentMethod, Integer orderIdHint) {
        BigDecimal ticketTotal = selectedTickets.stream()
            .map(VeDTO::getGiaVe)
            .filter(v -> v != null)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal productTotal = selectedProducts == null ? BigDecimal.ZERO : selectedProducts.extraAmount();
        BigDecimal grossTotal = ticketTotal.add(productTotal);
        BigDecimal discount = calculatePromotionDiscount(grossTotal, selectedPromotion);
        BigDecimal uiTotal = grossTotal.subtract(discount).max(BigDecimal.ZERO);

        StringBuilder sb = new StringBuilder();
        sb.append("THANH TOÁN THÀNH CÔNG\n\n");
        Integer orderCode = order != null ? order.getMaDonHang() : orderIdHint;
        sb.append("Mã đơn hàng: ").append(orderCode == null ? "-" : orderCode).append("\n");
        sb.append("Phương thức: ").append(toPaymentMethodLabel(paymentMethod)).append("\n");
        sb.append("Phim: ").append(selectedMovie == null ? "-" : selectedMovie.getTenPhim()).append("\n");

        String showtimeText = selectedShowtime == null || selectedShowtime.getNgayGioChieu() == null
                ? "-"
                : selectedShowtime.getNgayGioChieu().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        sb.append("Suất chiếu: ").append(showtimeText).append("\n");

        sb.append("Ghế: ").append(selectedTickets.stream().map(VeDTO::getViTriGhe).collect(Collectors.joining(", "))).append("\n");
        sb.append("Số lượng vé: ").append(selectedTickets.size()).append("\n");
        sb.append("Sản phẩm: ").append(selectedProducts == null ? "Không chọn sản phẩm" : selectedProducts.note()).append("\n");
        sb.append("Khuyến mãi: ").append(formatPromotionLabel(selectedPromotion)).append("\n");
        sb.append("Giảm giá: -").append(formatVnd(discount)).append("\n");

        if (order != null && order.getTongTien() != null) {
            sb.append("Tổng thanh toán: ").append(formatVnd(order.getTongTien())).append("\n");
        } else {
            sb.append("Tổng thanh toán: ").append(formatVnd(uiTotal)).append("\n");
        }
        sb.append("\nCảm ơn bạn đã đặt vé tại rạp.");

        InvoiceDialog dialog = new InvoiceDialog(view, "Hóa đơn", sb.toString());
        dialog.setVisible(true);
    }

    private void resetFlow() {
        selectedMovie = null;
        selectedShowtime = null;
        selectedTickets = new ArrayList<>();
        selectedProducts = new ProductSelectionResult(BigDecimal.ZERO, "Không chọn sản phẩm", new LinkedHashMap<>());
        selectedPromotion = null;
        view.getPaymentPanel().setPromotions(List.of());

        loadMovies();
        view.showStep(UserFrame.STEP_MOVIES);
    }

    private boolean isSuccessMessage(String message) {
        if (message == null) {
            return false;
        }
        String lower = message.toLowerCase();
        return lower.contains("thành công") || lower.contains("success");
    }

    private Integer parseOrderId(String response) {
        if (response == null) {
            return null;
        }
        Matcher matcher = Pattern.compile("Mã\\s*đơn\\s*hàng\\s*:\\s*(\\d+)", Pattern.CASE_INSENSITIVE).matcher(response);
        if (matcher.find()) {
            return Integer.valueOf(matcher.group(1));
        }
        return null;
    }

    private String toPaymentMethodLabel(String paymentMethod) {
        if (paymentMethod == null) {
            return "-";
        }
        return switch (paymentMethod.trim().toUpperCase()) {
            case "TIEN_MAT" -> "Tiền mặt";
            case "THE_NGAN_HANG" -> "Thẻ ngân hàng";
            case "MOMO" -> "Ví MoMo";
            case "ZALOPAY" -> "ZaloPay";
            default -> paymentMethod;
        };
    }

    private String formatPromotionLabel(KhuyenMaiDTO promotion) {
        if (promotion == null) {
            return "Không áp dụng";
        }
        return promotion.getTenKhuyenMai() == null || promotion.getTenKhuyenMai().isBlank()
                ? "Khuyến mãi #" + promotion.getMaKhuyenMai()
                : promotion.getTenKhuyenMai();
    }

    private BigDecimal calculatePromotionDiscount(BigDecimal grossTotal, KhuyenMaiDTO promotion) {
        if (grossTotal == null || grossTotal.compareTo(BigDecimal.ZERO) <= 0 || promotion == null) {
            return BigDecimal.ZERO;
        }

        BigDecimal minOrder = promotion.getDonHangToiThieu() == null ? BigDecimal.ZERO : promotion.getDonHangToiThieu();
        if (grossTotal.compareTo(minOrder) < 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal raw;
        if ("%".equals(promotion.getKieuGiaTri())) {
            BigDecimal percent = promotion.getGiaTri() == null ? BigDecimal.ZERO : promotion.getGiaTri();
            raw = grossTotal.multiply(percent).divide(BigDecimal.valueOf(100), 0, java.math.RoundingMode.HALF_UP);
        } else {
            raw = promotion.getGiaTri() == null ? BigDecimal.ZERO : promotion.getGiaTri();
        }

        if (raw.compareTo(BigDecimal.ZERO) < 0) {
            return BigDecimal.ZERO;
        }
        return raw.min(grossTotal);
    }

    private boolean isPromotionEligibleForCurrentOrder(KhuyenMaiDTO promotion) {
        if (promotion == null) {
            return true;
        }
        BigDecimal grossTotal = calculateCurrentGrossTotal();
        BigDecimal minOrder = promotion.getDonHangToiThieu() == null ? BigDecimal.ZERO : promotion.getDonHangToiThieu();
        return grossTotal.compareTo(minOrder) >= 0;
    }

    private BigDecimal calculateCurrentGrossTotal() {
        BigDecimal ticketTotal = selectedTickets.stream()
                .map(VeDTO::getGiaVe)
                .filter(v -> v != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal productTotal = selectedProducts == null ? BigDecimal.ZERO : selectedProducts.extraAmount();
        return ticketTotal.add(productTotal);
    }

    private void safeCancelOrder(Integer orderId) {
        if (orderId == null) {
            return;
        }
        try {
            banVeService.huyDonHangTam(String.valueOf(orderId));
        } catch (RuntimeException ignored) {
            // Ignore because the main flow already handles failure messaging.
        }
    }

    private String formatVnd(BigDecimal amount) {
        NumberFormat format = NumberFormat.getCurrencyInstance(VI_VN);
        return format.format(amount == null ? BigDecimal.ZERO : amount);
    }

    private void showError(String title, Exception ex) {
        SwingUtilities.invokeLater(() ->
                JOptionPane.showMessageDialog(view, title + ": " + ex.getMessage(), "Lỗi", JOptionPane.ERROR_MESSAGE)
        );
    }

    private void showErrorWithAuthHint(String title, Exception ex) {
        String safeMessage = ex.getMessage() == null ? "Vui lòng thử lại." : ex.getMessage();
        SwingUtilities.invokeLater(() ->
            JOptionPane.showMessageDialog(view, title + ": " + safeMessage,
                        "Lỗi", JOptionPane.ERROR_MESSAGE)
        );
    }
}
