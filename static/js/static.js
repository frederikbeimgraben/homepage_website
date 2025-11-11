// custom.js
function updateHtmlClassFromHash() {
  const html = document.documentElement;
  // Remove existing var-* class, if set
  html.classList.remove("var-blue", "var-bordeaux");

  // Get the hash, normalize (remove # if present)
  const hash = location.hash.replace(/^#/, "");
  if (hash === "blue") {
    html.classList.add("var-blue");
  } else if (hash === "bordeaux") {
    html.classList.add("var-bordeaux");
  }
}

// Run on page load and hash change
window.addEventListener("DOMContentLoaded", updateHtmlClassFromHash);
window.addEventListener("hashchange", updateHtmlClassFromHash);
