






#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ResourceMode) {
    ResourceModeNone   =  0,   // 取消选择
    ResourceModeCamera,
    ResourceModeAlbum
};

@class SDResourceSheetView;

@protocol SDResouceSheetViewDelegate<NSObject>

- (void)SDResourceSheetView:(SDResourceSheetView *)sheetView
                 seletedMode:(ResourceMode)resourceMode;
@end

@interface SDResourceSheetView : UIView

// 持有强引用，调用接收后，手动置为空，不然 SDAvatarPicker 会提前释放
@property (nonatomic, strong, nullable) id<SDResouceSheetViewDelegate> delegate;

- (void)show;

@end

NS_ASSUME_NONNULL_END
