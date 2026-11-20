package com.inventario.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "productos_historico")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ProductoHistorico {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_historico")
    private Long idHistorico;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_producto", nullable = false)
    private Producto producto;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoMovimiento accion;

    @Column(name = "cantidad_inicial", nullable = false)
    private int cantidadInicial;

    @Column(name = "cantidad_final", nullable = false)
    private int cantidadFinal;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @Column(name = "fecha_movimiento", nullable = false)
    private LocalDateTime fechaMovimiento;

    public ProductoHistorico(Producto producto, TipoMovimiento accion, int cantidadInicial) {
        this.producto = producto;
        this.accion = accion;
        this.cantidadInicial = cantidadInicial;
        this.cantidadFinal = producto.getCantidad();
        boolean alta = accion == TipoMovimiento.CREAR;
        this.usuario = alta ? producto.getUsuarioAlta() : producto.getUsuarioModificacion();
        this.fechaMovimiento = alta ? producto.getFechaAlta() : producto.getFechaModificacion();
    }
}
