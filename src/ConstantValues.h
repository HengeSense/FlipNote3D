//
//  Constant.h
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define PAGEPART_WIDTH 512
#define PAGEPART_HEIGHT 768
#define PAGEPART_HALFHEIGHT 384

#define BOTTOMBARBTN_SIZE 80
#define BOTTOMBARBTN_HALFSIZE 40

enum BookStatus{
    CLOSE,
    OPEN_FLIP,
    OPEN_TABLE,
    OPEN_CALENDAR
};

#define RENDERER_CLOSE_COMPLETE @"renderer close complete"
#define TOUCH_BEGIN @"touch begin"
#define TOUCH_MOVE @"touch move"
#define TOUCH_END @"touch end"
#define TOUCH_CLICK @"touch click"

#define MULTITOUCH_SCALE @"mutiltouch scale"

#define BOOKCOVER_WHITE @"bookcover white"
#define BOOKCOVER_BLACK @"bookcover black"
#define BOOK_OPEN @"book open"
#define BOOK_CLOSE @"book close"
#define PAGE_FULLSCREEN @"page fullscreen"
#define PAGE_EXIT_FULLSCREEN @"page exit fullscreen"

#define SKETCH_CLOSE @"sketch close"

#define MAX_PAGE_IN_BOOK 100
#define FLIPVIEW_PAGESELECT_EXPAND	 1.3304f

#define FLIPVIEW_PAGE_MAXX 500
#define FLIPVIEW_PAGE_OPENZ -1000
#define BOOKSHELF_BOOKDEFAULTZ -2000 
