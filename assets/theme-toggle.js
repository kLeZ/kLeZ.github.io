(function () {
	"use strict";

	var STORAGE_KEY = "theme-preference";
	// Modes: "system", "light", "dark"
	var MODES = ["system", "light", "dark"];
	var ICONS = {
		system: "fa-adjust",
		light: "fa-sun",
		dark: "fa-moon"
	};
	// Fallback labels (EN); the templates localize them with data-label-<mode> on the button.
	var LABELS = {
		system: "Auto",
		light: "Light",
		dark: "Dark"
	};

	function labelFor(btn, mode) {
		return btn.dataset["label" + mode.charAt(0).toUpperCase() + mode.slice(1)] || LABELS[mode];
	}

	function getStoredPreference() {
		try {
			return localStorage.getItem(STORAGE_KEY) || "system";
		} catch (e) {
			return "system";
		}
	}

	function setStoredPreference(mode) {
		try {
			localStorage.setItem(STORAGE_KEY, mode);
		} catch (e) {
			// localStorage not available
		}
	}

	function getSystemTheme() {
		if (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches) {
			return "dark";
		}
		return "light";
	}

	function resolveTheme(mode) {
		if (mode === "system") {
			return getSystemTheme();
		}
		return mode;
	}

	function applyTheme(mode) {
		var resolved = resolveTheme(mode);
		document.documentElement.setAttribute("data-theme", resolved);
	}

	function updateToggleButton(mode) {
		var buttons = document.querySelectorAll(".theme-toggle");
		for (var i = 0; i < buttons.length; i++) {
			var btn = buttons[i];
			var icon = btn.querySelector(".theme-icon");
			var label = btn.querySelector(".theme-label");

			if (icon) {
				MODES.forEach(function (m) { icon.classList.remove(ICONS[m]); });
				icon.classList.add(ICONS[mode]);
			}
			var text = labelFor(btn, mode);
			if (label) {
				label.textContent = text;
			}

			btn.setAttribute("title", text);
			btn.setAttribute("aria-label", text);
		}
	}

	function cycleMode() {
		var current = getStoredPreference();
		var idx = MODES.indexOf(current);
		var next = MODES[(idx + 1) % MODES.length];
		setStoredPreference(next);
		applyTheme(next);
		updateToggleButton(next);
	}

	// Listen for system theme changes (when in "system" mode)
	if (window.matchMedia) {
		window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", function () {
			var mode = getStoredPreference();
			if (mode === "system") {
				applyTheme("system");
			}
		});
	}

	// Initialize on DOM ready
	function init() {
		var mode = getStoredPreference();
		applyTheme(mode);
		updateToggleButton(mode);

		// Bind click handlers
		var buttons = document.querySelectorAll(".theme-toggle");
		for (var i = 0; i < buttons.length; i++) {
			buttons[i].addEventListener("click", function (e) {
				e.preventDefault();
				cycleMode();
			});
		}
	}

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", init);
	} else {
		init();
	}
})();
