//
//  CustomRichImgView.h
//  XinEBao
//
//  Created by LeMo-test on 2017/3/30.
//  Copyright © 2017年 Lemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomRichImgView : UIView<UITextViewDelegate>


/**
 删除图片按钮
 */
@property (nonatomic, strong) UIButton * deleteBtn;

@property (nonatomic, strong) UIImageView * mainImgView;


@property (nonatomic, strong) UITextView * bottomImgTextView;


/**
 高度
 */
@property (nonatomic, assign) CGFloat viewHeight;


@property (nonatomic, assign) CGFloat  textViewHeight;


@end
