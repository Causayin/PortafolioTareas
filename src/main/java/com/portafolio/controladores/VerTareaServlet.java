package com.portafolio.controladores;

import com.portafolio.dao.TareaDAO;
import com.portafolio.modelos.Tarea;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/VerTareaServlet")
public class VerTareaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de tarea requerido");
            return;
        }
        
        try {
            int tareaId = Integer.parseInt(idParam);
            TareaDAO tareaDAO = new TareaDAO();
            Tarea tarea = tareaDAO.getTareaById(tareaId);
            
            if (tarea == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tarea no encontrada");
                return;
            }
            
            String archivoUrl = tarea.getArchivoRuta();
            String archivoNombre = tarea.getArchivoNombre();
            
            System.out.println("=== VerTareaServlet: URL = " + archivoUrl);
            System.out.println("=== VerTareaServlet: Nombre = " + archivoNombre);
            
            // Abrir conexión a Cloudinary
            URL url = new URL(archivoUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("User-Agent", "Mozilla/5.0");
            conn.connect();
            
            int responseCode = conn.getResponseCode();
            System.out.println("=== VerTareaServlet: Response Code = " + responseCode);
            
            if (responseCode != HttpURLConnection.HTTP_OK) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Error al cargar el archivo desde Cloudinary: " + responseCode);
                return;
            }
            
            // Obtener el tipo de contenido
            String contentType = conn.getContentType();
            if (contentType == null) {
                contentType = "application/pdf";
            }
            
            System.out.println("=== VerTareaServlet: Content-Type = " + contentType);
            
            // === CLAVE: Headers para visualización INLINE ===
            response.setContentType(contentType);
            response.setHeader("Content-Disposition", "inline; filename=\"" + archivoNombre + "\"");
            response.setHeader("Content-Length", String.valueOf(conn.getContentLength()));
            response.setHeader("Cache-Control", "public, max-age=31536000");
            
            // Copiar el archivo de Cloudinary al response
            try (InputStream inputStream = conn.getInputStream();
                 ServletOutputStream outputStream = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
                outputStream.flush();
            }
            
            System.out.println("=== VerTareaServlet: PDF enviado correctamente");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error al cargar el archivo: " + e.getMessage());
        }
    }
}