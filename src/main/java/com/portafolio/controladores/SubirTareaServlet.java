package com.portafolio.controladores;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.portafolio.dao.ConexionDB;
import com.portafolio.modelos.Usuario;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/SubirTareaServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class SubirTareaServlet extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        super.init();

        String cloudName = System.getenv("CLOUDINARY_CLOUD_NAME");
        String apiKey = System.getenv("CLOUDINARY_API_KEY");
        String apiSecret = System.getenv("CLOUDINARY_API_SECRET");

        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", cloudName,
                "api_key", apiKey,
                "api_secret", apiSecret
        ));
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null || !"admin".equals(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        int semanaId = Integer.parseInt(request.getParameter("semanaId"));
        int categoriaId = Integer.parseInt(request.getParameter("categoriaId"));

        Part filePart = request.getPart("archivo");
        String fileName = filePart.getSubmittedFileName();

        String ext = "";
        if (fileName != null && fileName.contains(".")) {
            ext = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        }

        try {
            InputStream inputStream = filePart.getInputStream();
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            int nRead;
            byte[] data = new byte[16384];
            while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
                buffer.write(data, 0, nRead);
            }
            buffer.flush();
            byte[] fileBytes = buffer.toByteArray();

            String resourceType = "raw";
            if (ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".gif")) {
                resourceType = "image";
            }

            Map uploadResult = cloudinary.uploader().upload(
                    fileBytes,
                    ObjectUtils.asMap(
                            "resource_type", resourceType,
                            "public_id", fileName.replaceAll("\\.[^.]+$", ""),
                            "access_mode", "public"
                    )
            );

            // === CORRECCIÓN: Usar secure_url siempre ===
            String archivoUrl = "";
            String publicId = fileName.replaceAll("\\.[^.]+$", "");

            if (resourceType.equals("raw")) {
                archivoUrl = cloudinary.url()
                        .resourceType("raw")
                        .secure(true)
                        .version((Integer) uploadResult.get("version"))
                        .generate(publicId);

                // === AGREGA ESTA LÍNEA ===
                archivoUrl = archivoUrl + "?attachment=false";

            } else {
                archivoUrl = (String) uploadResult.get("secure_url");
            }

            System.out.println("✅ URL generada: " + archivoUrl);

            String sql = "INSERT INTO tareas (titulo, descripcion, archivo_nombre, archivo_ruta, semana_id, categoria_id, usuario_id) VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, titulo);
                ps.setString(2, descripcion);
                ps.setString(3, fileName);
                ps.setString(4, archivoUrl);
                ps.setInt(5, semanaId);
                ps.setInt(6, categoriaId);
                ps.setInt(7, usuario.getId());

                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?mensaje=exito");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-tareas.jsp?error=fallo");
        }
    }
}
