package com.portafolio.dao;

import com.portafolio.modelos.Semana;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SemanaDAO {
    public List<Semana> getAllSemanas() {
        List<Semana> semanas = new ArrayList<>();
        String sql = "SELECT * FROM semanas ORDER BY numero ASC";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Semana s = new Semana();
                s.setId(rs.getInt("id"));
                s.setNumero(rs.getInt("numero"));
                s.setNombre(rs.getString("nombre"));
                s.setDescripcion(rs.getString("descripcion"));
                semanas.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return semanas;
    }
}
