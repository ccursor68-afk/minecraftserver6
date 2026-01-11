-- ============================================
-- Add logoUrl field to servers table
-- ============================================
-- Run this script in your Supabase SQL Editor to add logo support
-- Dashboard: https://supabase.com → Your Project → SQL Editor
-- ============================================

-- Add logoUrl column to servers table
ALTER TABLE servers ADD COLUMN IF NOT EXISTS "logoUrl" TEXT;

-- Optional: Add some example logos for existing servers
-- You can customize these URLs or remove this section

-- Example: Update MellowCraft with a logo
UPDATE servers 
SET "logoUrl" = 'https://via.placeholder.com/80/eab308/000000?text=MC'
WHERE name = 'MellowCraft';

-- Example: Update MysticMC with a logo
UPDATE servers 
SET "logoUrl" = 'https://via.placeholder.com/80/3b82f6/ffffff?text=MM'
WHERE name = 'MysticMC';

-- Example: Update Simple Survival with a logo
UPDATE servers 
SET "logoUrl" = 'https://via.placeholder.com/80/10b981/ffffff?text=SS'
WHERE name = 'Simple Survival';

-- ============================================
-- NOTES:
-- ============================================
-- 1. Logo URLs can be:
--    - Uploaded to Supabase Storage
--    - External URLs (ensure CORS is properly configured)
--    - Minecraft avatar URLs: https://mc-heads.net/avatar/{username}/80
--
-- 2. Recommended logo size: 80x80 pixels or larger (square format)
--
-- 3. If logoUrl is NULL or empty, the site will display the first letter
--    of the server name as a fallback
-- ============================================
