package com.inventario.config;

import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableMethodSecurity
public class SeguridadConfig {



    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .authorizeHttpRequests(auth -> auth
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                        .requestMatchers("/login", "/css/**", "/js/**", "/img/**", "/favicon.ico").permitAll()

                        .requestMatchers(
                                "/inventario/nuevo",
                                "/inventario/guardar",
                                "/inventario/entrada/**",
                                "/inventario/estado/**"
                        ).hasRole("ADMINISTRADOR")

                        .requestMatchers("/inventario", "/inventario/**")
                        .hasAnyRole("ADMINISTRADOR", "ALMACENISTA")

                        .requestMatchers("/salida", "/salida/**")
                        .hasRole("ALMACENISTA")

                        .requestMatchers("/historico", "/historico/**")
                        .hasRole("ADMINISTRADOR")

                        .anyRequest().authenticated())
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .defaultSuccessUrl("/bienvenido", true)
                        .failureUrl("/login?error")
                        .permitAll())
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .permitAll())
                .build();
    }



    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
