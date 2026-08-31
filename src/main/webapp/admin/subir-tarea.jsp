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
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #0a0a0a;
            color: #ffffff;
        }
        
        .admin-navbar {
            background-color: #000000;
            border-bottom: 2px solid #FFD700;
            padding: 15px 0;
        }
        
        .admin-navbar .navbar-brand {
            color: #FFD700 !important;
            font-weight: 700;
            text-decoration: none;
        }
        
        .admin-navbar .nav-link {
            color: #cccccc !important;
            text-decoration: none;
            margin-left: 15px;
        }
        
        .admin-navbar .nav-link:hover {
            color: #FFD700 !important;
        }
        
        .form-container {
            max-width: 700px;
            margin: 50px auto;
            background-color: #1a1a1a;
            border: 2px solid #FFD700;
            border-radius: 15px;
            padding: 40px;
        }
        
        .form-container h2 {
            color: #FFD700;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .form-label {
            color: #FFD700;
            font-weight: 500;
        }
        
        .form-control,
        .form-select {
            background-color: #222222;
            border: 1px solid #FFD700;
            color: #ffffff;
        }
        
        .form-control:focus,
        .form-select:focus {
            background-color: #2a2a2a;
            border-color: #FFA500;
            color: #ffffff;
            box-shadow: 0 0 0 0.2rem rgba(255, 215, 0, 0.25);
        }
        
        .btn-submit {
            background-color: #FFD700;
            color: #000000;
            font-weight: 600;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            width: 100%;
            margin-top: 20px;
        }
        
        .btn-submit:hover {
            background-color: #FFA500;
            color: #000000;
        }
    </style>
</head>
<body>
    <!-- Navbar Admin -->
    <nav class="admin-navbar">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center">
                <a class="navbar-brand" href="<%= ctx %>/AdminServlet">📊 Panel de Administración</a>
                <div>
                    <a class="nav-link d-inline" href="<%= ctx %>/index.jsp">🏠 Ver Sitio</a>
                    <a class="nav-link d-inline" href="<%= ctx %>/LogoutServlet"> Cerrar Sesión</a>
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