package com.inventario.controller;

import com.inventario.dto.CantidadRequest;
import com.inventario.service.InventarioService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

@Controller
@RequiredArgsConstructor
public class SalidaController {
    private final InventarioService inventario;

    @GetMapping("/salida")
    public String init(Model model) {
        model.addAttribute("productos", inventario.listarActivos());
        return "salida";
    }

    @PostMapping("/salida/{id}")
    @ResponseBody
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void retirar(@PathVariable Integer id, @Valid @ModelAttribute CantidadRequest request) {
        inventario.retirarCantidad(id, request.getCantidad());
    }
}
