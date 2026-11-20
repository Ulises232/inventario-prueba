package com.inventario.controller;

import com.inventario.dto.CantidadRequest;
import com.inventario.dto.ProductoRequest;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

@Controller
@RequiredArgsConstructor
public class InventarioController {
    private final InventarioService inventario;

    @GetMapping("/inventario")
    public String init(Model model) {
        model.addAttribute("productos", inventario.listar());
        return "inventario";
    }

    @PostMapping("/inventario/guardar")
    @ResponseBody
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void guardar(@Valid @ModelAttribute ProductoRequest request) {
        if (request.getId() == null) {
            inventario.crear(request.getNombre(), request.getPrecio(), request.getActivo());
        } else {
            inventario.actualizar(request.getId(), request.getNombre(), request.getPrecio(), request.getActivo());
        }
    }

    @PostMapping("/inventario/entrada/{id}")
    @ResponseBody
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void entrada(@PathVariable Integer id, @Valid @ModelAttribute CantidadRequest request) {
        inventario.agregarCantidad(id, request.getCantidad());
    }

    @PostMapping("/inventario/estado/{id}")
    @ResponseBody
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void cambiarEstatus(@PathVariable Integer id, @RequestParam("activo") boolean activo) {
        inventario.cambiarEstatus(id, activo);
    }
}
