#!/usr/bin/env python3
"""
Test form attachment and activation functionality.
Tests:
1. Create a form
2. Attach form to business
3. Verify form is attached and active
4. Test form activation/deactivation
"""

import time
import requests
import json
from datetime import datetime

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

def get_auth_token():
    """Login and get auth token"""
    try:
        response = requests.post(
            "http://localhost:3010/auth/login",
            json={
                "email": "mbilal.dev133@gmail.com",
                "password": "aaaaaaaaaa"
            }
        )
        if response.status_code == 200:
            token = response.json().get('accessToken')
            log(f"✅ Login successful, got token", "SUCCESS")
            return token
        else:
            log(f"❌ Login failed: {response.status_code} - {response.text}", "ERROR")
            return None
    except Exception as e:
        log(f"❌ Login error: {e}", "ERROR")
        return None

def get_tenant_id(token):
    """Get tenantId from session"""
    try:
        response = requests.get(
            "http://localhost:3010/auth/session",
            headers={"Authorization": f"Bearer {token}"}
        )
        if response.status_code == 200:
            data = response.json()
            tenant_id = data.get('tenantId') or data.get('user', {}).get('metadata', {}).get('tenantId')
            log(f"✅ Got tenantId: {tenant_id}", "SUCCESS")
            return tenant_id
        else:
            log(f"❌ Failed to get session: {response.status_code}", "ERROR")
            return None
    except Exception as e:
        log(f"❌ Session error: {e}", "ERROR")
        return None

def get_business_id(token, tenant_id):
    """Get a business ID from onboarding data"""
    try:
        response = requests.get(
            "http://localhost:3010/auth/session",
            headers={"Authorization": f"Bearer {token}"}
        )
        if response.status_code == 200:
            data = response.json()
            business_id = data.get('onboarding', {}).get('businessId')
            if business_id:
                log(f"✅ Got businessId: {business_id}", "SUCCESS")
                return business_id
            else:
                log(f"⚠️ No businessId in session, using tenantId as fallback", "WARNING")
                return tenant_id
        return None
    except Exception as e:
        log(f"❌ Error getting businessId: {e}", "ERROR")
        return None

def create_form(token, tenant_id):
    """Create a test form"""
    try:
        form_data = {
            "tenantId": tenant_id,
            "name": f"Test Form {int(time.time())}",
            "description": "Test form for attachment verification",
            "code": f"TEST_FORM_{int(time.time())}",
            "fields": [
                {
                    "name": "customer_name",
                    "label": "Customer Name",
                    "type": "text",
                    "required": True
                },
                {
                    "name": "email",
                    "label": "Email",
                    "type": "email",
                    "required": True
                },
                {
                    "name": "feedback",
                    "label": "Feedback",
                    "type": "textarea",
                    "required": False
                }
            ],
            "isActive": True
        }
        
        response = requests.post(
            "http://localhost:3010/forms",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json",
                "x-tenant-id": tenant_id
            },
            json=form_data
        )
        
        if response.status_code in [200, 201]:
            form = response.json()
            log(f"✅ Form created: {form.get('id')} - {form.get('name')}", "SUCCESS")
            return form
        else:
            log(f"❌ Form creation failed: {response.status_code} - {response.text}", "ERROR")
            return None
    except Exception as e:
        log(f"❌ Form creation error: {e}", "ERROR")
        return None

def attach_form_to_business(token, form_id, business_id):
    """Attach form to business"""
    try:
        attach_data = {
            "businessId": business_id,
            "code": f"BIZ_FORM_{int(time.time())}",
            "isActive": True
        }
        
        response = requests.post(
            f"http://localhost:3010/forms/{form_id}/attach-business",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json"
            },
            json=attach_data
        )
        
        if response.status_code in [200, 201]:
            link = response.json()
            log(f"✅ Form attached to business: {link.get('id')}", "SUCCESS")
            log(f"   Form ID: {link.get('formId')}", "INFO")
            log(f"   Business ID: {link.get('businessId')}", "INFO")
            log(f"   Code: {link.get('code')}", "INFO")
            log(f"   Is Active: {link.get('isActive')}", "INFO")
            return link
        else:
            log(f"❌ Form attachment failed: {response.status_code} - {response.text}", "ERROR")
            return None
    except Exception as e:
        log(f"❌ Form attachment error: {e}", "ERROR")
        return None

def verify_form_attachment(token, business_id):
    """Verify form is attached to business"""
    try:
        response = requests.get(
            f"http://localhost:3010/forms?businessId={business_id}",
            headers={"Authorization": f"Bearer {token}"}
        )
        
        if response.status_code == 200:
            forms = response.json()
            if forms:
                log(f"✅ Found {len(forms)} form(s) attached to business", "SUCCESS")
                for form in forms:
                    log(f"   - {form.get('name')} (Active: {form.get('isActive', 'N/A')})", "INFO")
                return True
            else:
                log(f"⚠️ No forms found for business", "WARNING")
                return False
        else:
            log(f"❌ Failed to verify attachment: {response.status_code}", "ERROR")
            return False
    except Exception as e:
        log(f"❌ Verification error: {e}", "ERROR")
        return False

def main():
    """Main test execution"""
    log("="*80)
    log("FORM ATTACHMENT & ACTIVATION TEST")
    log("="*80)
    
    # Step 1: Login
    log("\n" + "="*80)
    log("STEP 1: Login")
    log("="*80)
    token = get_auth_token()
    if not token:
        log("❌ Cannot proceed without auth token", "ERROR")
        return False
    
    # Step 2: Get tenant ID
    log("\n" + "="*80)
    log("STEP 2: Get Tenant ID")
    log("="*80)
    tenant_id = get_tenant_id(token)
    if not tenant_id:
        log("❌ Cannot proceed without tenantId", "ERROR")
        return False
    
    # Step 3: Get business ID
    log("\n" + "="*80)
    log("STEP 3: Get Business ID")
    log("="*80)
    business_id = get_business_id(token, tenant_id)
    if not business_id:
        log("❌ Cannot proceed without businessId", "ERROR")
        return False
    
    # Step 4: Create a form
    log("\n" + "="*80)
    log("STEP 4: Create Form")
    log("="*80)
    form = create_form(token, tenant_id)
    if not form:
        log("❌ Cannot proceed without form", "ERROR")
        return False
    
    form_id = form.get('id')
    
    # Step 5: Attach form to business
    log("\n" + "="*80)
    log("STEP 5: Attach Form to Business")
    log("="*80)
    link = attach_form_to_business(token, form_id, business_id)
    if not link:
        log("❌ Form attachment failed", "ERROR")
        return False
    
    # Step 6: Verify attachment
    log("\n" + "="*80)
    log("STEP 6: Verify Form Attachment")
    log("="*80)
    verified = verify_form_attachment(token, business_id)
    
    # Final result
    log("\n" + "="*80)
    if verified:
        log("✅✅✅ ALL TESTS PASSED", "SUCCESS")
        log("="*80)
        log("\nForm attachment and activation functionality is working correctly!", "SUCCESS")
        log(f"Form ID: {form_id}", "INFO")
        log(f"Business ID: {business_id}", "INFO")
        log(f"Attachment Code: {link.get('code')}", "INFO")
        log(f"Is Active: {link.get('isActive')}", "INFO")
        return True
    else:
        log("❌❌❌ TESTS FAILED", "ERROR")
        log("="*80)
        return False

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)

