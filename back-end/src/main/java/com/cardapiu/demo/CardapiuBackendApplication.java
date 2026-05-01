package com.cardapiu.demo;

import com.cardapiu.demo.models.Produto;
import com.cardapiu.demo.repositories.ProdutoRepository;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class CardapiuBackendApplication {

	public static void main(String[] args) {
		Dotenv dotenv = Dotenv.configure().load();

		System.setProperty("JWT_SECRET", dotenv.get("JWT_SECRET"));
		System.setProperty("JWT_EXPIRATION", dotenv.get("JWT_EXPIRATION"));

		SpringApplication.run(CardapiuBackendApplication.class, args);

	}
}