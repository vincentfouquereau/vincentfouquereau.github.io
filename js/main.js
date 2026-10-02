// fouquereau.com — scripts du site
(function () {
  'use strict';

  // ---------- Année dans le pied de page ----------
  var year = document.getElementById('year');
  if (year) year.textContent = new Date().getFullYear();

  // ---------- Menu mobile : bascule simple, accessible ----------
  var toggle = document.querySelector('.nav-toggle');
  var links = document.querySelector('.nav-links');

  if (toggle && links) {
    toggle.addEventListener('click', function () {
      var open = links.classList.toggle('open');
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    });

    // Ferme le menu après un clic sur un lien (navigation ancrée)
    links.addEventListener('click', function (e) {
      if (e.target.closest('a')) {
        links.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
      }
    });

    // Ferme le menu avec la touche Échap
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && links.classList.contains('open')) {
        links.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
        toggle.focus();
      }
    });
  }

  // ---------- Carte Google : chargement après consentement ----------
  // Évite tout cookie/traceur Google avant que le visiteur ne le demande.
  var consent = document.querySelector('.map-consent');

  if (consent) {
    consent.addEventListener('click', function (e) {
      var btn = e.target.closest('[data-map-load]');
      if (!btn) return;

      var wrap = consent.closest('.map');
      var iframe = wrap ? wrap.querySelector('iframe[data-src]') : null;
      if (!iframe) return;

      iframe.addEventListener('load', function () {
        iframe.removeAttribute('data-src');
      });
      iframe.src = iframe.getAttribute('data-src');
      consent.remove();
    });
  }
})();
