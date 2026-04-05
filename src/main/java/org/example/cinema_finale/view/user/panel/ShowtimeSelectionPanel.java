package org.example.cinema_finale.view.user.panel;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.table.AbstractTableModel;

import org.example.cinema_finale.dto.PhimDTO;
import org.example.cinema_finale.dto.SuatChieuDTO;
import org.example.cinema_finale.util.AppTheme;

public class ShowtimeSelectionPanel extends JPanel {

    private final JLabel lblMovie = new JLabel("Phim: -");
    private final JButton btnBack = new JButton("Quay lại");
    private final JButton btnNext = new JButton("Tiếp tục");
    private final JTable table;
    private final ShowtimeTableModel tableModel = new ShowtimeTableModel();

    private Runnable backListener;
    private Consumer<SuatChieuDTO> nextListener;

    public ShowtimeSelectionPanel() {
        setLayout(new BorderLayout(10, 10));
        setBackground(AppTheme.BG_APP);
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        lblMovie.setForeground(AppTheme.TEXT_PRIMARY);
        lblMovie.setFont(lblMovie.getFont().deriveFont(18f));

        table = new JTable(tableModel);
        table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        AppTheme.styleTable(table);

        JPanel bottom = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        bottom.setBackground(AppTheme.BG_APP);
        AppTheme.styleWarningButton(btnBack);
        AppTheme.stylePrimaryButton(btnNext);
        bottom.add(btnBack);
        bottom.add(btnNext);

        add(lblMovie, BorderLayout.NORTH);
        add(new JScrollPane(table), BorderLayout.CENTER);
        add(bottom, BorderLayout.SOUTH);

        btnBack.addActionListener(e -> {
            if (backListener != null) {
                backListener.run();
            }
        });

        btnNext.addActionListener(e -> {
            int row = table.getSelectedRow();
            if (row < 0) {
                javax.swing.JOptionPane.showMessageDialog(this, "Vui lòng chọn suất chiếu.");
                return;
            }
            if (nextListener != null) {
                nextListener.accept(tableModel.getAt(row));
            }
        });
    }

    public void setBackListener(Runnable backListener) {
        this.backListener = backListener;
    }

    public void setNextListener(Consumer<SuatChieuDTO> nextListener) {
        this.nextListener = nextListener;
    }

    public void setData(PhimDTO movie, List<SuatChieuDTO> showtimes) {
        lblMovie.setText("Phim: " + (movie == null ? "-" : movie.getTenPhim()));
        tableModel.setRows(showtimes == null ? List.of() : showtimes);
    }

    private static class ShowtimeTableModel extends AbstractTableModel {
        private final String[] cols = {"Mã", "Phòng", "Thời gian", "Giá cơ bản", "Trạng thái"};
        private List<SuatChieuDTO> rows = new ArrayList<>();

        public void setRows(List<SuatChieuDTO> rows) {
            this.rows = new ArrayList<>(rows);
            fireTableDataChanged();
        }

        public SuatChieuDTO getAt(int row) {
            return rows.get(row);
        }

        @Override
        public int getRowCount() {
            return rows.size();
        }

        @Override
        public int getColumnCount() {
            return cols.length;
        }

        @Override
        public String getColumnName(int column) {
            return cols[column];
        }

        @Override
        public Object getValueAt(int rowIndex, int columnIndex) {
            SuatChieuDTO s = rows.get(rowIndex);
            return switch (columnIndex) {
                case 0 -> s.getMaSuatChieu();
                case 1 -> s.getTenPhongChieu();
                case 2 -> s.getNgayGioChieu() == null ? "" : s.getNgayGioChieu().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
                case 3 -> s.getGiaVeCoBan();
                case 4 -> s.getTrangThaiSuatChieu();
                default -> "";
            };
        }
    }
}
