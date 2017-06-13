//
//  ViewController.m
//  bookPublish
//
//  Created by duyong on 2017/5/29.
//  Copyright © 2017年 duyong. All rights reserved.
//

#import "ViewController.h"
#import "Singleton.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *serverAddr;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@end

@implementation ViewController
#if 0
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterButtonAction:(id)sender {
    
    // 1.创建一个网络路径
    
    NSString *paramUrl = nil;
    if([self.serverAddr.text isEqualToString:@""] == NO) {
        [Singleton sharedInstanceMethod].serverIpAddr = self.serverAddr.text;
        paramUrl = [NSString stringWithFormat:@"http://%@/",[Singleton sharedInstanceMethod].serverIpAddr];
    } else {
        [Singleton sharedInstanceMethod].serverIpAddr = @"http://192.168.103.101:8081";
        paramUrl = [NSString stringWithFormat:@"http://192.168.103.101:8081"];
    }
    

    //paramUrl = [paramUrl  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    paramUrl = [paramUrl  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //paramUrl = [paramUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:paramUrl];
    NSLog(@" request %@ origin %@",url,paramUrl);
    // 2.创建一个网络请求
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data) {
            /*
             对从服务器获取到的数据data进行相应的处理：
             */
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSLog(@"dict %@",dict);
            if(dict && [[dict objectForKey:@"result"]  isEqual: @"success"]) {
//                UIAlertController*alertController = [UIAlertController alertControllerWithTitle:@"提示框" message:@"发送成功" preferredStyle:UIAlertControllerStyleAlert];
//                
//                
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//                
//                [alertController addAction:okAction];
                
//                ViewSearchController * viewController = [[ViewSearchController alloc] init];
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self presentViewController: viewController animated:YES completion:nil];
//                });
                //[self presentViewController: viewController animated:YES completion:nil];
                ViewSearchController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"searchController"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:view animated:YES completion:nil];
                });
                
            } else {
                
                UIAlertController*alertController = [UIAlertController alertControllerWithTitle:@"提示框"message:@"连接服务器失败" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                
                [alertController addAction:okAction];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alertController animated:YES completion:nil];});
            }
            
            
        }
        
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];    // 启动任务

}

@end
