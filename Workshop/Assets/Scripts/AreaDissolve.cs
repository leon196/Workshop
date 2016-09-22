using UnityEngine;
using System.Collections;

public class AreaDissolve : MonoBehaviour {

	Bounds bounds;
	Material material;

	void Start () {
		bounds = GetComponent<MeshFilter>().mesh.bounds;
		material = GetComponent<Renderer>().sharedMaterial;
		// material = GetComponent<Renderer>().material;
	}
	
	void Update () {
		material.SetVector("_BoundsMin", bounds.min);
		material.SetVector("_BoundsMax", bounds.max);

		// Vector3 a = bounds.min;
		// Vector3 b = bounds.min;
		// b.x = bounds.max.x;
		// Debug.DrawLine(a, b, Color.red);
	}
}
