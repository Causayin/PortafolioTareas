<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.dao.SemanaDAO" %>
<%@ page import="com.portafolio.modelos.Semana" %>
<%@ page import="java.util.List" %>

<%
    SemanaDAO semanaDAO = new SemanaDAO();
    List<Semana> semanas = semanaDAO.getAllSemanas();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Tareas - Ludwin Pedro Rojas Rios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="css/estilos.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="page-header">
        <div class="container">
            <h1>Semanas y Tareas</h1>
        </div>
    </div>
    
    <div class="container">
        <div class="row">
            <% for (Semana s : semanas) { %>
                <div class="col-md-4 mb-4">
                    <div class="semana-card">
                        <h3><%= s.getNombre() %></h3>
                        <p><%= s.getDescripcion() %></p>
                        <a href="detalle-semana.jsp?id=<%= s.getId() %>" class="btn-ver-tareas">
                            Ver Tareas
                        </a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>