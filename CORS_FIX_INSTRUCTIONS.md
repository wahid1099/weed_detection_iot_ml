# 🔧 How to Fix CORS Issue for Your Flutter App

## Problem

Your Flutter web app can't access the API due to CORS (Cross-Origin Resource Sharing) restrictions.

## Solution Options

### Option 1: Fix Backend CORS (Recommended)

Add CORS headers to your Vercel backend API:

```javascript
// In your API route file (e.g., api/sensors/history.js)
export default function handler(req, res) {
  // Add CORS headers
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, DELETE, OPTIONS"
  );
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

  // Handle preflight requests
  if (req.method === "OPTIONS") {
    res.status(200).end();
    return;
  }

  // Your existing API logic here
  // ... rest of your code
}
```

### Option 2: Use Vercel CORS Configuration

Create a `vercel.json` file in your backend root:

```json
{
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        { "key": "Access-Control-Allow-Origin", "value": "*" },
        {
          "key": "Access-Control-Allow-Methods",
          "value": "GET, POST, PUT, DELETE, OPTIONS"
        },
        {
          "key": "Access-Control-Allow-Headers",
          "value": "Content-Type, Authorization"
        }
      ]
    }
  ]
}
```

### Option 3: Test on Mobile/Desktop

The CORS issue only affects web browsers. Test your app on:

- Android emulator/device
- iOS simulator/device
- Desktop (Windows/macOS/Linux)

## Current Workaround

The app now includes mock data when the API is not accessible, so you can:

1. ✅ See the UI working with sample data
2. ✅ Test all features
3. ✅ Use the "Test API Connection" button to check status

## Verification Steps

1. Apply one of the CORS fixes above
2. Redeploy your backend
3. Use the "Test API Connection" button in the app
4. Check for "✅ API Connected Successfully" message

## Mock Data Info

When CORS blocks the API, the app shows:

- Temperature: 32.3°C
- Humidity: 71.5%
- Soil Moisture: Wet
- pH Level: 7.2
- Farm: DIU_FIRM

This lets you develop and test the UI while fixing the backend issue.
