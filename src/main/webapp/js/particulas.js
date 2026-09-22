// ============================================
// SISTEMA DE PARTÍCULAS TECH
// ============================================

class ParticleSystem {
    constructor(canvasId, options = {}) {
        this.canvas = document.getElementById(canvasId);
        if (!this.canvas) return;
        
        this.ctx = this.canvas.getContext('2d');
        this.particles = [];
        this.options = {
            particleCount: options.particleCount || 50,
            connectionDistance: options.connectionDistance || 150,
            particleSpeed: options.particleSpeed || 0.5,
            particleSize: options.particleSize || 2,
            color: options.color || '#FFD700'
        };
        
        this.resize();
        this.init();
        this.animate();
        
        window.addEventListener('resize', () => this.resize());
    }
    
    resize() {
        const rect = this.canvas.parentElement.getBoundingClientRect();
        this.canvas.width = rect.width;
        this.canvas.height = rect.height;
    }
    
    init() {
        for (let i = 0; i < this.options.particleCount; i++) {
            this.particles.push({
                x: Math.random() * this.canvas.width,
                y: Math.random() * this.canvas.height,
                vx: (Math.random() - 0.5) * this.options.particleSpeed,
                vy: (Math.random() - 0.5) * this.options.particleSpeed,
                size: Math.random() * this.options.particleSize + 1
            });
        }
    }
    
    animate() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        
        // Actualizar y dibujar partículas
        this.particles.forEach(p => {
            p.x += p.vx;
            p.y += p.vy;
            
            // Rebotar en los bordes
            if (p.x < 0 || p.x > this.canvas.width) p.vx *= -1;
            if (p.y < 0 || p.y > this.canvas.height) p.vy *= -1;
            
            // Dibujar partícula
            this.ctx.beginPath();
            this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
            this.ctx.fillStyle = this.options.color;
            this.ctx.fill();
        });
        
        // Conectar partículas cercanas
        for (let i = 0; i < this.particles.length; i++) {
            for (let j = i + 1; j < this.particles.length; j++) {
                const dx = this.particles[i].x - this.particles[j].x;
                const dy = this.particles[i].y - this.particles[j].y;
                const distance = Math.sqrt(dx * dx + dy * dy);
                
                if (distance < this.options.connectionDistance) {
                    this.ctx.beginPath();
                    this.ctx.moveTo(this.particles[i].x, this.particles[i].y);
                    this.ctx.lineTo(this.particles[j].x, this.particles[j].y);
                    this.ctx.strokeStyle = this.options.color;
                    this.ctx.globalAlpha = 1 - (distance / this.options.connectionDistance);
                    this.ctx.lineWidth = 0.5;
                    this.ctx.stroke();
                    this.ctx.globalAlpha = 1;
                }
            }
        }
        
        requestAnimationFrame(() => this.animate());
    }
}

// Inicializar sistemas de partículas cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
    // Partículas del hero (más densas)
    new ParticleSystem('particles-canvas', {
        particleCount: 80,
        connectionDistance: 120,
        particleSpeed: 0.8
    });
    
    // Animaciones de las secciones
    new ParticleSystem('tech-animation-1', {
        particleCount: 40,
        connectionDistance: 100,
        particleSpeed: 0.5
    });
    
    new ParticleSystem('tech-animation-2', {
        particleCount: 40,
        connectionDistance: 100,
        particleSpeed: 0.5
    });
    
    new ParticleSystem('tech-animation-3', {
        particleCount: 40,
        connectionDistance: 100,
        particleSpeed: 0.5
    });
});