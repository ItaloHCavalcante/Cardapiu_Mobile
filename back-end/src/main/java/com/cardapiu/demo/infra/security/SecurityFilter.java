package com.cardapiu.demo.infra.security;

import com.cardapiu.demo.repositories.UsuarioRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class SecurityFilter extends OncePerRequestFilter {

    @Autowired
    TokenService tokenService;

    @Autowired
    UsuarioRepository usuarioRepository;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        var token = this.recoverToken(request);

        // --- DEBUG: Verifica se o token foi recuperado ---
        System.out.println("DEBUG: Token recuperado: " + (token != null ? token.substring(0, Math.min(token.length(), 20)) + "..." : "null"));

        if(token != null){
            var login = tokenService.validarToken(token);
            // --- DEBUG: Verifica o login extraído do token ---
            System.out.println("DEBUG: Login extraído do token: '" + login + "'");

            if (login != null && !login.isEmpty()) { // Garante que o login não é nulo ou vazio
                UserDetails user = usuarioRepository.findByLogin(login);

                if (user != null) {
                    var authentication = new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authentication);

                    // --- DEBUG: Usuário autenticado e autoridades ---
                    System.out.println("DEBUG: Usuário autenticado: " + user.getUsername());
                    System.out.println("DEBUG: Autoridades carregadas: " + user.getAuthorities());
                } else {
                    // --- DEBUG: Usuário não encontrado no banco de dados ---
                    System.out.println("DEBUG: Usuário '" + login + "' não encontrado no banco de dados.");
                }
            } else {
                // --- DEBUG: Token inválido ou expirado ---
                System.out.println("DEBUG: Token inválido ou expirado (login vazio/nulo).");
            }
        } else {
            // --- DEBUG: Requisição sem token ---
            System.out.println("DEBUG: Requisição sem token de autenticação.");
        }

        filterChain.doFilter(request, response);
    }

    private String recoverToken(HttpServletRequest request){
        var authHeader = request.getHeader("Authorization");
        if(authHeader == null) return null;
        return authHeader.replace("Bearer ", "");
    }
}
