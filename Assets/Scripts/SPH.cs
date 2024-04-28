using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SPH : MonoBehaviour
{
    const float G = -9.8f;
    [SerializeField] Material material;

    private int count = 250;
    private Vector4[] particles;
    private Vector4[] velocity;
    

    void Start()
    {
        particles = new Vector4[count];
        for (int i = 0; i < count; i++)
        {
            particles[i] = new Vector4(Random.value-0.5f, Random.value - 0.5f, 0.5f, 1);
        }

        material.SetVectorArray("_Pos", particles);

    }
}
