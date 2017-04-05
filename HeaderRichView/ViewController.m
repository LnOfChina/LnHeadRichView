//
//  ViewController.m
//  HeaderRichView
//
//  Created by LeMo-test on 2017/4/5.
//  Copyright © 2017年 LN. All rights reserved.
//

#import "ViewController.h"
#import "CustomRichImgView.h"
#import "UIView+Extension.h"
#import "QueryValue.h"
#import "ZLPhoto.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZLPhotoPickerViewControllerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

{
    NSInteger imgCount;
    
    NSInteger insertIndex;
}
@property(nonatomic,strong)UITextView *contentTextView;

@property (nonatomic,strong)UIButton    *addImgBtn;

@property (nonatomic,strong)NSMutableArray  *totalImgArray;

@property(nonatomic,strong)UITableView *rootTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.rootTableView];
    [self.view addSubview:self.addImgBtn];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapGesture];
}
-(void)tapAction
{
    [self.view endEditing:YES];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalImgArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //    cell.contentView.userInteractionEnabled = NO;
    CustomRichImgView *richImg = (CustomRichImgView *)self.totalImgArray[indexPath.row];
    
    richImg.deleteBtn.tag = indexPath.row+111;
    [richImg.deleteBtn addTarget:self action:@selector(deleImgAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    richImg.bottomImgTextView.tag = indexPath.row+111;
    richImg.bottomImgTextView.delegate = self;
    richImg.textViewHeight = richImg.bottomImgTextView.bounds.size.height;
    [richImg bringSubviewToFront:richImg.bottomImgTextView];
    richImg.userInteractionEnabled = YES;
    //    NSLog(@"textView的高度----%f-------%ld-------%f",richImg.bottomImgTextView.height,indexPath.row,richImg.viewHeight);
    [cell.contentView addSubview:richImg];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    cell.contentView.userInteractionEnabled = YES;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"点击的行数    %ld",indexPath.row);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.contentTextView.bounds.size.height))];
    [headerView addSubview:self.contentTextView];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.contentTextView.bounds.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomRichImgView *richImg = (CustomRichImgView *)self.totalImgArray[indexPath.row];
    //    NSLog(@"-行高-----%f----%ld",richImg.viewHeight,indexPath.row);
    return richImg.viewHeight;
}

#pragma mark 删除图片的操作
-(void)deleImgAction:(UIButton *)sender
{
    
    imgCount-=1;
    CustomRichImgView *richImg = (CustomRichImgView *)self.totalImgArray[sender.tag-111];
    if (richImg.bottomImgTextView.text.length==0) {
        [self.totalImgArray removeObjectAtIndex:sender.tag-111];
    }
    else
    {
        [richImg.mainImgView removeFromSuperview];
        richImg.height = richImg.bottomImgTextView.bounds.size.height;
        richImg.mainImgView.height =0;
        richImg.bottomImgTextView.y= 0;
        richImg.viewHeight = richImg.bottomImgTextView.height;
        [self.totalImgArray replaceObjectAtIndex:sender.tag-111 withObject:richImg];
    }
    [self.rootTableView reloadData];
    
}

#pragma  mark - 打开相机和图库事件

//拍照完毕触发方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //选择完成 --> 判断选择完的资源是image还是media
    NSString *str = [info objectForKey:UIImagePickerControllerMediaType];
    if ([str isEqualToString:(NSString *)kUTTypeImage]) {
        //如果取到的资源是image --> 把image显示在_photoIv上
        //UIImagePickerControllerEditedImage:编辑后的照片
        //UIImagePickerControllerOriginalImage:原图
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self dismissViewControllerAnimated:YES completion:nil];
        /**
         *  图片的对象
         */
        NSData*imageData;
        UIImage *imagenew ;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            imagenew = [QueryValue imageWithImageSimple:image targetWidth:800];
            imageData = UIImagePNGRepresentation(imagenew);
        }else {
            //返回为JPEG图像。
            imagenew = [QueryValue imageWithImageSimple:image targetWidth:800];
            imageData = UIImageJPEGRepresentation(imagenew, 0.3);
        }
        
        CustomRichImgView *richView = [[CustomRichImgView alloc]initWithFrame:(CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, [self getImgHeightWithImg:imagenew]+40))];
        richView.mainImgView.image = imagenew;
        richView.mainImgView.height =[self getImgHeightWithImg:imagenew];
        richView.viewHeight = [self getImgHeightWithImg:imagenew]+40;
        richView.bottomImgTextView.y = [self getImgHeightWithImg:imagenew];
        
        [self.totalImgArray insertObject:richView atIndex:insertIndex];
        [self.rootTableView reloadData];
        
        imgCount+=1;
        
    }
}

