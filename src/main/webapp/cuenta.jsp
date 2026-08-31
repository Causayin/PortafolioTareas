<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Mi Cuenta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= ctx %>/css/estilos.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    <div class="container mt-5">
        <div class="card-custom" style="max-width: 600px; margin: auto;">
            <h2>Mi Cuenta</h2>
            <% if ("ok".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success">Datos actualizados correctamente.</div>
            <% } %>
            <form action="<%= ctx %>/CuentaServlet" method="POST">
                <div class="mb-3">
                    <label class="form-label">Nombre Completo</label>
                    <input type="text" name="nombre" class="form-control" value="<%= usuario.getNombre() %>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" value="<%= usuario.getEmail() %>" required>
                </div>
                <button type="submit" class="btn-custom">Guardar Cambios</button>
            </form>
        </div>
    </div>
</body>
</html>