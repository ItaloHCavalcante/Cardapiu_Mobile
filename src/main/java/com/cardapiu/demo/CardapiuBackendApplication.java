package com.cardapiu.demo;

import com.cardapiu.demo.models.Produto;
import com.cardapiu.demo.repositories.ProdutoRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class CardapiuBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(CardapiuBackendApplication.class, args);

	}
}