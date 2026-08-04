/*
 * Colour-variant theming.
 *
 * The site has two independent controls:
 *   - Light/dark appearance. Congo owns this (`appearance.js`, `.dark` class).
 *   - Colour variant. This file owns it, as `data-theme` on <html>.
 *
 * The variant lives in localStorage. A "#blue", "#bordeaux" or "#violet"
 * fragment also selects a variant, so shared links of that form keep working,
 * and the fragment stays in the address bar for copying.
 *
 * What this file does not do is copy that fragment onto every internal link.
 * The earlier version did, which overwrote each in-page anchor on the page:
 * skip-to-content, back-to-top and the Impressum table of contents all became
 * "/#blue". Persisting the variant makes the copying unnecessary — a normal
 * link now carries the variant to the next page on its own.
 *
 * This script must run before the first paint, so `extend-head.html` loads it
 * without `defer`. Do not add `defer`: the page then flashes the previous
 * colours on every load.
 */
(function () {
  "use strict";

  var STORAGE_KEY = "theme-variant";
  /* Cycle order. The first entry is the default and carries no attribute: its
     colours are the ones `custom.css` puts on `html:not([data-theme])`. */
  var VARIANTS = ["blue", "bordeaux", "violet"];
  var DEFAULT_VARIANT = VARIANTS[0];
  var root = document.documentElement;
  var switcher = null;

  function isVariant(name) {
    return VARIANTS.indexOf(name) !== -1;
  }

  /* localStorage throws in private mode and when cookies are blocked. A
     failure there must not stop the rest of the page. */
  function readStored() {
    try {
      return localStorage.getItem(STORAGE_KEY);
    } catch (e) {
      return null;
    }
  }

  function writeStored(name) {
    try {
      localStorage.setItem(STORAGE_KEY, name);
    } catch (e) {
      /* Variant applies to this page view only. */
    }
  }

  function apply(name) {
    if (name === DEFAULT_VARIANT) {
      root.removeAttribute("data-theme");
    } else {
      root.setAttribute("data-theme", name);
    }
  }

  function current() {
    return root.getAttribute("data-theme") || DEFAULT_VARIANT;
  }

  function nextVariant() {
    return VARIANTS[(VARIANTS.indexOf(current()) + 1) % VARIANTS.length];
  }

  /* A fragment that names a variant selects it, on any path. The fragment is
     only read, never written to other links, so any other value is a heading
     anchor and is left alone. */
  function variantFromFragment() {
    var fragment = location.hash.replace(/^#/, "");
    return isVariant(fragment) ? fragment : null;
  }

  function select(name) {
    apply(name);
    writeStored(name);
    refreshSwitcher();
    /* Congo keeps the browser UI colour in sync with the page background. */
    if (typeof window.setThemeColor === "function") {
      window.setThemeColor();
    }
  }

  /* The button announces the variant it switches to, not the current one. */
  function refreshSwitcher() {
    if (!switcher) {
      return;
    }
    var label = switcher.getAttribute("data-label-" + nextVariant());
    if (label) {
      switcher.setAttribute("title", label);
      switcher.setAttribute("aria-label", label);
    }
  }

  var fromFragment = variantFromFragment();
  var stored = readStored();

  if (fromFragment) {
    apply(fromFragment);
    writeStored(fromFragment);
  } else if (isVariant(stored)) {
    apply(stored);
  } else {
    apply(DEFAULT_VARIANT);
  }

  /* Covers a "#blue" link followed from the page the reader is already on:
     the browser fires hashchange instead of loading the document again. */
  window.addEventListener("hashchange", function () {
    var next = variantFromFragment();
    if (next) {
      select(next);
    }
  });

  /* The button is rendered server-side into a <template> and placed next to
     Congo's light/dark switcher here. Building it in JS would duplicate the
     icon markup; shipping it in the footer partial would need a full copy of
     Congo's footer, and would leave a dead control for readers without
     JavaScript. */
  function mountSwitcher() {
    var source = document.getElementById("theme-variant-template");
    var appearance = document.getElementById("appearance-switcher-0");
    if (!source || !appearance || !appearance.parentElement) {
      return;
    }

    /* `appearance.parentElement` is the wrapper Congo styles and spaces; the
       variant button becomes its sibling so both share that row. */
    var anchor = appearance.parentElement;
    anchor.parentElement.insertBefore(source.content.cloneNode(true), anchor);
    source.remove();

    switcher = document.getElementById("theme-variant-switcher");
    if (!switcher) {
      return;
    }
    switcher.addEventListener("click", function () {
      select(nextVariant());
    });
    refreshSwitcher();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", mountSwitcher);
  } else {
    mountSwitcher();
  }
})();
