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
                        clone.attr('style', window.getComputedStyle(element[0]).cssText);
                        clone.css({
                            position: 'absolute',
                            top: element.offset().top,
                            left: element.offset().left,
                            width: element.width(),
                            height: element.height(),
                            margin:0,
                            //padding: 0
                            });
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
                    }
                    $('body').append(clone);
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
                });
                //return $(rA);
            };
        })(jQuery);