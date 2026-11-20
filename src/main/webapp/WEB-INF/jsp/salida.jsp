<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <sec:csrfMetaTags />
    <title>Salida de productos | Inventario</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/css/tabler.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
</head>
<body>
    <div class="page app-shell">
        <jsp:include page="fragments/sidebar.jsp" />
        <main class="page-wrapper app-main">
            <header class="app-header">
                <div class="container-xl">
                    <div class="text-secondary small">Inventario / Salida de productos</div>
                    <h1 class="page-title">Salida de productos</h1>
                </div>
            </header>
            <div class="page-body">
                <div class="container-xl">
                    <div class="card welcome-card">
                        <div class="card-header">
                            <h2 class="card-title">Productos activos</h2>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-vcenter mb-0">
                                <thead>
                                    <tr>
                                        <th scope="col">Nombre</th>
                                        <th scope="col">Cantidad disponible</th>
                                        <th scope="col">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${productos}" var="producto">
                                        <tr>
                                            <td><c:out value="${producto.nombre}" /></td>
                                            <td>${producto.cantidad}</td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#salida-modal"
                                                        data-url="${pageContext.request.contextPath}/salida/${producto.idProducto}"
                                                        data-producto-nombre="${fn:escapeXml(producto.nombre)}" data-existencias="${producto.cantidad}"
                                                        ${producto.cantidad == 0 ? 'disabled' : ''}>Registrar salida</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty productos}">
                                        <tr>
                                            <td colspan="3" class="text-center text-secondary">No hay productos activos.</td>
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
    <jsp:include page="fragments/modal-cantidad.jsp">
        <jsp:param name="operacion" value="salida" />
    </jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/js/tabler.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/inventario.js"></script>
</body>
</html>
