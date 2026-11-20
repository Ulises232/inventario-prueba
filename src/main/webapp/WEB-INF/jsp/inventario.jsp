<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="hasRole('ADMINISTRADOR')" var="esAdministrador" />
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <sec:csrfMetaTags />
    <title>Productos | Inventario</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/css/tabler.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
</head>
<body>
    <div class="page app-shell">
        <jsp:include page="fragments/sidebar.jsp" />
        <main class="page-wrapper app-main" id="inventario" data-url="${pageContext.request.contextPath}/inventario">
            <header class="app-header">
                <div class="container-xl">
                    <div class="text-secondary small">Inventario / Inventario</div>
                    <h1 class="page-title">Inventario de Productos</h1>
                </div>
            </header>
            <div class="page-body">
                <div class="container-xl">
                    <div class="alert alert-danger d-none" id="inventario-error" role="alert"></div>
                    <div class="card welcome-card">
                        <div class="card-header d-flex flex-wrap justify-content-between gap-2">
                            <h2 class="card-title">Lista de productos</h2>
                            <sec:authorize access="hasRole('ADMINISTRADOR')">
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#producto-modal" data-modo="agregar">Agregar producto</button>
                            </sec:authorize>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-vcenter mb-0">
                                <thead>
                                    <tr>
                                        <th scope="col">Nombre</th>
                                        <th scope="col" class="text-end">Precio</th>
                                        <th scope="col">Cantidad</th>
                                        <th scope="col">Estatus</th>
                                        <sec:authorize access="hasRole('ADMINISTRADOR')">
                                            <th scope="col">Acciones</th>
                                        </sec:authorize>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${productos}" var="producto">
                                    <tr>
                                        <td><c:out value="${producto.nombre}" /></td>
                                        <td class="text-end text-nowrap" data-precio="${producto.precio}">&#36;${producto.precio}</td>
                                        <td>${producto.cantidad}</td>
                                        <td>${producto.activo ? 'Activo' : 'Inactivo'}</td>
                                        <sec:authorize access="hasRole('ADMINISTRADOR')">
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <button type="button" class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#entrada-modal"
                                                            data-url="${pageContext.request.contextPath}/inventario/entrada/${producto.idProducto}"
                                                            data-producto-nombre="${fn:escapeXml(producto.nombre)}" data-existencias="${producto.cantidad}">Entrada de producto</button>
                                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#producto-modal" data-modo="editar" data-producto-id="${producto.idProducto}" data-producto-nombre="${fn:escapeXml(producto.nombre)}" data-producto-precio="${producto.precio}" data-producto-activo="${producto.activo}">Editar</button>
                                                    <button type="button" class="btn btn-sm ${producto.activo ? 'btn-outline-danger' : 'btn-outline-success'}" data-cambiar-estatus data-producto-id="${producto.idProducto}" data-activo="${not producto.activo}">${producto.activo ? 'Deshabilitar' : 'Habilitar'}</button>
                                                </div>
                                            </td>
                                        </sec:authorize>
                                    </tr>
                                    </c:forEach>
                                    <c:if test="${empty productos}">
                                        <tr>
                                            <td colspan="${esAdministrador ? 5 : 4}" class="text-center text-secondary">No hay productos registrados.</td>
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
    <sec:authorize access="hasRole('ADMINISTRADOR')">
    <div class="modal fade" id="producto-modal" tabindex="-1" aria-labelledby="producto-modal-titulo" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form class="modal-content" id="producto-formulario" method="post" action="${pageContext.request.contextPath}/inventario/guardar">
                <input type="hidden" id="producto-id" name="id">
                <div class="modal-header">
                    <h2 class="modal-title" id="producto-modal-titulo">Agregar producto</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger d-none" data-error role="alert"></div>
                    <div class="mb-3">
                        <label for="producto-nombre" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="producto-nombre" name="nombre" maxlength="100" required>
                    </div>
                    <div class="mb-3">
                        <label for="producto-precio" class="form-label">Precio</label>
                        <input type="number" class="form-control" id="producto-precio" name="precio" min="0.01" max="9999999999.99" step="0.01" required>
                    </div>
                    <div class="form-label">Estatus</div>
                    <label class="form-check form-switch mb-0" for="producto-activo">
                        <input type="checkbox" class="form-check-input" id="producto-activo" name="activo" role="switch" aria-label="Producto activo" checked>
                        <span class="form-check-label" id="producto-estatus" aria-live="polite">Activo</span>
                    </label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary" id="producto-guardar">Guardar</button>
                </div>
            </form>
        </div>
    </div>
    <jsp:include page="fragments/modal-cantidad.jsp">
        <jsp:param name="operacion" value="entrada" />
    </jsp:include>
    </sec:authorize>
    <script src="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/js/tabler.min.js"></script>
    <sec:authorize access="hasRole('ADMINISTRADOR')">
        <script src="${pageContext.request.contextPath}/js/inventario.js"></script>
    </sec:authorize>
</body>
</html>
