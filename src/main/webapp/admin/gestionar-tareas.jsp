<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<%@ page import="com.portafolio.modelos.Semana" %>
<%@ page import="com.portafolio.modelos.Tarea" %>
<%@ page import="com.portafolio.dao.SemanaDAO" %>
<%@ page import="com.portafolio.dao.TareaDAO" %>
<%@ page import="java.util.List" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"admin".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    SemanaDAO semanaDAO = new SemanaDAO();
    TareaDAO tareaDAO = new TareaDAO();
    List<Semana> semanas = semanaDAO.getAllSemanas();
    List<Tarea> todasLasTareas = tareaDAO.getAllTareas();
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Gestionar Tareas - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link href="<%= ctx%>/css/estilos.css" rel="stylesheet">
    </head>
    <body>
        <!-- Navbar Admin Simplificado -->
        <nav class="admin-navbar">
            <div class="container-fluid d-flex justify-content-between align-items-center">
                <a class="navbar-brand" href="<%= ctx%>/AdminServlet">← Volver al Dashboard</a>
                <h4 class="text-white m-0">Gestión de Tareas</h4>
                <button class="btn btn-warning fw-bold" data-bs-toggle="modal" data-bs-target="#modalSubir">
                    + Añadir Tarea
                </button>
            </div>
        </nav>

        <div class="container mt-4">
            <!-- Mensajes de éxito/error -->
            <% if ("exito".equals(request.getParameter("mensaje"))) { %>
            <div class="alert alert-success alert-dismissible fade show">
                ✅ Tarea subida correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if ("fallo".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show">
                ❌ Error al subir la tarea.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if ("eliminada".equals(request.getParameter("mensaje"))) { %>
            <div class="alert alert-warning alert-dismissible fade show">
                🗑️ Tarea eliminada correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <!-- Lista de Tareas Separadas por Semana -->
            <% for (Semana s : semanas) {%>
            <div class="semana-separator">
                <h3><%= s.getNombre()%>: <%= s.getDescripcion()%></h3>
            </div>

            <div class="ps-3">
                <%
                    boolean hayTareas = false;
                    for (Tarea t : todasLasTareas) {
                        if (t.getSemanaId() == s.getId()) {
                            hayTareas = true;

                            // Determinar si el archivo permite vista previa
                            String archivoRuta = t.getArchivoRuta();
                            String ext = "";
                            if (archivoRuta != null && archivoRuta.contains(".")) {
                                ext = archivoRuta.substring(archivoRuta.lastIndexOf(".")).toLowerCase();
                            }
                            boolean esVistaPrevia = ext.equals(".pdf") || ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png");
                %>

                <!-- TARJETA DE LA TAREA -->
                <div class="tarea-item">
                    <div class="tarea-info">
                        <h5><%= t.getTitulo()%></h5>
                        <p><%= t.getDescripcion()%></p>
                        <small>📅 <%= t.getFechaSubida()%> | 📄 <%= t.getArchivoNombre()%></small>
                    </div>

                    <!-- BOTONES CORREGIDOS (SIN MODAL Y SIN ctx) -->
                    <div class="d-flex gap-2 flex-wrap">
                        <% if (esVistaPrevia) {%>
                        <a href="<%= archivoRuta %>" target="_blank" class="btn btn-sm btn-info">
                            👁️ Ver
                        </a>
                        <% }%>

                        <a href="<%= archivoRuta %>" class="btn btn-sm btn-outline-warning" download>
                            ⬇️ Descargar
                        </a>
                        <a href="<%= ctx%>/EliminarTareaServlet?id=<%= t.getId()%>" 
                           class="btn btn-sm btn-danger" 
                           onclick="return confirm('¿Estás seguro de que deseas eliminar esta tarea?');">
                            🗑️ Eliminar
                        </a>
                    </div>
                </div>

                <!-- (EL MODAL DE VISTA PREVIA SE ELIMINÓ POR COMPLETO) -->

                <%
                        }
                    }
                    if (!hayTareas) {
                %>
                <p class="text-muted fst-italic">No hay tareas subidas para esta semana aún.</p>
                <% } %>
            </div>
            <% }%>
        </div>

        <!-- MODAL PARA SUBIR TAREA (Limpio de estilos inline, usa tu CSS) -->
        <div class="modal fade" id="modalSubir" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Subir Nueva Tarea</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form action="<%= ctx%>/SubirTareaServlet" method="POST" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label class="form-label">Título</label>
                                <input type="text" name="titulo" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Descripción</label>
                                <textarea name="descripcion" class="form-control" rows="2"></textarea>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Semana</label>
                                    <select name="semanaId" class="form-select" required>
                                        <% for (Semana s : semanas) {%>
                                        <option value="<%= s.getId()%>"><%= s.getNombre()%></option>
                                        <% }%>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Categoría</label>
                                    <select name="categoriaId" class="form-select">
                                        <option value="1">Tarea</option>
                                        <option value="2">Parcial</option>
                                        <option value="3">Proyecto</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Archivo</label>
                                <input type="file" name="archivo" class="form-control" required>
                            </div>
                            <div class="text-end">
                                <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">Cancelar</button>
                                <button type="submit" class="btn btn-warning fw-bold">Subir Tarea</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>