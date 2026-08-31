package com.portafolio.controladores;

import com.portafolio.dao.SemanaDAO;
import com.portafolio.dao.TareaDAO;
import com.portafolio.modelos.Semana;
import com.portafolio.modelos.Tarea;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        SemanaDAO semanaDAO = new SemanaDAO();
        TareaDAO tareaDAO = new TareaDAO();
        
        List<Semana> semanas = semanaDAO.getAllSemanas();
        List<Tarea> todasTareas = tareaDAO.getAllTareas();
        
        int totalSemanas = semanas.size();
        int totalTareas = todasTareas.size();
        
        int totalProyectos = 0;
        for (Tarea t : todasTareas) {
            if (t.getCategoriaId() == 3) {
                totalProyectos++;
            }
        }
        
        request.setAttribute("totalSemanas", totalSemanas);
        request.setAttribute("totalTareas", totalTareas);
        request.setAttribute("totalProyectos", totalProyectos);
        
        request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);
    }
}