// Google Analytics 4
(function() {
    var script = document.createElement('script');
    script.async = true;
    script.src = 'https://www.googletagmanager.com/gtag/js?id=G-9E6CKN660Z';
    document.head.appendChild(script);

    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-9E6CKN660Z');
})();

/**
 * MACH I Website — Main JavaScript
 * Shared header/footer injection, mobile menu, sticky header, smooth scroll,
 * Netlify Forms validation, scroll spy, scroll reveal animations
 */

(function () {
  'use strict';

  var SITE_PHONE = '(937) 668-6974';
  var SITE_PHONE_HREF = 'tel:+19376686974';
  var HEADER_HEIGHT = 80;

  // ============================================================
  // 1. SHARED HEADER
  // ============================================================

  function buildHeader() {
    var el = document.getElementById('site-header');
    if (!el) return;

    el.innerHTML =
      '<div class="logo-banner">' +
        '<div class="container">' +
          '<a href="index.html" aria-label="MACH I Home">' +
            '<img src="img/mach-i-logo.png" alt="MACH I Cardiology — Aviation Cardiologist for Pilots, FAA Special Issuance &amp; AME Exams in Dayton, Ohio" class="logo-banner-img">' +
          '</a>' +
        '</div>' +
      '</div>' +
      '<header class="site-header" role="banner">' +
        '<div class="container header-inner">' +
          '<nav class="main-nav" id="mainNav" role="navigation" aria-label="Main navigation">' +
            '<ul class="nav-links">' +
              '<li><a href="index.html">Home</a></li>' +
              '<li><a href="about.html">About</a></li>' +
              '<li><a href="services.html">Services</a></li>' +
              '<li><a href="special-issuance.html">Special Issuance</a></li>' +
              '<li><a href="publications.html">Publications</a></li>' +
              '<li><a href="contact.html">Contact</a></li>' +
            '</ul>' +
            '<a href="intake.html" class="btn btn-gold btn-sm nav-cta">Get Started</a>' +
          '</nav>' +
          '<button class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="Toggle navigation menu" aria-expanded="false">' +
            '<span class="hamburger-line"></span>' +
            '<span class="hamburger-line"></span>' +
            '<span class="hamburger-line"></span>' +
          '</button>' +
        '</div>' +
      '</header>';
  }

  // ============================================================
  // 2. SHARED FOOTER
  // ============================================================

  function buildFooter() {
    var el = document.getElementById('site-footer');
    if (!el) return;

    el.innerHTML = '<footer class="site-footer" role="contentinfo">' +
      '<div class="container">' +
        '<div class="footer-grid">' +

          '<div class="footer-brand">' +
            '<a href="index.html" class="footer-logo-link"><img src="img/mach-i-logo-med.png" alt="MACH I Cardiology — FAA Aviation Cardiology &amp; Special Issuance Specialists" class="footer-logo-img" width="160" height="78"></a>' +
            '<p class="footer-tagline">Medical Aerospace Cardiology &amp; Human Performance Institute</p>' +
            '<address class="footer-address">' +
              '7061 Corporate Way, Suite 109<br>' +
              'Dayton, OH 45459' +
            '</address>' +
          '</div>' +

          '<div class="footer-nav">' +
            '<h4>Navigation</h4>' +
            '<ul>' +
              '<li><a href="index.html">Home</a></li>' +
              '<li><a href="about.html">About</a></li>' +
              '<li><a href="services.html">Services</a></li>' +
              '<li><a href="special-issuance.html">Special Issuance</a></li>' +
              '<li><a href="publications.html">Publications</a></li>' +
              '<li><a href="contact.html">Contact</a></li>' +
            '</ul>' +
          '</div>' +

          '<div class="footer-services">' +
            '<h4>Services</h4>' +
            '<ul>' +
              '<li><a href="services.html#aviation">FAA AME Flight Exam</a></li>' +
              '<li><a href="services.html#cardiology">Aviation Cardiology</a></li>' +
              '<li><a href="special-issuance.html">FAA Special Issuance</a></li>' +
              '<li><a href="services.html#performance">Executive Heart Screening</a></li>' +
            '</ul>' +
          '</div>' +

          '<div class="footer-conditions">' +
            '<h4>Conditions</h4>' +
            '<ul>' +
              '<li><a href="special-issuance.html#conditions">Heart Attack &amp; CAD</a></li>' +
              '<li><a href="special-issuance.html#conditions">Coronary Stent</a></li>' +
              '<li><a href="special-issuance.html#conditions">Bypass Surgery</a></li>' +
              '<li><a href="special-issuance.html#conditions">AFib &amp; Arrhythmias</a></li>' +
              '<li><a href="special-issuance.html#conditions">Valve Replacement</a></li>' +
              '<li><a href="special-issuance.html#conditions">Pacemaker</a></li>' +
            '</ul>' +
          '</div>' +

          '<div class="footer-contact">' +
            '<h4>Contact</h4>' +
            '<p><a href="' + SITE_PHONE_HREF + '">' + SITE_PHONE + '</a></p>' +
            '<p><a href="mailto:medicalaerospacecardiology@gmail.com">medicalaerospacecardiology@gmail.com</a></p>' +
            '<p>Monday &ndash; Friday<br>8:00 AM &ndash; 5:00 PM EST</p>' +
          '</div>' +

        '</div>' +
        '<div class="footer-bottom">' +
          '<p>&copy; 2026 MACH I. All rights reserved.</p>' +
        '</div>' +
      '</div>' +
    '</footer>';
  }

  // ============================================================
  // 3. ACTIVE NAV LINK
  // ============================================================

  function setActiveNavLink() {
    var path = window.location.pathname;
    var links = document.querySelectorAll('.nav-links a');

    links.forEach(function (link) {
      link.removeAttribute('aria-current');
      var href = link.getAttribute('href');
      if (
        path.endsWith(href) ||
        (href === 'index.html' && (path.endsWith('/') || path === '/'))
      ) {
        link.setAttribute('aria-current', 'page');
      }
    });
  }

  // ============================================================
  // 4. MOBILE MENU TOGGLE
  // ============================================================

  function initMobileMenu() {
    var toggle = document.getElementById('mobileMenuToggle');
    var nav = document.getElementById('mainNav');
    var body = document.body;

    if (!toggle || !nav) return;

    toggle.addEventListener('click', function () {
      var isOpen = body.classList.toggle('nav-open');
      toggle.classList.toggle('active');
      nav.classList.toggle('mobile-nav-open');
      toggle.setAttribute('aria-expanded', String(isOpen));
    });

    // Close on nav link click
    nav.querySelectorAll('.nav-links a').forEach(function (link) {
      link.addEventListener('click', function () {
        body.classList.remove('nav-open');
        toggle.classList.remove('active');
        nav.classList.remove('mobile-nav-open');
        toggle.setAttribute('aria-expanded', 'false');
      });
    });

    // Close on overlay click
    document.addEventListener('click', function (e) {
      if (!nav.contains(e.target) && !toggle.contains(e.target) && body.classList.contains('nav-open')) {
        body.classList.remove('nav-open');
        toggle.classList.remove('active');
        nav.classList.remove('mobile-nav-open');
        toggle.setAttribute('aria-expanded', 'false');
      }
    });

    // Close on Escape
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && body.classList.contains('nav-open')) {
        body.classList.remove('nav-open');
        toggle.classList.remove('active');
        nav.classList.remove('mobile-nav-open');
        toggle.setAttribute('aria-expanded', 'false');
        toggle.focus();
      }
    });
  }

  // ============================================================
  // 5. STICKY HEADER SCROLL EFFECT
  // ============================================================

  function initStickyHeader() {
    var header = document.querySelector('.site-header');
    if (!header) return;

    var scrolled = false;

    function update() {
      var shouldBe = window.scrollY > 50;
      if (shouldBe !== scrolled) {
        scrolled = shouldBe;
        header.classList.toggle('header-scrolled', scrolled);
      }
    }

    window.addEventListener('scroll', update, { passive: true });
    update();
  }

  // ============================================================
  // 6. SMOOTH SCROLL FOR ANCHOR LINKS
  // ============================================================

  function initSmoothScroll() {
    document.addEventListener('click', function (e) {
      var link = e.target.closest('a[href^="#"]');
      if (!link) return;

      var href = link.getAttribute('href');
      if (href === '#') return;

      // Skip-to-content link
      if (href === '#main' || href === '#main-content') {
        e.preventDefault();
        var main = document.getElementById(href.substring(1));
        if (main) {
          main.setAttribute('tabindex', '-1');
          main.focus();
          window.scrollTo({ top: main.offsetTop - HEADER_HEIGHT, behavior: 'smooth' });
        }
        return;
      }

      var target = document.getElementById(href.substring(1));
      if (!target) return;

      e.preventDefault();
      var top = target.getBoundingClientRect().top + window.scrollY - HEADER_HEIGHT;
      window.scrollTo({ top: top, behavior: 'smooth' });
    });
  }

  // ============================================================
  // 7. NETLIFY FORMS — CLIENT-SIDE VALIDATION
  // ============================================================

  function initNetlifyForms() {
    var forms = document.querySelectorAll('form[data-netlify="true"]');
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    forms.forEach(function (form) {
      // Clear errors on input
      form.querySelectorAll('input, select, textarea').forEach(function (field) {
        field.addEventListener('input', function () {
          var group = this.closest('.form-group');
          if (group) group.classList.remove('error');
        });
      });

      form.addEventListener('submit', function (e) {
        var isValid = true;

        // Clear all errors
        form.querySelectorAll('.form-group').forEach(function (g) {
          g.classList.remove('error');
        });

        // Validate required fields
        form.querySelectorAll('[required]').forEach(function (field) {
          var group = field.closest('.form-group');
          if (!field.value.trim()) {
            isValid = false;
            if (group) group.classList.add('error');
          }
          if (field.type === 'email' && field.value.trim() && !emailRegex.test(field.value.trim())) {
            isValid = false;
            if (group) group.classList.add('error');
          }
        });

        if (!isValid) {
          e.preventDefault();
          var firstError = form.querySelector('.form-group.error input, .form-group.error select, .form-group.error textarea');
          if (firstError) firstError.focus();
        }
        // If valid, do NOT preventDefault — let the form POST to Netlify natively
      });
    });
  }

  // ============================================================
  // 8. SERVICES NAV PILLS — SCROLL SPY
  // ============================================================

  function initServicesPills() {
    var pills = document.querySelectorAll('.services-nav-pills .pill');
    if (!pills.length) return;

    function updateActive() {
      var current = null;

      pills.forEach(function (pill) {
        var href = pill.getAttribute('href');
        if (!href || !href.startsWith('#')) return;
        var el = document.getElementById(href.substring(1));
        if (!el) return;

        var offset = el.getBoundingClientRect().top - HEADER_HEIGHT;
        if (offset <= 150) {
          current = pill;
        }
      });

      pills.forEach(function (p) { p.classList.remove('active'); });
      if (current) current.classList.add('active');
    }

    window.addEventListener('scroll', updateActive, { passive: true });
    updateActive();
  }

  // ============================================================
  // 9. SPECIAL ISSUANCE — CONDITION CARD ACCORDION
  // ============================================================

  function initSICards() {
    var cards = document.querySelectorAll('.si-card');
    if (!cards.length) return;

    cards.forEach(function (card) {
      var header = card.querySelector('.si-card-header');
      var body = card.querySelector('.si-card-body');
      if (!header || !body) return;

      header.addEventListener('click', function () {
        var isOpen = card.classList.contains('si-card--open');

        // Close all other cards (accordion behavior)
        cards.forEach(function (otherCard) {
          if (otherCard !== card && otherCard.classList.contains('si-card--open')) {
            var otherHeader = otherCard.querySelector('.si-card-header');
            var otherBody = otherCard.querySelector('.si-card-body');
            otherCard.classList.remove('si-card--open');
            if (otherHeader) otherHeader.setAttribute('aria-expanded', 'false');
            if (otherBody) otherBody.style.maxHeight = '0';
          }
        });

        // Toggle current card
        if (isOpen) {
          card.classList.remove('si-card--open');
          header.setAttribute('aria-expanded', 'false');
          body.style.maxHeight = '0';
        } else {
          card.classList.add('si-card--open');
          header.setAttribute('aria-expanded', 'true');
          body.style.maxHeight = body.scrollHeight + 'px';

          // Scroll the card into view after a short delay for animation
          setTimeout(function () {
            var cardTop = card.getBoundingClientRect().top + window.scrollY - HEADER_HEIGHT - 16;
            if (card.getBoundingClientRect().top < HEADER_HEIGHT + 16) {
              window.scrollTo({ top: cardTop, behavior: 'smooth' });
            }
          }, 100);
        }
      });

      // Keyboard: Enter or Space to toggle
      header.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          header.click();
        }
      });
    });
  }

  // ============================================================
  // 9b. SPECIAL ISSUANCE — FAQ ACCORDION
  // ============================================================

  function initSIFaq() {
    var items = document.querySelectorAll('.si-faq-item');
    if (!items.length) return;

    items.forEach(function (item) {
      var question = item.querySelector('.si-faq-question');
      var answer = item.querySelector('.si-faq-answer');
      if (!question || !answer) return;

      question.addEventListener('click', function () {
        var isOpen = item.classList.contains('si-faq-item--open');

        // Close all other FAQ items
        items.forEach(function (otherItem) {
          if (otherItem !== item && otherItem.classList.contains('si-faq-item--open')) {
            var otherQuestion = otherItem.querySelector('.si-faq-question');
            var otherAnswer = otherItem.querySelector('.si-faq-answer');
            otherItem.classList.remove('si-faq-item--open');
            if (otherQuestion) otherQuestion.setAttribute('aria-expanded', 'false');
            if (otherAnswer) otherAnswer.style.maxHeight = '0';
          }
        });

        // Toggle current item
        if (isOpen) {
          item.classList.remove('si-faq-item--open');
          question.setAttribute('aria-expanded', 'false');
          answer.style.maxHeight = '0';
        } else {
          item.classList.add('si-faq-item--open');
          question.setAttribute('aria-expanded', 'true');
          answer.style.maxHeight = answer.scrollHeight + 'px';
        }
      });

      // Keyboard: Enter or Space to toggle
      question.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          question.click();
        }
      });
    });
  }

  // ============================================================
  // 10. SCROLL REVEAL ANIMATIONS
  // ============================================================

  function initScrollReveal() {
    var elements = document.querySelectorAll('.fade-in, .slide-up');
    if (!elements.length) return;

    // Respect reduced motion
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      elements.forEach(function (el) { el.classList.add('revealed'); });
      return;
    }

    if (!('IntersectionObserver' in window)) {
      elements.forEach(function (el) { el.classList.add('revealed'); });
      return;
    }

    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('revealed');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

    elements.forEach(function (el) { observer.observe(el); });
  }

  // ============================================================
  // INITIALIZE ON DOM READY
  // ============================================================

  document.addEventListener('DOMContentLoaded', function () {
    // Inject shared components first
    buildHeader();
    buildFooter();

    // Then initialize all interactive features
    setActiveNavLink();
    initMobileMenu();
    initStickyHeader();
    initSmoothScroll();
    initNetlifyForms();
    initServicesPills();
    initSICards();
    initSIFaq();
    initScrollReveal();
  });

})();
