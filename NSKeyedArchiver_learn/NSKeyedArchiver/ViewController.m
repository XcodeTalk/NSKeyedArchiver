//
//  ViewController.m
//  NSKeyedArchiver_归档
//
//  Created by 王斌 on 15/9/17.
//  Copyright (c) 2015年 Changhong electric Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "CHStudent.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     归档（又名序列化），把对象转为字节码，以文件的形式存储到磁盘上；程序运行过程中或者当再次重写打开程序的时候，可以通过解归档（反序列化）还原这些对象。
     
     归档方式：
     对Foundation框架中对象进行归档
     对自定义的内容进行归档
     对自定义的对象进行归档
     */
    
    // ------------  一、对Foundation框架中对象进行归档  -------------
    //获取文档路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"file.archive"];
    
    //归档（序列化）到指定路径
    NSArray *archiveAry = @[@"first",@"ios"];
    if ([NSKeyedArchiver archiveRootObject: archiveAry toFile:filePath]) {
        NSLog(@"Archiver  success");
    }
    
    //解归档（反序列化）
    NSArray *unArchiveAry = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"%@",unArchiveAry);
    
    
    //归档为NSData
    NSArray *archiveAry2 = @[@"second",@"ios"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:archiveAry2];
    //从NSData解档
    NSArray *unarchiveArray2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@",unarchiveArray2);
    
    /*
     小结：
     归档和解归档操作步骤简单
     再次对同一个文件归档，会覆盖数据
     一次只能归档一个对象，如果是多个对象归档需要分开进行
     归档的对象是Foundation框架中的对象
     归档和解归档其中任意对象都需要归档和解归档整个文件
     归档后的文件是加密的，所以归档文件的扩展名可以随意取
     */
    
    //----------- 二、对自定义的数据内容进行归档 ------------
    //获得文件路径
    NSString *secondFilePath = [documentsPath stringByAppendingPathComponent:@"secondFile.archive"];
    //1、使用NSData存放归档数据
    NSMutableData *archiveData = [NSMutableData data];
    //2、创建归档对象
    NSKeyedArchiver *myArchiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:archiveData];
    //3、添加归档内容（设置键值对）
    [myArchiver encodeObject:@"Wangbin" forKey:@"name"];
    [myArchiver encodeInt:22 forKey:@"age"];
    [myArchiver encodeObject:@[@"Objective-C", @"iOS"] forKey:@"language"];
    //4、完成归档
    [myArchiver finishEncoding];
    //5、将归档的数据存储到磁盘上
    if ([archiveData writeToFile:secondFilePath atomically:YES]) {
        NSLog(@"Archive and write to file success");
    }
    
    //解归档
    //1、从磁盘读取文件，生成NSData实例
    NSData *unArchiverData = [NSData dataWithContentsOfFile:secondFilePath];
    //2、根据data实例创建和初始化解归档对象
    NSKeyedUnarchiver *myUnarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:unArchiverData];
    //3、解归档，根据key值访问
    NSString *name = [myUnarchiver decodeObjectForKey:@"name"];
    int age = [myUnarchiver decodeIntForKey:@"age"];
    NSArray *array = [myUnarchiver decodeObjectForKey:@"language"];
    NSLog(@"name = %@ age = %d language = %@", name, age, array);
    
    /*
     小结：
     在带键的归档中，每个归档字段都有一个key值，解归档时key值要与归档时key值匹配
     带键归档可以一次存储多个对象
     归档的对象是Foundation框架中的对象
     归档和解归档其中任意对象都需要归档和解归档整个文件
     归档后的文件是加密的，所以归档文件的扩展名可以随意取
     */
    
    
    
    // --------------  三、 对自定义的对象进行归档  -----------
    /*
     *  当我们对自己定义的对象进行“编码/解码”操作时，
     *  却需要实现NSCoding协议的两个方法(encodeWithCoder: , initWithCoder:)来告诉程序
     *  该如何来“编码/解码”我们自己的对象！
     */
    //获得文件路径
    NSString *thirdFilePath = [documentsPath stringByAppendingPathComponent:@"thirdFile.archive"];
    
    //将自定义对象 归档（序列化）到指定路径
    CHStudent *xiaoMing = [[CHStudent alloc]init];
    xiaoMing.name = @"xiaoMing";
    xiaoMing.age = 12;
    xiaoMing.score = 95;
    if ([NSKeyedArchiver archiveRootObject: xiaoMing toFile:thirdFilePath]) {
        NSLog(@"Archiver customizing objects success");
    }
    
    //解归档（反序列化）
    CHStudent *unArchiverXiaoMing = [NSKeyedUnarchiver unarchiveObjectWithFile:thirdFilePath];
    NSLog(@"name:%@  age:%ld  score:%ld",unArchiverXiaoMing.name, unArchiverXiaoMing.age, unArchiverXiaoMing.score);
    
    /**
     小结：
     自定义对象与自定义内容归档和解归档步骤和用法完全相同
     自定义的对象归档需要实现NSCoding协议，并且实现协议中的方法
     NSCoding协议中有两个方法：
     　　encodeWithCoder方法 对对象属性进行编码，在对象归档时调用
     　　initWithCoder方法 解码归档数据来初始化对象，在对象解归档时调用
     */
    
    //路径
    NSString *fourthFilePath = [documentsPath stringByAppendingPathComponent:@"fourthFile.archive"];
    //数据
    NSArray *secondArray = @[xiaoMing, @"string"];
    //归档 存储
    if ([NSKeyedArchiver archiveRootObject:secondArray toFile:fourthFilePath]) {
        NSLog(@"archive success");
    }
    //解归档
    NSArray *unArchiveArray4 = [NSKeyedUnarchiver unarchiveObjectWithFile:fourthFilePath];
    CHStudent *unarchiveStudent = [unArchiveArray4 objectAtIndex:0];
    NSLog(@"%@",unArchiveArray4);
    NSLog(@"name:%@  age:%ld  score:%ld",unarchiveStudent.name, unarchiveStudent.age, unarchiveStudent.score);
    
    /*
     从上面可以看出，归档需要注意的是：
     1.同一个对象属性，编码/解码的key要相同！
     2.每一种基本数据类型，都有一个相应的编码/解码方法。
     如：encodeObject方法与decodeObjectForKey方法，是成对出现的。
     3.如果一个自定义的类A，作为另一个自定义类B的一个属性存在；
     那么，如果要对B进行归档，那么，B要实现NSCoding协议。并且，A也要实现NSCoding协议
     */
    
    /*
     -----------   总结： ---------------
     
     1、归档和解归档可以用于少量数据的持久化存储和读取
     2、plist只能存储Foundation框架中的对象，归档除了可以归档Foundation框架中的对象以外，
     还可以归档实现了NSCoding协议的自定义对象
     3、通过归档创建的文件是加密的
     */
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
