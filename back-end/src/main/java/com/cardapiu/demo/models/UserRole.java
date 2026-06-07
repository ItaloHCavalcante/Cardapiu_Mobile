package com.cardapiu.demo.models;

public enum UserRole {
    ADMIN("admin"),
    USER("user"),
    DELIVERER("deliverer");

    private String role;

    UserRole(String role){
        this.role = role;
    }

    public String getRole(){
        return role;
    }
}