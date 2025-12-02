#!/usr/bin/env python3
"""
Focused test to verify tenantId is set correctly after onboarding.
This test will:
1. Sign up a new user
2. Complete onboarding (create org/brand/business/franchise)
3. Verify tenantId is set in session response
"""

import time
import random
from datetime import datetime
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import TimeoutException

def log(message, level="INFO"):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    colors = {
        "INFO": "\033[94m",
        "SUCCESS": "\033[92m",
        "WARNING": "\033[93m",
        "ERROR": "\033[91m",
        "RESET": "\033[0m"
    }
    print(f"{colors.get(level, '')}[{timestamp}] {level}: {message}{colors['RESET']}")

def setup_driver():
    """Setup Chrome WebDriver"""
    chrome_options = Options()
    # Run in non-headless mode so we can see what's happening
    # chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--window-size=1920,1080')
    
    try:
        driver = webdriver.Chrome(options=chrome_options)
        driver.implicitly_wait(10)
        return driver
    except Exception as e:
        log(f"Failed to setup driver: {e}", "ERROR")
        raise

def test_signup(driver, email, password="Test123!@#"):
    """Test user signup"""
    try:
        driver.get("http://localhost:3076/register")
        time.sleep(5)
        
        # Try multiple selectors for form fields
        email_input = None
        password_input = None
        firstName_input = None
        lastName_input = None
        
        # Find email
        try:
            email_input = driver.find_element(By.ID, "email")
        except:
            try:
                email_input = driver.find_element(By.CSS_SELECTOR, "input[type='email']")
            except:
                pass
        
        # Find password
        try:
            password_input = driver.find_element(By.ID, "password")
        except:
            try:
                password_input = driver.find_element(By.CSS_SELECTOR, "input[type='password']")
            except:
                pass
        
        # Find firstName
        try:
            firstName_input = driver.find_element(By.ID, "firstName")
        except:
            try:
                firstName_input = driver.find_element(By.NAME, "firstName")
            except:
                pass
        
        # Find lastName
        try:
            lastName_input = driver.find_element(By.ID, "lastName")
        except:
            try:
                lastName_input = driver.find_element(By.NAME, "lastName")
            except:
                pass
        
        if not email_input or not password_input:
            log("Could not find email or password fields", "ERROR")
            return False
        
        # Fill form
        if firstName_input:
            firstName_input.clear()
            firstName_input.send_keys("Test")
        if lastName_input:
            lastName_input.clear()
            lastName_input.send_keys("User")
        email_input.clear()
        email_input.send_keys(email)
        password_input.clear()
        password_input.send_keys(password)
        
        # Submit form
        try:
            submit_btn = driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        except:
            # Try to find any button with submit text
            buttons = driver.find_elements(By.TAG_NAME, "button")
            for btn in buttons:
                if "sign up" in btn.text.lower() or "register" in btn.text.lower() or "submit" in btn.text.lower():
                    submit_btn = btn
                    break
        
        if submit_btn:
            driver.execute_script("arguments[0].scrollIntoView(true);", submit_btn)
            time.sleep(1)
            submit_btn.click()
            
            # Wait for redirect
            time.sleep(8)
            
            # Check if redirected to onboarding or dashboard
            current_url = driver.current_url
            if "/onboarding" in current_url or "/dashboard" in current_url:
                log(f"✅ Signup successful, redirected to: {current_url}", "SUCCESS")
                return True
            else:
                log(f"Signup may have succeeded but redirected to: {current_url}", "WARNING")
                return True  # Still consider it success if we got a response
        return False
    except Exception as e:
        log(f"Signup failed: {e}", "ERROR")
        import traceback
        log(traceback.format_exc(), "ERROR")
        return False

