//
//  SelectObjectViewController.h
//  bameng
//
//  Created by 刘琛 on 16/10/31.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectObjectDelegate <NSObject>

@optional

- (void)selectMengYou:(NSString *) mengYouId andName:(NSString *)names;

@end


@interface SelectObjectViewController : MyViewController

@property (retain, nonatomic) id <SelectObjectDelegate>delegate;


/**1 现金券  2 上传凭证*/
@property (nonatomic,assign) int type;
@end
