-- ============================================
-- FIXED: RPC Functions with Correct Column Names
-- ============================================
-- Supabase created columns as lowercase without quotes
-- ============================================

-- Drop old functions if exist
DROP FUNCTION IF EXISTS update_server_featured(TEXT, TIMESTAMP WITH TIME ZONE);
DROP FUNCTION IF EXISTS remove_server_featured(TEXT);

-- Create function to update server featured status (FIXED)
CREATE OR REPLACE FUNCTION update_server_featured(
  server_id TEXT,
  featured_until TIMESTAMP WITH TIME ZONE
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE servers
  SET isfeatured = true,
      featureduntil = featured_until
  WHERE id = server_id;
END;
$$;

-- Create function to remove server featured status (FIXED)
CREATE OR REPLACE FUNCTION remove_server_featured(
  server_id TEXT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE servers
  SET isfeatured = false,
      featureduntil = NULL
  WHERE id = server_id;
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION update_server_featured TO service_role;
GRANT EXECUTE ON FUNCTION remove_server_featured TO service_role;
GRANT EXECUTE ON FUNCTION update_server_featured TO authenticated;
GRANT EXECUTE ON FUNCTION remove_server_featured TO authenticated;
