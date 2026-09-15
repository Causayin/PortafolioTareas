package com.portafolio.controladores;

import com.portafolio.dao.UsuarioDAO;
import com.portafolio.modelos.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener datos del formulario
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // 2. Validaciones básicas
        if (nombre == null || email == null || password == null || 
            nombre.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=campos_vacios");
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=pass_no_coincide");
            return;
        }
        
        // 3. Crear objeto Usuario
        Usuario usuario = new Usuario();
        usuario.setNombre(nombre);
        usuario.setEmail(email);
        usuario.setPassword(password); // El DAO se encarga de encriptarlo con MD5 en la BD
        
        // 4. Guardar en la Base de Datos
        UsuarioDAO dao = new UsuarioDAO();
        
        try {
            boolean registrado = dao.registrarUsuario(usuario);
            
            if (registrado) {
                // Éxito: Redirigir al login con mensaje de éxito
                response.sendRedirect(request.getContextPath() + "/index.jsp?exito=registro_ok");
            } else {
                // Fallo: Probablemente el email ya existe (el DAO lo maneja)
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=email_existe");
            }
        } catch (Exception e) {
            System.out.println("ERROR EN REGISTRO: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=registro_fallido");
        }
    }
}