using UnityEngine;

namespace MalbersAnimations
{
    public class UnityUtils : MonoBehaviour
    {
        public virtual void Freeze_Time(bool value) => Time.timeScale = value ? 0 : 1;

        /// <summary>Destroy this GameObject by a time </summary>
        public void DestroyMe(float time) => Destroy(gameObject, time);

        /// <summary>Destroy this GameObject</summary>
        public void DestroyMe() => Destroy(gameObject);

        /// <summary>Destroy this GameObject</summary>
        public void GameObjectHide(float time) => Invoke(nameof(GOHide), time);

        private void GOHide() => gameObject.SetActive(false);

        /// <summary>Destroy a GameObject</summary>
        public void DestroyGameObject(GameObject go) => Destroy(go);

        /// <summary>Random Rotate around X</summary>
        public void RandomRotateAroundX() => transform.Rotate(new Vector3(Random.Range(0, 360), 0, 0), Space.Self);

        /// <summary>Random Rotate around X</summary>
        public void RandomRotateAroundY() => transform.Rotate(new Vector3(0, Random.Range(0, 360), 0), Space.Self);
        /// <summary>Random Rotate around X</summary>
        public void RandomRotateAroundZ() => transform.Rotate(new Vector3(0, 0, Random.Range(0, 360)), Space.Self);

        /// <summary>Destroy a Component</summary>
        public void DestroyComponent(Component component) => Destroy(component);

        /// <summary>Parent this Game Object to a new Transform, retains its World Position</summary>
        public void Parent(Transform newParent) => transform.parent = newParent;

        /// <summary>Parent this Game Object to a new Transform</summary>
        public void Parent_Local(Transform newParent)
        {
            transform.parent = newParent;
            transform.localPosition = Vector3.zero;
            transform.localRotation = Quaternion.identity;
            transform.localScale = Vector3.one;
        }

        /// <summary>Instantiate a GameObject in the position of this gameObject</summary>
        public void Instantiate(GameObject go) => Instantiate(go, transform.position, transform.rotation);

        /// <summary>Instantiate a GameObject in the position of this gameObject and parent to this object</summary>
        public void InstantiateAndParent(GameObject go) => Instantiate(go, transform.position, transform.rotation, transform);

        public static void ShowCursor(bool value)
        {
            Cursor.lockState = !value ? CursorLockMode.Locked : CursorLockMode.None;  // Lock or unlock the cursor.
            Cursor.visible = value;
        } 
    }
    /// <summary> Used to store Transform pos, rot and scale values </summary>
    [System.Serializable]
    public struct TransformOffset
    {
        public Vector3 Position;
        public Vector3 Rotation;
        public Vector3 Scale;


        public TransformOffset(int def)
        {
            Position = Vector3.zero;
            Rotation = Vector3.zero;
            Scale = Vector3.one;
        }
    }
}
