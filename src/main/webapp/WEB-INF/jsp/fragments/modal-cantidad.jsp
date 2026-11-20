<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="tipo" value="${param.operacion eq 'salida' ? 'salida' : 'entrada'}" />
<div class="modal fade" id="${tipo}-modal" tabindex="-1" aria-labelledby="${tipo}-modal-titulo" aria-hidden="true" data-modal-cantidad>
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" id="${tipo}-formulario" method="post">
            <div class="modal-header">
                <h2 class="modal-title" id="${tipo}-modal-titulo">${tipo eq 'salida' ? 'Salida de producto' : 'Entrada de producto'}</h2>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger d-none" data-error role="alert"></div>
                <p class="text-secondary" id="${tipo}-producto-nombre" data-nombre></p>
                <label for="${tipo}-cantidad" class="form-label">${tipo eq 'salida' ? 'Cantidad a retirar' : 'Cantidad a agregar'}</label>
                <input type="number" class="form-control" id="${tipo}-cantidad" name="cantidad" min="1" max="2147483647" step="1" required aria-describedby="${tipo}-cantidad-ayuda">
                <div class="form-hint" id="${tipo}-cantidad-ayuda">Hay <span data-existencias></span> en existencia.</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-primary">Guardar</button>
            </div>
        </form>
    </div>
</div>