//从相册选择多张图片返回触发方法
-(void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    //    NSMutableArray *temp =[[NSMutableArray alloc] init];
    for (ZLPhotoAssets * asset in assets) {
        NSData*imageData;
        UIImage * image = asset.originImage;
        UIImage *imagenew;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            imagenew= [QueryValue imageWithImageSimple:image targetWidth:800];
            imageData = UIImagePNGRepresentation(imagenew);
        }else {
            //返回为JPEG图像。
            imagenew = [QueryValue imageWithImageSimple:image targetWidth:800];
            imageData = UIImageJPEGRepresentation(imagenew, 0.3);
        }
        
        //        [self sendImageMessageWithData:imageData];
        
        CustomRichImgView *richView = [[CustomRichImgView alloc]initWithFrame:(CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, [self getImgHeightWithImg:imagenew]+40))];
        richView.mainImgView.image = imagenew;
        richView.mainImgView.height =[self getImgHeightWithImg:imagenew];
        richView.viewHeight = [self getImgHeightWithImg:imagenew]+40;
        richView.bottomImgTextView.y = [self getImgHeightWithImg:imagenew];
        [self.totalImgArray insertObject:richView atIndex:insertIndex];
        imgCount+=1;
    }
    [self.rootTableView reloadData];
    
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//点击alertController
-(void)openPickViewAcyion:(NSInteger)index
{
    
    if (imgCount == 6) {
        
        NSLog(@"图片数目已达上限");
        return;
    }
    
    UIImagePickerController *pc = [[UIImagePickerController alloc]init];
    pc.delegate = self;
    if (index==0) {
        //选择相册
        //相册选择
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            // 创建控制器
            ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
            // 默认显示相册里面的内容SavePhotos
            pickerVc.status = PickerViewShowStatusCameraRoll;
            pickerVc.maxCount = 6-imgCount;
            pickerVc.delegate = self;
            [pickerVc showPickerVc:self];
            
            //            [pc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            //            //设置允许编辑
            //            pc.allowsEditing = YES;
            //            [self presentViewController:pc animated:YES completion:nil];
            
            
        }
        else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无法访问相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
        }
    }else if(index==1){
        //拍照
        //设置资源类型 --> 先要检测要设置的资源类型是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            [pc setSourceType:UIImagePickerControllerSourceTypeCamera];
            //根据开发习惯，UIImagePickerController以present的方式出现
            //设置允许编辑
            pc.allowsEditing = YES;
            [self presentViewController:pc animated:YES completion:nil];
        }
        else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相机不可用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
        }
    }
}














#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView.tag == 5) {
        insertIndex = 0;
    }
    else
    {
        insertIndex = textView.tag-111+1;
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    //    insertIndex = imgCount-1;
    [self.rootTableView reloadData];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    
    if (textView.tag == 5) {
        [self updateDefauleContent];
    }
    else
    {
        CustomRichImgView *richImg = (CustomRichImgView *)self.totalImgArray[textView.tag-111];
        
        if ([text isEqualToString:@""]) {
            //            NSLog(@"点击了键盘的删除按钮");
            
            if (textView.text.length==0) {
                
                if (richImg.mainImgView.height == 0) {
                    
                    
                    
                    [self.totalImgArray removeObjectAtIndex:textView.tag-111];
                    
                    [self.rootTableView reloadData];
                    
                    if (textView.tag-111==0) {
                        [self.contentTextView becomeFirstResponder];
                    }
                    else
                    {
                        
                        UITableViewCell *cell = [self.rootTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag-112 inSection:0]];
                        
                        
                        for (UIView *view in cell.contentView.subviews) {
                            if ([view isKindOfClass:[CustomRichImgView class]]) {
                                
                                CustomRichImgView *laterImg = (CustomRichImgView *)view;
                                [laterImg.bottomImgTextView becomeFirstResponder];
                                
                            }
                        }
                        
                    }
                }
                
            }
            
        }
        else
        {
            [self distributionChanged:textView.tag-111];
        }
        
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
    if (textView.tag == 5) {
        [self updateDefauleContent];
        
    }
    else
    {
        [self distributionChanged:textView.tag-111];
        
    }
    
    
}

