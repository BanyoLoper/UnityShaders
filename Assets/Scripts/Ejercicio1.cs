using UnityEngine;

public class Ejercicio1 : MonoBehaviour
{
    
    public float changeDuration = 1.0f;
    public float changeInterval = 5.0f;
    
    private Renderer _objectRenderer;
    private Material _material;
    private Color _currentColor, _targetColor;
    private float _elapsedTime = 0.0f;
    private float _colorChangeTime = 0.0f;
    private float _timeSinceLastChange = 0.0f;
    void Start()
    {
        _objectRenderer = GetComponent<Renderer>();
        _material = _objectRenderer.material;
        _targetColor = Random.ColorHSV();
    }

    void Update()
    {
        _elapsedTime += Time.deltaTime;
        _colorChangeTime += Time.deltaTime;
        
        if (_colorChangeTime >= _elapsedTime)
        {
            _currentColor = Color.Lerp(_currentColor, _targetColor, _colorChangeTime / changeDuration);
            _material.color = _currentColor;
        }
        
        if (_elapsedTime >= changeInterval)
        {
            _elapsedTime = 0.0f;
            _colorChangeTime = 0.0f;
            _targetColor = Random.ColorHSV();
        }
    }
}
