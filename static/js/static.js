function updateHtmlClassFromHash() {
  const html = document.documentElement;
  html.classList.remove("var-blue", "var-bordeaux");

  const hash = location.hash.replace(/^#/, "");
  if (hash === "blue") {
    html.classList.add("var-blue");
  } else if (hash === "bordeaux") {
    html.classList.add("var-bordeaux");
  }

  updateInternalLinksWithHash(location.hash);
}

function updateInternalLinksWithHash(currentHash) {
  if (!currentHash) return;

  const siteOrigin = location.origin;

  // Select all anchor tags with href attribute
  const links = document.querySelectorAll("a[href]");

  links.forEach((link) => {
    const href = link.getAttribute("href");

    // Ignore if it already has the current hash to avoid duplication
    if (href.includes(currentHash)) return;

    try {
      const url = new URL(href, siteOrigin);

      // Only update links that have the same origin as the site
      if (url.origin === siteOrigin) {
        // Remove any existing hash before appending current hash
        const cleanPath = url.pathname + url.search;
        link.setAttribute("href", cleanPath + currentHash);
      }
    } catch {
      // Skip invalid URLs (e.g., mailto:, tel:)
    }
  });
}

// Run on page load and on hash changes
window.addEventListener("DOMContentLoaded", updateHtmlClassFromHash);
window.addEventListener("hashchange", updateHtmlClassFromHash);
