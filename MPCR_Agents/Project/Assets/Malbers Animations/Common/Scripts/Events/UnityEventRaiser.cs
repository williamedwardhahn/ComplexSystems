using UnityEngine;
using UnityEngine.Serialization;

namespace MalbersAnimations.Events
{
    /// <summary>Simple Event Raiser On Enable</summary>
    public class UnityEventRaiser : UnityUtils
    {
        [Tooltip("Delayed time for invoking the Events, or the Repeated time  when Repeat is enable")]
        public float Delayed;
        public float RepeatTime;
        public bool Repeat;
        public string desc;

        [FormerlySerializedAs("OnEnableEvent")]
        public UnityEngine.Events.UnityEvent onEnable;


        public string Description = "";
        [HideInInspector] public bool editDescription = false;
        [ContextMenu("Edit Description")]
        internal void EditDescription() => editDescription ^= true;

        public void OnEnable()
        {
            if (Repeat && RepeatTime > 0f)
            {
                InvokeRepeating(nameof(StartEvent), Delayed, RepeatTime);
            }
            else if (Delayed > 0)
            {
                Invoke(nameof(StartEvent), Delayed);
            }
            else
            {
                onEnable.Invoke();
            }
        }

        [ContextMenu("Invoke on Editor")]
        private void StartEvent() => onEnable.Invoke();


        private void OnDisable() => CancelInvoke();
    }






#if UNITY_EDITOR
    [UnityEditor.CustomEditor(typeof(UnityEventRaiser))]
    public class UnityEventRaiserInspector : UnityEditor.Editor
    {
        UnityEditor.SerializedProperty Delayed, Repeat, RepeatTime, OnEnableEvent, editDescription, Description;
        public static GUIStyle StyleBlue => Style(new Color(0, 0.5f, 1f, 0.3f));



        private void OnEnable()
        {
            Delayed = serializedObject.FindProperty("Delayed");
            editDescription = serializedObject.FindProperty("editDescription");
            Description = serializedObject.FindProperty("Description");
            Repeat = serializedObject.FindProperty("Repeat");
            RepeatTime = serializedObject.FindProperty("RepeatTime");
            OnEnableEvent = serializedObject.FindProperty("onEnable");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            if (editDescription.boolValue)
                UnityEditor.EditorGUILayout.PropertyField(Description);
            else
              if (!string.IsNullOrEmpty(Description.stringValue))
            {
                UnityEditor.EditorGUILayout.BeginVertical(StyleBlue);
                UnityEditor.EditorGUILayout.HelpBox(Description.stringValue, UnityEditor.MessageType.None);
                UnityEditor.EditorGUILayout.EndVertical();
            }


            UnityEditor.EditorGUILayout.BeginHorizontal();

            UnityEditor.EditorGUILayout.PropertyField(Delayed, GUILayout.MinWidth(100));
            if (Repeat.boolValue)
            {

                UnityEditor.EditorGUIUtility.labelWidth = 40;
                UnityEditor.EditorGUILayout.PropertyField(RepeatTime,new GUIContent("RT","Repeat Time") ,GUILayout.MinWidth(40));
                UnityEditor.EditorGUIUtility.labelWidth = 0;
            }
            
            Repeat.boolValue = GUILayout.Toggle(Repeat.boolValue, new GUIContent("Repeat"), UnityEditor.EditorStyles.miniButton, GUILayout.Width(47));
            UnityEditor.EditorGUILayout.EndHorizontal();
            UnityEditor.EditorGUILayout.PropertyField(OnEnableEvent);
            serializedObject.ApplyModifiedProperties();
        }


        public static GUIStyle Style(Color color)
        {
            GUIStyle currentStyle = new GUIStyle(GUI.skin.box) { border = new RectOffset(-1, -1, -1, -1) };


            Color[] pix = new Color[1];
            pix[0] = color;
            Texture2D bg = new Texture2D(1, 1);
            bg.SetPixels(pix);
            bg.Apply();


            currentStyle.normal.background = bg;

#if UNITY_2019 || UNITY_2020
            // MW 04-Jul-2020: Check if system supports newer graphics formats used by Unity GUI
            Texture2D bgActual = currentStyle.normal.scaledBackgrounds[0];

            if (SystemInfo.IsFormatSupported(bgActual.graphicsFormat, UnityEngine.Experimental.Rendering.FormatUsage.Sample) == false)
            {
                currentStyle.normal.scaledBackgrounds = new Texture2D[] { }; // This can't be null
            }
#endif
            return currentStyle;
        }
    }
#endif
}