package com.cardapiu.demo.controllers;


import com.cardapiu.demo.dtos.AuthenticationDTO;
import com.cardapiu.demo.dtos.LoginResponseDTO;
import com.cardapiu.demo.dtos.RegisterDTO;
import com.cardapiu.demo.infra.security.TokenService;
import com.cardapiu.demo.models.Usuario;
import com.cardapiu.demo.repositories.UsuarioRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("auth")
public class AuthenticationController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UsuarioRepository repository;

    @Autowired
    private TokenService tokenService;

    @PostMapping("/login")
    public ResponseEntity login(@RequestBody @Valid AuthenticationDTO data){
        // Gera uma requisição de login e senha para o spring conferir
        var usernamePassword = new UsernamePasswordAuthenticationToken(data.login(), data.senha());

        // O authenticationManeger vai no Banco de Dadods e checa se a senha está correta
        var auth = this.authenticationManager.authenticate(usernamePassword);

        //Se estiver tudo certo, o spring vai gerar um TOKEN para o usuário.
        var token = tokenService.gerarToken((Usuario) auth.getPrincipal());

        return ResponseEntity.ok(new LoginResponseDTO(token));
    }
    @PostMapping("/register")
    public ResponseEntity register(@RequestBody @Valid RegisterDTO data){
        if(this.repository.findByLogin(data.login()) != null) return ResponseEntity.badRequest().build();

        String encryptedPassword = new BCryptPasswordEncoder().encode(data.senha());

        Usuario novoUsuario = new Usuario();
        novoUsuario.setLogin(data.login());
        novoUsuario.setSenha(encryptedPassword);

        this.repository.save(novoUsuario);
        return ResponseEntity.ok().build();

    }
}
