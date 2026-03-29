@echo off
echo ============================================
echo  STUDIER CLEANUP + DEPLOYMENT SCRIPT
echo ============================================
echo.

cd /d "%~dp0"

echo [1/7] Removing Expo/React Native files...
echo ----------------------------------------

REM Delete Expo root files
if exist "App.js" del /q "App.js"
if exist "babel.config.js" del /q "babel.config.js"
if exist "tsconfig.json" del /q "tsconfig.json"
if exist "package.json" del /q "package.json"
if exist "package-lock.json" del /q "package-lock.json"
if exist "setup-project.ps1" del /q "setup-project.ps1"

REM Delete Expo directories
if exist "src" rmdir /s /q "src"
if exist "studier" rmdir /s /q "studier"
if exist "node_modules" rmdir /s /q "node_modules"
if exist ".expo" rmdir /s /q ".expo"
if exist "public" rmdir /s /q "public"
if exist "assets" rmdir /s /q "assets"
if exist ".azure" rmdir /s /q ".azure"

echo Expo files removed.
echo.

echo [2/7] Checking git status...
echo ----------------------------------------
git status
echo.

echo [3/7] Staging all changes...
echo ----------------------------------------
git add -A
echo Done.
echo.

echo [4/7] Committing cleanup + security fixes...
echo ----------------------------------------
git commit -m "chore: remove Expo/React Native code, keep Flutter only" -m "" -m "BREAKING CHANGE: Project is now Flutter-only" -m "" -m "- Remove src/ (React Native prototype)" -m "- Remove studier/ (Expo Router template)" -m "- Remove root Expo config files" -m "- Update README for Flutter project" -m "- Update .gitignore for Flutter-only" -m "" -m "Security fixes included:" -m "- Remove hardcoded passwords from mock_data.dart" -m "- Remove password field from AppUser model" -m "- Harden Firestore and Storage rules" -m "- Add Firebase config to .gitignore" -m "- Enforce HTTPS for image URLs" -m "" -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
echo.

echo [5/7] Pushing to GitHub...
echo ----------------------------------------
git push origin main
echo.

echo [6/7] Deploying Firebase security rules...
echo ----------------------------------------
cd studier_flutter
firebase deploy --only firestore:rules,storage
cd ..
echo.

echo ============================================
echo  ALL DONE!
echo ============================================
echo.
echo Summary:
echo  - Expo/React Native files removed
echo  - Security fixes committed
echo  - Pushed to GitHub
echo  - Firebase rules deployed
echo.
echo IMPORTANT: Regenerate Firebase API keys!
echo https://console.firebase.google.com/project/studier-78f4d/settings/general
echo.
pause
