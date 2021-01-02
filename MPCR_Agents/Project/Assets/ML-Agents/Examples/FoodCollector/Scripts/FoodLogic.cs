using UnityEngine;

public class FoodLogic : MonoBehaviour
{
    public bool respawn;
    public FoodCollectorArea myArea;

    public void OnEaten()
    {
        if (respawn)
        {
            transform.position = new Vector3(Random.Range(-10, 10),3f,Random.Range(-10, 10)) + myArea.transform.position;
        }
        else
        {
            Destroy(gameObject);
        }
    }
}
