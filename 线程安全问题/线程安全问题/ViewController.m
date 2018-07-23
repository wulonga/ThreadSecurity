//
//  ViewController.m
//  线程安全问题
//
//  Created by mac on 2018/7/23.
//  Copyright © 2018年 Gooou. All rights reserved.
//

#import "ViewController.h"
#import "Account.h"

@interface ViewController ()
@property(nonatomic,strong)Account *account;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Account *account=[[Account alloc]init];
    account.accountNo=@"321456";
    self.account=account;
    [self draw];
}
//-(void)drawMethod{
//    [self.account draw2:800.0];
//}
-(void)draw{
    //创建两个线程进行模拟取款操作
//    NSThread *thread1=[[NSThread alloc]initWithTarget:self selector:@selector(drawMethod) object:nil];
//    thread1.name=@"甲";
//
//    NSThread *thread2=[[NSThread alloc]initWithTarget:self selector:@selector(drawMethod) object:nil];
//    thread2.name=@"乙";
//    [thread1 start];
//    [thread2 start];
    //创建三个线程进行存钱
    NSThread *thread1=[[NSThread alloc]initWithTarget:self selector:@selector(depositMethod) object:nil];
    NSThread *thread2=[[NSThread alloc]initWithTarget:self selector:@selector(depositMethod) object:nil];
    NSThread *thread3=[[NSThread alloc]initWithTarget:self selector:@selector(depositMethod) object:nil];
    NSThread *thread4=[[NSThread alloc]initWithTarget:self selector:@selector(drawMethod) object:nil];
    [thread1 start];
    [thread2 start];
    [thread3 start];
    [thread4 start];
   
}
-(void)drawMethod{
    NSThread.currentThread.name=@"乙";
    for (int i=0; i<100; i++) {
        [self.account draw3:800.0];
    }
}
-(void)depositMethod{
    NSThread.currentThread.name=@"甲";
    for (int i=0; i<100; i++) {
        [self.account deposit:800.0];
    }
}
@end
