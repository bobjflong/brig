###brig

brig is a static site generator written in drog\_lisp, and exists mainly as a non trivial example of drog\_lisp code. It uses the Textile markup language for writing posts.

brig generates <a href="http://bobjflong.co">my blog</a>.

####Dependencies
* ruby
* drog\_lisp
* pry (for now)
* rvm (or edit the shebang in <code>./brig.rb</code>)
* RedCloth
* Mustache
* maybe other things I  can't remember.

####Commands
<pre>
./brig.rb new testing-1-2-3  #create a post with shortcode testing-1-2-3
./brig.rb search testing     #search for a post containing "testing"
./brig.rb search test.+-3    #regexes are also ok
./brig.rb edit test.+-3      #post templates use the textile markup language
./brig.rb build              #builds site containing a paginated index, and post pages
./brig.rb view               #starts a server (default WEBrick)
</pre>

####Config

<code>lisp/config.drog</code> contains some configuration items, which should be self explanatory.


####Templates
<code>templates/layout.html</code> will be where your post(s) are rendered. This page provides a <code>{{{ yield }}}</code> tag designating where your post(s) should go. It also provides <code>{{{ next\_page }}}</code> and <code>{{{ prev\_page }}}</code> tags for pagination links.

Individual posts are provided with a  <code>{{{ link }}}</code> tag for permalinks.
