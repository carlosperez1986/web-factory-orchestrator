# Nexo Escolar — Client Briefing (pasted from chat, 2026-05-02)

**Source:** Chat text pasted directly in conversation.  
**Received:** 2026-05-02

---

Nexo Escolar – The Ultimate Production-Ready SaaS Blueprint
Role: Senior Creative Technologist & Product UI Engineer.
Objective: Architect a world-class, high-conversion landing page for "Nexo Escolar", a school management platform for K-12 institutions. The code must prioritize 100% Spanish copy, premium UX, and absolute precision in interactive components.

Core Stack & Architecture:

Framework: React 18+, Tailwind CSS.
Component Library: shadcn/ui (Accordion, Tabs, Input, Button, Form).
Motion: Framer Motion for scroll-orchestrated storytelling and micro-interactions.
Typography: Font family 'Plus Jakarta Sans' (Google Fonts).
Headlines: clamp(28px, 5vw, 56px), weight 700, -0.02em tracking.
Subheadings: clamp(20px, 3vw, 32px), weight 600.
Body: 17px, weight 400.
Color Palette: Deep Navy (#0F1B3C), Electric Teal (#00C9B1), Amber (#FFC857).

Page Architecture & Component Specifications

0. NAVBAR (Sticky & Glass)
ID: navbar | Logo: Typographic React component: "Nexo" (800 weight, #00C9B1) + "Escolar" (400 weight, White).
Links: Funciones (#funciones), Beneficios (#beneficios), App (#app), Demo (#demo).
Behavior: backdrop-blur-md, transparent at top, #0F1B3C on scroll.

1. HERO (#hero)
Headline: "Gestión escolar en tiempo real para colegios que quieren operar mejor."
Visual (Coded Mockup - No images):
Left (Admin): Dark glass card with chips: "Asistencia hoy: 94%", "Comunicados: 12", "Grupos: 8".
Right (Phone): CSS-only frame showing notification: "Tu hijo Marco llegó tarde hoy — Colegio Nexo".
Motion: Mouse-parallax effect (Phone: 8px, Dashboard: 4px).

2. PROBLEM (#problema)
Headline: "La gestión escolar no puede depender de procesos dispersos."
UI: 4 cards with border-white/10 and bg-white/5. Use the exact Spanish pain point copy.

3. INTERACTIVE HUB (#beneficios)
Logic: Central "Nexo" node with SVG pulses toward "Directivos", "Docentes", "Padres".
Desktop Hover Panel: On node hover, display an absolute floating panel (right-0).
Style: bg-white/10, backdrop-blur-md, rounded-xl, p-4.
Content: Role h3 + ul with 3 benefit bullets.
Motion: opacity 0→1, x: 20→0, duration 0.3s.
Mobile: Replace SVG with shadcn/ui Tabs (stacked full-width).

4. BENTO GRID FEATURES (#funciones)
Desktop Layout: Row 1: col-span-7, col-span-5. Row 2: col-span-4 x3.
Mobile Layout: All 5 cards full-width stacked vertically (flex-col gap-4).
Style: bg-white/5, rounded-2xl, p-6. Hover: border-[#00C9B1]/50, scale(1.02), Teal glow icon (Lucide).

5. MOBILE APP SHOWCASE (#app)
Headline: "El colegio en tu bolsillo."
Visual: CSS-only Android phone frame (rounded-[3rem], border-4 border-white/20).
Content: 2 notification cards with teal accents and Spanish text. No external images.
Copy: Highlights for real-time alerts, grades, and Android availability.

6. TRUST VISUALS (#trust)
Headline: "Diseñado para colegios que necesitan orden, velocidad y trazabilidad."
Components: 3 horizontal blocks with Lucide icons (Shield, CheckCircle, Lock) in Teal.

7. ACTION FORM (#demo)
Card: Glassmorphism, border-teal/30, rounded-2xl, p-8.
Form Fields: Nombre completo, Nombre del colegio, Correo institucional, WhatsApp.
Submit: "Quiero mi demo" (Amber, full-width).
Microcopy (Below Button): "Te contactamos en menos de 24 horas hábiles." (Style: text-sm, text-white/50, text-center, mt-2).

8. FAQ (#faq)
Component: shadcn/ui Accordion.
Content: Use the exact 3 Q&As in Spanish regarding educational levels, family communication, and modular implementation.

9. FOOTER (#footer)
Style: Deep navy, border-t border-teal/20.
Content: Logo + Tagline: "Conectando colegios, docentes y familias."

Operational Guidelines:
Zero Placeholders: Use only the provided Spanish copy.
Animation Orchestration: All sections use fadeUp (y: 40 → 0, opacity: 0 → 1) via Framer Motion whileInView.
Responsiveness: Use flex-col for mobile-first stacking and clamp() for fluid typography.
Performance: Prioritize CSS-based visuals over external image assets.
