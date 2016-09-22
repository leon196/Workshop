using UnityEngine;
using System.Collections;

public class FrameBuffer
{
	RenderTexture[] textures;
	int currentTexture;

	public FrameBuffer ()
	{
		currentTexture = 0;
		textures = new RenderTexture[2];
	}

	public void Create (int width, int height)
	{
		for (int i = 0; i < textures.Length; ++i) 
		{
			if (textures[i]) 
			{
				textures[i].Release();
			}
			textures[i] = new RenderTexture(width, height, 24, RenderTextureFormat.ARGBFloat);
			textures[i].Create();
			textures[i].wrapMode = TextureWrapMode.Clamp;
			textures[i].filterMode = FilterMode.Point;
		}
	}

	public void Swap ()
	{
		currentTexture = (currentTexture + 1) % 2;
	}

	public RenderTexture Get ()
	{
		return textures[currentTexture];
	}
}
