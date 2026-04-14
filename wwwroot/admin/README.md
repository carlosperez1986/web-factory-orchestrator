# Guía Editorial — Mi Mascota CMS

> Panel de administración disponible en: `/admin/`

---

## Inicio rápido

1. Abre `/admin/` en tu navegador
2. Haz clic en **Login with GitHub**
3. Autoriza la aplicación OAuth con tu cuenta `carlosperez1986`
4. Ya puedes editar el contenido del sitio

> ⚠️ Solo las cuentas con acceso al repositorio `carlosperez1986/mimascota-web` pueden editar.

---

## Dónde vive cada contenido

| Lo que quieres editar | Colección en el CMS | Archivo en Git |
|---|---|---|
| Banner principal (hero) | **Hero / Banner Principal** | `content/hero.json` |
| Las 4 líneas de producto | **Líneas de Producto** | `content/product-lines.json` |
| Productos individuales | **Productos** | `content/products/*.json` |
| Artículos del blog | **Blog** | `content/blog/*.md` |
| Página Nosotros (historia, equipo) | **Nosotros** | `content/about.json` |
| Galería de fotos y videos | **Galería** | `content/gallery.json` |
| WhatsApp, redes, distribuidores | **Contacto y Distribuidores** | `content/contact.json` |
| Reseñas de clientes | **Testimonios** | `content/testimonials.json` |
| Términos, privacidad, devoluciones | **Contenido Legal** | `content/legal.json` |

---

## ¿Cómo publicar un cambio?

1. Edita el campo deseado en el CMS
2. Haz clic en **Guardar** (guarda un borrador)
3. Haz clic en **Publicar** (hace commit al branch `main`)
4. Espera 1–2 minutos a que el CI/CD haga deploy automático
5. Refresca el sitio — los cambios son visibles

> El flujo Git es automático. No necesitas usar GitHub directamente.

---

## Cómo editar el Hero Banner

1. En el menú izquierdo, haz clic en **Hero / Banner Principal**
2. Haz clic en el único archivo **Hero Banner**
3. Edita los campos:
   - **Titular principal** — el H1 grande del banner
   - **Subtítulo** — el texto bajo el titular
   - **CTA primario** — botón principal (texto + URL)
   - **CTA secundario** — botón secundario (opcional)
   - **Imagen de fondo** — sube una imagen 1920×800px
4. Haz clic en **Publicar**

---

## Cómo agregar un producto nuevo

1. En **Productos**, haz clic en **Nuevo Producto**
2. Completa todos los campos obligatorios:
   - **Slug** — URL del producto (ej: `gel-higienizante-perros`) — sin tildes, sin espacios
   - **Nombre**, **Línea**, **Descripción**
   - **Ingredientes** — agrega uno por uno
   - **Instrucciones de uso**
   - **Presentaciones disponibles**
   - **Imágenes de galería** — agrega al menos 2
3. Haz clic en **Publicar**

La nueva URL del producto será: `/productos/{slug}`

---

## Cómo publicar un artículo de blog

1. En **Blog**, haz clic en **Nuevo Post**
2. Completa los campos:
   - **Título** — máximo 60 caracteres para SEO
   - **Fecha** — fecha de publicación
   - **Categoría** — selecciona del menú
   - **Imagen destacada** — 1200×630px
   - **Resumen** — máximo 160 caracteres (aparece en Google)
   - **Slug** — URL del artículo (ej: `tips-higiene-gatos-en-verano`)
   - **Contenido** — escribe en el editor Markdown
3. Haz clic en **Publicar**

La nueva URL del artículo será: `/blog/{slug}`

---

## Cómo actualizar los distribuidores

1. En **Contacto y Distribuidores**, haz clic en **Contacto**
2. En la sección **Distribuidores**, haz clic en **Agregar Distribuidor**
3. Completa: Ciudad, Nombre, Dirección, Teléfono
4. Haz clic en **Publicar**

---

## Cómo actualizar el número de WhatsApp

1. En **Contacto y Distribuidores → Contacto**
2. Edita **Número WhatsApp Business** — formato: `+573001234567`
3. Edita **Mensaje predeterminado** si deseas
4. Haz clic en **Publicar**

El botón flotante de WhatsApp en el sitio actualizará su link automáticamente.

---

## Convenciones de contenido

### Slugs
- Solo letras minúsculas, números y guiones
- Sin tildes, sin espacios, sin caracteres especiales
- ✅ `tips-higiene-gatos` 
- ❌ `Tips Higiene Gatos`, `tips_higiene_gatos`, `típs-higiéne`

### Imágenes
- Hero: **1920×800px** mínimo, formato JPG/WebP
- Productos: **800×800px** mínimo (cuadradas), formato JPG/WebP
- Blog: **1200×630px** (ratio 1.91:1), formato JPG/WebP
- Galería: **800×800px** mínimo

### Texto Markdown
El editor de blog, historia de la marca y contenido legal soportan Markdown:
```
# Título grande (H1) — no usar, el sistema lo genera
## Subtítulo (H2)
### Sección (H3)
**texto en negritas**
*texto en cursiva*
[texto del enlace](/url)
- Ítem de lista
```

---

## Soporte

¿Problemas con el panel? Contacta al equipo de desarrollo en el canal de proyecto.
