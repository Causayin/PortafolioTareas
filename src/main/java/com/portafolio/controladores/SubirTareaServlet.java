package com.portafolio.controladores;

import com.portafolio.dao.ConexionDB;
import com.portafolio.modelos.Usuario;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
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
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        
        String uploadPath = getServletContext().getRealPath("") + "uploads";
        Path uploadDir = Paths.get(uploadPath);
        if (!Files.exists(uploadDir)) {
            Files.createDirectories(uploadDir);
        }
        
        Path filePath = uploadDir.resolve(fileName);
        Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        String sql = "INSERT INTO tareas (titulo, descripcion, archivo_nombre, archivo_ruta, semana_id, categoria_id, usuario_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, titulo);
            ps.setString(2, descripcion);
            ps.setString(3, fileName);
            ps.setString(4, "uploads/" + fileName);
            ps.setInt(5, semanaId);
            ps.setInt(6, categoriaId);
            ps.setInt(7, usuario.getId());
            
            ps.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?mensaje=exito");
            return; 
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?error=fallo");
            return;
        }
        
    }
}