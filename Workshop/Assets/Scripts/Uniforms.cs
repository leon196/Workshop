using UnityEngine;
using System.Collections;

public class Uniforms : MonoBehaviour {

	public Transform target;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		Shader.SetGlobalVector("_Target", target.position);
	}
}
