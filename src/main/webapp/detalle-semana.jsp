<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.dao.TareaDAO" %>
<%@ page import="com.portafolio.modelos.Tarea" %>
<%@ page import="java.util.List" %>

<%
    int semanaId = Integer.parseInt(request.getParameter("id"));
    TareaDAO tareaDAO = new TareaDAO();
    List<Tarea> tareas = tareaDAO.getTareasBySemanaId(semanaId);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Detalle de Semana - Ludwin Pedro Rojas Rios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="css/estilos.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="page-header">
        <div class="container">
            <h1>Tareas de la Semana <%= semanaId %></h1>
        </div>
    </div>
    
    <div class="container">
        <% if (tareas.isEmpty()) { %>
            <div class="empty-state">
                <h3>📂 Carpeta Vacía</h3>
                <p>Aún no se han subido tareas o evidencias para esta semana.</p>
                <p class="text-muted">El administrador las subirá pronto.</p>
            </div>
        <% } else { %>
            <% for (Tarea t : tareas) { %>
                <div class="tarea-card">
                    <h4><%= t.getTitulo() %></h4>
                    <span class="text-muted"> Subido el: <%= t.getFechaSubida() %></span>
                    <p><%= t.getDescripcion() %></p>
                    <a href="uploads/<%= t.getArchivoNombre() %>" class="btn-descargar" download>
                        ⬇ Descargar: <%= t.getArchivoNombre() %>
                    </a>
                </div>
            <% } %>
        <% } %>
        
        <div class="text-center mt-5 mb-5">
            <a href="tareas.jsp" class="btn-volver">← Volver a Semanas</a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>