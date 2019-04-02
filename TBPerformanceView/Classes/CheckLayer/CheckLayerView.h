//
//  CheckLayerView.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CheckLayerViewDeleaget <NSObject>

- (void)showDetailViewSuperViews:(NSArray *)views;


@end

@interface CheckLayerView : UIView

@property(weak, nonatomic) id <CheckLayerViewDeleaget> delegate;

- (void)show;

- (void)hidden;

@end

NS_ASSUME_NONNULL_END
