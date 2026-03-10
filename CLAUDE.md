# MACH-I Cardiology Website

## What This Is
This is the website for MACH-I (Medical Aerospace Cardiology & Hypertension Institute), the practice of Dr. Eddie Davenport and Dr. Jason Young. The site helps pilots who need FAA Special Issuance medical certificates after cardiac events find and contact the practice.

## Site Overview
- **Live URL:** [will be updated with final domain]
- **Hosting:** Netlify (Dr. D's account)
- **Tech:** Static HTML, CSS, JavaScript — no frameworks
- **Repository:** GitHub (txcfi-scott/MACH-I-Website)

## Pages
| File | Page | Purpose |
|------|------|---------|
| `index.html` | Homepage | Hero, trust bar, services overview, CTAs to intake form |
| `about.html` | About Us | Dr. Davenport and Dr. Young bios, credentials, philosophy |
| `services.html` | Services | 6 service categories with pricing |
| `special-issuance.html` | Special Issuance | Expanding condition cards, FAQ accordion |
| `publications.html` | Publications | NATO series, awards, speaking, leadership roles |
| `contact.html` | Contact | Contact form, map, office info |
| `intake.html` | Patient Intake | Intake form (noindex — not in search engines) |
| `thank-you.html` | Thank You | Form submission confirmation (noindex) |

## Key Files
- `css/styles.css` — All styling. Uses CSS custom properties (variables) for colors/spacing.
- `js/main.js` — Shared header/footer injection, accordion functionality, scroll animations.
- `netlify.toml` — Security headers and caching rules.
- `sitemap.xml` — SEO sitemap (update if adding new pages).
- `img/` — Stock photos used across pages.
- `favicon.svg` — The "M I" logo favicon.

## Design System
- **Colors:** Navy (#1a1f36), Blue (#2563eb), Gold (#d4a843), White
- **Fonts:** System font stack (no external fonts)
- **Style:** Professional, authoritative, clean — appropriate for a medical practice

## How to Deploy
Always commit and push to GitHub first, then deploy:
```
git add -A
git commit -m "Description of changes"
git push
netlify deploy --prod --dir=.
```

## How to Make Changes
Dr. D (Eddie) uses Claude Code to make changes by describing what he wants in plain English:

**Examples:**
- "Update the AME exam price to $350"
- "Change the office phone number to 555-123-4567"
- "Add a new condition card for hypertrophic cardiomyopathy"
- "Update my bio to mention the Milan keynote"
- "Add a testimonial from a pilot"

After making changes, always deploy so the live site is updated.

## Content Voice & Tone
- **Authoritative but approachable** — Dr. D is a world expert, but pilots should feel comfortable reaching out
- **Pilot-first language** — "get back in the cockpit," "return to flying," not generic medical language
- **Confidence without arrogance** — Emphasize experience and track record
- **Action-oriented** — Always guide toward the intake form or contact
- **Dr. Davenport** is referred to as "Dr. Davenport" on the site, never "Dr. D" or "Eddie"
- **Dr. Young** is the practice partner — his bio and role should be kept current

## Important Notes
- Dr. D is not a developer — keep all explanations simple and jargon-free
- The site uses Netlify Forms for both contact and intake forms — no backend needed
- Images are in `img/` — stock photos with navy gradient overlays
- The header and footer are injected by JavaScript (defined in `js/main.js`), not repeated in each HTML file
- When adding new pages, also update the sitemap.xml and the nav in js/main.js
- SEO: Each page has meta descriptions, canonical URLs, and the homepage has JSON-LD schema markup

## Support
If something breaks or you need help beyond what Claude can do, contact Scott.
