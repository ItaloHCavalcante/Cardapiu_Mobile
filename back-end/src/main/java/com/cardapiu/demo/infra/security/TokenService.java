package com.cardapiu.demo.infra.security;


import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.cardapiu.demo.models.Usuario;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

@Service
public class TokenService {

    @Value("${api.security.token.secret}")
    private String secret;

    //Metodo para gerar o token
    public String gerarToken(Usuario usuario) {
        try {
            Algorithm algorithm = Algorithm.HMAC256(secret);
            // Adicionando a role como um claim no token
            return JWT.create()
                    .withIssuer("auth-api")
                    .withSubject(usuario.getLogin())
                    .withClaim("role", usuario.getRole().name()) // <-- LINHA ADICIONADA/CORRIGIDA
                    .withExpiresAt(genExpirationDate())
                    .sign(algorithm);
        }catch (JWTCreationException exception){
            throw new RuntimeException("Erro ao fazer login", exception);
        }
    }

    public String validarToken(String token) {
        try{
            Algorithm algorithm = Algorithm.HMAC256(secret);
            return JWT.require(algorithm)
                    .withIssuer("auth-api")
                    .build()
                    .verify(token)
                    .getSubject();
        }catch (JWTVerificationException exception){
            return ""; // Se o token for inválido ou expirado, retorna vazio
        }
    }
    private Instant genExpirationDate() {
        // Usando a propriedade JWT_EXPIRATION do .env
        // Convertendo de milissegundos para horas para usar com plusHours
        long expirationMillis = Long.parseLong(System.getProperty("JWT_EXPIRATION"));
        long expirationHours = expirationMillis / (1000 * 60 * 60); // Convertendo ms para horas

        return LocalDateTime.now().plusHours(expirationHours).toInstant(ZoneOffset.of("-03:00"));
    }


}