(function(){
// ----------------------------------------------------------
// アンカーリンクの移動をスクロールにする
// ----------------------------------------------------------


// ----------------------------------------------------------
// 変数の記述ルール
// var EXAMPLE   = 全て大文字の変数は定数
// var _example = アンダースコアから始まる変数は関数内だけで有効な変数
// var i_example = i_から始まる変数は引数
// var $example = $から始まる変数はjQueryオブジェクト
// var _$example = _$から始まる変数は関数内だけで有効なjQueryオブジェクト
// ----------------------------------------------------------

//-----------------------------------------------------------
// 最上位の変数(無名関数でスコープされていますので、グローバル変数ではありません)
//-----------------------------------------------------------

    var _smartphone_nav_open = "is-nav-open";
    var _classname_active = 'is-dropdown-open';
    var _trigger_obj_class = '.js-dropdown-trigger';

//-----------------------------------------------------------
// 関数を定義 | 連想配列を定義
//-----------------------------------------------------------


//-----------------------------------------------------------
// 処理を実行
//-----------------------------------------------------------
$(function(){

    $(_trigger_obj_class).on('click',function(){
        if ($(this).parent('li').hasClass(_classname_active)){
            $(_trigger_obj_class).parent('li').removeClass(_classname_active);//一度すべてのshowになっているものを非表示にする
        }else{
            $(_trigger_obj_class).parent('li').removeClass(_classname_active);
            $(this).parent('li').addClass(_classname_active);
        }
    });


    var mainHeader = $('.js-auto-header-wrap'),
        secondaryNavigation = $('.header__secondary-nav'),
        belowNavHeroContent = $('.sub-nav-hero'),
        headerHeight = mainHeader.height();

    //set scrolling variables
    var scrolling = false,
        previousTop = 0,
        currentTop = 0,
        scrollDelta = 10,
        scrollOffset = 150;

    mainHeader.on('click', '.header__nav-trigger', function(event){
        // open primary navigation on mobile
        event.preventDefault();
        mainHeader.toggleClass(_smartphone_nav_open);
    });

    $(window).on('scroll', function(){
        $(_trigger_obj_class).parent('li').removeClass(_classname_active);
        if( !scrolling ) {
            scrolling = true;
            (!window.requestAnimationFrame)
                ? setTimeout(autoHideHeader, 250)
                : requestAnimationFrame(autoHideHeader);
        }
    });

    $(window).on('resize', function(){
        headerHeight = mainHeader.height();
    });

    function autoHideHeader() {
        var currentTop = $(window).scrollTop();

        ( belowNavHeroContent.length > 0 )
            ? checkStickyNavigation(currentTop) // secondary navigation below intro
            : checkSimpleNavigation(currentTop);

        previousTop = currentTop;
        scrolling = false;
    }

    function checkSimpleNavigation(currentTop) {
        //there's no secondary nav or secondary nav is below primary nav
        if (previousTop - currentTop > scrollDelta) {
            //if scrolling up...
            mainHeader.removeClass('is-hidden');
        } else if( currentTop - previousTop > scrollDelta && currentTop > scrollOffset) {
            //if scrolling down...
            mainHeader.addClass('is-hidden');
        }
    }

    function checkStickyNavigation(currentTop) {
        //secondary nav below intro section - sticky secondary nav
        var secondaryNavOffsetTop = belowNavHeroContent.offset().top - secondaryNavigation.height() - mainHeader.height();

        if (previousTop >= currentTop ) {
            //if scrolling up...
            if( currentTop < secondaryNavOffsetTop ) {
                //secondary nav is not fixed
                mainHeader.removeClass('is-hidden');
                secondaryNavigation.removeClass('fixed slide-up');
                belowNavHeroContent.removeClass('secondary-nav-fixed');
            } else if( previousTop - currentTop > scrollDelta ) {
                //secondary nav is fixed
                mainHeader.removeClass('is-hidden');
                secondaryNavigation.removeClass('slide-up').addClass('fixed');
                belowNavHeroContent.addClass('secondary-nav-fixed');
            }

        } else {
            //if scrolling down...
            if( currentTop > secondaryNavOffsetTop + scrollOffset ) {
                //hide primary nav
                mainHeader.addClass('is-hidden');
                secondaryNavigation.addClass('fixed slide-up');
                belowNavHeroContent.addClass('secondary-nav-fixed');
            } else if( currentTop > secondaryNavOffsetTop ) {
                //once the secondary nav is fixed, do not hide primary nav if you haven't scrolled more than scrollOffset
                mainHeader.removeClass('is-hidden');
                secondaryNavigation.addClass('fixed').removeClass('slide-up');
                belowNavHeroContent.addClass('secondary-nav-fixed');
            }

        }
    }
});

})();