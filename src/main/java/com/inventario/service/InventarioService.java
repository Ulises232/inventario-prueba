package com.inventario.service;

import com.inventario.commons.UsuarioActual;
import com.inventario.entity.Producto;
import com.inventario.entity.ProductoHistorico;
import com.inventario.entity.TipoMovimiento;
import com.inventario.entity.Usuario;
import com.inventario.repository.ProductoHistoricoRepository;
import com.inventario.repository.ProductoRepository;
import jakarta.persistence.EntityNotFoundException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@PreAuthorize("hasAnyRole('ADMINISTRADOR', 'ALMACENISTA')")
public class InventarioService {
    private static final ZoneId ZONA_HORARIA = ZoneId.of("America/Mexico_City");

    private final ProductoRepository productos;
    private final ProductoHistoricoRepository historico;
    private final UsuarioActual usuarioActual;

    public List<Producto> listar() {
        return productos.findAll(Sort.by("nombre").ascending());
    }

    public List<Producto> listarActivos() {
        return productos.findByActivoTrueOrderByNombreAsc();
    }

    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public List<ProductoHistorico> listarMovimientos(TipoMovimiento tipo) {
        return historico.listar(tipo);
    }

    public Producto getById(Integer id) {
        return productos.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado."));
    }

    @Transactional
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public Producto crear(String nombre, BigDecimal precio, boolean activo) {
        String nombreValidado = validarNombre(nombre);
        BigDecimal precioValidado = validarPrecio(precio);
        Usuario usuario = usuarioActual.obtenerUsuarioActual();

        Producto producto = new Producto();
        producto.setNombre(nombreValidado);
        producto.setPrecio(precioValidado);
        producto.setActivo(activo);
        producto.setFechaAlta(LocalDateTime.now(ZONA_HORARIA));
        producto.setUsuarioAlta(usuario);
        return guardarConMovimiento(producto, TipoMovimiento.CREAR, 0);
    }

    @Transactional
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public Producto actualizar(Integer id, String nombre, BigDecimal precio, boolean activo) {
        String nombreValidado = validarNombre(nombre);
        BigDecimal precioValidado = validarPrecio(precio);
        Usuario usuario = usuarioActual.obtenerUsuarioActual();
        Producto producto = obtenerParaModificar(id);

        producto.setNombre(nombreValidado);
        producto.setPrecio(precioValidado);
        producto.setActivo(activo);
        registrarModificacion(producto, usuario);
        return productos.save(producto);
    }

    @Transactional
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public Producto agregarCantidad(Integer id, Integer cantidad) {
        return ajustarExistencias(id, cantidadPositiva(cantidad));
    }

    @Transactional
    @PreAuthorize("hasRole('ALMACENISTA')")
    public Producto retirarCantidad(Integer id, Integer cantidad) {
        return ajustarExistencias(id, -cantidadPositiva(cantidad));
    }

    @Transactional
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public Producto cambiarEstatus(Integer id, boolean activo) {
        Usuario usuario = usuarioActual.obtenerUsuarioActual();
        Producto producto = obtenerParaModificar(id);
        producto.setActivo(activo);
        registrarModificacion(producto, usuario);
        return productos.save(producto);
    }

    private Producto obtenerParaModificar(Integer id) {
        return productos.findForUpdateByIdProducto(id)
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado."));
    }

    private int cantidadPositiva(Integer cantidad) {
        if (cantidad == null || cantidad <= 0) {
            throw new IllegalArgumentException("La cantidad debe ser un número entero mayor que 0.");
        }
        return cantidad;
    }

    private Producto ajustarExistencias(Integer id, int cambio) {
        Producto producto = obtenerParaModificar(id);
        if (cambio < 0 && !producto.isActivo()) {
            throw new IllegalArgumentException("El producto está inactivo y no admite salidas.");
        }
        int cantidadInicial = producto.getCantidad();
        long nuevaCantidad = (long) cantidadInicial + cambio;
        if (nuevaCantidad < 0) {
            throw new IllegalArgumentException("La cantidad solicitada supera las existencias disponibles ("
                    + cantidadInicial + ").");
        }
        if (nuevaCantidad > Integer.MAX_VALUE) {
            throw new IllegalArgumentException("La cantidad excede el máximo permitido.");
        }

        producto.setCantidad((int) nuevaCantidad);
        registrarModificacion(producto, usuarioActual.obtenerUsuarioActual());
        TipoMovimiento accion = cambio > 0 ? TipoMovimiento.ENTRADA : TipoMovimiento.SALIDA;
        return guardarConMovimiento(producto, accion, cantidadInicial);
    }

    private Producto guardarConMovimiento(Producto producto, TipoMovimiento accion, int cantidadInicial) {
        Producto guardado = productos.save(producto);
        historico.save(new ProductoHistorico(guardado, accion, cantidadInicial));
        return guardado;
    }

    private String validarNombre(String nombre) {
        if (nombre == null || nombre.isBlank()) {
            throw new IllegalArgumentException("El nombre es obligatorio.");
        }
        String nombreValidado = nombre.strip();
        if (nombreValidado.length() > 100) {
            throw new IllegalArgumentException("El nombre no puede superar los 100 caracteres.");
        }
        return nombreValidado;
    }

    private BigDecimal validarPrecio(BigDecimal precio) {
        if (precio == null) {
            throw new IllegalArgumentException("El precio es obligatorio.");
        }
        if (precio.signum() <= 0) {
            throw new IllegalArgumentException("El precio debe ser mayor que 0.");
        }

        BigDecimal precioValidado;
        try {
            precioValidado = precio.setScale(2, RoundingMode.UNNECESSARY);
        } catch (ArithmeticException exception) {
            throw new IllegalArgumentException("El precio debe tener como máximo dos decimales.");
        }
        if (precioValidado.precision() > 12) {
            throw new IllegalArgumentException("El precio no puede superar $9,999,999,999.99.");
        }
        return precioValidado;
    }

    private void registrarModificacion(Producto producto, Usuario usuario) {
        producto.setUsuarioModificacion(usuario);
        producto.setFechaModificacion(LocalDateTime.now(ZONA_HORARIA));
    }
}
