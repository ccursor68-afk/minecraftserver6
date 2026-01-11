import asyncio
import base64
import httpx

async def generate_minecraft_background():
    api_key = "sk-emergent-905FbC07d00A631044"
    proxy_url = "https://integrations.emergentagent.com/llm"
    
    prompt = """Generate a beautiful Minecraft-style landscape image for a website hero background. 
    The scene should show a Minecraft village with blocky houses, green grass blocks, oak trees, 
    mountains in the background with warm sunset lighting. Classic Minecraft voxel aesthetic.
    Wide panoramic composition (16:9 aspect ratio)."""
    
    try:
        async with httpx.AsyncClient(timeout=180.0) as client:
            # Use Emergent proxy for Gemini image generation
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
                print(f"Response keys: {data.keys() if isinstance(data, dict) else 'not dict'}")
                
                if "data" in data and len(data["data"]) > 0:
                    img_data = data["data"][0]
                    
                    if "b64_json" in img_data:
                        image_bytes = base64.b64decode(img_data["b64_json"])
                        with open('/app/public/minecraft-hero-bg.png', 'wb') as f:
                            f.write(image_bytes)
                        print("SUCCESS: Image saved from base64")
                        return True
                    elif "url" in img_data:
                        img_response = await client.get(img_data["url"])
                        with open('/app/public/minecraft-hero-bg.png', 'wb') as f:
                            f.write(img_response.content)
                        print("SUCCESS: Image saved from URL")
                        return True
            else:
                print(f"Response: {response.text[:1000]}")
            
            return False
            
    except Exception as e:
        print(f"ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    result = asyncio.run(generate_minecraft_background())
    print(f"Result: {result}")
