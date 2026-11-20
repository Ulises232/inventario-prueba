package com.inventario.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
@Controller
public class AccesoController {

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping({"/", "/bienvenido"})
    public String inicio() {
        return "inicio";
    }
}
