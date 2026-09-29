<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.dao.TareaDAO" %>
<%@ page import="com.portafolio.modelos.Tarea" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    String idParam = request.getParameter("id");
    int semanaId = 0;
    List<Tarea> tareas = new ArrayList<>();

    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            semanaId = Integer.parseInt(idParam);
            TareaDAO tareaDAO = new TareaDAO();
            tareas = tareaDAO.getTareasBySemanaId(semanaId);
        } catch (NumberFormatException e) {
            // ID inválido
        }
    }

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Detalle de Semana - Ludwin Pedro Rojas Rios</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link href="<%= ctx %>/css/estilos.css" rel="stylesheet">
        <!-- NUEVO CSS ESPECÍFICO PARA ESTA VISTA -->
        <link href="<%= ctx %>/css/tareas-estilos.css" rel="stylesheet">
    </head>
    <body>
        <%@ include file="includes/navbar.jsp" %>

        <div class="page-header">
            <div class="container">
                <h1>Tareas de la Semana <%= semanaId %></h1>
            </div>
        </div>

        <div class="container pb-5">
            <% if (tareas == null || tareas.isEmpty()) { %>
                <div class="empty-state text-center py-5">
                    <h3>📂 Carpeta Vacía</h3>
                    <p>Aún no se han subido tareas o evidencias para esta semana.</p>
                    <p class="text-muted">El administrador las subirá pronto.</p>
                </div>
            <% } else { %>

                <!-- LAYOUT DIVIDIDO: IZQUIERDA (Tareas) | DERECHA (Animación) -->
                <div class="row split-layout">
                    
                    <!-- COLUMNA IZQUIERDA: Grid de Tareas -->
                    <div class="col-lg-7">
                        <div class="tasks-grid">
                            <% for (Tarea t : tareas) {
                                    String archivoRuta = t.getArchivoRuta();
                                    String archivoNombre = t.getArchivoNombre();

                                    String ext = "";
                                    if (archivoNombre != null && archivoNombre.contains(".")) {
                                        ext = archivoNombre.substring(archivoNombre.lastIndexOf(".")).toLowerCase();
                                    }

                                    boolean esImagen = ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".gif") || ext.equals(".webp");
                                    boolean esPDF = ext.equals(".pdf");
                            %>
                                <!-- TARJETA DE TAREA -->
                                <div class="modern-task-card">
                                    <div class="card-icon">
                                        <% if(esPDF) { %> 📄 <% } else if(esImagen) { %> 🖼️ <% } else { %> 📦 <% } %>
                                    </div>
                                    <h4 class="task-title"><%= t.getTitulo() %></h4>
                                    <p class="task-desc"><%= t.getDescripcion() %></p>

                                    <!-- Botones de acción (LÓGICA INTACTA) -->
                                    <div class="d-flex gap-2 flex-wrap mt-auto">
                                        <% if (esImagen) { %>
                                            <a href="<%= archivoRuta %>" target="_blank" class="btn-action btn-view">Ver</a>
                                            <a href="<%= archivoRuta %>" class="btn-action btn-download" download="<%= archivoNombre %>">Descargar</a>
                                        <% } else if (esPDF) { %>
                                            <a href="<%= archivoRuta %>" target="_blank" class="btn-action btn-view">Ver</a>
                                            <a href="<%= ctx %>/VerTareaServlet?id=<%= t.getId() %>" class="btn-action btn-download" download="<%= archivoNombre %>">Descargar PDF</a>
                                        <% } else { %>
                                            <a href="<%= archivoRuta %>" class="btn-action btn-download" download="<%= archivoNombre %>">Descargar Archivo</a>
                                        <% } %>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- COLUMNA DERECHA: Animación 3D CSS -->
                    <div class="col-lg-5 d-none d-lg-flex justify-content-center align-items-center">
                        <div class="animation-3d-wrapper">
                            <div class="floating-folder">
                                <div class="folder-tab"></div>
                                <div class="folder-body">
                                    <div class="folder-lines">
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                    </div>
                                </div>
                            </div>
                            <div class="glow-effect"></div>
                            <p class="animation-text">Evidencias Digitales</p>
                        </div>
                    </div>

                </div>
            <% } %>

            <div class="text-center mt-5">
                <a href="<%= ctx %>/tareas.jsp" class="btn btn-outline-light px-4 py-2 rounded-pill">← Volver a Semanas</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>