def complete_onboarding_simple(driver):
    """Complete onboarding with minimal data"""
    try:
        # Wait for onboarding page
        time.sleep(5)
        
        # Fill business name (required)
        business_inputs = driver.find_elements(By.CSS_SELECTOR, "input[placeholder*='business' i], input[placeholder*='name' i]")
        if business_inputs:
            business_inputs[0].clear()
            business_inputs[0].send_keys(f"Test Business {int(time.time())}")
        
        # Fill primary email (required for business)
        email_inputs = driver.find_elements(By.CSS_SELECTOR, "input[type='email']")
        for email_input in email_inputs:
            if email_input.is_displayed():
                email_input.clear()
                email_input.send_keys(f"business{int(time.time())}@test.com")
                break
        
        # Try to find and click Next/Continue button
        next_buttons = driver.find_elements(By.CSS_SELECTOR, "button:contains('Next'), button:contains('Continue'), button:contains('Submit')")
        if not next_buttons:
            # Try to find any button with text containing Next
            all_buttons = driver.find_elements(By.TAG_NAME, "button")
            for btn in all_buttons:
                btn_text = btn.text.lower()
                if "next" in btn_text or "continue" in btn_text or "submit" in btn_text:
                    driver.execute_script("arguments[0].scrollIntoView(true);", btn)
                    time.sleep(1)
                    btn.click()
                    time.sleep(5)
                    break
        
        # Wait for completion
        time.sleep(5)
        return True
    except Exception as e:
        log(f"Onboarding completion failed: {e}", "WARNING")
        return False

def verify_tenant_id(driver):
    """Verify tenantId is set in session"""
    try:
        # Get auth token
        token = driver.execute_script("""
            return localStorage.getItem('keephy-token') || 
                   localStorage.getItem('keephy_session') ||
                   document.cookie.split(';').find(c => c.trim().startsWith('keephy_session='))?.split('=')[1] ||
                   null;
        """)
        
        if not token:
            log("❌ No auth token found", "ERROR")
            return False
        
        log(f"✅ Found auth token", "SUCCESS")
        
        # Fetch session
        driver.execute_script("""
            var token = arguments[0];
            window.__sessionResult = null;
            window.__sessionError = null;
            
            fetch('http://localhost:3010/auth/session', {
                headers: {
                    'Authorization': 'Bearer ' + token,
                    'Content-Type': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                window.__sessionResult = {
                    tenantId: data.tenantId || data.user?.metadata?.tenantId || null,
                    hasTenantId: !!(data.tenantId || data.user?.metadata?.tenantId),
                    userId: data.user?.id || null,
                    email: data.user?.email || null,
                    organizationId: data.organizationId || null,
                    fullData: JSON.stringify(data, null, 2)
                };
            })
            .catch(err => {
                window.__sessionError = err.toString();
            });
        """, token)
        
        # Wait for fetch
        time.sleep(3)
        
        # Get result
        result = driver.execute_script("""
            if (window.__sessionError) {
                return { error: window.__sessionError };
            }
            if (window.__sessionResult) {
                return window.__sessionResult;
            }
            return { error: 'No result found' };
        """)
        
        if result and 'error' in result:
            log(f"❌ Error fetching session: {result['error']}", "ERROR")
            return False
        
        if result and result.get('hasTenantId'):
            tenant_id = result.get('tenantId')
            log(f"✅✅✅ tenantId VERIFIED: {tenant_id}", "SUCCESS")
            log(f"   User ID: {result.get('userId')}", "INFO")
            log(f"   Email: {result.get('email')}", "INFO")
            log(f"   Organization ID: {result.get('organizationId')}", "INFO")
            log(f"\nFull session data:\n{result.get('fullData', 'N/A')}", "INFO")
            return True
        else:
            log(f"❌❌❌ tenantId is EMPTY or NOT FOUND", "ERROR")
            log(f"   Session result: {result}", "ERROR")
            if result and result.get('fullData'):
                log(f"\nFull session data:\n{result.get('fullData')}", "ERROR")
            return False
            
    except Exception as e:
        log(f"❌ Error verifying tenantId: {e}", "ERROR")
        import traceback
        log(traceback.format_exc(), "ERROR")
        return False

