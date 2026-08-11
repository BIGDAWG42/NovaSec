# NovaSec 0.1

NovaSec is a lightweight **Kali Linux Rolling** live image for 64-bit Intel/AMD PCs. It uses Kali's official `kali-live` repository and live-build wrapper, starts from Kali's `xfce-light` variant, and adds a focused set of networking and security tools.

It is intended to boot from USB without installing Linux on the computer's internal drive. Only use security tools on systems you own or are explicitly authorized to test.

## Build with GitHub Actions

1. Extract this ZIP.
2. Create an empty GitHub repository.
3. Upload **all extracted files and folders**, including `.github`, to the repository root. GitHub does not extract a ZIP uploaded as a single file.
4. Open **Actions**, select **Build NovaSec Kali Live ISO**, and choose **Run workflow**.
5. When the job finishes, download the `NovaSec-0.1-amd64` artifact.

The artifact contains the ISO, its SHA-256 checksum, and Kali live-build's log. The cloud runner uses the official `kalilinux/kali-rolling` container in privileged mode because live-build needs mount capabilities and Kali's current patched live-build package.

## Repository layout

```text
.github/workflows/build.yml                     GitHub cloud build
build.sh                                       NovaSec build wrapper
config/variant-novasec/package-lists/...       Explicit package selection
config/common/includes.chroot/...              Files added to the live system
outputs/                                       Generated ISO, checksum, and log
```

## Local build (optional)

The supported route for this project is GitHub Actions. On an existing Kali Rolling machine, install `git live-build cdebootstrap curl ca-certificates`, then run:

```bash
sudo ./build.sh
```

The expected image is `outputs/NovaSec-0.1-amd64.iso`.

## Notes

- Architecture: `amd64` (correct for modern 64-bit Intel and AMD PCs)
- Distribution: `kali-rolling`
- Desktop: Xfce
- Image type: hybrid live ISO for USB/DVD boot
- Persistence is not pre-created inside the ISO; it can be added when preparing the USB.
- Kali Rolling changes over time, so the same source may contain newer packages when rebuilt later.

