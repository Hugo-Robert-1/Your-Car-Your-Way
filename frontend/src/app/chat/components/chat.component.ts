import { Component, OnDestroy } from '@angular/core';
import { ChatService, ChatMessage } from '../services/chat.service';
import { Subscription } from 'rxjs';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule]
})
export class ChatComponent implements OnDestroy {
  username = '';
  message = '';
  connected = false;
  messages: ChatMessage[] = [];
  private sub: Subscription | null = null;

  constructor(private chatService: ChatService) {}

  connect(): void {
    if (!this.username.trim()) return;

    this.connected = true;
    this.sub = this.chatService.messages$.subscribe(msg => this.messages.push(msg));
    this.chatService.connect(this.username);
  }

  sendMessage(): void {
    if (!this.message.trim()) return;

    const chatMessage: ChatMessage = {
      sender: this.username,
      content: this.message,
      type: 'CHAT'
    };

    this.chatService.sendMessage(chatMessage);
    this.message = '';
  }

  getAvatarColor(sender: string): string {
    const colors = ['#2196F3', '#32c787', '#00BCD4', '#ff5652', '#ffc107', '#ff85af', '#FF9800', '#39bbb0'];
    let hash = 0;
    for (let i = 0; i < sender.length; i++) {
      hash = 31 * hash + sender.charCodeAt(i);
    }
    return colors[Math.abs(hash % colors.length)];
  }

  ngOnDestroy(): void {
    this.sub?.unsubscribe();
    this.chatService.disconnect();
  }
}