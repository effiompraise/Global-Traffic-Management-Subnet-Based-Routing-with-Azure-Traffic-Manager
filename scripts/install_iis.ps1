# Install IIS Web Server
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Remove default IIS welcome page
Remove-Item C:\inetpub\wwwroot\iisstart.htm

# Create custom index page displaying the VM Name
# This helps verify which region serves the traffic
$Content = @"
<!DOCTYPE html>
<html>
<head>
    <title>Azure Traffic Manager Demo</title>
    <style>
        body { font-family: sans-serif; text-align: center; padding-top: 50px; background-color: #f0f2f5; }
        .card { background: white; padding: 40px; border-radius: 10px; display: inline-block; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        h1 { color: #0078D4; }
        .region { font-size: 24px; font-weight: bold; color: #333; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Traffic Manager Endpoint</h1>
        <p>Response served by:</p>
        <div class="region">$($env:computername)</div>
    </div>
</body>
</html>
"@

Add-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $Content