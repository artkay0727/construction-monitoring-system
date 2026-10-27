import React from 'react';
import { useApp } from './context/AppContext';
import { Header } from './components/Header';
import { Sidebar } from './components/Sidebar';
import { HeroSection } from './components/HeroSection';
import { ScopeSection } from './components/ScopeSection';
import { CommentDrawer } from './components/CommentDrawer';
import { MapModal } from './components/MapModal';
import { BrandingModal } from './components/BrandingModal';
import { Monitor, Tablet, Smartphone, Download, HardHat } from 'lucide-react';

export const AppContent: React.FC = () => {
  const { viewportMode, setViewportMode } = useApp();

  return (
    <div className="min-h-screen bg-slate-100 dark:bg-slate-950 text-slate-800 dark:text-slate-100 flex flex-col transition-colors duration-200">
      
      {/* Viewport Framing Wrapper */}
      <div
        className={`mx-auto w-full transition-all duration-300 flex-1 flex flex-col ${
          viewportMode === 'tablet'
            ? 'max-w-[768px] my-6 rounded-3xl shadow-2xl border-8 border-slate-300 dark:border-slate-800 overflow-hidden'
            : viewportMode === 'mobile'
            ? 'max-w-[390px] my-6 rounded-3xl shadow-2xl border-8 border-slate-300 dark:border-slate-800 overflow-hidden'
            : 'max-w-full'
        }`}
      >
        {/* Viewport Mode active banner (if tablet or mobile) */}
        {viewportMode !== 'desktop' && (
          <div className="bg-slate-800 text-white text-xs px-4 py-1.5 flex items-center justify-between border-b border-slate-700">
            <span className="font-semibold flex items-center gap-1.5">
              {viewportMode === 'tablet' ? <Tablet className="w-3.5 h-3.5 text-brand-400" /> : <Smartphone className="w-3.5 h-3.5 text-brand-400" />}
              {viewportMode === 'tablet' ? 'Tablet Viewport Mode (768px)' : 'Mobile Viewport Mode (390px)'}
            </span>
            <button
              onClick={() => setViewportMode('desktop')}
              className="text-[11px] underline text-slate-300 hover:text-white"
            >
              Back to Full Desktop
            </button>
          </div>
        )}

        {/* Top Header Row: Company Logo, Company Name, Philippine Standard Time Clock */}
        <Header />

        {/* Second Row: Hamburger Menu Button & Nav Shortcuts */}
        <Sidebar />

        {/* Main Content Area */}
        <main className="flex-1">
          {/* Hero Section: Data visualization donut chart + specialized engineering progress bars */}
          <HeroSection />

          {/* Second Section: Scope of Works, Admin controls, Timeline aggregation, 100% completion style */}
          <ScopeSection />
        </main>

        {/* Footer */}
        <footer className="mt-auto border-t border-slate-200 dark:border-slate-800 bg-white/50 dark:bg-slate-900/50 py-6 px-4 text-center text-xs text-slate-500 dark:text-slate-400">
          <div className="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-3">
            <div className="flex items-center gap-2">
              <HardHat className="w-4 h-4 text-brand-600 dark:text-brand-400" />
              <span className="font-bold text-slate-800 dark:text-slate-200">
                BuildTrack · Construction Monitoring System
              </span>
            </div>
            <div className="text-[11px]">
              Single-Page Application & PWA · Netlify Ready · Supabase Realtime Compatible
            </div>
          </div>
        </footer>
      </div>

      {/* Modals & Overlays */}
      <CommentDrawer />
      <MapModal />
      <BrandingModal />
    </div>
  );
};

export default function App() {
  return <AppContent />;
}