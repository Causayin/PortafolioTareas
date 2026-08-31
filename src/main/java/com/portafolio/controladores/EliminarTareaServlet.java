package com.portafolio.controladores;

import com.portafolio.dao.ConexionDB;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EliminarTareaServlet")
public class EliminarTareaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String archivoNombre = request.getParameter("archivo");

        // 1. Borrar de la Base de Datos
        String sql = "DELETE FROM tareas WHERE id = ?";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

            // 2. Borrar el archivo físico de la carpeta uploads
            String rutaArchivo = getServletContext().getRealPath("") + "uploads/" + archivoNombre;
            File archivo = new File(rutaArchivo);
            if (archivo.exists()) {
                archivo.delete();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirigir de vuelta al dashboard
        response.sendRedirect("admin/dashboard.jsp");
    }
}
