﻿using UnityEngine;
using System.Collections;

public class ImageFilter : MonoBehaviour
{
	public Material material;
	
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, material);
	}
}
