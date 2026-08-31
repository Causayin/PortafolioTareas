<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<%@ page import="com.portafolio.dao.ConexionDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("UTF-8");
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    String ctx = request.getContextPath();
    String nombre = "", email = "", carrera = "", institucion = "", descripcion = "", habilidades = "";
    
    try (Connection conn = ConexionDB.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM info_perfil WHERE id = 1");
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            nombre = rs.getString("nombre");
            email = rs.getString("email");
            carrera = rs.getString("carrera");
            institucion = rs.getString("institucion");
            descripcion = rs.getString("descripcion");
            habilidades = rs.getString("habilidades");
        }
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Perfil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= ctx %>/css/estilos.css" rel="stylesheet">
</head>
<body>
    <nav class="admin-navbar">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center">
                <a class="navbar-brand" href="<%= ctx %>/AdminServlet">Volver al Dashboard</a>
                <div>
                    <a class="nav-link d-inline" href="<%= ctx %>/index.jsp">🏠 Ver Sitio</a>
                    <a class="nav-link d-inline" href="<%= ctx %>/LogoutServlet">🚪 Cerrar Sesión</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="card-custom" style="max-width: 800px; margin: auto;">
            <h2 class="text-warning mb-4">✏️ Editar Información del Perfil</h2>
            
            <% if ("ok".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success">✅ Perfil actualizado correctamente.</div>
            <% } %>
            <% if ("error".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-danger"> Error al actualizar.</div>
            <% } %>

            <form action="<%= ctx %>/PerfilServlet" method="POST" accept-charset="UTF-8">
                <div class="mb-3">
                    <label class="form-label text-warning">Nombre Completo</label>
                    <input type="text" name="nombre" class="form-control bg-dark text-white border-warning" value="<%= nombre %>" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-warning">Email</label>
                    <input type="email" name="email" class="form-control bg-dark text-white border-warning" value="<%= email %>" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-warning">Carrera</label>
                    <input type="text" name="carrera" class="form-control bg-dark text-white border-warning" value="<%= carrera %>" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-warning">Institución</label>
                    <input type="text" name="institucion" class="form-control bg-dark text-white border-warning" value="<%= institucion %>" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-warning">Descripción</label>
                    <textarea name="descripcion" class="form-control bg-dark text-white border-warning" rows="3" required><%= descripcion %></textarea>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-warning">Habilidades (separar con |)</label>
                    <textarea name="habilidades" class="form-control bg-dark text-white border-warning" rows="3" required><%= habilidades %></textarea>
                    <small class="text-muted">Formato: "Categoría: habilidad1, habilidad2 | Categoría2: habilidad3"</small>
                </div>
                
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-warning fw-bold">💾 Guardar Cambios</button>
                    <a href="<%= ctx %>/perfil.jsp" class="btn btn-outline-warning">👁️ Vista Previa</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>