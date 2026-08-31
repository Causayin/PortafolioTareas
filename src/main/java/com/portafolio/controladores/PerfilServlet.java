package com.portafolio.controladores;

import com.portafolio.dao.ConexionDB;
import com.portafolio.modelos.Usuario;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/PerfilServlet")
public class PerfilServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Solo redirige al perfil.jsp (los datos se cargan ahí)
        request.getRequestDispatcher("perfil.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar UTF-8 para recibir datos correctamente
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null || !"admin".equals(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // Obtener datos del formulario
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String carrera = request.getParameter("carrera");
        String institucion = request.getParameter("institucion");
        String descripcion = request.getParameter("descripcion");
        String habilidades = request.getParameter("habilidades");
        
        System.out.println("=== ACTUALIZANDO PERFIL ===");
        System.out.println("Nombre: " + nombre);
        System.out.println("Email: " + email);
        System.out.println("Carrera: " + carrera);
        System.out.println("Institución: " + institucion);
        
        try (Connection conn = ConexionDB.getConnection()) {
            String sql = "UPDATE info_perfil SET nombre=?, email=?, carrera=?, institucion=?, descripcion=?, habilidades=? WHERE id=1";
            PreparedStatement ps = conn.prepareStatement(sql);
            
            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setString(3, carrera);
            ps.setString(4, institucion);
            ps.setString(5, descripcion);
            ps.setString(6, habilidades);
            
            int filas = ps.executeUpdate();
            System.out.println("Filas actualizadas: " + filas);
            
            if (filas > 0) {
                response.sendRedirect(request.getContextPath() + "/perfil.jsp?msg=ok");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/editar-perfil.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/editar-perfil.jsp?msg=error");
        }
    }
}