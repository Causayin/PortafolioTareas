<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.portafolio.modelos.Usuario" %>
<!DOCTYPE html>
<html>
<head>
    <title>Portafolio - Ludwin Pedro Rojas Rios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="css/estilos.css" rel="stylesheet">
    <link href="css/index.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <!-- Hero Section con Partículas -->
    <div class="hero-section-modern">
        <canvas id="particles-canvas"></canvas>
        <div class="hero-content">
            <div class="container">
                <h1 class="hero-title">Ludwin Pedro Rojas Rios</h1>
                <p class="hero-subtitle">Portafolio de Actividades y Evidencias</p>
                <div class="hero-cta">
                    <a href="tareas.jsp" class="btn-hero">Explorar Tareas</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Sección 1: Sobre Mí (Info izquierda, Animación derecha) -->
    <div class="section-alternada">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 fade-in-left">
                    <div class="info-card-modern">
                        <h2 class="section-title">Sobre Mí</h2>
                        <p class="section-text">
                            Estudiante apasionado por el desarrollo web y la creación de soluciones tecnológicas dinámicas. 
                            Este portafolio contiene todas mis tareas universitarias organizadas por semanas, 
                            demostrando mi progreso y aprendizaje en cada etapa.
                        </p>
                        <div class="section-stats">
                            <div class="stat-item">
                                <span class="stat-number">5+</span>
                                <span class="stat-label">Semanas</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">10+</span>
                                <span class="stat-label">Tareas</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">100%</span>
                                <span class="stat-label">Compromiso</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 fade-in-right">
                    <div class="animation-container">
                        <canvas id="tech-animation-1"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Sección 2: Habilidades (Animación izquierda, Info derecha) -->
    <div class="section-alternada section-reverse">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 fade-in-left">
                    <div class="animation-container">
                        <canvas id="tech-animation-2"></canvas>
                    </div>
                </div>
                <div class="col-lg-6 fade-in-right">
                    <div class="info-card-modern">
                        <h2 class="section-title">Habilidades y Herramientas</h2>
                        <div class="skills-grid">
                            <div class="skill-item">
                                <div class="skill-icon"></div>
                                <div class="skill-content">
                                    <h4>Desarrollo y Bases de Datos</h4>
                                    <p>Java, MySQL, JSP, Servlets</p>
                                </div>
                            </div>
                            <div class="skill-item">
                                <div class="skill-icon">⚙️</div>
                                <div class="skill-content">
                                    <h4>Gestión y Plataformas</h4>
                                    <p>GitHub, NetBeans, Apache Tomcat</p>
                                </div>
                            </div>
                            <div class="skill-item">
                                <div class="skill-icon">🎨</div>
                                <div class="skill-content">
                                    <h4>Diseño Web</h4>
                                    <p>HTML5, CSS3, Bootstrap</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Sección 3: Evidencias -->
    <div class="section-alternada">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 fade-in-left">
                    <div class="info-card-modern">
                        <h2 class="section-title">Evidencias de la Semana 1</h2>
                        <p class="section-text">
                            Aquí se encuentra la infografía resumen sobre los 
                            <strong class="text-warning">Fundamentos de un Proyecto Web</strong>.
                        </p>
                        <a href="tareas.jsp" class="btn-hero mt-3">Ver Tareas</a>
                    </div>
                </div>
                <div class="col-lg-6 fade-in-right">
                    <div class="animation-container">
                        <canvas id="tech-animation-3"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/particulas.js"></script>
</body>
</html>