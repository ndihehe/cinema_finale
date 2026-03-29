package org.example.cinema_finale.entity;

import lombok.*;
import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "suat_chieu")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SuatChieu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int maSuat;

    private LocalDateTime gioBatDau;
    private LocalDateTime gioKetThuc;

    // Quan hệ N-1: Nhiều suất chiếu thuộc về 1 bộ phim
    @ManyToOne
    @JoinColumn(name = "ma_phim")
    private Phim phim;
}