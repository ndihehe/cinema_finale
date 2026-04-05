package org.example.cinema_finale.dto;

public class LoginResultDTO {
    private boolean success;
    private String message;
    private String role;
    private String displayName;

    public LoginResultDTO() {
    }

    public LoginResultDTO(boolean success, String message, String role, String displayName) {
        this.success = success;
        this.message = message;
        this.role = role;
        this.displayName = displayName;
    }

    public static LoginResultDTO success(String message, String role, String displayName) {
        return new LoginResultDTO(true, message, role, displayName);
    }

    public static LoginResultDTO fail(String message) {
        return new LoginResultDTO(false, message, null, null);
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
}