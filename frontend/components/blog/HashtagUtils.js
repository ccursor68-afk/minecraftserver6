import Link from 'next/link'
import { Badge } from '@/components/ui/badge'

// Parse hashtags and make them clickable
export function parseHashtags(text) {
  if (!text) return text
  
  // Regex to find hashtags (#word)
  const hashtagRegex = /#(\w+)/g
  const parts = []
  let lastIndex = 0
  let match

  while ((match = hashtagRegex.exec(text)) !== null) {
    // Add text before hashtag
    if (match.index > lastIndex) {
      parts.push({
        type: 'text',
        content: text.slice(lastIndex, match.index)
      })
    }

    // Add hashtag
    parts.push({
      type: 'hashtag',
      content: match[0],
      tag: match[1]
    })

    lastIndex = match.index + match[0].length
  }

  // Add remaining text
  if (lastIndex < text.length) {
    parts.push({
      type: 'text',
      content: text.slice(lastIndex)
    })
  }

  return parts
}

// Render parsed content with clickable hashtags
export function RenderWithHashtags({ text, className = '' }) {
  const parts = parseHashtags(text)
  
  if (typeof parts === 'string') {
    return <span className={className}>{parts}</span>
  }

  return (
    <span className={className}>
      {parts.map((part, index) => {
        if (part.type === 'hashtag') {
          return (
            <Link
              key={index}
              href={`/blog?tag=${encodeURIComponent(part.tag)}`}
              className="text-green-500 hover:text-green-400 hover:underline font-medium"
            >
              {part.content}
            </Link>
          )
        }
        return <span key={index}>{part.content}</span>
      })}
    </span>
  )
}

// Extract hashtags from text
export function extractHashtags(text) {
  if (!text) return []
  
  const hashtagRegex = /#(\w+)/g
  const hashtags = []
  let match

  while ((match = hashtagRegex.exec(text)) !== null) {
    if (!hashtags.includes(match[1])) {
      hashtags.push(match[1])
    }
  }

  return hashtags
}

// Render hashtag badges
export function HashtagBadges({ hashtags, onTagClick }) {
  if (!hashtags || hashtags.length === 0) return null

  return (
    <div className="flex flex-wrap gap-2">
      {hashtags.map((tag, index) => (
        <Link
          key={index}
          href={`/blog?tag=${encodeURIComponent(tag)}`}
          onClick={(e) => {
            if (onTagClick) {
              e.preventDefault()
              onTagClick(tag)
            }
          }}
        >
          <Badge 
            variant="outline" 
            className="border-green-600 text-green-400 hover:bg-green-600 hover:text-white transition-colors cursor-pointer"
          >
            #{tag}
          </Badge>
        </Link>
      ))}
    </div>
  )
}
