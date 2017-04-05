//
//  CustomRichImgView.m
//  XinEBao
//
//  Created by LeMo-test on 2017/3/30.
//  Copyright © 2017年 Lemo. All rights reserved.
//

#import "CustomRichImgView.h"
#import "UIView+Extension.h"
@implementation CustomRichImgView






-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubViews];
    }
    
    
    return self;
    
}


-(void)initSubViews
{
    
    self.mainImgView.frame = CGRectMake(0, 0, self.width, self.mainImgView.image.size.height);
    self.deleteBtn.frame = CGRectMake(self.mainImgView.width-35, 0, 35, 35);
    if (self.textViewHeight ==0) {
        self.textViewHeight = 40;
    }
    self.bottomImgTextView.frame = CGRectMake(0, self.mainImgView.height+self.mainImgView.y, self.width, self.textViewHeight);
    
}
-(void)setTextViewHeight:(CGFloat)textViewHeight
{
    _textViewHeight = textViewHeight;
    self.bottomImgTextView.frame = CGRectMake(0, self.mainImgView.height+self.mainImgView.y, self.width, textViewHeight);

}

#pragma mark LazyLoad


-(UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _deleteBtn.backgroundColor = [UIColor redColor];
        
        [self.mainImgView addSubview:_deleteBtn];
    }

    
    return _deleteBtn;
}
-(UIImageView *)mainImgView
{
    if (!_mainImgView) {
        _mainImgView = [[UIImageView alloc]init];
        _mainImgView.userInteractionEnabled = YES;
        [self addSubview:_mainImgView];
    }
    
    return _mainImgView;
}
-(UITextView *)bottomImgTextView
{
    if (!_bottomImgTextView) {
        
        _bottomImgTextView = [[UITextView alloc]init];
        _bottomImgTextView.font = [UIFont systemFontOfSize:16.0f];
        _bottomImgTextView.textColor  = [UIColor darkTextColor];
        _bottomImgTextView.delegate = self;
        _bottomImgTextView.returnKeyType = UIReturnKeyDone;
        _bottomImgTextView.showsVerticalScrollIndicator = NO;
        _bottomImgTextView.scrollEnabled = NO;
        [self addSubview:_bottomImgTextView];
    }
    
    return _bottomImgTextView;
}

@end
