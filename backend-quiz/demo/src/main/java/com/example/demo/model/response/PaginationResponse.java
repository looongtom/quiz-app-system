package com.example.demo.model.response;

import lombok.Data;

import java.util.List;

@Data
public class PaginationResponse {
    private int totalPage;
    private int currentPage;
    private int itemPerPage;
    private long totalItem;
    private Object data;
    private String search;
}
