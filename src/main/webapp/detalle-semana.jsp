<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.dao.TareaDAO" %>
<%@ page import="com.portafolio.modelos.Tarea" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    String idParam = request.getParameter("id");
    int semanaId = 0;
    List<Tarea> tareas = new ArrayList<>();
    
    // Obtener las tareas de forma segura
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            semanaId = Integer.parseInt(idParam);
            TareaDAO tareaDAO = new TareaDAO();
            tareas = tareaDAO.getTareasBySemanaId(semanaId);
        } catch (NumberFormatException e) {
            // Si el ID no es válido, se mantiene en 0 y no mostrará tareas
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
                // Lógica para saber si se puede ver en vista previa
                String archivoRuta = t.getArchivoRuta();
                String ext = "";
                if (archivoRuta != null && archivoRuta.contains(".")) {
                    ext = archivoRuta.substring(archivoRuta.lastIndexOf(".")).toLowerCase();
                }
                boolean esVistaPrevia = ext.equals(".pdf") || ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png");
            %>
                <div class="tarea-card mb-4 p-4" style="background-color: #1a1a1a; border: 1px solid #333; border-radius: 8px;">
                    <h4 class="text-warning"><%= t.getTitulo() %></h4>
                    <span class="text-muted d-block mb-2">📅 Subido el: <%= t.getFechaSubida() %></span>
                    <p class="text-white"><%= t.getDescripcion() %></p>
                    
                    <!-- Botones de acción -->
                    <div class="d-flex gap-2 flex-wrap mt-3">
                        <% if (esVistaPrevia) { %>
                            <button type="button" class="btn btn-sm btn-info" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#modalVistaPrevia<%= t.getId() %>">
                                👁️ Ver
                            </button>
                        <% } %>
                        
                        <a href="<%= archivoRuta %>" class="btn btn-sm btn-outline-warning" download>
                            ⬇️ Descargar: <%= t.getArchivoNombre() %>
                        </a>
                    </div>
                </div>

                <!-- MODAL DE VISTA PREVIA (CORREGIDO CON IFRAME) -->
                <% if (esVistaPrevia) { %>
                <div class="modal fade" id="modalVistaPrevia<%= t.getId() %>" tabindex="-1">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content bg-dark">
                            <div class="modal-header border-warning">
                                <h5 class="modal-title text-warning"><%= t.getTitulo() %></h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body text-center p-0" style="overflow: hidden; border-radius: 0 0 8px 8px;">
                                <% if (ext.equals(".pdf")) { %>
                                    <!-- IFRAME es mucho más estable para PDFs de Cloudinary -->
                                    <iframe src="<%= archivoRuta %>#toolbar=0" width="100%" height="600px" style="border: none;"></iframe>
                                <% } else { %>
                                    <img src="<%= archivoRuta %>" class="img-fluid" alt="<%= t.getTitulo() %>" style="max-height: 600px; object-fit: contain;" />
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
                
            <% } %>
        <% } %>
        
        <div class="text-center mt-5 mb-5">
            <a href="<%= ctx %>/tareas.jsp" class="btn btn-outline-light px-4 py-2">← Volver a Semanas</a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>