using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

public class iOSManager : MonoBehaviour
{

    static iOSManager _instance;

#if UNITY_IOS
    [DllImport("__Internal")]
    private static extern bool _DetectCaptured();

    [DllImport("__Internal")]
    private static extern bool detectScreenshot();

    [DllImport("__Internal")]
    private static extern void deleteScreenShot();

    [DllImport("__Internal")]
    private static extern void permissionPhoto();
#endif

    public static iOSManager GetInstance()
    {
        if(_instance == null)
        {
            _instance = new GameObject("iOSManager").AddComponent<iOSManager>();
        }
        return _instance;
    }

    public bool callOfCaptured()
    {
        return _DetectCaptured();
    }

    public bool callOfProtectingScreenCapture()
    {
        return detectScreenshot();
    }

    public void callOfDeleteScreenShot()
    {
        deleteScreenShot();
    }

    public void callOfPermission()
    {
        permissionPhoto();
    }

}
