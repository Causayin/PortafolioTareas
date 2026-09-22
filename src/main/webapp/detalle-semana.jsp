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
    </head>
    <body>
        <%@ include file="includes/navbar.jsp" %>

        <div class="page-header">
            <div class="container">
                <h1>Tareas de la Semana <%= semanaId %></h1>
            </div>
        </div>

        <div class="container">
            <% if (tareas == null || tareas.isEmpty()) { %>
            <div class="empty-state text-center py-5">
                <h3>📂 Carpeta Vacía</h3>
                <p>Aún no se han subido tareas o evidencias para esta semana.</p>
                <p class="text-muted">El administrador las subirá pronto.</p>
            </div>
            <% } else { %>

            <% for (Tarea t : tareas) {
                    String archivoRuta = t.getArchivoRuta();
                    String archivoNombre = t.getArchivoNombre();

                    String ext = "";
                    if (archivoNombre != null && archivoNombre.contains(".")) {
                        ext = archivoNombre.substring(archivoNombre.lastIndexOf(".")).toLowerCase();
                    }

                    // Separamos la lógica: imágenes sí se pueden ver, PDFs solo descargar
                    boolean esImagen = ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".gif") || ext.equals(".webp");
                    boolean esPDF = ext.equals(".pdf");
            %>
            <div class="tarea-card mb-4 p-4" style="background-color: #1a1a1a; border: 1px solid #333; border-radius: 8px;">
                <h4 class="text-warning"><%= t.getTitulo() %></h4>
                <span class="text-muted d-block mb-2">📅 Subido el: <%= t.getFechaSubida() %></span>
                <p class="text-white"><%= t.getDescripcion() %></p>

                <!-- Botones de acción según el tipo de archivo -->
                <div class="d-flex gap-2 flex-wrap mt-3">
                    <% if (esImagen) { %>
                        <!-- Para IMÁGENES: Se puede ver y descargar -->
                        <a href="<%= archivoRuta %>" target="_blank" class="btn btn-sm btn-info">
                            Ver
                        </a>
                        <a href="<%= archivoRuta %>" class="btn btn-sm btn-outline-warning" download="<%= archivoNombre %>">
                            Descargar
                        </a>
                    <% } else if (esPDF) { %>
                        <!-- Para PDFs: Solo descargar (Cloudinary fuerza descarga en archivos raw) -->
                        <a href="<%= archivoRuta %>" class="btn btn-sm btn-outline-warning" download="<%= archivoNombre %>">
                            Descargar PDF
                        </a>
                    <% } else { %>
                        <!-- Para otros archivos (ZIP, etc.): Solo descargar -->
                        <a href="<%= archivoRuta %>" class="btn btn-sm btn-outline-warning" download="<%= archivoNombre %>">
                            Descargar Archivo
                        </a>
                    <% } %>
                </div>
            </div>

            <% } %>
            <% } %>

            <div class="text-center mt-5 mb-5">
                <a href="<%= ctx %>/tareas.jsp" class="btn btn-outline-light px-4 py-2">← Volver a Semanas</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>