using UnityEngine;
using System.Collections;

public class VertexToTexture : MonoBehaviour 
{
	public Material debug;
	public Material shader;
	public string uniformName;

	Mesh mesh;
	Renderer render;
	public Texture2D texture;
	Color[] colorArray;
	int resolution;
	FrameBuffer frameBuffer;
	RenderTexture output;

	void Start ()
	{
		mesh = GetComponent<MeshFilter>().sharedMesh;
		resolution = (int)GetNearestPowerOfTwo(Mathf.Sqrt(mesh.vertices.Length));
		texture = new Texture2D(resolution, resolution, TextureFormat.RGBAFloat, false);
		texture.filterMode = FilterMode.Point;
		colorArray = new Color[resolution * resolution];

		Print();

		frameBuffer = new FrameBuffer();
		frameBuffer.Create(resolution, resolution);

		Graphics.Blit(texture, frameBuffer.Get());
		frameBuffer.Swap();
		Graphics.Blit(texture, frameBuffer.Get());

		Shader.SetGlobalTexture(uniformName, frameBuffer.Get());
		Shader.SetGlobalTexture("_VertexTexture", texture);
		Shader.SetGlobalFloat("_Resolution", resolution);

		render = GetComponent<Renderer>();
	}

	void Update ()
	{
		Shader.SetGlobalMatrix("_RendererMatrix", render.localToWorldMatrix);
		Shader.SetGlobalMatrix("_InverseMatrix", render.localToWorldMatrix.inverse);
		Shader.SetGlobalVector("_TransformPosition", transform.position);
		Shader.SetGlobalMatrix("_TransformMatrix", transform.localToWorldMatrix);

		Graphics.Blit(frameBuffer.Get(), output, shader);
		output = frameBuffer.Get();
		frameBuffer.Swap();

		if (debug) {
			debug.mainTexture = output;
		}

		Shader.SetGlobalTexture("_VertexTexture", texture);
		Shader.SetGlobalTexture(uniformName, frameBuffer.Get());
	}

	// http://stackoverflow.com/questions/466204/rounding-up-to-nearest-power-of-2
	float GetNearestPowerOfTwo (float x)
	{
		return Mathf.Pow(2f, Mathf.Ceil(Mathf.Log(x) / Mathf.Log(2f)));
	}

	public void Print ()
	{
		if (texture != null) 
		{
			int i = 0;
			Vector3 p;
			Vector3[] vertices = mesh.vertices;
      Vector2[] uvs2 = new Vector2[vertices.Length];
			int count = resolution * resolution;
			for (i = 0; i < vertices.Length; ++i) {
				p = vertices[i];
				
      	float x = i % resolution;
      	float y = Mathf.Floor(i / (float)resolution);
        uvs2[i] = new Vector2(x, y) / (float)resolution;

				colorArray[i].r = p.x;
				colorArray[i].g = p.y;
				colorArray[i].b = p.z;
			}

      mesh.uv2 = uvs2;

			texture.SetPixels(colorArray);
			texture.Apply();
		}
	}
}