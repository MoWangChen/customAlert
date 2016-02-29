//
//  MrLoadingView.h
//  MrLoadingView
//
//  Created by ChenHao on 2/11/15.
//  Copyright (c) 2015 xxTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHAlertViewConst.h"
#import "UIView+Draw.h"

@protocol HHAlertViewDelegate;

/*
 * the style of the logo view
 */
typedef NS_ENUM(NSInteger, HHAlertViewMode){
    HHAlertViewModeSuccess,
    HHAlertViewModeError,
    HHAlertViewModeWarning,
    HHAlertViewModeInfo,
    HHAlertViewModeDefault,
    HHAlertViewModeCustom
};

typedef NS_ENUM(NSInteger, HHAlertEnterMode){
    HHAlertEnterModeFadeIn,
    HHAlertEnterModeTop,
    HHAlertEnterModeBottom,
    HHAlertEnterModeLeft,
    HHAlertEnterModeRight,
};

typedef NS_ENUM(NSInteger, HHAlertLeaveMode){
    HHAlertLeaveModeFadeOut,
    HHAlertLeaveModeTop,
    HHAlertLeaveModeBottom,
    HHAlertLeaveModeLeft,
    HHAlertLeaveModeRight,
    
};
#if NS_BLOCKS_AVAILABLE

/**
 *  the block to tell user whitch button is clicked
 *
 *  @param button button
 */
typedef void (^selectButtonIndexComplete)(NSInteger index);

#endif

@interface HHAlertView : UIView


/**
 *  show a alert view with title detailTitle and at least one button
 *
 *  @param title              titleString
 *  @param detailtext         detailStrng
 *  @param superView          the view that alertview will show
 *  @param cancelButtonTitle  cancel button's title
 *  @param otherButtonsTitles ohter button's titles
 *
 *  @return instance of alertview
 */
- (instancetype)initWithTitle:(NSString *)title
                   detailText:(NSString *)detailtext
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray  *)otherButtonsTitles;


/**
 *  dismiss the alertview
 */
- (void)hide;


/**
 *  show the alertview
 */
- (void)show;

#if NS_BLOCKS_AVAILABLE
/**
 *  show method with block to konw which button clicked
 *
 *  @param completeBlock
 */
- (void)showWithBlock:(selectButtonIndexComplete)completeBlock;

#endif

@property (nonatomic, weak)   id<HHAlertViewDelegate> delegate;

#if NS_BLOCKS_AVAILABLE

@property (nonatomic, copy)   selectButtonIndexComplete completeBlock;

#endif


/**
 *  HHAlertView style mode
 */
@property (nonatomic, assign) HHAlertViewMode mode;

@property (nonatomic, assign) HHAlertEnterMode enterMode;

@property (nonatomic, assign) HHAlertLeaveMode leaveMode;

/**
 * An optional short message to be displayed on the title label.
 * the entire text. If the text is too long it will get clipped by displaying "..." at the end.
 * set to @"", then no message is displayed.
 */
@property (nonatomic, copy)   NSString *titleText;

/**
 * An optional details message displayed below the titleText message.
 * property is also set and is different from an empty string (@""). The details text can span multiple lines.
 */
@property (nonatomic, copy)   NSString *detailText;

/**
 * The UIView (e.g., a UIImageView) to be shown when the AlertView is in HHAlertViewModeCustom.
 * For best results use a 60 by 60 pixel view.
 *
 */
@property (nonatomic, strong) UIView *customView;

/**
 * The x-axis offset of the AlertView relative to the centre of the superview.
 */
@property (nonatomic, assign) CGFloat xOffset;

/**
 * The y-axis offset of the AlertView relative to the centre of the superview.
 */
@property (nonatomic, assign) CGFloat yOffset;

/**
 *  the radius of the alertview
 *  default value is 5.0
 */
@property (nonatomic, assign) CGFloat radius;

/**
 * An optional short message to be displayed on the cancel button.
 * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
 * set to nil if have no cancel buttons.
 */
@property (nonatomic, copy)   NSString  *cancelButtonTitle;

/**
 *  An array of String of button's title
 *  set to nil if have no other buttons
 */
@property (nonatomic, strong) NSArray   *otherButtonTitles;

/**
 * Removes the HUD from its parent view when hidden.
 * Defaults to YES.
 */
@property (nonatomic, assign) BOOL removeFromSuperViewOnHide;

@end



@protocol HHAlertViewDelegate <NSObject>

@optional
/**
 *  the delegate to tell user whitch button is clicked
 *
 *  @param button button
 */
- (void)HHAlertView:(HHAlertView *)alertview didClickButtonAnIndex:(NSInteger )buttonIndex;

@end

