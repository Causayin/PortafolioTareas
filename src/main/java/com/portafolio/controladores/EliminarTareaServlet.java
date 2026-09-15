package com.portafolio.controladores;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.portafolio.dao.ConexionDB;
import com.portafolio.dao.TareaDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/EliminarTareaServlet")
public class EliminarTareaServlet extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        super.init();
        String cloudinaryUrl = System.getenv("CLOUDINARY_URL");
        cloudinary = new Cloudinary(cloudinaryUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                
                // Obtener URL antes de borrar
                String archivoUrl = null;
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    conn = ConexionDB.getConnection();
                    ps = conn.prepareStatement("SELECT archivo_ruta FROM tareas WHERE id = ?");
                    ps.setInt(1, id);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        archivoUrl = rs.getString("archivo_ruta");
                    }
                } catch (SQLException e) {
                    System.out.println("Error al obtener URL: " + e.getMessage());
                    e.printStackTrace();
                } finally {
                    // Cerrar recursos manualmente
                    if (rs != null) { try { rs.close(); } catch (SQLException e) {} }
                    if (ps != null) { try { ps.close(); } catch (SQLException e) {} }
                    if (conn != null) { try { conn.close(); } catch (SQLException e) {} }
                }

                // Eliminar de Cloudinary si es URL de Cloudinary
                if (archivoUrl != null && archivoUrl.contains("cloudinary")) {
                    try {
                        String publicId = extraerPublicId(archivoUrl);
                        if (publicId != null) {
                            cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
                            System.out.println("=== ARCHIVO ELIMINADO DE CLOUDINARY: " + publicId);
                        }
                    } catch (Exception e) {
                        System.out.println("Error al eliminar de Cloudinary: " + e.getMessage());
                    }
                }

                // Eliminar de BD
                TareaDAO dao = new TareaDAO();
                boolean eliminado = dao.eliminarTarea(id);

                if (eliminado) {
                    response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?mensaje=eliminada");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?error=fallo");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?error=fallo");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp");
        }
    }

    private String extraerPublicId(String url) {
        try {
            String[] parts = url.split("/");
            int uploadIndex = -1;
            for (int i = 0; i < parts.length; i++) {
                if (parts[i].equals("upload")) {
                    uploadIndex = i;
                    break;
                }
            }
            if (uploadIndex != -1 && uploadIndex + 2 < parts.length) {
                StringBuilder sb = new StringBuilder();
                for (int i = uploadIndex + 2; i < parts.length; i++) {
                    if (i > uploadIndex + 2) sb.append("/");
                    sb.append(parts[i]);
                }
                String fullId = sb.toString();
                int dotIndex = fullId.lastIndexOf(".");
                if (dotIndex > 0) {
                    fullId = fullId.substring(0, dotIndex);
                }
                return fullId;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}