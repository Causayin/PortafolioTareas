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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                TareaDAO dao = new TareaDAO();
                boolean eliminado = dao.eliminarTarea(id);
                
                if (eliminado) {
                    response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?mensaje=eliminada");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?error=fallo");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?error=fallo");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp");
        }
    }
}