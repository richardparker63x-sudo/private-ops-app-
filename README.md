# Private Ops — Android APK Builder

This repository contains the Flutter source supplied to you and a GitHub Actions workflow that builds an Android APK in the cloud. You do not need to install Flutter on your phone.

## Important
- This ZIP is **source code plus an automated build workflow**, not the APK itself.
- The first build runs when you push the files to the `main` branch. You can also run it manually from the Actions tab.
- Review the app and its permissions before installing or sharing the APK.

## Phone-only route (GitHub)
1. On your phone, open GitHub in Chrome and sign in or create an account.
2. Create a **new public or private repository** named `private-ops-app`; initialize it with a README if you want.
3. Extract this ZIP using your phone's Files app. You need to upload the contents of this folder, including the hidden `.github/workflows/build-apk.yml` file. Some mobile file pickers hide dot-folders, so the easiest route is to use GitHub Codespaces or a browser-based editor that supports uploading/extracting a ZIP and committing files.
4. Commit the files to the repository's `main` branch.
5. Open the repository's **Actions** tab. Select **Build Android APK** and tap **Run workflow** if it has not already started.
6. Wait for the run to finish with a green check. Open the completed run, find **Artifacts**, and download `private-ops-android-apk`.
7. Extract the downloaded artifact ZIP. Install `app-release.apk`. Android may ask you to allow installation from that browser or file manager; only allow it if you trust the source.

## If the build fails
Open the failed workflow run and inspect the first red step. Share the error log to get help fixing it.
