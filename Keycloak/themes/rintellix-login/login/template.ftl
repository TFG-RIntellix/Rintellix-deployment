<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html lang="${(locale.currentLanguageTag)!""}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Iniciar Sesión - FreeBank</title>
    
    <#-- Importando fuentes de Google -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Albert+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <#-- CSS Estático compilado con Tailwind -->
    <link href="${url.resourcesPath}/css/styles.css" rel="stylesheet" />
    
    <style>
        body { 
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; 
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body class="m-0 p-0 h-full w-full bg-slate-50">
    <#nested "form">
</body>
</html>
</#macro>
