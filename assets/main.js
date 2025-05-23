(function ($) {
	"use strict"; // Start of use strict

	// Show the navbar when the page is scrolled up
	var MQL = 992;

	//primary navigation slide-in effect
	if ($(window).width() > MQL) {
		var headerHeight = $('#mainNav').height();
		$(window).on('scroll', {
				previousTop: 0
			},
			function () {
				var currentTop = $(window).scrollTop();
				//check if user is scrolling up
				if (currentTop < this.previousTop) {
					//if scrolling up...
					if (currentTop > 0 && $('#mainNav').hasClass('is-fixed')) {
						$('#mainNav').addClass('is-visible');
					} else {
						$('#mainNav').removeClass('is-visible is-fixed');
					}
				} else if (currentTop > this.previousTop) {
					//if scrolling down...
					$('#mainNav').addClass('is-visible');
					if (currentTop > headerHeight && !$('#mainNav').hasClass('is-fixed')) $('#mainNav').addClass('is-fixed');
				}
				this.previousTop = currentTop;
			});
	}

	$("script[type='math/tex']").replaceWith(function () {
		var tex = $(this).text();
		return "<span class=\"inline-equation\">" + katex.renderToString(tex) + "</span>";
	});

	$("script[type='math/tex; mode=display']").replaceWith(function () {
		var tex = $(this).text();
		return "<div class=\"equation\">" + katex.renderToString("\\displaystyle " + tex) + "</div>";
	});

	$(document).ready(function () {
		// scroll to top button
		$('#scroller').click(function () {
			$("html, body").animate({
				scrollTop: 0
			}, 'slow');
		});
	});
})(jQuery); // End of use strict