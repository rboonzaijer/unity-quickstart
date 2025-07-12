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
