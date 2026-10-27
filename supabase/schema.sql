-- ==============================================================================
-- Construction Monitoring System - Supabase PostgreSQL Database Schema
-- Includes Row Level Security (RLS), Realtime replication, and Seed Data
-- ==============================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Site Settings Table (Company branding, map coordinates, support contacts)
CREATE TABLE IF NOT EXISTS site_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_name TEXT NOT NULL DEFAULT 'Apex Horizon Builders & Construction Corp.',
    company_logo_url TEXT DEFAULT '',
    admin_email TEXT NOT NULL DEFAULT 'admin@apexhorizon.ph',
    admin_phone TEXT NOT NULL DEFAULT '+63 (02) 8876-5432 / +63 917 123 4567',
    site_latitude DOUBLE PRECISION NOT NULL DEFAULT 14.5547,  -- Bonifacio Global City / Metro Manila coords
    site_longitude DOUBLE PRECISION NOT NULL DEFAULT 121.0244,
    site_address TEXT NOT NULL DEFAULT 'Plot 4A, High Street South, Bonifacio Global City, Taguig, Philippines',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Profiles Table (Extends Supabase auth.users or acts as directory of stakeholders)
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('admin', 'owner', 'team_member', 'viewer')),
    member_color TEXT NOT NULL DEFAULT '#3B82F6', -- Hex color code for badges/tags
    can_access_map BOOLEAN NOT NULL DEFAULT false,
    email TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Specialized Engineering Categories
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    is_general_scope BOOLEAN NOT NULL DEFAULT false,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Scope of Works
CREATE TABLE IF NOT EXISTS scopes_of_work (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT DEFAULT '',
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    percent_completion INT NOT NULL DEFAULT 0 CHECK (percent_completion >= 0 AND percent_completion <= 100),
    assigned_person_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Comments & Instructions
CREATE TABLE IF NOT EXISTS comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    scope_id UUID NOT NULL REFERENCES scopes_of_work(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    photo_url TEXT,
    tagged_person_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    is_call_attention BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. Notifications (Call-Attention tags)
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipient_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    scope_id UUID NOT NULL REFERENCES scopes_of_work(id) ON DELETE CASCADE,
    comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    is_read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. Enable Row Level Security (RLS)
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE scopes_of_work ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- 9. Setup Public Read Policies
CREATE POLICY "Public profiles can be read" ON profiles FOR SELECT USING (true);
CREATE POLICY "Public site_settings can be read" ON site_settings FOR SELECT USING (true);
CREATE POLICY "Public categories can be read" ON categories FOR SELECT USING (true);
CREATE POLICY "Public scopes_of_work can be read" ON scopes_of_work FOR SELECT USING (true);
CREATE POLICY "Public comments can be read" ON comments FOR SELECT USING (true);
CREATE POLICY "Public notifications can be read" ON notifications FOR SELECT USING (true);

-- Setup Modification Policies (Admins can do all; Users can comment and update read status)
CREATE POLICY "Anyone can insert comments" ON comments FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can insert notifications" ON notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "Recipients can update notifications" ON notifications FOR UPDATE USING (true);
CREATE POLICY "Admins or users can update scopes_of_work" ON scopes_of_work FOR ALL USING (true);
CREATE POLICY "Admins can update categories" ON categories FOR ALL USING (true);
CREATE POLICY "Admins can update site_settings" ON site_settings FOR ALL USING (true);
CREATE POLICY "Admins can update profiles" ON profiles FOR ALL USING (true);

-- 10. Enable Supabase Realtime for instant synchronization
ALTER PUBLICATION supabase_realtime ADD TABLE scopes_of_work;
ALTER PUBLICATION supabase_realtime ADD TABLE comments;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
ALTER PUBLICATION supabase_realtime ADD TABLE site_settings;
ALTER PUBLICATION supabase_realtime ADD TABLE profiles;

-- 11. Seed Initial Data
INSERT INTO site_settings (company_name, admin_email, admin_phone, site_latitude, site_longitude, site_address)
VALUES (
    'Apex Horizon Builders & Construction Corp.',
    'lead.admin@apexhorizon.ph',
    '+63 (02) 8876-5432 / +63 917 888 9900',
    14.5547,
    121.0244,
    'Tower 3 Construction Site, 28th Street, Bonifacio Global City, Taguig City, Philippines'
) ON CONFLICT DO NOTHING;

-- Seed Stakeholders & Team Members
INSERT INTO profiles (id, full_name, role, member_color, can_access_map, email)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'Engr. Carlos Mendoza (Lead Project Admin)', 'admin', '#DC2626', true, 'carlos.mendoza@apexhorizon.ph'),
    ('22222222-2222-2222-2222-222222222222', 'Mr. Fernando Zobel (Project Owner / Investor)', 'owner', '#D97706', true, 'fernando.owner@capitalgroup.ph'),
    ('33333333-3333-3333-3333-333333333333', 'Ms. Maria Beatrice Tan (Project Owner Representative)', 'owner', '#9333EA', false, 'maria.tan@holdings.ph'),
    ('44444444-4444-4444-4444-444444444444', 'Engr. Paolo Reyes (Senior Structural Engineer)', 'team_member', '#2563EB', true, 'paolo.reyes@apexhorizon.ph'),
    ('55555555-5555-5555-5555-555555555555', 'Engr. Lito Santos (Electrical Systems Head)', 'team_member', '#059669', false, 'lito.santos@apexhorizon.ph'),
    ('66666666-6666-6666-6666-666666666666', 'Arch. Camille Dizon (Mechanical & HVAC Specialist)', 'team_member', '#EA580C', false, 'camille.dizon@apexhorizon.ph'),
    ('77777777-7777-7777-7777-777777777777', 'Engr. Mark Villanueva (Permits & Safety Officer)', 'team_member', '#0891B2', true, 'mark.v@apexhorizon.ph')
ON CONFLICT DO NOTHING;

-- Seed Categories
INSERT INTO categories (id, name, is_general_scope, sort_order)
VALUES
    ('c1111111-1111-1111-1111-111111111111', 'Building Permits & Regulatory Approvals', false, 1),
    ('c2222222-2222-2222-2222-222222222222', 'Structural & Civil Works', false, 2),
    ('c3333333-3333-3333-3333-333333333333', 'Electrical & Power Distribution', false, 3),
    ('c4444444-4444-4444-4444-444444444444', 'Mechanical & HVAC Installation', false, 4),
    ('c5555555-5555-5555-5555-555555555555', 'General Scope of Works & Site Logistics', true, 5)
ON CONFLICT DO NOTHING;

-- Seed Scopes of Work
INSERT INTO scopes_of_work (id, category_id, title, description, start_date, end_date, percent_completion, assigned_person_id)
VALUES
    -- Permits
    ('s1010101-1010-1010-1010-101010101010', 'c1111111-1111-1111-1111-111111111111', 'LGU Barangay & City Hall Building Clearance', 'Secured building permit from Taguig Engineering Office', '2026-06-01', '2026-06-15', 100, '77777777-7777-7777-7777-777777777777'),
    ('s1020202-2020-2020-2020-202020202020', 'c1111111-1111-1111-1111-111111111111', 'Bureau of Fire Protection (BFP) Safety Clearance', 'Fire safety inspection certificate and sprinkler layout validation', '2026-06-16', '2026-07-05', 85, '77777777-7777-7777-7777-777777777777'),
    
    -- Structural
    ('s2010101-1010-1010-1010-101010101010', 'c2222222-2222-2222-2222-222222222222', 'Excavation & Substructure Ground Prep', 'Deep foundation drilling and soil stabilization', '2026-06-10', '2026-06-28', 100, '44444444-4444-4444-4444-444444444444'),
    ('s2020202-2020-2020-2020-202020202020', 'c2222222-2222-2222-2222-222222222222', 'Foundation Rebars & Grade Beam Pouring', 'Placement of high-tensile Grade 60 rebar and 4000 PSI concrete pour', '2026-06-25', '2026-07-18', 70, '44444444-4444-4444-4444-444444444444'),
    ('s2030303-3030-3030-3030-303030303030', 'c2222222-2222-2222-2222-222222222222', 'Column Erection & Suspended Slab Formwork', 'Levels 1 to 3 shear walls and structural beams', '2026-07-15', '2026-08-20', 35, '44444444-4444-4444-4444-444444444444'),

    -- Electrical
    ('s3010101-1010-1010-1010-101010101010', 'c3333333-3333-3333-3333-333333333333', 'Main Service Feeder & Rough-in Conduits', 'Embedment of PVC and EMT conduits in slabs and risers', '2026-07-01', '2026-08-05', 55, '55555555-5555-5555-5555-555555555555'),
    ('s3020202-2020-2020-2020-202020202020', 'c3333333-3333-3333-3333-333333333333', 'Sub-panel Distribution & Earthing Grid', 'Grounding rod installation and main circuit breaker panels', '2026-08-06', '2026-09-10', 15, '55555555-5555-5555-5555-555555555555'),

    -- Mechanical
    ('s4010101-1010-1010-1010-101010101010', 'c4444444-4444-4444-4444-444444444444', 'HVAC Ductwork Fabrication & Ceiling Hangars', 'Fabrication of galvanized steel ducts and insulation brackets', '2026-07-20', '2026-08-30', 40, '66666666-6666-6666-6666-666666666666'),

    -- General Scope (Excluded from Hero Section engineering progress bars, placed in Section 2)
    ('s5010101-1010-1010-1010-101010101010', 'c5555555-5555-5555-5555-555555555555', 'Site Security, Temporary Perimeter Fencing & Barracks', 'Erection of temporary facilities, security checkpoint, and utilities', '2026-05-20', '2026-06-05', 100, '11111111-1111-1111-1111-111111111111'),
    ('s5020202-2020-2020-2020-202020202020', 'c5555555-5555-5555-5555-555555555555', 'Weekly Hauling & Debris Waste Management', 'Scheduled disposal of excavation dirt and construction debris', '2026-06-01', '2026-10-30', 45, '11111111-1111-1111-1111-111111111111')
ON CONFLICT DO NOTHING;