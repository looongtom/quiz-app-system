package com.example.sse;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
@CrossOrigin(origins = "*") // This enables CORS for all origins
public class SseController {
    private SseService sseService;

    public SseController(SseService sseService) {
        this.sseService = sseService;
    }

    @GetMapping(path = "/sse", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter subscribe() {
        SseEmitter emitter = new SseEmitter(Long.MAX_VALUE);
        // Add the emitter to a list of subscribers or handle it in another way
        sseService.addEmitter(emitter);
//        sseService.sendEvents("New user connected");
        return emitter;
    }

    @GetMapping(path = "/send-message")
    //call subscribe method to send message to all subscribers
    public void sendMessage(@RequestParam String message) {
        sseService.message = message;
    }

}
