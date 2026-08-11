# NovaSec

Lightweight Debian/Kali-style live security workstation designed for an 8 GB USB.

## Build
Use the GitHub Actions workflow: Actions -> Build NovaSec ISO -> Run workflow.

The workflow builds the image in the cloud and uploads the resulting ISO as an artifact.

## Target
- amd64 / x86-64 (works on modern Intel and AMD CPUs)
- XFCE desktop
- UEFI + BIOS boot where supported by live-build
- Small hand-picked toolset

Use security tools only on systems and networks you own or have explicit permission to test.
