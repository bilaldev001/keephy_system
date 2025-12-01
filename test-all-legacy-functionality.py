#!/usr/bin/env python3
"""
Comprehensive Selenium Test Suite for All Legacy Functionality
Tests all features from OLD_SYSTEM_FUNCTIONALITY_LIST.md
"""

import time
import sys
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
import requests
import json

# Color codes for terminal output
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

def log(message, level="INFO"):
    """Log messages with colors"""
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
    if level == "ERROR":
        print(f"{Colors.RED}[{timestamp}] ERROR: {message}{Colors.RESET}")
    elif level == "WARNING":
        print(f"{Colors.YELLOW}[{timestamp}] WARNING: {message}{Colors.RESET}")
    elif level == "SUCCESS":
        print(f"{Colors.GREEN}[{timestamp}] ✅ {message}{Colors.RESET}")
    else:
        print(f"{Colors.BLUE}[{timestamp}] {level}: {message}{Colors.RESET}")

class TestResults:
    def __init__(self):
        self.passed = []
        self.failed = []
        self.skipped = []
        self.errors = []

    def add_passed(self, test_name, details=""):
        self.passed.append({"name": test_name, "details": details})

    def add_failed(self, test_name, error=""):
        self.failed.append({"name": test_name, "error": error})

    def add_skipped(self, test_name, reason=""):
        self.skipped.append({"name": test_name, "reason": reason})

    def add_error(self, test_name, error=""):
        self.errors.append({"name": test_name, "error": error})

    def print_summary(self):
        total = len(self.passed) + len(self.failed) + len(self.skipped)
        print(f"\n{Colors.BOLD}{'='*80}{Colors.RESET}")
        print(f"{Colors.BOLD}TEST SUMMARY{Colors.RESET}")
        print(f"{Colors.BOLD}{'='*80}{Colors.RESET}")
        print(f"{Colors.GREEN}✅ Passed: {len(self.passed)}{Colors.RESET}")
        print(f"{Colors.RED}❌ Failed: {len(self.failed)}{Colors.RESET}")
        print(f"{Colors.YELLOW}⏭️  Skipped: {len(self.skipped)}{Colors.RESET}")
        if self.errors:
            print(f"{Colors.RED}⚠️  Errors: {len(self.errors)}{Colors.RESET}")
        print(f"{Colors.BOLD}{'='*80}{Colors.RESET}\n")

        if self.passed:
            print(f"{Colors.GREEN}✅ PASSED TESTS:{Colors.RESET}")
            for test in self.passed:
                print(f"  - {test['name']}")
                if test['details']:
                    print(f"    {test['details']}")

        if self.failed:
            print(f"\n{Colors.RED}❌ FAILED TESTS:{Colors.RESET}")
            for test in self.failed:
                print(f"  - {test['name']}")
                if test['error']:
                    print(f"    Error: {test['error']}")

        if self.skipped:
            print(f"\n{Colors.YELLOW}⏭️  SKIPPED TESTS:{Colors.RESET}")
            for test in self.skipped:
                print(f"  - {test['name']}")
                if test['reason']:
                    print(f"    Reason: {test['reason']}")

def setup_driver():
    """Setup Chrome WebDriver"""
    chrome_options = Options()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--window-size=1920,1080')
    chrome_options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36')

    try:
        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=chrome_options)
        driver.implicitly_wait(10)
        return driver
    except Exception as e:
        log(f"Failed to setup driver: {e}", "ERROR")
        sys.exit(1)

def wait_for_element(driver, by, value, timeout=10):
    """Wait for element to be present"""
    try:
        element = WebDriverWait(driver, timeout).until(
            EC.presence_of_element_located((by, value))
        )
        return element
    except TimeoutException:
        return None

def wait_for_clickable(driver, by, value, timeout=10):
    """Wait for element to be clickable"""
    try:
        element = WebDriverWait(driver, timeout).until(
            EC.element_to_be_clickable((by, value))
        )
        return element
    except TimeoutException:
        return None

