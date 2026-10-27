# 🏗️ BuildTrack - Construction Monitoring System (SPA & PWA)

A responsive **Single-Page Application (SPA)** and **Progressive Web App (PWA)** for construction management, featuring real-time **Philippine Standard Time (PST)** synchronization, specialized engineering category rollups, Leaflet site map clearance controls, and collaborative @mention attention-tagging.

---

## 🌟 Instant Live Preview (Zero Setup Needed)

Open `standalone-preview.html` in your browser (Double-click or drag into Chrome/Edge/Firefox). It runs with zero dependencies!

---

## 🛠️ Tech Stack (100% Free Tier)

| Component | Technology |
| :--- | :--- |
| **Frontend** | React 18 + TypeScript + Vite |
| **Styling** | Tailwind CSS (Dark/Light mode) |
| **Map** | Leaflet + OpenStreetMap (free, no API key) |
| **Backend** | Supabase PostgreSQL + Realtime |
| **Hosting** | Netlify (static SPA deploy) |
| **PWA** | vite-plugin-pwa |

---

## 🚀 Features

- 🕒 **Philippine Standard Time (PST)** real-time clock (`Asia/Manila`, UTC+8)
- 🏗️ **Interactive Donut Chart** — overall project accomplishment % with animated SVG
- 📊 **Specialized Engineering Progress Bars** — Building Permits, Structural, Electrical, Mechanical
- 📅 **Timeline Aggregation** — Category timeline auto-spans from min(child starts) to max(child ends)
- ✅ **100% Completion Visual State** — Scope cards automatically turn emerald green when done
- 🔔 **@Call-Attention Tagging** — Red notification badges update live in Hamburger menu
- 🖼️ **Progress Photo Uploads** — Via Supabase Storage or base64 local preview
- 🇺🇸🇵🇭🇮🇳 **Trilingual i18n** — English, Filipino (Tagalog), Hindi
- 🌙 **Dark/Light Mode** — CSS class strategy, persisted in localStorage
- 📱 **Viewport Simulator** — Desktop / Tablet (768px) / Mobile (390px) frame preview
- 🗯️ **Live Leaflet Site Map** — With admin approval RBAC gating
- 🔒 **Role-Based Access** — Admin/Owner/Team Member permission system

---

## 📂 Project Structure

```text
├── standalone-preview.html      # Zero-install browser preview
├── index.html                   # Vite entry point
├── package.json
├── vite.config.ts               # Vite + PWA config
├── tailwind.config.js
├── netlify.toml                 # Netlify SPA redirect rules
├── supabase/
│   └── schema.sql               # PostgreSQL schema, RLS, seed data
└── src/
    ├── main.tsx
    ├── App.tsx
    ├── types.ts
    ├── index.css
    ├── context/AppContext.tsx
    ├── translations/index.ts
    ├── lib/supabase.ts
    └── components/
        ├── Header.tsx
        ├── Sidebar.tsx
        ├── HeroSection.tsx
        ├── ScopeSection.tsx
        ├── CommentDrawer.tsx
        ├── MapModal.tsx
        └── BrandingModal.tsx
```

---

## ⚡ Run Locally

```bash
npm install
npm run dev
# Open http://localhost:3000
```

---

## ☁️ Connect Supabase (Optional)

1. Create a free project at [supabase.com](https://supabase.com)
2. Run `supabase/schema.sql` in the SQL Editor
3. Create `.env`:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

> Without `.env`, the app uses `localStorage` fallback automatically.

---

## 🌐 Deploy to Netlify

1. Push this repo to GitHub
2. In Netlify: **Add New Site** → import this repo
3. Build command: `npm run build` · Publish dir: `dist`
4. Click **Deploy Site** — your PWA is live with HTTPS!
