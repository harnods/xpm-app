/* ── app.js — Shared utilities for XPM MPA prototype ── */

/**
 * Show a transient toast message inside #phone.
 * @param {string} message  Text to display
 * @param {string} [kind]   CSS modifier class e.g. 'success'
 */
function showToast(message, kind) {
  const phone = document.getElementById('phone');
  if (!phone) return;
  let t = document.getElementById('app-toast');
  if (!t) {
    t = document.createElement('div');
    t.id = 'app-toast';
    t.className = 'app-toast';
    phone.appendChild(t);
  }
  t.className = 'app-toast' + (kind ? ' ' + kind : '');
  t.innerHTML = '<i class="ti ti-circle-check"></i><span>' + message + '</span>';
  t.classList.remove('visible');
  void t.offsetWidth; // force reflow to restart animation
  t.classList.add('visible');
  clearTimeout(showToast._t);
  showToast._t = setTimeout(function() { t.classList.remove('visible'); }, 2600);
}
