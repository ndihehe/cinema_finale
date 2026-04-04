package org.example.cinema_finale.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public final class PosterStorageUtil {

    private static final String POSTER_DIR = "posters";

    private PosterStorageUtil() {
    }

    public static String storePoster(File sourceFile) throws IOException {
        if (sourceFile == null || !sourceFile.exists()) {
            throw new IOException("File poster không tồn tại.");
        }

        Path targetDir = Path.of(System.getProperty("user.dir"), POSTER_DIR);
        Files.createDirectories(targetDir);

        String extension = getExtension(sourceFile.getName());
        String fileName = "poster_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS")) + extension;

        Path targetPath = targetDir.resolve(fileName);
        Files.copy(sourceFile.toPath(), targetPath, StandardCopyOption.REPLACE_EXISTING);

        return targetPath.toString();
    }

    public static void deletePosterQuietly(String posterPath) {
        if (posterPath == null || posterPath.isBlank()) {
            return;
        }

        try {
            Files.deleteIfExists(Path.of(posterPath));
        } catch (IOException ignored) {
            // Best effort cleanup only
        }
    }

    private static String getExtension(String fileName) {
        int idx = fileName.lastIndexOf('.');
        if (idx < 0 || idx == fileName.length() - 1) {
            return ".jpg";
        }
        return fileName.substring(idx);
    }
}
