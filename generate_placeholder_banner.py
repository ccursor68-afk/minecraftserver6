import asyncio
import base64
import httpx

async def generate_placeholder_banner():
    api_key = "sk-emergent-905FbC07d00A631044"
    proxy_url = "https://integrations.emergentagent.com/llm"
    
    prompt = """Generate a Minecraft-style banner image for a server placeholder. 
    The image should be:
    - Wide panoramic format (468x60 pixels ratio, banner style)
    - Dark themed with green/emerald Minecraft colors
    - Show abstract Minecraft blocks pattern (grass blocks, stone, diamonds scattered)
    - Subtle and not too busy - suitable as a background for text overlay
    - Pixelated/voxel Minecraft aesthetic
    - Dark gradient from left to right for text readability
    - No text in the image - just the background design"""
    
    try:
        async with httpx.AsyncClient(timeout=180.0) as client:
            response = await client.post(
                f"{proxy_url}/v1/images/generations",
                headers={
                    "Authorization": f"Bearer {api_key}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": "gemini/gemini-2.5-flash-image-preview",
                    "prompt": prompt,
                    "n": 1
                }
            )
            
            print(f"Status: {response.status_code}")
            
            if response.status_code == 200:
                data = response.json()
                
                if "data" in data and len(data["data"]) > 0:
                    img_data = data["data"][0]
                    
                    if "b64_json" in img_data:
                        image_bytes = base64.b64decode(img_data["b64_json"])
                        with open('/app/public/placeholder-banner.png', 'wb') as f:
                            f.write(image_bytes)
                        print("SUCCESS: Placeholder banner saved")
                        return True
                    elif "url" in img_data:
                        img_response = await client.get(img_data["url"])
                        with open('/app/public/placeholder-banner.png', 'wb') as f:
                            f.write(img_response.content)
                        print("SUCCESS: Placeholder banner saved from URL")
                        return True
            else:
                print(f"Response: {response.text[:500]}")
            
            return False
            
    except Exception as e:
        print(f"ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    result = asyncio.run(generate_placeholder_banner())
    print(f"Result: {result}")
