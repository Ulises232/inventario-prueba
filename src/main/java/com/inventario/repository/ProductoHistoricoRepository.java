package com.inventario.repository;

import com.inventario.entity.ProductoHistorico;
import com.inventario.entity.TipoMovimiento;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ProductoHistoricoRepository extends JpaRepository<ProductoHistorico, Long> {
    @Query("""
            select h from ProductoHistorico h
            join fetch h.producto
            join fetch h.usuario
            where (:tipo is null or h.accion = :tipo)
            order by h.fechaMovimiento desc, h.idHistorico desc
            """)
    List<ProductoHistorico> listar(@Param("tipo") TipoMovimiento tipo);
}
