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
        
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("index.jsp?error=pass_no_coincide");
            return;
        }
        
        Usuario usuario = new Usuario();
        usuario.setNombre(nombre);
        usuario.setEmail(email);
        usuario.setPassword(password);
        
        UsuarioDAO dao = new UsuarioDAO();
        
        try {
            if (dao.registrarUsuario(usuario)) {
                response.sendRedirect("index.jsp?exito=registro_ok");
            } else {
                response.sendRedirect("index.jsp?error=email_existe");
            }
        } catch (Exception e) {
            response.sendRedirect("index.jsp?error=registro_fallido");
        }
    }
}