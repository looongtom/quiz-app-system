package com.example.demo.model.response;

import org.springframework.http.HttpStatus;

public class ResponseStatusConstants {
    public static final HttpStatus SUCCESS_STATUS = HttpStatus.OK;
    public static final HttpStatus ERROR_STATUS = HttpStatus.BAD_GATEWAY;
    public static final String SUCCESS_MESSAGE = "Success";
    public static final String ERROR_MESSAGE = "Error";
    public static final String ERROR_INSERT_MESSAGE = "Error while inserting data";
    public static final String ERROR_GET_MESSAGE = "Error while getting data";
}