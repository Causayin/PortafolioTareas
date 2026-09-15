package com.portafolio.controladores;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.portafolio.dao.ConexionDB;
import com.portafolio.modelos.Usuario;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/SubirTareaServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                 maxFileSize = 1024 * 1024 * 10,
                 maxRequestSize = 1024 * 1024 * 50)
public class SubirTareaServlet extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        super.init();
        String cloudinaryUrl = System.getenv("CLOUDINARY_URL");
        cloudinary = new Cloudinary(cloudinaryUrl);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null || !"admin".equals(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        int semanaId = Integer.parseInt(request.getParameter("semanaId"));
        int categoriaId = Integer.parseInt(request.getParameter("categoriaId"));

        Part filePart = request.getPart("archivo");
        String fileName = filePart.getSubmittedFileName();

        try {
            // === CORRECCIÓN AQUÍ ===
            // Subir a Cloudinary con opciones explícitas
            Map uploadOptions = ObjectUtils.asMap(
                "resource_type", "auto",
                "public_id", fileName.replaceAll("\\.[^.]+$", "") // Quitar extensión del nombre
            );
            
            Map uploadResult = cloudinary.uploader().upload(
                filePart.getInputStream(),
                uploadOptions
            );
            // ========================

            String archivoUrl = (String) uploadResult.get("secure_url");
            System.out.println("=== CLOUDINARY UPLOAD SUCCESS: " + archivoUrl);

            // Guardar en BD
            String sql = "INSERT INTO tareas (titulo, descripcion, archivo_nombre, archivo_ruta, semana_id, categoria_id, usuario_id) VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (Connection conn = ConexionDB.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, titulo);
                ps.setString(2, descripcion);
                ps.setString(3, fileName);
                ps.setString(4, archivoUrl);
                ps.setInt(5, semanaId);
                ps.setInt(6, categoriaId);
                ps.setInt(7, usuario.getId());

                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?mensaje=exito");

        } catch (Exception e) {
            System.out.println("=== ERROR AL SUBIR A CLOUDINARY: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?error=fallo");
        }
    }
}