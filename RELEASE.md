# Release Guide (Internal)

## Overview

La remise se fait via la section **Release** de GitLab, liée à un **tag** Git.

---

## Step 1: Build All Executables

Refer to `BUILD.md` in each folder:

| Project      | Instructions            | Output                                          |
| ------------ | ----------------------- | ----------------------------------------------- |
| Client Lourd | `client/BUILD.md`       | `build/client-win32-x64/`                       |
| Client Léger | `client_leger/BUILD.md` | `build/app/outputs/flutter-apk/app-release.apk` |
| Serveur      | `server/BUILD.md`       | Zip source folder                               |

---

## Test Release (Demo)

For testing the release process (e.g., demo1):

```bash
git tag -a demo1 -m "Demo 1 test release"
git push origin demo1
```

Then create a release on GitLab with tag `demo1` and upload your zips to test.

---

## Step 2: Create Git Tag (Final Release)

```bash
git add .
git commit -m "Release finale"
git tag -a v1.0.0 -m "Release Sprint X"
git push origin main
git push origin v1.0.0
```

⚠️ **Important**: Build all executables AFTER creating the tag.

---

## Step 3: Create GitLab Release

1. Go to GitLab → **Deploy** → **Releases**
2. Click **New Release**
3. Select your tag (`v1.0.0`)
4. Add release notes
5. Upload files:
    - `ClientLourd.zip` → Zip of `build/client-win32-x64/`
    - `ClientLeger.zip` → Zip containing APK (or just the APK)
    - `Serveur.zip` → Zip of `server/` (exclude `node_modules/` and `out/`)

---
