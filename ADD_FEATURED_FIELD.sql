-- ============================================
-- Add Sponsored/Featured Server Support
-- ============================================
-- Run this script in your Supabase SQL Editor
-- Dashboard: https://supabase.com → Your Project → SQL Editor
-- ============================================

-- Add isFeatured column to servers table (for sponsored servers)
ALTER TABLE servers ADD COLUMN IF NOT EXISTS isFeatured BOOLEAN DEFAULT false;

-- Add featuredUntil column to track when sponsorship expires
ALTER TABLE servers ADD COLUMN IF NOT EXISTS featuredUntil TIMESTAMP WITH TIME ZONE;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_servers_featured ON servers(isFeatured, featuredUntil);

-- ============================================
-- Example: Make some servers featured/sponsored
-- ============================================
-- You can customize these or remove this section

-- Make first 3 servers featured (example)
UPDATE servers 
SET isFeatured = true, 
    featuredUntil = NOW() + INTERVAL '30 days'
WHERE id IN (
  SELECT id FROM servers 
  ORDER BY voteCount DESC 
  LIMIT 3
);

-- ============================================
-- NOTES:
-- ============================================
-- 1. isFeatured: true = Sponsorlu sunucu (SPONSOR rozet gösterilir)
-- 2. featuredUntil: Sponsorluk bitiş tarihi (null = sınırsız)
-- 3. Admin panelinden sunucuları featured yapabilirsiniz
-- 4. Sponsorluk süresi dolduğunda manuel olarak false yapılmalı
--    (veya otomatik cron job eklenebilir)
-- ============================================
