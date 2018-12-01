using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class PortalManager : MonoBehaviour {

    public GameObject mainCamera;   //主摄像机
        
    public Material portalMat;      //门的材质球

    public Material scene1Mat;      //黑色场景的材质球

    public Material scene2Mat;      //蓝色场景的材质球


    private void Update()
    {
        //计算 摄像机与门的相对位置
        Vector3 cameraPostionInPortalSpace = transform.InverseTransformPoint(mainCamera.transform.position);

        if(cameraPostionInPortalSpace.z < -0.3) //表示在scene2这边
        {
            scene2Mat.SetInt("_RefValue", (int)CompareFunction.Always);
            scene1Mat.SetInt("_RefValue", (int)CompareFunction.Equal);
            portalMat.SetInt("_RefValue", 1);
        }
        else if (cameraPostionInPortalSpace.z >0.3)
        {
            scene2Mat.SetInt("_RefValue", (int)CompareFunction.Equal);
            scene1Mat.SetInt("_RefValue", (int)CompareFunction.Always);
            portalMat.SetInt("_RefValue", 2);
        }
        else
        {
            scene2Mat.SetInt("_RefValue", (int)CompareFunction.Always);
            scene1Mat.SetInt("_RefValue", (int)CompareFunction.Always);
        }
    }
}
