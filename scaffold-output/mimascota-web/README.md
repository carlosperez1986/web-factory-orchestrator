# Mi Mascota — Web

Sitio web oficial de **Mi Mascota** (Oclara Group).

- **Stack:** .NET 9 · Razor Pages · Bootstrap 5 · Decap CMS · Git-backed JSON/MD
- **Dominio:** [mimascota.com.co](https://mimascota.com.co)
- **Admin CMS:** `/admin/`
- **Generado por:** WFO project-scaffolding skill

---

## Desarrollo local

```bash
# Requisitos: .NET 9 SDK
dotnet restore
dotnet run
# → http://localhost:5000
```

## Estructura de contenido

```
wwwroot/content/
├── hero.json              # Banner principal (editable desde /admin/)
├── product-lines.json     # 4 líneas de producto
├── about.json             # Historia, misión, equipo
├── gallery.json           # Galería de fotos/videos
├── contact.json           # WhatsApp, redes, distribuidores
├── testimonials.json      # Reseñas de clientes
├── legal.json             # T&C, Privacidad, Devoluciones
├── products/              # Una ficha JSON por producto
└── blog/                  # Un archivo .md por artículo
```

## Páginas

| Ruta | Descripción |
|------|-------------|
| `/` | Inicio — Hero, líneas de producto, testimonios, blog preview |
| `/productos` | Catálogo con filtro por línea |
| `/productos/{slug}` | Ficha de producto con galería Swiper |
| `/blog` | Listado de artículos con filtro por categoría |
| `/blog/{slug}` | Artículo completo |
| `/galeria` | Galería con filtro por línea |
| `/nosotros` | Historia, misión, equipo, compromiso ecológico |
| `/contacto` | Formulario + WhatsApp + distribuidores |
| `/legal` | Términos, Privacidad (Ley 1581), Devoluciones |
| `/admin/` | Panel de administración Decap CMS |

## Variables de entorno (producción)

Configura en el servidor VPS:

```
GitHub__ClientId=<tu-oauth-client-id>
GitHub__ClientSecret=<tu-oauth-client-secret>
```

## Deploy

```bash
git push origin main
# → GitHub Actions despliega automáticamente al VPS
```

Ver `.github/workflows/deploy.yml` para el pipeline completo.