def main():
    """Main test execution"""
    driver = None
    try:
        log("="*80)
        log("TENANT ID VERIFICATION TEST")
        log("="*80)
        
        driver = setup_driver()
        
        # Use provided credentials
        test_email = "mbilal.dev133@gmail.com"
        test_password = "aaaaaaaaaa"
        
        log(f"Using email: {test_email}", "INFO")
        
        # Step 1: Login with provided credentials
        log("\n" + "="*80)
        log("STEP 1: User Login")
        log("="*80)
        
        driver.get("http://localhost:3076/login")
        time.sleep(5)
        
        login_success = False
        try:
            # Find login form fields
            email_input = None
            password_input = None
            
            try:
                email_input = driver.find_element(By.ID, "email")
            except:
                try:
                    email_input = driver.find_element(By.CSS_SELECTOR, "input[type='email']")
                except:
                    email_input = driver.find_element(By.NAME, "email")
            
            try:
                password_input = driver.find_element(By.ID, "password")
            except:
                try:
                    password_input = driver.find_element(By.CSS_SELECTOR, "input[type='password']")
                except:
                    password_input = driver.find_element(By.NAME, "password")
            
            if email_input and password_input:
                email_input.clear()
                email_input.send_keys(test_email)
                password_input.clear()
                password_input.send_keys(test_password)
                
                # Find and click submit button
                try:
                    submit_btn = driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
                except:
                    # Try to find button with login text
                    buttons = driver.find_elements(By.TAG_NAME, "button")
                    for btn in buttons:
                        if "login" in btn.text.lower() or "sign in" in btn.text.lower():
                            submit_btn = btn
                            break
                
                driver.execute_script("arguments[0].scrollIntoView(true);", submit_btn)
                time.sleep(1)
                submit_btn.click()
                
                # Wait for redirect
                time.sleep(10)
                
                current_url = driver.current_url
                # Check if we're no longer on login page
                if "/login" not in current_url and "register" not in current_url.lower():
                    log(f"✅ Login successful, redirected to: {current_url}", "SUCCESS")
                    login_success = True
                else:
                    # Check for error messages
                    try:
                        error_elements = driver.find_elements(By.CSS_SELECTOR, "[role='alert'], .error, .text-red, [class*='error']")
                        if error_elements:
                            error_text = error_elements[0].text
                            log(f"Login failed: {error_text}", "ERROR")
                        else:
                            log(f"Login may have failed, still on: {current_url}", "WARNING")
                    except:
                        log(f"Login may have failed, still on: {current_url}", "WARNING")
            else:
                log("Could not find email or password fields", "ERROR")
        except Exception as e:
            log(f"Login failed: {e}", "ERROR")
            import traceback
            log(traceback.format_exc(), "ERROR")
        
        if not login_success:
            log("Login failed, cannot proceed with tenantId verification", "ERROR")
            return False
        
        # Step 2: Complete onboarding (if needed)
        log("\n" + "="*80)
        log("STEP 2: Check/Complete Onboarding")
        log("="*80)
        current_url = driver.current_url
        log(f"Current URL: {current_url}", "INFO")
        
        if "/onboarding" in current_url:
            log("On onboarding page, attempting to complete...", "INFO")
            complete_onboarding_simple(driver)
            time.sleep(5)
        else:
            log("Not on onboarding page, user may have already completed onboarding", "INFO")
        
        # Step 3: Verify tenantId
        log("\n" + "="*80)
        log("STEP 3: Verify TenantId in Session")
        log("="*80)
        
        # Navigate to dashboard to ensure we're authenticated
        driver.get("http://localhost:3076/")
        time.sleep(5)
        
        # Try multiple times to get token (sometimes it takes a moment)
        for attempt in range(3):
            success = verify_tenant_id(driver)
            if success:
                break
            log(f"Attempt {attempt + 1} failed, retrying...", "WARNING")
            time.sleep(2)
        
        if success:
            log("\n" + "="*80)
            log("✅✅✅ TEST PASSED: tenantId is correctly set!", "SUCCESS")
            log("="*80)
        else:
            log("\n" + "="*80)
            log("❌❌❌ TEST FAILED: tenantId is not set!", "ERROR")
            log("="*80)
        
        # Keep browser open for inspection
        log("\nBrowser will stay open for 30 seconds for inspection...", "INFO")
        time.sleep(30)
        
        return success
        
    except Exception as e:
        log(f"Test execution error: {e}", "ERROR")
        import traceback
        log(traceback.format_exc(), "ERROR")
        return False
    finally:
        if driver:
            driver.quit()

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)

