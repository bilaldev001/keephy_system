# Questionnaire Forms Implementation - Testing Guide

## Overview

This guide provides step-by-step instructions for testing the complete questionnaire forms functionality, including:
- Form creation with short URL generation
- Linking forms to businesses/franchises
- Public form submissions with rate limiting
- Email notifications for form submissions

## Prerequisites

1. Backend services running (fbms-service and notifications-service)
2. Frontend application running (fbms)
3. Database migrations applied
4. Environment variables configured:
   - `APP_BASE_URL` - Base URL for short URLs (e.g., http://localhost:3000)
   - `NOTIFICATIONS_SERVICE_URL` - URL for notifications service (e.g., http://localhost:4005)
   - `SENDGRID_API_KEY` (optional) - SendGrid API key for email sending
   - `FROM_EMAIL` (optional) - From email address for notifications

## Test Scenarios

### 1. Form Creation with Short URL

**Endpoint:** `POST /fbms/forms`

**Test Data:**
```json
{
  "tenantId": "your-tenant-id",
  "userId": "your-user-id",
  "name": "Customer Satisfaction Survey",
  "description": "Help us improve our services",
  "questions": [
    {
      "questionLabel": "How satisfied are you with our service?",
      "isRequired": true,
      "questionType": "rating",
      "ratingData": {
        "minRating": 1,
        "maxRating": 5
      }
    },
    {
      "questionLabel": "What can we improve?",
      "isRequired": false,
      "questionType": "long-text"
    }
  ],
  "status": "active",
  "emailNotifications": true,
  "emailRecipients": {
    "formCreatorEmail": "creator@example.com",
    "customEmails": ["manager@example.com"]
  },
  "emailTemplate": "form_submission_notification"
}
```

**Expected Result:**
- Form created successfully
- `shortUrl` field populated (e.g., http://localhost:3000/f/AbC12345)
- Email configuration saved

**Verification Steps:**
1. Check the response includes a `shortUrl` field
2. Verify the short URL is unique (8 character code)
3. Confirm email settings are saved correctly

### 2. Link Form to Business

**Endpoint:** `POST /fbms/forms/:formId/attach-business`

**Test Data:**
```json
{
  "businessId": "business-uuid",
  "code": "ABC123",
  "isActive": true
}
```

**Expected Result:**
- Form successfully linked to business
- Code is unique and active
- Link record created in `form_business_links` table

### 3. Link Form to Franchise

**Endpoint:** `POST /fbms/forms/:formId/attach-franchise`

**Test Data:**
```json
{
  "franchiseId": "franchise-uuid",
  "code": "XYZ789",
  "isActive": true
}
```

**Expected Result:**
- Form successfully linked to franchise
- Code is unique and active
- Link record created in `form_franchise_links` table

### 4. Retrieve Public Form

**Endpoint:** `GET /fbms/public/forms/:code`

**Test Steps:**
1. Use the code from step 2 or 3
2. Make GET request without authentication
3. Verify form details are returned

**Expected Result:**
- Form data returned successfully
- Questions array populated
- Theme and configuration visible
- No sensitive data exposed (tenant IDs, etc.)

### 5. Public Form Submission (First Attempt)

**Endpoint:** `POST /fbms/public/forms/:code/submit`

**Test Data:**
```json
{
  "answers": [
    {
      "questionLabel": "How satisfied are you with our service?",
      "answer": "5",
      "type": "rating"
    },
    {
      "questionLabel": "What can we improve?",
      "answer": "Everything is great!",
      "type": "long-text"
    }
  ],
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "deviceId": "web-public"
}
```

**Expected Result:**
- Submission created successfully
- IP address and user agent captured
- Device type detected
- Email notifications queued/sent
- Response includes submission ID

**Verification Steps:**
1. Check `form_submissions` table for new record
2. Check `notifications` table for queued/sent notification
3. Verify email recipients received notifications (if SendGrid configured)
4. Confirm submission details in email match the data

### 6. Rate Limit Testing (Second Attempt - Same Day)

**Endpoint:** `POST /fbms/public/forms/:code/submit`

**Test Steps:**
1. Use the same IP address
2. Attempt to submit the same form again
3. Should be blocked by rate limiter

**Expected Result:**
- HTTP 429 (Too Many Requests) response
- Error message: "Rate limit exceeded. You can submit this form again after [timestamp]"
- Response includes `retryAfter` field (seconds until reset)

**Verification Steps:**
1. Confirm no new submission created in database
2. Verify rate limit message is clear and helpful
3. Check rate limit reset time is 24 hours from first submission

### 7. Email Notification Content

**Verification Steps:**
1. Open the email received from form submission
2. Verify email contains:
   - Form name
   - Submission timestamp
   - Submitter name, email, phone
   - Preview of first 3 answers
   - "View Full Submission" button/link
   - Submission ID
3. Click "View Full Submission" link
4. Verify it navigates to the correct submission detail page

### 8. Multiple Recipients

**Test Steps:**
1. Create a form with multiple email recipients:
   - Form creator email
   - 2-3 custom emails
2. Submit the form
3. Verify all recipients receive email

**Expected Result:**
- All configured recipients receive notification email
- Email content is identical for all recipients
- No duplicate emails sent to same address

### 9. Frontend Integration

**Test Steps:**
1. Navigate to form creation page
2. Create a new form
3. Enable email notifications
4. Add email recipients
5. Save form
6. Verify short URL is displayed
7. Click "Copy" button
8. Click "Open Form" button

**Expected Result:**
- Short URL displayed prominently
- Copy button successfully copies URL to clipboard
- Open Form button opens new tab with public form
- Email configuration UI is intuitive and functional

### 10. Public Form UI

**Test Steps:**
1. Open the short URL in incognito/private browser
2. Fill out the form
3. Submit the form
4. Verify success message

**Expected Result:**
- Form loads correctly
- All questions render properly
- Contact information fields present
- Required field validation works
- Submit button disabled while submitting
- Success message shown after submission
- Option to submit another response

## Database Verification

### Check Form Record
```sql
SELECT id, name, short_url, email_notifications, email_recipients, email_template
FROM forms
WHERE id = 'your-form-id';
```

### Check Form Links
```sql
SELECT * FROM form_business_links WHERE form_id = 'your-form-id';
SELECT * FROM form_franchise_links WHERE form_id = 'your-form-id';
```

### Check Submissions
```sql
SELECT id, form_id, name, email, ip_address, device_type, created_at
FROM form_submissions
WHERE form_id = 'your-form-id'
ORDER BY created_at DESC;
```

### Check Notifications
```sql
SELECT id, channel, template, status, sent_at, error
FROM notifications
WHERE reference_type = 'form_submission'
ORDER BY created_at DESC;
```

## API Testing with cURL

### Create Form
```bash
curl -X POST http://localhost:4000/fbms/forms \
  -H "Content-Type: application/json" \
  -H "x-tenant-id: your-tenant-id" \
  -d '{
    "tenantId": "your-tenant-id",
    "userId": "your-user-id",
    "name": "Test Form",
    "questions": [...],
    "status": "active",
    "emailNotifications": true,
    "emailRecipients": {
      "formCreatorEmail": "creator@example.com"
    }
  }'
```

### Get Public Form
```bash
curl -X GET http://localhost:4000/fbms/public/forms/ABC123
```

### Submit Form
```bash
curl -X POST http://localhost:4000/fbms/public/forms/ABC123/submit \
  -H "Content-Type: application/json" \
  -d '{
    "answers": [...],
    "name": "John Doe",
    "email": "john@example.com",
    "deviceId": "web-public"
  }'
```

## Common Issues and Troubleshooting

### Issue: Short URL not generated
**Solution:** 
- Check if migration was applied
- Verify `APP_BASE_URL` environment variable is set
- Check logs for ShortUrlService errors

### Issue: Email notifications not sent
**Solution:**
- Verify `NOTIFICATIONS_SERVICE_URL` is correct
- Check if notifications service is running
- Review notifications table for failed notifications
- Verify email recipients are configured

### Issue: Rate limit not working
**Solution:**
- Check if RateLimitGuard is applied to endpoint
- Verify IP address extraction is working
- Check rate limit store (in-memory Map)

### Issue: Public form 404
**Solution:**
- Verify form status is 'active'
- Check if form link is active
- Verify code matches database record

## Performance Testing

### Load Test Public Submission Endpoint
- Test 100 concurrent requests from different IPs
- Verify rate limiting works correctly
- Check response times stay under 500ms
- Ensure database handles concurrent writes

### Email Queue Performance
- Submit 50 forms rapidly
- Verify all notifications are queued
- Check email service doesn't block submission
- Confirm all emails eventually sent

## Security Testing

### Test Cases:
1. Submit form without required fields - should fail validation
2. Submit form with SQL injection attempts - should be sanitized
3. Submit form with XSS payloads - should be escaped
4. Access form with inactive code - should return 404
5. Exceed rate limit - should return 429
6. Submit to archived form - should be rejected

## Success Criteria

All tests pass when:
- ✅ Forms created successfully with unique short URLs
- ✅ Forms can be linked to businesses/franchises
- ✅ Public form accessible via short URL
- ✅ Form submissions work without authentication
- ✅ Rate limiting enforces 1 submission per day per IP
- ✅ Email notifications sent to all configured recipients
- ✅ Email content includes submission summary and view link
- ✅ Frontend displays short URL and email configuration
- ✅ Public form UI is responsive and user-friendly
- ✅ No security vulnerabilities detected

## Next Steps

After successful testing:
1. Deploy to staging environment
2. Conduct user acceptance testing
3. Update documentation
4. Train users on new features
5. Deploy to production

