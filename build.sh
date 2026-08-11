#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
UPSTREAM_DIR="$PROJECT_DIR/.build/kali-live"
OUTPUT_DIR="$PROJECT_DIR/outputs"
VERSION="${NOVASEC_VERSION:-0.1}"
UPSTREAM_REF="${KALI_LIVE_REF:-main}"
FINAL_ISO="$OUTPUT_DIR/NovaSec-${VERSION}-amd64.iso"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: run this script as root, or use the supplied GitHub Actions workflow." >&2
  exit 1
fi

for command in git lb cdebootstrap curl; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "ERROR: required command is missing: $command" >&2
    exit 1
  fi
done

case "$PROJECT_DIR" in
  /|/root|/home|/usr|/var) echo "ERROR: unsafe project directory: $PROJECT_DIR" >&2; exit 1 ;;
esac

echo "NovaSec ${VERSION}: Kali Rolling amd64 live ISO"
rm -rf -- "$UPSTREAM_DIR"
mkdir -p -- "$PROJECT_DIR/.build" "$OUTPUT_DIR"
rm -f -- "$FINAL_ISO" "$OUTPUT_DIR/build.log"

git clone --depth 1 --branch "$UPSTREAM_REF" \
  https://gitlab.com/kalilinux/build-scripts/kali-live.git \
  "$UPSTREAM_DIR"

# Start from Kali's supported lightweight Xfce variant, then replace its
# package selection with NovaSec's explicit list.
cp -a -- "$UPSTREAM_DIR/kali-config/variant-xfce-light" \
  "$UPSTREAM_DIR/kali-config/variant-novasec"
cp -a -- "$PROJECT_DIR/config/variant-novasec/." \
  "$UPSTREAM_DIR/kali-config/variant-novasec/"
cp -a -- "$PROJECT_DIR/config/common/." \
  "$UPSTREAM_DIR/kali-config/common/"
chmod 0755 -- \
  "$UPSTREAM_DIR/kali-config/common/includes.chroot/usr/local/bin/novasec-info"

cd -- "$UPSTREAM_DIR"
./build.sh \
  --verbose \
  --distribution kali-rolling \
  --arch amd64 \
  --variant novasec \
  --version "$VERSION"

BUILT_ISO="$(./build.sh --distribution kali-rolling --arch amd64 --variant novasec --version "$VERSION" --get-image-path)"
if [[ ! -s "$BUILT_ISO" ]]; then
  echo "ERROR: expected ISO was not created: $BUILT_ISO" >&2
  exit 1
fi

install -m 0644 -- "$BUILT_ISO" "$FINAL_ISO"
install -m 0644 -- "${BUILT_ISO%.*}.log" "$OUTPUT_DIR/build.log"
echo "Build complete: $FINAL_ISO"
ls -lh -- "$FINAL_ISO"
