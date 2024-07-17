package com.example.demo.model.response;

public class ResponseEntityCustom<T> {
    private int status;
    private String message;
    private T data;

    public ResponseEntityCustom(int status, String message, T data) {
        this.status = status;
        this.message = message;
        this.data = data;
    }

}