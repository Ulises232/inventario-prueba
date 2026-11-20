<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio | Inventario</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/css/tabler.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
</head>
<body>
    <div class="page app-shell">
        <jsp:include page="fragments/sidebar.jsp" />
        <main class="page-wrapper app-main">
            <header class="app-header">
                <div class="container-xl">
                    <div class="text-secondary small">Bienvenido </div>
                    <h1 class="page-title">Bienvenido </h1>
                </div>
            </header>
            <div class="page-body">
                <div class="container-xl">
                    <div class="card welcome-card">
                        <div class="card-body">
                            <h2 class="h3 mb-2">Bienvenido</h2>
                            <p class="text-secondary mb-0">Sistema de inventario.</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/@tabler/core@1.7.5/dist/js/tabler.min.js"></script>
</body>
</html>
