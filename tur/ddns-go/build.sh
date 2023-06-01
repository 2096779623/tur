TERMUX_PKG_HOMEPAGE=https://github.com/jeessy2/ddns-go
TERMUX_PKG_DESCRIPTION="Simple and easy-to-use DDNS"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION="5.3.1"
TERMUX_PKG_SRCURL=https://github.com/jeessy2/ddns-go/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=afca100b1b2d2b5bdcb0f6d061709136a567978e9cca85b9c0867d9219ead3f5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	LDFLAGS+=" -llog"
	go mod init || :
	go mod tidy
}

termux_step_make() {
	local _date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
	ldflags="\
	-X 'main.buildTime=$_date' \
	-X 'main.version=v${TERMUX_PKG_VERSION}' \
        -extldflags -static -s -w \
	"
	go build -trimpath -o "$TERMUX_PKG_SRCDIR"/ddns-go -ldflags="$ldflags"
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/ddns-go
}
