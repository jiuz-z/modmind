@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

echo ========================================
echo   ModMind Sync and Release Script
echo ========================================
echo.

REM Check git
where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] git not found in PATH
    pause
    exit /b 1
)

REM Check upstream remote
git remote get-url upstream >nul 2>nul
if errorlevel 1 (
    echo [ERROR] upstream remote not configured
    echo Run: git remote add upstream https://github.com/waterpail114514/modmind.git
    pause
    exit /b 1
)

echo [1/6] Pulling latest from upstream...
git pull upstream main
if errorlevel 1 (
    echo.
    echo [ERROR] Merge conflict or pull failed.
    echo Please resolve conflicts manually, then run this script again.
    echo.
    git status
    pause
    exit /b 1
)

REM Check for merge conflicts
git status --porcelain | findstr /r "^UU ^AA ^DD" >nul 2>nul
if not errorlevel 1 (
    echo.
    echo [ERROR] Merge conflicts detected.
    echo Please resolve them manually, then run this script again.
    pause
    exit /b 1
)

echo.
echo [2/6] Running typecheck...
call npm run typecheck
if errorlevel 1 (
    echo.
    echo [ERROR] Typecheck failed. Please fix errors before continuing.
    pause
    exit /b 1
)

echo.
echo [3/6] Running tests...
call npm test
if errorlevel 1 (
    echo.
    echo [ERROR] Tests failed. Please fix before continuing.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Build and tests PASSED
echo ========================================
echo.
echo Now please test the app manually:
echo   1. Run: npm run dev  (or double-click 启动开发模式.bat)
echo   2. Test: AI chat, custom API, build, MCP tools
echo   3. Confirm everything works
echo.
echo Press ANY key to continue and create release tag...
pause >nul

echo.
echo [4/6] Creating release tag...
for /f %%i in ('powershell -Command "Get-Date -Format 'yyyyMMdd'"') do set TODAY=%%i
set TAG=stable-1.4.4-custom-%TODAY%
echo Tag name: %TAG%
git tag "%TAG%"
if errorlevel 1 (
    echo [ERROR] Failed to create tag (may already exist)
    pause
    exit /b 1
)

echo.
echo [5/6] Pushing code to origin/main...
git push origin master:main
if errorlevel 1 (
    echo [ERROR] Failed to push code
    pause
    exit /b 1
)

echo.
echo [6/6] Pushing tag to origin...
git push origin "%TAG%"
if errorlevel 1 (
    echo [ERROR] Failed to push tag
    pause
    exit /b 1
)

echo.
echo ========================================
echo   DONE
echo ========================================
echo.
echo Released: %TAG%
echo Remote: https://github.com/jiuz-z/modmind
echo.
echo Press any key to close...
pause >nul
