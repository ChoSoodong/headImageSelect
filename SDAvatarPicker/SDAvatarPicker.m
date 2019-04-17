






#import "SDAvatarPicker.h"
#import "SDResourceSheetView.h"
#import "SDAuthorizationManager.h"

typedef void(^seletedImage)(UIImage *image);

@interface SDAvatarPicker ()<UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate,
                                SDResouceSheetViewDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) SDResourceSheetView *toolView;

@property (nonatomic, copy) seletedImage selectedImage;

@end

@implementation SDAvatarPicker

+ (void)avatarSelected:(void(^)(UIImage *image))compleiton {
      [[self new] startSelected:^(UIImage * _Nonnull image) {
        compleiton(image);
    }];
}


- (void)startSelected:(void (^)(UIImage * _Nonnull))compleiton {
    [self.toolView show];
    self.selectedImage = compleiton;
}


#pragma mark - <SDResouceSheetViewDelegate>

- (void)SDResourceSheetView:(SDResourceSheetView *)sheetView seletedMode:(ResourceMode)resourceMode {
    
    if (resourceMode == ResourceModeNone) {
        self.selectedImage ? self.selectedImage(nil) : nil;
        [self clean];
        return;
    }
    
    if (resourceMode == ResourceModeAlbum) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        __weak typeof(self) weakSelf = self;
        [SDAuthorizationManager checkAuthorization:SDAuthorizationTypePhotoLibrary firstRequestAccess:nil completion:^(BOOL isPermission) {
            if (isPermission) {
                [weakSelf presentToImagePicker];
            } else {
                [SDAuthorizationManager requestAuthorization:SDAuthorizationTypePhotoLibrary];
            }
        }];
  
    } else if (resourceMode == ResourceModeCamera) {
    
        //先判断相机是否可用
       BOOL isCameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (isCameraAvailable) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            
            __weak typeof(self) weakSelf = self;
            [SDAuthorizationManager checkAuthorization:SDAuthorizationTypeCamera firstRequestAccess:nil completion:^(BOOL isPermission) {
                if (isPermission) {
                    [weakSelf presentToImagePicker];
                } else {
                    [SDAuthorizationManager requestAuthorization:SDAuthorizationTypeCamera];
                }
            }];
        }else{
            NSLog(@"相机不可用!");
        }
        
        
    }
}


- (void)presentToImagePicker {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootVC = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        [rootVC presentViewController:self.imagePicker animated:YES completion:nil];
    });
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.selectedImage ? self.selectedImage(image) : nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self clean];
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.selectedImage ? self.selectedImage(nil) : nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self clean];
    }];
}


- (void)clean {
    self.toolView.delegate = nil;
    self.toolView = nil;
}


#pragma mark - getter

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}


- (SDResourceSheetView *)toolView {
    if (!_toolView) {
        _toolView = [SDResourceSheetView new];
        _toolView.delegate = self;
    }
    return _toolView;
}


- (void)dealloc {
    NSLog(@"picker dealloc");
}

@end
