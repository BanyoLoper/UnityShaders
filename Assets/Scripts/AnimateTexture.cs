using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimateTexture : MonoBehaviour
{
    public float speed = 1.0f;
    public float amplitude = 1.0f;

    private Renderer _renderer;
    private float _time;
    
    void Start()
    {
        _renderer = GetComponent<Renderer>();    
    }

    void Update()
    {
        _time += Time.deltaTime * speed;
        float offset = Mathf.Sin(_time) * amplitude;
        _renderer.material.SetTextureOffset("_MainTex", new Vector2(offset, 0));
    }
}
