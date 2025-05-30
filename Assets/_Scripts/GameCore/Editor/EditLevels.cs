using UnityEngine;
using UnityEditor;
using UnityEditorInternal;
using GameCore.Scriptables;

namespace GameCore.Editor
{
    public class EditLevels : UnityEditor.EditorWindow
    {
        private LevelData levelData;
        private SerializedObject serializedLevelData;
        private ReorderableList reorderableList;
        private Vector2 scrollPosition;

        [UnityEditor.MenuItem("Game Design/Edit Levels")]
        private static void ShowWindow()
        {
            var window = GetWindow<EditLevels>();
            window.titleContent = new UnityEngine.GUIContent("Edit Levels");
            window.Show();
        }

        private void OnEnable()
        {
            LoadLevelData();
        }

        private void LoadLevelData()
        {
            string[] guids = AssetDatabase.FindAssets("t:LevelData", new[] { "Assets/_Data" });
            
            if (guids.Length > 0)
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(guids[0]);
                levelData = AssetDatabase.LoadAssetAtPath<LevelData>(assetPath);
                
                if (levelData != null)
                {
                    serializedLevelData = new SerializedObject(levelData);
                    SetupReorderableList();
                }
            }
        }

        private void SetupReorderableList()
        {
            if (serializedLevelData == null) return;

            SerializedProperty levelPrefabReferences = serializedLevelData.FindProperty("LevelPrefabReferences");
            
            reorderableList = new ReorderableList(serializedLevelData, levelPrefabReferences, true, true, true, true);

            reorderableList.drawHeaderCallback = (Rect rect) =>
            {
                EditorGUI.LabelField(rect, "Level Prefab References");
            };

            reorderableList.drawElementCallback = (Rect rect, int index, bool isActive, bool isFocused) =>
            {
                SerializedProperty element = levelPrefabReferences.GetArrayElementAtIndex(index);
                rect.y += 2;
                rect.height = EditorGUIUtility.singleLineHeight;
                
                EditorGUI.LabelField(new Rect(rect.x, rect.y, 50, rect.height), $"[{index}]");
                EditorGUI.PropertyField(new Rect(rect.x + 55, rect.y, rect.width - 55, rect.height), element, GUIContent.none);
            };            reorderableList.onAddCallback = (ReorderableList list) =>
            {
                levelPrefabReferences.arraySize++;
            };

            reorderableList.onRemoveCallback = (ReorderableList list) =>
            {
                if (EditorUtility.DisplayDialog("Remove Level Reference", 
                    $"Are you sure you want to remove level reference at index {list.index}?", 
                    "Yes", "No"))
                {
                    ReorderableList.defaultBehaviours.DoRemoveButton(list);
                }
            };
        }

        private void OnGUI()
        {
            if (levelData == null)
            {
                EditorGUILayout.HelpBox("No LevelData asset found in Assets/_Data folder.", MessageType.Warning);
                
                if (GUILayout.Button("Create LevelData Asset"))
                {
                    CreateLevelDataAsset();
                }
                
                if (GUILayout.Button("Refresh"))
                {
                    LoadLevelData();
                }
                return;
            }

            EditorGUILayout.LabelField($"Editing: {levelData.name}", EditorStyles.boldLabel);
            EditorGUILayout.Space();

            if (serializedLevelData == null)
            {
                LoadLevelData();
                return;
            }

            serializedLevelData.Update();

            scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition);
            
            if (reorderableList != null)
            {
                reorderableList.DoLayoutList();
            }
            
            EditorGUILayout.EndScrollView();
            EditorGUILayout.Space();
            
            if (GUILayout.Button("Save Changes"))
            {
                serializedLevelData.ApplyModifiedProperties();
                EditorUtility.SetDirty(levelData);
                AssetDatabase.SaveAssets();
                ShowNotification(new GUIContent("Changes saved!"));
            }

            if (serializedLevelData.hasModifiedProperties)
            {
                EditorGUILayout.HelpBox("You have unsaved changes. Remember to save!", MessageType.Info);
            }

            serializedLevelData.ApplyModifiedProperties();
        }

        private void CreateLevelDataAsset()
        {
            if (!AssetDatabase.IsValidFolder("Assets/_Data"))
            {
                AssetDatabase.CreateFolder("Assets", "_Data");
            }

            LevelData newLevelData = CreateInstance<LevelData>();
            string assetPath = "Assets/_Data/LevelData.asset";
            
            AssetDatabase.CreateAsset(newLevelData, assetPath);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            
            LoadLevelData();
        }

        private void OnDisable()
        {
            if (serializedLevelData != null && serializedLevelData.hasModifiedProperties)
            {
                if (EditorUtility.DisplayDialog("Unsaved Changes", 
                    "You have unsaved changes. Do you want to save them before closing?", 
                    "Save", "Don't Save"))
                {
                    serializedLevelData.ApplyModifiedProperties();
                    EditorUtility.SetDirty(levelData);
                    AssetDatabase.SaveAssets();
                }
            }
        }
    }
}
