(function () {
	"use strict";

	// Wide screens: past the masthead the navbar becomes fixed (is-fixed) and
	// slides in (is-visible); back at the top it returns to its place.
	// Same breakpoint as _navbar.scss.
	var nav = document.getElementById("mainNav");
	var wide = window.matchMedia("(min-width: 992px)");
	if (!nav) return;

	var previousTop = window.scrollY;
	var pending = false;

	function update() {
		pending = false;
		var currentTop = window.scrollY;
		if (!wide.matches) {
			nav.classList.remove("is-visible", "is-fixed");
		} else if (currentTop < previousTop) {
			if (currentTop > 0 && nav.classList.contains("is-fixed")) {
				nav.classList.add("is-visible");
			} else {
				nav.classList.remove("is-visible", "is-fixed");
			}
		} else if (currentTop > previousTop) {
			nav.classList.add("is-visible");
			if (currentTop > nav.offsetHeight) nav.classList.add("is-fixed");
		}
		previousTop = currentTop;
	}

	function schedule() {
		if (pending) return;
		pending = true;
		window.requestAnimationFrame(update);
	}

	window.addEventListener("scroll", schedule, { passive: true });
	wide.addEventListener("change", schedule);
})();
