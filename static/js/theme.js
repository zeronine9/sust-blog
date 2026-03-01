// DevBlog — Dark Mode Theme Toggle
// Persists preference in localStorage

const html = document.documentElement;
const toggleBtn = document.getElementById('themeToggle');
const themeIcon = document.getElementById('themeIcon');

function applyTheme(theme) {
    html.setAttribute('data-theme', theme);
    if (theme === 'dark') {
        themeIcon.className = 'bi bi-sun-fill';
        toggleBtn.title = 'Switch to light mode';
    } else {
        themeIcon.className = 'bi bi-moon-stars-fill';
        toggleBtn.title = 'Switch to dark mode';
    }
}

// Load saved theme or default to light
const savedTheme = localStorage.getItem('devblog-theme') || 'light';
applyTheme(savedTheme);

toggleBtn.addEventListener('click', () => {
    const current = html.getAttribute('data-theme');
    const next = current === 'dark' ? 'light' : 'dark';
    applyTheme(next);
    localStorage.setItem('devblog-theme', next);
});
