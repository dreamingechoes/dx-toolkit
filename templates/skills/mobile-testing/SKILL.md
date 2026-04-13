---
name: mobile-testing
description: 'Testing strategy for mobile apps. Covers unit, integration, E2E with Detox/Maestro, screenshot testing, and device farm testing.'
---

# Mobile Testing

## Overview

Mobile testing is harder than web testing. You're dealing with two platforms, inconsistent device behavior, native module boundaries, and app store reviewers who find bugs you missed. The web test pyramid still applies — fast unit tests at the base, slower integration tests in the middle, E2E tests at the top — but mobile adds its own layers: screenshot testing for visual regressions, device farm testing for hardware diversity, and native module mocking for platform boundaries.

This skill sets up a testing strategy that catches bugs before your users (and Apple's reviewers) find them. Start with unit tests, build up through component tests, and top it off with E2E tests that actually run on real devices.

## When to Use

- Starting a new mobile project and need a testing strategy
- Adding tests to an existing app that has poor coverage
- Setting up E2E testing with Detox or Maestro
- Configuring device farm testing (Firebase Test Lab, AWS Device Farm)
- Adding screenshot testing for visual regression detection
- Integrating mobile tests into CI/CD

**When NOT to use:** Web-only projects (use standard browser testing). For general testing strategy across any tech, use the `testing-strategy` skill if available. This skill is specifically for mobile platform concerns.

## Process

### Step 1 — Define the Mobile Test Pyramid

The classic test pyramid adapted for mobile:

```
         ╱ ╲              E2E (Detox/Maestro)
        ╱   ╲             ~10% of tests, slowest
       ╱─────╲            Screenshot / Visual
      ╱       ╲           ~10% of tests
     ╱─────────╲          Component / Integration
    ╱           ╲         ~30% of tests
   ╱─────────────╲        Unit Tests
  ╱_______________╲       ~50% of tests, fastest
```

**Coverage targets by layer:**

| Layer      | What It Tests                               | Speed         | Target % |
| ---------- | ------------------------------------------- | ------------- | -------- |
| Unit       | Business logic, utilities, state management | <1s each      | 50%+     |
| Component  | Individual screens/components in isolation  | 1-5s each     | 30%      |
| Screenshot | Visual appearance across devices/themes     | 2-10s each    | 10%      |
| E2E        | Full user flows on real/simulated devices   | 30s-2min each | 10%      |

### Step 2 — Set Up Unit Testing

Unit tests cover pure business logic — anything that doesn't touch the UI or native modules.

**React Native (Jest):**

```typescript
// __tests__/utils/formatCurrency.test.ts
import { formatCurrency } from '@/utils/formatCurrency'

describe('formatCurrency', () => {
  it('formats USD with 2 decimal places', () => {
    expect(formatCurrency(1999, 'USD')).toBe('$19.99')
  })

  it('handles zero', () => {
    expect(formatCurrency(0, 'USD')).toBe('$0.00')
  })

  it('handles negative amounts', () => {
    expect(formatCurrency(-500, 'USD')).toBe('-$5.00')
  })
})
```

**State management tests (Redux/Zustand):**

```typescript
// __tests__/store/cartStore.test.ts
import { useCartStore } from '@/store/cartStore'

describe('cartStore', () => {
  beforeEach(() => {
    useCartStore.getState().clearCart()
  })

  it('adds item to cart', () => {
    useCartStore.getState().addItem({ id: '1', name: 'Widget', price: 999 })
    expect(useCartStore.getState().items).toHaveLength(1)
  })

  it('calculates total correctly', () => {
    const { addItem } = useCartStore.getState()
    addItem({ id: '1', name: 'Widget', price: 999 })
    addItem({ id: '2', name: 'Gadget', price: 1499 })
    expect(useCartStore.getState().total).toBe(2498)
  })
})
```

**iOS (XCTest / Swift Testing):**

```swift
import Testing
@testable import MyApp

struct CurrencyFormatterTests {
    @Test func formatsUSD() {
        #expect(CurrencyFormatter.format(cents: 1999, currency: .usd) == "$19.99")
    }

    @Test func handlesZero() {
        #expect(CurrencyFormatter.format(cents: 0, currency: .usd) == "$0.00")
    }
}
```

**Android (JUnit 5 + Kotlin):**

```kotlin
class CurrencyFormatterTest {
    @Test
    fun `formats USD with 2 decimal places`() {
        assertEquals("$19.99", CurrencyFormatter.format(1999, Currency.USD))
    }
}
```

### Step 3 — Configure Component Testing

Component tests render individual screens/components in isolation with mock data and verify behavior.

**React Native Testing Library:**

```typescript
// __tests__/components/ProductCard.test.tsx
import { render, fireEvent, screen } from '@testing-library/react-native';
import { ProductCard } from '@/components/ProductCard';

const mockProduct = {
  id: '1',
  name: 'Widget',
  price: 1999,
  imageUrl: 'https://example.com/widget.jpg',
};

describe('ProductCard', () => {
  it('renders product name and formatted price', () => {
    render(<ProductCard product={mockProduct} onAddToCart={jest.fn()} />);

    expect(screen.getByText('Widget')).toBeTruthy();
    expect(screen.getByText('$19.99')).toBeTruthy();
  });

  it('calls onAddToCart when button pressed', () => {
    const onAddToCart = jest.fn();
    render(<ProductCard product={mockProduct} onAddToCart={onAddToCart} />);

    fireEvent.press(screen.getByRole('button', { name: /add to cart/i }));
    expect(onAddToCart).toHaveBeenCalledWith('1');
  });

  it('shows out of stock state', () => {
    render(
      <ProductCard product={{ ...mockProduct, inStock: false }} onAddToCart={jest.fn()} />
    );

    expect(screen.getByText(/out of stock/i)).toBeTruthy();
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

**Mocking native modules:**

```typescript
// jest.setup.js — mock native modules that don't exist in test environment
jest.mock('react-native-device-info', () => ({
  getVersion: () => '1.0.0',
  getBuildNumber: () => '42',
  getUniqueId: () => 'test-device-id',
}))

jest.mock('@react-native-async-storage/async-storage', () =>
  require('@react-native-async-storage/async-storage/jest/async-storage-mock'),
)

jest.mock('react-native-reanimated', () => require('react-native-reanimated/mock'))
```

**Android Compose testing:**

```kotlin
@get:Rule
val composeTestRule = createComposeRule()

@Test
fun productCard_displaysNameAndPrice() {
    composeTestRule.setContent {
        ProductCard(
            product = Product(name = "Widget", price = 1999),
            onAddToCart = {}
        )
    }

    composeTestRule.onNodeWithText("Widget").assertIsDisplayed()
    composeTestRule.onNodeWithText("$19.99").assertIsDisplayed()
}
```

### Step 4 — Set Up E2E Testing (Detox / Maestro)

E2E tests run the full app on a simulator/device and tap through real user flows.

**Detox vs Maestro vs Appium:**

| Tool    | Platforms     | Language   | Flakiness | Speed  | Setup Complexity |
| ------- | ------------- | ---------- | --------- | ------ | ---------------- |
| Detox   | iOS + Android | JavaScript | Low       | Fast   | Medium           |
| Maestro | iOS + Android | YAML flows | Low       | Fast   | Low              |
| Appium  | iOS + Android | Any        | Higher    | Slower | High             |

**Maestro flow (YAML — lowest setup cost):**

```yaml
# .maestro/flows/login.yaml
appId: com.myapp
---
- launchApp
- tapOn: 'Email'
- inputText: 'test@example.com'
- tapOn: 'Password'
- inputText: 'testpass123'
- tapOn: 'Sign In'
- assertVisible: 'Welcome back'
```

```yaml
# .maestro/flows/add-to-cart.yaml
appId: com.myapp
---
- launchApp
- tapOn: 'Products'
- tapOn: 'Widget'
- tapOn: 'Add to Cart'
- assertVisible: '1 item in cart'
- tapOn: 'Cart'
- assertVisible: 'Widget'
- assertVisible: '$19.99'
```

**Detox test (JavaScript):**

```typescript
// e2e/login.test.ts
describe('Login flow', () => {
  beforeAll(async () => {
    await device.launchApp({ newInstance: true })
  })

  it('should login with valid credentials', async () => {
    await element(by.id('email-input')).typeText('test@example.com')
    await element(by.id('password-input')).typeText('testpass123')
    await element(by.id('login-button')).tap()

    await expect(element(by.text('Welcome back'))).toBeVisible()
  })

  it('should show error for invalid credentials', async () => {
    await element(by.id('email-input')).typeText('wrong@example.com')
    await element(by.id('password-input')).typeText('badpassword')
    await element(by.id('login-button')).tap()

    await expect(element(by.text('Invalid credentials'))).toBeVisible()
  })
})
```

**E2E test guidelines:**

- Test critical user flows only (login, purchase, core feature)
- Keep E2E tests under 20 — they're slow and fragile at scale
- Use stable selectors (`testID` / `accessibilityLabel`), not text content
- Add wait/retry logic for animations and network responses
- Run on CI, not just locally

### Step 5 — Add Screenshot Testing

Screenshot tests catch visual regressions — layout shifts, color changes, missing elements — that unit tests miss entirely.

**React Native with Jest Image Snapshot:**

```typescript
// __tests__/screenshots/ProductCard.screenshot.test.tsx
import { render } from '@testing-library/react-native';
import { ProductCard } from '@/components/ProductCard';

describe('ProductCard screenshots', () => {
  it('matches default state', async () => {
    const tree = render(<ProductCard product={mockProduct} onAddToCart={jest.fn()} />);
    const image = await tree.toJSON();
    expect(image).toMatchSnapshot();
  });

  it('matches dark mode', async () => {
    const tree = render(
      <ThemeProvider theme="dark">
        <ProductCard product={mockProduct} onAddToCart={jest.fn()} />
      </ThemeProvider>
    );
    expect(await tree.toJSON()).toMatchSnapshot();
  });
});
```

**Maestro screenshot assertions:**

```yaml
- launchApp
- tapOn: 'Products'
- assertVisible: 'Widget'
- takeScreenshot: 'product-list' # saved and compared against baseline
```

**Screenshot testing rules:**

- Generate baselines in CI (not locally — different machines render differently)
- Review and update baselines on intentional visual changes
- Test both light and dark mode
- Test key breakpoints (small phone, large phone, tablet if supported)
- Set a pixel tolerance threshold (1-2% to avoid flaky failures from anti-aliasing)

### Step 6 — Configure Device Farm Testing

Simulators are not phones. Device farms run your tests on actual hardware.

**Firebase Test Lab (recommended for Android):**

```bash
# Run Maestro tests on Firebase Test Lab
gcloud firebase test android run \
  --type instrumentation \
  --app app-debug.apk \
  --test app-debug-androidTest.apk \
  --device model=Pixel7,version=34,locale=en,orientation=portrait \
  --device model=Pixel6,version=33,locale=en,orientation=portrait \
  --timeout 10m
```

**AWS Device Farm (cross-platform):**

```bash
# Upload and run via AWS CLI
aws devicefarm create-upload \
  --project-arn $PROJECT_ARN \
  --name app.apk \
  --type ANDROID_APP
```

**Device selection strategy:**

- Cover top 3-5 devices from your analytics (real user distribution)
- Include one low-end device (catches performance issues)
- Include oldest supported OS version
- Include one tablet if your app supports it
- Run on device farm for release builds; simulators are fine for PR checks

### Step 7 — Integrate with CI

**CI pipeline for mobile tests:**

```
PR opened:
  → Unit tests (Jest / XCTest / JUnit)          [~1 min]
  → Component tests (RNTL / Compose)             [~2 min]
  → Screenshot tests (compare against baseline)  [~3 min]

Pre-release:
  → E2E tests on simulator (Detox / Maestro)     [~10 min]
  → E2E tests on device farm (Firebase / AWS)     [~20 min]
```

**GitHub Actions example:**

```yaml
name: Mobile Tests
on: [pull_request]

jobs:
  unit-and-component:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test -- --coverage
      - run: npm run test:components

  e2e-ios:
    runs-on: macos-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npx detox build --configuration ios.sim.release
      - run: npx detox test --configuration ios.sim.release --cleanup
```

## Common Rationalizations

| Rationalization                                  | Reality                                                                                                 |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------- |
| "We test manually on our phones — that's enough" | Manual testing checks happy paths. It doesn't catch the crash on Android 12 with a foldable display.    |
| "E2E tests are too flaky for mobile"             | Flaky E2E tests mean bad selectors or missing waits. Fix the tests, don't skip them.                    |
| "Simulators are good enough"                     | Simulators don't reproduce memory pressure, slow I/O, or weird OEM behavior. Use device farms.          |
| "Screenshot tests break too often"               | If screenshots break on every PR, your threshold is too tight or your UI is unstable. Both need fixing. |
| "We'll add tests after launch"                   | After launch you'll be fixing the bugs that tests would have caught. Test now.                          |
| "We only need to test on the latest devices"     | Your users are on 3-year-old phones running OS N-2. Test what they actually use.                        |

## Red Flags

- No unit tests for business logic (everything tested via manual QA)
- E2E tests using brittle text selectors instead of `testID` / accessibility labels
- Screenshot baselines generated locally (differs across machines)
- Only testing on one device size and OS version
- E2E tests that take 30+ minutes to run (too many, too slow)
- Native modules not mocked in unit tests (tests crash instead of fail)
- No tests running in CI — only on developer machines

## Verification

- [ ] Unit tests cover business logic, utilities, and state management (50%+ of tests)
- [ ] Component tests verify individual screen rendering and interaction
- [ ] Native modules are properly mocked in the test environment
- [ ] E2E tests cover critical user flows (login, core feature, purchase)
- [ ] E2E tests use stable selectors (`testID` / `accessibilityLabel`)
- [ ] Screenshot tests exist for key components in both light and dark mode
- [ ] Screenshot baselines are generated in CI, not locally
- [ ] Tests run on at least 3 representative devices (device farm or multiple simulators)
- [ ] One low-end device and the oldest supported OS version are in the test matrix
- [ ] Unit and component tests run on every PR; E2E runs on merge to main
- [ ] CI pipeline completes in under 15 minutes for PR checks
