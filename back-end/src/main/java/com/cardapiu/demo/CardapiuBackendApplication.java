package com.cardapiu.demo;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CardapiuBackendApplication {

	public static void main(String[] args) {
		Dotenv dotenv = Dotenv.configure()
				.ignoreIfMissing()
				.load();

		if (dotenv.get("JWT_SECRET") != null) {
			System.setProperty("JWT_SECRET", dotenv.get("JWT_SECRET"));
		}

		if (dotenv.get("DB_PASSWORD") != null) {
			System.setProperty("DB_PASSWORD", dotenv.get("DB_PASSWORD"));
		}
		if (dotenv.get("DB_URL") != null) {
			System.setProperty("DB_URL", dotenv.get("DB_URL"));
		}
		if (dotenv.get("DB_USER") != null) {
			System.setProperty("DB_USER", dotenv.get("DB_USER"));
		}


		SpringApplication.run(CardapiuBackendApplication.class, args);
	}
}
