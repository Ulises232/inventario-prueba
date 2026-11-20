package com.inventario.controller;

import com.inventario.entity.TipoMovimiento;
import com.inventario.service.InventarioService;
import java.time.format.DateTimeFormatter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class HistoricoController {
    private static final DateTimeFormatter FORMATO_FECHA = DateTimeFormatter.ofPattern("dd/MM/uuuu HH:mm:ss");

    private final InventarioService inventario;

    @GetMapping("/historico")
    public String init(@RequestParam(name = "tipo", required = false) TipoMovimiento tipo, Model model) {
        model.addAttribute("movimientos", inventario.listarMovimientos(tipo));
        model.addAttribute("tipos", TipoMovimiento.values());
        model.addAttribute("tipoSeleccionado", tipo);
        model.addAttribute("formatoFecha", FORMATO_FECHA);
        return "historico";
    }
}