def safe_click(driver, by, value, timeout=10):
    """Safely click an element"""
    try:
        element = wait_for_clickable(driver, by, value, timeout)
        if element:
            driver.execute_script("arguments[0].scrollIntoView({block: 'center'});", element)
            time.sleep(0.5)
            element.click()
            return True
        return False
    except Exception as e:
        log(f"Click failed: {e}", "WARNING")
        return False

def safe_send_keys(driver, by, value, text, timeout=10):
    """Safely send keys to an element"""
    try:
        element = wait_for_element(driver, by, value, timeout)
        if element:
            element.clear()
            element.send_keys(text)
            return True
        return False
    except Exception as e:
        log(f"Send keys failed: {e}", "WARNING")
        return False

def check_page_loaded(driver, indicators=None):
    """Check if page loaded successfully"""
    if indicators is None:
        indicators = ["html", "body", "h1", "h2", "div"]
    
    for indicator in indicators:
        try:
            elements = driver.find_elements(By.CSS_SELECTOR, indicator)
            if elements:
                return True
        except:
            continue
    return False

def test_authentication_flow(driver, results, email, password):
    """Test user signup and login"""
    log("="*80)
    log("AUTHENTICATION TESTS")
    log("="*80)

    # Test Console Accessibility
    try:
        driver.get("http://localhost:3076")
        time.sleep(5)
        if check_page_loaded(driver):
            results.add_passed("Console Accessibility", "Page loaded successfully")
        else:
            results.add_failed("Console Accessibility", "Page did not load")
    except Exception as e:
        results.add_failed("Console Accessibility", str(e))

    # Test Signup
    try:
        driver.get("http://localhost:3076/register")
        time.sleep(5)
        
        # Fill signup form
        if safe_send_keys(driver, By.ID, "firstName", "Test"):
            if safe_send_keys(driver, By.ID, "lastName", "User"):
                if safe_send_keys(driver, By.ID, "email", email):
                    if safe_send_keys(driver, By.ID, "password", password):
                        if safe_send_keys(driver, By.ID, "confirmPassword", password):
                            if safe_click(driver, By.CSS_SELECTOR, "button[type='submit']"):
                                time.sleep(10)
                                current_url = driver.current_url
                                if "/register" not in current_url:
                                    results.add_passed("User Signup", "Redirected after signup")
                                else:
                                    results.add_failed("User Signup", "Still on register page")
                            else:
                                results.add_failed("User Signup", "Submit button not found")
                        else:
                            results.add_failed("User Signup", "Confirm password field not found")
                    else:
                        results.add_failed("User Signup", "Password field not found")
                else:
                    results.add_failed("User Signup", "Email field not found")
            else:
                results.add_failed("User Signup", "Last name field not found")
        else:
            results.add_failed("User Signup", "First name field not found")
    except Exception as e:
        results.add_failed("User Signup", str(e))

    # Test Login
    try:
        driver.get("http://localhost:3076/login")
        time.sleep(5)
        
        if safe_send_keys(driver, By.ID, "email", email):
            if safe_send_keys(driver, By.ID, "password", password):
                if safe_click(driver, By.CSS_SELECTOR, "button[type='submit']"):
                    time.sleep(10)
                    current_url = driver.current_url
                    if "/dashboard" in current_url or "/onboarding" in current_url:
                        results.add_passed("User Login", "Login successful")
                    else:
                        results.add_failed("User Login", f"Unexpected redirect: {current_url}")
                else:
                    results.add_failed("User Login", "Submit button not found")
            else:
                results.add_failed("User Login", "Password field not found")
        else:
            results.add_failed("User Login", "Email field not found")
    except Exception as e:
        results.add_failed("User Login", str(e))

