package com.poc.controllers;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

import com.poc.models.Message;

@Controller
public class ChatController {

	// Envoi d'un message dans la conversation
	@MessageMapping("/chat.sendMessage")
	@SendTo("/topic/chat")
	public Message sendMessage(@Payload Message chatMessage) {
		return chatMessage;
	}

	// Ajout d'un utilisateur à la conversation
	@MessageMapping("chat.addUser")
	@SendTo("/topic/chat")
	public Message addUser(@Payload Message msg, SimpMessageHeaderAccessor headerAccessor) {
		headerAccessor.getSessionAttributes().put("username", msg.getSender());
		return msg;
	}
}