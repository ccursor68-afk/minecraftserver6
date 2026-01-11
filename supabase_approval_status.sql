-- Add approvalStatus column to servers table
-- Run this in Supabase SQL Editor

-- Step 1: Add the column if it doesn't exist
ALTER TABLE servers 
ADD COLUMN IF NOT EXISTS "approvalStatus" TEXT DEFAULT 'approved';

-- Step 2: Update existing servers to 'approved' status (they were already live)
UPDATE servers 
SET "approvalStatus" = 'approved' 
WHERE "approvalStatus" IS NULL;

-- Step 3: Create an index for better query performance
CREATE INDEX IF NOT EXISTS idx_servers_approval_status ON servers("approvalStatus");

-- Optional: Add check constraint for valid values
-- ALTER TABLE servers 
-- ADD CONSTRAINT check_approval_status 
-- CHECK ("approvalStatus" IN ('pending', 'approved', 'rejected'));

-- View the updated table structure
-- SELECT column_name, data_type, column_default 
-- FROM information_schema.columns 
-- WHERE table_name = 'servers';
