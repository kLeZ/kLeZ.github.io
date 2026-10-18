// Client-side full-text search for /cerca/ (MiniSearch, index in /search.json).
// The form works without this script: it submits ?q=&tag= to the same page,
// and this script reads those parameters, so results are shareable URLs.
(function () {
	"use strict";

	var root = document.getElementById("search");
	var out = document.getElementById("search-results");
	if (!root || !out || !window.MiniSearch || !window.fetch) return;

	var form = root.querySelector("form");
	var input = form.elements.q;
	var select = form.elements.tag;
	var text = out.dataset;
	var lang = document.documentElement.lang || "it";
	var dateFormat = new Intl.DateTimeFormat(lang, { day: "numeric", month: "short", year: "numeric" });

	// Short stopword lists: they appear in every post and would only add noise.
	var STOPWORDS = new Set((
		"a ad al alla alle allo agli ai anche che chi ci con cui da dal dalla dalle dai degli dei del della delle dello di " +
		"e ed gli ha hanno ho i il in io la le lo l ma mi ne nel nella nelle nei non o per piu se si sono su sul sulla " +
		"tra fra un una uno è c d " +
		"an and are as at be by for from has have in is it its of on or that the this to was were with"
	).split(/\s+/));

	// Lowercase and drop diacritics, one output char per input char, so that
	// offsets found in the folded text are valid in the original text.
	function fold(s) {
		var r = "";
		for (var i = 0; i < s.length; i++) {
			r += s[i].normalize("NFD")[0].toLowerCase()[0];
		}
		return r;
	}

	function processTerm(term) {
		var t = fold(term);
		return STOPWORDS.has(t) ? null : t;
	}

	var docs = null;
	var engine = null;

	function el(tag, attrs, children) {
		var node = document.createElement(tag);
		Object.keys(attrs || {}).forEach(function (k) { node.setAttribute(k, attrs[k]); });
		(children || []).forEach(function (c) {
			node.appendChild(typeof c === "string" ? document.createTextNode(c) : c);
		});
		return node;
	}

	function status(message) {
		out.replaceChildren(el("p", { role: "status" }, [message]));
	}

	// Snippet around the first matched term, with every matched term in <mark>.
	function snippet(doc, terms) {
		var content = doc.content;
		var folded = fold(content);
		if (!terms.length) return [doc.excerpt];

		var escaped = terms.map(function (t) { return t.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); });
		var re = new RegExp("(^|[^\\p{L}\\p{N}])(" + escaped.join("|") + ")", "gu");
		var first = re.exec(folded);
		if (!first) return [doc.excerpt];

		var at = first.index + first[1].length;
		var start = Math.max(0, content.lastIndexOf(" ", Math.max(0, at - 120)) + 1);
		var end = content.indexOf(" ", Math.min(content.length, at + 200));
		if (end < 0) end = content.length;

		var parts = [];
		if (start > 0) parts.push("… ");
		var cursor = start;
		re.lastIndex = start;
		var m;
		while ((m = re.exec(folded)) && m.index < end) {
			var s = m.index + m[1].length;
			var e = s + m[2].length;
			if (s > cursor) parts.push(content.slice(cursor, s));
			parts.push(el("mark", {}, [content.slice(s, e)]));
			cursor = e;
		}
		if (end > cursor) parts.push(content.slice(cursor, end));
		if (end < content.length) parts.push(" …");
		return parts;
	}

	function render(list, terms) {
		if (!list.length) {
			status(text.none);
			return;
		}
		var count = list.length === 1 ? text.resultsOne : text.resultsOther.replace("%count%", list.length);
		var ol = el("ol", { class: "search-results list-unstyled" });
		list.forEach(function (doc) {
			var tags = el("p", { class: "tag-list small text-muted mb-0" }, [el("span", { class: "tag-list-label" }, [text.tagsLabel])]);
			doc.tags.forEach(function (tag, i) {
				tags.appendChild(document.createTextNode(" "));
				tags.appendChild(el("a", { href: text.tagBase + tag.slug + "/", rel: "tag" }, [tag.name]));
				if (i < doc.tags.length - 1) tags.appendChild(document.createTextNode(","));
			});
			var body = el("section", { class: "card-body" }, [
				el("h2", { class: "card-title h4" }, [el("a", { href: doc.url }, [doc.title])]),
				el("p", { class: "card-subtitle mb-2 text-muted" }, [
					el("time", { datetime: doc.date }, [dateFormat.format(new Date(doc.date))])
				]),
				el("p", { class: "card-text" }, snippet(doc, terms))
			]);
			var article = el("article", { class: "card my-4" }, [body]);
			if (doc.tags.length) article.appendChild(el("footer", { class: "card-footer" }, [tags]));
			ol.appendChild(el("li", {}, [article]));
		});
		out.replaceChildren(el("p", { role: "status" }, [count]), ol);
	}

	function run() {
		var q = input.value.trim();
		var tag = select.value;
		if (!engine) return;
		if (!q && !tag) {
			status(text.empty);
			return;
		}
		var hasTag = function (doc) {
			return !tag || doc.tags.some(function (t) { return t.slug === tag; });
		};
		if (!q) {
			render(docs.filter(hasTag), []);
			return;
		}
		var hits = engine.search(q, { filter: function (r) { return hasTag(docs[r.id]); } });
		var terms = [];
		hits.forEach(function (h) {
			h.terms.forEach(function (t) { if (terms.indexOf(t) < 0) terms.push(t); });
		});
		render(hits.map(function (h) { return docs[h.id]; }), terms);
	}

	function syncUrl() {
		var params = new URLSearchParams();
		if (input.value.trim()) params.set("q", input.value.trim());
		if (select.value) params.set("tag", select.value);
		var qs = params.toString();
		history.replaceState(null, "", location.pathname + (qs ? "?" + qs : ""));
	}

	var timer = null;
	function schedule() {
		clearTimeout(timer);
		timer = setTimeout(function () { syncUrl(); run(); }, 200);
	}

	var params = new URLSearchParams(location.search);
	input.value = params.get("q") || "";
	select.value = params.get("tag") || "";

	form.addEventListener("submit", function (e) {
		e.preventDefault();
		syncUrl();
		run();
	});
	input.addEventListener("input", schedule);
	select.addEventListener("change", schedule);

	status(text.loading);
	fetch(text.index)
		.then(function (r) {
			if (!r.ok) throw new Error(r.status);
			return r.json();
		})
		.then(function (data) {
			docs = data;
			engine = new MiniSearch({
				fields: ["title", "tagText", "content"],
				extractField: function (doc, field) {
					if (field === "tagText") return doc.tags.map(function (t) { return t.name; }).join(" ");
					return doc[field];
				},
				processTerm: processTerm,
				searchOptions: {
					boost: { title: 3, tagText: 2 },
					prefix: true,
					fuzzy: 0.2,
					combineWith: "AND",
					processTerm: processTerm
				}
			});
			engine.addAll(docs);
			run();
		})
		.catch(function () { status(text.error); });
})();
