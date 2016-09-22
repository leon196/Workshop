using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GameOfLifeShaderPass : MonoBehaviour
{
	public Material material;

	[Range(0.0f, 1.0f)]
	public float delay = 0.1f;

	private Material shader;
	private Texture2D input;

	private RenderTexture output;
	private FrameBuffer frameBuffer;

	private int width = 128;
	private int height = 128;

	private float last = 0f;

	void Start ()
	{
		Camera.onPreRender += onPreRender;
		

		input = new Texture2D(width, height);
		
		Color[] colorArray = new Color[width * height];
		for (int i = 0; i < colorArray.Length; ++i) 
		{
			colorArray[i] = Random.Range(0f, 1f) > 0.5f ? Color.white : Color.black;
		}
		
		input.SetPixels(colorArray);
		input.Apply();

		if (material)
		{
			material.mainTexture = input;
		}

		frameBuffer = new FrameBuffer();
		frameBuffer.Create(width, height);
		output = frameBuffer.Get();
		frameBuffer.Swap();
		Graphics.Blit(input, frameBuffer.Get());
	}

	public void onPreRender (Camera camera)
	{
		if (shader == null)
		{
			shader = new Material(Shader.Find("Hidden/GameOfLife"));
			shader.SetVector("_Resolution", new Vector2(width, height));
		}

		if (last + delay < Time.time)
		{
			last = Time.time;

			Graphics.Blit(frameBuffer.Get(), output, shader);

			output = frameBuffer.Get();
			frameBuffer.Swap();

			if (material)
			{
				material.mainTexture = output;
			}
		}
	}
}