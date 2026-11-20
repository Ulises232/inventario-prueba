<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<aside class="navbar navbar-vertical navbar-expand-lg app-sidebar" aria-label="Navegación principal">
    <div class="container-fluid d-flex flex-column align-items-stretch h-100">
        <div class="sidebar-top d-flex align-items-center justify-content-between">
            <a href="${pageContext.request.contextPath}/bienvenido" class="brand-link">
                <span>Inventario </span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menu-lateral"
                    aria-controls="menu-lateral" aria-expanded="false" aria-label="Mostrar menú">
                <span class="navbar-toggler-icon"></span>
            </button>
        </div>
        <div class="collapse navbar-collapse app-nav" id="menu-lateral">
            <div class="nav-label">NAVEGACIÓN</div>
            <ul class="navbar-nav">
                <sec:authorize access="isAuthenticated()">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/bienvenido" class="nav-link" data-ruta-alternativa="${pageContext.request.contextPath}/">
                            <span class="nav-link-title">Bienvenido </span>
                        </a>
                    </li>
                </sec:authorize>

                <sec:authorize access="hasAnyRole('ADMINISTRADOR', 'ALMACENISTA')">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/inventario" class="nav-link">
                            <span class="nav-link-title">Inventario</span>
                        </a>
                    </li>
                </sec:authorize>


                <sec:authorize access="hasRole('ALMACENISTA')">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/salida" class="nav-link">
                            <span class="nav-link-title">Salida de productos</span>
                        </a>
                    </li>
                </sec:authorize>

                <sec:authorize access="hasRole('ADMINISTRADOR')">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/historico" class="nav-link">
                            <span class="nav-link-title">Histórico</span>
                        </a>
                    </li>
                </sec:authorize>
            </ul>
            <div class="sidebar-bottom mt-auto">
                <div class="small text-secondary mb-2">Sesión: <strong>
                    <c:out value="${pageContext.request.userPrincipal.name}"/>
                </strong></div>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <button class="btn btn-outline-secondary w-100" type="submit">Cerrar sesión</button>
                </form>
            </div>
        </div>
    </div>
</aside>
<script src="https://code.jquery.com/jquery-4.1.0.min.js"></script>
<script src="${pageContext.request.contextPath}/js/general.js"></script>
