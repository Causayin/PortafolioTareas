<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<!DOCTYPE html>
<html>
<head>
    <title>Portafolio - Ludwin Pedro Rojas Rios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="css/estilos.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="hero-section">
        <div class="container">
            <h1>Ludwin Pedro Rojas Rios</h1>
            <p>Portafolio de Actividades y Evidencias</p>
        </div>
    </div>

    <div class="container">
        <div class="card-custom">
            <h2>Sobre Mí</h2>
            <p>
                Estudiante apasionado por el desarrollo web y la creación de soluciones tecnológicas dinámicas. 
                Este portafolio contiene todas mis tareas universitarias organizadas por semanas, 
                demostrando mi progreso y aprendizaje en cada etapa.
            </p>
        </div>

        <div class="card-custom">
            <h2>Habilidades y Herramientas</h2>
            <div class="info-item">
                <label>Desarrollo y Bases de Datos:</label>
                <span>Java, MySQL, JSP, Servlets.</span>
            </div>
            <div class="info-item">
                <label>Gestión y Plataformas:</label>
                <span>GitHub, NetBeans, Apache Tomcat.</span>
            </div>
            <div class="info-item">
                <label>Diseño Web:</label>
                <span>HTML5, CSS3, Bootstrap.</span>
            </div>
        </div>

        <div class="card-custom">
            <h2>Evidencias de la Semana 1</h2>
            <p>
                Aquí se encuentra la infografía resumen sobre los <strong>Fundamentos de un Proyecto Web</strong>.
            </p>
            <a href="tareas.jsp" class="btn-custom mt-3">Ver Tareas</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>