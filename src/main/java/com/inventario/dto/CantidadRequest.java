package com.inventario.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CantidadRequest {
    @NotNull(message = "La cantidad es obligatoria.")
    @Positive(message = "La cantidad debe ser un número entero mayor que 0.")
    private Integer cantidad;
}
