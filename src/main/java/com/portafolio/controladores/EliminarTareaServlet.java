package com.portafolio.controladores;

import com.portafolio.dao.TareaDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/EliminarTareaServlet")
public class EliminarTareaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Verificar que sea admin
        if (session.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                TareaDAO dao = new TareaDAO();
                boolean eliminado = dao.eliminarTarea(id);
                
                if (eliminado) {
                    // Redirigir al panel admin con mensaje de éxito
                    response.sendRedirect(request.getContextPath() + "/admin/gestionar_tareas.jsp?mensaje=exito");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/gestionar_tareas.jsp?error=fallo");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("AdminServlet?msg=error");
            }
        } else {
            response.sendRedirect("AdminServlet");
        }
    }
}