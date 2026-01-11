-- ============================================
-- Create RPC Function for Updating Featured Status
-- ============================================
-- Run this in Supabase SQL Editor
-- This bypasses the schema cache issue
-- ============================================

-- Create function to update server featured status
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
  SET "isFeatured" = true,
      "featuredUntil" = featured_until
  WHERE id = server_id;
END;
$$;

-- Create function to remove server featured status
CREATE OR REPLACE FUNCTION remove_server_featured(
  server_id TEXT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE servers
  SET "isFeatured" = false,
      "featuredUntil" = NULL
  WHERE id = server_id;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION update_server_featured TO authenticated;
GRANT EXECUTE ON FUNCTION remove_server_featured TO authenticated;
GRANT EXECUTE ON FUNCTION update_server_featured TO service_role;
GRANT EXECUTE ON FUNCTION remove_server_featured TO service_role;
