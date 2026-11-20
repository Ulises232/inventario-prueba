package com.inventario.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum TipoMovimiento {
    CREAR("Crear producto"),
    ENTRADA("Entrada"),
    SALIDA("Salida");

    private final String etiqueta;
}
