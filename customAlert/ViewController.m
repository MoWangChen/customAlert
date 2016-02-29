//
//  ViewController.m
//  customAlert
//
//  Created by 谢鹏翔 on 15/12/30.
//  Copyright © 2015年 谢鹏翔. All rights reserved.
//

#import "ViewController.h"
#import "HHAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self onCheckVersion];
    
}
- (IBAction)update:(id)sender {
    
//    HHAlertView *alertview = [[HHAlertView alloc] initWithTitle:@"软件更新提示" detailText:@"版本不息，优化不止。爱下厨V2.0给您全新体验。新增多款设备，大幅优化与设备的交互性能" cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即更新"]];
//    alertview.mode = HHAlertViewModeCustom;
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contentview_image-cartton"]];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    
//    [alertview setCustomView:imageView];
//    [alertview show];
    
    [self onCheckVersion];
}

-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *URL = @"http://itunes.apple.com/lookup?id=929607381";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData options:0 error:nil];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            
            HHAlertView *alertview = [[HHAlertView alloc] initWithTitle:@"软件更新提示" detailText:@"版本不息，优化不止。爱下厨V2.0给您全新体验。新增多款设备，大幅优化与设备的交互性能" cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即更新"]];
            alertview.mode = HHAlertViewModeCustom;
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contentview_image-cartton"]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [alertview setCustomView:imageView];
//            [alertview show];
            [alertview showWithBlock:^(NSInteger index) {
                if (index == 1) {
                    NSRange range = {0,5};
                    NSString *trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
                    trackViewURL = [trackViewURL stringByReplacingCharactersInRange:range withString:@"itms-apps"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewURL]];
                }
            }];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}

@end
