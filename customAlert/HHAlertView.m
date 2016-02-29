//
//  MrLoadingView.m
//  MrLoadingView
//
//  Created by ChenHao on 2/11/15.
//  Copyright (c) 2015 xxTeam. All rights reserved.
//

#import "HHAlertView.h"


#define OKBUTTON_BACKGROUND_COLOR [UIColor colorWithRed:158/255.0 green:214/255.0 blue:243/255.0 alpha:1]
#define CANCELBUTTON_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:20/255.0 blue:20/255.0 alpha:1]


@interface HHAlertView()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *detailLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSArray  *otherButtons;

@property (nonatomic, strong) UIView   *logoView;
@property (nonatomic, strong) UIView   *maskView;
@property (nonatomic, strong) UIView   *mainAlertView; //main alert view

@property (nonatomic, strong) UIView *horizonLine;
@property (nonatomic, strong) UIView *verticalLine;

@end


@implementation HHAlertView

#pragma mark Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.xOffset = 0.0;
        self.yOffset = 0.0;
        self.radius  = KDefaultRadius;
        self.mode = HHAlertViewModeDefault;
        self.alpha   = 0.0;
        self.removeFromSuperViewOnHide = YES;
        [self registerKVC];
        
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
                   detailText:(NSString *)detailtext
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonsTitles {
    
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.titleText = title;
        self.detailText = detailtext;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = otherButtonsTitles;
        [self layout];
        
    }
    return self;
}


#pragma mark UI

- (void)addView {
    [self addSubview:self.maskView];
    [self addSubview:self.mainAlertView];
    
    [self.mainAlertView addSubview:self.logoView];
    [self.mainAlertView addSubview:self.titleLabel];
    [self.mainAlertView addSubview:self.detailLabel];
    [self.mainAlertView addSubview:self.horizonLine];
    [self.mainAlertView addSubview:self.verticalLine];
}

- (void)updateModeStyle {
    if(self.mode == HHAlertViewModeCustom){
    
        if (self.customView) {
            [self.logoView hh_drawCustomeView:self.customView];
            
        }
        [self.cancelButton setTitleColor:SUCCESS_COLOR forState:UIControlStateNormal];
        for (UIButton *button in self.otherButtons) {
            [button setTitleColor:SUCCESS_COLOR forState:UIControlStateNormal];
        }
        
    }
}

- (void)setupLabel {
    [self.titleLabel setText:self.titleText];
    [self.titleLabel sizeToFit];
    [self.detailLabel setText:self.detailText];
    [self.detailLabel setTextColor:[UIColor grayColor]];
    [self.detailLabel setFont:[UIFont systemFontOfSize:14]];
    [self.detailLabel setNumberOfLines:0];
    
    [self.horizonLine setBackgroundColor:[UIColor blackColor]];
    [self.verticalLine setBackgroundColor:[UIColor blackColor]];
}

- (void)setupButton {
    if (self.cancelButtonTitle == nil && self.otherButtonTitles ==nil) {
        NSAssert(NO, @"error");
    }
    
    if (self.cancelButtonTitle != nil) {
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [self.cancelButton setTag:KbuttonTag];
        [self.cancelButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainAlertView addSubview:self.cancelButton];
    }
    
    if (self.otherButtonTitles != nil) {
        NSMutableArray *tempButtonArray = [[NSMutableArray alloc] init];
        NSInteger i = 1;
        for (NSString *title in self.otherButtonTitles) {
            
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTag:KbuttonTag + i];
            [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [tempButtonArray addObject:button];
            [self.mainAlertView addSubview:button];
            i++;
        }
        self.otherButtons = [tempButtonArray copy];
    }
}

#pragma mark Layout

