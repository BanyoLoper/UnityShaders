using UnityEngine;

public class WaterWave : MonoBehaviour
{
    public Material waterWaveMaterial;

    void Update()
    {
        if (waterWaveMaterial != null)
        {
            waterWaveMaterial.SetFloat("_ElapsedTime", Time.time);
            waterWaveMaterial.SetFloat("_ScreenSize", new Vector2(Screen.width, Screen.height).magnitude);
        }    
    }
}
