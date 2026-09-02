@echo off
cd /d "%~dp0"
echo ========================================
echo   ModMind Dev Mode Launcher
echo ========================================
echo.
echo Project: %cd%
echo.
echo Starting... close this window to stop.
echo.
npm run dev
echo.
echo ========================================
echo   App stopped. Press any key to close.
echo ========================================
pause >nul
