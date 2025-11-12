// custom.js
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

// Append current hash to all internal links
function updateInternalLinksWithHash(currentHash) {
  if (!currentHash) return;

  // Select all anchor tags with href starting with "/"
  const links = document.querySelectorAll('a[href^="/"]');

  links.forEach((link) => {
    const href = link.getAttribute("href").split("#")[0]; // Remove existing hash part if any
    link.setAttribute("href", href + currentHash);
  });
}

// Run on page load and on hash changes
window.addEventListener("DOMContentLoaded", updateHtmlClassFromHash);
window.addEventListener("hashchange", updateHtmlClassFromHash);
