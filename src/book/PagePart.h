//
//  PagePart.h
//  FlipBook3D
//
//  Created by xiang huang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectContainer3D.h"
#import "GLProgram.h"

enum Part{
    LEFT,
    RIGHT
};

@class Page;
@interface PagePart : ObjectContainer3D{
}

@property(readonly)enum Part part;
@property(readonly)Page* page;

-(id)initWidthPart:(enum Part)part page:(Page*)page;

+(void)initialize;
+(GLProgram*)getProgram;


@end
