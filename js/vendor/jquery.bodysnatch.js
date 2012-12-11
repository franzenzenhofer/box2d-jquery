         (function($){
    $.fn.getStyleObject = function(){
        var dom = this.get(0);
        var style;
        var returns = {};
        if(window.getComputedStyle){
            var camelize = function(a,b){
                return b.toUpperCase();
            }
            style = window.getComputedStyle(dom, null);
            for(var i=0;i<style.length;i++){
                var prop = style[i];
                var camel = prop.replace(/\-([a-z])/g, camelize);
                var val = style.getPropertyValue(prop);
                returns[camel] = val;
            }
            return returns;
        }
        if(dom.currentStyle){
            style = dom.currentStyle;
            for(var prop in style){
                returns[prop] = style[prop];
            }
            return returns;
        }
        return this.css();
    }
})(jQuery);

         (function($){
            isString = function (obj) {
            return toString.call(obj) == '[object String]';
            };
            
            $.fn.bodysnatch = function() {
                //rA = [];
                var collection = this;
                //console.log(collection)
                return collection.each(function(a,b) {
                    var element = $(this);
                    var clone = element.clone();
                    
                    w = element.width()
                    h = element.height()
                    //otherwise not loaded image will be stuck with zero width/height
                    if ( w && h)
                    {
                        //cssText returns "" on FF!!!
                        if ( window.getComputedStyle && window.getComputedStyle.cssText )
                        {
                            clone.attr('style', window.getComputedStyle(element[0]).cssText);
                        }
                        else
                        {
                            clone.css(element.getStyleObject());
                        }
                        clone.css({
                            position: 'absolute',
                            //hot fix for the 101 balls samplein FF and opera
                            //due to idiotic behaviour of 
                            //https://developer.mozilla.org/de/docs/DOM/window.getComputedStyle
                            //'background-color': element.css('background-color'),
                            top: element.offset().top,
                            left: element.offset().left,
                            width: element.width(),
                            height: element.height(),
                            margin:0,
                            //padding: 0
                            });
                        clone.addClass('perfect');
                    }
                    else //probably images without a width and height yet
                    {
                        clone.css({
                            position: 'absolute',
                            top: element.offset().top,
                            left: element.offset().left,
                            margin:0,
                            //padding: 0
                            }); 
                        clone.addClass('imperfect');
                    }
                    //clone.hide();
                    //$('body').append(clone);
                    //clone.show();
                    if(element[0].id) {
                        element[0].id=element[0].id+'_snatched';
                    }
                    element.addClass('snatched');
                    clone.addClass('bodysnatcher');
                    //stop audio and videos
                    element.css('visibility','hidden');
                    if(element[0].pause){
                        //console.log('video or audio')
                        element[0].pause();
                        element[0].src='';
                    }
                    collection[a]=clone[0]
                    $('body').append(clone);
                    //experiments for better rendering
                    //window.setTimeout(function(){element.css('visibility','hidden');},0);
                    //windiw.setTimeout(function(){element.css('visibility','hidden');}, 0);
                });
                //return $(rA);
            };
        })(jQuery);