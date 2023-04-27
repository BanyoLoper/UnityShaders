using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dissolve : MonoBehaviour
{

    public Material dissolveMaterial;
    public float dissolveSpeed = 1f;

    private float _dissolveThreshold = 0f;
    private float _timePassed = 0f;
    private bool _increasing = true;
    
    private void Update()
    {
        _timePassed += Time.deltaTime * dissolveSpeed;

        if (_increasing) {
            _dissolveThreshold = Mathf.Lerp(0f, 1f, _timePassed);
            if (_dissolveThreshold >= 1f) {
                _increasing = false;
                _timePassed = 0f;
            }
        } else {
            _dissolveThreshold = Mathf.Lerp(1f, 0f, _timePassed);
            if (_dissolveThreshold <= 0f) {
                _increasing = true;
                _timePassed = 0f;
            }
        }

        dissolveMaterial.SetFloat("_DissolveThreshold", _dissolveThreshold);
    }
}
