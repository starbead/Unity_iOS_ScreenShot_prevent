using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIBinding : MonoBehaviour
{
    public GameObject whitescreen;
    public GameObject blackscreen;
    public GameObject normalscreen;
    public Button _ondelete;

    void Awake()
    {
        iOSManager.GetInstance().callOfPermission();
    }
    // Start is called before the first frame update
    void Start()
    {
        normalscreen.SetActive(true);
        blackscreen.SetActive(false);
        whitescreen.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {

#if UNITY_IOS

        if (iOSManager.GetInstance().callOfCaptured())
        {
            whitescreen.SetActive(true);
            normalscreen.SetActive(false);
        }
        else
        {
            normalscreen.SetActive(true);
            whitescreen.SetActive(false);
        }
        if (iOSManager.GetInstance().callOfProtectingScreenCapture())
        {
            blackscreen.SetActive(true);
            normalscreen.SetActive(false);
        }
        
#endif
    }

    public void OnClickDelete()
    {
#if UNITY_IOS
        iOSManager.GetInstance().callOfDeleteScreenShot();
        normalscreen.SetActive(true);
        blackscreen.SetActive(false);
#endif
    }

}
