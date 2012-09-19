//
//  FlipRender.h
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RendererBase.h"
#import "Page.h"

@interface FlipRenderer : RendererBase{
    GLKVector3 *_pagesPos;
    
    float _pageDist;
    
    float _expandLevel;
    float _targetExpandLevel;
    
    float _maxSlideX;
    float _minSlideX;
    float _maxDragSlideX;
    float _minDragSlideX;
    
    float _slideX;
    float _targetSlideX;
    float _slideInterval;
    float _avgSpeedX;
    
}

-(void)flipToPageById:(int)pageId;
-(void)flipToPage:(Page *)page;
-(void)flipNextPage;
-(void)flipPrevPage;

//select
-(void)selectFocusedPage;

//expand param

@end
