//
//  Account.m
//  线程安全问题
//
//  Created by mac on 2018/7/23.
//  Copyright © 2018年 Gooou. All rights reserved.
//

#import "Account.h"
@interface Account()
{
    NSCondition *cond;
    BOOL flage;
}
@end

@implementation Account

- (instancetype)init
{
    self = [super init];
    if (self) {
        balance=1000;
        flage=true;
    }
    return self;
}
/*使用多线程来操作此方法，会造成错误结果*/
-(void)draw:(double)drawAmount{
    //账户余额大于取钱数目
    if (balance>=drawAmount) {
        //吐出钞票
        NSString *str=[NSString stringWithFormat:@"%@取钱%f成功",NSThread.currentThread.name,drawAmount];
        NSLog(@"%@", str);
        [NSThread sleepForTimeInterval:0.001];
        //修改余额
        balance-=drawAmount;
        NSLog(@"余额为%f",balance);
    }else{
        NSString *str=[NSString stringWithFormat:@"%@取钱失败，余额不足",NSThread.currentThread.name];
        NSLog(@"%@", str);
    }
}
/*修改之后的方法,一个线程进行操作，其他的线程就被挡在外面。*/
-(void)draw2:(double)drawAmount{
    //使用self作为同步监视器，在任何线程进入下面的同步代码块之前
    //必须先获得对self账户的锁定-其他线程无法获得锁，也就无法修改他
    //这种做法符合“加锁-修改-释放锁”的逻辑
    @synchronized(self){
        //账户余额大于取钱数目
        if (balance>=drawAmount) {
            //吐出钞票
            NSString *str=[NSString stringWithFormat:@"%@取钱%f成功",NSThread.currentThread.name,drawAmount];
            NSLog(@"%@", str);
            [NSThread sleepForTimeInterval:0.001];
            //修改余额
            balance-=drawAmount;
            NSLog(@"余额为%f",balance);
        }else{
            NSString *str=[NSString stringWithFormat:@"%@取钱失败，余额不足",NSThread.currentThread.name];
            NSLog(@"%@", str);
        }
    }
}
/*线程间通讯*/
-(void)draw3:(double)drawAmount{
    //加锁
    [cond lock];
    //如果flage为假，则表明账户中还没有人存钱进去，取钱方法阻塞。
    if (!flage) {
        [cond wait];
    }else{
        //吐出钞票
        NSLog(@"%@取钱成功！吐出钞票%g",[NSThread currentThread].name,drawAmount);
        [NSThread sleepForTimeInterval:0.001];
        //修改余额
        balance-=drawAmount;
        NSLog(@"余额为:%g",balance);
        flage=NO;//将标识账户是否已经有钱的旗帜设置为假
        //唤醒其他线程
        [cond broadcast];
    }
    //释放锁
    [cond unlock];
}
-(void)deposit:(double)depositAmount{
    //加锁
    [cond lock];
    //如果flage为真，则表明账户中已经有人存钱进去，存钱方法阻塞。
    if (flage) {
        [cond wait];
    }else{
        //执行存款操作
        NSLog(@"%@存款：%f",[NSThread currentThread].name,depositAmount);
        //修改余额
        balance+=depositAmount;
        NSLog(@"账户余额为:%f",balance);
        flage=YES;//将标识账户是否有钱的旗帜设置为真
        [cond broadcast];
    }
    //释放对cond的锁定
    [cond unlock];
}
@end
