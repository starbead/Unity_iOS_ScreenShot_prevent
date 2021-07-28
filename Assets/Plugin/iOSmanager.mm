#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface iOSmanager : NSObject
@end
static bool isCapture = false;
static int countNum = 0;
@implementation iOSmanager

+(bool)detectScreenshot{
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil queue:mainQueue usingBlock:^(NSNotification *notification){
        isCapture = true;
     }];
    
    return isCapture;
}

+(void)deleteScreenShot{
    countNum = 0;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    [fetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            BOOL req = [obj canPerformEditOperation:PHAssetEditOperationDelete];
            if(req){
                if(countNum == 0){
                    [PHAssetChangeRequest deleteAssets:@[obj]];
                    countNum++;
                }
            }
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(success){
                isCapture = false;
            }
            else{
                exit(0);
            }
        }];
    }];
}

+(void)permissionPhoto{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            // Access has not been determined.
            
            __block PHAuthorizationStatus authorized;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                authorized = status;
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
                if (authorized == PHAuthorizationStatusAuthorized) {
                    NSLog(@"Autorized");
                }else {
                    NSLog(@"Not Autorized");
                    
                    // Access has been denied.
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Need Photo Permission"
                                                                                   message:@"Using this app need photo permission, do you want to turn on it?"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          NSURL *settingsUrl = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
                                                                          [[UIApplication sharedApplication] openURL:settingsUrl];
                                                                      }];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * action) {
                                                                     }];
                    [alert addAction:yesAction];
                    [alert addAction:noAction];
                    [UnityGetGLViewController() presentViewController:alert animated:YES completion:nil];

                }

        }
}

+(bool)detectCapture{
    if (UIScreen.mainScreen.isCaptured)
    {
        return true;
    }
    else
    {
        return false;
    }
}

@end
extern "C"{

    bool _DetectCaptured()
    {
        return [iOSmanager detectCapture];
    }

    bool detectScreenshot(){
        return [iOSmanager detectScreenshot];
    }

    void deleteScreenShot(){
        [iOSmanager deleteScreenShot];
    }
    
    void permissionPhoto(){
        [iOSmanager permissionPhoto];
    }
}
