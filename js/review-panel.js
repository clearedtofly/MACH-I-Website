/**
 * MACH-I Test Site Review Panel
 * Appears on test.mach1cardiology.com only.
 * Lists pending changes for Dr. Davenport's review.
 * REMOVE THIS SCRIPT TAG before merging to main / going live.
 */

(function () {
  const changes = [
    {
      category: 'Credentials & Language',
      items: [
        'Replaced "FAA\'s go-to cardiovascular specialist" with "internationally recognized expert in Aerospace Cardiology, Federal Air Surgeon-appointed Cardiovascular Specialty Consultant" — across homepage and About page.',
        'Added USAFSAM as Dr. Davenport\'s current role (Chief of Cardiology, U.S. Air Force School of Aerospace Medicine) to the bio and credentials section.',
        'Updated bio to make clear USAFSAM is a current role, not a past one — added context that all USAF/ANG/AFRES pilots come to WPAFB.',
        'Added all military branches to credentials: Air Force, Space Force, Army, Navy, Marines, Coast Guard — reflecting Dr. Davenport\'s cross-branch consulting role.',
      ]
    },
    {
      category: 'Homepage Design',
      items: [
        'Hero subtitle shortened from 60 words to 25 — faster read for pilots in distress scanning the page.',
        'Trust bar: "All USAF Waiver Guides Since 2009" → "Every USAF Cardiac Waiver Guide Since 2009" (clearer).',
        'Trust bar: "Col. USAF (Ret.)" → "USAFSAM Chief of Cardiology" (reflects current role).',
        'Added Professional Affiliations & Service bar with 9 logos: FAA, U.S. Air Force, Space Force, NASA, NATO, Navy, Marines, Army, Coast Guard.',
        'Added subtle gold divider between the two dark navy sections on the homepage.',
      ]
    },
    {
      category: 'About Page',
      items: [
        'Page title updated: "The FAA\'s Cardiovascular Specialist" → "Internationally Recognized Expert in Aerospace Cardiology".',
        'Headshot upgraded from a small 120px circle avatar to a full 280px portrait with gold border.',
      ]
    },
    {
      category: 'Services Page',
      items: [
        'MedXPress callout box added to AME exam section — prominent blue box with button linking to medxpress.faa.gov, so patients know to complete it before their appointment.',
        'Page HTML reformatted from compressed one-liners to properly indented code — makes future edits safe and easy.',
      ]
    },
    {
      category: 'Infrastructure',
      items: [
        'Repo transferred to Dr. Davenport\'s GitHub account (clearedtofly/MACH-I-Website). Scott remains a collaborator.',
        'Test site created: test.mach1cardiology.com — all future changes reviewed here before going live.',
        'GitHub → Netlify auto-deploy wired up: pushing to main branch now automatically updates the live site.',
      ]
    },
  ];

  const style = document.createElement('style');
  style.textContent = `
    #machi-review-panel {
      position: fixed;
      bottom: 0;
      left: 0;
      right: 0;
      z-index: 99999;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      font-size: 14px;
    }
    #machi-review-bar {
      background: #1a1f36;
      border-top: 3px solid #d4a843;
      padding: 10px 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      flex-wrap: wrap;
      cursor: pointer;
      user-select: none;
    }
    #machi-review-bar:hover { background: #222840; }
    #machi-review-bar-left {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .machi-review-badge {
      background: #d4a843;
      color: #1a1f36;
      font-weight: 700;
      font-size: 11px;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      padding: 3px 9px;
      border-radius: 3px;
    }
    #machi-review-bar-title {
      color: #ffffff;
      font-weight: 600;
    }
    #machi-review-bar-sub {
      color: rgba(255,255,255,0.55);
      font-size: 12px;
    }
    #machi-review-toggle {
      color: #d4a843;
      font-weight: 600;
      font-size: 13px;
      white-space: nowrap;
    }
    #machi-review-drawer {
      background: #f8f9fb;
      border-top: 1px solid #e5e7eb;
      max-height: 55vh;
      overflow-y: auto;
      display: none;
      padding: 24px 24px 32px;
    }
    #machi-review-drawer.open { display: block; }
    .machi-review-header {
      margin-bottom: 20px;
    }
    .machi-review-header h3 {
      font-size: 16px;
      font-weight: 700;
      color: #1a1f36;
      margin: 0 0 4px;
    }
    .machi-review-header p {
      font-size: 13px;
      color: #6b7280;
      margin: 0;
    }
    .machi-section { margin-bottom: 20px; }
    .machi-section-title {
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: #d4a843;
      margin-bottom: 8px;
    }
    .machi-section ul {
      margin: 0;
      padding: 0;
      list-style: none;
    }
    .machi-section ul li {
      padding: 6px 0 6px 20px;
      position: relative;
      border-bottom: 1px solid #e5e7eb;
      color: #374151;
      line-height: 1.5;
    }
    .machi-section ul li:last-child { border-bottom: none; }
    .machi-section ul li::before {
      content: '✓';
      position: absolute;
      left: 0;
      color: #16a34a;
      font-weight: 700;
    }
    #machi-review-footer {
      margin-top: 20px;
      padding-top: 16px;
      border-top: 2px solid #1a1f36;
      display: flex;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }
    #machi-review-footer p {
      color: #374151;
      font-size: 13px;
      margin: 0;
      flex: 1;
    }
    #machi-review-footer strong { color: #1a1f36; }
  `;
  document.head.appendChild(style);

  const totalChanges = changes.reduce((n, c) => n + c.items.length, 0);

  const panel = document.createElement('div');
  panel.id = 'machi-review-panel';
  panel.innerHTML = `
    <div id="machi-review-bar">
      <div id="machi-review-bar-left">
        <span class="machi-review-badge">Test Site</span>
        <span id="machi-review-bar-title">Changes Pending Dr. Davenport's Review</span>
        <span id="machi-review-bar-sub">${totalChanges} changes across ${changes.length} areas</span>
      </div>
      <span id="machi-review-toggle">View Changes ▲</span>
    </div>
    <div id="machi-review-drawer">
      <div class="machi-review-header">
        <h3>Changes Pending Review — test.mach1cardiology.com</h3>
        <p>Review each item below. When approved, Scott will merge to the live site and this panel disappears.</p>
      </div>
      ${changes.map(cat => `
        <div class="machi-section">
          <div class="machi-section-title">${cat.category}</div>
          <ul>${cat.items.map(item => `<li>${item}</li>`).join('')}</ul>
        </div>
      `).join('')}
      <div id="machi-review-footer">
        <p><strong>To approve:</strong> Reply to Scott with "looks good" or any change requests and he'll update the test site before going live.</p>
      </div>
    </div>
  `;
  document.body.appendChild(panel);

  let open = false;
  document.getElementById('machi-review-bar').addEventListener('click', function () {
    open = !open;
    const drawer = document.getElementById('machi-review-drawer');
    const toggle = document.getElementById('machi-review-toggle');
    drawer.classList.toggle('open', open);
    toggle.textContent = open ? 'Hide Changes ▼' : 'View Changes ▲';
  });
})();
