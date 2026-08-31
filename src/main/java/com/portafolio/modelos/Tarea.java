package com.portafolio.modelos;

public class Tarea {
    private int id;
    private String titulo;
    private String descripcion;
    private String archivoNombre;
    private String archivoRuta;
    private String fechaSubida;
    private int semanaId;
    private int categoriaId;
    private int usuarioId;

    public Tarea() {}

    public Tarea(int id, String titulo, String descripcion, String archivoNombre, 
                 String archivoRuta, String fechaSubida, int semanaId, int categoriaId, int usuarioId) {
        this.id = id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.archivoNombre = archivoNombre;
        this.archivoRuta = archivoRuta;
        this.fechaSubida = fechaSubida;
        this.semanaId = semanaId;
        this.categoriaId = categoriaId;
        this.usuarioId = usuarioId;
    }

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getArchivoNombre() { return archivoNombre; }
    public void setArchivoNombre(String archivoNombre) { this.archivoNombre = archivoNombre; }

    public String getArchivoRuta() { return archivoRuta; }
    public void setArchivoRuta(String archivoRuta) { this.archivoRuta = archivoRuta; }

    public String getFechaSubida() { return fechaSubida; }
    public void setFechaSubida(String fechaSubida) { this.fechaSubida = fechaSubida; }

    public int getSemanaId() { return semanaId; }
    public void setSemanaId(int semanaId) { this.semanaId = semanaId; }

    public int getCategoriaId() { return categoriaId; }
    public void setCategoriaId(int categoriaId) { this.categoriaId = categoriaId; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
}