         (function($){
            isString = function (obj) {
            return toString.call(obj) == '[object String]';
            };
            
            $.fn.bodysnatch = function() {
                rA = [];
                this.each(function() {
                    var element = $(this);
                    var clone = element.clone();
                    clone.attr('style', window.getComputedStyle(element[0]).cssText);
                    clone.css({
                        position: 'absolute',
                        top: element.offset().top,
                        left: element.offset().left,
                        width: element.width(),
                        height: element.height(),
                        margin:0,
                        padding: 0
                        });
                    rA.push(clone);
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
                });
                return $(rA);
            };
        })(jQuery);