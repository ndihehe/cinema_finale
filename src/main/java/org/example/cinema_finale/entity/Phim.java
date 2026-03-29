package org.example.cinema_finale.entity;

import lombok.*;
import javax.persistence.*;

@Entity
@Table(name = "phim")
@Data // Tự tạo Getter, Setter, toString nhờ Lombok
@NoArgsConstructor
@AllArgsConstructor
public class Phim {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int maPhim;

    @Column(name = "ten_phim", nullable = false)
    private String tenPhim;

    private int thoiLuong;
    private String daoDien;
    private int namSx;
}