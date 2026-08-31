<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<%@ page import="com.portafolio.dao.UsuarioDAO" %>
<%@ page import="java.util.List" %>

<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null || !"admin".equals(user.getRol())) { 
        response.sendRedirect(request.getContextPath() + "/index.jsp"); 
        return; 
    }
    
    UsuarioDAO dao = new UsuarioDAO();
    List<Usuario> usuarios = dao.getAllUsuarios();
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Usuarios Registrados</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="<%= ctx %>/css/estilos.css" rel="stylesheet">
</head>
<body>
    <!-- Navbar Admin -->
    <nav class="admin-navbar">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center">
                <a class="navbar-brand" href="<%= ctx %>/AdminServlet">Volver al Dashboard</a>
                <div>
                    <a class="nav-link d-inline" href="<%= ctx %>/index.jsp">🏠 Ver Sitio</a>
                    <a class="nav-link d-inline" href="<%= ctx %>/LogoutServlet"> Cerrar Sesión</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2 class="text-warning mb-4">Usuarios Registrados</h2>
        
        <div class="table-responsive">
            <table class="table table-dark table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Email</th>
                        <th>Rol</th>
                        <th>Fecha Registro</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Usuario u : usuarios) { %>
                    <tr>
                        <td><%= u.getId() %></td>
                        <td><%= u.getNombre() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><span class="badge bg-warning text-dark"><%= u.getRol() %></span></td>
                        <td><%= u.getFechaRegistro() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>