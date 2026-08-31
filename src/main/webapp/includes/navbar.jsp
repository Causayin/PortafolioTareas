<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
%>
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp">Portafolio Tareas</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/index.jsp">Inicio</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/tareas.jsp">Tareas</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/perfil.jsp">Sobre Mí</a></li>
            </ul>
            <ul class="navbar-nav">
                <% if (usuario != null) { %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            👤 <%= usuario.getNombre().split(" ")[0] %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" style="background-color: #1a1a1a; border: 1px solid #FFD700;">
                            <% if ("admin".equals(usuario.getRol())) { %>
                                <li><a class="dropdown-item text-warning" href="<%= request.getContextPath() %>/AdminServlet">Panel Admin</a></li>
                                <li><hr class="dropdown-divider bg-secondary"></li>
                            <% } %>
                            <li><a class="dropdown-item text-white" href="<%= request.getContextPath() %>/cuenta.jsp">Mi Cuenta</a></li>
                            <li><a class="dropdown-item text-white" href="<%= request.getContextPath() %>/LogoutServlet">Cerrar Sesión</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <button type="button" class="nav-link" data-bs-toggle="modal" data-bs-target="#loginModal" style="cursor: pointer;">
                            Ingresar
                        </button>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
<div class="modal fade" id="loginModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="background-color: #1a1a1a; border: 2px solid #FFD700;">
            <div class="modal-header" style="border-bottom: 2px solid #FFD700;">
                <h5 class="modal-title text-warning">Iniciar Sesión</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <% if ("error".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-danger">Credenciales incorrectas.</div>
                <% } %>
                <form action="<%= request.getContextPath() %>/LoginServlet" method="POST">
                    <div class="mb-3">
                        <label class="form-label text-warning">Email</label>
                        <input type="email" name="email" class="form-control bg-dark text-white border-warning" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-warning">Contraseña</label>
                        <input type="password" name="password" class="form-control bg-dark text-white border-warning" required>
                    </div>
                    <button type="submit" class="btn btn-warning w-100 fw-bold">Ingresar</button>
                </form>
                <p class="text-center mt-3 text-white">
                    ¿No tienes cuenta? 
                    <button type="button" class="btn btn-link text-warning p-0" data-bs-toggle="modal" data-bs-target="#registroModal" data-bs-dismiss="modal">
                        Regístrate aquí
                    </button>
                </p>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="registroModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="background-color: #1a1a1a; border: 2px solid #FFD700;">
            <div class="modal-header" style="border-bottom: 2px solid #FFD700;">
                <h5 class="modal-title text-warning">Crear Cuenta</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <% if ("exito".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success">¡Registro exitoso! Inicia sesión.</div>
                <% } %>
                <form action="<%= request.getContextPath() %>/RegistroServlet" method="POST">
                    <div class="mb-3">
                        <label class="form-label text-warning">Nombre completo</label>
                        <input type="text" name="nombre" class="form-control bg-dark text-white border-warning" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-warning">Email</label>
                        <input type="email" name="email" class="form-control bg-dark text-white border-warning" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-warning">Contraseña</label>
                        <input type="password" name="password" class="form-control bg-dark text-white border-warning" required>
                    </div>
                    <button type="submit" class="btn btn-warning w-100 fw-bold">Registrarse</button>
                </form>
                <p class="text-center mt-3 text-white">
                    ¿Ya tienes cuenta? 
                    <button type="button" class="btn btn-link text-warning p-0" data-bs-toggle="modal" data-bs-target="#loginModal" data-bs-dismiss="modal">
                        Inicia sesión aquí
                    </button>
                </p>
            </div>
        </div>
    </div>
</div>