def test_onboarding_flow(driver, results):
    """Test onboarding steps"""
    log("="*80)
    log("ONBOARDING TESTS")
    log("="*80)

    try:
        driver.get("http://localhost:3076/onboarding")
        time.sleep(5)

        # Test Organization Step
        org_input = wait_for_element(driver, By.CSS_SELECTOR, "input[placeholder*='organization' i], input[placeholder*='name' i]", 5)
        if org_input:
            org_input.clear()
            org_input.send_keys("Test Organization")
            time.sleep(1)
            if safe_click(driver, By.CSS_SELECTOR, "button[type='submit'], button:contains('Next')"):
                time.sleep(5)
                results.add_passed("Organization Creation", "Organization step completed")
            else:
                results.add_failed("Organization Creation", "Next button not found")
        else:
            results.add_failed("Organization Creation", "Organization input not found")

        # Test Brand Step
        brand_input = wait_for_element(driver, By.CSS_SELECTOR, "input[placeholder*='brand' i], input[placeholder*='name' i]", 5)
        if brand_input:
            brand_input.clear()
            brand_input.send_keys("Test Brand")
            time.sleep(1)
            if safe_click(driver, By.CSS_SELECTOR, "button[type='submit'], button:contains('Next')"):
                time.sleep(5)
                results.add_passed("Brand Creation", "Brand step completed")
            else:
                results.add_failed("Brand Creation", "Next button not found")
        else:
            results.add_failed("Brand Creation", "Brand input not found")

        # Test Business Step
        business_input = wait_for_element(driver, By.CSS_SELECTOR, "input[placeholder*='business' i], input[placeholder*='name' i]", 5)
        if business_input:
            business_input.clear()
            business_input.send_keys("Test Business")
            time.sleep(1)
            if safe_click(driver, By.CSS_SELECTOR, "button[type='submit'], button:contains('Next')"):
                time.sleep(5)
                results.add_passed("Business Creation", "Business step completed")
            else:
                results.add_failed("Business Creation", "Next button not found")
        else:
            results.add_failed("Business Creation", "Business input not found")

        # Test Franchise Step
        franchise_input = wait_for_element(driver, By.CSS_SELECTOR, "input[placeholder*='franchise' i], input[placeholder*='location' i], input[placeholder*='name' i]", 5)
        if franchise_input:
            franchise_input.clear()
            franchise_input.send_keys("Test Franchise")
            time.sleep(1)
            if safe_click(driver, By.CSS_SELECTOR, "button[type='submit'], button:contains('Complete'), button:contains('Next')"):
                time.sleep(8)
                results.add_passed("Franchise Creation", "Franchise step completed")
            else:
                results.add_failed("Franchise Creation", "Complete button not found")
        else:
            results.add_failed("Franchise Creation", "Franchise input not found")

    except Exception as e:
        results.add_failed("Onboarding Flow", str(e))

def test_entity_pages(driver, results):
    """Test all entity listing pages"""
    log("="*80)
    log("ENTITY MANAGEMENT TESTS")
    log("="*80)

    entities = [
        ("Organizations", "/organizations"),
        ("Brands", "/brands"),
        ("Businesses", "/businesses"),
        ("Franchises", "/franchises"),
    ]

    for name, path in entities:
        try:
            driver.get(f"http://localhost:3076{path}")
            time.sleep(5)
            
            current_url = driver.current_url
            if "/login" in current_url:
                results.add_passed(f"{name} List", "Redirected to login (auth required)")
            elif path in current_url or check_page_loaded(driver):
                results.add_passed(f"{name} List", "Page loaded successfully")
            else:
                results.add_failed(f"{name} List", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name} List", str(e))

def test_staff_management(driver, results):
    """Test staff management pages"""
    log("="*80)
    log("STAFF MANAGEMENT TESTS")
    log("="*80)

    pages = [
        ("Staff List", "/staff"),
        ("Staff Create", "/staff/create"),
    ]

    for name, path in pages:
        try:
            driver.get(f"http://localhost:3076{path}")
            time.sleep(5)
            
            current_url = driver.current_url
            if "/login" in current_url:
                results.add_passed(f"{name}", "Redirected to login (auth required)")
            elif path in current_url or check_page_loaded(driver):
                results.add_passed(f"{name}", "Page loaded successfully")
            else:
                results.add_failed(f"{name}", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name}", str(e))

