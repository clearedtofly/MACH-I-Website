## Checkpoint: SEO Overhaul & Search Visibility Fix (2026-03-19)

### What Was Done
- **Root cause found:** All canonical URLs, og:url, JSON-LD, sitemap.xml, robots.txt still referenced old domain (medicalaerospacecardiology.com). Google had ZERO pages indexed for mach1cardiology.com.
- **Domain references fixed:** Updated all canonical URLs, og:url, JSON-LD schema across all 6 public HTML files to mach1cardiology.com
- **Old Wix path redirects added:** /home, /about-1, /plans-pricing, /copy-of-home, /service-page/* all 301 redirect to correct new pages in netlify.toml
- **Fixed /home bug:** Was serving 200 instead of redirecting (removed from _redirects file)
- **Google Analytics 4 installed:** Measurement ID G-9E6CKN660Z, injected via main.js, CSP headers updated
- **Google Search Console set up:** mach1cardiology.com verified, sitemap submitted
- **Google Business Profile created:** Pending postcard verification at office address
- **Comprehensive SEO overhaul (693cde2):**
  - Enhanced JSON-LD schemas: MedicalClinic (with services/geo/hours), Physician, FAQPage (11 Qs), MedicalWebPage (11 conditions), Service with pricing, BreadcrumbList on all pages
  - Geo meta tags, Twitter Cards, author, robots directives, og:locale on all pages
  - Keyword-optimized title tags and meta descriptions (condition-specific, pricing in services title)
  - New content sections: "Who We Help", "Find Your Condition" (index), "Aviation Cardiology Expertise" (about), "BasicMed vs Special Issuance" (special-issuance), expanded travel info (contact)
  - 3 new FAQ items: "Can I fly after a heart attack?", "aviation cardiologist near me", "FAA denial appeal"
  - Footer: keyword-rich link text + new Conditions column on every page
  - Image alt text optimization, internal cross-linking improvements
  - Sitemap: clean URLs, changefreq tags
- **Email authentication complete:** SPF + DKIM + DMARC all configured and verified
- **Dual-repo issue found & fixed:** mach1cardiology.com serves from clearedtofly/MACH-I-Website (Eddie's repo), not txcfi-scott. Must push to both remotes. clearedtofly remote added.
- **Eddie's Netlify API token saved:** macOS Keychain (netlify.eddie / drd@mach1cardiology.com)
- **dr-d-review.html blocked** in robots.txt

### Still Outstanding
- **Google Business Profile:** Eddie needs to enter postcard verification code when it arrives (after Mar 28)
- **Old domain in Search Console:** medicalaerospacecardiology.com needs TXT verification via Wix DNS — requires Eddie's phone for Wix 2FA. Then use Change of Address tool.
- **DKIM activation:** Click "Start authentication" in Google Admin (Apps > Gmail > Authenticate email) — may have been done by Scott this session
- **Request indexing:** Quota hit today. Return tomorrow to request indexing for remaining pages.
- **Bing Webmaster Tools:** Submit site at bing.com/webmasters
- **Directory listings:** Update Doximity, WebMD, Healthgrades, US News, Vitals with new URL (mach1cardiology.com)
- **DMARC tightening:** Once DKIM is confirmed working, change DMARC from p=none to p=quarantine
- **GitHub repo consolidation:** Once clearedtofly accepts repo transfer, consolidate to single repo/site
- **Content strategy:** Blog posts targeting pilot search queries (future initiative)

---

## Checkpoint — 2026-03-19 (DMARC + DKIM setup)

**What was done:**
- Added DMARC TXT record to Netlify DNS via Eddie's Netlify API:
  - `_dmarc.mach1cardiology.com` -> `v=DMARC1; p=none; rua=mailto:DrD@mach1cardiology.com; pct=100; adkim=r; aspf=r`
  - Policy is `p=none` (monitor only) -- safe to start, tighten to `p=quarantine` or `p=reject` once DKIM is confirmed working
- Retrieved and saved Eddie's Netlify API token to macOS Keychain (`netlify.eddie` / `drd@mach1cardiology.com`)
- Updated services.md with Eddie's Netlify account details
- Verified all email DNS records: SPF, MX, DMARC all live and correct

**DKIM -- still needs Eddie's action:**
DKIM requires a key generated in Google Admin Console. Eddie (or Scott in a session with Eddie) needs to:
1. Go to https://admin.google.com
2. Sign in as DrD@mach1cardiology.com
3. Navigate: Apps > Google Workspace > Gmail > Authenticate email
4. Click "Generate new record" (selector prefix: `google`, key length: 2048-bit)
5. Copy the TXT record value (starts with `v=DKIM1; k=rsa; p=...`)
6. Add it as a DNS record. The command to add via API:
   ```bash
   EDDIE_TOKEN=$(security find-generic-password -s "netlify.eddie" -a "drd@mach1cardiology.com" -w)
   curl -X POST -H "Authorization: Bearer $EDDIE_TOKEN" -H "Content-Type: application/json" \
     -d '{"type":"TXT","hostname":"google._domainkey.mach1cardiology.com","value":"THE_DKIM_KEY_HERE","ttl":3600}' \
     "https://api.netlify.com/api/v1/dns_zones/69af9f80844e4495959b199e/dns_records"
   ```
7. Back in Google Admin, click "Start authentication"
8. Wait ~48h, then tighten DMARC to `p=quarantine`

**Current email DNS status:**
- SPF: `v=spf1 include:_spf.google.com ~all` -- LIVE
- MX: All 5 Google Workspace records -- LIVE
- DMARC: `v=DMARC1; p=none; ...` -- LIVE (just added)
- DKIM: NOT YET CONFIGURED (needs Google Admin Console)

---

## Checkpoint — 2026-03-19 (Domain fix)

**Branch:** main
**Issue:** mach1cardiology.com was serving old content while mach-i-cardiology.netlify.app had the new content.
**Root cause:** Two separate Netlify sites exist:
1. `mach-i-cardiology` on TXCFI team account (Scott's) — deploys from `txcfi-scott/MACH-I-Website` — has NO custom domain
2. `mach-i-cardiology-website` (or similar) on Dr. D's Netlify account — deploys from `clearedtofly/MACH-I-Website` — owns `mach1cardiology.com` domain + Netlify DNS
Dr. D's repo was stale (last push Mar 10), while Scott's repo had newer commits. The domain pointed to Dr. D's site with old content.
**Fix:** Force-pushed Scott's repo (latest code) to Dr. D's repo (`clearedtofly/MACH-I-Website`), triggering a redeploy on the site that owns the domain. Verified mach1cardiology.com now serves the new content with correct canonical URLs and working redirects.
**Also deployed:** to TXCFI Netlify site (`mach-i-cardiology.netlify.app`) to keep both in sync.

**Architectural note:** There is a dual-site problem that should be resolved long-term:
- Either transfer the domain to the TXCFI site and delete Dr. D's site, or
- Consolidate to a single repo and single Netlify site
- For now, both repos need to be kept in sync when deploying changes

**Next step:** Consider consolidating to a single Netlify site + single repo to avoid this happening again.

---

## Checkpoint — 2026-03-03 (Logo integration)

**Branch:** main
**Last action:** Added real MACH-I logo to header and footer, deployed to Netlify
**Next step:** QA the live site — check logo renders correctly on nav and footer
**Blockers:** None

Logo assets created:
- `img/mach-i-logo.png` — 320x157px, transparent bg (general use)
- `img/mach-i-logo-small.png` — 91x45px for nav header
- `img/mach-i-logo-med.png` — 160x78px for footer
Both header and footer logos use `filter: brightness(0) invert(1)` for white silhouette on navy background.

---

## Checkpoint — 2026-03-03

**Branch:** main (all revision changes merged and pushed)
**Last action:** Elon completed final project review — sprint graded A, recommendation: SHIP
**Next step:** Verify Netlify deploy, send dr-d-review.html to Dr. D for sign-off
**Blockers:** None
**Running services:** None

---

# Working Notes — MACH-I Website Revision Sprint

## Project Status: COMPLETE — READY FOR CLIENT REVIEW

## Sprint Summary
9-phase revision sprint implementing all of Dr. D's feedback from "Web Site changes.docx". All phases executed, all acceptance criteria met, all verification checks passed.

### What Was Done
1. **Removed Dr. Young and all pulmonary content** across all pages (preserved in HTML comments for future)
2. **Updated home page** — credentials, messaging, NATO role fix, "thousands" not "hundreds"
3. **Rewrote about page bio** with full CV highlights, added headshot
4. **Major services page revamp** — executive cardio eval, free consultation banner, speaking engagements
5. **Added CVG/CMH airports** to special issuance FAQ and contact page
6. **Site-wide consistency pass** — NATO title, orphaned links, CSS cleanup
7. **Full UI/UX review** at desktop/tablet/mobile viewports
8. **Fixed P2 issues** (gold callout box), cleaned orphaned CSS
9. **Created dr-d-review.html** — integrated review page with change summary and 13-item checklist

### Commits (8 revision commits)
```
e467cee  Add Dr. Davenport headshot for about page
7936965  Remove Dr. Young and all pulmonary references per client feedback
b72c5aa  Update home page content per Dr. D feedback — credentials, messaging, NATO role
e0a44fb  Enhance Dr. D about page bio with CV highlights, headshot, and credential updates
69f00fa  Update special issuance FAQ and contact page — airports, travel info, hours
8948d03  Revamp services page — executive cardio eval, speaking engagements, consultation updates
1c861ad  Site-wide consistency pass — verify all feedback changes, fix orphaned refs
cda8713  Add Dr. D review page with change summary and checklist
8c6a6da  Fix UI issues found in post-revision review
```

### Final Review
`build-monitor/reports/final-review.md` — comprehensive review with checklist, grep verification, risk assessment, and sprint grade (A).

### Open Items for Future Work
- Verify Netlify auto-deploy succeeded and live site reflects all changes
- Test contact and intake form submissions on live site
- Contact page hours: using 8-5 default; revisit if Dr. D prefers evening/Saturday hours
- Logo photo (`feedback/We made LOGO on DOOR of OFFICE.PNG`) unused — may need for future branding
- Pulmonary services ready to re-enable when Dr. Young joins (HTML comments preserved)
- New email setup (separate project — Mac Studio sessions)
- Encrypted inbox for medical records (separate project)
- Testimonials system (future feature)

## Previous State (preserved)
The Mac Studio setup plan (Sessions 1-3) remains valid and is tracked in `setup/` directory. That work is independent of this revision sprint.

---

## Checkpoint — 2026-03-03 10:32:28

**Branch:** main
**Uncommitted changes:** M working-notes.md
**Session work:**
- Completed full Dr. D feedback revision sprint (9 phases + final review)
- Removed Dr. Young and all pulmonary content site-wide
- Updated home page credentials, messaging, NATO role
- Rewrote about page bio with CV highlights, added upscaled headshot
- Major services page revamp — Executive Cardiovascular Evaluation, free consultation banner, speaking engagements
- Added CVG/CMH airports to special issuance FAQ and contact page
- Site-wide consistency pass, UI/UX review, final fixes
- Created dr-d-review.html — interactive review page with 13-item checklist for Dr. D
- Processed and integrated MACH-I logo (heart+wings) — full-color banner above nav + white silhouette in footer
- All pushed to GitHub and deployed to https://mach-i-cardiology.netlify.app
- Elon final review: SHIP — Grade A
- Team retrospective completed, memory files updated

**Next step:** Send Dr. D the review page link (https://mach-i-cardiology.netlify.app/dr-d-review.html) for his sign-off on 13 items. Key ask: high-res headshot photo.
**Blockers:** Need Dr. D's review/sign-off. Need original high-res headshot. Netlify auto-deploy not wired up (using manual `netlify deploy --prod --dir=.`).
**Notes:** Contact hours kept as 8-5 Mon-Fri virtual availability (Dr. D's default preference). Logo on office door photo processed to transparent PNG. Pulmonary content preserved in HTML comments for future re-addition. Sprint retro lessons saved to agents/memory/shared.md and pepper.md.

---

## 2026-03-05 — Tech Stack Scoping for Dr. D's Practice

### What Was Done
- Reviewed existing HIPAA file sharing research (research/hipaa-file-sharing.md)
- Scoped complete tech stack for Dr. D's medical practice:
  - Google Workspace (already purchased) for email + calendar
  - OpenClaw (self-hosted, Docker) for CRM/automation with OpenAI OAuth
  - Patient Gain ($99/mo) for HIPAA-compliant medical records transfer
  - Claude Code for website self-service editing
  - GitHub for version control + remote safety net (auto-push via launchd)
  - Tailscale for remote support access
  - Netlify auto-deploy from GitHub
- Created comprehensive meeting runbook: research/dr-d-tech-stack-setup.md (861 lines, 12 phases, ~6 hour meeting)
- Created prep/ directory with:
  - CLAUDE.md guardrails for Dr. D's website project
  - launchd auto-push plist + shell script + installer
  - .gitignore files for website and OpenClaw repos
  - Installer download checklist with URLs
  - Draft email to Dr. D requesting pre-meeting info

### Key Decisions
- Google Workspace instead of Fastmail (Dr. D already purchased it)
- OpenAI OAuth for OpenClaw (not Anthropic)
- Keep HIPAA compliance confined to Patient Gain file transfers — no PHI in email/calendar
- Everything pushes to GitHub automatically so Scott can help remotely
- Tailscale node sharing (free) for remote access — separate accounts, shared device

### Monthly Cost for Dr. D
- Patient Gain: $99
- Anthropic (Claude Code): ~$20
- OpenAI (OpenClaw): ~$20
- Google Workspace: already purchased
- Tailscale, GitHub, Netlify: free
- **Total: ~$139/mo**

### Next Steps
- [ ] Send email to Dr. D requesting pre-meeting info
- [ ] Get domain registrar access and do DNS changes 24-48h before meeting
- [ ] Pre-build OpenClaw skills on Scott's instance (lead intake, appointment manager, patient contacts, secure upload trigger, recall/follow-up, daily briefing)
- [ ] Download all installers to USB drive
- [ ] Pre-pull OpenClaw Docker image
- [ ] Schedule the 6-hour meeting
- [ ] Get Dr. D's high-res headshot

### Open Questions (Need Dr. D's Input)
- Email address format preference
- Domain registrar login
- GitHub account (existing or create new?)
- Mac Studio specs and current state
- Preferred notification channel (email only? Telegram? SMS?)
- Calendar — anything to migrate?

## Checkpoint — 2026-03-05 14:09:16

**Branch:** main
**Uncommitted changes:** None (all pushed to GitHub)
**Session work:**
- Scoped complete tech stack for Dr. D's medical practice (Google Workspace, OpenClaw, Patient Gain, Claude Code, GitHub, Tailscale, Netlify)
- Created comprehensive FaceTime meeting runbook (research/dr-d-tech-stack-setup.md) — 4-step structure: Tailscale → Scott SSHs + installs → accounts → training (~2 hours)
- Built complete OpenClaw "Mach 1 Front Desk" agent (prep/openclaw/) — 25 files: workspace, templates, hooks, cron jobs, config
- Created all prep materials (prep/) — CLAUDE.md guardrails, auto-push launchd, .gitignore files, installer download script, email draft to Eddie
- Confirmed mach1cardiology.com registered by Dr. D today (Squarespace, Google DNS)
- Verified Tailscale running on Scott's machine (100.65.205.84)
- Saved end-of-session git commit rule to project memory

**Next step:** Send email to Eddie (prep/email-to-dr-d-meeting-prep.md — HTML preview at prep/email-preview.html). Once he replies with Squarespace login, do DNS changes 24-48h before the FaceTime call.

**Blockers:**
- Need Eddie's Squarespace domain registrar login (for DNS/MX changes)
- Need Eddie to confirm mach1cardiology.com as primary domain + email
- Need Eddie to confirm redirect of medicalaerospacecardiology.com to new site
- Need to schedule the FaceTime call (~2 hours)

**Pre-call prep still TODO:**
- Run download-installers.sh to pre-download Docker/Tailscale/Node.js
- Pre-pull OpenClaw Docker image (docker save)
- DNS changes once registrar access obtained
- Test OpenClaw agent on Scott's instance before deploying to Eddie's

**Notes:** Meeting is via FaceTime, not in-person. Eddie installs Tailscale, Scott SSHs in and does everything else. OpenClaw uses OpenAI (gpt-4o), not Anthropic. Gmail bridge hook and Netlify webhook hook are skeleton/TODO — need testing. No PHI in email/calendar — Patient Gain handles HIPAA file transfers.

--- Checkpoint saved before context clear ---

---

## Checkpoint — 2026-03-10

**Branch:** main (pushed to GitHub)
**Session:** Dr. D and Scott — live setup session on Eddie's Mac Studio (Scott remoted in via Tailscale)

### What Was Done
- **Google Workspace email activated** — drd@mach1cardiology.com created and live
- **Gmail activated** on mach1cardiology.com domain, DKIM enabled
- **Netlify CLI installed** on Mac Studio (via Homebrew)
- **Site deployed** to Dr. D's Netlify account (team: MACH I) — mach1cardiology.com
- **Custom domain connected** — mach1cardiology.com set as primary domain
- **Netlify DNS activated** — nameservers updated in Squarespace to Netlify's ns1-4.p04.nsone.net
- **Google MX records added** to Netlify DNS zone (all 5 priority records + SPF TXT)
- **SSL certificate provisioned** — DNS verification passed, Let's Encrypt cert issued
- **Clean URL redirects added** to netlify.toml (no .html extension needed for any page)
- **Netlify Forms enabled** — contact and intake forms detected
- **Form email notifications configured:**
  - drd@mach1cardiology.com (primary — pending MX propagation)
  - medicalaerospacecardiology@gmail.com (backup — confirmed working)
- **End-to-end test passed** — form submission received in Gmail

### Current State
- Site: https://mach1cardiology.com — LIVE ✅
- Email: drd@mach1cardiology.com — provisioned, MX propagating (may take up to 1 hour)
- Forms: working, notifications going to Gmail backup
- Netlify site name: mach-i-cardiology-website

### Backlog — Next Session
**Quick (do first):**
- [ ] Set up local dev server for testing before pushing to live (e.g. `netlify dev` — serves site locally with forms + redirects working, so changes can be previewed before deploy)
- [ ] Verify drd@mach1cardiology.com receives email once MX propagates (~1 hour after session)
- [ ] Remove medicalaerospacecardiology@gmail.com backup notification once primary email confirmed
- [ ] Transfer repo from txcfi-scott/MACH-I-Website → Dr. D's GitHub account (he has one); Scott stays as collaborator; update git remote on Mac Studio
- [ ] Wire up auto-deploy: GitHub → Netlify (so `git push` auto-deploys the site)
- [ ] Set git config on Mac Studio (name + email for commits)
- [ ] Redirect medicalaerospacecardiology.com → mach1cardiology.com (via Wix domain redirect)

**Next session:**
- [ ] OpenClaw setup — install Docker Desktop, deploy Mach 1 Front Desk agent, configure skills
- [ ] Patient Gain account — create together, wire up to OpenClaw secure upload trigger
- [ ] OpenAI account + API key (for OpenClaw AI backend)
- [ ] Claude Code training — show Dr. D how to edit the site himself
- [ ] GitHub account for Dr. D — confirm username, add as repo owner

### Netlify DNS Zone ID
`69af9f80844e4495959b199e` (mach1cardiology.com zone in Netlify DNS)

## Checkpoint — 2026-03-10 01:45:00

**Branch:** main
**Uncommitted changes:** None (all pushed)
**Session work:**
- Deployed site to Dr. D's Netlify account (mach-i-cardiology-website)
- Connected mach1cardiology.com as primary domain with Netlify DNS
- Added Google Workspace MX + SPF records to Netlify DNS zone
- SSL cert provisioned and live
- Clean URL redirects added (no .html needed)
- Netlify Forms enabled, email notifications to drd@mach1cardiology.com + medicalaerospacecardiology@gmail.com (backup)
- Forms tested end-to-end — working
- medicalaerospacecardiology.com added as domain alias, redirects to mach1cardiology.com
- QR code generated: img/mach1cardiology-qr.png (1000x1000, for presentations)

**Next step:** Commit QR code to repo, then start next session backlog (dev server, GitHub transfer, auto-deploy)
**Blockers:**
- MX records for drd@mach1cardiology.com still propagating (check in Gmail — may be live by now)
- medicalaerospacecardiology.com redirect pending Wix DNS propagation (~1 hour)
**Notes:** Dr. D is on his Mac Studio. Scott remoted in via Tailscale. Netlify CLI installed and authenticated on Mac Studio. Git committer currently shows Eddie's name — needs git config set up next session.

## Checkpoint — 2026-03-10 17:58:26

**Branch:** main
**Uncommitted changes:** ?? "img/High res headshot.jpg", ?? prep/studio-setup.sh
**Session work:**
- Live meeting with Eddie — set up his Mac Studio remotely via Tailscale + SSH
- Installed Homebrew, Node.js, Git, Claude Code on Mac Studio (edave user account)
- Created GitHub account for Eddie: username clearedtofly, email DrD@mach1cardiology.com
- Added Eddie as collaborator on MACH-I-Website repo (push access)
- Pushed agents framework to new private repo txcfi-scott/claude-agents, added Eddie as collaborator
- Created and pushed CLAUDE.md to website repo for Claude Code project context
- Cloned both repos on Studio: ~/Projects/mach-i-website and ~/Claude/agents
- Installed slash commands (pepper, bootstrap, checkpoint, mailbox) to ~/.claude/commands/ on Studio
- Created studio-bootstrap.sh — single master setup script for future runs
- Saved all Eddie's credentials to ~/Claude/agents/memory/services.md (Google Workspace, Squarespace, Wix, GitHub, Mac Studio)
- Initiated repo transfer of MACH-I-Website to clearedtofly (pending acceptance)
- Composed Pat Brown / Mad Props Aero intro email for Dr. D special issuance segment
- Two macOS user accounts on Studio: edave (primary, Eddie uses daily) and eddiedavenport (admin, initial setup). All work moved to edave.
- Homebrew ownership fixed for edave user

**Next step:**
- Eddie needs to accept GitHub repo transfer notification
- Run studio-bootstrap.sh on Studio to finalize (pmset sleep disable, SSH keys, git identity)
- Eddie needs to sign up for Claude Pro ($20/mo) or use free tier
- Send Pat Brown intro email
- Look through Eddie's Wix account to evaluate what he's paying for vs using
- Eddie available Mon-Thu 9pm for evening sessions; out of country Mar 15-28

**Blockers:**
- Repo transfer to clearedtofly pending (may need to retry from GitHub web UI)
- Still need Eddie's domain registrar access (Squarespace) for DNS changes
- Need to evaluate Wix vs current stack

**Notes:**
- Tailscale IP for Mac Studio: 100.88.145.73
- Mac Studio password: EDpdad12! (both accounts)
- edave is the primary user account, eddiedavenport was initial setup
- Tech stack info is out of date per Scott — skip Docker/OpenClaw for now, revisit later
- Studio has two user accounts causing Homebrew permission issues — fixed with sudo chown

--- Checkpoint saved before context clear ---
