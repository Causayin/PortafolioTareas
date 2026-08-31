<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<%@ page import="com.portafolio.modelos.Semana" %>
<%@ page import="com.portafolio.modelos.Tarea" %>
<%@ page import="java.util.List" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    List<Semana> semanas = (List<Semana>) request.getAttribute("semanas");
    Integer totalSemanas = (Integer) request.getAttribute("totalSemanas");
    Integer totalTareas = (Integer) request.getAttribute("totalTareas");
    Integer totalProyectos = (Integer) request.getAttribute("totalProyectos");
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard Admin - Portafolio</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link href="<%= ctx%>/css/estilos.css" rel="stylesheet">
</head>
<body>
    <!-- Navbar Admin -->
    <nav class="admin-navbar">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center">
                <a class="navbar-brand" href="<%= ctx%>/AdminServlet">Panel de Administración</a>
                <div>
                    <a class="nav-link d-inline" href="<%= ctx%>/index.jsp">🏠 Ver Sitio</a>
                    <a class="nav-link d-inline" href="<%= ctx%>/LogoutServlet"> Cerrar Sesión</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 admin-sidebar">
                <h5 style="color: #FFD700; margin-bottom: 20px;">Menú Admin</h5>
                <nav class="nav flex-column">
                    <a class="nav-link active" href="<%= ctx%>/AdminServlet">📊 Dashboard</a>
                    <a class="nav-link" href="<%= ctx%>/admin/gestionar-tareas.jsp"> Gestionar Tareas</a>
                    <a class="nav-link" href="<%= ctx%>/admin/usuarios.jsp">👥 Usuarios Registrados</a>
                    <a class="nav-link" href="<%= ctx%>/tareas.jsp">📚 Ver Sitio Público</a>
                    <a class="nav-link" href="<%= ctx%>/perfil.jsp">👤 Mi Perfil</a>
                </nav>
            </div>

            <!-- Contenido Principal -->
            <div class="col-md-10 p-4">
                <div class="admin-header rounded">
                    <div class="container">
                        <h1>Bienvenido, <%= usuario.getNombre()%></h1>
                        <p style="color: #000000; margin: 0;">Panel de control de tu portafolio</p>
                    </div>
                </div>

                <!-- Estadísticas -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="stat-card">
                            <h3><%= totalSemanas != null ? totalSemanas : 0%></h3>
                            <p>Semanas Creadas</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <h3><%= totalTareas != null ? totalTareas : 0%></h3>
                            <p>Tareas Subidas</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <h3><%= totalProyectos != null ? totalProyectos : 0%></h3>
                            <p>Proyectos Finales</p>
                        </div>
                    </div>
                </div>

                <!-- Acciones Rápidas -->
                <h3 style="color: #FFD700; margin-bottom: 20px;">Acciones Rápidas</h3>
                <div class="row">
                    <div class="col-md-4">
                        <div class="action-card">
                            <h4>📤 Gestionar y Subir Tareas</h4>
                            <p>Sube nuevas evidencias o administra las existentes por semana</p>
                            <a href="<%= ctx%>/admin/gestionar-tareas.jsp" class="btn-admin">Ir a Gestión</a>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="action-card">
                            <h4>📋 Ver Portafolio Público</h4>
                            <p>Visualiza cómo se ve tu portafolio para los visitantes</p>
                            <a href="<%= ctx%>/tareas.jsp" class="btn-admin">Ver Semanas</a>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="action-card">
                            <h4>👁️ Ir al Inicio</h4>
                            <p>Vuelve a la página principal del sitio web</p>
                            <a href="<%= ctx%>/index.jsp" class="btn-admin">Ir al Inicio</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>