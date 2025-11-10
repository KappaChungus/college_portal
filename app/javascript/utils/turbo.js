// Turbo navigation helpers

/**
 * Setup Turbo navigation handlers for data loading
 * @param {Function} loadDataFn - Function to call when page loads
 * @param {Function} resetStateFn - Function to call before cache (optional)
 */
export function setupTurboHandlers(loadDataFn, resetStateFn = null) {
  // Load data when page loads
  document.addEventListener('turbo:load', loadDataFn);

  // Reset state before caching (optional)
  if (resetStateFn) {
    document.addEventListener('turbo:before-cache', resetStateFn);
  }

  // Cleanup on unmount
  return () => {
    document.removeEventListener('turbo:load', loadDataFn);
    if (resetStateFn) {
      document.removeEventListener('turbo:before-cache', resetStateFn);
    }
  };
}

/**
 * Execute function on Turbo load
 * @param {Function} fn - Function to execute
 */
export function onTurboLoad(fn) {
  document.addEventListener('turbo:load', fn);
}

/**
 * Execute function before Turbo cache
 * @param {Function} fn - Function to execute
 */
export function beforeTurboCache(fn) {
  document.addEventListener('turbo:before-cache', fn);
}
