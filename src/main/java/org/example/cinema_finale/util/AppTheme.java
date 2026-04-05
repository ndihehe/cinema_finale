package org.example.cinema_finale.util;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JPasswordField;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.UIManager;
import javax.swing.border.Border;
import javax.swing.border.CompoundBorder;
import javax.swing.border.EmptyBorder;
import javax.swing.border.TitledBorder;
import javax.swing.plaf.FontUIResource;
import javax.swing.table.JTableHeader;

import com.formdev.flatlaf.FlatDarkLaf;
import com.formdev.flatlaf.FlatLightLaf;

public final class AppTheme {

    public enum ThemeMode {
        DARK,
        LIGHT
    }

    public static Color BG_APP = new Color(29, 33, 40);
    public static Color BG_CARD = new Color(40, 45, 54);
    public static Color BG_INPUT = new Color(34, 39, 47);
    public static Color TEXT_PRIMARY = new Color(235, 239, 244);
    public static Color TEXT_MUTED = new Color(160, 172, 186);

    public static final Color PRIMARY = new Color(59, 130, 246);
    public static final Color SUCCESS = new Color(34, 197, 94);
    public static final Color WARNING = new Color(245, 158, 11);
    public static final Color DANGER = new Color(239, 68, 68);

    private static ThemeMode currentMode = ThemeMode.DARK;

    private AppTheme() {
    }

    public static void installGlobal() {
        installDark();
    }

    public static void installDark() {
        currentMode = ThemeMode.DARK;
        FlatDarkLaf.setup();
        BG_APP = new Color(29, 33, 40);
        BG_CARD = new Color(40, 45, 54);
        BG_INPUT = new Color(34, 39, 47);
        TEXT_PRIMARY = new Color(235, 239, 244);
        TEXT_MUTED = new Color(160, 172, 186);
        applySharedDefaults();
    }

    public static void installLight() {
        currentMode = ThemeMode.LIGHT;
        FlatLightLaf.setup();
        BG_APP = new Color(241, 245, 249);
        BG_CARD = new Color(255, 255, 255);
        BG_INPUT = new Color(248, 250, 252);
        TEXT_PRIMARY = new Color(30, 41, 59);
        TEXT_MUTED = new Color(100, 116, 139);
        applySharedDefaults();
    }

    public static void toggleTheme() {
        if (currentMode == ThemeMode.DARK) {
            installLight();
        } else {
            installDark();
        }
    }

    public static ThemeMode getCurrentMode() {
        return currentMode;
    }

    public static Color getTableHeaderBackground() {
        if (currentMode == ThemeMode.LIGHT) {
            return new Color(226, 232, 240);
        }
        return new Color(50, 56, 66);
    }

    public static Color getTableSelectionBackground() {
        if (currentMode == ThemeMode.LIGHT) {
            return new Color(191, 219, 254);
        }
        return new Color(60, 86, 122);
    }

    public static Color getInputBorderColor() {
        if (currentMode == ThemeMode.LIGHT) {
            return new Color(148, 163, 184);
        }
        return new Color(80, 90, 106);
    }

    private static void applySharedDefaults() {

        FontUIResource defaultFont = new FontUIResource("Segoe UI", Font.PLAIN, 14);
        UIManager.put("defaultFont", defaultFont);

        UIManager.put("Component.arc", 12);
        UIManager.put("Button.arc", 12);
        UIManager.put("TextComponent.arc", 10);
        UIManager.put("ScrollBar.width", 12);
        UIManager.put("Table.showHorizontalLines", false);
        UIManager.put("Table.showVerticalLines", false);

        UIManager.put("Panel.background", BG_APP);
        UIManager.put("Viewport.background", BG_APP);
        UIManager.put("Label.foreground", TEXT_PRIMARY);

        UIManager.put("TextField.background", BG_INPUT);
        UIManager.put("TextField.foreground", TEXT_PRIMARY);
        UIManager.put("TextField.caretForeground", TEXT_PRIMARY);

        UIManager.put("ComboBox.background", BG_INPUT);
        UIManager.put("ComboBox.foreground", TEXT_PRIMARY);

        UIManager.put("Table.background", BG_CARD);
        UIManager.put("Table.foreground", TEXT_PRIMARY);
        UIManager.put("Table.selectionBackground", getTableSelectionBackground());
        UIManager.put("Table.selectionForeground", TEXT_PRIMARY);

        UIManager.put("TableHeader.background", getTableHeaderBackground());
        UIManager.put("TableHeader.foreground", TEXT_PRIMARY);
    }

    public static void styleTitledPanel(JComponent component, String title) {
        Border line = BorderFactory.createLineBorder(new Color(70, 78, 91));
        TitledBorder titled = BorderFactory.createTitledBorder(line, title);
        titled.setTitleColor(TEXT_PRIMARY);
        titled.setTitleFont(new Font("Segoe UI", Font.BOLD, 13));

        component.setBorder(new CompoundBorder(titled, new EmptyBorder(6, 6, 6, 6)));
        component.setBackground(BG_APP);
    }

    public static void styleSearchField(JTextField field) {
        field.setBackground(BG_INPUT);
        field.setForeground(TEXT_PRIMARY);
        field.setCaretColor(TEXT_PRIMARY);
        field.setBorder(new CompoundBorder(
            BorderFactory.createLineBorder(getInputBorderColor()),
                new EmptyBorder(6, 10, 6, 10)
        ));
    }

    public static void stylePasswordField(JPasswordField field) {
        field.setBackground(BG_INPUT);
        field.setForeground(TEXT_PRIMARY);
        field.setCaretColor(TEXT_PRIMARY);
        field.setBorder(new CompoundBorder(
            BorderFactory.createLineBorder(getInputBorderColor()),
                new EmptyBorder(6, 10, 6, 10)
        ));
    }

    public static void styleTable(JTable table) {
        table.setRowHeight(30);
        table.setForeground(TEXT_PRIMARY);
        table.setBackground(BG_CARD);
        table.setSelectionBackground(getTableSelectionBackground());
        table.setSelectionForeground(TEXT_PRIMARY);

        JTableHeader header = table.getTableHeader();
        header.setForeground(TEXT_PRIMARY);
        header.setBackground(getTableHeaderBackground());
        header.setFont(new Font("Segoe UI", Font.BOLD, 13));
    }

    public static void styleActionButton(JButton button, Color color) {
        button.setBackground(color);
        button.setForeground(Color.WHITE);
        button.setFocusPainted(false);
        button.setFont(new Font("Segoe UI", Font.BOLD, 13));
        button.setBorder(BorderFactory.createEmptyBorder(7, 14, 7, 14));
        button.setCursor(new Cursor(Cursor.HAND_CURSOR));
    }

    public static void styleSuccessButton(JButton button) {
        styleActionButton(button, SUCCESS);
    }

    public static void styleWarningButton(JButton button) {
        styleActionButton(button, WARNING);
    }

    public static void styleDangerButton(JButton button) {
        styleActionButton(button, DANGER);
    }

    public static void stylePrimaryButton(JButton button) {
        styleActionButton(button, PRIMARY);
    }
}
