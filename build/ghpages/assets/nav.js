/* PRA Registry — Sidebar Navigation */
document.addEventListener("DOMContentLoaded", function () {
  // Toggle tree nodes
  document
    .querySelectorAll(".tree-label[data-toggle]")
    .forEach(function (label) {
      label.addEventListener("click", function (e) {
        e.preventDefault();
        var children = this.nextElementSibling;
        var arrow = this.querySelector(".tree-arrow");
        if (children && children.classList.contains("tree-children")) {
          children.classList.toggle("open");
          if (arrow) arrow.classList.toggle("open");
        }
      });
    });

  // Highlight active page in sidebar
  var currentPath = window.location.pathname;
  // Also try with .html for file:// protocol
  var currentHref = window.location.href;
  document.querySelectorAll(".sidebar a").forEach(function (link) {
    var href = link.getAttribute("href");
    if (!href) return;
    // Normalize: compare end of path
    if (currentPath.endsWith(href) || currentHref.endsWith(href)) {
      link.classList.add("active");
      // Open parent tree nodes
      var parent = link.closest(".tree-children");
      while (parent) {
        parent.classList.add("open");
        var prev = parent.previousElementSibling;
        if (prev) {
          var arrow = prev.querySelector(".tree-arrow");
          if (arrow) arrow.classList.add("open");
        }
        parent = parent.parentElement.closest(".tree-children");
      }
    }
  });

  // Close sidebar on overlay click (mobile)
  document.addEventListener("click", function (e) {
    if (document.body.classList.contains("sidebar-open")) {
      var sidebar = document.querySelector(".sidebar");
      var toggle = document.querySelector(".sidebar-toggle");
      if (!sidebar.contains(e.target) && !toggle.contains(e.target)) {
        document.body.classList.remove("sidebar-open");
      }
    }
  });
});
