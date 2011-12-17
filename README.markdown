# DESCRIPTION

EXPERIMENTAL! Only a few hours old.

Hpple: A nice Objective-C wrapper on the XPathQuery library for parsing HTML.

Inspired by why the lucky stiff's [Hpricot](http://github.com/why/hpricot/tree/master).

# AUTHOR

Geoffrey Grosenbach, [Topfunky Corporation](http://topfunky.com) and [PeepCode Screencasts](http://peepcode.com).

# FEATURES

* Easy searching by XPath (CSS selectors are planned)
* Parses HTML (XML coming soon)
* Easy access to tag content, name, and attributes.

# INSTALLATION

* Open your XCode project and the Hpple project.
* Drag the "Hpple" directory to your project.
* Add the libxml2.dylib framework to your project and header search path as described at [Cocoa with Love](http://cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html)

# USAGE

See TFHppleHTMLTest.m and TFHppleXMLTest.m in HppleTests for samples.

<pre>
#import "TFHpple.h"

NSString * pathPath = [[NSBundle mainBundle] pathForResource:@"index" ofType: @"html"];
NSData * data       = [NSData dataWithContentsOfFile: dataPath];

TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
NSArray * elements  = [doc searchWithXPathQuery:@"//a[@class='sponsor']"];

TFHppleElement * element = [elements objectAtIndex:0];
[e content];              // Tag's innerHTML
[e tagName];              // "a"
[e attributes];           // NSDictionary of href, class, id, etc.
[e objectForKey:@"href"]; // Easy access to single attribute
</pre>

# TODO

* Internal error catching and messages
* CSS3 selectors in addition to XPath
