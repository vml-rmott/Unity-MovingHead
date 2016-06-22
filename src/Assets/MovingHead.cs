using UnityEngine;
using System.Collections;

public class MovingHead : MonoBehaviour {

	public GameObject dmxObject;
	private DP.DMX dmx;

	public int address;

	[Range(0,540)]
	public float panDegrees;

	[Range(0,230)]
	public float tiltDegrees;

	[Range(0,255)]
	public float dimmer;

	[Range(0,255)]
	public float colour;

	private GameObject panArm;
	private GameObject tiltHead;

	// Use this for initialization
	void Start () 
	{
		dmx = dmxObject.GetComponent<DP.DMX>();

		panArm = this.transform.Find("Pan").gameObject;
		tiltHead = panArm.transform.Find("Head").gameObject;
	}
	
	// Update is called once per frame
	void Update () 
	{
		panArm.transform.eulerAngles = new Vector3(0, panDegrees, 0);
		tiltHead.transform.eulerAngles = new Vector3(tiltDegrees-25, panDegrees, 0);

		panDegrees = Mathf.PingPong(Time.time*40, 540);
		tiltDegrees = Mathf.PingPong(Time.time*40, 230);
		dmx[1] = (int)((255.0f/540)*panDegrees);
		dmx[3] = (int)((255.0f/230)*tiltDegrees);
		dmx[6] = (int)colour;
		dmx[7] = (int)dimmer;
	}
}
