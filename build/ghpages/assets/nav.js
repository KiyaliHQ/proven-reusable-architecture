/* PRA Registry — Navigation & TOC */

/* ── Sidebar toggle functions (used by inline onclick handlers) ── */

function toggleSection(el) {
  el.classList.toggle("open");
  var children = el.nextElementSibling;
  if (children) children.classList.toggle("collapsed");
}

function toggleNode(el) {
  if (el.classList.contains("empty")) return;
  el.classList.toggle("open");
  var children = el.nextElementSibling;
  if (children && children.classList.contains("tree-children"))
    children.classList.toggle("collapsed");
}

/* ── DOMContentLoaded logic ── */
document.addEventListener("DOMContentLoaded", function () {
  /* ── Highlight active page in sidebar ── */
  var currentPath = window.location.pathname;
  var currentHref = window.location.href;

  document.querySelectorAll(".sidebar a").forEach(function (link) {
    var href = link.getAttribute("href");
    if (!href) return;
    if (currentPath.endsWith(href) || currentHref.endsWith(href)) {
      link.classList.add("active");
      // Open ancestor tree nodes / sections so the active link is visible
      var parent = link.parentElement;
      while (parent && !parent.classList.contains("sidebar")) {
        if (parent.classList.contains("tree-children")) {
          parent.classList.remove("collapsed");
        }
        if (
          parent.classList.contains("tree-node") ||
          parent.classList.contains("tree-subnode")
        ) {
          parent.classList.add("open");
        }
        if (parent.classList.contains("sidebar-section-title")) {
          parent.classList.add("open");
          var sib = parent.nextElementSibling;
          if (sib) sib.classList.remove("collapsed");
        }
        parent = parent.parentElement;
      }
    }
  });

  /* ── Close sidebar on outside click (mobile) ── */
  document.addEventListener("click", function (e) {
    var sidebar = document.querySelector(".sidebar");
    if (!sidebar || !sidebar.classList.contains("sidebar-visible")) return;
    var menuBtn = document.querySelector(".mobile-menu-btn");
    if (
      !sidebar.contains(e.target) &&
      (!menuBtn || !menuBtn.contains(e.target))
    ) {
      sidebar.classList.remove("sidebar-visible");
    }
  });

  /* ── Active TOC tracking on scroll ── */
  (function () {
    var tocLinks = document.querySelectorAll(".toc-nav a");
    if (!tocLinks.length) return;

    var sectionIds = [];
    tocLinks.forEach(function (link) {
      var id = link.getAttribute("href");
      if (id && id.charAt(0) === "#") sectionIds.push(id.slice(1));
    });
    if (!sectionIds.length) return;

    function getAbsoluteTop(el) {
      var top = 0;
      while (el) {
        top += el.offsetTop;
        el = el.offsetParent;
      }
      return top;
    }

    function updateToc() {
      var scrollPos = window.scrollY + 140;
      var currentId = sectionIds[0];
      var maxScroll =
        document.documentElement.scrollHeight - window.innerHeight;
      var atBottom = window.scrollY >= maxScroll - 10;

      if (atBottom) {
        for (var j = sectionIds.length - 1; j >= 0; j--) {
          var elB = document.getElementById(sectionIds[j]);
          if (elB && elB.getBoundingClientRect().top < window.innerHeight) {
            currentId = sectionIds[j];
            break;
          }
        }
      } else {
        for (var i = sectionIds.length - 1; i >= 0; i--) {
          var el = document.getElementById(sectionIds[i]);
          if (el && getAbsoluteTop(el) <= scrollPos) {
            currentId = sectionIds[i];
            break;
          }
        }
      }

      tocLinks.forEach(function (link) {
        if (link.getAttribute("href") === "#" + currentId) {
          link.classList.add("active");
        } else {
          link.classList.remove("active");
        }
      });
    }

    window.addEventListener("scroll", updateToc, { passive: true });
    updateToc();
  })();
});
