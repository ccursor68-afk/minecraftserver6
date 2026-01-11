import { NextResponse } from 'next/server'
import { supabaseAdmin } from '../../../../../lib/supabase.js'

// GET /api/auth/user/[id] - Get user by ID
export async function GET(request, { params }) {
  try {
    const userId = params.id
    
    if (!userId) {
      return NextResponse.json({ error: 'User ID required' }, { status: 400 })
    }
    
    // Get user from users table using admin client (bypasses RLS)
    const { data: user, error } = await supabaseAdmin
      .from('users')
      .select('id, username, email, role, createdAt, isActive')
      .eq('id', userId)
      .single()
    
    if (error) {
      console.error('Error fetching user:', error)
      // If user doesn't exist in users table, return default role
      return NextResponse.json({ 
        id: userId, 
        email: '', 
        role: 'user', 
        isActive: true 
      })
    }
    
    return NextResponse.json(user)
  } catch (error) {
    console.error('API Error:', error)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}
