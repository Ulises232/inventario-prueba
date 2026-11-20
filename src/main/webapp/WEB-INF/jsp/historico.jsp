<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Histórico de movimientos | Inventario</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/css/tabler.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
</head>
<body>
    <div class="page app-shell">
        <jsp:include page="fragments/sidebar.jsp" />
        <main class="page-wrapper app-main">
            <header class="app-header">
                <div class="container-xl">
                    <div class="text-secondary small">Inventario / Histórico</div>
                    <h1 class="page-title">Histórico de movimientos</h1>
                </div>
            </header>
            <div class="page-body">
                <div class="container-xl">
                    <div class="card welcome-card">
                        <div class="card-header">
                            <form method="get" action="${pageContext.request.contextPath}/historico" class="d-flex flex-wrap align-items-center gap-2">
                                <label for="tipo" class="form-label mb-0">Tipo de movimiento</label>
                                <select id="tipo" name="tipo" class="form-select w-auto">
                                    <option value="">Todos</option>
                                    <c:forEach items="${tipos}" var="tipo">
                                        <option value="${tipo.name()}" ${tipo eq tipoSeleccionado ? 'selected' : ''}>${tipo.etiqueta}</option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-primary">Filtrar</button>
                            </form>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-vcenter mb-0">
                                <thead>
                                    <tr>
                                        <th scope="col">Fecha y hora</th>
                                        <th scope="col">Producto</th>
                                        <th scope="col">Movimiento</th>
                                        <th scope="col" class="text-end">Cantidad inicial</th>
                                        <th scope="col" class="text-end">Cantidad final</th>
                                        <th scope="col">Usuario</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${movimientos}" var="movimiento">
                                        <tr>
                                            <td class="text-nowrap"><time datetime="${movimiento.fechaMovimiento}">${movimiento.fechaMovimiento.format(formatoFecha)}</time></td>
                                            <td><c:out value="${movimiento.producto.nombre}" /> <span class="text-secondary">#${movimiento.producto.idProducto}</span></td>
                                            <td>${movimiento.accion.etiqueta}</td>
                                            <td class="text-end">${movimiento.cantidadInicial}</td>
                                            <td class="text-end">${movimiento.cantidadFinal}</td>
                                            <td>
                                                <c:out value="${movimiento.usuario.nombre}" />
                                                <span class="d-block text-secondary small"><c:out value="${movimiento.usuario.correo}" /></span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty movimientos}">
                                        <tr>
                                            <td colspan="6" class="text-center text-secondary">No hay movimientos para este filtro.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/js/tabler.min.js"></script>
</body>
</html>
