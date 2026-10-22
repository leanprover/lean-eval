#!/usr/bin/env bash
# Build bubblewrap from the pinned upstream release tarball, in the trusted phase, and
# print the path of the resulting binary. Palomar binds into candidate-written trees on
# every phase after the first, which is the pattern GHSA-pxhw-h44j-8pfx (fixed in 0.12.0)
# concerns, so the distribution's older package is not used.
#
# On kernels where unprivileged user namespaces are AppArmor-restricted (Ubuntu 24.04:
# kernel.apparmor_restrict_unprivileged_userns=1) a profile naming this binary is loaded;
# it grants nothing but the `userns` permission, and only to this path.
set -euo pipefail

BWRAP_VERSION="0.12.0"
BWRAP_SHA256="9760d007363e3abba7c747489910f9f82d9fca53ba3bd3282e396fa3c97a3314"
PREFIX="${1:?usage: install_bwrap.sh <install-dir>}"
case "$PREFIX" in
  /*) ;;
  *) echo "install_bwrap: the install directory must be an absolute path" >&2; exit 2 ;;
esac
if [[ "$PREFIX" =~ [[:space:]] ]]; then
  # The path is written into an AppArmor profile attachment, where a space
  # would need quoting that the profile syntax and this script do not share.
  echo "install_bwrap: the install directory must not contain whitespace" >&2
  exit 2
fi

mkdir -p "$PREFIX"
PREFIX="$(cd "$PREFIX" && pwd -P)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
curl --fail --location --silent --show-error --proto '=https' --tlsv1.2 \
  --output "$work/bubblewrap.tar.xz" \
  "https://github.com/containers/bubblewrap/releases/download/v${BWRAP_VERSION}/bubblewrap-${BWRAP_VERSION}.tar.xz"
echo "${BWRAP_SHA256}  $work/bubblewrap.tar.xz" | sha256sum --check --quiet
tar -xJf "$work/bubblewrap.tar.xz" -C "$work"
(
  cd "$work/bubblewrap-${BWRAP_VERSION}"
  meson setup build -Dselinux=disabled -Dman=disabled -Dbash_completion=disabled \
    -Dzsh_completion=disabled -Dtests=false >/dev/null
  ninja -C build >/dev/null
)
install -m 0755 "$work/bubblewrap-${BWRAP_VERSION}/build/bwrap" "$PREFIX/bwrap"

if [ "$(sysctl -n kernel.apparmor_restrict_unprivileged_userns 2>/dev/null || echo 0)" = 1 ]; then
  if ! command -v apparmor_parser >/dev/null; then
    echo "install_bwrap: user namespaces are AppArmor-restricted and apparmor_parser is missing" >&2
    exit 1
  fi
  profile="/etc/apparmor.d/palomar-bwrap"
  printf '%s\n' 'abi <abi/4.0>,' 'include <tunables/global>' \
    "profile palomar-bwrap $PREFIX/bwrap flags=(unconfined) {" '  userns,' '}' \
    | sudo tee "$profile" >/dev/null
  sudo apparmor_parser -r "$profile"
fi
"$PREFIX/bwrap" --version >&2
echo "$PREFIX/bwrap"
