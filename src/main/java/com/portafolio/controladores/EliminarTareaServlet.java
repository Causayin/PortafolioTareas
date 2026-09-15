package com.portafolio.controladores;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.portafolio.dao.ConexionDB;
import com.portafolio.dao.TareaDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
        
        String cloudName = System.getenv("CLOUDINARY_CLOUD_NAME");
        String apiKey = System.getenv("CLOUDINARY_API_KEY");
        String apiSecret = System.getenv("CLOUDINARY_API_SECRET");
        
        cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", cloudName,
            "api_key", apiKey,
            "api_secret", apiSecret
        ));
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
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                
                // Obtener URL antes de borrar
                String archivoUrl = null;
                try (Connection conn = ConexionDB.getConnection();
                     PreparedStatement ps = conn.prepareStatement("SELECT archivo_ruta FROM tareas WHERE id = ?")) {
                    ps.setInt(1, id);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        archivoUrl = rs.getString("archivo_ruta");
                    }
                }
                
                // Eliminar de Cloudinary si es URL de Cloudinary
                if (archivoUrl != null && archivoUrl.contains("cloudinary")) {
                    try {
                        String publicId = extraerPublicId(archivoUrl);
                        if (publicId != null) {
                            cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
                            System.out.println("✅ Eliminado de Cloudinary: " + publicId);
                        }
                    } catch (Exception e) {
                        System.out.println("️ Error al eliminar de Cloudinary: " + e.getMessage());
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
                
            } catch (Exception e) {
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