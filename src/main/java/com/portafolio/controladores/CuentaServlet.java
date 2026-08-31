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

@WebServlet("/CuentaServlet")
public class CuentaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        String nuevoNombre = request.getParameter("nombre");
        String nuevoEmail = request.getParameter("email");
        
        usuario.setNombre(nuevoNombre);
        usuario.setEmail(nuevoEmail);
        
        UsuarioDAO dao = new UsuarioDAO();
        if (dao.actualizarUsuario(usuario)) {
            session.setAttribute("usuario", usuario); // Actualizar sesión
            response.sendRedirect(request.getContextPath() + "/cuenta.jsp?msg=ok");
        } else {
            response.sendRedirect(request.getContextPath() + "/cuenta.jsp?msg=error");
        }
    }
}