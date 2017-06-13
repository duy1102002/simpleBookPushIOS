//
//  ViewSearch.m
//  bookPublish
//
//  Created by duyong on 2017/5/29.
//  Copyright © 2017年 duyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewSearchController.h"
#import "Singleton.h"

@interface ViewSearchController ()
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *searchRequest;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong,nonatomic) NSDictionary *bookList;
@end

@implementation ViewSearchController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.bookList = [[NSDictionary alloc] initWithObjectsAndKeys:@"result", @"",nil];
}

- (IBAction)searchRequest:(id)sender {
    if(self.searchText.text == nil) {
        return;
    }
    // 1.创建一个网络路径


    NSString *paramUrl = [NSString stringWithFormat:@"http://%@/find?{\"search\":\"%@\"}",[Singleton sharedInstanceMethod].serverIpAddr,self.searchText.text];
    
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
        NSLog(@"从服务器获取到数据 %@",data);
        if(data) {
        /*
         对从服务器获取到的数据data进行相应的处理：
         */
               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSLog(@"dict %@",dict);
        self.bookList = [[NSDictionary alloc] initWithDictionary:dict];
        }
        [self.tableView reloadData];
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];    // 启动任务

}

#pragma mark UITableViewDataSource 协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection %lu",[[self.bookList objectForKey:@"result" ] count]);
    return [[self.bookList objectForKey:@"result" ] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *rowDict = self.bookList;
    
    NSArray *rowArray = [rowDict objectForKey:@"result"];
    
    cell.textLabel.text = [rowArray objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSLog(@"text %@",cell.textLabel.text);
        return cell;
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

}





- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"good");
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"推送";//向左滑动显示的文字
}

// 设置编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [[self.bookList objectForKey:@"result" ] count]) {
        return FALSE;
    } else {
        return TRUE;
    }
}

// 这个方法用来告诉表格 这一行是否可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark 在滑动手势删除某一行的时候，显示出更多的按钮
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 添加一个删除按钮
    NSLog(@"editActionsForRowAtIndexPath");
    UITableViewRowAction *enterRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"确定" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了确定");
        // 1.创建一个网络路径
        
        
         NSString *paramUrl = [NSString stringWithFormat:@"http://%@/sendmail?{\"bookName\":\"%@\"}",[Singleton sharedInstanceMethod].serverIpAddr,[[self.bookList objectForKey:@"result" ] objectAtIndex:indexPath.row]];
        
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
            NSLog(@"从服务器获取到数据 %@",data);
            /*
             对从服务器获取到的数据data进行相应的处理：
             */
            if(data) {
                /*
                 对从服务器获取到的数据data进行相应的处理：
                 */
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                NSLog(@"dict %@",dict);
                if(dict && [[dict objectForKey:@"result"]  isEqual: @"success"]) {
                    UIAlertController*alertController = [UIAlertController alertControllerWithTitle:@"提示框" message:@"发送成功" preferredStyle:UIAlertControllerStyleAlert];
                    
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                    
                    [alertController addAction:okAction];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:alertController animated:YES completion:nil];});

                } else {
                
                UIAlertController*alertController = [UIAlertController alertControllerWithTitle:@"提示框"message:@"发送失败" preferredStyle:UIAlertControllerStyleAlert];
           
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
 
                [alertController addAction:okAction];
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:alertController animated:YES completion:nil];});
                    

                }
                

                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            
        }];
        // 5.最后一步，执行任务（resume也是继续执行）:
        [sessionDataTask resume];    // 启动任务
//        // 1. 更新数据
//        [[self.bookList objectForKey:@"result" ] removeObjectAtIndex:indexPath.row];
//        // 2. 更新UI
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    // 将设置好的按钮放到数组中返回
    //[self.tableView reloadData];
    return @[enterRowAction];
}

- (NSString *)toJSONString:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    str = [NSString stringWithFormat:@"%@",str];
    return str;
}

@end

