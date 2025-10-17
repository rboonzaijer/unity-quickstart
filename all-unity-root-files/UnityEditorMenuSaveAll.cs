// Assets/Editor/UnityEditorMenuSaveAll.cs

// This file will add a 'Save All' to the Unity Editor menu, to execute both the 'File/Save' and 'File/Save Project', to avoid corrupt Scene's.
// It can be triggered with the shortcut CTRL+SHIFT+ALT+S

#if UNITY_EDITOR

using UnityEditor;
using UnityEngine;

namespace MysticEraGames
{
    public class UnityEditorMenuSaveAll
    {
        [MenuItem("File/Save All (CTRL+S + Save Project) %#&S")] // Ctrl+Shift+Alt+S to trigger this function
        static void SaveAll()
        {
            if (!Application.isPlaying)
            {
                EditorApplication.ExecuteMenuItem("File/Save");
                EditorApplication.ExecuteMenuItem("File/Save Project");

                Debug.Log("UnityEditorMenuSaveAll: Executed 'File/Save' + 'File/Save Project'");
            }
            else
            {
                Debug.LogWarning("UnityEditorMenuSaveAll: Application is still playing (no save performed)");
            }
        }
    }
}
#endif
