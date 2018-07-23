//
//  Account.h
//  线程安全问题
//
//  Created by mac on 2018/7/23.
//  Copyright © 2018年 Gooou. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Account : NSObject
{
    double balance;
}
@property(nonatomic,copy)NSString *accountNo;
-(void)draw:(double)drawAmount;
-(void)draw2:(double)drawAmount;
-(void)draw3:(double)drawAmount;
-(void)deposit:(double)depositAmount;
@end