#pragma mark 动态计算textview的高度
-(void)updateDefauleContent
{
    CGRect orgRect = self.contentTextView.frame;//获取原始UITextView的frame
    CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(self.contentTextView.width, MAXFLOAT)];
    
    orgRect.size.height=size.height;//获取自适应文本内容高度
    
    if (orgRect.size.height > 40) {
        self.contentTextView.height = orgRect.size.height;
    }else{
        self.contentTextView.height = 40;
    }
    
    [self.rootTableView beginUpdates];
    [self.rootTableView endUpdates];
}

-(void)distributionChanged:(NSInteger)index
{
    
    CustomRichImgView *richImg = (CustomRichImgView *)self.totalImgArray[index];
    
    CGRect orgRect = richImg.bottomImgTextView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [richImg.bottomImgTextView sizeThatFits:CGSizeMake(richImg.bottomImgTextView.width, MAXFLOAT)];
    
    orgRect.size.height=size.height;//获取自适应文本内容高度
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 40) {
        richImg.bottomImgTextView.height = orgRect.size.height;
        richImg.viewHeight = richImg.mainImgView.height+richImg.bottomImgTextView.height;
        richImg.textViewHeight = richImg.bottomImgTextView.height;
        richImg.bottomImgTextView.y = richImg.mainImgView.height;
        richImg.height = richImg.viewHeight;
    }else{
        richImg.bottomImgTextView.height = 40;
        richImg.viewHeight = richImg.mainImgView.height+40;
        richImg.textViewHeight = richImg.bottomImgTextView.height;
        richImg.bottomImgTextView.y = richImg.mainImgView.height;
        richImg.height = richImg.viewHeight;
    }
    
    [self.totalImgArray replaceObjectAtIndex:index withObject:richImg];
    [self.rootTableView beginUpdates];
    [self.rootTableView endUpdates];
    
}



#pragma mark - //根据屏幕宽度适配高度
- (CGFloat)getImgHeightWithImg:(UIImage *)img {
    CGFloat height = ((self.view.frame.size.width)/ img.size.width) * img.size.height;
    return height;
}



#pragma mark lazyLoad
-(UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]initWithFrame:(CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 40))];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.textColor = [UIColor darkTextColor];
        _contentTextView.tag =5;
        _contentTextView.returnKeyType = UIReturnKeyDone;
        _contentTextView.delegate = self;
    }
    
    return _contentTextView;
}


-(UIButton *)addImgBtn
{
    if (!_addImgBtn) {
        _addImgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _addImgBtn.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height-64-44, 50, 44);
        [_addImgBtn setTitle:@"添加" forState:(UIControlStateNormal)];
        [_addImgBtn setBackgroundColor:[UIColor orangeColor]];
        _addImgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addImgBtn addTarget:self action:@selector(addImgAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addImgBtn;
}
-(NSMutableArray *)totalImgArray
{
    if (!_totalImgArray) {
        _totalImgArray = [NSMutableArray new];
    }
    return _totalImgArray;
}
-(UITableView *)rootTableView
{
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20-44)) style:(UITableViewStyleGrouped)];
        _rootTableView.delegate =self;
        _rootTableView.dataSource = self;
        _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _rootTableView;
}

-(void)addImgAction
{
    
    
    NSLog(@"点击了添加图片");
    
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"添加图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPickViewAcyion:1];
        
    }];
    [actionConfirm setValue:[UIColor darkTextColor] forKey:@"titleTextColor"];
    UIAlertAction *actionCance = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPickViewAcyion:0];
    }];
    [actionCance setValue:[UIColor darkTextColor] forKey:@"titleTextColor"];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [action setValue:[UIColor darkTextColor] forKey:@"titleTextColor"];
    
    [alterController addAction:actionConfirm];
    [alterController addAction:actionCance];
    [alterController addAction:action];
    [self presentViewController:alterController animated:YES completion:nil];
    
    
    
}


@end
