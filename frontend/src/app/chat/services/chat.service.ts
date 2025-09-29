import { Injectable } from '@angular/core';
import { Client, IMessage } from '@stomp/stompjs';
import SockJS from 'sockjs-client';
import { Observable, Subject } from 'rxjs';

export interface ChatMessage {
  sender: string;
  content: string;
  type: 'CHAT' | 'JOIN' | 'LEAVE';
}

@Injectable({
  providedIn: 'root'
})
export class ChatService {
  private stompClient: Client | null = null;
  private messageSubject = new Subject<ChatMessage>();
  public messages$: Observable<ChatMessage> = this.messageSubject.asObservable();

  connect(username: string): void {
    this.stompClient = new Client({
      webSocketFactory: () => new SockJS('http://localhost:8080/ws'),
      reconnectDelay: 5000
    });

    this.stompClient.onConnect = () => {
      this.stompClient?.subscribe('/topic/chat', (msg: IMessage) => {
        const message: ChatMessage = JSON.parse(msg.body);
        this.messageSubject.next(message);
      });

      this.sendMessage({ sender: username, content: '', type: 'JOIN' });
    };

    this.stompClient.onStompError = (err) => {
      console.error('WebSocket connection error:', err);
    };

    this.stompClient.activate();
  }

  sendMessage(message: ChatMessage): void {
    this.stompClient?.publish({
      destination: '/app/chat.sendMessage',
      body: JSON.stringify(message)
    });
  }

  disconnect(): void {
    this.stompClient?.deactivate();
  }
}