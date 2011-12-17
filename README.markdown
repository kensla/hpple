# DESCRIPTION

Hpple: A nice Objective-C wrapper on the XPathQuery library for parsing HTML.

Inspired by why the lucky stiff's [Hpricot](https://github.com/hpricot/hpricot).

# AUTHORS

* Geoffrey Grosenbach, [Topfunky Corporation](http://topfunky.com) and [PeepCode Screencasts](http://peepcode.com).
* Lysann Kessler

# FEATURES

* Easy searching by XPath (CSS selectors are planned)
* Parses HTML (XML coming soon)
* Easy access to tag content, name, and attributes.

# INSTALLATION

* Open your XCode project and the Hpple project.
* Drag the "Hpple" directory to your project.
* Add the libxml2.dylib framework to your project and header search path as described at [Cocoa with Love](http://cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html)

# USAGE

<pre>
#import "TFHpple.h"

NSString * pathPath = [[NSBundle mainBundle] pathForResource:@"index" ofType: @"html"];
NSData   * data     = [NSData dataWithContentsOfFile: dataPath];
TFHpple  * document = [[TFHpple alloc] initWithHTMLData:data];

// You can search in the whole document.
TFHppleXPathResult * result  = [document searchWithXPathQuery:@"//a[@class='sponsor']"];

TFHppleElement * element = [result objectAtIndex:0];
[element content];              // Tag's innerHTML
[element tagName];              // "a"
[element attributes];           // NSDictionary of href, class, id, etc.
[element objectForKey:@"href"]; // Easy access to single attribute

// You can search starting from a subnode.
TFHppleElement * subnode = [document peekAtSearchWithXPathQuery:@"//div[@id='footer']"];
result = [subnode searchWithXPathQuery:@"div"]; // direct "div" children of subnode

// The TFHppleXPathResult behaves like an array.
[result count];            // number of matching elements
[result objectAtIndex: 3]; // the 4th element
[result isEmpty];          // BOOL that determines whether the result is empty or not

// You can transform it into an array.
NSArray* arr = [result array];
forin(TFHppleElement* node in arr) {
  NSLog(@"%@", node.tagName);
}
</pre>

See TFHppleHTMLTest.m and TFHppleXMLTest.m in HppleTests for more examples.

# TODO

* Internal error catching and messages
* CSS3 selectors in addition to XPath