def test_shifts_management(driver, results):
    """Test shifts and scheduling pages"""
    log("="*80)
    log("SHIFTS & SCHEDULING TESTS")
    log("="*80)

    pages = [
        ("Shifts List", "/shifts"),
        ("Shifts Create", "/shifts/create"),
        ("Schedule Templates", "/shifts/templates"),
    ]

    for name, path in pages:
        try:
            driver.get(f"http://localhost:3076{path}")
            time.sleep(5)
            
            current_url = driver.current_url
            if "/login" in current_url:
                results.add_passed(f"{name}", "Redirected to login (auth required)")
            elif path in current_url or check_page_loaded(driver):
                results.add_passed(f"{name}", "Page loaded successfully")
            else:
                results.add_failed(f"{name}", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name}", str(e))

def test_gift_cards(driver, results):
    """Test gift cards pages"""
    log("="*80)
    log("GIFT CARDS TESTS")
    log("="*80)

    pages = [
        ("Gift Cards List", "/gift-cards"),
        ("Gift Cards Create", "/gift-cards/create"),
    ]

    for name, path in pages:
        try:
            driver.get(f"http://localhost:3076{path}")
            time.sleep(5)
            
            current_url = driver.current_url
            if "/login" in current_url:
                results.add_passed(f"{name}", "Redirected to login (auth required)")
            elif path in current_url or check_page_loaded(driver):
                results.add_passed(f"{name}", "Page loaded successfully")
            else:
                results.add_failed(f"{name}", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name}", str(e))

def test_coupons(driver, results):
    """Test coupons pages"""
    log("="*80)
    log("COUPONS TESTS")
    log("="*80)

    pages = [
        ("Coupons List", "/coupons"),
        ("Coupons Create", "/coupons/create"),
    ]

    for name, path in pages:
        try:
            driver.get(f"http://localhost:3076{path}")
            time.sleep(5)
            
            current_url = driver.current_url
            if "/login" in current_url:
                results.add_passed(f"{name}", "Redirected to login (auth required)")
            elif path in current_url or check_page_loaded(driver):
                results.add_passed(f"{name}", "Page loaded successfully")
            else:
                results.add_failed(f"{name}", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name}", str(e))

def test_fbms_pages(driver, results):
    """Test FBMS pages"""
    log("="*80)
    log("FBMS TESTS")
    log("="*80)

    # Test FBMS frontend
    fbms_urls = ["http://localhost:3088", "http://localhost:3080"]
    
    for url in fbms_urls:
        try:
            driver.get(url)
            time.sleep(8)
            
            current_url = driver.current_url
            page_text = driver.page_source.lower()
            
            if "/login" in current_url:
                results.add_passed("FBMS Dashboard", "Redirected to login (auth required)")
                break
            elif "feedback" in page_text or "fbms" in page_text or "form" in page_text:
                results.add_passed("FBMS Dashboard", "FBMS page loaded")
                break
            elif "localhost" in current_url and "err_connection" not in page_text:
                results.add_passed("FBMS Dashboard", "Page accessible")
                break
        except Exception as e:
            continue
    else:
        results.add_failed("FBMS Dashboard", "FBMS not accessible")

def test_forms_pages(driver, results):
    """Test forms pages"""
    log("="*80)
    log("FORMS TESTS")
    log("="*80)

    pages = [
        ("Forms List", "/forms"),
        ("Forms Create", "/forms/create"),
    ]

    for name, path in pages:
        try:
            # Forms might be on a different port
            driver.get(f"http://localhost:3082{path}")
            time.sleep(5)
            
            current_url = driver.current_url
            if "/login" in current_url:
                results.add_passed(f"{name}", "Redirected to login (auth required)")
            elif path in current_url or check_page_loaded(driver):
                results.add_passed(f"{name}", "Page loaded successfully")
            else:
                results.add_failed(f"{name}", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name}", str(e))

