<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "form">
        <div class="min-h-screen w-full flex flex-col items-center justify-center bg-slate-50 relative overflow-hidden font-sans">
            
            <#-- Background Pattern -->
            <div
                class="absolute inset-0 z-0 opacity-[0.03]"
                style="background-image: radial-gradient(#2563eb 1px, transparent 1px); background-size: 32px 32px;"
            ></div>

            <div class="z-10 w-full max-w-md px-4">
                <#-- Logo and Header Section -->
                <div class="flex flex-col items-center mb-8">
                    <div class="h-16 w-16 bg-[rgb(243,0,5)] rounded-xl flex items-center justify-center mb-[16px] shadow-lg shadow-red-200 p-[0px] mt-[30px] mr-[0px] ml-[0px]">
                        <#-- Lucide Layers Icon -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                            <polyline points="2 12 12 17 22 12"></polyline>
                            <polyline points="2 17 12 22 22 17"></polyline>
                        </svg>
                    </div>
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight">FreeBank</h1>
                    <h2 class="text-lg font-medium text-[rgb(243,0,5)]">RIntellix</h2>
                    <p class="text-sm text-slate-500 mt-2">Sistema de Análisis de Riesgo Financiero</p>
                </div>

                <#-- Login Card -->
                <div class="rounded-xl border border-slate-200 bg-white text-slate-950 shadow-xl shadow-slate-200/50">
                    <div class="flex flex-col space-y-1.5 p-6 text-center pb-2">
                        <h3 class="text-xl text-[rgb(243,0,5)] font-[Albert_Sans] font-semibold leading-none tracking-tight">
                            Iniciar Sesión
                        </h3>
                        <p class="text-sm text-slate-500">
                            Ingrese sus credenciales para acceder
                        </p>
                    </div>
                    
                    <div class="p-6 pt-4 space-y-4">
                        <#-- KEYCLOAK FORM -->
                        <form id="kc-form-login" class="space-y-4" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                            
                            <#-- Username Input -->
                            <div class="space-y-2">
                                <label for="username" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 text-slate-700">
                                    <#if !realm.loginWithEmailAllowed>Usuario<#elseif !realm.registrationEmailAsUsername>Usuario o Email<#else>Email</#if>
                                </label>
                                <div class="relative">
                                    <#-- Lucide User Icon -->
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-3 top-3 text-slate-400">
                                        <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                    <input 
                                        tabindex="1"
                                        id="username" 
                                        name="username" 
                                        value="${(login.username!'')}"
                                        type="text" 
                                        autofocus 
                                        autocomplete="off"
                                        class="flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm ring-offset-white file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-slate-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-950 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 pl-9"
                                        placeholder="Ingrese su usuario" 
                                    />
                                </div>
                            </div>

                            <#-- Password Input -->
                            <div class="space-y-2">
                                <label for="password" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 text-slate-700">Contraseña</label>
                                <div class="relative">
                                    <#-- Lucide Lock Icon -->
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-3 top-3 text-slate-400">
                                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                    <input 
                                        tabindex="2"
                                        id="password" 
                                        name="password" 
                                        type="password" 
                                        autocomplete="off"
                                        class="flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm ring-offset-white file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-slate-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-950 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 pl-9"
                                        placeholder="Ingrese su contraseña"
                                    />
                                </div>
                            </div>
                            
                            <#-- Manejo de errores de Keycloak -->
                            <#if messagesPerField.existsError('username','password')>
                                <span class="text-sm text-red-500 mt-2 block" aria-live="polite">
                                    ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                </span>
                            </#if>

                            <#-- Botón Submit -->
                            <div class="flex items-center pt-2 mt-4">
                                <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                                <button 
                                    tabindex="4" 
                                    type="submit" 
                                    name="login" 
                                    id="kc-login" 
                                    class="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-white transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-950 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 w-full bg-[rgb(243,0,5)] hover:bg-red-700 text-white h-11 text-base shadow-md shadow-red-200 cursor-pointer"
                                >
                                    Entrar al Sistema
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <#-- Footer Section -->
                <div class="mt-8 text-center text-xs text-slate-400">
                    <p>© 2025 FreeBank. Todos los derechos reservados.</p>
                    <p class="mt-1">Plataforma segura v2.4.0</p>
                </div>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
