using UnityEngine;
using Unity.MLAgentsExamples;

public class FoodCollectorArea : Area
{
    public GameObject food;
    public GameObject badFood;
    public int numFood;
    public int numBadFood;
    public bool respawnFood;
    public float range;



    public void ResetFoodArea(GameObject[] agents)
    {

    }

    public override void ResetArea()
    {

    }
}
