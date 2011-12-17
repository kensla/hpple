//
//  TFHppleElementAttribute.h
//  Hpple
//
//  Created by Lysann Kessler on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libxml/tree.h>

#import "TFHppleElement.h"

@interface TFHppleElementAttribute : NSObject {
@private
  xmlAttrPtr attribute;
  TFHppleElement* parentElement;
}

- (id) initWithAttribute: (xmlAttrPtr) attr ofElement: (TFHppleElement*) parent;
+ (TFHppleElementAttribute*) hppleElementAttributeWithAttribute: (xmlAttrPtr) attr ofElement: (TFHppleElement*) parent;

#pragma mark -

- (NSString*) name;
- (NSString*) value;

@end
