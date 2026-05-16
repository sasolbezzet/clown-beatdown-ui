const { chromium } = require('playwright');

(async () => {
  // Launch browser (headless or with UI)
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();

  // Go to DuckDuckGo and search for "arc tesnet"
  await page.goto('https://duckduckgo.com');
  await page.fill('input[name="q"]', 'arc tesnet');
  await page.press('input[name="q"]', 'Enter');

  // Wait for search results to appear
  await page.waitForSelector('a.result__a');

  // Extract titles of results
  const titles = await page.$$eval('a.result__a', links =>
    links.map(l => l.textContent?.trim())
  );

  console.log('Titel hasil pencarian:');
  titles.forEach(t => console.log(' •', t));

  // Save a screenshot for visual verification
  await page.screenshot({ path: 'arc_tesnet_search.png', fullPage: true });

  await browser.close();
})();