using UnityEngine;
using System.Collections;

public class GrassCollider : MonoBehaviour {

	struct cirCollider
	{
		public Vector3 pos;
		public float radius;
	};

	public float radius;
	public Material material;

	cirCollider col;
    static int ID = 0;
    int myId = 0;

	// Use this for initialization
	void Start () {
		col = new cirCollider();
		col.pos = transform.position;
		col.radius = radius;

        myId = ID++;
        material.SetInt("_colliderCount", ID);

        setData();
	}
	
	// Update is called once per frame
	void Update () {
		col.pos = transform.position;
		col.radius = radius;

		setData();
	}

	void OnRenderObject()
	{
		col.pos = transform.position;
		col.radius = radius;
		setData();
	}

	private void setData(){
		material.SetVector("_colPos" + myId, col.pos);
		material.SetFloat("_colRad" + myId, col.radius);
        
	}
}
