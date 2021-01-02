using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.SideChannels;
using System.Text;
using System;

public class SimpleChannel : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        

        
    }

    // Update is called once per frame
    void Update()
    {
        var envParameters = Academy.Instance.EnvironmentParameters;
        float property1 = envParameters.GetWithDefault("parameter_1", 0.0f);
        Debug.Log("hi");
        Debug.Log(property1);

    }
}