- (void)layout {
    [self addView];
    [self setupLabel];
    [self setupButton];
    [self updateModeStyle];
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIView *window = [windows objectAtIndex:0];
    [window addSubview:self];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.mainAlertView setBackgroundColor:[UIColor whiteColor]];
    [[self.mainAlertView layer] setCornerRadius:self.radius];
    [self.mainAlertView setAlpha:0.8];
    
    //logoView frame
    CGPoint logoCenter =  CGPointMake(130, 85);
    [self.logoView setCenter:logoCenter];
    
    //titleLabel frame
    CGPoint titleCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, 25);
    [self.titleLabel setCenter:titleCenter];
    
    //detailLabel frame
    [self.detailLabel setFrame:CGRectMake(0, 0, CGRectGetWidth(self.mainAlertView.frame)-KHHAlertView_Padding*2, 0)];
    [self.detailLabel sizeToFit];
    
    CGPoint detailCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, 10+CGRectGetHeight(self.detailLabel.frame)/2 + CGRectGetMaxY(self.logoView.frame));
    [self.detailLabel setCenter:detailCenter];
    
    [self.horizonLine setFrame:CGRectMake(0, 250, CGRectGetWidth(self.mainAlertView.frame), 1)];
    
    [self.verticalLine setFrame:CGRectMake(CGRectGetWidth(self.mainAlertView.frame)/2, 250, 1, 50)];
    
    
    
    if (self.cancelButtonTitle != nil && [self.otherButtonTitles count]==1) {
        CGRect buttonFrame = CGRectMake(0, 0, 130, 50);
        [self.cancelButton setFrame:buttonFrame];
        
        CGPoint leftButtonCenter = CGPointMake(65, 275);
        [self.cancelButton setCenter:leftButtonCenter];
        
        UIButton *rightButton = (UIButton *)self.otherButtons[0];
        [rightButton setFrame:buttonFrame];
        
        CGPoint rightButtonCenter = CGPointMake(195,275);
        [rightButton setCenter:rightButtonCenter];
        
    }
}

#pragma mark Event Response

- (void)buttonTouch:(UIButton *)button {
    if (self.completeBlock) {
        self.completeBlock(button.tag - KbuttonTag);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HHAlertView:didClickButtonAnIndex:)]) {
        [self.delegate HHAlertView:self didClickButtonAnIndex:button.tag - KbuttonTag];
    }
    [self hide];
}


#pragma mark show & hide 

- (void)show {
    NSTimeInterval interval = 0.3;
    CGRect frame = self.mainAlertView.frame;
    if (self.enterMode) {
        switch (self.enterMode) {
            case HHAlertEnterModeTop:
            {
                frame.origin.y -= CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case HHAlertEnterModeBottom:
            {
                frame.origin.y += CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case HHAlertEnterModeLeft:
            {
                frame.origin.x -= CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case HHAlertEnterModeRight:
            {
                frame.origin.x += CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case HHAlertEnterModeFadeIn:
            {
           
            }
                break;
            
            default:
                break;
        }
    }
    [self.mainAlertView setFrame:frame];
    [UIView animateWithDuration:interval animations:^{
        [self setAlpha:1];
        [self.mainAlertView setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showWithBlock:(selectButtonIndexComplete)completeBlock {
    self.completeBlock = completeBlock;
    [self show];
}

- (void)hide {
    NSTimeInterval interval = 0.3;
    CGRect frame = self.mainAlertView.frame;
    if (self.leaveMode) {
        switch (self.leaveMode) {
            case HHAlertLeaveModeTop:
            {
                frame.origin.y -= CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case HHAlertLeaveModeBottom:
            {
                frame.origin.y += CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case HHAlertLeaveModeLeft:
            {
                frame.origin.y -= CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case HHAlertLeaveModeRight:
            {
                frame.origin.x += CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case HHAlertLeaveModeFadeOut:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
 
    [UIView animateWithDuration:interval animations:^{
        [self setAlpha:0];
        [self.mainAlertView setFrame:frame];
    } completion:^(BOOL finished) {
        if (self.removeFromSuperViewOnHide) {
            [self removeFromSuperview];
        }
        [self unregisterKVC];
    }];
}

#pragma mark KVC

- (void)registerKVC {
    for (NSString *keypath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keypath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)unregisterKVC {
    for (NSString *keypath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keypath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"mode",@"customView", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    }
    else{
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keypath {
    if ([keypath isEqualToString:@"mode"] || [keypath isEqualToString:@"customView"]) {
        [self updateModeStyle];
    }
}

#pragma mark getter and setter

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        [_maskView setBackgroundColor:[UIColor blackColor]];
        [_maskView setAlpha:0.2];
    }
    return _maskView;
}

- (UIView *)mainAlertView {
    if (!_mainAlertView) {
        _mainAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KHHAlertView_Width, KHHAlertView_Height)];
        [_mainAlertView setCenter:self.center];
    }
    return _mainAlertView;
}

- (UIView *)logoView {
    if (!_logoView) {
        _logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KLogoView_Size, KLogoView_Size)];
    }
    return _logoView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
    }
    return _detailLabel;
}

-(UIView *)horizonLine
{
    if (!_horizonLine) {
        _horizonLine = [[UIView alloc] init];
    }
    return _horizonLine;
}

-(UIView *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
    }
    return _verticalLine;
}

@end
