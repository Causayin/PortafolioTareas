<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<%@ page import="com.portafolio.dao.ConexionDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    
    // Valores por defecto
    String nombre = "Ludwin Pedro Rojas Rios";
    String email = "ludwin.rojas@email.com";
    String carrera = "Desarrollo de Software / Sistemas";
    String institucion = "Instituto de Educación Superior Tecnológico";
    String descripcion = "Estudiante apasionado por el desarrollo web.";
    String habilidades = "";
    
    // Leer directamente de la base de datos
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
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    String[] habilidadesArray = habilidades.split("\\|");
    Usuario usuarioAdmin = (Usuario) session.getAttribute("usuario");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sobre Mí - <%= nombre %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="<%= ctx %>/css/estilos.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="page-header">
        <div class="container">
            <h1><%= nombre %></h1>
            <p><%= carrera %></p>
        </div>
    </div>
    
    <div class="container">
        <% if ("ok".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">✅ Información actualizada correctamente.</div>
        <% } %>
        
        <div class="profile-card">
            <h2>Información Personal</h2>
            
            <div class="info-item">
                <label>👤 Nombre Completo</label>
                <span><%= nombre %></span>
            </div>
            
            <div class="info-item">
                <label>📧 Email de Contacto</label>
                <span><%= email %></span>
            </div>
            
            <div class="info-item">
                <label>🎓 Carrera</label>
                <span><%= carrera %></span>
            </div>
            
            <div class="info-item">
                <label>🏫 Institución</label>
                <span><%= institucion %></span>
            </div>
            
            <div class="info-item">
                <label>📝 Descripción</label>
                <span><%= descripcion %></span>
            </div>
        </div>
        
        <div class="card-custom">
            <h2>Habilidades y Herramientas</h2>
            <% for (String habilidad : habilidadesArray) { 
                if (habilidad.trim().isEmpty()) continue;
                String[] partes = habilidad.trim().split(":");
                if (partes.length == 2) {
            %>
                <div class="info-item">
                    <label><%= partes[0].trim() %>:</label>
                    <span><%= partes[1].trim() %></span>
                </div>
            <% 
                } else { %>
                    <div class="info-item">
                        <span><%= habilidad.trim() %></span>
                    </div>
            <% 
                }
            } %>
        </div>
        
        <% if (usuarioAdmin != null && "admin".equals(usuarioAdmin.getRol())) { %>
            <div class="text-center mt-4 mb-5">
                <a href="<%= ctx %>/admin/editar-perfil.jsp" class="btn-admin">
                    ✏️ Editar esta información
                </a>
            </div>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>