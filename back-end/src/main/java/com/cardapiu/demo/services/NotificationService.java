package com.cardapiu.demo.services;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {

    public void enviarNotificacao(String tokenDispositivo, String titulo, String corpo) {
        if (tokenDispositivo == null || tokenDispositivo.isEmpty()) {
            System.out.println("Token FCM não encontrado. Notificação não enviada.");
            return;
        }

        try {
            Notification notification = Notification.builder()
                    .setTitle(titulo)
                    .setBody(corpo)
                    .build();

            Message message = Message.builder()
                    .setToken(tokenDispositivo)
                    .setNotification(notification)
                    .build();

            // envia notificação
             String response = FirebaseMessaging.getInstance().send(message);
             System.out.println("Notificação enviada com sucesso: " + response);
            
            System.out.println("Simulando envio de push notification para o token: " + tokenDispositivo);
            System.out.println("Título: " + titulo);
            System.out.println("Corpo: " + corpo);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Erro ao enviar notificação: " + e.getMessage());
        }
    }
}
