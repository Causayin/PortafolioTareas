package com.portafolio.controladores;

import com.portafolio.dao.UsuarioDAO;
import com.portafolio.modelos.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = dao.validarLogin(email, password);

        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            if ("admin".equals(usuario.getRol())) {
                response.sendRedirect("AdminServlet");  // ← CAMBIO: Redirige al servlet
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // CAMBIO IMPORTANTE: Redirigir al index con un parámetro de error
            response.sendRedirect("index.jsp?error=login_fallido");
        }
    }
}
