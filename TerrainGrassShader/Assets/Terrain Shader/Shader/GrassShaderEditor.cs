using UnityEngine;
using System.Collections;
using UnityEditor;

public class GrassShaderEditor : ShaderGUI {

	bool toggle = true;
	bool toggle2 = true;
	bool[] foldoutToggle = new bool[4];

	Texture2D grassTexture1, grassTexture2, grassTexture3, grassTexture4;
	float height1;

	public override void OnGUI (MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // base.OnGUI (materialEditor, properties);
		GUIStyle gs = new GUIStyle();
		gs.fontSize = 20;

        int index = 18;
        MaterialProperty[] temp = new MaterialProperty[6];
        for(int j = 0; j < 4; j++)
        {
        	for(int i = 0; i < 6; i++)
	        {
	        	temp[i] = properties[++index];
	        }

	        foldoutToggle[j] = EditorGUILayout.Foldout(foldoutToggle[j], "Options for Terrain texture " + j);
	        if(foldoutToggle[j]){
                EditorGUI.indentLevel++;
	        	base.OnGUI (materialEditor, temp);
                EditorGUI.indentLevel--;
                EditorGUILayout.Space();
	        }	        
        }
        EditorGUILayout.Space();
		EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

        temp = new MaterialProperty[properties.Length - index - 1];
        for(int i = index +1, j = 0; i < properties.Length; i++, j++){
        	temp[j] = properties[i];
        }

        base.OnGUI (materialEditor, temp);

    }
}
