<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contacto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <h2 class="mb-4">Contáctame</h2>
                <div class="card p-4">
                    <form>
                        <div class="mb-3">
                            <label class="form-label">Tu Nombre</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tu Email</label>
                            <input type="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mensaje</label>
                            <textarea class="form-control" rows="4" required></textarea>
                        </div>
                        <button type="button" class="btn btn-primary" onclick="alert('Mensaje enviado (Simulación)')">Enviar Mensaje</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>