//
//  ViewController.m
//  demo
//
//  Created by yunyunzhang on 2017/8/21.
//  Copyright © 2017年 yunyunzhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UIImageView * detachImageView;
@property (weak, nonatomic) IBOutlet UIButton *detachBtn;
@end

@implementation ViewController
- (IBAction)detachAction:(id)sender
{
    [self detach];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detachImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
    self.detachImageView.image = [UIImage imageNamed:@"6.jpeg"]; // 1.jpg
    self.detachImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.detachImageView];
}

- (void)detach
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                     forKey:CIDetectorAccuracy];
    CIDetector * detector= [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    CIImage * image = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"6.jpeg"]];
    NSArray *faceArray = [detector featuresInImage:image
                                           options:nil];
    CGSize ciImageSize = [image extent].size;;
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    transform = CGAffineTransformTranslate(transform,0,-ciImageSize.height);
    
    for (CIFeature * feature in faceArray)
    {
        if ([feature.type isEqualToString:CIFeatureTypeFace])
        {
            CIFaceFeature * faceFeature=(CIFaceFeature *)feature;
            CGSize viewSize = self.detachImageView.bounds.size;
            CGFloat scale = MIN(viewSize.width / ciImageSize.width,
                                viewSize.height / ciImageSize.height);
            CGFloat offsetX = (viewSize.width - ciImageSize.width * scale) / 2;
            CGFloat offsetY = (viewSize.height - ciImageSize.height * scale) / 2;
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        
            CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
            faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
            faceViewBounds.origin.x += offsetX;
            faceViewBounds.origin.y += offsetY;
        
            UIView * faceView = [[UIView alloc]initWithFrame:faceViewBounds];
            faceView.layer.borderWidth = 1;
            faceView.layer.borderColor= [UIColor greenColor].CGColor;
            [self.detachImageView addSubview:faceView];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
