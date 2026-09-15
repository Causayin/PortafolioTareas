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
                             <%= usuario.getNombre().split(" ")[0] %>
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

<!-- MODAL DE LOGIN -->
<div class="modal fade modal-auth" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-center modal-lg">
        <div class="modal-content">
            <div class="modal-split">
                <!-- Lado izquierdo - Imagen/Decoración -->
                <div class="modal-image">
                    <div class="modal-image-content">
                        <div class="auth-icon">📚</div>
                        <h2>¡Bienvenido!</h2>
                        <p>Accede a tu portafolio de tareas<br>y mantente organizado</p>
                    </div>
                </div>
                
                <!-- Lado derecho - Formulario -->
                <div class="modal-form">
                    <div class="modal-header" style="border: none; padding-bottom: 0;">
                        <h5 class="modal-title" id="loginModalLabel">Iniciar Sesión</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" style="padding-top: 1rem;">
                        <% if ("error".equals(request.getParameter("msg"))) { %>
                            <div class="alert alert-danger">❌ Credenciales incorrectas.</div>
                        <% } %>
                        <form action="<%= request.getContextPath() %>/LoginServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" placeholder="tu@email.com" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Contraseña</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                            </div>
                            <button type="submit" class="btn btn-warning w-100">Ingresar</button>
                        </form>
                        <p class="text-center mt-3">
                            ¿No tienes cuenta? 
                            <button type="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#registroModal" data-bs-dismiss="modal">
                                Regístrate aquí
                            </button>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL DE REGISTRO -->
<div class="modal fade modal-auth" id="registroModal" tabindex="-1" aria-labelledby="registroModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-center modal-lg">
        <div class="modal-content">
            <div class="modal-split">
                <!-- Lado izquierdo - Imagen/Decoración -->
                <div class="modal-image">
                    <div class="modal-image-content">
                        <div class="auth-icon">🚀</div>
                        <h2>Únete Ahora</h2>
                        <p>Crea tu cuenta y comienza<br>a organizar tus tareas</p>
                    </div>
                </div>
                
                <!-- Lado derecho - Formulario -->
                <div class="modal-form">
                    <div class="modal-header" style="border: none; padding-bottom: 0;">
                        <h5 class="modal-title" id="registroModalLabel">Crear Cuenta</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" style="padding-top: 1rem;">
                        <% if ("exito".equals(request.getParameter("msg"))) { %>
                            <div class="alert alert-success">✅ ¡Registro exitoso! Inicia sesión.</div>
                        <% } %>
                        <form action="<%= request.getContextPath() %>/RegistroServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label">Nombre completo</label>
                                <input type="text" name="nombre" class="form-control" placeholder="Juan Pérez" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" placeholder="tu@email.com" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Contraseña</label>
                                <input type="password" name="password" class="form-control" placeholder="Mínimo 6 caracteres" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Confirmar contraseña</label>
                                <input type="password" name="confirmPassword" class="form-control" placeholder="Repite tu contraseña" required>
                            </div>
                            <button type="submit" class="btn btn-warning w-100">Registrarse</button>
                        </form>
                        <p class="text-center mt-3">
                            ¿Ya tienes cuenta? 
                            <button type="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#loginModal" data-bs-dismiss="modal">
                                Inicia sesión aquí
                            </button>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>