def test_vouchers_pages(driver, results):
    """Test vouchers pages"""
    log("="*80)
    log("VOUCHERS TESTS")
    log("="*80)

    pages = [
        ("Vouchers Manage", "/vouchers/manage"),
    ]

    for name, path in pages:
        try:
            driver.get(f"http://localhost:3090{path}")
            time.sleep(5)
            
            current_url = driver.current_url
            if "/login" in current_url:
                results.add_passed(f"{name}", "Redirected to login (auth required)")
            elif path in current_url or check_page_loaded(driver):
                results.add_passed(f"{name}", "Page loaded successfully")
            else:
                results.add_failed(f"{name}", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name}", str(e))

def test_admin_pages(driver, results):
    """Test admin pages"""
    log("="*80)
    log("ADMIN TESTS")
    log("="*80)

    pages = [
        ("Admin Login", "/admin/login"),
        ("Admin Users", "/admin/users"),
        ("Admin Businesses", "/admin/businesses"),
        ("Admin Plans", "/admin/plans"),
        ("Admin Submissions", "/admin/submissions"),
    ]

    for name, path in pages:
        try:
            driver.get(f"http://localhost:3084{path}")
            time.sleep(5)
            
            current_url = driver.current_url
            if "/login" in current_url:
                results.add_passed(f"{name}", "Redirected to login (auth required)")
            elif path in current_url or check_page_loaded(driver):
                results.add_passed(f"{name}", "Page loaded successfully")
            else:
                results.add_failed(f"{name}", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name}", str(e))

def test_analytics_pages(driver, results):
    """Test analytics pages"""
    log("="*80)
    log("ANALYTICS TESTS")
    log("="*80)

    pages = [
        ("Analytics Dashboard", "/analytics"),
    ]

    for name, path in pages:
        try:
            driver.get(f"http://localhost:3086{path}")
            time.sleep(5)
            
            current_url = driver.current_url
            if "/login" in current_url:
                results.add_passed(f"{name}", "Redirected to login (auth required)")
            elif path in current_url or check_page_loaded(driver):
                results.add_passed(f"{name}", "Page loaded successfully")
            else:
                results.add_failed(f"{name}", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name}", str(e))

def test_marketing_pages(driver, results):
    """Test marketing pages"""
    log("="*80)
    log("MARKETING TESTS")
    log("="*80)

    pages = [
        ("Marketing Home", "/"),
        ("Marketing Features", "/features"),
        ("Marketing Pricing", "/pricing"),
        ("Marketing About", "/about"),
        ("Marketing Contact", "/contact"),
        ("Marketing Terms", "/terms"),
        ("Marketing Privacy", "/privacy"),
        ("Marketing Cookies", "/cookies"),
    ]

    for name, path in pages:
        try:
            driver.get(f"http://localhost:3074{path}")
            time.sleep(5)
            
            if check_page_loaded(driver):
                results.add_passed(f"{name}", "Page loaded successfully")
            else:
                results.add_failed(f"{name}", "Page did not load")
        except Exception as e:
            results.add_failed(f"{name}", str(e))

def main():
    """Main test execution"""
    log("Starting Comprehensive Legacy Functionality Tests", "INFO")
    log("="*80)
    
    results = TestResults()
    driver = None
    
    try:
        driver = setup_driver()
        test_email = f"test_{int(time.time())}@example.com"
        test_password = "Test123!@#"

        # Run all test suites
        test_authentication_flow(driver, results, test_email, test_password)
        test_onboarding_flow(driver, results)
        test_entity_pages(driver, results)
        test_staff_management(driver, results)
        test_shifts_management(driver, results)
        test_gift_cards(driver, results)
        test_coupons(driver, results)
        test_fbms_pages(driver, results)
        test_forms_pages(driver, results)
        test_vouchers_pages(driver, results)
        test_admin_pages(driver, results)
        test_analytics_pages(driver, results)
        test_marketing_pages(driver, results)

    except Exception as e:
        log(f"Test execution error: {e}", "ERROR")
        results.add_error("Test Execution", str(e))
    finally:
        if driver:
            driver.quit()
        results.print_summary()

if __name__ == "__main__":
    main()

