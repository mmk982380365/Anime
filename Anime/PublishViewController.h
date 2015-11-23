//
//  PublishViewController.h
//  Anime
//
//  Created by wang on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "BaseViewController.h"
#import <BmobSDK/Bmob.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#define  WIDTH self.view.frame.size.width
#define  HEIGHT self.view.frame.size.height
@interface PublishViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
/**
 *  图片视图
 */
@property(strong,nonatomic) UICollectionView *collectionView;
/**
 *  图片数据
 */
@property(strong,nonatomic) NSMutableArray *dataArr;
/**
 *  图片选择器
 */
@property(strong,nonatomic) UIImagePickerController *pickerController;
/**
 *  文本框
 */
@property(strong,nonatomic)UITextView *commentTextView;
/**
 *  占位符
 */
@property(strong,nonatomic)UILabel *lab1;
/**
 *  图片高度
 */
@property(assign,nonatomic) float headerHeight;
/**
 *  中心
 */
@property(assign,nonatomic)CGPoint center;
/**
 *  遮罩视图
 */
@property(strong,nonatomic)UIView *shadeView;

/**
 *  HUD
 */
@property(strong,nonatomic)MBProgressHUD *hud;
@end
