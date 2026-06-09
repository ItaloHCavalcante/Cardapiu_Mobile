package com.cardapiu.demo.infra;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.io.InputStream;

@Configuration
public class FirebaseConfig {

    @Bean
    public FirebaseApp initializeFirebase() throws IOException {
        // **IMPORTANTE:** Você precisa gerar este arquivo no seu console do Firebase
        // e colocá-lo na pasta `src/main/resources`
        ClassPathResource resource = new ClassPathResource("cardapiu-firebase-adminsdk.json");

        if (!resource.exists()) {
            System.err.println("=======================================================================");
            System.err.println("ARQUIVO DE CONFIGURAÇÃO DO FIREBASE NÃO ENCONTRADO!");
            System.err.println("Caminho esperado: src/main/resources/cardapiu-firebase-adminsdk.json");
            System.err.println("O envio de notificações push não funcionará.");
            System.err.println("=======================================================================");
            // Retorna null ou lança uma exceção para impedir a inicialização se o arquivo for crítico
            return null;
        }

        InputStream serviceAccount = resource.getInputStream();

        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

        if (FirebaseApp.getApps().isEmpty()) {
            System.out.println("Inicializando Firebase Admin SDK...");
            return FirebaseApp.initializeApp(options);
        } else {
            return FirebaseApp.getInstance();
        }
    }
}
