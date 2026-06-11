package com.cardapiu.demo;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CardapiuBackendApplication {

	public static void main(String[] args) {
		// Carrega as variáveis de ambiente do arquivo .env
		// ignoreIfMissing() permite que a aplicação inicie mesmo se o .env não for encontrado,
		// útil para ambientes de produção onde as variáveis podem vir de outras fontes.
		Dotenv dotenv = Dotenv.configure()
				.ignoreIfMissing()
				.load();

		// Define as variáveis de ambiente como propriedades de sistema
		// Isso permite que o Spring @Value("${...}") as injete
		if (dotenv.get("JWT_SECRET") != null) {
			System.setProperty("JWT_SECRET", dotenv.get("JWT_SECRET"));
		}
		// REMOVIDO: Não precisamos mais definir JWT_EXPIRATION aqui, será lido diretamente do application.properties
		// if (dotenv.get("JWT_EXPIRATION") != null) {
		// 	System.setProperty("JWT_EXPIRATION", dotenv.get("JWT_EXPIRATION"));
		// }
		if (dotenv.get("DB_PASSWORD") != null) {
			System.setProperty("DB_PASSWORD", dotenv.get("DB_PASSWORD"));
		}
		// Adicionei a leitura do DB_URL também, caso você use no application.properties
		if (dotenv.get("DB_URL") != null) {
			System.setProperty("DB_URL", dotenv.get("DB_URL"));
		}
		// Adicionei a leitura do DB_USER também, caso você use no application.properties
		if (dotenv.get("DB_USER") != null) {
			System.setProperty("DB_USER", dotenv.get("DB_USER"));
		}


		SpringApplication.run(CardapiuBackendApplication.class, args);
	}
}
