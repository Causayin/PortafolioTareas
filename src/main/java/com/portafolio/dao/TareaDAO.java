package com.portafolio.dao;

import com.portafolio.modelos.Tarea;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TareaDAO {

    public List<Tarea> getTareasBySemanaId(int semanaId) {
        List<Tarea> tareas = new ArrayList<>();
        String sql = "SELECT * FROM tareas WHERE semana_id = ?";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, semanaId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Tarea t = new Tarea();
                t.setId(rs.getInt("id"));
                t.setTitulo(rs.getString("titulo"));
                t.setDescripcion(rs.getString("descripcion"));
                t.setArchivoNombre(rs.getString("archivo_nombre"));
                t.setArchivoRuta(rs.getString("archivo_ruta"));
                t.setFechaSubida(rs.getString("fecha_subida"));
                tareas.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tareas;
    }

    public List<Tarea> getAllTareas() {
        List<Tarea> tareas = new ArrayList<>();
        String sql = "SELECT * FROM tareas ORDER BY semana_id ASC, id DESC";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Tarea t = new Tarea();
                t.setId(rs.getInt("id"));
                t.setTitulo(rs.getString("titulo"));
                t.setDescripcion(rs.getString("descripcion"));
                t.setArchivoNombre(rs.getString("archivo_nombre"));
                t.setArchivoRuta(rs.getString("archivo_ruta"));
                t.setFechaSubida(rs.getString("fecha_subida"));
                t.setSemanaId(rs.getInt("semana_id"));
                tareas.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tareas;
    }
    
    public boolean eliminarTarea(int id) {
    String sql = "DELETE FROM tareas WHERE id = ?";
    
    try (Connection conn = ConexionDB.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
    
}
