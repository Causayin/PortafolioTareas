<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<%@ page import="com.portafolio.dao.SemanaDAO" %>
<%@ page import="com.portafolio.modelos.Semana" %>
<%@ page import="java.util.List" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    SemanaDAO semanaDAO = new SemanaDAO();
    List<Semana> semanas = semanaDAO.getAllSemanas();
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Subir Tarea - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="<%= ctx %>/css/estilos.css" rel="stylesheet">
</head>
<body>
    <!-- Navbar Admin -->
    <nav class="admin-navbar">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center">
                <a class="navbar-brand" href="<%= ctx %>/AdminServlet">📊 Panel de Administración</a>
                <div>
                    <a class="nav-link d-inline" href="<%= ctx %>/index.jsp">🏠 Ver Sitio</a>
                    <a class="nav-link d-inline" href="<%= ctx %>/LogoutServlet">Cerrar Sesión</a>
                </div>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <div class="form-container">
            <h2>📤 Subir Nueva Tarea</h2>
            
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("mensaje") %></div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="<%= ctx %>/SubirTareaServlet" method="POST" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">Título de la tarea</label>
                    <input type="text" name="titulo" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Descripción</label>
                    <textarea name="descripcion" class="form-control" rows="3"></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Seleccionar Semana</label>
                    <select name="semanaId" class="form-select" required>
                        <% for (Semana s : semanas) { %>
                            <option value="<%= s.getId() %>"><%= s.getNombre() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Categoría</label>
                    <select name="categoriaId" class="form-select">
                        <option value="1">Tarea</option>
                        <option value="2">Parcial</option>
                        <option value="3">Proyecto</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Archivo (PDF, ZIP, Imagen)</label>
                    <input type="file" name="archivo" class="form-control" required>
                </div>
                <button type="submit" class="btn-submit">Subir Tarea</button>
            </form>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>