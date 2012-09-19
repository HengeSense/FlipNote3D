//
//  TableRender.h
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RendererBase.h"
#import "Page.h"

@interface TableRenderer : RendererBase{
    GLKVector3 *_pagesPos;
    float _maxDragY;
    float _minDragY;
    float _dragY;
    //float _targetDragY;
    Page * _touchDownPage;
    


    float _expandLevel ;
    float _targetExpandLevel;
    float _expandInterval;
    
    BOOL _isExpandInTableStatus;
}


-(void)resetPagesPosition;

@end
