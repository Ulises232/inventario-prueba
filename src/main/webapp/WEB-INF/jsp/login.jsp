<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Iniciar sesión | Inventario</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/css/tabler.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
</head>
<body class="d-flex flex-column bg-surface-secondary auth-page">
    <main class="page page-center">
        <div class="container container-tight py-4">
            <div class="text-center mb-4">
                <div class="brand-icon mx-auto mb-3" aria-hidden="true">
                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="m3 7 9-4 9 4-9 4-9-4Z"/><path d="M3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></svg>
                </div>
                <div class="h1 fw-semibold mb-1">Inventario</div>
                <div class="text-secondary">Ingresa con tu cuenta</div>
            </div>

            <div class="card card-md auth-card">
                <div class="card-body">
                    <h2 class="h3 text-center mb-4">Iniciar sesión</h2>
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger" role="alert">Usuario o contraseña incorrectos.</div>
                    </c:if>
                    <c:if test="${not empty param.logout}">
                        <div class="alert alert-success" role="status">Tu sesión se cerró correctamente.</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <div class="mb-3">
                            <label for="username" class="form-label">Correo</label>
                            <input id="username" name="username" type="email" class="form-control" placeholder="Escribe tu correo" autocomplete="username" required autofocus>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label">Contraseña</label>
                            <input id="password" name="password" type="password" class="form-control" placeholder="Escribe tu contraseña" autocomplete="current-password" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Entrar</button>
                    </form>
                </div>
            </div>
            <p class="text-center text-secondary small mt-4">Sistema de inventario</p>
        </div>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/js/tabler.min.js"></script>
</body>
</html>
